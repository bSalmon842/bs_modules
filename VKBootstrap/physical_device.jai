/*
Module: BS842 Vk Bootstrap
File: physical_device.jai
Author: Brock Salmon
Created: 15DEC2024
*/

PhysicalDeviceError :: enum {
    Success;
    No_Surface_Provided;
    Failed_To_Enumerate_Physical_Devices;
    No_Physical_Devices_Found;
    No_Suitable_Device;
}

PhysicalDeviceSuitable :: enum {
    Yes;
    Partial;
    No;
}

PreferredPhysicalDeviceType :: enum {
    Other;
    Integrated;
    Discrete;
    VirtualGPU;
    CPU;
}

PhysicalDeviceSelectionMode :: enum {
    Partially_And_Fully_Suitable;
    Only_Fully_Suitable;
}

FEATURE_NODE_FIELD_CAPACITY : u32 : 256;
GenericFeaturesNextPtrNode :: struct {
    sType : VkStructureType = 0;
    pNext : *void = null;
    fields : [FEATURE_NODE_FIELD_CAPACITY] VkBool32;
}

make_features_node :: () -> GenericFeaturesNextPtrNode {
    node : GenericFeaturesNextPtrNode;
    memset(node.fields.data, U8_MAX, size_of(VkBool32) * FEATURE_NODE_FIELD_CAPACITY);
    return node;
}

make_features_node :: (features : $T) -> GenericFeaturesNextPtrNode {
    node := make_features_node();
    memcpy(*node, *features, size_of(T));
    return node;
}

match_nodes :: (requested : GenericFeaturesNextPtrNode, supported : GenericFeaturesNextPtrNode) -> bool {
    assert(requested.sType == supported.sType, "Non-matching sTypes in features nodes!");
    for 0 .. FEATURE_NODE_FIELD_CAPACITY-1 {
        if requested.fields[it] && !supported.fields[it] then return false;
    }
    return true;
}

PhysicalDeviceSelectionCriteria :: struct {
    name : string;
    preferredType := PreferredPhysicalDeviceType.Discrete;
    allowAnyType                  := true;
    requirePresent                := true;
    requireDedicatedTransferQueue := false;
    requireDedicatedComputeQueue  := false;
    requireSeparateTransferQueue  := false;
    requireSeparateComputeQueue   := false;
    requiredMemSize : VkDeviceSize = 0;
    desiredMemSize  : VkDeviceSize = 0;
    
    requiredExtensions : [..] string;
    desiredExtensions  : [..] string;
    
    requiredVersion : u32 = VK_API_VERSION_1_0;
    desiredVersion : u32 = VK_API_VERSION_1_0;
    
    requiredFeatures  : VkPhysicalDeviceFeatures;
    requiredFeatures2 : VkPhysicalDeviceFeatures2;
    
    extendedFeaturesChain : [..] GenericFeaturesNextPtrNode;
    deferSurfaceInitialisation := false;
    useFirstGPUUnconditionally := false;
    enablePortabilitySubset := true;
}

PhysicalDevice :: struct {
    name           : string;
    physicalDevice : VkPhysicalDevice = VK_NULL_HANDLE;
    surface        : VkSurfaceKHR = VK_NULL_HANDLE;
    
    features         : VkPhysicalDeviceFeatures;
    features2        : VkPhysicalDeviceFeatures2;
    properties       : VkPhysicalDeviceProperties;
    memoryProperties : VkPhysicalDeviceMemoryProperties;
    
    instanceVersion       : u32 = VK_API_VERSION_1_0;
    extensionsToEnable    : [..] string;
    availableExtensions   : [..] string;
    queueFamilies         : [..] VkQueueFamilyProperties;
    extendedFeaturesChain : [..] GenericFeaturesNextPtrNode;
    
    deferSurfaceInitialisation := false;
    properties2EXTEnabled := false;
    
    suitable := PhysicalDeviceSuitable.Yes;
}

has_dedicated_compute_queue :: (physicalDevice : PhysicalDevice) -> bool {
    return get_dedicated_queue_index(physicalDevice.queueFamilies, .COMPUTE_BIT, .TRANSFER_BIT) != QUEUE_INDEX_MAX_VALUE;
}

