/*
Module: BS842 Vk Bootstrap
File: device.jai
Author: Brock Salmon
Created: 19DEC2024
*/

DeviceError :: enum {
    Success;
    Failed_To_Create_Device;
    VkPhysicalDeviceFeatures2_In_pNext_Chain_While_Using_Add_Required_Extension_Features;
}

QueueError :: enum {
    Success;
    Present_Unavailable;
    Graphics_Unavailable;
    Compute_Unavailable;
    Transfer_Unavailable;
    Queue_Index_Out_Of_Range;
    Invalid_Queue_Family_Index;
};

Device :: struct {
    device : VkDevice = VK_NULL_HANDLE;
    physicalDevice : PhysicalDevice;
    surface : VkSurfaceKHR = VK_NULL_HANDLE;
    queueFamilies : [..] VkQueueFamilyProperties;
    allocCallbacks : *VkAllocationCallbacks = VK_NULL_HANDLE;
    instanceVersion : u32 = VK_API_VERSION_1_0;
}

get_queue_index :: (device : Device, type : QueueType) -> u32, QueueError {
    index := QUEUE_INDEX_MAX_VALUE;
    
    if #complete type == {
        case .Present; {
            index = get_present_queue_index(device.physicalDevice.physicalDevice, device.surface, device.queueFamilies);
            if index == QUEUE_INDEX_MAX_VALUE then return index, .Present_Unavailable;
        }
        case .Graphics; {
            index = get_first_queue_index(device.queueFamilies, .GRAPHICS_BIT);
            if index == QUEUE_INDEX_MAX_VALUE then return index, .Graphics_Unavailable;
        }
        case .Compute; {
            index = get_separate_queue_index(device.queueFamilies, .COMPUTE_BIT, .TRANSFER_BIT);
            if index == QUEUE_INDEX_MAX_VALUE then return index, .Compute_Unavailable;
        }
        case .Transfer; {
            index = get_separate_queue_index(device.queueFamilies, .TRANSFER_BIT, .COMPUTE_BIT);
            if index == QUEUE_INDEX_MAX_VALUE then return index, .Transfer_Unavailable;
        }
        
        case; return U32_MAX, .Invalid_Queue_Family_Index;
    }
    
    return index, .Success;
}

get_dedicated_queue_index :: (device : Device, type : QueueType) -> u32, QueueError {
    index := QUEUE_INDEX_MAX_VALUE;
    
    if type == {
        case .Compute; {
            index = get_dedicated_queue_index(device.queueFamilies, .COMPUTE_BIT, .TRANSFER_BIT);
            if index == QUEUE_INDEX_MAX_VALUE then return index, .Compute_Unavailable;
        }
        case .Transfer; {
            index = get_dedicated_queue_index(device.queueFamilies, .TRANSFER_BIT, .COMPUTE_BIT);
            if index == QUEUE_INDEX_MAX_VALUE then return index, .Transfer_Unavailable;
        }
        
        case; return U32_MAX, .Invalid_Queue_Family_Index;
    }
    
    return index, .Success;
}

get_queue :: (device : Device, type : QueueType) -> VkQueue, QueueError {
    index, error := get_queue_index(device, type);
    if error then return VK_NULL_HANDLE, error;
    
    queue : VkQueue;
    vkGetDeviceQueue(device.device, index, 0, *queue);
    return queue, .Success;
}

get_dedicated_queue :: (device : Device, type : QueueType) -> VkQueue, QueueError {
    index, error := get_dedicated_queue_index(device, type);
    if error then return VK_NULL_HANDLE, error;
    
    queue : VkQueue;
    vkGetDeviceQueue(device.device, index, 0, *queue);
    return queue, .Success;
}

CustomQueueDescription :: struct {
    index : u32 = 0;
    priorities : [] float;
}

DeviceBuilder :: struct {
    physicalDevice : PhysicalDevice;
    flags : VkDeviceCreateFlags;
    pNextChain : [..] *VkBaseOutStructure;
    queueDescs : [..] CustomQueueDescription;
    allocCallbacks : *VkAllocationCallbacks = VK_NULL_HANDLE;
}

make_device_builder :: (physDevice : PhysicalDevice) -> *DeviceBuilder {
    builder := New(DeviceBuilder);
    builder.physicalDevice = physDevice;
    return builder;
}

