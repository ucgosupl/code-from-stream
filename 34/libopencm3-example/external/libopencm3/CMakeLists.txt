cmake_minimum_required(VERSION 3.14)

include(FetchContent)
FetchContent_Declare(libopencm3
  GIT_REPOSITORY        https://github.com/libopencm3/libopencm3
  GIT_TAG               de96f0f4aa626
#  FETCHCONTENT_QUIET    OFF
  SOURCE_DIR            ${CMAKE_SOURCE_DIR}/external/libopencm3/src
  BINARY_DIR            ${CMAKE_SOURCE_DIR}/external/libopencm3/bin
)

FetchContent_MakeAvailable(libopencm3)

set(LIBOPENCM3_PATH ${libopencm3_SOURCE_DIR})
set(STM32_PATH ${LIBOPENCM3_PATH}/lib/stm32)
set(COMMON_PATH ${STM32_PATH}/common)
set(F4_PATH ${STM32_PATH}/f4)

set (USB_PATH ${LIBOPENCM3_PATH}/lib/usb)
set (ETH_PATH ${LIBOPENCM3_PATH}/lib/ethernet)
set (CM3_PATH ${LIBOPENCM3_PATH}/lib/cm3)

set(libopencm3_DEFS
  STM32F4
  STM32F4CCM
  STM32F407VG
)

set(libopencm3_INCLUDE
  ${LIBOPENCM3_PATH}/include
  ${LIBOPENCM3_PATH}/include/usb
  ${LIBOPENCM3_PATH}/include/eth
  ${LIBOPENCM3_PATH}/include/cm3
  ${LIBOPENCM3_PATH}/include/stm32/common
  ${LIBOPENCM3_PATH}/include/stm32/f4
)

set(libopencm3_SRC
  ${COMMON_PATH}/adc_common_v1.c
  ${COMMON_PATH}/adc_common_v1_multi.c
  ${COMMON_PATH}/adc_common_f47.c
  ${STM32_PATH}/can.c
  ${COMMON_PATH}/crc_common_all.c
  ${COMMON_PATH}/crypto_common_f24.c
  ${F4_PATH}/crypto.c
  ${COMMON_PATH}/dac_common_all.c
  ${COMMON_PATH}/dac_common_v1.c
  ${COMMON_PATH}/dcmi_common_f47.c
  ${COMMON_PATH}/desig_common_all.c
  ${COMMON_PATH}/desig_common_v1.c
  ${COMMON_PATH}/dma_common_f24.c
  ${COMMON_PATH}/dma2d_common_f47.c
  ${COMMON_PATH}/dsi_common_f47.c
  ${COMMON_PATH}/exti_common_all.c
  ${F4_PATH}/flash.c
  ${COMMON_PATH}/flash_common_all.c
  ${COMMON_PATH}/flash_common_f.c
  ${COMMON_PATH}/flash_common_f24.c
  ${COMMON_PATH}/flash_common_idcache.c
  ${COMMON_PATH}/fmc_common_f47.c
  ${COMMON_PATH}/gpio_common_all.c
  ${COMMON_PATH}/gpio_common_f0234.c
  ${COMMON_PATH}/hash_common_f24.c
  ${COMMON_PATH}/i2c_common_v1.c
  ${COMMON_PATH}/iwdg_common_all.c
  ${COMMON_PATH}/lptimer_common_all.c
  ${COMMON_PATH}/ltdc_common_f47.c
  ${COMMON_PATH}/pwr_common_v1.c
  ${F4_PATH}/pwr.c
  ${COMMON_PATH}/rcc_common_all.c
  ${F4_PATH}/rcc.c
  ${COMMON_PATH}/rng_common_v1.c
  ${COMMON_PATH}/rtc_common_l1f024.c
  ${F4_PATH}/rtc.c
  ${COMMON_PATH}/spi_common_all.c
  ${COMMON_PATH}/spi_common_v1.c
  ${COMMON_PATH}/spi_common_v1_frf.c
  ${COMMON_PATH}/timer_common_all.c
  ${COMMON_PATH}/timer_common_f0234.c
  ${COMMON_PATH}/timer_common_f24.c
  ${COMMON_PATH}/usart_common_all.c
  ${COMMON_PATH}/usart_common_f124.c
  ${COMMON_PATH}/quadspi_common_v1.c

  ${USB_PATH}/usb.c
  ${USB_PATH}/usb_standard.c
  ${USB_PATH}/usb_control.c
  ${USB_PATH}/usb_msc.c
  ${USB_PATH}/usb_hid.c
  ${USB_PATH}/usb_audio.c
  ${USB_PATH}/usb_cdc.c
  ${USB_PATH}/usb_midi.c
  ${USB_PATH}/usb_dwc_common.c
  ${USB_PATH}/usb_f107.c
  ${USB_PATH}/usb_f207.c

  ${ETH_PATH}/mac.c
  ${ETH_PATH}/phy.c
  ${ETH_PATH}/mac_stm32fxx7.c
  ${ETH_PATH}/phy_ksz80x1.c

  ${CM3_PATH}/vector.c
  ${CM3_PATH}/systick.c
  ${CM3_PATH}/scb.c
  ${CM3_PATH}/nvic.c
  ${CM3_PATH}/assert.c
  ${CM3_PATH}/sync.c
  ${CM3_PATH}/dwt.c
)

add_library(libopencm3_stm32f4 STATIC ${libopencm3_SRC})
target_include_directories(libopencm3_stm32f4 PUBLIC ${libopencm3_INCLUDE})
target_compile_definitions(libopencm3_stm32f4 PUBLIC ${libopencm3_DEFS})

add_custom_command(OUTPUT ${F4_PATH}/vector_nvic.c
  COMMAND python scripts/irq2nvic_h ./include/libopencm3/stm32/f4/irq.json)

add_custom_command(OUTPUT linker-stm32f407vg.ld
  COMMAND arm-none-eabi-gcc -P -E -DSTM32F4 -DSTM32F4CCM -DSTM32F407VG -D_ROM=1024K -D_RAM=128K -D_CCM=64K -D_CCM_OFF=0x10000000 -D_ROM_OFF=0x08000000 -D_RAM_OFF=0x20000000 ld/linker.ld.S -o linker-stm32f407vg.ld)
