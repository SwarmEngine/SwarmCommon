###############################################################
# OPTIONS
###############################################################

# Build Type
if(LIBRARY_BUILD_TYPE)
    set (LIBRARY_BUILD_TYPE ${LIBRARY_BUILD_TYPE} CACHE STRING "How to build the engine <STATIC/MODULE_DYNAMIC/FULL_DYNAMIC>")
else()
    set (LIBRARY_BUILD_TYPE MODULE_DYNAMIC CACHE STRING "How to build the engine <STATIC/MODULE_DYNAMIC/FULL_DYNAMIC>")
endif()
set_property(CACHE LIBRARY_BUILD_TYPE PROPERTY STRINGS STATIC MODULE_DYNAMIC FULL_DYNAMIC)



###############################################################
# SETUP CONFIGURATION
###############################################################

# Output Directories
set (CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set (CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set (CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# Retrieve Build Type
if(LIBRARY_BUILD_TYPE STREQUAL "STATIC")
    set(ENGINE_BUILD_TYPE STATIC)
    set(MODULE_BUILD_TYPE STATIC)
elseif(LIBRARY_BUILD_TYPE STREQUAL "FULL_DYNAMIC")
    set(ENGINE_BUILD_TYPE SHARED)
    set(MODULE_BUILD_TYPE SHARED)
else()
    set(ENGINE_BUILD_TYPE STATIC)
    set(MODULE_BUILD_TYPE SHARED)
endif()

if(NOT ENGINE_INSTALL_LOCATION)
    set(ENGINE_INSTALL_LOCATION ${CMAKE_SOURCE_DIR}/engine)
endif(NOT ENGINE_INSTALL_LOCATION)

if(NOT EXTERNAL_INSTALL_LOCATION)
    set(EXTERNAL_INSTALL_LOCATION ${CMAKE_SOURCE_DIR}/external)
endif(NOT EXTERNAL_INSTALL_LOCATION)

include(ExternalProject)
find_package(Git REQUIRED)

set(CurrentPackageDependencies)
set(CurrentPackageSources)



###############################################################
# FUNCTIONS
###############################################################

# Swarm Package Add Function
function(SwarmAddPackageDependency Name)
    ExternalProject_Add("Swarm${Name}"
            PREFIX "Swarm${Name}"
            GIT_REPOSITORY "https://github.com/SwarmEngine/Swarm${Name}"
            UPDATE_COMMAND ${GIT_EXECUTABLE} pull
            CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${ENGINE_INSTALL_LOCATION}
    )
    set(CurrentPackageDependencies ${CurrentPackageDependencies} "Swarm${Name}" PARENT_SCOPE)
endfunction(SwarmAddPackageDependency)

# External Dependency Add Function
function(SwarmAddExternalDependency Name GitRepository)
    ExternalProject_Add(${Name}
            PREFIX ${Name}
            GIT_REPOSITORY ${GitRepository}
            UPDATE_COMMAND ${GIT_EXECUTABLE} pull
            CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${EXTERNAL_INSTALL_LOCATION}
    )
    set(CurrentPackageDependencies ${CurrentPackageDependencies} ${Name} PARENT_SCOPE)
endfunction(SwarmAddExternalDependency)

# Sources Add Function
function(SwarmAddSources Sources)
    set(CurrentPackageSources ${CurrentPackageSources} ${ARGV} PARENT_SCOPE)
endfunction(SwarmAddSources)

# Package Definition Function
function(SwarmDefinePackage Name Major Minor)

    # Versioning
    if(ARGV3)
        set(Patch ${ARGV3})
    else(ARGV3)
        set(Patch 0)
    endif(ARGV3)
    if(ARGV4)
        set(Extra ${ARGV4})
    else(ARGV4)
        set(Extra "")
    endif(ARGV4)
    set(Swarm${Name}_VERSION_MAJOR ${Major} PARENT_SCOPE)
    set(Swarm${Name}_VERSION_MINOR ${Minor} PARENT_SCOPE)
    set(Swarm${Name}_VERSION_PATCH ${Patch} PARENT_SCOPE)
    set(Swarm${Name}_VERSION_EXTRA ${Extra} PARENT_SCOPE)
    set(Swarm${Name}_VERSION "${Major}.${Minor}" PARENT_SCOPE)
    set(FullVersionTemp "${Major}.${Minor}.${Patch}${Extra}")
    set(Swarm${Name}_VERSION_FULL ${FullVersionTemp} PARENT_SCOPE)
    message(STATUS "Swarm${Name} Package Version: ${FullVersionTemp}")

    # Definition
    message(STATUS "Sources: ${CurrentPackageSources}")
    add_library(Swarm${Name} ${ENGINE_BUILD_TYPE} ${CurrentPackageSources})
    target_link_libraries(Swarm${Name} ${CurrentPackageDependencies})

endfunction(SwarmDefinePackage)
