{
  config.nixos.base = { config, pkgs, lib, ... }: {
    zramSwap.enable = true;
    systemd.oomd.enable = true;
    services.fwupd.enable = true;
    services.fprintd.enable = true;
    # For Yubikey
    services.udev.packages = [ pkgs.yubikey-personalization ];
    services.pcscd.enable = true;
  };
}
