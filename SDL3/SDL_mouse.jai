Mouse_ID :: u32;
Cursor   :: void;


System_Cursor :: enum u32
{
    SYSTEM_CURSOR_DEFAULT;
    SYSTEM_CURSOR_TEXT;
    SYSTEM_CURSOR_WAIT;
    SYSTEM_CURSOR_CROSSHAIR;
    SYSTEM_CURSOR_PROGRESS;
    SYSTEM_CURSOR_NWSE_RESIZE;
    SYSTEM_CURSOR_NESW_RESIZE;
    SYSTEM_CURSOR_EW_RESIZE;
    SYSTEM_CURSOR_NS_RESIZE;
    SYSTEM_CURSOR_MOVE;
    SYSTEM_CURSOR_NOT_ALLOWED;
    SYSTEM_CURSOR_POINTER;
    SYSTEM_CURSOR_NW_RESIZE;
    SYSTEM_CURSOR_N_RESIZE;
    SYSTEM_CURSOR_NE_RESIZE;
    SYSTEM_CURSOR_E_RESIZE;
    SYSTEM_CURSOR_SE_RESIZE;
    SYSTEM_CURSOR_S_RESIZE;
    SYSTEM_CURSOR_SW_RESIZE;
    SYSTEM_CURSOR_W_RESIZE;
    SYSTEM_CURSOR_COUNT;
}

Mouse_Wheel_Direction :: enum u32
{
    NORMAL;
    FLIPPED;
}

BUTTON_LEFT     :: 1;
BUTTON_MIDDLE   :: 2;
BUTTON_RIGHT    :: 3;
BUTTON_X1       :: 4;
BUTTON_X2       :: 5;

BUTTON_MASK     :: (x: s32) -> s32 {return (xx 1 << (x-1));}

Mouse_Button_Flags :: enum_flags u32
{
    BUTTON_LMASK    :: #run BUTTON_MASK(BUTTON_LEFT);
    BUTTON_MMASK    :: #run BUTTON_MASK(BUTTON_MIDDLE);
    BUTTON_RMASK    :: #run BUTTON_MASK(BUTTON_RIGHT);
    BUTTON_X1MASK   :: #run BUTTON_MASK(BUTTON_X1);
    BUTTON_X2MASK   :: #run BUTTON_MASK(BUTTON_X2);
}


has_mouse                      :: () -> bool                                                                #foreign SDL3 "SDL_HasMouse";
get_mice                       :: (count: *s32) -> Mouse_ID                                                 #foreign SDL3 "SDL_GetMice";
get_mouse_name_for_id          :: (instance_id: Mouse_ID) -> *u8                                            #foreign SDL3 "SDL_GetMouseNameForID";
get_mouse_focus                :: () -> *Window                                                             #foreign SDL3 "SDL_GetMouseFocus";
get_mouse_state                :: (x: *float32, y: *float32) -> Mouse_Button_Flags                          #foreign SDL3 "SDL_GetMouseState";
get_global_mouse_state         :: (x: *float32, y: *float32) -> Mouse_Button_Flags                          #foreign SDL3 "SDL_GetGlobalMouseState";
get_relative_mouse_state       :: (x: *float32, y: *float32) -> Mouse_Button_Flags                          #foreign SDL3 "SDL_GetRelativeMouseState";
warp_mouse_in_window           :: (window: *Window, x: float32, y: float32)                                 #foreign SDL3 "SDL_WarpMouseInWindow";
warp_mouse_global              :: (x: float32, y: float32) -> bool                                          #foreign SDL3 "SDL_WarpMouseGlobal";
set_window_relative_mouse_mode :: (window: *Window, enabled: bool) -> bool                                  #foreign SDL3 "SDL_SetWindowRelativeMouseMode";
get_window_relative_mouse_mode :: (window: *Window) -> bool                                                 #foreign SDL3 "SDL_GetWindowRelativeMouseMode";
capture_mouse                  :: (enabled: bool) -> bool                                                   #foreign SDL3 "SDL_CaptureMouse";
create_cursor                  :: (data: *u8, mask: *u8, w: s32, h: s32, hot_x: s32, hot_y: s32) -> *Cursor #foreign SDL3 "SDL_CreateCursor";
create_color_cursor            :: (surface: *Surface, hot_x: s32, hot_y: s32) -> *Cursor                    #foreign SDL3 "SDL_CreateColorCursor";
create_system_cursor           :: (id: System_Cursor) -> *Cursor                                             #foreign SDL3 "SDL_CreateSystemCursor";
set_cursor                     :: (cursor: *Cursor) -> bool                                                 #foreign SDL3 "SDL_SetCursor";
get_cursor                     :: () -> *Cursor                                                             #foreign SDL3 "SDL_GetCursor";
get_default_cursor             :: () -> *Cursor                                                             #foreign SDL3 "SDL_GetDefaultCursor";
destroy_cursor                 :: (cursor: *Cursor)                                                         #foreign SDL3 "SDL_DestroyCursor";
show_cursor                    :: () -> bool                                                                #foreign SDL3 "SDL_ShowCursor";
hide_cursor                    :: () -> bool                                                                #foreign SDL3 "SDL_HideCursor";
cursor_visible                 :: () -> bool                                                                #foreign SDL3 "SDL_CursorVisible";
