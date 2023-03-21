cmake_minimum_required(VERSION 3.14)

set(CMAKE_C_STANDARD 99)
set(CMAKE_CXX_STANDARD 17)

set(CMAKE_TOOLCHAIN_FILE config/Toolchain-arm-gcc.cmake)

# Allow assembler
enable_language(ASM)

project(freertos-stack)

set(INCLUDE_DIRS
  .
   
  code
  hw
  utils

  external/stm32
  external/cmsis

  external/FreeRTOS/src/include
  external/FreeRTOS/src/portable/GCC/ARM_CM4F
)

set(C_SRCS
    main.c

    freertos_hooks.c

    hw/core_init/core_init.c
    hw/gpio_f4/gpio_f4.c
    hw/startup/hardfault.c
    hw/startup/vectors.c
	
    utils/syscalls.c

    external/FreeRTOS/src/croutine.c
    external/FreeRTOS/src/event_groups.c
    external/FreeRTOS/src/list.c
    external/FreeRTOS/src/queue.c
    external/FreeRTOS/src/stream_buffer.c
    external/FreeRTOS/src/tasks.c
    external/FreeRTOS/src/timers.c
    external/FreeRTOS/src/portable/GCC/ARM_CM4F/port.c
    external/FreeRTOS/src/portable/MemMang/heap_4.c
)

set(ASM_SRCS
    hw/startup/startup.S
)

set(GLOBAL_DEFINES
    -DSTM32F40_41xxx
)



include_directories(${INCLUDE_DIRS})
add_definitions(${GLOBAL_DEFINES})

include(config/compiler_flags.cmake)

# generate elf file
add_arm_executable(${CMAKE_PROJECT_NAME} ${C_SRCS} ${ASM_SRCS})
