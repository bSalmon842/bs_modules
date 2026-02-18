Display_ID :: u32;
Window_ID  :: u32;

System_Theme :: enum u32
{
    UNKNOWN;
    LIGHT;
    DARK;
}

Display_Mode_Data :: void;

Display_Mode :: struct
{
    display_id:               Display_ID;
    format:                   Pixel_Format;
    w:                        s32;
    h:                        s32;
    pixel_density:            float32;
    refresh_rate:             float32;
    refresh_rate_numerator:   s32;
    refresh_rate_denominator: s32;

    internal:                 *Display_Mode_Data;
}

Display_Orientation :: enum u32
{
    UNKNOWN;
    LANDSCAPE;
    LANDSCAPE_FLIPPED;
    PORTRAIT;
    PORTRAIT_FLIPPED;
}

Window       :: void;
Window_Flags :: enum_flags u64
{
    FULLSCREEN           :: 0x0000000000000001;
    OPENGL               :: 0x0000000000000002;
    OCCLUDED             :: 0x0000000000000004;
    HIDDEN               :: 0x0000000000000008;
    BORDERLESS           :: 0x0000000000000010;
    RESIZABLE            :: 0x0000000000000020;
    MINIMIZED            :: 0x0000000000000040;
    MAXIMIZED            :: 0x0000000000000080;
    MOUSE_GRABBED        :: 0x0000000000000100;
    INPUT_FOCUS          :: 0x0000000000000200;
    MOUSE_FOCUS          :: 0x0000000000000400;
    EXTERNAL             :: 0x0000000000000800;
    MODAL                :: 0x0000000000001000;
    HIGH_PIXEL_DENSITY   :: 0x0000000000002000;
    MOUSE_CAPTURE        :: 0x0000000000004000;
    MOUSE_RELATIVE_MODE  :: 0x0000000000008000;
    ALWAYS_ON_TOP        :: 0x0000000000010000;
    UTILITY              :: 0x0000000000020000;
    TOOLTIP              :: 0x0000000000040000;
    POPUP_MENU           :: 0x0000000000080000;
    KEYBOARD_GRABBED     :: 0x0000000000100000;
    VULKAN               :: 0x0000000010000000;
    METAL                :: 0x0000000020000000;
    TRANSPARENT          :: 0x0000000040000000;
    NOT_FOCUSABLE        :: 0x0000000080000000;
}


WINDOWPOS_UNDEFINED_MASK    : u64 : 0x1FFF0000;
WINDOWPOS_UNDEFINED_DISPLAY :: (x: u64) -> u64 #expand {return (WINDOWPOS_UNDEFINED_MASK | x);}
WINDOWPOS_UNDEFINED         :: () -> u64 #expand {return WINDOWPOS_UNDEFINED_DISPLAY(0);}
WINDOWPOS_ISUNDEFINED       :: (x: u64) -> bool #expand {return ((x & 0xFFFF0000) == WINDOWPOS_UNDEFINED_MASK);}

WINDOWPOS_CENTERED_MASK     : u64 : 0x2FFF0000;
WINDOWPOS_CENTERED_DISPLAY  :: (x: u64) -> u64 {return (WINDOWPOS_CENTERED_MASK | x);}
WINDOWPOS_CENTERED          :: () -> u64 {return WINDOWPOS_CENTERED_DISPLAY(0);}
WINDOWPOS_ISCENTERED        :: (x: u64) -> bool {return ((x & 0xFFFF0000) == WINDOWPOS_CENTERED_MASK);}

Flash_Operation :: enum u32
{
    FLASH_CANCEL;
    FLASH_BRIEFLY;
    FLASH_UNTIL_FOCUSED;
}

GL_Context       :: void;
GL_Context_State :: *GL_Context;
EGL_Display      :: *void;
EGL_Config       :: *void;
EGL_Surface      :: *void;
EGL_Attrib       :: *s32;
EGL_int          :: s32;

EGL_Attrib_Array_Callback :: #type (user_data: *void) -> *EGL_Attrib;
EGL_Int_Array_Callback    :: #type (user_data: *void, display: EGL_Display, config: EGL_Config) -> *EGL_int;

