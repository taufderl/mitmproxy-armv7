#!/bin/sh
# Build without mitmproxy-linux.
#
# mitmproxy-linux is the eBPF redirector for "mitmproxy --mode local". It has
# no 32-bit ARM build. Drop it from the dependencies and do not import it when
# the module loads; local mode still imports it lazily and then fails with an
# ImportError, all other modes work.
#
# Done with sed rather than a .patch file because the dependency line pins the
# exact upstream version, which would break a patch on every release.
#
# Usage: strip-mitmproxy-linux.sh <path to unpacked sdist>
set -eu
src=$1

# pyproject.toml: drop the dependency line.
sed -i '/^[[:space:]]*"mitmproxy_linux[=<>~! ]/d' "$src/pyproject.toml"

# lib.rs: drop the eager import and the #[cfg(...)] line guarding it.
sed -i '/#\[cfg(.*target_os = "linux".*)\]/{N;/m\.py()\.import("mitmproxy_linux")?;/d}' \
    "$src/mitmproxy-rs/src/lib.rs"

if grep -n 'mitmproxy_linux' "$src/pyproject.toml" "$src/mitmproxy-rs/src/lib.rs"; then
    echo "mitmproxy_linux still referenced; upstream layout changed" >&2
    exit 1
fi
