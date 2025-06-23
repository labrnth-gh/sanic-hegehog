{ modulesPath, pkgs, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      ./hardware-configuration.nix
      ./disk-config.nix
    ];

  nix.settings = {
    experimental-features = "nix-command flakes";
  };

  ### BOOTLOADER ###
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  ### NETWORKING ###
  networking.hostName = "nixos-edge";
  networking.networkmanager.enable = true;

  ### LOCALE and TZ ###
  time.timeZone = "Etc/UTC";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  ### USER INTERFACE ###
  # KDE Plasma with SDDM
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  ### USERS ###
  users.mutableUsers = false;
  security.sudo.wheelNeedsPassword = false;
  users.users.user = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBTVzY9/XGDuNR6G3poED7Seu25nLHrQcbgXgt1p6ApS dev"
    ];

    isNormalUser = true;
    description = "user";
    extraGroups = [ "networkmanager" "wheel" ];
    initialPassword = "user";
    shell = pkgs.bash;
    packages = with pkgs; [
      kdePackages.kate
    ];
  };
  # This allows us to upgrade the system over SSH
  nix.settings.trusted-users = [ "user" "root" ];

  ### SYSTEM PACKAGES and SERVICES ###
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # Packages installed in the system profile
  environment.systemPackages = with pkgs; [
  vim
  python314
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  networking.firewall.allowedTCPPorts = [ 8000 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "25.05";

}
