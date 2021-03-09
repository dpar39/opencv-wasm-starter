cmake_minimum_required(VERSION 3.16)
set(MODULE_NAME demo)
project(${MODULE_NAME})

string(TOLOWER ${CMAKE_BUILD_TYPE} BUILD_CONFIG_LOWER)

string(TOLOWER ${CMAKE_BUILD_TYPE} BUILD_CONFIG_LOWER)
set(BUILD_NAME_SUFFIX ${BUILD_PLATFORM}_${BUILD_CONFIG_LOWER})

set(THIRD_PARTY_INSTALL_DIR ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/install_${BUILD_NAME_SUFFIX})

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 17)

if(MSVC)
    add_definitions(-D_CRT_SECURE_NO_WARNINGS)
else()
    find_program(CCACHE_FOUND ccache)
    if(CCACHE_FOUND)
        set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ccache)
    endif()
endif()

set(OpenCV_STATIC ON)
set(OpenCV_DIR ${THIRD_PARTY_INSTALL_DIR}/lib/cmake/opencv4)
find_package(OpenCV REQUIRED)

if(EMSCRIPTEN)
    set(PRE_POST "--pre-js ${CMAKE_CURRENT_SOURCE_DIR}/src/pre.js --post-js ${CMAKE_CURRENT_SOURCE_DIR}/src/post.js")
    set(PRE_POST "")
    set(EM_FLAGS "${PRE_POST} --bind -std=c++17 -s TOTAL_MEMORY=134217728 -s USE_PTHREADS=1 -s DISABLE_EXCEPTION_CATCHING=0")
    if (${BUILD_CONFIG_LOWER} MATCHES "debug")
        message("Building in debug mode")
        set(EM_FLAGS "${EM_FLAGS} -g --source-map-base http://127.0.0.1:5500/example/ -s DISABLE_EXCEPTION_CATCHING=0")
    else()
        message("Building in release mode")
        set(EM_FLAGS "${EM_FLAGS} -Os -flto")
    endif()
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${EM_FLAGS}")
    foreach(FLAG_VAR CMAKE_CXX_FLAGS CMAKE_CXX_FLAGS_DEBUG CMAKE_CXX_FLAGS_RELEASE CMAKE_CXX_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_RELWITHDEBINFO)
        if(${FLAG_VAR} MATCHES "-g")
            string(REGEX REPLACE "-g" "-g4" ${FLAG_VAR} "${${FLAG_VAR}}")
        endif()
    endforeach()
else()  
    message(STATUS "Compiling native C++")
endif()
message(STATUS CMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS})


#-----------------------------
# Build the module library
#-----------------------------
file(GLOB LIB_CPP_FILES "src/*.cpp")
set(LIB_SRC_FILES ${LIB_C_FILES} ${LIB_CPP_FILES})

include_directories(${CMAKE_CURRENT_SOURCE_DIR} ${OpenCV_INCLUDE_DIRS})
add_executable(${MODULE_NAME} ${LIB_SRC_FILES})
target_link_libraries(${MODULE_NAME} ${OpenCV_LIBRARIES} ${OPENCV_3RDPARTY_LIBS})

message(STATUS "-------- Finished configuring CMake for module ${MODULE_NAME} --------")