GL_Attr :: enum u32
{
    RED_SIZE;
    GREEN_SIZE;
    BLUE_SIZE;
    ALPHA_SIZE;
    BUFFER_SIZE;
    DOUBLEBUFFER;
    DEPTH_SIZE;
    STENCIL_SIZE;
    ACCUM_RED_SIZE;
    ACCUM_GREEN_SIZE;
    ACCUM_BLUE_SIZE;
    ACCUM_ALPHA_SIZE;
    STEREO;
    MULTISAMPLEBUFFERS;
    MULTISAMPLESAMPLES;
    ACCELERATED_VISUAL;
    RETAINED_BACKING;
    CONTEXT_MAJOR_VERSION;
    CONTEXT_MINOR_VERSION;
    CONTEXT_FLAGS;
    CONTEXT_PROFILE_MASK;
    SHARE_WITH_CURRENT_CONTEXT;
    FRAMEBUFFER_SRGB_CAPABLE;
    CONTEXT_RELEASE_BEHAVIOR;
    CONTEXT_RESET_NOTIFICATION;
    CONTEXT_NO_ERROR;
    FLOATBUFFERS;
    EGL_PLATFORM;
}


GL_Profile :: enum_flags u32
{
    CORE          :: 0x0001;
    COMPATIBILITY :: 0x0002;
    ES            :: 0x0004;
}

GL_Context_Flag :: enum_flags u32
{
    DEBUG_FLAG              :: 0x0001;
    FORWARD_COMPATIBLE_FLAG :: 0x0002;
    ROBUST_ACCESS_FLAG      :: 0x0004;
    RESET_ISOLATION_FLAG    :: 0x0008;
}

Gl_Context_Release_Flag :: enum_flags u32
{
    NONE   :: 0x0000;
    FLUSH  :: 0x0001;
}



GL_Context_Reset_Notification :: enum_flags u32
{
    NO_NOTIFICATION   :: 0x0000;
    LOSE_CONTEXT      :: 0x0001;
}

WINDOW_SURFACE_VSYNC_DISABLED :: 0;
WINDOW_SURFACE_VSYNC_ADAPTIVE :: -1;

Hit_Test_Result :: enum u32
{
    NORMAL;
    DRAGGABLE;
    RESIZE_TOPLEFT;
    RESIZE_TOP;
    RESIZE_TOPRIGHT;
    RESIZE_RIGHT;
    RESIZE_BOTTOMRIGHT;
    RESIZE_BOTTOM;
    RESIZE_BOTTOMLEFT;
    RESIZE_LEFT;
}

Hit_Test :: #type (window: *Window, area: *Point, data: *void) -> Hit_Test_Result;

