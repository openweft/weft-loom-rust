# weft-loom-rust — Rust compile sandbox image for weft-loom.
#
# Consumed by weft-agent when a weft-loom compile job has
# language="rust". Default command runs `cargo build --release`.
# The official rust image ships rustup + cargo + rustfmt + clippy ;
# this image adds nothing on top, just a non-root user + the workspace
# layout the weft-loom contract expects.
#
# Invocation contract :
#
#   docker run --rm \
#     -v <project>:/workspace:ro \
#     -v <scratch>:/workspace/.build:rw \
#     ghcr.io/openweft/weft-loom-rust \
#     cargo build --release --target-dir /workspace/.build

FROM rust:1.85-bookworm

RUN useradd --create-home --shell /bin/bash --uid 1000 build \
 && mkdir -p /workspace \
 && chown build:build /workspace

# Cargo's registry + target cache lives in the writable home so
# subsequent builds reuse downloaded crates.
RUN mkdir -p /home/build/.cargo/registry && chown -R build:build /home/build/.cargo

USER build
WORKDIR /workspace
ENV CARGO_HOME=/home/build/.cargo

CMD ["cargo", "build", "--release", "--target-dir", "/workspace/.build"]

LABEL org.opencontainers.image.title="weft-loom-rust"
LABEL org.opencontainers.image.description="Rust compile sandbox for weft-loom (rustc 1.85 stable + cargo)"
LABEL org.opencontainers.image.source="https://github.com/openweft/weft-loom-rust"
LABEL org.opencontainers.image.licenses="BSD-3-Clause"
