# nixos-edge
**_Install Edge device NixOS configuration_**

<img src="https://raw.githubusercontent.com/labrnth-gh/sanic-hegehog/refs/heads/0001/logo.webp" width="150" height="150">


## README

This repository contains the files and configuration details, and procedure for
initalizing and updating our edge device. It is meant to be run on a current 
NixOS development machine (targeting `nixos-25.05` (Warbler) LTS channel 
with Flakes). This repository specifies a 3-step process:

1. The creation of a base NixOS ISO using `nix-build`. The edge device should 
   be booted from this image (via USB, PXE, etc.) It is assumed that the edge 
   device is configured with a UEFI bootloader and is capable of booting from 
   this image. This configuration can be found under `nix-config/iso`.
2. The provisioning of the edge device using nixos-everywhere. It assumed that 
   the edge device was booted from the ISO created in the previous step. It is 
   also assumed that the edge device and the workstation are reachable and the 
   IP address of the edge device is known. Finally, the edge device must have 
   internet access in order to complete OS provisioning 
   (for downloading packages from nixpkgs). These instructions can be found
   in `nix-config/edgeos`.
3. Updating the edge device using `nixos-rebuild`. These instructons can be
   found in `nix-config/edgeos`.