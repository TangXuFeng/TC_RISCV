CC = gcc
CFLAGS = -std=c11 -O2 -Wall

TARGET = rv32i_asm
SRC = rv32i_asm.c

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) -o $(TARGET) $(SRC)

run: $(TARGET)
	./$(TARGET) input.s output.hex

debug: $(TARGET)
	./$(TARGET) input.s output.hex debug

clean:
	rm -f $(TARGET)