has_separate_compute_queue :: (physicalDevice : PhysicalDevice) -> bool {
    return get_separate_queue_index(physicalDevice.queueFamilies, .COMPUTE_BIT, .TRANSFER_BIT) != QUEUE_INDEX_MAX_VALUE;
}

has_dedicated_transfer_queue :: (physicalDevice : PhysicalDevice) -> bool {
    return get_dedicated_queue_index(physicalDevice.queueFamilies, .TRANSFER_BIT, .COMPUTE_BIT) != QUEUE_INDEX_MAX_VALUE;
}

has_separate_transfer_queue :: (physicalDevice : PhysicalDevice) -> bool {
    return get_separate_queue_index(physicalDevice.queueFamilies, .TRANSFER_BIT, .COMPUTE_BIT) != QUEUE_INDEX_MAX_VALUE;
}

is_extension_present :: (physicalDevice : PhysicalDevice, extension : string) -> bool {
    for physicalDevice.availableExtensions {
        if compare(it, extension) == 0 then return true;
    }
    return false;
}

enable_extension_if_present :: (physicalDevice : PhysicalDevice, extension : string) -> bool {
    if is_extension_present(physicalDevice, extension) {
        array_add_if_unique(*physicalDevice.extensionsToEnable, extension);
    }
    return false;
}

check_extension_support :: (availableExtensions : [..] string, desiredExtensions : [..] string) -> [..] string {
    extensionsToEnable : [..] string;
    
    for available : availableExtensions {
        for desired : desiredExtensions {
            if compare(available, desired) == 0 {
                array_add_if_unique(*extensionsToEnable, desired);
                break;
            }
        }
    }
    
    return extensionsToEnable;
}

PhysicalDeviceSelector :: struct {
    instance : VkInstance = VK_NULL_HANDLE;
    surface  : VkSurfaceKHR = VK_NULL_HANDLE;
    version  : u32 = VK_API_VERSION_1_0;
    headless              := false;
    properties2EXTEnabled := false;
    
    criteria : PhysicalDeviceSelectionCriteria;
}

make_physical_device_selector :: (instance : Instance) -> *PhysicalDeviceSelector {
    return make_physical_device_selector(instance, VK_NULL_HANDLE);
}

make_physical_device_selector :: (instance : Instance, surface : VkSurfaceKHR) -> *PhysicalDeviceSelector {
    selector := New(PhysicalDeviceSelector);
    
    selector.instance = instance.instance;
    selector.version = instance.instanceVersion;
    selector.properties2EXTEnabled = instance.properties2EXTEnabled;
    selector.surface = surface;
    selector.criteria.requirePresent = !instance.headless;
    selector.criteria.requiredVersion = instance.apiVersion;
    selector.criteria.desiredVersion = instance.apiVersion;
    
    return selector;
}

set_surface :: (using selector : *PhysicalDeviceSelector, newSurface : VkSurfaceKHR) {
    surface = newSurface;
}

set_name :: (using selector : *PhysicalDeviceSelector, name : string) {
    criteria.name = name;
}

prefer_gpu_device_type :: (using selector : *PhysicalDeviceSelector, type := PreferredPhysicalDeviceType.Discrete) {
    criteria.preferredType = type;
}

allow_any_gpu_device_type :: (using selector : *PhysicalDeviceSelector, allowAnyType := true) {
    criteria.allowAnyType = allowAnyType;
}

require_present :: (using selector : *PhysicalDeviceSelector, require := true) {
    criteria.requirePresent = require;
}

require_dedicated_transfer_queue :: (using selector : *PhysicalDeviceSelector) {
    criteria.requireDedicatedTransferQueue = true;
}

require_dedicated_compute_queue :: (using selector : *PhysicalDeviceSelector) {
    criteria.requireDedicatedComputeQueue = true;
}

require_separate_transfer_queue :: (using selector : *PhysicalDeviceSelector) {
    criteria.requireSeparateTransferQueue = true;
}

