cmake_minimum_required(VERSION 3.16)
project(openomd VERSION 1.2.3 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Build options
option(BUILD_TESTS "Build tests" ON)
option(BUILD_TOOLS "Build tools" ON)
option(BUILD_SHARED_LIBS "Build shared libraries" OFF)

# Set default build type
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

# Compiler flags
if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    set(CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDEBUG")
    set(CMAKE_CXX_FLAGS_DEBUG "-O0 -g -fprofile-arcs -ftest-coverage")
    add_compile_options(-pthread)
endif()

if(WIN32)
    add_definitions(-D_ENABLE_ATOMIC_ALIGNMENT_FIX -DNOMINMAX)
    if(MSVC)
        add_compile_options(/FS)
    endif()
endif()

# Include third-party libraries
include(third_party/ThirdPartyConfig.cmake)

# Add subdirectories
add_subdirectory(openomd_handler)

if(BUILD_TESTS)
    enable_testing()
    add_subdirectory(openomd_test)
endif()

if(BUILD_TOOLS)
    add_subdirectory(openomd_tools)
endif()

# Install configuration
include(GNUInstallDirs)

install(EXPORT openomd-targets
    FILE openomd-targets.cmake
    NAMESPACE openomd::
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/openomd)

configure_file(cmake/openomd-config.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/openomd-config.cmake
    @ONLY)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/openomd-config.cmake
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/openomd)