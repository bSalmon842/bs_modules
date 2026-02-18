set_error     :: (fmt: *u8, args: ..Any) -> bool      #foreign SDL3 "SDL_SetError";
set_error_v   :: (fmt: *u8, args: [..]Any) -> bool    #foreign SDL3 "SDL_SetErrorV";
out_of_memory :: () -> bool                           #foreign SDL3 "SDL_OutOfMemory";
get_error     :: () -> *u8                            #foreign SDL3 "SDL_GetError";
clear_error   :: ()                                   #foreign SDL3 "SDL_ClearError";

unsupported         :: ()           {set_error("That operation is not supported");}
invalid_param_error :: (param: *u8) {set_error("Parameter '%s' is invalid", param);}
