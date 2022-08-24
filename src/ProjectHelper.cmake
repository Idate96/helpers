#=============================================================================
# Copyright (C) 2018, Robotic Systems Lab, ETH Zurich
# All rights reserved.
# http://www.rsl.ethz.ch
# https://bitbucket.org/leggedrobotics
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================

macro(project_set_user_eigen EIGEN_PATH)
  set(EIGEN3_INCLUDE_DIR ${EIGEN_PATH})
endmacro()

macro(project_initialize CATKIN_WS_DEVEL_DIR)
  include_directories(${CATKIN_WS_DEVEL_DIR}/include)
  find_package(catkin REQUIRED) # Speeds up sourcing
endmacro()

macro(project_add_module MODULE)
  add_subdirectory(${MODULE})
  get_property(curr_hack_includes DIRECTORY ${MODULE} PROPERTY INCLUDE_DIRECTORIES)
  list(APPEND hack_includes ${curr_hack_includes})
endmacro()

macro(project_finalize)
  list(REMOVE_DUPLICATES hack_includes)
  foreach(dir ${hack_includes})
    if((NOT ${dir} MATCHES "^${CMAKE_CURRENT_LIST_DIR}/src") OR (NOT EXISTS ${dir}))
      list(REMOVE_ITEM hack_includes ${dir})
      if(NOT EXISTS ${dir})
        message(WARNING "Directory '${dir}' was included but does not exist. Please fix the corresponding CMakeLists.txt" )
      endif()
    endif()
  endforeach()
  add_library(lib_include_hack ${hack_includes} src/.include_hack.cpp )
endmacro()

# EOF
