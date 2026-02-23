Properties_ID :: u32;

get_pointer_property :: (props : Properties_ID, name : *u8, default_value : *void) -> *void #foreign SDL3 "SDL_GetPointerProperty";

