cmake_minimum_required(VERSION 3.13)

project(hello_crow)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)

# Add the path to Boost headers
#find_package(Boost REQUIRED)
#include_directories(${Boost_INCLUDE_DIRS})

find_package(Boost COMPONENTS system filesystem REQUIRED)
find_package(Threads)

include_directories(${Boost_INCLUDE_DIRS})
# Add source files and create executable
add_executable(hello_crow main.cpp)
target_link_libraries(hello_crow ${Boost_LIBRARIES} Threads::Threads)