get_num_video_drivers               :: () -> s32                                                                                                                                                                 #foreign SDL3 "SDL_GetNumVideoDrivers";
get_video_driver                    :: (index: s32) -> *u8                                                                                                                                                       #foreign SDL3 "SDL_GetVideoDriver";
get_current_video_driver            :: () -> *u8                                                                                                                                                                 #foreign SDL3 "SDL_GetCurrentVideoDriver";
get_system_theme                    :: () -> System_Theme                                                                                                                                                        #foreign SDL3 "SDL_GetSystemTheme";
get_displays                        :: (count: *s32) -> *Display_ID                                                                                                                                              #foreign SDL3 "SDL_GetDisplays";
get_primary_display                 :: () -> Display_ID                                                                                                                                                          #foreign SDL3 "SDL_GetPrimaryDisplay";
get_display_properties              :: (display_id: Display_ID) -> Properties_ID                                                                                                                                 #foreign SDL3 "SDL_GetDisplayProperties";
get_display_name                    :: (display_id: Display_ID) -> *u8                                                                                                                                           #foreign SDL3 "SDL_GetDisplayName";
get_display_bounds                  :: (display_id: Display_ID, rect: *Rect) -> bool                                                                                                                             #foreign SDL3 "SDL_GetDisplayBounds";
get_display_usable_bounds           :: (display_id: Display_ID, rect: *Rect) -> bool                                                                                                                             #foreign SDL3 "SDL_GetDisplayUsableBounds";
get_natural_display_orientation     :: (display_id: Display_ID) -> Display_Orientation                                                                                                                           #foreign SDL3 "SDL_GetNaturalDisplayOrientation";
get_current_display_orientation     :: (display_id: Display_ID) -> Display_Orientation                                                                                                                           #foreign SDL3 "SDL_GetCurrentDisplayOrientation";
get_display_content_scale           :: (display_id: Display_ID) -> float32                                                                                                                                       #foreign SDL3 "SDL_GetDisplayContentScale";
get_fullscreen_display_modes        :: (display_id: Display_ID, count: *s32) -> **Display_Mode                                                                                                                   #foreign SDL3 "SDL_GetFullscreenDisplayModes";
get_closest_fullscreen_display_mode :: (display_id: Display_ID, w: s32, h: s32, refresh_rate: float32, include_high_density_modes: bool, closest: *Display_Mode) -> bool                                         #foreign SDL3 "SDL_GetClosestFullscreenDisplayMode";
get_desktop_display_mode            :: (display_id: Display_ID) -> *Display_Mode                                                                                                                                 #foreign SDL3 "SDL_GetDesktopDisplayMode";
get_current_display_mode            :: (display_id: Display_ID) -> *Display_Mode                                                                                                                                 #foreign SDL3 "SDL_GetCurrentDisplayMode";
get_display_for_point               :: (point: *Point) -> Display_ID                                                                                                                                             #foreign SDL3 "SDL_GetDisplayForPoint";
get_display_for_rect                :: (rect: *Rect) -> Display_ID                                                                                                                                               #foreign SDL3 "SDL_GetDisplayForRect";
get_display_for_window              :: (window: *Window) -> Display_ID                                                                                                                                           #foreign SDL3 "SDL_GetDisplayForWindow";
get_window_pixel_density            :: (window: *Window) -> float32                                                                                                                                              #foreign SDL3 "SDL_GetWindowPixelDensity";
get_window_display_scale            :: (window: *Window) -> float32                                                                                                                                              #foreign SDL3 "SDL_GetWindowDisplayScale";
set_window_fullscreen_mode          :: (window: *Window, mode: *Display_Mode) -> bool                                                                                                                            #foreign SDL3 "SDL_SetWindowFullscreenMode";
get_window_fullscreen_mode          :: (window: *Window) -> *Display_Mode                                                                                                                                        #foreign SDL3 "SDL_GetWindowFullscreenMode";
get_window_icc_profile              :: (window: *Window, size: *u64) -> *void                                                                                                                                    #foreign SDL3 "SDL_GetWindowICCProfile";
get_window_pixel_format             :: (window: *Window) -> Pixel_Format                                                                                                                                         #foreign SDL3 "SDL_GetWindowPixelFormat";
get_windows                         :: (count: *s32) -> **Window                                                                                                                                                 #foreign SDL3 "SDL_GetWindows";
create_window                       :: (title: *u8, w: s32, h: s32, flags: Window_Flags) -> *Window                                                                                                              #foreign SDL3 "SDL_CreateWindow";
create_popup_window                 :: (parent: *Window, offset_x: s32, offset_y: s32, w: s32, h: s32, flags: Window_Flags) -> *Window                                                                           #foreign SDL3 "SDL_CreatePopupWindow";
create_window_with_properties       :: (props: Properties_ID) -> *Window                                                                                                                                         #foreign SDL3 "SDL_CreateWindowWithProperties";
get_window_id                       :: (window: *Window) -> Window_ID                                                                                                                                            #foreign SDL3 "SDL_GetWindowID";
get_window_from_id                  :: (id: Window_ID) -> *Window                                                                                                                                                #foreign SDL3 "SDL_GetWindowFromID";
get_window_parent                   :: (window: *Window) -> *Window                                                                                                                                              #foreign SDL3 "SDL_GetWindowParent";
get_window_properties               :: (window: *Window) -> Properties_ID                                                                                                                                        #foreign SDL3 "SDL_GetWindowProperties";
get_window_flags                    :: (window: *Window) -> Window_Flags                                                                                                                                         #foreign SDL3 "SDL_GetWindowFlags";
set_window_title                    :: (window: *Window, title: *u8) -> bool                                                                                                                                     #foreign SDL3 "SDL_SetWindowTitle";
get_window_title                    :: (window: *Window) -> *u8                                                                                                                                                  #foreign SDL3 "SDL_GetWindowTitle";
set_window_icon                     :: (window: *Window, icon: *Surface) -> bool                                                                                                                                 #foreign SDL3 "SDL_SetWindowIcon";
set_window_position                 :: (window: *Window, x: s32, y: s32) -> bool                                                                                                                                 #foreign SDL3 "SDL_SetWindowPosition";
get_window_position                 :: (window: *Window, x: *s32, y: *s32) -> bool                                                                                                                               #foreign SDL3 "SDL_GetWindowPosition";
set_window_size                     :: (window: *Window, w: s32, h: s32) -> bool                                                                                                                                 #foreign SDL3 "SDL_SetWindowSize";
get_window_size                     :: (window: *Window, w: *s32, h: *s32) -> bool                                                                                                                               #foreign SDL3 "SDL_GetWindowSize";
get_window_safe_area                :: (window: *Window, rect: *Rect) -> bool                                                                                                                                    #foreign SDL3 "SDL_GetWindowSafeArea";
set_window_aspect_ratio             :: (window: *Window, min_aspect: float32, max_aspect: float32) -> bool                                                                                                       #foreign SDL3 "SDL_SetWindowAspectRatio";
get_window_aspect_ratio             :: (window: *Window, min_aspect: *float32, max_aspect: *float32) -> bool                                                                                                     #foreign SDL3 "SDL_GetWindowAspectRatio";
get_window_borders_size             :: (window: *Window, top: *s32, left: *s32, bottom: *s32, right: *s32) -> bool                                                                                               #foreign SDL3 "SDL_GetWindowBordersSize";
get_window_size_in_pixels           :: (window: *Window, w: *s32, h: *s32) -> bool                                                                                                                               #foreign SDL3 "SDL_GetWindowSizeInPixels";
set_window_minimum_size             :: (window: *Window, min_w: s32, min_h: s32) -> bool                                                                                                                         #foreign SDL3 "SDL_SetWindowMinimumSize";
get_window_minimum_size             :: (window: *Window, w: *s32, h: *s32) -> bool                                                                                                                               #foreign SDL3 "SDL_GetWindowMinimumSize";
set_window_maximum_size             :: (window: *Window, max_w: s32, max_h: s32) -> bool                                                                                                                         #foreign SDL3 "SDL_SetWindowMaximumSize";
get_window_maximum_size             :: (window: *Window, w: *s32, h: *s32) -> bool                                                                                                                               #foreign SDL3 "SDL_GetWindowMaximumSize";
set_window_bordered                 :: (window: *Window, bordered: bool) -> bool                                                                                                                                 #foreign SDL3 "SDL_SetWindowBordered";
set_window_resizable                :: (window: *Window, resizable: bool) -> bool                                                                                                                                #foreign SDL3 "SDL_SetWindowResizable";
set_window_always_on_top            :: (window: *Window, on_top: bool) -> bool                                                                                                                                   #foreign SDL3 "SDL_SetWindowAlwaysOnTop";
show_window                         :: (window: *Window) -> bool                                                                                                                                                 #foreign SDL3 "SDL_ShowWindow";
hide_window                         :: (window: *Window) -> bool                                                                                                                                                 #foreign SDL3 "SDL_HideWindow";
raise_window                        :: (window: *Window) -> bool                                                                                                                                                 #foreign SDL3 "SDL_RaiseWindow";
maximize_window                     :: (window: *Window) -> bool                                                                                                                                                 #foreign SDL3 "SDL_MaximizeWindow";
minimize_window                     :: (window: *Window) -> bool                                                                                                                                                 #foreign SDL3 "SDL_MinimizeWindow";
restore_window                      :: (window: *Window) -> bool                                                                                                                                                 #foreign SDL3 "SDL_RestoreWindow";
set_window_fullscreen               :: (window: *Window, fullscreen: bool) -> bool                                                                                                                               #foreign SDL3 "SDL_SetWindowFullscreen";
sync_window                         :: (window: *Window) -> bool                                                                                                                                                 #foreign SDL3 "SDL_SyncWindow";
window_has_surface                  :: (window: *Window) -> bool                                                                                                                                                 #foreign SDL3 "SDL_WindowHasSurface";
get_window_surface                  :: (window: *Window) -> *Surface                                                                                                                                             #foreign SDL3 "SDL_GetWindowSurface";
set_window_surface_v_sync           :: (window: *Window, vsync: s32) -> bool                                                                                                                                     #foreign SDL3 "SDL_SetWindowSurfaceVSync";
get_window_surface_v_sync           :: (window: *Window, vsync: *s32) -> bool                                                                                                                                    #foreign SDL3 "SDL_GetWindowSurfaceVSync";
update_window_surface               :: (window: *Window) -> bool                                                                                                                                                 #foreign SDL3 "SDL_UpdateWindowSurface";
update_window_surface_rects         :: (window: *Window, rects: *Rect, num_rects: s32) -> bool                                                                                                                   #foreign SDL3 "SDL_UpdateWindowSurfaceRects";
destroy_window_surface              :: (window: *Window) -> bool                                                                                                                                                 #foreign SDL3 "SDL_DestroyWindowSurface";
set_window_keyboard_grab            :: (window: *Window, grabbed: bool) -> bool                                                                                                                                  #foreign SDL3 "SDL_SetWindowKeyboardGrab";
set_window_mouse_grab               :: (window: *Window, grabbed: bool) -> bool                                                                                                                                  #foreign SDL3 "SDL_SetWindowMouseGrab";
get_window_keyboard_grab            :: (window: *Window) -> bool                                                                                                                                                 #foreign SDL3 "SDL_GetWindowKeyboardGrab";
get_window_mouse_grab               :: (window: *Window) -> bool                                                                                                                                                 #foreign SDL3 "SDL_GetWindowMouseGrab";
get_grabbed_window                  :: () -> *Window                                                                                                                                                             #foreign SDL3 "SDL_GetGrabbedWindow";
set_window_mouse_rect               :: (window: *Window, rect: *Rect) -> bool                                                                                                                                    #foreign SDL3 "SDL_SetWindowMouseRect";
get_window_mouse_rect               :: (window: *Window) -> *Rect                                                                                                                                                #foreign SDL3 "SDL_GetWindowMouseRect";
set_window_opacity                  :: (window: *Window, opacity: float32) -> bool                                                                                                                               #foreign SDL3 "SDL_SetWindowOpacity";
get_window_opacity                  :: (window: *Window) -> float32                                                                                                                                              #foreign SDL3 "SDL_GetWindowOpacity";
set_window_parent                   :: (window: *Window, parent: *Window) -> bool                                                                                                                                #foreign SDL3 "SDL_SetWindowParent";
set_window_modal                    :: (window: *Window, modal: bool) -> bool                                                                                                                                    #foreign SDL3 "SDL_SetWindowModal";
set_window_focusable                :: (window: *Window, focusable: bool) -> bool                                                                                                                                #foreign SDL3 "SDL_SetWindowFocusable";
show_window_system_menu             :: (window: *Window, x: s32, y: s32) -> bool                                                                                                                                 #foreign SDL3 "SDL_ShowWindowSystemMenu";
set_window_hit_test                 :: (window: *Window, callback: Hit_Test, callback_data: *void) -> bool                                                                                                       #foreign SDL3 "SDL_SetWindowHitTest";
set_window_shape                    :: (window: *Window, shape: *Surface) -> bool                                                                                                                                #foreign SDL3 "SDL_SetWindowShape";
flash_window                        :: (window: *Window, operation: Flash_Operation) -> bool                                                                                                                     #foreign SDL3 "SDL_FlashWindow";
destroy_window                      :: (window: *Window)                                                                                                                                                         #foreign SDL3 "SDL_DestroyWindow";
screen_saver_enabled                :: () -> bool                                                                                                                                                                #foreign SDL3 "SDL_ScreenSaverEnabled";
enable_screen_saver                 :: () -> bool                                                                                                                                                                #foreign SDL3 "SDL_EnableScreenSaver";
disable_screen_saver                :: () -> bool                                                                                                                                                                #foreign SDL3 "SDL_DisableScreenSaver";
gl_load_library                     :: (path: *u8) -> bool                                                                                                                                                       #foreign SDL3 "SDL_GL_LoadLibrary";
gl_get_proc_address                 :: (proc: *u8) -> Function_Pointer                                                                                                                                           #foreign SDL3 "SDL_GL_GetProcAddress";
egl_get_proc_address                :: (proc: *u8) -> Function_Pointer                                                                                                                                           #foreign SDL3 "SDL_EGL_GetProcAddress";
gl_unload_library                   :: ()                                                                                                                                                                        #foreign SDL3 "SDL_GL_UnloadLibrary";
gl_extension_supported              :: (extension: *u8) -> bool                                                                                                                                                  #foreign SDL3 "SDL_GL_ExtensionSupported";
gl_reset_attributes                 :: ()                                                                                                                                                                        #foreign SDL3 "SDL_GL_ResetAttributes";
gl_set_attribute                    :: (attr: GL_Attr, value: s32) -> bool                                                                                                                                       #foreign SDL3 "SDL_GL_SetAttribute";
gl_get_attribute                    :: (attr: GL_Attr, value: *s32) -> bool                                                                                                                                      #foreign SDL3 "SDL_GL_GetAttribute";
gl_create_context                   :: (window: *Window) -> GL_Context                                                                                                                                           #foreign SDL3 "SDL_GL_CreateContext";
gl_make_current                     :: (window: *Window, ctx: GL_Context) -> bool                                                                                                                                #foreign SDL3 "SDL_GL_MakeCurrent";
gl_get_current_window               :: () -> *Window                                                                                                                                                             #foreign SDL3 "SDL_GL_GetCurrentWindow";
gl_get_current_context              :: () -> GL_Context                                                                                                                                                          #foreign SDL3 "SDL_GL_GetCurrentContext";
egl_get_current_display             :: () -> EGL_Display                                                                                                                                                         #foreign SDL3 "SDL_EGL_GetCurrentDisplay";
egl_get_current_config              :: () -> EGL_Config                                                                                                                                                          #foreign SDL3 "SDL_EGL_GetCurrentConfig";
egl_get_window_surface              :: (window: *Window) -> EGL_Surface                                                                                                                                          #foreign SDL3 "SDL_EGL_GetWindowSurface";
egl_set_attribute_callbacks         :: (platform_attrib_callback: EGL_Attrib_Array_Callback, surface_attrib_callback: EGL_Int_Array_Callback, context_attrib_callback: EGL_Int_Array_Callback, user_data: *void) #foreign SDL3 "SDL_EGL_SetAttributeCallbacks";
gl_set_swap_interval                :: (interval: s32) -> bool                                                                                                                                                   #foreign SDL3 "SDL_GL_SetSwapInterval";
gl_get_swap_interval                :: (interval: *s32) -> bool                                                                                                                                                  #foreign SDL3 "SDL_GL_GetSwapInterval";
gl_swap_window                      :: (window: *Window) -> bool                                                                                                                                                 #foreign SDL3 "SDL_GL_SwapWindow";
gl_destroy_context                  :: (ctx: GL_Context) -> bool                                                                                                                                                 #foreign SDL3 "SDL_GL_DestroyContext";