require_separate_compute_queue :: (using selector : *PhysicalDeviceSelector) {
    criteria.requireSeparateComputeQueue = true;
}

set_required_device_memory_size :: (using selector : *PhysicalDeviceSelector, size : VkDeviceSize) {
    criteria.requiredMemSize = size;
}

set_desired_device_memory_size :: (using selector : *PhysicalDeviceSelector, size : VkDeviceSize) {
    criteria.desiredMemSize = size;
}

add_required_extension :: (using selector : *PhysicalDeviceSelector, extension : string) {
    array_add_if_unique(*criteria.requiredExtensions, extension);
}

add_required_extensions :: (using selector : *PhysicalDeviceSelector, extensions : [..] string) {
    array_add(*criteria.requiredExtensions, ..extensions);
}

add_desired_extension :: (using selector : *PhysicalDeviceSelector, extension : string) {
    array_add_if_unique(*criteria.desiredExtensions, extension);
}

add_desired_extensions :: (using selector : *PhysicalDeviceSelector, extensions : [..] string) {
    array_add(*criteria.desiredExtensions, ..extensions);
}

set_minimum_version :: (using selector : *PhysicalDeviceSelector, major : u32, minor : u32) {
    criteria.requiredVersion = VK_MAKE_VERSION(major, minor, 0);
}

set_desired_version :: (using selector : *PhysicalDeviceSelector, major : u32, minor : u32) {
    criteria.desiredVersion = VK_MAKE_VERSION(major, minor, 0);
}

disable_portability_subset :: (using selector : *PhysicalDeviceSelector) {
    criteria.enablePortabilitySubset = false;
}

add_required_extension_features :: (using selector : *PhysicalDeviceSelector, features : $T) {
    array_add(*criteria.extendedFeaturesChain, make_features_node(features));
}

set_required_features :: (using selector : *PhysicalDeviceSelector, features : VkPhysicalDeviceFeatures) {
    criteria.requiredFeatures = features;
}

set_required_features_11 :: (using selector : *PhysicalDeviceSelector, features : VkPhysicalDeviceVulkan11Features) {
    add_required_extension_features(selector, features);
}

set_required_features_12 :: (using selector : *PhysicalDeviceSelector, features : VkPhysicalDeviceVulkan12Features) {
    add_required_extension_features(selector, features);
}

set_required_features_13 :: (using selector : *PhysicalDeviceSelector, features : VkPhysicalDeviceVulkan13Features) {
    add_required_extension_features(selector, features);
}

defer_surface_initialisation :: (using selector : *PhysicalDeviceSelector) {
    criteria.deferSurfaceInitialisation = true;
}

select_first_device_unconditionally :: (using selector : *PhysicalDeviceSelector, unconditional := true) {
    criteria.useFirstGPUUnconditionally = unconditional;
}

