CC = gcc
CFLAGS = -std=c11 -O2 -Wall

TARGET = rv32i_asm
SRC = rv32i_asm.c

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) -o $(TARGET) $(SRC)

clean:
	rm -f $(TARGET)