PROP_GLOBAL_VIDEO_WAYLAND_WL_DISPLAY_POINTER :: "SDL.video.wayland.wl_display";

PROP_DISPLAY_HDR_ENABLED_BOOLEAN             :: "SDL.display.HDR_enabled";
PROP_DISPLAY_KMSDRM_PANEL_ORIENTATION_NUMBER :: "SDL.display.KMSDRM.panel_orientation";

PROP_WINDOW_CREATE_ALWAYS_ON_TOP_BOOLEAN               :: "SDL.window.create.always_on_top";
PROP_WINDOW_CREATE_BORDERLESS_BOOLEAN                  :: "SDL.window.create.borderless";
PROP_WINDOW_CREATE_FOCUSABLE_BOOLEAN                   :: "SDL.window.create.focusable";
PROP_WINDOW_CREATE_EXTERNAL_GRAPHICS_CONTEXT_BOOLEAN   :: "SDL.window.create.external_graphics_context";
PROP_WINDOW_CREATE_FLAGS_NUMBER                        :: "SDL.window.create.flags";
PROP_WINDOW_CREATE_FULLSCREEN_BOOLEAN                  :: "SDL.window.create.fullscreen";
PROP_WINDOW_CREATE_HEIGHT_NUMBER                       :: "SDL.window.create.height";
PROP_WINDOW_CREATE_HIDDEN_BOOLEAN                      :: "SDL.window.create.hidden";
PROP_WINDOW_CREATE_HIGH_PIXEL_DENSITY_BOOLEAN          :: "SDL.window.create.high_pixel_density";
PROP_WINDOW_CREATE_MAXIMIZED_BOOLEAN                   :: "SDL.window.create.maximized";
PROP_WINDOW_CREATE_MENU_BOOLEAN                        :: "SDL.window.create.menu";
PROP_WINDOW_CREATE_METAL_BOOLEAN                       :: "SDL.window.create.metal";
PROP_WINDOW_CREATE_MINIMIZED_BOOLEAN                   :: "SDL.window.create.minimized";
PROP_WINDOW_CREATE_MODAL_BOOLEAN                       :: "SDL.window.create.modal";
PROP_WINDOW_CREATE_MOUSE_GRABBED_BOOLEAN               :: "SDL.window.create.mouse_grabbed";
PROP_WINDOW_CREATE_OPENGL_BOOLEAN                      :: "SDL.window.create.opengl";
PROP_WINDOW_CREATE_PARENT_POINTER                      :: "SDL.window.create.parent";
PROP_WINDOW_CREATE_RESIZABLE_BOOLEAN                   :: "SDL.window.create.resizable";
PROP_WINDOW_CREATE_TITLE_STRING                        :: "SDL.window.create.title";
PROP_WINDOW_CREATE_TRANSPARENT_BOOLEAN                 :: "SDL.window.create.transparent";
PROP_WINDOW_CREATE_TOOLTIP_BOOLEAN                     :: "SDL.window.create.tooltip";
PROP_WINDOW_CREATE_UTILITY_BOOLEAN                     :: "SDL.window.create.utility";
PROP_WINDOW_CREATE_VULKAN_BOOLEAN                      :: "SDL.window.create.vulkan";
PROP_WINDOW_CREATE_WIDTH_NUMBER                        :: "SDL.window.create.width";
PROP_WINDOW_CREATE_X_NUMBER                            :: "SDL.window.create.x";
PROP_WINDOW_CREATE_Y_NUMBER                            :: "SDL.window.create.y";
PROP_WINDOW_CREATE_COCOA_WINDOW_POINTER                :: "SDL.window.create.cocoa.window";
PROP_WINDOW_CREATE_COCOA_VIEW_POINTER                  :: "SDL.window.create.cocoa.view";
PROP_WINDOW_CREATE_WAYLAND_SURFACE_ROLE_CUSTOM_BOOLEAN :: "SDL.window.create.wayland.surface_role_custom";
PROP_WINDOW_CREATE_WAYLAND_CREATE_EGL_WINDOW_BOOLEAN   :: "SDL.window.create.wayland.create_egl_window";
PROP_WINDOW_CREATE_WAYLAND_WL_SURFACE_POINTER          :: "SDL.window.create.wayland.wl_surface";
PROP_WINDOW_CREATE_WIN32_HWND_POINTER                  :: "SDL.window.create.win32.hwnd";
PROP_WINDOW_CREATE_WIN32_PIXEL_FORMAT_HWND_POINTER     :: "SDL.window.create.win32.pixel_format_hwnd";
PROP_WINDOW_CREATE_X11_WINDOW_NUMBER                   :: "SDL.window.create.x11.window";

