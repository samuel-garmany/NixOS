# NixOS Configuration

Welcome to my NixOS configuration!

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
