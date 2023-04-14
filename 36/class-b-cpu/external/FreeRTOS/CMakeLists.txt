cmake_minimum_required(VERSION 3.14)

set(FREERTOS_CONFIG_FILE_DIRECTORY "${PROJECT_SOURCE_DIR}" CACHE STRING "")

include(FetchContent)
FetchContent_Declare(freertos_kernel
  GIT_REPOSITORY        https://github.com/FreeRTOS/FreeRTOS-Kernel.git
  GIT_TAG               V10.5.1
#  FETCHCONTENT_QUIET    OFF
  SOURCE_DIR            ${CMAKE_SOURCE_DIR}/external/FreeRTOS/src
  BINARY_DIR            ${CMAKE_SOURCE_DIR}/external/FreeRTOS/bin
)

set(FREERTOS_HEAP "4" CACHE STRING "" FORCE)
set(FREERTOS_PORT "GCC_ARM_CM4F" CACHE STRING "" FORCE)

FetchContent_MakeAvailable(freertos_kernel)
