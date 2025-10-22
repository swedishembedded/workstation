# ==============================================================================
# Docker Buildx Bake Configuration
# ==============================================================================
# Build all targets in parallel:
#   docker buildx bake
#
# Build specific targets:
#   docker buildx bake boot dev
#
# Build for specific Ubuntu version:
#   docker buildx bake -f docker-bake.hcl ubuntu24
#   docker buildx bake -f docker-bake.hcl ubuntu25
#
# Build both Ubuntu versions:
#   docker buildx bake -f docker-bake.hcl all-ubuntu
#
# Build for multiple platforms:
#   docker buildx bake --set=*.platform=linux/amd64,linux/arm64
#
# Push to registry:
#   docker buildx bake --push
# ==============================================================================

# ==============================================================================
# Variables
# ==============================================================================
variable "DOCKERFILE" {
  default = "Dockerfile"
}

variable "REGISTRY" {
  default = "swedishembedded"
}

variable "PLATFORMS" {
  default = "linux/amd64"
}

variable "TAG" {
  default = "latest"
}

variable "VERSION" {
  default = ""
}

variable "CONTEXT" {
  default = "."
}

# ==============================================================================
# Groups
# ==============================================================================
group "default" {
  targets = ["boot", "dev", "rust", "zephyr", "workstation"]
}

group "base" {
  targets = ["boot", "dev"]
}

group "full" {
  targets = ["boot", "dev", "rust", "zephyr", "workstation"]
}

# Ubuntu version-specific groups
group "ubuntu24" {
  targets = ["boot-24", "dev-24", "rust-24", "zephyr-24", "workstation-24"]
}

group "ubuntu25" {
  targets = ["boot-25", "dev-25", "rust-25", "zephyr-25", "workstation-25"]
}

group "all-ubuntu" {
  targets = [
    "boot-24", "dev-24", "rust-24", "zephyr-24", "workstation-24",
    "boot-25", "dev-25", "rust-25", "zephyr-25", "workstation-25"
  ]
}

# ==============================================================================
# Common Target Configuration
# ==============================================================================
target "_common" {
  dockerfile = "${DOCKERFILE}"
  context    = "${CONTEXT}"
  platforms  = split(",", "${PLATFORMS}")
}

# ==============================================================================
# Target: boot
# ==============================================================================
target "boot" {
  inherits = ["_common"]
  target   = "boot"
  tags     = ["${REGISTRY}/boot:${TAG}"]
  labels   = {
    "org.opencontainers.image.title"       = "Swedish Embedded Boot"
    "org.opencontainers.image.description" = "Base OS with build essentials and Python"
    "org.opencontainers.image.vendor"      = "Swedish Embedded"
  }
}

# ==============================================================================
# Target: dev
# ==============================================================================
target "dev" {
  inherits = ["_common"]
  target   = "dev"
  tags     = ["${REGISTRY}/dev:${TAG}"]
  labels   = {
    "org.opencontainers.image.title"       = "Swedish Embedded Dev"
    "org.opencontainers.image.description" = "Development tools, Node.js, Docker CLI, and editors"
    "org.opencontainers.image.vendor"      = "Swedish Embedded"
  }
}

# ==============================================================================
# Target: rust
# ==============================================================================
target "rust" {
  inherits = ["_common"]
  target   = "rust"
  tags     = ["${REGISTRY}/rust:${TAG}"]
  labels   = {
    "org.opencontainers.image.title"       = "Swedish Embedded Rust"
    "org.opencontainers.image.description" = "Rust toolchain with cross-compilation targets"
    "org.opencontainers.image.vendor"      = "Swedish Embedded"
  }
}

# ==============================================================================
# Target: zephyr
# ==============================================================================
target "zephyr" {
  inherits = ["_common"]
  target   = "zephyr"
  tags     = ["${REGISTRY}/zephyr:${TAG}"]
  labels   = {
    "org.opencontainers.image.title"       = "Swedish Embedded Zephyr"
    "org.opencontainers.image.description" = "Zephyr RTOS CI/build environment with SDK and tooling"
    "org.opencontainers.image.vendor"      = "Swedish Embedded"
  }
}

# ==============================================================================
# Target: workstation
# ==============================================================================
target "workstation" {
  inherits = ["_common"]
  target   = "workstation"
  tags     = ["${REGISTRY}/workstation:${TAG}"]
  labels   = {
    "org.opencontainers.image.title"       = "Swedish Embedded Workstation"
    "org.opencontainers.image.description" = "Full developer workstation with UX tools and configurations"
    "org.opencontainers.image.vendor"      = "Swedish Embedded"
  }
}