PROP_WINDOW_SHAPE_POINTER                              :: "SDL.window.shape";
PROP_WINDOW_HDR_ENABLED_BOOLEAN                        :: "SDL.window.HDR_enabled";
PROP_WINDOW_SDR_WHITE_LEVEL_FLOAT                      :: "SDL.window.SDR_white_level";
PROP_WINDOW_HDR_HEADROOM_FLOAT                         :: "SDL.window.HDR_headroom";
PROP_WINDOW_ANDROID_WINDOW_POINTER                     :: "SDL.window.android.window";
PROP_WINDOW_ANDROID_SURFACE_POINTER                    :: "SDL.window.android.surface";
PROP_WINDOW_UIKIT_WINDOW_POINTER                       :: "SDL.window.uikit.window";
PROP_WINDOW_UIKIT_METAL_VIEW_TAG_NUMBER                :: "SDL.window.uikit.metal_view_tag";
PROP_WINDOW_UIKIT_OPENGL_FRAMEBUFFER_NUMBER            :: "SDL.window.uikit.opengl.framebuffer";
PROP_WINDOW_UIKIT_OPENGL_RENDERBUFFER_NUMBER           :: "SDL.window.uikit.opengl.renderbuffer";
PROP_WINDOW_UIKIT_OPENGL_RESOLVE_FRAMEBUFFER_NUMBER    :: "SDL.window.uikit.opengl.resolve_framebuffer";
PROP_WINDOW_KMSDRM_DEVICE_INDEX_NUMBER                 :: "SDL.window.kmsdrm.dev_index";
PROP_WINDOW_KMSDRM_DRM_FD_NUMBER                       :: "SDL.window.kmsdrm.drm_fd";
PROP_WINDOW_KMSDRM_GBM_DEVICE_POINTER                  :: "SDL.window.kmsdrm.gbm_dev";
PROP_WINDOW_COCOA_WINDOW_POINTER                       :: "SDL.window.cocoa.window";
PROP_WINDOW_COCOA_METAL_VIEW_TAG_NUMBER                :: "SDL.window.cocoa.metal_view_tag";
PROP_WINDOW_OPENVR_OVERLAY_ID                          :: "SDL.window.openvr.overlay_id";
PROP_WINDOW_VIVANTE_DISPLAY_POINTER                    :: "SDL.window.vivante.display";
PROP_WINDOW_VIVANTE_WINDOW_POINTER                     :: "SDL.window.vivante.window";
PROP_WINDOW_VIVANTE_SURFACE_POINTER                    :: "SDL.window.vivante.surface";
PROP_WINDOW_WIN32_HWND_POINTER                         :: "SDL.window.win32.hwnd";
PROP_WINDOW_WIN32_HDC_POINTER                          :: "SDL.window.win32.hdc";
PROP_WINDOW_WIN32_INSTANCE_POINTER                     :: "SDL.window.win32.instance";
PROP_WINDOW_WAYLAND_DISPLAY_POINTER                    :: "SDL.window.wayland.display";
PROP_WINDOW_WAYLAND_SURFACE_POINTER                    :: "SDL.window.wayland.surface";
PROP_WINDOW_WAYLAND_VIEWPORT_POINTER                   :: "SDL.window.wayland.viewport";
PROP_WINDOW_WAYLAND_EGL_WINDOW_POINTER                 :: "SDL.window.wayland.egl_window";
PROP_WINDOW_WAYLAND_XDG_SURFACE_POINTER                :: "SDL.window.wayland.xdg_surface";
PROP_WINDOW_WAYLAND_XDG_TOPLEVEL_POINTER               :: "SDL.window.wayland.xdg_toplevel";
PROP_WINDOW_WAYLAND_XDG_TOPLEVEL_EXPORT_HANDLE_STRING  :: "SDL.window.wayland.xdg_toplevel_export_handle";
PROP_WINDOW_WAYLAND_XDG_POPUP_POINTER                  :: "SDL.window.wayland.xdg_popup";
PROP_WINDOW_WAYLAND_XDG_POSITIONER_POINTER             :: "SDL.window.wayland.xdg_positioner";
PROP_WINDOW_X11_DISPLAY_POINTER                        :: "SDL.window.x11.display";
PROP_WINDOW_X11_SCREEN_NUMBER                          :: "SDL.window.x11.screen";
PROP_WINDOW_X11_WINDOW_NUMBER                          :: "SDL.window.x11.window";
