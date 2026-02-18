#load "SDL_image.jai";

#scope_export

#if OS == .LINUX
{
    X11 :: #import "X11";
    SDL3_image :: #library "linux/libSDL3_image";
    #library,system,link_always "libdl";
    #library,system,link_always "libm";
    #library,system,link_always "libpthread";
}

main :: () {}

// Local Variables:
// compile-command: "jai module.jai"
// End:
