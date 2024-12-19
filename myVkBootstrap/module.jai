/*
Module: BS842 Vk Bootstrap
File: module.jai
Author: Brock Salmon
Created: 03DEC2024
Last Edit: 18DEC2024
*/

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

setup_pNext_chain :: (chainBase : $T, structures : *[..] *VkBaseOutStructure) {
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

#load "instance.jai";
#load "physical_device.jai";
#load "queues.jai";
#load "system_info.jai";

#scope_file

#import "Basic";
#import "Math";
#import "Reflection";
#import "Sort";
#import "String";
#import "Vulkan_1_3";


