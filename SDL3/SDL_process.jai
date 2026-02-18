Process :: void;

Process_IO :: enum u32
{
    INHERITED;
    NULL;
    APP;
    REDIRECT;
}


create_process                 :: (args: **u8, pipe_stdio: bool) -> *Process                     #foreign SDL3 "SDL_CreateProcess";
create_process_with_properties :: (props: Properties_ID) -> *Process                             #foreign SDL3 "SDL_CreateProcessWithProperties";
get_process_properties         :: (process: *Process) -> Properties_ID                           #foreign SDL3 "SDL_GetProcessProperties";
read_process                   :: (process: *Process, data_size: *u64, exit_code: *s32) -> *void #foreign SDL3 "SDL_ReadProcess";
get_process_input              :: (process: *Process) -> *IO_Stream                              #foreign SDL3 "SDL_GetProcessInput";
get_process_output             :: (process: *Process) -> *IO_Stream                              #foreign SDL3 "SDL_GetProcessOutput";
kill_process                   :: (process: *Process, force: bool) -> bool                       #foreign SDL3 "SDL_KillProcess";
wait_process                   :: (process: *Process, block: bool, exit_code: *s32) -> bool      #foreign SDL3 "SDL_WaitProcess";
destroy_process                :: (process: *Process)                                            #foreign SDL3 "SDL_DestroyProcess";

PROP_PROCESS_CREATE_ARGS_POINTER                :: "SDL.process.create.args";
PROP_PROCESS_CREATE_ENVIRONMENT_POINTER         :: "SDL.process.create.environment";
PROP_PROCESS_CREATE_STDIN_NUMBER                :: "SDL.process.create.stdin_option";
PROP_PROCESS_CREATE_STDIN_POINTER               :: "SDL.process.create.stdin_source";
PROP_PROCESS_CREATE_STDOUT_NUMBER               :: "SDL.process.create.stdout_option";
PROP_PROCESS_CREATE_STDOUT_POINTER              :: "SDL.process.create.stdout_source";
PROP_PROCESS_CREATE_STDERR_NUMBER               :: "SDL.process.create.stderr_option";
PROP_PROCESS_CREATE_STDERR_POINTER              :: "SDL.process.create.stderr_source";
PROP_PROCESS_CREATE_STDERR_TO_STDOUT_BOOLEAN    :: "SDL.process.create.stderr_to_stdout";
PROP_PROCESS_CREATE_BACKGROUND_BOOLEAN          :: "SDL.process.create.background";

PROP_PROCESS_PID_NUMBER                         :: "SDL.process.pid";
PROP_PROCESS_STDIN_POINTER                      :: "SDL.process.stdin";
PROP_PROCESS_STDOUT_POINTER                     :: "SDL.process.stdout";
PROP_PROCESS_STDERR_POINTER                     :: "SDL.process.stderr";
PROP_PROCESS_BACKGROUND_BOOLEAN                 :: "SDL.process.background";
