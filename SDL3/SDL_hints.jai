
HINT_ORIENTATIONS :: "SDL_ORIENTATIONS";

set_hint :: (name : *u8, value : *u8) -> bool #foreign SDL3 "SDL_SetHint";
