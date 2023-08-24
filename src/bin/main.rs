use std::ffi::CString;

#[path ="../lib.rs"]
mod lib;

fn main() {
    let string = CString::new("Hello from a FFI function").unwrap();
    let lib::SpeakBuffer {size: buffer_size, ptr: buffer} = lib::speak_message(0, 0, 0, 0, string.into_raw());
    let buf = unsafe {std::slice::from_raw_parts(buffer, buffer_size as usize)};
    
}