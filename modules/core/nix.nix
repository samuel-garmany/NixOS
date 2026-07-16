{
  config.nixos.base = { config, pkgs, lib, ... }: {
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;
  
    # Enable flakes and the nix command
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  
    # Weekly garbage collect
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    # Allow insecure electron to use obsidian
    nixpkgs.config.permittedInsecurePackages = [
      "electron-39.8.10"
    ];
    # Disable the NixOS manual
    documentation.nixos.enable = false;
  };
}
