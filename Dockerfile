# weft-loom-rust — Rust compile sandbox image for weft-loom.
#
# Consumed by weft-agent when a weft-loom compile job has
# language="rust". The loom-server dispatches via a wrapper that
# tries `cargo run` when Cargo.toml is present + falls back to
# `rustc <entry>` for one-off scripts. We need `sh`, `rustc`,
# `cargo` all in PATH at the default WORKDIR.
#
# Invocation contract (loom-server uses this shape) :
#
#   apptainer exec --bind <project>:/workspace ghcr.io/openweft/weft-loom-rust:latest \
#     sh -c "if [ -f Cargo.toml ]; then cargo run; else rustc <entry> -o /tmp/a.out && /tmp/a.out; fi"
#
# Legacy `docker run` (still supported) :
#
#   docker run --rm \
#     -v <project>:/workspace:rw \
#     ghcr.io/openweft/weft-loom-rust \
#     cargo build --release --target-dir /workspace/.build

FROM rust:1.85-bookworm

# Apptainer runs as the host user — the in-image USER directive is
# not honoured AND the bind mount maps the host file ownership
# verbatim. A non-root USER in the Dockerfile creates a permission
# trap (UID 1000 in the image can't read the project tree if the
# host user has a different UID). Stay root inside the image ; the
# sandbox boundary is the workspace μVM, not the container user.

# Cargo's registry + target cache live in /root so subsequent
# builds reuse downloaded crates.
RUN mkdir -p /root/.cargo/registry
ENV CARGO_HOME=/root/.cargo
# Make sure cargo + rustc are on PATH for non-login shells too
# (apptainer exec doesn't source /etc/profile by default).
ENV PATH=/usr/local/cargo/bin:/usr/local/rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin:${PATH}

WORKDIR /workspace

CMD ["cargo", "build", "--release", "--target-dir", "/workspace/.build"]

LABEL org.opencontainers.image.title="weft-loom-rust"
LABEL org.opencontainers.image.description="Rust compile sandbox for weft-loom (rustc 1.85 stable + cargo)"
LABEL org.opencontainers.image.source="https://github.com/openweft/weft-loom-rust"
LABEL org.opencontainers.image.licenses="BSD-3-Clause"
