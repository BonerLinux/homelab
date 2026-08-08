{ config, pkgs, ... }:

{
  # Update this to match your system's hardware profile if needed.
  # imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "UTC";

  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
  };

  services.openssh.enable = true;

  virtualisation.docker.enable = true;
  environment.systemPackages = [
    pkgs.docker-compose
  ];

  system.stateVersion = "24.05";
}
