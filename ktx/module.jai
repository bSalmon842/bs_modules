// Bindings to Khrono's KTX-Software/libktx for reading and writing ktx/ktx2 texture files.
//
// The Vulkan bindings used here can be found at https://gitlab.com/Stowy/jai-vulkan,
// but this also works with the Vulkan ones that come with the compiler.

#load "helpers.jai";

#if OS == .WINDOWS {
    #load "ktx_windows.jai";
    #scope_module
    FILE :: void;
} else #if OS == .LINUX {
    #import "POSIX";
    #load "ktx_linux.jai";
} else #if OS == .ANDROID {
    #import "POSIX";
    #load "ktx_android.jai";
    #scope_module
    FILE :: void;
} else {
    #assert false  "Unsupported OS";
}

#scope_export

// Exported Constants

KTX_ETC1S_DEFAULT_COMPRESSION_LEVEL: ktx_uint32_t : 2;
