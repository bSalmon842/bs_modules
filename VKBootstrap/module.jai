/*
Module: BS842 Vk Bootstrap
File: module.jai
Author: Brock Salmon
Created: 03DEC2024
Last Edit: 18DEC2024
*/

#module_parameters(DEBUG_OUTPUT := false, VERBOSE := false);

#scope_module

VALIDATION_LAYER_NAME :: "VK_LAYER_KHRONOS_validation";
PORTABILITY_EXT_NAME :: "VK_KHR_portability_subset";

// Default debug messenger
default_debug_callback :: (messageSeverity : VkDebugUtilsMessageSeverityFlagBitsEXT,
                           messageType : VkDebugUtilsMessageTypeFlagsEXT,
                           pCallbackData : *VkDebugUtilsMessengerCallbackDataEXT, *void) -> VkBool32 #c_call {
    callback_context := Context.{};
    push_context callback_context {
        ms := enum_value_to_name(messageSeverity);
        mt := enum_value_to_name(messageType);
        print("[%s: %s]\n%s\n", ms, mt, pCallbackData.pMessage);
    }

    return VK_FALSE; // Applications must return false here
}

setup_pNext_chain :: (chainBase : *$T, structures : *[..] *VkBaseOutStructure) {
    if structures.*.count == 0 then return;
    for 1 .. structures.count-1 {
        structures.*[it-1].pNext = structures.*[it];
    }
    
    chainBase.pNext = structures.*[0];
}

cleanup_cstr_array :: (arr : [..] *u8) {
    for * arr {
        free(it);
    }
}

get_version_string :: (version : u32) -> string {
    return tprint("%.%.%", VK_VERSION_MAJOR(version), VK_VERSION_MINOR(version), VK_VERSION_PATCH(version));
}

get_vk_array :: ($T : Type, funcSig : string, funcArgs : string, logFunc : (Log_Type, string), args : ..Any) -> [..] T #expand {
    FUNC_STRING :: #run tprint("%(%);", funcSig, funcArgs);
    
    arrSize : u32;
    arr : [..] T;
    oldData := arr.data;
    arr.data = null;
    result : VkResult = #insert FUNC_STRING;
    if result == .SUCCESS {
        arr.data = oldData;
        array_resize(*arr, arrSize);
        result = #insert FUNC_STRING;
    }
    
    check_vk(result, logFunc, tprint("% succeeded", funcSig), tprint("% failed", funcSig));
    
    return arr;
}

log_vkb :: (type : Log_Type, t : string, s : string) {
    if DEBUG_OUTPUT then log(type, tprint("[VKB INTERNAL: %] %", t, s));
}

check_vk :: (result : VkResult, logFunc : (Log_Type, string), success : string, fail : string) {
    #if VERBOSE {
        if result == .SUCCESS {
            logFunc(.SUCCESS, success);
        } else {
            logFunc(.ERROR, fail);
        }
    }
}

init_for_debugging :: (file : File, time_12hr : bool, time_utc : bool, time_inclDate : bool) {
    set_log_file(file, time_12hr, time_utc, time_inclDate);
}

#load "device.jai";
#load "instance.jai";
#load "physical_device.jai";
#load "queues.jai";
#load "swapchain.jai";
#load "swapchain_misc.jai";
#load "system_info.jai";

#scope_file

#import "Basic";
#import "File";
#import "Logger";
#import "Math";
#import "Reflection";
#import "Sort";
#import "String";
#import "Vulkan_1_3";
