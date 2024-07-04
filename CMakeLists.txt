#
# Author: Kirill Trofimov
# Email: k.trofimov@geoscan.ru
# Date: 04.07.24
#
# TODO: I do not know if this one can broke an actual project
#cmake_minimum_required(VERSION 3.15)
#
#project(cmake-dev-tools)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake" CACHE INTERNAL "CMake modules path")
