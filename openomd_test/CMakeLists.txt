# OpenOMD Tests

# Collect test source files
file(GLOB TEST_SOURCES
    "src/test/c/*.cpp"
)

file(GLOB TEST_HEADERS
    "src/test/include/openomd/*.h"
)

# Create test executable
add_executable(openomd_test ${TEST_SOURCES} ${TEST_HEADERS})

# Include directories
target_include_directories(openomd_test PRIVATE
    src/test/include
    ${CMAKE_SOURCE_DIR}/openomd_handler/src/main/include
)

# Link libraries
target_link_libraries(openomd_test PRIVATE
    openomd_handler
    ThirdParty::GTest
    ThirdParty::ZLIB
)

# Add tests to CTest
add_test(NAME openomd_unit_tests COMMAND openomd_test)

# Set test properties
set_tests_properties(openomd_unit_tests PROPERTIES
    TIMEOUT 300
)