set history filename ~/.gdb_history
set history save on
set output-radix 16
# Indent some text when printing objects to make them easier to read
set print pretty on

set confirm off
set verbose off

# Color prompt
#set prompt \033[31mgdb$ \033[0m

# Print everything in hex
set output-radix 16

# Stop printing char arrays once the null terminator is found
set print null-stop on

# Print actual/derived types using the vptr
set print object on
