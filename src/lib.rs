mod sam;
// -pitch number        set pitch value (default=64)
// -speed number        set speed value (default=72)
// -throat number        set throat value (default=128)
// -mouth number        set mouth value (default=128)
use sam::*;

#[repr(C)]
pub struct SpeakBuffer {
    pub size: i32,
    pub ptr: *mut i8,
}

pub extern "C" fn speak_message(pitch: u8,speed: u8,mouth: u8,throat: u8, text: *mut i8) -> SpeakBuffer {
    unsafe {
        SetPitch(if pitch==0 {64} else {pitch});
        SetSpeed(if speed==0 {72} else {speed});
        SetThroat(if throat==0 {128} else {throat});
        SetMouth(if mouth==0 {128} else {mouth});
        SetInput(text);
        SAMMain();
        return SpeakBuffer {size: GetBufferLength(),ptr: GetBuffer()}
    }
}