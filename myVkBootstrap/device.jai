/*
Module: BS842 Vk Bootstrap
File: device.jai
Author: Brock Salmon
Created: 19DEC2024
Last Edit: 19DEC2024
*/

DeviceError :: enum {
    Failed_To_Create_Device;
    VkPhysicalDeviceFeatures2_In_pNext_Chain_While_Using_Add_Required_Extension_Features;
}

QueueError :: enum {
    Present_Unavailable,
    Graphics_Unavailable,
    Compute_Unavailable,
    Transfer_Unavailable,
    Queue_Index_Out_Of_Range,
    Invalid_Queue_Family_Index
};

Device :: struct {
    device : VkDevice = VK_NULL_HANDLE;
    physicalDevice : PhysicalDevice;
    surface : VkSurfaceKHR = VK_NULL_HANDLE;
    queueFamilies : [..] VkQueueFamilyProperties;
    allocCallbacks : *VkAllocationsCallback = VK_NULL_HANDLE;
    instanceVersion : u32 = VK_API_VERSION_1_0;
}

get_queue_index :: (device : Device, type : QueueType) -> u32, QueueError {
    index := QUEUE_INDEX_MAX_VALUE;
    
    if #complete type == {
        case .Present;
        case .Graphics;
        case .Compute;
        case .Transfer;
        case; return U32_MAX, .Invalid_Queue_Family_Index;
    }
    
    return index;
}

CustomQueueDescription :: struct {
    index : u32 = 0;
    priorities : [..] float;
}

DeviceBuilder :: struct {
    physicalDevice : PhysicalDevice;
    flags : VkDeviceCreateFlags;
    pNextChain : [..] *VkBaseOutStructure;
    queueDescs : [..] CustomQueueDescription;
    allocCallbacks : *VkAllocationsCallback = VK_NULL_HANDLE;
}
