/*
Module: BS842 Vk Bootstrap
File: system_info.jai
Author: Brock Salmon
Created: 14DEC2024
Last Edit: 14DEC2024
*/

log_systeminfo :: (type : Log_Type, s : string) { log_vkb(type, "SYSTEMINFO", s); }

SystemInfo :: struct {
    availableLayers     : [..] VkLayerProperties;
    availableExtensions : [..] VkExtensionProperties;
    validationLayersAvailable : bool = false;
    debugUtilsAvailable       : bool = false;
}

make_system_info :: () -> SystemInfo {
    systemInfo : SystemInfo;
    
    systemInfo.availableLayers = get_vk_array(VkLayerProperties, "vkEnumerateInstanceLayerProperties", "*arrSize, arr.data", log_systeminfo);
    for systemInfo.availableLayers {
        if compare(cast(string) it.layerName, VALIDATION_LAYER_NAME) == 0 {
            systemInfo.validationLayersAvailable = true;
            break;
        }
    }

    systemInfo.availableExtensions = get_vk_array(VkExtensionProperties, "vkEnumerateInstanceExtensionProperties", "null, *arrSize, arr.data", log_systeminfo);
    for systemInfo.availableExtensions {
        if compare(cast(string) it.extensionName, VK_EXT_DEBUG_UTILS_EXTENSION_NAME) == 0 {
            systemInfo.debugUtilsAvailable = true;
            break;
        }
    }
    
    for systemInfo.availableLayers {
        layerExtensions := get_vk_array(VkExtensionProperties, "vkEnumerateInstanceExtensionProperties", "xx args[0].value_pointer, *arrSize, arr.data", log_systeminfo, it.layerName.data);
        
        array_add(*systemInfo.availableExtensions, ..layerExtensions);
        
        if !systemInfo.debugUtilsAvailable {
            for layerExtensions {
                if compare(cast(string) it.extensionName, VK_EXT_DEBUG_UTILS_EXTENSION_NAME) == 0 {
                    systemInfo.debugUtilsAvailable = true;
                    break;
                }
            }
        }
    }
    
    return systemInfo;
}

is_layer_available :: (using systemInfo : SystemInfo, requestName : string) -> bool {
    for availableLayers {
        if compare(requestName, to_string(it.layerName.data)) == 0 {
            return true;
        }
    }
    return false;
}

is_extension_available :: (using systemInfo : SystemInfo, requestName : string) -> bool {
    for availableExtensions {
        if compare(requestName, to_string(it.extensionName.data)) == 0 {
            return true;
        }
    }
    
    return false;
}

are_extensions_available :: (using systemInfo : SystemInfo, extensions : [..] *u8) -> bool {
    for extensions {
        if !is_extension_available(systemInfo, to_string(it)) then return false;
    }
    
    return true;
}

are_layers_available :: (using systemInfo : SystemInfo, layers : [..] *u8) -> bool {
    for layers {
        if !is_layer_available(systemInfo, to_string(it)) then return false;
    }
    
    return true;
}

