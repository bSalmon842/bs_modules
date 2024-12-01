#if OS == .WINDOWS {
    #load "modified_generated_windows.jai";
} else #if OS == .LINUX {
    #load "modified_generated_linux.jai";
}