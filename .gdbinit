# .gdbinit for RISC-V kernel debugging with QEMU

set architecture riscv:rv32
# Disable pagination for uninterrupted output
set pagination off
# Enable pretty printing for structures
set print pretty on
# Enable logging to a file for session analysis
set logging file log/debug.log
# Enable manually with `set logging on` during sessions
set logging enabled off

# --- QEMU Connection ---
# Connect to QEMU's GDB server (default port 1234)
target remote :1234

# --- Symbol Loading ---
add-symbol-file kernel.elf 0x80200000

# --- Initial Breakpoints ---
break boot
break kernel_main
break kernel_entry
break handle_trap
break handle_syscall

# --- Display Settings ---
# Automatically display registers and instructions when stopping
display/i $pc
display/x $sp
display/x $a0

# --- Custom Commands ---
# Shortcut to show registers and nearby code
define kregs
    info registers
    x/10i $pc
end

# Shortcut to dump kernel stack
define kstack
    backtrace
    info frame
    x/20xw $sp
end

# Shortcut to inspect memory at a given address
define kmem10
    x/10xw $arg0
end
document kmem10
    Usage: kmem10 <address>
    Dumps 10 words of memory starting at <address> in hex.
end

# Shortcut to reload symbols (useful after recompiling kernel)
define reload
    file kernel.elf
    add-symbol-file kernel.elf 0x80200000
end

# # New function to reconnect GDB after recompiling and restarting QEMU
# define reconnect
#     # Disconnect from current QEMU session (if connected)
#     # Check if connected to a remote target
#     python
#     if gdb.selected_inferior().connection is not None and gdb.selected_inferior().connection.name.startswith("remote"):
#         gdb.execute("disconnect")
#     end
#     # Reload kernel symbols
#     file kernel.elf
#     add-symbol-file kernel.elf 0x80200000
#     # Reconnect to QEMU's GDB server
#     target remote :1234
#     # Restore saved breakpoints (from breakpoints.gdb)
#     source breakpoints.gdb
#     # Optional: Continue execution (uncomment if desired)
#     # continue
# end
# document reconnect
#     Usage: reconnect
#     Reconnects GDB to QEMU after recompiling kernel and restarting QEMU.
#     Reloads symbols, reconnects to :1234, and restores breakpoints.
# end

# --- TUI Enhancements ---
# Enable TUI layout for source and assembly (uncomment to enable by default)
# tui enable
# layout src
# layout asm

# --- Exception Debugging ---
# Display mcause and mepc when stopping at traps
define hook-stop
    printf "mcause: %d\n", $mcause
    printf "mepc: 0x%x\n", $mepc
    info registers
end

# --- Save Breakpoints ---
# Save breakpoints to a file for reuse across sessions
save breakpoints breakpoints.gdb
# Later in new session you can load saved breakpoints like this:
#(gdb) source breakpoints.gdb

# --- End of .gdbinit ---
