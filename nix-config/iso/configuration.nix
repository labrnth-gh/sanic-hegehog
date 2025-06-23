{ config, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];
  networking.hostName = "nixos-base";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
  ];
  i18n.defaultLocale = "en_US.UTF-8";

  security.sudo.wheelNeedsPassword = false;
  users.users.user = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBTVzY9/XGDuNR6G3poED7Seu25nLHrQcbgXgt1p6ApS dev"
    ];

    description = "user";
    extraGroups = [ "wheel" ];
    initialPassword = "user";
    shell = pkgs.bash;
    packages = with pkgs; [];
  };

  environment.systemPackages = with pkgs; [
    git
    rsync
    bash
    vim
    emacs
    wget
    curl
    rxvt-unicode
    lshw
  ];

  services.openssh.enable = true;

  system.stateVersion = "25.05";
}
