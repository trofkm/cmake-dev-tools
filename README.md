# CMake Dev tools

Set of tools to make the development easier.

## clang-dev-tools

Adds clang-format and clang-tidy targets to the project.

Example:

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

`CPP_EXTENSIONS` - extensions of cpp files.

`USE_GLOB_RECURSIVE` - whether to use glob recursive (DEFAULT: ON).


By default, it takes `.clang-format` and `.clang-tidy` from the root dir of the project.


I found this script useful for checking code style on CI and one-click formatting from the IDE.