# Rapid NixOS deployments for edge devices and robots 🚀

This project demonstrates how to deploy a [NixOS](https://nixos.org/) configuration to robots or edge devices using [FlakeHub](https://flakehub.com) _in seconds_ ⏱️

- **Initial deployment completes in _less than 60 seconds_**
- **Subsequent deployments take _less than 10 seconds_**

The deployment process fetches pre-built NixOS [closures](https://zero-to-nix.com/concepts/closures) from [FlakeHub](https://flakehub.com) and applies them to your devices, dramatically reducing deployment time and ensuring consistency across your fleet.

## ✨ Sign up for FlakeHub ✨

To experience this streamlined NixOS deployment pipeline yourself, [**sign up for FlakeHub**](https://flakehub.com) at https://flakehub.com.

FlakeHub provides the enterprise-grade Nix infrastructure needed to fully use these advanced deployment techniques, ensuring a secure and efficient path from development to production.

## ⚠️ Disclaimer

> **IMPORTANT**: This repository contains demo configurations intended for educational and testing purposes only.
>
> These configurations should **NOT** be applied to production systems without thorough review and adaptation.
> The flakes, configurations, and workflows demonstrated here are designed to showcase FlakeHub's capabilities.
>
> Before adapting these techniques for real-world use:
> - Thoroughly test in isolated environments
> - Review and customize configurations for your specific requirements

## Running the demo deployment

In this demo, you'll deploy a minimal NixOS configuration to a robot or edge device.

> [!TIP]
> For a full explanation of how everything works, see [What's in the demo](#whats-in-the-demo) below.

### Run it locally

To deploy the NixOS configuration to your robot or edge device:

```shell
# Clone the repo
git clone https://github.com/AmbiguousTechnologies/robot
cd robot

# Build the NixOS configuration locally and push to FlakeHub Cache
nix build .#nixosConfigurations.robot.config.system.build.toplevel

# Deploy to your device (replace DEVICE_IP with your robot's IP address)
ssh root@DEVICE_IP "curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate"
ssh root@DEVICE_IP "determinate-nixd login token" # Follow the prompts to authenticate
ssh root@DEVICE_IP "fh apply nixos AmbiguousTechnologies/nixos-robot/0.1"
```

## What's in the demo

This demonstration project consists of the following key components:

- **Nix [flake](https://zero-to-nix.com/concepts/flakes) configuration**: A Nix flake that defines the NixOS configuration for robot or edge devices.
- **NixOS modules**: Configuration modules that set up a minimal but functional NixOS system.
- **GitHub Actions workflow**: A workflow that builds the NixOS configuration and publishes it to FlakeHub.

### Nix flake ❄️

The [`flake.nix`](./flake.nix) sets up a NixOS configuration:

- **Inputs**: Specifies dependencies from FlakeHub:
  - `nixpkgs`: Nixpkgs flake from FlakeHub.
- **Outputs**: Defines the NixOS configuration:
  - `nixosConfigurations.robot`: A NixOS configuration for robot systems.

### NixOS Configuration 🤖

The [`nixos/configuration.nix`](./nixos/configuration.nix) file defines a minimal NixOS system:

- Installs git and other essential packages
- Enables SSH with secure defaults
- Configures a user account with initial password
- Sets up Nix with flakes enabled
- Disables Nix channels in favor of flakes

The [`nixos/hardware-configuration.nix`](./nixos/hardware-configuration.nix) includes basic hardware settings:

- Enables systemd-boot for UEFI systems
- Configures the root filesystem
- Specifies x86_64-linux as the platform

### Deployment with `fh apply` 🚀

The `fh apply nixos` command is the key to this demo's efficiency:

1. **Zero evaluation overhead**: Unlike traditional `nixos-rebuild` commands, `fh apply` skips local Nix evaluation entirely.
2. **Pre-cached closures**: FlakeHub Cache stores pre-built closures of your NixOS configurations.
3. **Resource efficiency**: Ideal for resource-constrained edge devices that might struggle with full Nix evaluation.
4. **Authentication integration**: Leverages your Determinate Nix authentication with FlakeHub.

```bash
# Apply a NixOS configuration without local evaluation
fh apply nixos "AmbiguousTechnologies/robot/0.1#nixosConfigurations.robot"
```

If you don't specify a flake output path, `fh apply nixos` defaults to `nixosConfigurations.$(hostname)`. If your device's hostname is "robot", these two commands are equivalent:

```bash
fh apply nixos "AmbiguousTechnologies/robot/0.1#nixosConfigurations.robot"
fh apply nixos "AmbiguousTechnologies/robot/0.1"
```

## Summary 🤔

Deploying NixOS to edge devices or robots via FlakeHub offers significant advantages over traditional methods:

### Resource efficiency

- **FlakeHub deployment**: Perfect for resource-constrained devices that don't have the memory or CPU to evaluate complex Nix expressions.
- **Traditional deployment**: Requires significant resources on the target device for evaluation, which may not be available on embedded systems.

### Deployment speed

- **FlakeHub deployment**: Configurations are pre-evaluated and pre-built. Deployment only requires downloading and applying the closure.
- **Traditional deployment**: Each deployment requires evaluation and building, which can be extremely time-consuming on low-powered devices.

### Security

- **FlakeHub deployment**: Configurations are built in controlled CI environments and cryptographically verified.
- **Traditional deployment**: Building on the edge device might introduce vulnerabilities if the build environment isn't properly secured.

### Fleet consistency

- **FlakeHub deployment**: The same evaluated closure is applied to all devices, ensuring identical configurations.
- **Traditional deployment**: Small differences in local environments or timestamps can lead to subtle inconsistencies across your fleet.

In summary, using FlakeHub for NixOS deployments to edge devices ensures that your robots and IoT devices receive identical, secure configurations with minimal resource usage and deployment time, enabling faster iteration and more reliable updates across your entire fleet.
