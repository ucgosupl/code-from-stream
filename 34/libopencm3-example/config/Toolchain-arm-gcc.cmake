# System Generic - no OS bare-metal application
set(CMAKE_SYSTEM_NAME Generic)

# Setup arm processor and bleeding edge toolchain
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER arm-none-eabi-g++)
set(CMAKE_ASM_COMPILER arm-none-eabi-gcc)
set(CMAKE_LINKER arm-none-eabi-ld)
set(CMAKE_AR arm-none-eabi-ar)
set(CMAKE_OBJCOPY arm-none-eabi-objcopy)
set(CMAKE_OBJDUMP arm-none-eabi-objdump)
set(CMAKE_NM arm-none-eabi-nm)
set(CMAKE_STRIP arm-none-eabi-strip)
set(CMAKE_SIZE arm-none-eabi-size)
set(CMAKE_RANLIB arm-none-eabi-ranlib)

# When trying to link cross compiled test program, error occurs, so setting test compilation to static library
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# Don't know if following setting works also for Ninja
set(CMAKE_VERBOSE_MAKEFILE ON)

# Remove default static libraries for win32
set(CMAKE_C_STANDARD_LIBRARIES "")

set(CORE_FLAGS "-nostartfiles -Wno-psabi --specs=nosys.specs -mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16 -ffast-math")

set(CMAKE_C_FLAGS                   " ${CORE_FLAGS} -ffunction-sections -fdata-sections -fverbose-asm -MMD -Wall -Wextra -Wstrict-prototypes" CACHE INTERNAL "")
set(CMAKE_CXX_FLAGS                 "${CMAKE_C_FLAGS} -fno-rtti -fno-exceptions" CACHE INTERNAL "")
set(CMAKE_ASM_FLAGS                 "${CORE_FLAGS} -x assembler-with-cpp" CACHE INTERNAL "")

set(LD_FLAGS "-Wl,-Map=\"${PROJECT_BINARY_DIR}/${CMAKE_PROJECT_NAME}.map\",--cref")

set(CMAKE_EXE_LINKER_FLAGS ${LD_FLAGS})

set(CMAKE_C_FLAGS_DEBUG             "-Og -g" CACHE INTERNAL "")
set(CMAKE_C_FLAGS_RELEASE           "-Os -DNDEBUG" CACHE INTERNAL "")
set(CMAKE_CXX_FLAGS_DEBUG           "${CMAKE_C_FLAGS_DEBUG}" CACHE INTERNAL "")
set(CMAKE_CXX_FLAGS_RELEASE         "${CMAKE_C_FLAGS_RELEASE}" CACHE INTERNAL "")

set(CMAKE_EXECUTABLE_SUFFIX_C   .elf)
set(CMAKE_EXECUTABLE_SUFFIX_CXX .elf)
set(CMAKE_EXECUTABLE_SUFFIX_ASM .elf)

function(stm32_add_linker_script TARGET VISIBILITY SCRIPT)
    get_filename_component(SCRIPT "${SCRIPT}" ABSOLUTE)
    target_link_options(${TARGET} ${VISIBILITY} -T "${SCRIPT}")
endfunction()
