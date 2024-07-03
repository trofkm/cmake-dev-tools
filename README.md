# CMake Dev tools

Set of tools to make the development easier.

## clang-dev-tools

Adds clang-format and clang-tidy targets to the project.

**Example:**

```cmake
include(clang-cxx-dev-tools)
add_dev_tools_targets(
        CPP_SEARCH_PATHS ${PROJECT_SOURCE_DIR}/src
        CPP_EXTENSIONS ".cpp" ".h"
        USE_GLOB_RECURSIVE ON
)
```

**Arguments**

`CPP_SEARCH_PATHS` - paths to search for cpp sources and headers.

`CPP_EXTENSIONS` - extensions of cpp sources and headers.

`USE_GLOB_RECURSIVE` - whether to use glob recursive (DEFAULT: ON).

`TARGET_NAME_PREFIX` - prefix for target names (DEFAULT: "${PROJECT_NAME}").

**Description**

After adding the targets, the project will have the following targets:

- `${TARGET_NAME_PREFIX}-clang-format` - runs clang-format on the source files.
- `${TARGET_NAME_PREFIX}-clang-tidy` - runs clang-tidy on the source files.

By default, it takes `.clang-format` and `.clang-tidy` from the root dir of the project.

I found this script useful for checking code style on CI and one-click formatting from the IDE.


## message

Adds cmake macros for beautiful messages.

**Example:**

```cmake
include(message)
add_subdir_with_message("foo")
# prints "======= SUBDIRECTORY: FOO ======="

begin_header(cmake)
begin_header(is)
begin_header(awesome)
begin_header(isn't)
begin_header(it.)
begin_header(Amount)
begin_header(of)
begin_header(tabs)
begin_header(increases.)
end_header()
end_header()
end_header()
end_header()
end_header()
end_header()
end_header()
end_header()
# prints:
# ======= CMAKE =======
# **** is ****
# --- awesome ---
#    isn't
#     it.
#      Amount
#       of
#        tabs
#         increases.

h1(H1)
h2(H2)
h3(H3)
# prints:
# ======= H1 =======
# **** H2 ****
# --- H3 ---
```

## setup-project

Sets up `ccache`, `ninja` and some optimizations for the project.

Include it after `project` declaration.

## pkg-build-config

Create pkg config for the targets.


**Example:**

```cmake
include(pkg-build-config)
pkg_build_config(NAME "lib${LIBGIT2_FILENAME}"
	VERSION ${libgit2_VERSION}
	DESCRIPTION "The git library, take 2"
	LIBS_SELF ${LIBGIT2_FILENAME}
	PRIVATE_LIBS ${LIBGIT2_PC_LIBS}
	REQUIRES ${LIBGIT2_PC_REQUIRES})
```


## ide-split-sources

Splits the source files up into their appropriate subdirectories.