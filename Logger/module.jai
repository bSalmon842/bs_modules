/*
Module: BS842 Logger
File: module.jai
Author: Brock Salmon
Created: 26NOV2023
Last Edit: 01JAN2024
*/

// TODO: Think about how to format the calling location in the log
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

Log_Filename_Flags :: enum_flags u8 {
    YEAR   :: 0x80;
    MONTH  :: 0x40;
    DAY    :: 0x20;
    HOUR   :: 0x10;
    MINUTE :: 0x8;
    SECOND :: 0x4;
    
    USE_12_HR :: 0x2;
    USE_UTC   :: 0x1;
}

Log_Flags :: enum_flags u8 {
    SHOW_DATE_IN_TIMESTAMP :: 0x4;
    USE_12_HR              :: 0x2;
    USE_UTC                :: 0x1;
}

make_log_file :: (programName : string, filenameFlags : Log_Filename_Flags, flags : Log_Flags) {
    if LOG_FILE.handle {
        log(.ERROR, "A log file is already opened for this program.");
        return;
    }
    
    TIMESTAMP_INCL_DATE = cast(bool) (flags & .SHOW_DATE_IN_TIMESTAMP);
    TIMESTAMP_12HR = cast(bool) (flags & .USE_12_HR);
    TIMESTAMP_UTC = cast(bool) (flags & .USE_UTC);
    
    logFolder := "logs";
    make_directory_if_it_does_not_exist(logFolder);
    
    filename : String_Builder;
    print_to_builder(*filename, "%/%_%.log", logFolder, programName, make_filename_timestamp(filenameFlags));
    file, success := file_open(builder_to_string(*filename), for_writing=true, keep_existing_content=true);
    if success {
        LOG_FILE = file;
        log(.SUCCESS, "Created Log File");
    } else {
        assert(false, "Failed to create log file.");
    }
}

log :: (type : Log_Type, s : string, callLoc := #caller_location) {
    assert(!!LOG_FILE.handle);
    if type == .DEV && !IS_DEV then return;
    
    logMsg : String_Builder;
    dt := to_calendar(current_time_consensus(), ifx TIMESTAMP_UTC then .UTC else .LOCAL);
    
    desig : string;
    if #complete type == {
        case .INFO;    desig = "I";
        case .SUCCESS; desig = "S";
        case .WARN;    desig = "W";
        case .ERROR;   desig = "E";
        case .FATAL;   desig = "F";
        case .DEV;     desig = "D";
    }
    
    hour := dt.hour;
    meridiem := "";
    if TIMESTAMP_12HR {
        meridiem = " AM";
        if hour > 12 {
            hour -= 12;
            meridiem = " PM";
        }
    } 
    
    timestamp : string;
    if TIMESTAMP_INCL_DATE {
        timestamp = tprint("[%-%-%|%:%:%.%7%]", dt.year, formatInt(dt.month_starting_at_0 + 1, minimum_digits=2), formatInt(dt.day_of_month_starting_at_0 + 1, minimum_digits=2), formatInt(hour, minimum_digits=2), formatInt(dt.minute, minimum_digits=2), formatInt(dt.second, minimum_digits=2), formatInt(dt.millisecond, minimum_digits=3), meridiem);
    } else {
        timestamp = tprint("[%:%:%.%5%]", formatInt(hour, minimum_digits=2), formatInt(dt.minute, minimum_digits=2), formatInt(dt.second, minimum_digits=2), formatInt(dt.millisecond, minimum_digits=3), meridiem);
    }
    
    filename := path_filename(callLoc.fully_pathed_filename);
    print_to_builder(*logMsg, "% (%:%) %: %\n", timestamp, filename, callLoc.line_number, desig, s);
    file_write(*LOG_FILE, builder_to_string(*logMsg));
    
    if type == .FATAL then assert(false);
}

#scope_file
LOG_FILE : File;
TIMESTAMP_12HR      : bool;
TIMESTAMP_UTC       : bool;
TIMESTAMP_INCL_DATE : bool;

make_filename_timestamp :: (flags : Log_Filename_Flags) -> string {
    timestamp : String_Builder;
    
    usingUTC := cast(bool) (flags & .USE_UTC);
    dt := to_calendar(current_time_consensus(), ifx usingUTC then .UTC else .LOCAL);
    
    using12Hr := cast(bool) (flags & .USE_12_HR);
    hour := dt.hour;
    meridiem := "AM";
    if using12Hr && hour > 12 {
        hour -= 12;
        meridiem = "PM";
    }
    
    lastMaskUsed : Log_Filename_Flags = 0xFF;
    for 0 .. 5 {
        mask : Log_Filename_Flags = xx 0x80 >> it;
        if (flags & mask) > 0 {
            // If this isn't the first part of the timestamp being printed out, then append a separator before the next part
            if lastMaskUsed != 0xFF {
                // We usually want a hyphen for separating 'like' parts (e.g. between date elements and time elements),
                // but between the date and the time sections (if we have both) we want an underscore instead
                // "yyyy-mm-dd" vs "dd_hh"
                sepChar : u8 = ifx lastMaskUsed > .HOUR && mask <= .HOUR then cast(u8) #char "_" else cast(u8) #char "-";
                append(*timestamp, sepChar);
            }
            
            timestampSection : string;
            set_timestamp_section_string :: (fmtData : $T) #expand { `timestampSection = tprint("%", fmtData); }
            
            if mask == {
                case .YEAR;   set_timestamp_section_string(dt.year);
                case .MONTH;  set_timestamp_section_string(formatInt(dt.month_starting_at_0 + 1, minimum_digits=2));
                case .DAY;    set_timestamp_section_string(formatInt(dt.day_of_month_starting_at_0 + 1, minimum_digits=2));
                case .HOUR;   set_timestamp_section_string(formatInt(hour, minimum_digits=2));
                case .MINUTE; set_timestamp_section_string(formatInt(dt.minute, minimum_digits=2));
                case .SECOND; set_timestamp_section_string(formatInt(dt.second, minimum_digits=2));
                
                case; assert(false, "Invalid mask value for Filename timestamp.");
            }
            
            append(*timestamp, timestampSection);
            
            lastMaskUsed = mask;
        }
    }
    
    if using12Hr {
        append(*timestamp, meridiem);
    }
    
    return builder_to_string(*timestamp);
}

#import "Basic";
#import "File";
#import "String";