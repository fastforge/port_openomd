# OpenOMD Tools

# Collect source files
file(GLOB TOOLS_SOURCES
    "src/main/c/*.cpp"
    "src/main/c/*.hpp"
)

file(GLOB TOOLS_HEADERS
    "src/main/include/*.h"
)

# Create tools executable
add_executable(openomd_tools ${TOOLS_SOURCES} ${TOOLS_HEADERS})

# Include directories
target_include_directories(openomd_tools PRIVATE
    src/main/include
    ${CMAKE_SOURCE_DIR}/openomd_handler/src/main/include
)

# Link libraries
target_link_libraries(openomd_tools PRIVATE
    openomd_handler
    ThirdParty::Boost
    ThirdParty::ZLIB
)

# Install executable
install(TARGETS openomd_tools
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

# Install configuration files
install(DIRECTORY src/nar/resources/noarch/config/
    DESTINATION share/openomd/config
    FILES_MATCHING PATTERN "*.conf"
)