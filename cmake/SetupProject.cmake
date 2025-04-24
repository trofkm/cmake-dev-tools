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

# Link what you use
set(LINK_WHAT_YOU_USE TRUE)

# Compiler warnings
# I'm not using -Werror because sometimes it breaks everything
add_compile_options(-Wpedantic -Wall -Wextra)

# Include what you use
# https://stackoverflow.com/questions/30951492/how-can-i-use-the-tool-include-what-you-use-together-with-cmake-to-detect-unus
macro(enable_include_what_you_use)
    find_program(iwyu_path NAMES include-what-you-use iwyu REQUIRED)
    set(CMAKE_CXX_INCLUDE_WHAT_YOU_USE "${iwyu_path}")
    set(CXX_INCLUDE_WHAT_YOU_USE TRUE)
    message(STATUS "Using include-what-you-use")
endmacro()

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

# Adds thread or address sanitizer depends on passed THREAD or ADDRESS value
# You should choose one. Cannot use both of them the same time.
#
# EXAMPLE
#
#	if (${CMAKE_BUILD_TYPE} STREQUAL "Debug")
#        enable_sanitizing(THREAD)
#   endif ()
#
macro(enable_sanitizing _sanitizer_type)
    # Check if the sanitizer type is valid
    if (NOT "${_sanitizer_type}" STREQUAL "THREAD" AND NOT "${_sanitizer_type}" STREQUAL "ADDRESS")
        message(FATAL_ERROR "Invalid sanitizer type: ${_sanitizer_type}. Must be THREAD or ADDRESS.")
    endif ()

    # Determine the appropriate sanitizer flag
    if ("${_sanitizer_type}" STREQUAL "THREAD")
        set(SANITIZER_FLAG "-fsanitize=thread")
    elseif ("${_sanitizer_type}" STREQUAL "ADDRESS")
        set(SANITIZER_FLAG "-fsanitize=address")
    endif ()

    # Check compiler type and add sanitizer flags
    if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        # GCC or Clang
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${SANITIZER_FLAG}")
        set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${SANITIZER_FLAG}")
        message(STATUS "Enabled ${_sanitizer_type} with flag: ${SANITIZER_FLAG}")
    elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
        # MSVC (only AddressSanitizer is supported)
        if ("${_sanitizer_type}" STREQUAL "THREAD")
            message(FATAL_ERROR "ThreadSanitizer is not supported by MSVC.")
        endif ()
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /fsanitize=address")
        message(STATUS "Enabled ${_sanitizer_type} with MSVC flag: /fsanitize=address")
    else ()
        message(FATAL_ERROR "Unsupported compiler: ${CMAKE_CXX_COMPILER_ID}. Sanitizers are only supported by GCC, Clang, and MSVC.")
    endif ()
endmacro()