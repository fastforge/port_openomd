# OpenOMD Handler Library

# Create header-only library since this is mostly header files
add_library(openomd_handler INTERFACE)

# Include directories
target_include_directories(openomd_handler INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src/main/include>
    $<INSTALL_INTERFACE:include>
)

# Link libraries
target_link_libraries(openomd_handler INTERFACE
    ThirdParty::PCAP
)

if(UNIX)
    target_link_libraries(openomd_handler INTERFACE pthread dl)
elseif(WIN32)
    target_link_libraries(openomd_handler INTERFACE Ws2_32)
endif()

# Install targets
install(TARGETS openomd_handler
    EXPORT openomd-targets
)

# Install headers
install(DIRECTORY src/main/include/
    DESTINATION include
    FILES_MATCHING PATTERN "*.h"
)