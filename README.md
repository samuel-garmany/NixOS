# NixOS Configuration

My personal system configuration for [NixOS](https://nixos.org), a Linux distribution where your entire operating system — packages, services, users, boot — is defined in code and reproducible across machines.

This setup is organized around the [Dendritic Pattern](https://github.com/mightyiam/dendritic) using [flake-parts](https://flake.parts), and leans on a few community projects I'd recommend to anyone getting started:
- [lanzaboote](https://github.com/nix-community/lanzaboote) — Secure Boot
- [nvf](https://github.com/notashelf/nvf) — Neovim configuration
- [home-manager](https://github.com/nix-community/home-manager) — declarative user environments
- [nixos-hardware](https://github.com/NixOS/nixos-hardware) — hardware-specific quirks
