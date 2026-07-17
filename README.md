# NixOS Configuration

Welcome to my NixOS configuration!

## Flake Map

<!-- FLAKE_MAP_START -->
```mermaid
mindmap
  root((flake.nix))
    inputs
      flake-parts
      home-manager
      lanzaboote
      nixos-hardware
      nixpkgs
      nvf
    Local Repository
      ./hosts
        desktop
        laptop
      ./modules
        apps
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
        cli
          bat
          eza
          fzf
          utils
          zoxide
        core
          boot
          hardware
          locale
          networking
          nix
          options
          packages
          security
          tailscale
        desktop
          audio
          fonts
          gnome
          printing
        shells
          direnv
          fish
          pyqt
          r
          starship
        users
          user
    outputs
      devShells
        x86_64-linux
          pyqt
          r
      nixosConfigurations
        desktop
        laptop
```
<!-- FLAKE_MAP_END -->
