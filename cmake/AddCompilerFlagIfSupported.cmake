include(CheckCCompilerFlag)

macro(add_c_flag _FLAG)
    string(TOUPPER ${_FLAG} UPCASE)
    string(REGEX REPLACE "[-=]" "_" UPCASE_PRETTY ${UPCASE})
    string(REGEX REPLACE "^_+" "" UPCASE_PRETTY ${UPCASE_PRETTY})
    check_c_compiler_flag(${_FLAG} IS_${UPCASE_PRETTY}_SUPPORTED)

    if (IS_${UPCASE_PRETTY}_SUPPORTED)
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${_FLAG}")
    else ()
        message(FATAL_ERROR "Required flag ${_FLAG} is not supported")
    endif ()
endmacro()

# - Append compiler flag to CMAKE_C_FLAGS if compiler supports it
# ADD_C_FLAG_IF_SUPPORTED(<flag>)
#  <flag> - the compiler flag to test
# This internally calls the CHECK_C_COMPILER_FLAG macro.
macro(add_c_flag_if_supported _FLAG)
    string(TOUPPER ${_FLAG} UPCASE)
    string(REGEX REPLACE "[-=]" "_" UPCASE_PRETTY ${UPCASE})
    string(REGEX REPLACE "^_+" "" UPCASE_PRETTY ${UPCASE_PRETTY})
    check_c_compiler_flag(${_FLAG} IS_${UPCASE_PRETTY}_SUPPORTED)

    if (IS_${UPCASE_PRETTY}_SUPPORTED)
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${_FLAG}")
    endif ()
endmacro()

include(CheckCXXCompilerFlag)


macro(add_cxx_flag _FLAG)
    string(TOUPPER ${_FLAG} UPCASE)
    string(REGEX REPLACE "[-=]" "_" UPCASE_PRETTY ${UPCASE})
    string(REGEX REPLACE "^_+" "" UPCASE_PRETTY ${UPCASE_PRETTY})
    check_cxx_compiler_flag(${_FLAG} IS_${UPCASE_PRETTY}_SUPPORTED)

    if (IS_${UPCASE_PRETTY}_SUPPORTED)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${_FLAG}")
    else ()
        message(FATAL_ERROR "Required flag ${_FLAG} is not supported")
    endif ()
endmacro()

# - Append compiler flag to CMAKE_CXX_FLAGS if compiler supports it
# ADD_CXX_FLAG_IF_SUPPORTED(<flag>)
#  <flag> - the compiler flag to test
# This internally calls the CHECK_CXX_COMPILER_FLAG macro.
macro(add_cxx_flag_if_supported _FLAG)
    string(TOUPPER ${_FLAG} UPCASE)
    string(REGEX REPLACE "[-=]" "_" UPCASE_PRETTY ${UPCASE})
    string(REGEX REPLACE "^_+" "" UPCASE_PRETTY ${UPCASE_PRETTY})
    check_cxx_compiler_flag(${_FLAG} IS_${UPCASE_PRETTY}_SUPPORTED)

    if (IS_${UPCASE_PRETTY}_SUPPORTED)
        set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS} ${_FLAG}")
    endif ()
endmacro()