populate_device_details :: (selector : *PhysicalDeviceSelector, vkPhysDevice : VkPhysicalDevice, srcExtendedFeaturesChain : [..] GenericFeaturesNextPtrNode) -> PhysicalDevice {
    physicalDevice : PhysicalDevice;
    
    physicalDevice.physicalDevice = vkPhysDevice;
    physicalDevice.surface = selector.surface;
    physicalDevice.deferSurfaceInitialisation = selector.criteria.deferSurfaceInitialisation;
    physicalDevice.instanceVersion = selector.version;
    
    queueFamilyPropertyCount : u32;
    vkGetPhysicalDeviceQueueFamilyProperties(vkPhysDevice, *queueFamilyPropertyCount, null);
    array_resize(*physicalDevice.queueFamilies, queueFamilyPropertyCount);
    vkGetPhysicalDeviceQueueFamilyProperties(vkPhysDevice, *queueFamilyPropertyCount, physicalDevice.queueFamilies.data);
    
    vkGetPhysicalDeviceProperties(vkPhysDevice, *physicalDevice.properties);
    vkGetPhysicalDeviceFeatures(vkPhysDevice, *physicalDevice.features);
    vkGetPhysicalDeviceMemoryProperties(vkPhysDevice, *physicalDevice.memoryProperties);
    
    physicalDevice.name = to_string(physicalDevice.properties.deviceName.data);
    
    extensionCount : u32;
    physDeviceExtensions : [..] VkExtensionProperties;
    if vkEnumerateDeviceExtensionProperties(vkPhysDevice, null, *extensionCount, null) != .SUCCESS then return physicalDevice;
    array_resize(*physDeviceExtensions, extensionCount);
    vkEnumerateDeviceExtensionProperties(vkPhysDevice, null, *extensionCount, physDeviceExtensions.data);
    
    for physDeviceExtensions {
        array_add_if_unique(*physicalDevice.availableExtensions, to_string(it.extensionName.data));
    }
    
    physicalDevice.properties2EXTEnabled = selector.properties2EXTEnabled;
    
    chain := srcExtendedFeaturesChain;
    atLeast1_1 := selector.version >= VK_API_VERSION_1_1;
    if chain.count && (atLeast1_1 || selector.properties2EXTEnabled) {
        prev : *GenericFeaturesNextPtrNode = null;
        for * chain {
            if prev then prev.pNext = it;
            prev = it;
        }
        
        localFeatures := VkPhysicalDeviceFeatures2.{ pNext=*chain[0] };
        if atLeast1_1 {
            vkGetPhysicalDeviceFeatures2(vkPhysDevice, *localFeatures);
        } else {
            vkGetPhysicalDeviceFeatures2KHR : PFN_vkGetPhysicalDeviceFeatures2KHR = xx vkGetInstanceProcAddr(selector.instance, "vkGetPhysicalDeviceFeatures2KHR");
            
            if vkGetPhysicalDeviceFeatures2KHR {
                vkGetPhysicalDeviceFeatures2KHR(vkPhysDevice, *localFeatures);
            }
        }
        
        physicalDevice.extendedFeaturesChain = chain;
    }
    
    return physicalDevice;
}

