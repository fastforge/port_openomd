# Third Party Libraries Configuration for OpenOMD

set(THIRD_PARTY_ROOT ${CMAKE_CURRENT_LIST_DIR})
set(THIRD_PARTY_INSTALL_PREFIX ${THIRD_PARTY_ROOT}/install)

# Set library and include paths
set(THIRD_PARTY_INCLUDE_DIRS ${THIRD_PARTY_INSTALL_PREFIX}/include)
set(THIRD_PARTY_LIBRARY_DIRS ${THIRD_PARTY_INSTALL_PREFIX}/lib)

# Boost
set(BOOST_ROOT ${THIRD_PARTY_INSTALL_PREFIX})
set(Boost_NO_SYSTEM_PATHS ON)
find_package(Boost 1.68.0 REQUIRED COMPONENTS system filesystem thread chrono date_time)

# zlib
find_library(ZLIB_LIBRARY NAMES libz.a z
    PATHS ${THIRD_PARTY_LIBRARY_DIRS}
    NO_DEFAULT_PATH)
if(ZLIB_LIBRARY)
    set(ZLIB_FOUND TRUE)
    set(ZLIB_LIBRARIES ${ZLIB_LIBRARY})
    set(ZLIB_INCLUDE_DIRS ${THIRD_PARTY_INCLUDE_DIRS})
endif()

# libpcap
find_library(PCAP_LIBRARY NAMES libpcap.a pcap
    PATHS ${THIRD_PARTY_LIBRARY_DIRS}
    NO_DEFAULT_PATH)
if(PCAP_LIBRARY)
    set(PCAP_FOUND TRUE)
    set(PCAP_LIBRARIES ${PCAP_LIBRARY})
    set(PCAP_INCLUDE_DIRS ${THIRD_PARTY_INCLUDE_DIRS})
endif()

# Google Test/Mock
find_package(GTest REQUIRED
    HINTS ${THIRD_PARTY_INSTALL_PREFIX})

# SBE (Simple Binary Encoding)
set(SBE_JAR ${THIRD_PARTY_ROOT}/sbe/sbe-all-1.7.4.jar)

# Create interface targets for easier usage
if(NOT TARGET ThirdParty::Boost)
    add_library(ThirdParty::Boost INTERFACE IMPORTED)
    target_link_libraries(ThirdParty::Boost INTERFACE ${Boost_LIBRARIES})
    target_include_directories(ThirdParty::Boost INTERFACE ${Boost_INCLUDE_DIRS})
endif()

if(ZLIB_FOUND AND NOT TARGET ThirdParty::ZLIB)
    add_library(ThirdParty::ZLIB INTERFACE IMPORTED)
    target_link_libraries(ThirdParty::ZLIB INTERFACE ${ZLIB_LIBRARIES})
    target_include_directories(ThirdParty::ZLIB INTERFACE ${ZLIB_INCLUDE_DIRS})
endif()

if(PCAP_FOUND AND NOT TARGET ThirdParty::PCAP)
    add_library(ThirdParty::PCAP INTERFACE IMPORTED)
    target_link_libraries(ThirdParty::PCAP INTERFACE ${PCAP_LIBRARIES})
    target_include_directories(ThirdParty::PCAP INTERFACE ${PCAP_INCLUDE_DIRS})
endif()

if(NOT TARGET ThirdParty::GTest)
    add_library(ThirdParty::GTest INTERFACE IMPORTED)
    target_link_libraries(ThirdParty::GTest INTERFACE GTest::gtest GTest::gtest_main GTest::gmock GTest::gmock_main)
endif()

message(STATUS "Third-party libraries configuration loaded")
message(STATUS "  Boost: ${Boost_FOUND}")
message(STATUS "  ZLIB: ${ZLIB_FOUND}")
message(STATUS "  PCAP: ${PCAP_FOUND}")
message(STATUS "  GTest: ${GTest_FOUND}")
message(STATUS "  SBE JAR: ${SBE_JAR}")