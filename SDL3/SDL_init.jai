Init_Flags :: enum_flags u32
{
    AUDIO    :: 0x00000010;
    VIDEO    :: 0x00000020;
    JOYSTICK :: 0x00000200;
    HAPTIC   :: 0x00001000;
    GAMEPAD  :: 0x00002000;
    EVENTS   :: 0x00004000;
    SENSOR   :: 0x00008000;
    CAMERA   :: 0x00010000;
}

App_Result :: enum u32
{
    CONTINUE;
    SUCCESS;
    FAILURE;
}

AppInit_func    :: #type (appstate: **void, argc: s32, argv: **u8) -> App_Result;
AppIterate_func :: #type (appstate: *void) -> App_Result;
AppEvent_func   :: #type (appstate: *void, event: *Event) -> App_Result;
AppQuit_func    :: #type (appstate: *void, result: App_Result);

init                      :: (flags: Init_Flags) -> bool                            #foreign SDL3 "SDL_Init";
init_subsystem            :: (flags: Init_Flags) -> bool                            #foreign SDL3 "SDL_InitSubSystem";
quit_subsystem            :: (flags: Init_Flags)                                    #foreign SDL3 "SDL_QuitSubSystem";
was_init                  :: (flags: Init_Flags) -> Init_Flags                      #foreign SDL3 "SDL_WasInit";
quit                      :: ()                                                     #foreign SDL3 "SDL_Quit";

set_app_metadata          :: (app_name: *u8, app_version: *u8, app_id: *u8) -> bool #foreign SDL3 "SDL_SetAppMetadata";
set_app_metadata_property :: (name: *u8, value: *u8) -> bool                        #foreign SDL3 "SDL_SetAppMetadataProperty";
get_app_metadata_property :: (name: *u8) -> *u8                                     #foreign SDL3 "SDL_GetAppMetadataProperty";

PROP_APP_METADATA_NAME_STRING       :: "SDL.app.metadata.name";
PROP_APP_METADATA_VERSION_STRING    :: "SDL.app.metadata.version";
PROP_APP_METADATA_IDENTIFIER_STRING :: "SDL.app.metadata.identifier";
PROP_APP_METADATA_CREATOR_STRING    :: "SDL.app.metadata.creator";
PROP_APP_METADATA_COPYRIGHT_STRING  :: "SDL.app.metadata.copyright";
PROP_APP_METADATA_URL_STRING        :: "SDL.app.metadata.url";
PROP_APP_METADATA_TYPE_STRING       :: "SDL.app.metadata.type";
