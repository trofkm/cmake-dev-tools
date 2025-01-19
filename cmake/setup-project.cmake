# Enable ccache
macro(enable_ccache)
    find_program(CCACHE_FOUND ccache)
    if (CCACHE_FOUND)
        set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ccache)
        set(CMAKE_C_COMPILER_LAUNCHER "ccache")
        set(CMAKE_CXX_COMPILER_LAUNCHER "ccache")
        message(STATUS "Using ccache")
    else ()
        message(WARNING "ccache isn't available, using the default system compiler.")
    endif (CCACHE_FOUND)
endmacro()

# Enable gold linker
macro(enable_gold_linker)
    if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
        execute_process(COMMAND ${CMAKE_CXX_COMPILER} -fuse-ld=gold -Wl,--version OUTPUT_VARIABLE stdout ERROR_QUIET)
        if ("${stdout}" MATCHES "GNU gold")
            set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -fuse-ld=gold")
            message(STATUS "Using GNU gold linker")
        else ()
            message(WARNING "GNU gold linker isn't available, using the default system linker.")
        endif ()
    endif ()
endmacro()

# Enable Ninja
macro(enable_ninja)
    find_program(NINJA_FOUND ninja)
    if (NINJA_FOUND)
        set(CMAKE_MAKE_PROGRAM "${NINJA_FOUND}")
        message(STATUS "Using Ninja")
    else ()
        message(WARNING "Ninja isn't available, using the default system generator.")
    endif ()
endmacro()

# Enable PIC
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# Enable Inter-procedural Optimization
macro(enable_ipo)
    include(CheckIPOSupported)
    check_ipo_supported(RESULT ipo_supported)
    if (ipo_supported)
        set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)
        message(STATUS "Using Inter-procedural Optimization")
    else ()
        message(WARNING "Inter-procedural Optimization isn't available")
    endif ()
endmacro()

# Prevent building in the source tree.
macro(disable_source_tree_build)

    if (${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR})
        message(FATAL_ERROR "
ERROR: CMake generation is not allowed within the source directory!

You *MUST* remove the CMakeCache.txt file and try again from another
directory:

   rm CMakeCache.txt
   mkdir build
   cd build
   cmake -G Ninja ..")
    endif ()
endmacro()