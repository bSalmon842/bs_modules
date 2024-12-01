/*
Module: BS842 Map Array
File: module.jai
Author: Brock Salmon
Created: 25APR2024
Last Edit: 26APR2024
*/

Map_Array :: struct (T : Type) {
    array : [..] T;
    names : [..] string;
}

// Unlike std::map in C++, you cannot add to the map via the [] operator
operator [] :: (using map : Map_Array($T), name : string) -> T {
    assert(array.count == names.count, "Map internal sizes have become mismatched!");
    result : *T = null;
    for names {
        if compare(it, name) == 0 {
            result.* = array[it_index];
            break;
        }
    }
    
    // TODO: There's probably a better way to handle this than straight up asserting
    assert(result != null, "Failed to find % in Map_Array", name);
    return result.*;
}

map_add :: (using map : *Map_Array($T), name : string, value : T) {
    assert(array.count == names.count, "Map internal sizes have become mismatched!");
    
    for names {
        assert(compare(it, name) != 0, "Item with name % already exists in the Map", name);
    }
    
    array_add(*array, value);
    array_add(*names, name);
}

map_reset :: (using map : *Map_Array($T)) {
    array_reset(array);
    array_reset(names);
}

#scope_module
#import "Basic";
#import "String";