supports_features :: (supported : VkPhysicalDeviceFeatures, requested : VkPhysicalDeviceFeatures,
					  extensionsSupported : [..] GenericFeaturesNextPtrNode, extensionsRequested : [..] GenericFeaturesNextPtrNode) -> bool {
	if (requested.robustBufferAccess && !supported.robustBufferAccess) return false;
	if (requested.fullDrawIndexUint32 && !supported.fullDrawIndexUint32) return false;
	if (requested.imageCubeArray && !supported.imageCubeArray) return false;
	if (requested.independentBlend && !supported.independentBlend) return false;
	if (requested.geometryShader && !supported.geometryShader) return false;
	if (requested.tessellationShader && !supported.tessellationShader) return false;
	if (requested.sampleRateShading && !supported.sampleRateShading) return false;
	if (requested.dualSrcBlend && !supported.dualSrcBlend) return false;
	if (requested.logicOp && !supported.logicOp) return false;
	if (requested.multiDrawIndirect && !supported.multiDrawIndirect) return false;
	if (requested.drawIndirectFirstInstance && !supported.drawIndirectFirstInstance) return false;
	if (requested.depthClamp && !supported.depthClamp) return false;
	if (requested.depthBiasClamp && !supported.depthBiasClamp) return false;
	if (requested.fillModeNonSolid && !supported.fillModeNonSolid) return false;
	if (requested.depthBounds && !supported.depthBounds) return false;
	if (requested.wideLines && !supported.wideLines) return false;
	if (requested.largePoints && !supported.largePoints) return false;
	if (requested.alphaToOne && !supported.alphaToOne) return false;
	if (requested.multiViewport && !supported.multiViewport) return false;
	if (requested.samplerAnisotropy && !supported.samplerAnisotropy) return false;
	if (requested.textureCompressionETC2 && !supported.textureCompressionETC2) return false;
	if (requested.textureCompressionASTC_LDR && !supported.textureCompressionASTC_LDR) return false;
	if (requested.textureCompressionBC && !supported.textureCompressionBC) return false;
	if (requested.occlusionQueryPrecise && !supported.occlusionQueryPrecise) return false;
	if (requested.pipelineStatisticsQuery && !supported.pipelineStatisticsQuery) return false;
	if (requested.vertexPipelineStoresAndAtomics && !supported.vertexPipelineStoresAndAtomics) return false;
	if (requested.fragmentStoresAndAtomics && !supported.fragmentStoresAndAtomics) return false;
	if (requested.shaderTessellationAndGeometryPointSize && !supported.shaderTessellationAndGeometryPointSize) return false;
	if (requested.shaderImageGatherExtended && !supported.shaderImageGatherExtended) return false;
	if (requested.shaderStorageImageExtendedFormats && !supported.shaderStorageImageExtendedFormats) return false;
	if (requested.shaderStorageImageMultisample && !supported.shaderStorageImageMultisample) return false;
	if (requested.shaderStorageImageReadWithoutFormat && !supported.shaderStorageImageReadWithoutFormat) return false;
	if (requested.shaderStorageImageWriteWithoutFormat && !supported.shaderStorageImageWriteWithoutFormat) return false;
	if (requested.shaderUniformBufferArrayDynamicIndexing && !supported.shaderUniformBufferArrayDynamicIndexing) return false;
	if (requested.shaderSampledImageArrayDynamicIndexing && !supported.shaderSampledImageArrayDynamicIndexing) return false;
	if (requested.shaderStorageBufferArrayDynamicIndexing && !supported.shaderStorageBufferArrayDynamicIndexing) return false;
	if (requested.shaderStorageImageArrayDynamicIndexing && !supported.shaderStorageImageArrayDynamicIndexing) return false;
	if (requested.shaderClipDistance && !supported.shaderClipDistance) return false;
	if (requested.shaderCullDistance && !supported.shaderCullDistance) return false;
	if (requested.shaderFloat64 && !supported.shaderFloat64) return false;
	if (requested.shaderInt64 && !supported.shaderInt64) return false;
	if (requested.shaderInt16 && !supported.shaderInt16) return false;
	if (requested.shaderResourceResidency && !supported.shaderResourceResidency) return false;
	if (requested.shaderResourceMinLod && !supported.shaderResourceMinLod) return false;
	if (requested.sparseBinding && !supported.sparseBinding) return false;
	if (requested.sparseResidencyBuffer && !supported.sparseResidencyBuffer) return false;
	if (requested.sparseResidencyImage2D && !supported.sparseResidencyImage2D) return false;
	if (requested.sparseResidencyImage3D && !supported.sparseResidencyImage3D) return false;
	if (requested.sparseResidency2Samples && !supported.sparseResidency2Samples) return false;
	if (requested.sparseResidency4Samples && !supported.sparseResidency4Samples) return false;
	if (requested.sparseResidency8Samples && !supported.sparseResidency8Samples) return false;
	if (requested.sparseResidency16Samples && !supported.sparseResidency16Samples) return false;
	if (requested.sparseResidencyAliased && !supported.sparseResidencyAliased) return false;
	if (requested.variableMultisampleRate && !supported.variableMultisampleRate) return false;
	if (requested.inheritedQueries && !supported.inheritedQueries) return false;

    if (extensionsSupported.count != extensionsRequested.count) {
        return false;
    }

	for 0 .. max(extensionsSupported.count-1, extensionsRequested.count-1) {
		if !match_nodes(extensionsRequested[it], extensionsSupported[it]) then return false;
	}

	return true;
}

