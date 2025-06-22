#!/bin/bash

# Get project root
PROJECT_ROOT="$PWD"

# Define paths
GDBINIT="${PROJECT_ROOT}/.gdbinit"
KERNEL="${PROJECT_ROOT}/kernel.elf"
GDB="riscv32-unknown-elf-gdb"

if [[ ! -f "${GDBINIT}" ]]; then
    echo "Error: .gdbinit not found at ${GDBINIT}"
    exit 1
fi

if [[ ! -f "${KERNEL}" ]]; then
    echo "Error: kernel.elf not found at ${KERNEL}"
    exit 1
fi

if ! command -v "${GDB}" &> /dev/null; then
    echo "Error: ${GDB} not found. Please install the RISC-V toolchain."
    exit 1
fi

${GDB} -x "${GDBINIT}" "${KERNEL}"
