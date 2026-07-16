{
  config.nixos.desktop = { config, pkgs, lib, ... }: {
    imports = [
      ./hardware-configuration.nix
    ];

    networking.hostName = "desktop"; # Define your hostname.

    # Hide extraneous disks
    services.udev.extraRules = ''
      # Hide specific encrypted partitions from GNOME Files sidebar
      ENV{ID_FS_UUID}=="5a37508d-66a3-40ba-a228-cdeb5606e521", ENV{UDISKS_IGNORE}="1"
      ENV{ID_FS_UUID}=="d57a23be-cf31-405e-ac09-9cb06e6331c1", ENV{UDISKS_IGNORE}="1"
    '';

    system.stateVersion = "26.05"; # Did you read the comment?
  };
}
