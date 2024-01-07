cmake_minimum_required(VERSION 3.13)

project(hello_crow)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)

# Add the path to Boost headers
#find_package(Boost REQUIRED)
#include_directories(${Boost_INCLUDE_DIRS})

find_package(Boost COMPONENTS system filesystem REQUIRED)
find_package(Threads REQUIRED)
find_package(libmongocxx REQUIRED)
find_package (libmongoc-1.0 REQUIRED)

message ("--   mongoc found version \"${MONGOC_VERSION}\"")
message ("--   mongoc include path \"${MONGOC_INCLUDE_DIRS}\"")
message ("--   mongoc libraries \"${MONGOC_LIBRARIES}\"")

add_executable(hello_crow main.cpp)
include_directories(${Boost_INCLUDE_DIRS})
target_include_directories(hello_crow PRIVATE ${Boost_INCLUDE_DIRS} ${LIBMONGOCXX_INCLUDE_DIRS})

# Specify the path to libmongocxx.so library
set(LIBMONGOCXX_LIBRARIES /usr/local/lib64/libmongocxx.so)
set(LIBBSONCXX_LIBRARIES /usr/local/lib64/libbsoncxx.so)

target_link_libraries(hello_crow ${Boost_LIBRARIES} Threads::Threads ${LIBMONGOCXX_LIBRARIES} ${LIBBSONCXX_LIBRARIES})