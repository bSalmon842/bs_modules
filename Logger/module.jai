/*
Project: AZ842 Vulkan Renderer
File: logger.jai
Author: Brock Salmon
Created: 26NOV2023
*/

// TODO: Add calling location to log (maybe just for fatal)
// TODO: Logs on the same minute are overwriting text instead of appending

#module_parameters(IS_DEV := false);

Log_Type :: enum {
    INFO;
    SUCCESS;
    WARN;
    ERROR;
    FATAL;
    DEV;
}

make_log_file :: (programName : string) {
    logFolder := "logs";
    make_directory_if_it_does_not_exist(logFolder);
    
    dt := get_system_time(true);
    
    filename : String_Builder;
    print_to_builder(*filename, "%/%_%-%-%_%-%.log", logFolder, programName, dt.year, formatInt(dt.month, minimum_digits=2), formatInt(dt.day, minimum_digits=2), formatInt(dt.hour, minimum_digits=2), formatInt(dt.minute, minimum_digits=2));
    file, success := file_open(builder_to_string(*filename), for_writing=true, keep_existing_content=true);
    if success {
        LOG_FILE = file;
        log(.SUCCESS, "Created Log File");
    } else {
        assert(false, "Failed to create log file.");
    }
}

log :: (type : Log_Type, s : string) {
    if type == .DEV && !IS_DEV then return;
    
    logMsg : String_Builder;
    dt := get_system_time(true);
    
    desig : string;
    if #complete type == {
        case .INFO; desig = "I";
        case .SUCCESS; desig = "S";
        case .WARN; desig = "W";
        case .ERROR; desig = "E";
        case .FATAL; desig = "F";
        case .DEV; desig = "D";
    }
    
    print_to_builder(*logMsg, "[%:%:%.%] %: %\n", formatInt(dt.hour, minimum_digits=2), formatInt(dt.minute, minimum_digits=2), formatInt(dt.second, minimum_digits=2), formatInt(dt.millisecond, minimum_digits=3), desig, s);
    file_write(*LOG_FILE, builder_to_string(*logMsg));
    
    if type == .FATAL then assert(false);
}

#scope_file
LOG_FILE : File;

#import "Basic";
#import "File";