is_device_suitable :: (selector : *PhysicalDeviceSelector, physDevice : PhysicalDevice) -> PhysicalDeviceSuitable {
    suitable := PhysicalDeviceSuitable.Yes;
    
    if selector.criteria.name.count && compare(selector.criteria.name, to_string(physDevice.properties.deviceName.data)) != 0 then return .No;
    if selector.criteria.requiredVersion > physDevice.properties.apiVersion then return .No;
    if selector.criteria.desiredVersion > physDevice.properties.apiVersion then suitable = .Partial;
    
    dedicatedCompute := has_dedicated_compute_queue(physDevice);
    dedicatedTransfer := has_dedicated_transfer_queue(physDevice);
    separateCompute := has_separate_compute_queue(physDevice);
    separateTransfer := has_separate_transfer_queue(physDevice);
    
    presentQueue := get_present_queue_index(physDevice.physicalDevice, selector.surface, physDevice.queueFamilies) != QUEUE_INDEX_MAX_VALUE;
    
    if (selector.criteria.requireDedicatedComputeQueue && !dedicatedCompute) ||
       (selector.criteria.requireDedicatedTransferQueue && !dedicatedTransfer) ||
       (selector.criteria.requireSeparateComputeQueue && !separateCompute) ||
       (selector.criteria.requireSeparateTransferQueue && !separateTransfer) ||
       (selector.criteria.requirePresent && !presentQueue && !selector.criteria.deferSurfaceInitialisation) {
        return .No;
    }
    
    requiredExtensionsSupported := check_extension_support(physDevice.availableExtensions, selector.criteria.requiredExtensions);
    if requiredExtensionsSupported.count != selector.criteria.requiredExtensions.count then return .No;
    
    desiredExtensionsSupported := check_extension_support(physDevice.availableExtensions, selector.criteria.desiredExtensions);
    if desiredExtensionsSupported.count != selector.criteria.desiredExtensions.count then return .Partial;
    
    if !selector.criteria.deferSurfaceInitialisation && selector.criteria.requirePresent {
        formats : [..] VkSurfaceFormatKHR;
        presentModes : [..] VkPresentModeKHR;
        
        formatCount : u32;
        if vkGetPhysicalDeviceSurfaceFormatsKHR(physDevice.physicalDevice, selector.surface, *formatCount, null) == .SUCCESS {
            array_resize(*formats, formatCount);
            vkGetPhysicalDeviceSurfaceFormatsKHR(physDevice.physicalDevice, selector.surface, *formatCount, formats.data);
        }
        
        presentCount : u32;
        if vkGetPhysicalDeviceSurfacePresentModesKHR(physDevice.physicalDevice, selector.surface, *presentCount, null) == .SUCCESS {
            array_resize(*presentModes, presentCount);
            vkGetPhysicalDeviceSurfacePresentModesKHR(physDevice.physicalDevice, selector.surface, *presentCount, presentModes.data);
        }
        
        if !formats.count || !presentModes.count {
            return .No;
        }
    }
    
    if !selector.criteria.allowAnyType && physDevice.properties.deviceType != cast(VkPhysicalDeviceType) selector.criteria.preferredType {
        suitable = .Partial;
    }
    
    if !supports_features(physDevice.features, selector.criteria.requiredFeatures, physDevice.extendedFeaturesChain, selector.criteria.extendedFeaturesChain) {
        return .No;
    }
    
    for 0 .. physDevice.memoryProperties.memoryHeapCount-1 {
        memoryHeap := physDevice.memoryProperties.memoryHeaps[it];
        if memoryHeap.flags & .DEVICE_LOCAL_BIT {
            if memoryHeap.size < selector.criteria.requiredMemSize {
                return .No;
            } else if memoryHeap.size < selector.criteria.desiredMemSize {
                suitable = .Partial;
            }
        }
    }
    
    return suitable;
}

