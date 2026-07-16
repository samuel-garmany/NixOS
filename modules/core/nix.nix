{
  config.nixos.base =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;

      # Enable flakes, nix command, and optimize storage
      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        auto-optimise-store = true;
      };

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