# ==============================================================================
# Ubuntu 24.04 Targets
# ==============================================================================
target "boot-24" {
  inherits = ["_common"]
  target   = "boot"
  args     = {
    UBUNTU_VERSION = "24.04"
  }
  tags = [
    "${REGISTRY}/boot:${TAG}-ubuntu24.04",
    "${REGISTRY}/boot:ubuntu24.04",
    notequal("", VERSION) ? "${REGISTRY}/boot:${VERSION}+ubuntu24.04" : ""
  ]
  labels = {
    "org.opencontainers.image.title"       = "Swedish Embedded Boot (Ubuntu 24.04)"
    "org.opencontainers.image.description" = "Base OS with build essentials and Python (Ubuntu 24.04 LTS)"
    "org.opencontainers.image.vendor"      = "Swedish Embedded"
    "org.opencontainers.image.version"     = notequal("", VERSION) ? "${VERSION}+ubuntu24.04" : ""
  }
}

target "dev-24" {
  inherits = ["_common"]
  target   = "dev"
  args     = {
    UBUNTU_VERSION = "24.04"
  }
  tags = [
    "${REGISTRY}/dev:${TAG}-ubuntu24.04",
    "${REGISTRY}/dev:ubuntu24.04",
    notequal("", VERSION) ? "${REGISTRY}/dev:${VERSION}+ubuntu24.04" : ""
  ]
  labels = {
    "org.opencontainers.image.title"       = "Swedish Embedded Dev (Ubuntu 24.04)"
    "org.opencontainers.image.description" = "Development tools, Node.js, Docker CLI (Ubuntu 24.04 LTS)"
    "org.opencontainers.image.vendor"      = "Swedish Embedded"
    "org.opencontainers.image.version"     = notequal("", VERSION) ? "${VERSION}+ubuntu24.04" : ""
  }
}

target "rust-24" {
  inherits = ["_common"]
  target   = "rust"
  args     = {
    UBUNTU_VERSION = "24.04"
  }
  tags = [
    "${REGISTRY}/rust:${TAG}-ubuntu24.04",
    "${REGISTRY}/rust:ubuntu24.04",
    notequal("", VERSION) ? "${REGISTRY}/rust:${VERSION}+ubuntu24.04" : ""
  ]
  labels = {
    "org.opencontainers.image.title"       = "Swedish Embedded Rust (Ubuntu 24.04)"
    "org.opencontainers.image.description" = "Rust toolchain with cross-compilation (Ubuntu 24.04 LTS)"
    "org.opencontainers.image.vendor"      = "Swedish Embedded"
    "org.opencontainers.image.version"     = notequal("", VERSION) ? "${VERSION}+ubuntu24.04" : ""
  }
}

target "zephyr-24" {
  inherits = ["_common"]
  target   = "zephyr"
  args     = {
    UBUNTU_VERSION = "24.04"
  }
  tags = [
    "${REGISTRY}/zephyr:${TAG}-ubuntu24.04",
    "${REGISTRY}/zephyr:ubuntu24.04",
    notequal("", VERSION) ? "${REGISTRY}/zephyr:${VERSION}+ubuntu24.04" : ""
  ]
  labels = {
    "org.opencontainers.image.title"       = "Swedish Embedded Zephyr (Ubuntu 24.04)"
    "org.opencontainers.image.description" = "Zephyr RTOS CI/build environment (Ubuntu 24.04 LTS)"
    "org.opencontainers.image.vendor"      = "Swedish Embedded"
    "org.opencontainers.image.version"     = notequal("", VERSION) ? "${VERSION}+ubuntu24.04" : ""
  }
}

target "workstation-24" {
  inherits = ["_common"]
  target   = "workstation"
  args     = {
    UBUNTU_VERSION = "24.04"
  }
  tags = [
    "${REGISTRY}/workstation:${TAG}-ubuntu24.04",
    "${REGISTRY}/workstation:ubuntu24.04",
    notequal("", VERSION) ? "${REGISTRY}/workstation:${VERSION}+ubuntu24.04" : ""
  ]
  labels = {
    "org.opencontainers.image.title"       = "Swedish Embedded Workstation (Ubuntu 24.04)"
    "org.opencontainers.image.description" = "Full developer workstation (Ubuntu 24.04 LTS)"
    "org.opencontainers.image.vendor"      = "Swedish Embedded"
    "org.opencontainers.image.version"     = notequal("", VERSION) ? "${VERSION}+ubuntu24.04" : ""
  }
}

