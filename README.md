# NixOS Configuration

A modular and declarative NixOS setup managed via Flakes. It is built around the [Dendritic Pattern](https://github.com/mightyiam/dendritic), which heavily utilizes [flake-parts](https://flake.parts) to organize system configurations and reusable feature modules cleanly across different hosts.

This flake brings together several prominent community projects:
- [lanzaboote](https://github.com/nix-community/lanzaboote) for Secure Boot support.
- [nvf](https://github.com/notashelf/nvf) for robust Neovim configurations.
- [home-manager](https://github.com/nix-community/home-manager) for declarative user environments.
- [nixos-hardware](https://github.com/NixOS/nixos-hardware) for host-specific hardware quirks.

## Architecture Map

The mindmap below visualizes the entire flake architecture. It is **auto-generated** on push by a GitHub Action that parses the Nix schema (`nix flake show` & `metadata`) and scans the local repository structure to map inputs, local modules, and final outputs.

## Flake Map

<!-- FLAKE_MAP_START -->
```mermaid
mindmap
  root((flake.nix))
    Inputs
      flake-parts
      home-manager
      lanzaboote
      nixos-hardware
      nixpkgs
      nvf
    Local Repository
      Hosts
        desktop
        laptop
      Modules
        Apps
          communication
          dev
          firefox
          gaming
          git
          joplin
          media
          neovim
          nextcloud
          office
          thunderbird
          writing
          zotero
        Cli
          bat
          eza
          fzf
          utils
          zoxide
        Core
          boot
          hardware
          locale
          networking
          nix
          options
          packages
          security
          tailscale
        Desktop
          audio
          fonts
          gnome
          printing
        Shells
          direnv
          fish
          pyqt
          r
          starship
        Users
          user
    Outputs
      devShells
        x86_64-linux
          pyqt
          r
      nixosConfigurations
        desktop
        laptop
```
<!-- FLAKE_MAP_END -->
