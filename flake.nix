{
  description = "A Dendritic Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    flake-parts.url = "github:hercules-ci/flake-parts";

    # Lanzaboote handles Secure Boot for NixOS
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf.url = "github:notashelf/nvf";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nix-flatpak.url = "github:gmodena/nix-flatpak"; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { config, ... }: {
        systems = [ "x86_64-linux" ];

        imports =
          let
            # Since all non-entry-point files are top-level modules and their paths convey meaning only to the author, they can all be automatically imported using a trivial expression
            allFiles = inputs.nixpkgs.lib.filesystem.listFilesRecursive ./modules;
            allModules = builtins.filter (
              file: inputs.nixpkgs.lib.hasSuffix ".nix" (builtins.toString file)
            ) allFiles;
          in
          allModules
          ++ [
            ./hosts/desktop/configuration.nix
            ./hosts/laptop/configuration.nix
          ];

        flake = {
          nixosConfigurations = {
            desktop = inputs.nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              modules = [
                config.nixos.desktop
                inputs.lanzaboote.nixosModules.lanzaboote
                inputs.nvf.nixosModules.default
                inputs.home-manager.nixosModules.home-manager
                inputs.nix-flatpak.nixosModules.nix-flatpak
                inputs.nixos-hardware.nixosModules.common-cpu-intel
                inputs.nixos-hardware.nixosModules.common-pc-ssd
                inputs.nixos-hardware.nixosModules.common-gpu-amd
              ];
            };

            laptop = inputs.nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              modules = [
                config.nixos.laptop
                inputs.lanzaboote.nixosModules.lanzaboote
                inputs.nvf.nixosModules.default
                inputs.home-manager.nixosModules.home-manager
                inputs.nix-flatpak.nixosModules.nix-flatpak
                inputs.nixos-hardware.nixosModules.framework-13-7040-amd
              ];
            };
          };
        };
      }
    );
}
