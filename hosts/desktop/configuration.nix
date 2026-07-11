{ config, pkgs, lib, ... }:

{
  imports =
    [ 
      ../../modules/common.nix
      ../../modules/gaming.nix
      ./hardware-configuration.nix
    ];

  networking.hostName = "desktop"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "America/Denver";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Hide extraneous disks
  services.udev.extraRules = ''
    # Hide specific encrypted partitions from GNOME Files sidebar
    ENV{ID_FS_UUID}=="5a37508d-66a3-40ba-a228-cdeb5606e521", ENV{UDISKS_IGNORE}="1"
    ENV{ID_FS_UUID}=="d57a23be-cf31-405e-ac09-9cb06e6331c1", ENV{UDISKS_IGNORE}="1"
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
