[![Daily build](https://github.com/gp-devenv/gp-ncs-devenv/actions/workflows/dispatch.yaml/badge.svg)](https://github.com/gp-devenv/gp-ncs-devenv/actions/workflows/dispatch.yaml)

[![License](https://img.shields.io/badge/license-MIT-blue)](./LICENSE)

[![Ubuntu](https://img.shields.io/badge/ubuntu-22.04-orange)](https://ubuntu.com)
[![Ubuntu](https://img.shields.io/badge/ubuntu-24.04-orange)](https://ubuntu.com)

![ARM64](https://img.shields.io/badge/linux%2farm64-Yes-red)
![ARMV7](https://img.shields.io/badge/linux%2farm%2fv7-Yes-red)
![AMD64](https://img.shields.io/badge/linux%2famd64-Yes-red)

# gp-ncs-devenv: Build Tempalte dev containers for VSCode

> Copyright (c) 2023-2025, Greg PFISTER. MIT License

## About

This is a simple Ubuntu container to use as development environment for NCS
projectswhich I use with Visual Studio Code Remote Container feature.

This is image is provided with Ubuntu 22.04 and 24.04.

See [version](#version) mapping to find out which version Ubuntu.

This image is built from
[ghcr.io/gp-devenv/gp-base-devenv](https://github.com/gp-devenv/gp-base-devenv/pkgs/container/gp-base-devenv)
and adds:

- `nrfutil` to manage NCS (SDK and toolchain install)

The image can be found
[here](https://github.com/gp-devenv/gp-ncs-devenv/pkgs/container/gp-ncs-devenv).

## Volumes

In order to persist user data, a volume for the /home folder is set. The root
user will not be persisted.

| Volume | Description                                        |
| ------ | -------------------------------------------------- |
| /home  |  Persist the user data stored in their home folder |

<div id="build-run-scan-push" />

## Build, scan and push

### Versioning

Image version contains the Ubuntu version and the build version, using the
format `<Ubuntu version>-<Build version>`. The build version
refers to the latest Dockerfile script, when modification consists of fixing
(patch change), or adding or removing something significant (minor change) or
breaking (major).

For example:

| Image                                       | Description                               |
| ------------------------------------------- | ----------------------------------------- |
| ghcr.io/gp-devenv/gp-ncs-devenv:24.04       | The latest build using Ubuntu 24.04       |
| ghcr.io/gp-devenv/gp-ncs-devenv:24.04-1     | The latest build 1.x using Ubuntu 24.04   |
| ghcr.io/gp-devenv/gp-ncs-devenv:24.04-1.1   | The latest build 1.1.x using Ubuntu 24.04 |
| ghcr.io/gp-devenv/gp-ncs-devenv:24.04-1.1.0 | The latest build 1.1.0 using Ubuntu 24.04 |
| ghcr.io/gp-devenv/gp-ncs-devenv:24.04-1.0   | The latest build 1.0.x using Ubuntu 24.04 |
| ghcr.io/gp-devenv/gp-ncs-devenv:24.04-1.0.0 | The latest build 1.0.0 using Ubuntu 24.04 |

For CI/CD, the build version is store in `.version` file. The build version is
in the format
[SemVer](https://en.wikipedia.org/wiki/Software_versioning#Semantic_versioning).

Only the latest version (MAJOR, MAJOR.MINOR and MAJOR.MINOR.PATCH) is been built
daily.

### Testing locally using `-dev` images

When you are making change to the image, use :develop at the end of the
[build](#build_dev), [run](#run_dev) and [scan](#scan_dev) commands. The `*-dev`
tag should never be pushed...

### Cross-platform building

#### Setup

In order to build x-platform, `docker buildx` must be enabled (more info
[here](https://docs.docker.com/buildx/working-with-buildx/)). Then, instead of
`build` command, `buildx` command should be used (for example:
`npm run buildx:develop` will create a cross-platform image tagged `develop`).

You will need to create a multiarch builder:

```sh
./src/scripts/buildx/setup.sh
```

On successful completion, it should at least have platforms `linux/arm64`,
`linux/arm/v7` and `linux/amd64`:

```sh
[+] Building 5.8s (1/1) FINISHED
 => [internal] booting buildkit                                             5.8s
 => => pulling image moby/buildkit:buildx-stable-1                            7s
 => => creating container buildx_buildkit_multiarch0                          1s
Name:   multiarch
Driver: docker-container

Nodes:
Name:      multiarch0
Endpoint:  unix:///var/run/docker.sock
Status:    running
Platforms: linux/arm64, linux/amd64, linux/amd64/v2, linux/riscv64,
           linux/ppc64le, linux/s390x, linux/386, linux/mips64le, linux/mips64,
           linux/arm/v7, linux/arm/v6
```

#### Build commands

Once the previous step is completed, simpy run to build the current version:

```sh
(cd src && ./scripts/buildx/build.sh)
```

### Build using local architecture (for local testing)

<div id="build_dev" />

#### Build the development image

To build using a specific Ubuntu version, use:

```sh
(cd scr && ./scripts/dev/image/build.sh <UBUNTU_VERSION>)
```

With:

- `UBUNTU_VERSION` can be 22.04 or 24.04.

It will create and image `ghcr.io/gp-devenv/gp-ncs-devenv` tagged with the current
version (see `src/.version` file) and `-dev` suffix.

You may alter the `.src/.version` file should you want to have different tags or
names, however if you PR your change, it will be rejected. The ideal solution
is to run the `docker build` command instead.

To remove the created image (named:
`ghcr.io/gp-devenv/gp-ncs-devenv:<UBUNTU_VERIONS>-<VERSION>-dev`), simply use:

```sh
(cd scr && ./scripts/dev/image/rm.sh <UBUNTU_VERSION>)
```

<div id="run_dev" />

#### Run or create/start/stop/exec a container

To run an interactive container of a give Ubuntu version, simple use:

```sh
(cd src && ./scripts/dev/container/run.sh <UBUNTU_VERSION>)
```

With:

- `UBUNTU_VERSION` can be 22.04 or 24.04.

Alternatively, you can create and start a container to run in background, and
execute scripts on this container, using the following scripts:

| Action | Script                                                           |
| ------ | ---------------------------------------------------------------- |
| create | `(cd src && ./scripts/dev/container/create.sh <UBUNTU_VERSION>)` |
| start  | `(cd src && ./scripts/dev/container/start.sh <UBUNTU_VERSION>)`  |
| stop   | `(cd src && ./scripts/dev/container/stop.sh <UBUNTU_VERSION>)`   |
| exec   | `(cd src && ./scripts/dev/container/exec.sh <UBUNTU_VERSION>)`   |

To remove the created container (named:
`gp-ncs-devenv:<UBUNTU_VERIONS>-<VERSION>-dev`), simply use:

```sh
(cd src && ./scripts/dev/container/rm.sh <UBUNTU_VERSION>)
```

<div id="scan_dev" />

#### Scan the development image

To scan the image of a give Ubuntu version, simple use:

```sh
(cd src && ./scripts/dev/scan.sh <UBUNTU_VERSION>)
```

where `UBUNTU_VERSION` can be 22.04 or 24.04.

<div id="build-from-this-image" />

## Build from this image

Should you want to make other changes, the ideal solution is to build from this
image. For example, here's the way to set the image to a different timezone than
"Europe/Paris" (the default one):

```Dockerfile
FROM ghcr.io/gp-devenv/gp-ncs-devenv:22.04

ENV TZ="America/New_York"

# Switch to root
USER root

# Reconfigure tzdata
RUN dpkg-reconfigure -f noninteractive tzdata

# Switch back to vscode
USER vscode
```

**Important:** unless you really want to use the root user, you should always
make sure the `vscode` is the last one activate.

<div id="version" />

## Version

_`Base image version` correspond to the underlying base image that can be found
[here](https://github.com/gp-devenv/gp-base-devenv/pkgs/container/gp-base-devenv)_

|   Image   |            Base image version            |   Ubuntu    | amd64 | arm64 | arm/v7 | Daily build |
| :-------: | :--------------------------------------: | :---------: | :---: | :---: | :----: | :---------: |
|   22:04   | ghcr.io/gp-devenv/gp-base-devenv:22.04-1 | 22.04 (LTS) |   X   |   X   |   X    |     Yes     |
| 22:04-1.x | ghcr.io/gp-devenv/gp-base-devenv:22.04-1 | 22.04 (LTS) |   X   |   X   |   X    |     Yes     |
|   24:04   | ghcr.io/gp-devenv/gp-base-devenv:24.04-1 | 24.04 (LTS) |   X   |   X   |   X    |     Yes     |
| 24:04-1.x | ghcr.io/gp-devenv/gp-base-devenv:24.04-1 | 24.04 (LTS) |   X   |   X   |   X    |     Yes     |

<div id="faq" />

## FAQ

1. [How to require password for sudo command ?](#faq1)
2. [Is there an example to use it with Visual Studio Code ?](#faq2)

<div id="faq1" />

### 1. How to require password for sudo command ?

You will have to [build from this image](#build-from-this-image) to disable the
the password less sudo command. Typically create a `Dockerfile` like:

```Dockerfile
FROM ghcr.io/gp-devenv/gp-ncs-devenv:22.04

ARG VSCODE_PASSWORD="dummy"

# Switch to root to make changes
USER root

# Remove the specific config for sudo and add to sudo group
RUN rm /etc/sudoers.d/vscode && \
    usermod -aG sudo vscode

# Change the password.
RUN usermod -p $VSCODE_PASSWORD vscode

# Switch back to vscode
USER vscode
```

If you simply want to get rid of `sudo`:

```Dockerfile

FROM ghcr.io/gp-devenv/gp-ncs-devenv:22.04

# Switch to root to make changes
USER root

# Remove the specific config for sudo and add to sudo group
RUN rm /etc/sudoers.d/vscode && \
    apt-get purge -y sudo

# Switch back to vscode
USER vscode
```

<div id="faq2"/>

### 2. Is there an example to use it with Visual Studio Code ?

There will be one soon !!! Add notification to this project so that when the
update on this file is done you can check.

<div id="known_issues" />

## Known issues

See known issues [here](./KNOWN_ISSUES.md).

<div id="contrib" />

## Contributions

See instructions [here](./CONTRIBUTING.md).

<div id="license" />

## License

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

See license [here](./LICENSE.md).
