# Compiler
CC = gcc

# Assembly source files
ASM_SRCS = strlen.s strcpy.s strcat.s strcmp.s

# Assembly object files (same names but .o)
ASM_OBJS = $(ASM_SRCS:.s=.o)

# C source file
C_SRC = string_manipulation.c

# C object file (same name but .o)
C_OBJ = $(C_SRC:.c=.o)

# All object files
OBJS = $(ASM_OBJS) $(C_OBJ)

# Output executable
TARGET = string_manipulation.out

# Default rule
all: $(TARGET)

# Link executable from all object files
$(TARGET): $(OBJS)
	$(CC) $(OBJS) -o $(TARGET)

# Compile assembly to object files
%.o: %.s
	$(CC) -c $< -o $@

# Compile C source to object file
%.o: %.c
	$(CC) -c $< -o $@

# Clean build files
clean:
	rm -f $(OBJS) $(TARGET)
