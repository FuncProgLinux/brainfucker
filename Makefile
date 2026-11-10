ZIG      ?= zig
SRC      ?= src/main.zig
TEST_SRC ?= $(SRC)
OUT      ?= brainfucker

all: build

build: $(OUT)

$(OUT): $(SRC) $(CLI_SRC)
	$(ZIG) build-exe $(SRC) -femit-bin=$(OUT)

test: $(CLI_SRC)
	$(ZIG) test $(TEST_SRC)

run: $(OUT)
	./$(OUT)

clean:
	rm -f $(OUT) $(OUT).o

.PHONY: all build test run clean
