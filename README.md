# NixOS Configuration

My modular and declarative NixOS setup managed via Flakes. It is built around the [Dendritic Pattern](https://github.com/mightyiam/dendritic), which heavily utilizes [flake-parts](https://flake.parts) to organize system configs and reusable feature modules across different hosts.

This flake uses a few more prominent community projects that I highly recommend:
- [lanzaboote](https://github.com/nix-community/lanzaboote) for Secure Boot support.
- [nvf](https://github.com/notashelf/nvf) for super simple Neovim configurations.
- [home-manager](https://github.com/nix-community/home-manager) for declarative user environments.
- [nixos-hardware](https://github.com/NixOS/nixos-hardware) for host-specific hardware quirks.

## Architecture Map

The flowchart below visualizes the entire flake architecture. It is **auto-generated** on push by a GitHub Action that parses the Nix schema (`nix flake show` & `metadata`) and scans the local repository structure to map inputs, local modules, and final outputs.

## Flake Map

<!-- FLAKE_MAP_START -->
```mermaid
graph LR
  classDef flake fill:#5277C3,stroke:#fff,stroke-width:2px,color:#fff,font-weight:bold,rx:20,ry:20;
  classDef input fill:#7EBAE4,stroke:#5277C3,stroke-width:2px,color:#111,rx:20,ry:20;
  classDef local fill:#7EBAE4,stroke:#5277C3,stroke-width:2px,color:#111,rx:20,ry:20;
  classDef output fill:#5277C3,stroke:#7EBAE4,stroke-width:2px,color:#fff,rx:20,ry:20;
  Flake(flake.nix):::flake

  subgraph Inputs [Flake Inputs]
    direction TB
    in_flake_parts(flake-parts):::input
    in_home_manager(home-manager):::input
    in_lanzaboote(lanzaboote):::input
    in_nixos_hardware(nixos-hardware):::input
    in_nixpkgs(nixpkgs):::input
    in_nvf(nvf):::input
  end
  Inputs --> Flake

  subgraph Local [Local Repository]
    direction TB
    h_Hosts(hosts/
desktop, laptop):::local
    m_apps(modules/apps/
communication, dev, firefox, gaming, git, joplin, media, neovim, nextcloud, office, thunderbird, writing, zotero):::local
    m_cli(modules/cli/
bat, eza, fzf, utils, zoxide):::local
    m_core(modules/core/
boot, hardware, locale, networking, nix, options, packages, security, tailscale):::local
    m_desktop(modules/desktop/
audio, fonts, gnome, printing):::local
    m_shells(modules/shells/
direnv, fish, pyqt, r, starship):::local
    m_users(modules/users/
user):::local
  end
  Local --> Flake

  subgraph Outputs [Flake Outputs]
    direction TB
    out_devShells_x86_64_linux_pyqt(devShells.x86_64-linux.pyqt):::output
    out_devShells_x86_64_linux_r(devShells.x86_64-linux.r):::output
    out_nixosConfigurations_desktop(nixosConfigurations.desktop):::output
    out_nixosConfigurations_laptop(nixosConfigurations.laptop):::output
  end
  Flake --> Outputs
```
<!-- FLAKE_MAP_END -->
