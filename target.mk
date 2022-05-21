PROJECT= freertos_stm32

CPU = -mcpu=cortex-m4

# fpu
FPU = -mfpu=fpv4-sp-d16

# float-abi
FLOAT-ABI = -mfloat-abi=hard

# mcu
MCU = $(CPU) -mthumb $(FPU) $(FLOAT-ABI)

# macros for gcc
# AS defines
AS_DEFS =

# C defines
C_DEFS =  \
-DUSE_HAL_DRIVER \
-DSTM32F407xx

TOOLCHAIN = tools/bin/arm-none-eabi

# Define the CPU Core (example : cortex-m0plus, cortex-m4)
CPU_CORE=cortex-m4

# Set up the object code location
OUTPUT_DIR=build

# AS includes
AS_INCLUDES =  \
-ICore/Inc

# Specific files to include if you don't want the entire directory including
SRC_FILES = \
startup_stm32f407xx.s \
drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_rcc.c \
drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_rcc_ex.c \
drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_flash.c \
drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_flash_ex.c \
drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_flash_ramfunc.c \
drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_gpio.c \
drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_dma_ex.c \
drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_dma.c \
drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_pwr.c \
drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_pwr_ex.c \
drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_cortex.c \
drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal.c \
drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_exti.c \
drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_tim.c \
drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_tim_ex.c \
os/portable/MemMang/heap_4.c \

# Include all the source files in the following directories
SRC_DIRS = \
core \
os \
os/CMSIS_RTOS_V2 \
os/portable/GCC/ARM_CM4F

# Define additional include directories

C_INCLUDES =  \
-Idrivers/STM32F4xx_HAL_Driver/Inc \
-Idrivers/STM32F4xx_HAL_DriverInc/Legacy \
-Ios/include \
-Ios/CMSIS_RTOS_V2 \
-Ios/portable/GCC/ARM_CM4F \
-Idrivers/CMSIS/Device/ST/STM32F4xx/Include \
-Idrivers/CMSIS/Include

# compile gcc flags
ASFLAGS = $(MCU) $(AS_DEFS) $(AS_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

CFLAGS = $(MCU) $(C_DEFS) $(C_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

ifeq ($(DEBUG), 1)
CFLAGS += -g -gdwarf-2
endif

# Generate dependency information
CFLAGS += -MMD -MP -MF"$(@:%.o=%.d)"

#######################################
# LDFLAGS
#######################################
# link script
LDSCRIPT = STM32F407VETx_FLASH.ld

# libraries
LIBS = -lc -lm -lnosys
LIBDIR =

LDFLAGS = $(MCU) -specs=nano.specs -Wl,--script=$(LDSCRIPT) $(LIBDIR) $(LIBS) -Wl,--entry,Reset_Handler,-Map=$(OUTPUT_DIR)/$(PROJECT).map,--cref -Wl,--gc-sections

# Now do the heavy lifting
include tools/build.mk
