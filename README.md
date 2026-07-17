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
  classDef flake fill:#3b82f6,stroke:#1e3a8a,stroke-width:3px,color:#fff,font-weight:bold,rx:10,ry:10;
  classDef input fill:#10b981,stroke:#064e3b,color:#fff,rx:5,ry:5;
  classDef local fill:#f59e0b,stroke:#78350f,color:#fff,rx:5,ry:5;
  classDef output fill:#8b5cf6,stroke:#4c1d95,color:#fff,rx:5,ry:5;
  Flake[flake.nix]:::flake

  subgraph Inputs [Flake Inputs]
    direction TB
    in_flake_parts[flake-parts]:::input
    in_home_manager[home-manager]:::input
    in_lanzaboote[lanzaboote]:::input
    in_nixos_hardware[nixos-hardware]:::input
    in_nixpkgs[nixpkgs]:::input
    in_nvf[nvf]:::input
  end
  Inputs --> Flake

  subgraph Local [Local Repository]
    direction TB
    subgraph Hosts
      direction TB
      h_desktop[desktop]:::local
      h_laptop[laptop]:::local
    end
    subgraph Modules
      direction TB
      m_apps[Apps]:::local
      m_cli[Cli]:::local
      m_core[Core]:::local
      m_desktop[Desktop]:::local
      m_shells[Shells]:::local
      m_users[Users]:::local
    end
  end
  Local --> Flake

  subgraph Outputs [Flake Outputs]
    direction TB
    out_devShells_x86_64_linux_pyqt["<b>devShells.x86_64-linux.pyqt</b><hr/><i>Packages:</i><br/>- python3<br/>- ffmpeg<br/>- git<br/>- qtwayland<br/>- nodejs<br/><i>... (+1 more)</i>"]:::output
    out_devShells_x86_64_linux_r["<b>devShells.x86_64-linux.r</b><hr/><i>Packages:</i><br/>- R<br/>- r-languageserver<br/>- r-rmarkdown<br/>- r-knitr<br/>- r-tidyverse<br/><i>... (+16 more)</i>"]:::output
    out_nixosConfigurations_desktop["<b>nixosConfigurations.desktop</b><hr/><i>Packages:</i><br/>- slack<br/>- zoom<br/>- arduino-ide<br/>- git<br/>- joplin-desktop<br/><i>... (+301 more)</i>"]:::output
    out_nixosConfigurations_laptop["<b>nixosConfigurations.laptop</b><hr/><i>Packages:</i><br/>- slack<br/>- zoom<br/>- arduino-ide<br/>- git<br/>- joplin-desktop<br/><i>... (+297 more)</i>"]:::output
  end
  Flake --> Outputs
```
<!-- FLAKE_MAP_END -->
