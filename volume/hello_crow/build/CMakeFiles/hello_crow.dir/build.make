# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.18

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Disable VCS-based implicit rules.
% : %,v


# Disable VCS-based implicit rules.
% : RCS/%


# Disable VCS-based implicit rules.
% : RCS/%,v


# Disable VCS-based implicit rules.
% : SCCS/s.%


# Disable VCS-based implicit rules.
% : s.%


.SUFFIXES: .hpux_make_needs_suffix_list


# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /usr/src/cppweb/hello_crow

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /usr/src/cppweb/hello_crow/build

# Include any dependencies generated for this target.
include CMakeFiles/hello_crow.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/hello_crow.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/hello_crow.dir/flags.make

CMakeFiles/hello_crow.dir/main.cpp.o: CMakeFiles/hello_crow.dir/flags.make
CMakeFiles/hello_crow.dir/main.cpp.o: ../main.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/usr/src/cppweb/hello_crow/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/hello_crow.dir/main.cpp.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/hello_crow.dir/main.cpp.o -c /usr/src/cppweb/hello_crow/main.cpp

CMakeFiles/hello_crow.dir/main.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/hello_crow.dir/main.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /usr/src/cppweb/hello_crow/main.cpp > CMakeFiles/hello_crow.dir/main.cpp.i

CMakeFiles/hello_crow.dir/main.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/hello_crow.dir/main.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /usr/src/cppweb/hello_crow/main.cpp -o CMakeFiles/hello_crow.dir/main.cpp.s

# Object files for target hello_crow
hello_crow_OBJECTS = \
"CMakeFiles/hello_crow.dir/main.cpp.o"

# External object files for target hello_crow
hello_crow_EXTERNAL_OBJECTS =

hello_crow: CMakeFiles/hello_crow.dir/main.cpp.o
hello_crow: CMakeFiles/hello_crow.dir/build.make
hello_crow: /usr/lib/aarch64-linux-gnu/libboost_system.so.1.74.0
hello_crow: /usr/lib/aarch64-linux-gnu/libboost_filesystem.so.1.74.0
hello_crow: CMakeFiles/hello_crow.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/usr/src/cppweb/hello_crow/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable hello_crow"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/hello_crow.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/hello_crow.dir/build: hello_crow

.PHONY : CMakeFiles/hello_crow.dir/build

CMakeFiles/hello_crow.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/hello_crow.dir/cmake_clean.cmake
.PHONY : CMakeFiles/hello_crow.dir/clean

CMakeFiles/hello_crow.dir/depend:
	cd /usr/src/cppweb/hello_crow/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /usr/src/cppweb/hello_crow /usr/src/cppweb/hello_crow /usr/src/cppweb/hello_crow/build /usr/src/cppweb/hello_crow/build /usr/src/cppweb/hello_crow/build/CMakeFiles/hello_crow.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/hello_crow.dir/depend

