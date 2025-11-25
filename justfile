set shell := ["cmd", "/c"]

# wormboard build and run commands

# build the windows executable
build:
    zig build

# build release version
release:
    zig build -Doptimize=ReleaseSafe

# run the executable
run: build
    zig-out\bin\wormboard.exe
