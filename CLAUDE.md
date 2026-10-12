# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repo builds and publishes Docker toolchain images to `ghcr.io/nfrechette/` used to compile
sjson-cpp, RTM, ACL, and related C++ projects across many compiler versions. There is no application
code here — only Dockerfiles and thin bash wrappers.

## Structure

Each image is a quartet of files sharing one name (`xenial`, `bionic`, `focal`, `lunar`,
`resolute`, `emscripten`, `sonarcloud`):

- `Dockerfile-<name>` — the image definition
- `build_image_<name>.sh [arch]` — `docker build`, defaults to `amd64`
- `docker_push_<name>.sh [arch]` — `docker image push`
- `build_with_<name>.sh <src-dir> [arch]` — runs the image interactively with the source dir bind
  mounted at `/project-src` (the images' `WORKDIR`); arch is auto-detected from `uname -a` when
  omitted

Adding or changing an image means touching all four files together.

Image references follow `ghcr.io/nfrechette/toolchain-<arch>-<name>:<tag>`, except `emscripten`
and `sonarcloud`, which insert `linux-` (`toolchain-<arch>-linux-emscripten`). Copy from an
existing script for the same image rather than deriving the name.

## Commands

```bash
# Build (arch defaults to amd64; pass arm64 for the other)
./build_image_lunar.sh
./build_image_lunar.sh arm64

# resolute also builds for armv7 (Docker platform linux/arm/v7, emulated by QEMU on other hosts)
./build_image_resolute.sh armv7

# Publish (requires CR_PAT env var holding a GitHub PAT with package registry write access)
./docker_login.sh
./docker_push_lunar.sh

# Use an image to build a project
./build_with_lunar.sh ~/acl
```

There are no tests or linters. Verification is building the image and, if the toolchain changed,
running `build_with_<name>.sh` against a real project source tree.

If image building fails, run `docker system prune` to free up space.

## Image tag versioning

Image tags are hand-maintained integers (`:v1`, `:v2`, …), not `latest`. The tag string appears in
three files per image — `build_image_*.sh`, `docker_push_*.sh`, and `build_with_*.sh` — and **all
three must be bumped in the same commit** when an image's contents change, otherwise consumers pull
a stale image. See `6eaafbb` for the canonical bump.

Current tags: xenial `v1`, bionic `v1`, focal `v1`, emscripten `v1`, lunar `v2`, resolute `v1`
(amd64, arm64, and armv7), sonarcloud `v3`.

The distro images' compiler ranges are contiguous: a new image picks up where the previous one
stops (lunar ends at GCC 13 / Clang 18, so resolute starts at GCC 14 / Clang 19).

Known drift: `build_with_sonarcloud.sh` still points at `:v2` while build/push use `:v3`, and it
hardcodes `SRC=~/sjson-cpp` / `ARCH=amd64` instead of taking arguments like its siblings. The
`# Usage:` comments in `build_with_emscripten.sh` and `build_with_xenial.sh` name the wrong script
(copy-paste from lunar/focal).

## Dockerfile conventions

All images follow the same shape: `FROM ubuntu:<ver> as base`, `ARG ARCH`, `ENV LANG C.UTF-8`
(needed so CMake/build progress bars render correctly), noninteractive debconf, then toolchain
layers, `WORKDIR /project-src`, `CMD ["bash"]`. The header comment listing supported compiler
versions is part of the contract — update it when adding compilers.

Things that are easy to get wrong:

- **Multilib is amd64-only.** `g++-*-multilib` packages must stay inside an amd64-only guard
  (`if [ "$ARCH" = "amd64" ]` in `resolute`, `!= arm64` in the older images); they do not exist
  for arm64 or armhf and will break those builds.
- **armv7 is `resolute` only.** Docker names the platform `linux/arm/v7`, not `linux/armv7`, so
  `build_image_resolute.sh` and `build_with_resolute.sh` map `armv7` to it; the image name still
  uses `armv7` (`toolchain-armv7-resolute`). apt.llvm.org publishes no armhf packages, so the
  armv7 image gets Clang from the stock repos, and it only installs one compiler of each kind
  (GCC 15, Clang 22) because it exists to test with, not to cover a version range. Consumers must
  pass `-mfpu=neon`, since the armhf GCC does not enable NEON by default.
- **LLVM apt repos are per-distro.** The `apt.llvm.org/<codename>/llvm-toolchain-<codename>-<ver>`
  lines must use the host image's codename, and only versions LLVM actually published for that
  codename are installable. This caps how new a compiler a given base image can host. On
  `resolute`, Clang 19–21 come from the stock Ubuntu repos (apt.llvm.org has no 19/20 there, and
  its `~++` snapshot version strings sort below the stock 21), and only 22+ from apt.llvm.org.
- **No `apt-key` from 26.04 on.** apt 3.x removed it. `resolute` dearmors the LLVM key into
  `/usr/share/keyrings/` and references it with `[signed-by=...]` on each repo line; older images
  still use `apt-key add`.
- **Newer GCC comes from a PPA.** `focal` and `lunar` add `ppa:ubuntu-toolchain-r/test` (which
  needs `software-properties-common`) to get GCC versions the stock repos lack.
- **Emscripten paths are pinned.** The emsdk version appears in two `emsdk` commands, and the
  `ENV` block hardcodes the bundled Node path (`/emsdk/node/14.18.2_64bit`). Bumping emsdk means
  updating those `ENV` lines to whatever Node version the new SDK ships.
- **Sonarcloud is effectively amd64-only.** It always downloads `build-wrapper-linux-x86.zip`
  regardless of `ARCH`.

Multi-version compilers are installed side by side (e.g. `clang-15` … `clang-18`) rather than
aliased to `clang`; consuming projects select one by full binary name.

## Commit style

Conventional commits (`feat:`, `fix:`, `chore:`, `docs:`), with the new image tag in parentheses
when a version is bumped.