select_impl :: (selector : *PhysicalDeviceSelector, selection : PhysicalDeviceSelectionMode) -> [..] PhysicalDevice, PhysicalDeviceError {
    // Validation
    for selector.criteria.extendedFeaturesChain {
        assert(it.sType != 0, "Features struct sType must be filled with the struct's corresponding VkStructureType enum");
        assert(it.sType != .PHYSICAL_DEVICE_FEATURES_2, "Do not pass VkPhysicalDeviceFeatures2 as a required extension feature structure. An instance of this is managed internally for selection criteria and device creation.");
    }
    
    physDevices : [..] PhysicalDevice;
    
    if selector.criteria.requirePresent && !selector.criteria.deferSurfaceInitialisation && selector.surface == VK_NULL_HANDLE {
        return physDevices, .No_Surface_Provided;
    }
    
    vkPhysDevices : [..] VkPhysicalDevice;
    physDeviceCount : u32;
    if vkEnumeratePhysicalDevices(selector.instance, *physDeviceCount, null) != .SUCCESS return physDevices, .Failed_To_Enumerate_Physical_Devices;
    if physDeviceCount == 0 then return physDevices, .No_Physical_Devices_Found;
    array_resize(*vkPhysDevices, physDeviceCount);
    vkEnumeratePhysicalDevices(selector.instance, *physDeviceCount, vkPhysDevices.data);
    
    fill_physical_device_with_criteria :: (selector : *PhysicalDeviceSelector, physicalDevice : *PhysicalDevice) {
        physicalDevice.features = selector.criteria.requiredFeatures;
        physicalDevice.extendedFeaturesChain = selector.criteria.extendedFeaturesChain;
        
        portabilityEXTAvailable := false;
        for physicalDevice.availableExtensions {
            if selector.criteria.enablePortabilitySubset && compare(it, PORTABILITY_EXT_NAME) == 0 {
                portabilityEXTAvailable = true;
                break;
            }
        }
        
        desiredExtensionsSupported := check_extension_support(physicalDevice.availableExtensions, selector.criteria.desiredExtensions);
        
        array_reset(*physicalDevice.extensionsToEnable);
        array_add(*physicalDevice.extensionsToEnable, ..selector.criteria.requiredExtensions);
        array_add(*physicalDevice.extensionsToEnable, ..desiredExtensionsSupported);
        if portabilityEXTAvailable {
            array_add_if_unique(*physicalDevice.extensionsToEnable, PORTABILITY_EXT_NAME);
        }
    }
    
    if selector.criteria.useFirstGPUUnconditionally && vkPhysDevices.count {
        physDevice := populate_device_details(selector, vkPhysDevices[0], selector.criteria.extendedFeaturesChain);
        fill_physical_device_with_criteria(selector, *physDevice);
    
        unconditonalPhysDevices : [..] PhysicalDevice;
        array_add(*unconditonalPhysDevices, physDevice);
        return unconditonalPhysDevices, .Success;
    }
    
    for vkPhysDevices {
        physDevice := populate_device_details(selector, it, selector.criteria.extendedFeaturesChain);
        physDevice.suitable = is_device_suitable(selector, *physDevice);
        if physDevice.suitable != .No then array_add(*physDevices, physDevice);
    }
    
    suitablePhysDevices : [..] PhysicalDevice;
    if selection == .Only_Fully_Suitable {
        for physDevices {
            if it.suitable == .Yes then array_add(*suitablePhysDevices, it);
        }
    } else {
        suitablePhysDevices = physDevices;
    }
    
    for * suitablePhysDevices {
        fill_physical_device_with_criteria(selector, it);
    }
    
    return suitablePhysDevices, .Success;
}

select :: (selector : *PhysicalDeviceSelector, selection := PhysicalDeviceSelectionMode.Partially_And_Fully_Suitable) -> PhysicalDevice, PhysicalDeviceError {
    selectedDevices, selectionError := select_impl(selector, selection);
    
    if selectedDevices.count == 0 then selectionError = .No_Suitable_Device;
    if selectionError then return .{}, selectionError;
    
    return selectedDevices[0], .Success;
}

select_devices :: (selector : *PhysicalDeviceSelector, selection := PhysicalDeviceSelectionMode.Partially_And_Fully_Suitable) -> [..] PhysicalDevice, PhysicalDeviceError {
    selectedDevices, selectionError := select_impl(selector, selection);
    
    if selectedDevices.count == 0 then selectionError = .No_Suitable_Device;
    if selectionError then return selectedDevices, selectionError;
    
    return selectedDevices, .Success;
}

select_device_names :: (selector : *PhysicalDeviceSelector, selection := PhysicalDeviceSelectionMode.Partially_And_Fully_Suitable) -> [..] string, PhysicalDeviceError {
    selectedDevices, selectionError := select_impl(selector, selection);
    
    if selectedDevices.count == 0 then selectionError = .No_Suitable_Device;
    if selectionError then return selectedDevices, selectionError;
    
    names : [..] string;
    for selectedDevices {
        array_add(*names, it.name);
    }
    
    return names, .Success;
}