#
# Author: Kirill Trofimov
# Email: k.trofimov@geoscan.ru
# Date: 05.12.23
#
# To the extent possible under law, the author(s) have dedicated all
# copyright and related and neighboring rights to this software to the
# public domain worldwide. This software is distributed without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication
# along with this software. If not, see
#
#     http://creativecommons.org/publicdomain/zero/1.0/
#
########################################################################

# This file defines a targets to perform clang-format and clang-tidy.
# Here are the primary arguments that control script behavior:
#
#   CPP_SEARCH_PATHS
#   -- The paths to search for C++ source files.
#   -- Defaults to ${PROJECT_SOURCE_DIR} and ${PROJECT_SOURCE_DIR}/src.
#
#   CPP_EXTENSIONS
#   -- The file extensions to search for.
#
#   TARGET_NAME_PREFIX
#   -- The prefix to use for the target names.
#   -- Defaults to "${PROJECT_NAME}-clang-format" and "${PROJECT_NAME}-clang-tidy" if not specified.
#
#   USE_GLOB_RECURSIVE
#   -- Whether to use glob_recursive to search for C++ source files.
#      Defaults to false.
#
#
# EXAMPLE
#
#
#   include(clang-cxx-dev-tools)
#   add_dev_tools_targets(
#       CPP_SEARCH_PATHS ${PROJECT_SOURCE_DIR}/src
#       CPP_EXTENSIONS ".cpp" ".h"
#       USE_GLOB_RECURSIVE ON
#   )
#
macro(add_dev_tools_targets)
    set(options USE_GLOB_RECURSIVE)
    set(oneValueArgs TARGET_NAME_PREFIX)
    set(multiValueArgs CPP_SEARCH_PATHS CPP_EXTENSIONS)
    set(_default_cpp_extensions ".cpp" ".cxx" ".cc" ".C" ".h" ".H" ".hh" ".hxx" ".hpp")

    cmake_parse_arguments(DEV_TOOLS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    if (NOT DEV_TOOLS_CPP_SEARCH_PATHS)
        message(WARNING "No CPP_SEARCH_PATHS specified. Using default: ${PROJECT_SOURCE_DIR}")
        set(DEV_TOOLS_CPP_SEARCH_PATHS ${PROJECT_SOURCE_DIR})
    endif ()
    if (NOT DEV_TOOLS_CPP_EXTENSIONS)
        #        message(WARNING "No CPP_EXTENSIONS specified. Using default: ${_default_cpp_extensions}")
        set(DEV_TOOLS_CPP_EXTENSIONS ${_default_cpp_extensions})
    endif ()
    if (NOT DEV_TOOLS_TARGET_NAME_PREFIX)
        set(DEV_TOOLS_TARGET_NAME_PREFIX ${PROJECT_NAME})
    endif ()

    set(_cpp_search_paths_regex)
    foreach (ext ${DEV_TOOLS_CPP_EXTENSIONS})
        foreach (dir ${DEV_TOOLS_CPP_SEARCH_PATHS})
            list(APPEND _cpp_search_paths_regex "${dir}/*${ext}")
        endforeach ()
    endforeach ()


    message(STATUS "Searching for C++ source files in ${_cpp_search_paths_regex}")
    set(_all_cxx_source_files)

    foreach (path ${_cpp_search_paths_regex})
        if (_use_glob_recursive)

            file(GLOB_RECURSE
                    _found_cxx_files
                    ${path}
            )
        else ()
            file(GLOB
                    _found_cxx_files
                    ${path}
            )
        endif ()
        if (_found_cxx_files)
            list(APPEND _all_cxx_source_files ${_found_cxx_files})
        endif ()
    endforeach ()

    list(REMOVE_DUPLICATES _all_cxx_source_files)


    message(STATUS "Found ${_all_cxx_source_files} C++ source files")

    # Adding clang-format target if executable is found
    find_program(CLANG_FORMAT "clang-format")
    if (CLANG_FORMAT)
        add_custom_target(
                ${DEV_TOOLS_TARGET_NAME_PREFIX}-clang-format
                COMMAND clang-format
                -i
                -style=file
                ${_all_cxx_source_files}
        )
    endif ()

    # Adding clang-tidy target if executable is found
    find_program(CLANG_TIDY "clang-tidy")
    if (CLANG_TIDY)
        add_custom_target(
                ${DEV_TOOLS_TARGET_NAME_PREFIX}-clang-tidy
                COMMAND clang-tidy
                -config-file=${PROJECT_SOURCE_DIR}/.clang-tidy
                ${_all_cxx_source_files}
        )
    endif ()
endmacro()