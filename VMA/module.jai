#if OS == .WINDOWS {
    #load "generated_windows.jai";
} else #if OS == .LINUX || OS == .ANDROID {
    #load "generated_linux.jai";
}
