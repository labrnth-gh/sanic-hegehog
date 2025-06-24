## Base Image Configuration

Building a NixOS installer is very similar to configuring a regular NixOS 
system. The procedure is documented in the 
[official NixOS wiki](https://wiki.nixos.org/wiki/Creating_a_NixOS_live_CD).

The configuration here provisions the livecd with a known hostname `nixos-base`
and default user/password `user:user` and host keys for ssh access. It also
contains some helper utilities such as `git` for fetching configurations and 
`urxvt-unicode` for terminfo (if your TERM requires it).

To build:
1. `cd` to this folder
2. Set the `NIX_PATH` environment variable to point 
   [nix-build(1)](https://manpages.debian.org/nix-build.1) the configuration file
   and specify the upstream channel for nixpkgs (`nixos-25.05`).
   ```bash
   export NIX_PATH=nixos-config=$PWD/configuration.nix:nixpkgs=channel:nixos-25.05
   ```
3. Run `nix-build` to produce the installation iso
   ```bash
   nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage
   ```

Finally boot the edge device from this image and note the IP address that it
is assigned. We will need this in the provisioning step.