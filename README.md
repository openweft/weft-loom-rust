<p align="center"><img src="https://raw.githubusercontent.com/openweft/brand/main/social/weft-loom-rust.png" alt="weft-loom-rust" width="720"></p>

# weft-loom-rust

Rust compile sandbox for weft-loom (rustc 1.85 stable + cargo). Consumed by [weft-loom-server](https://github.com/openweft/weft-loom-server) via weft-agent when a compile job picks this language.

## Invocation contract

```
docker run --rm \
  -v <project>:/workspace:ro \
  -v <scratch>:/workspace/.build:rw \
  ghcr.io/openweft/weft-loom-rust:latest
```

See the [Dockerfile](./Dockerfile) for the default `CMD` ; override
via the weft-loom compile job's `extra_args` for non-default targets.

## Image

- Base : see Dockerfile FROM line
- Arch : `linux/amd64`, `linux/arm64` (built via buildx + QEMU on tag)
- Registry : `ghcr.io/openweft/weft-loom-rust`
- Tag policy : `latest` (rolling main), `vX.Y.Z` (immutable)

## License

BSD 3-Clause — see LICENSE.
