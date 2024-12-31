/*
Module: BS842 Vk Bootstrap
File: queues.jai
Author: Brock Salmon
Created: 16DEC2024
*/

QUEUE_INDEX_MAX_VALUE : u32 : 65536;

QueueType :: enum {
    Present;
    Graphics;
    Compute;
    Transfer;
}

get_dedicated_queue_index :: (families : [..] VkQueueFamilyProperties, desiredFlags : VkQueueFlags, undesiredFlags : VkQueueFlags) -> u32 {
    for families {
        if (it.queueFlags & desiredFlags) == desiredFlags && (it.queueFlags & .GRAPHICS_BIT) == 0 && (it.queueFlags & undesiredFlags) == 0 {
           return xx it_index;
        }
    }
    
    return QUEUE_INDEX_MAX_VALUE;
}

get_separate_queue_index :: (families : [..] VkQueueFamilyProperties, desiredFlags : VkQueueFlags, undesiredFlags : VkQueueFlags) -> u32 {
    index := QUEUE_INDEX_MAX_VALUE;
    
    for families {
        if (it.queueFlags & desiredFlags) == desiredFlags && (it.queueFlags & .GRAPHICS_BIT) == 0 {
            if (it.queueFlags & undesiredFlags) == 0 {
                return xx it_index;
            } else {
                index = xx it_index;
            }
        }
    }
    
    return index;
}

get_first_queue_index :: (families : [..] VkQueueFamilyProperties, desiredFlags : VkQueueFlags) -> u32 {
    for families {
        if (it.queueFlags & desiredFlags) == desiredFlags then return cast(u32) it_index;
    }
    
    return QUEUE_INDEX_MAX_VALUE;
}

get_present_queue_index :: (vkPhysDevice : VkPhysicalDevice, surface : VkSurfaceKHR, families : [..] VkQueueFamilyProperties) -> u32 {
    for 0 .. families.count-1 {
        presentSupport : u32 = VK_FALSE;
        if surface != VK_NULL_HANDLE {
            if vkGetPhysicalDeviceSurfaceSupportKHR(vkPhysDevice, xx it, surface, *presentSupport) != .SUCCESS then return QUEUE_INDEX_MAX_VALUE;
        }
        if presentSupport then return xx it;
    }
    
    return QUEUE_INDEX_MAX_VALUE;
}