# ==============================================================================
# Ubuntu 25.04 Targets
# ==============================================================================
target "boot-25" {
  inherits = ["_common"]
  target   = "boot"
  args     = {
    UBUNTU_VERSION = "25.04"
  }
  tags = [
    "${REGISTRY}/boot:${TAG}-ubuntu25.04",
    "${REGISTRY}/boot:ubuntu25.04",
    notequal("", VERSION) ? "${REGISTRY}/boot:${VERSION}+ubuntu25.04" : ""
  ]
  labels = {
    "org.opencontainers.image.title"       = "Swedish Embedded Boot (Ubuntu 25.04)"
    "org.opencontainers.image.description" = "Base OS with build essentials and Python (Ubuntu 25.04)"
    "org.opencontainers.image.vendor"      = "Swedish Embedded"
    "org.opencontainers.image.version"     = notequal("", VERSION) ? "${VERSION}+ubuntu25.04" : ""
  }
}

target "dev-25" {
  inherits = ["_common"]
  target   = "dev"
  args     = {
    UBUNTU_VERSION = "25.04"
  }
  tags = [
    "${REGISTRY}/dev:${TAG}-ubuntu25.04",
    "${REGISTRY}/dev:ubuntu25.04",
    notequal("", VERSION) ? "${REGISTRY}/dev:${VERSION}+ubuntu25.04" : ""
  ]
  labels = {
    "org.opencontainers.image.title"       = "Swedish Embedded Dev (Ubuntu 25.04)"
    "org.opencontainers.image.description" = "Development tools, Node.js, Docker CLI (Ubuntu 25.04)"
    "org.opencontainers.image.vendor"      = "Swedish Embedded"
    "org.opencontainers.image.version"     = notequal("", VERSION) ? "${VERSION}+ubuntu25.04" : ""
  }
}

target "rust-25" {
  inherits = ["_common"]
  target   = "rust"
  args     = {
    UBUNTU_VERSION = "25.04"
  }
  tags = [
    "${REGISTRY}/rust:${TAG}-ubuntu25.04",
    "${REGISTRY}/rust:ubuntu25.04",
    notequal("", VERSION) ? "${REGISTRY}/rust:${VERSION}+ubuntu25.04" : ""
  ]
  labels = {
    "org.opencontainers.image.title"       = "Swedish Embedded Rust (Ubuntu 25.04)"
    "org.opencontainers.image.description" = "Rust toolchain with cross-compilation (Ubuntu 25.04)"
    "org.opencontainers.image.vendor"      = "Swedish Embedded"
    "org.opencontainers.image.version"     = notequal("", VERSION) ? "${VERSION}+ubuntu25.04" : ""
  }
}

target "zephyr-25" {
  inherits = ["_common"]
  target   = "zephyr"
  args     = {
    UBUNTU_VERSION = "25.04"
  }
  tags = [
    "${REGISTRY}/zephyr:${TAG}-ubuntu25.04",
    "${REGISTRY}/zephyr:ubuntu25.04",
    notequal("", VERSION) ? "${REGISTRY}/zephyr:${VERSION}+ubuntu25.04" : ""
  ]
  labels = {
    "org.opencontainers.image.title"       = "Swedish Embedded Zephyr (Ubuntu 25.04)"
    "org.opencontainers.image.description" = "Zephyr RTOS CI/build environment (Ubuntu 25.04)"
    "org.opencontainers.image.vendor"      = "Swedish Embedded"
    "org.opencontainers.image.version"     = notequal("", VERSION) ? "${VERSION}+ubuntu25.04" : ""
  }
}

target "workstation-25" {
  inherits = ["_common"]
  target   = "workstation"
  args     = {
    UBUNTU_VERSION = "25.04"
  }
  tags = [
    "${REGISTRY}/workstation:${TAG}-ubuntu25.04",
    "${REGISTRY}/workstation:ubuntu25.04",
    notequal("", VERSION) ? "${REGISTRY}/workstation:${VERSION}+ubuntu25.04" : ""
  ]
  labels = {
    "org.opencontainers.image.title"       = "Swedish Embedded Workstation (Ubuntu 25.04)"
    "org.opencontainers.image.description" = "Full developer workstation (Ubuntu 25.04)"
    "org.opencontainers.image.vendor"      = "Swedish Embedded"
    "org.opencontainers.image.version"     = notequal("", VERSION) ? "${VERSION}+ubuntu25.04" : ""
  }
}

