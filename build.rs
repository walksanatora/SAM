extern crate bindgen;

use std::env;
use std::path::PathBuf;
use std::process::Command;

use bindgen::CargoCallbacks;

static SRCDIR: &str = "sam";
static OUTDIR: &str = "target/c";
static _LIBS: [&str;5] = ["reciter.o", "sam.o", "render.o", "lib.o", "debug.o"]; 

fn main() {
    println!("cargo:rerun-if-changed=sam/*");
    let builder = cc::Build::new();
    let gcc = builder.get_compiler();

    let mut libb = Command::new(gcc.path());
    libb.arg("-shared")
        .arg("-o").arg(format!("{OUTDIR}/libsam.so"));
    for lib in _LIBS {
        let out = Command::new(gcc.path())
            .arg("-c")
            .arg("-o")
            .arg(format!("{OUTDIR}/{}",lib))
            .arg(format!("{SRCDIR}/{}",lib.replace(".o",".c")))
            .arg("-Wall")
            .arg("-Os")
            .arg("-fPIC")
            .output()
            .expect("could not spawn c compiler");
        libb.arg(format!("{OUTDIR}/{lib}"));
        if !out.status.success(){
            // Panic if the command was not successful.
            panic!("could not run make to build library: {:?}",std::str::from_utf8(out.stderr.as_slice()));
        }
    }
    libb.arg("-Wl,-soname,libsam.so")
        .arg("-fPIC");
    let out = libb.output().expect("failed to build libary");
    if !out.status.success() {
        panic!("Failed to build library {:?}",std::str::from_utf8(out.stderr.as_slice()));
    }
    
    let libdir_path = PathBuf::from("target/c")
        .canonicalize()
        .expect("cannot canonicalize path");

    // Tell cargo to look for shared libraries in the specified directory
    println!("cargo:rustc-link-search={}", libdir_path.to_str().unwrap());

    // Tell cargo to tell rustc to link our `hello` library. Cargo will
    // automatically know it must look for a `libhello.a` file.
    println!("cargo:rustc-link-lib=libsam.so");

    // Run `clang` to compile the `hello.c` file into a `hello.o` object file.
    // Unwrap if it is not possible to spawn the process.
    //if !std::process::Command::new("make")
    //.arg("lib")
    //.arg("-j")
    //    .output()
    //    .expect("could not spawn `clang`")
    //    .status
    //    .success()
    //{
    //    // Panic if the command was not successful.
    //    panic!("could not run make to build library");
    //}

    // The bindgen::Builder is the main entry point
    // to bindgen, and lets you build up options for
    // the resulting bindings.
    // This is the path to the `c` headers file.
    let headers_path = PathBuf::from("sam/lib.h").canonicalize().unwrap();
    let headers_path_str = headers_path.to_str().expect("Path is not a valid string");
    
    let bindings = bindgen::Builder::default()
        .raw_line("#[allow(dead_code)]")
        // The input header we would like to generate
        // bindings for.
        .header(headers_path_str)
        // Tell cargo to invalidate the built crate whenever any of the
        // included header files changed.
        .parse_callbacks(Box::new(CargoCallbacks))
        // Finish the builder and generate the bindings.
        .generate()
        // Unwrap the Result and panic on failure.
        .expect("Unable to generate bindings");

    // Write the bindings to the $OUT_DIR/bindings.rs file.
    let out_path = PathBuf::from(env::var("OUT_DIR").unwrap()).join("bindings.rs");
    bindings
        .write_to_file(out_path)
        .expect("Couldn't write bindings!");
}
