# mitmproxy-armv7

Unofficial **ARMv7** (32-bit ARM, hard-float) wheels of
[`mitmproxy_rs`](https://github.com/mitmproxy/mitmproxy_rs), the Rust part of
[mitmproxy](https://mitmproxy.org/).

mitmproxy itself is pure Python, and its other dependencies either ship ARMv7
wheels or build from source without trouble. `mitmproxy_rs` is the exception:
upstream publishes wheels for x86_64, aarch64, macOS and Windows only, and
building it on the device needs a recent Rust toolchain. This repository builds
the missing wheels on GitHub Actions and publishes them as releases.

| Wheel | For |
|---|---|
| `manylinux` (glibc ≥ 2.17) | Raspberry Pi OS, Debian/Ubuntu armhf |
| `musllinux` (musl ≥ 1.2) | Alpine and other musl systems |

## Install

Download the wheel for your system from the
[releases](https://github.com/taufderl/mitmproxy-armv7/releases), then:

```sh
pip install mitmproxy_rs-<version>-cp312-abi3-<platform>.whl
pip install mitmproxy
```

## How it is built

Each run takes the `mitmproxy_rs` sdist from PyPI, verifies its sha256, and
cross-compiles it with [maturin-action](https://github.com/PyO3/maturin-action).
The wheels are smoke-tested on emulated ARMv7 (import, WireGuard key generation)
before release. A weekly run picks up new upstream versions.

One change to upstream ([`patches/`](patches)): `mitmproxy-linux` is neither a
dependency nor imported when the module loads. It is the eBPF redirector for
`mitmproxy --mode local`, which has no 32-bit ARM build; local mode raises an
ImportError, all other modes (regular, transparent, reverse, SOCKS, WireGuard)
work.

## OpenWrt

OpenWrt builds packages from source and does not use these wheels. OpenWrt
packaging lives in a separate feed.

## License

The build scripts in this repository are [MIT](LICENSE). The wheels contain
mitmproxy_rs, which is MIT-licensed by the mitmproxy project.

Not affiliated with the mitmproxy project.
