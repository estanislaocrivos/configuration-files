# =============================================================================
# .gdbinit - GDB Configuration for C Embedded Development
# =============================================================================
# Place in the project directory or in ~/.gdbinit
#
# Usage:
#   gdb-multiarch -x .gdbinit firmware.elf
#   arm-none-eabi-gdb -x .gdbinit firmware.elf

# -----------------------------------------------------------------------------
# General configuration
# -----------------------------------------------------------------------------

# Disable annoying confirmations
set confirm off

# Disable pagination (for scripts)
set pagination off

# Command history
set history save on
set history size 10000
set history filename ~/.gdb_history
set history expansion on

# Pretty printing
set print pretty on
set print array on
set print array-indexes on
set print elements 256
set print null-stop on
set print union on
set print demangle on
set print asm-demangle on
set print object on
set print static-members off

# Show source code in disassembly
set disassembly-flavor intel

# Logging (uncomment for GDB debugging)
# set logging file gdb.log
# set logging on

# -----------------------------------------------------------------------------
# ARM Embedded configuration
# -----------------------------------------------------------------------------

# Default remote target (OpenOCD, J-Link, ST-Link, etc.)
# Uncomment and adjust according to your debugger:

# OpenOCD (default port 3333)
# target extended-remote :3333

# J-Link GDB Server (default port 2331)
# target extended-remote :2331

# ST-Link (via OpenOCD)
# target extended-remote :3333

# Black Magic Probe
# target extended-remote /dev/ttyACM0

# QEMU ARM
# target extended-remote :1234

# -----------------------------------------------------------------------------
# Custom commands
# -----------------------------------------------------------------------------

# Reset target
define reset
    monitor reset halt
    echo Target reset.\n
end
document reset
    Reset the target and halt.
end

# Reset and run
define reset_run
    monitor reset init
    continue
    echo Target reset and running.\n
end
document reset_run
    Reset the target and continue execution.
end

# Flash firmware
define flash
    load
    monitor reset halt
    echo Firmware flashed.\n
end
document flash
    Flash the firmware and reset.
end

# Show ARM registers
define regs
    info registers
end
document regs
    Show all CPU registers.
end

# Show special ARM registers
define sregs
    info registers cpsr
    info registers sp
    info registers lr
    info registers pc
end
document sregs
    Show special ARM registers (CPSR, SP, LR, PC).
end

# Stack trace with more context
define btf
    backtrace full
end
document btf
    Full backtrace with local variables.
end

# Show memory as hexdump
define xxd
    if $argc == 2
        dump binary memory /tmp/gdb_dump.bin $arg0 $arg0+$arg1
        shell xxd /tmp/gdb_dump.bin
    else
        echo Usage: xxd <address> <length>\n
    end
end
document xxd
    Hexdump memory: xxd <address> <length>
end

# Show buffer contents
define pbuf
    if $argc == 2
        set $i = 0
        while $i < $arg1
            printf "0x%02X ", *(uint8_t*)($arg0 + $i)
            set $i = $i + 1
            if ($i % 16) == 0
                printf "\n"
            end
        end
        printf "\n"
    else
        echo Usage: pbuf <address> <length>\n
    end
end
document pbuf
    Print buffer as hex bytes: pbuf <address> <length>
end

# Show peripherals (example for ARM Cortex-M)
define periph
    echo === System Control Block ===\n
    printf "CPUID:    0x%08X\n", *(uint32_t*)0xE000ED00
    printf "ICSR:     0x%08X\n", *(uint32_t*)0xE000ED04
    printf "AIRCR:    0x%08X\n", *(uint32_t*)0xE000ED0C
    printf "SCR:      0x%08X\n", *(uint32_t*)0xE000ED10
    printf "CFSR:     0x%08X\n", *(uint32_t*)0xE000ED28
    printf "HFSR:     0x%08X\n", *(uint32_t*)0xE000ED2C
    printf "DFSR:     0x%08X\n", *(uint32_t*)0xE000ED30
    printf "MMFAR:    0x%08X\n", *(uint32_t*)0xE000ED34
    printf "BFAR:     0x%08X\n", *(uint32_t*)0xE000ED38
end
document periph
    Show ARM Cortex-M System Control Block registers.
end

# Analyze fault
define fault
    echo === Fault Analysis ===\n
    printf "CFSR:  0x%08X\n", *(uint32_t*)0xE000ED28
    printf "HFSR:  0x%08X\n", *(uint32_t*)0xE000ED2C
    printf "DFSR:  0x%08X\n", *(uint32_t*)0xE000ED30
    printf "MMFAR: 0x%08X\n", *(uint32_t*)0xE000ED34
    printf "BFAR:  0x%08X\n", *(uint32_t*)0xE000ED38
    printf "AFSR:  0x%08X\n", *(uint32_t*)0xE000ED3C
    echo \n=== Stack Frame ===\n
    info frame
    echo \n=== Backtrace ===\n
    backtrace
end
document fault
    Analyze ARM Cortex-M fault registers and show stack.
end

# Write watchpoint
define ww
    if $argc == 1
        watch *$arg0
        echo Write watchpoint set.\n
    else
        echo Usage: ww <address>\n
    end
end
document ww
    Set write watchpoint: ww <address>
end

# Read watchpoint
define wr
    if $argc == 1
        rwatch *$arg0
        echo Read watchpoint set.\n
    else
        echo Usage: wr <address>\n
    end
end
document wr
    Set read watchpoint: wr <address>
end

# Access watchpoint (read/write)
define wa
    if $argc == 1
        awatch *$arg0
        echo Access watchpoint set.\n
    else
        echo Usage: wa <address>\n
    end
end
document wa
    Set access watchpoint: wa <address>
end

# Connect to OpenOCD
define ocd
    target extended-remote :3333
    monitor reset halt
    echo Connected to OpenOCD.\n
end
document ocd
    Connect to OpenOCD on port 3333.
end

# Connect to J-Link
define jlink
    target extended-remote :2331
    monitor reset
    echo Connected to J-Link GDB Server.\n
end
document jlink
    Connect to J-Link GDB Server on port 2331.
end

# -----------------------------------------------------------------------------
# Hooks
# -----------------------------------------------------------------------------

# Show info after each stop
define hook-stop
    # Uncomment to automatically show registers
    # info registers pc sp lr
end

# -----------------------------------------------------------------------------
# Python extensions (if GDB has Python support)
# -----------------------------------------------------------------------------

# Uncomment if you have custom Python scripts
# python
# import sys
# sys.path.insert(0, '/path/to/your/gdb/python/scripts')
# end

# -----------------------------------------------------------------------------
# Welcome message
# -----------------------------------------------------------------------------
echo \n
echo =====================================================\n
echo   GDB Embedded Configuration Loaded\n
echo =====================================================\n
echo   Commands: reset, flash, regs, fault, periph\n
echo   Connect:  ocd (OpenOCD), jlink (J-Link)\n
echo =====================================================\n
echo \n
