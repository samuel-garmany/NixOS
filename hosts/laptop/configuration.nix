{ config, pkgs, lib, ... }:

{
  imports =
    [ 
      ../../modules/common.nix
      ./hardware-configuration.nix
    ];

  networking.hostName = "laptop"; # Define your hostname.

  # Enable automatic timezone and location services for weather
  services.automatic-timezoned.enable = true;
  services.geoclue2.geoProviderUrl = "https://api.beacondb.net/v1/geolocate";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