set_custom_queues :: (builder : *DeviceBuilder, queueDescs : [..] CustomQueueDescription) {
    builder.queueDescs = queueDescs;
}

set_allocation_callbacks :: (builder : *DeviceBuilder, callbacks : *VkAllocationCallbacks) {
    builder.allocCallbacks = callbacks;
}

add_pNext :: (builder : *DeviceBuilder, structure : *$T) {
    array_add(*builder.pNextChain, cast(*VkBaseOutStructure) structure);
}

build :: (builder : *DeviceBuilder) -> Device, DeviceError {
    queueDescs : [..] CustomQueueDescription;
    array_add(*queueDescs, ..builder.queueDescs);
    
    if queueDescs.count == 0 {
        for builder.physicalDevice.queueFamilies {
            array_add(*queueDescs, CustomQueueDescription.{ xx it_index, .[ 1.0 ] });
        }
    }
    
    queueCreateInfos : [..] VkDeviceQueueCreateInfo;
    for queueDescs {
        createInfo := VkDeviceQueueCreateInfo.{
            queueFamilyIndex = it.index,
            queueCount = xx it.priorities.count,
            pQueuePriorities = it.priorities.data
        };
        array_add(*queueCreateInfos, createInfo);
    }
    
    extensionsToEnable : [..] *u8;
    defer cleanup_cstr_array(extensionsToEnable);
    for builder.physicalDevice.extensionsToEnable {
        array_add(*extensionsToEnable, to_c_string(it));
    }
    
    if builder.physicalDevice.surface != VK_NULL_HANDLE || builder.physicalDevice.deferSurfaceInitialisation {
        array_add(*extensionsToEnable, VK_KHR_SWAPCHAIN_EXTENSION_NAME);
    }
    
    userDefinedPhysDeviceFeatures2 := false;
    for builder.pNextChain {
        if it.sType == .PHYSICAL_DEVICE_FEATURES_2 {
            userDefinedPhysDeviceFeatures2 = true;
            break;
        }
    }
    
    if userDefinedPhysDeviceFeatures2 && builder.physicalDevice.extendedFeaturesChain.count {
        return .{}, .VkPhysicalDeviceFeatures2_In_pNext_Chain_While_Using_Add_Required_Extension_Features;
    }
    
    finalChain : [..] *VkBaseOutStructure;
    deviceCreateInfo : VkDeviceCreateInfo;
    
    localFeatures2 : VkPhysicalDeviceFeatures2;
    
    if !userDefinedPhysDeviceFeatures2 {
        if builder.physicalDevice.instanceVersion >= VK_API_VERSION_1_1 || builder.physicalDevice.properties2EXTEnabled {
            localFeatures2.features = builder.physicalDevice.features;
            array_add(*finalChain, cast(*VkBaseOutStructure) *localFeatures2);
            for * builder.physicalDevice.extendedFeaturesChain {
                array_add(*finalChain, cast(*VkBaseOutStructure) it);
            }
        } else {
            deviceCreateInfo.pEnabledFeatures = *builder.physicalDevice.features;
        }
    }
    
    for builder.pNextChain {
        array_add(*finalChain, it);
    }
    
    setup_pNext_chain(*deviceCreateInfo, *finalChain);
    for finalChain {
        assert(it.sType != .APPLICATION_INFO);
    }
    
    deviceCreateInfo.flags = builder.flags;
    deviceCreateInfo.queueCreateInfoCount = cast(u32) queueCreateInfos.count;
    deviceCreateInfo.pQueueCreateInfos = queueCreateInfos.data;
    deviceCreateInfo.enabledExtensionCount = cast(u32) extensionsToEnable.count;
    deviceCreateInfo.ppEnabledExtensionNames = extensionsToEnable.data;
    
    device : Device;
    if vkCreateDevice(builder.physicalDevice.physicalDevice, *deviceCreateInfo, builder.allocCallbacks, *device.device) != .SUCCESS {
        return device, .Failed_To_Create_Device;
    }
    
    device.physicalDevice = builder.physicalDevice;
    device.surface = builder.physicalDevice.surface;
    device.queueFamilies = builder.physicalDevice.queueFamilies;
    device.allocCallbacks = builder.allocCallbacks;
    device.instanceVersion = builder.physicalDevice.instanceVersion;
    
    return device, .Success;
}