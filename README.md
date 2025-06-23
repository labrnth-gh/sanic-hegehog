# nixos-edge
**_Install Edge device NixOS configuration_**


## README

This repository contains the files and configuration details, and procedure for
initalizing and updating our edge device. It is meant to be run on a current 
NixOS development machine (targeting `nixos-25.05` (Warbler) LTS channel 
with Flakes). This repository specifies a 3-step process:

1. The creation of a base NixOS ISO using `nix-build`. The edge device should 
   be booted from this image (via USB, PXE, etc.) It is assumed that the edge 
   device is configured with a UEFI bootloader and is capable of booting from 
   this image. This configuration can be found under `nix-config/iso`.