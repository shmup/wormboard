# syntax=docker/dockerfile:1
FROM debian:bookworm-slim

ARG ZIG_VERSION=0.15.2

# install deps (ffmpeg for compression, curl for zig download)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    xz-utils \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# download and install zig
RUN curl -sSL "https://ziglang.org/download/${ZIG_VERSION}/zig-x86_64-linux-${ZIG_VERSION}.tar.xz" \
    | tar -xJ -C /opt \
    && ln -s /opt/zig-x86_64-linux-${ZIG_VERSION}/zig /usr/local/bin/zig

WORKDIR /build

# copy source (excluding wavs - those come from volume for embedded builds)
COPY src/ src/
COPY build.zig .
COPY worm.ico .

# create wavs mount point (volume will overlay this)
RUN mkdir -p src/wavs

# build args as env vars for runtime build
ENV OPTIMIZE=ReleaseSafe
ENV EMBED=false
ENV COMPRESS=false
ENV HOST_UID=1000
ENV HOST_GID=1000

# build at runtime so volume-mounted wavs are available
CMD zig build \
    -Doptimize=${OPTIMIZE} \
    $([ "${EMBED}" = "true" ] && echo "-Dembed=true") \
    $([ "${COMPRESS}" = "true" ] && echo "-Dcompress=true") \
    && cp /build/zig-out/bin/wormtalker.exe /out/ \
    && chown ${HOST_UID}:${HOST_GID} /out/wormtalker.exe
