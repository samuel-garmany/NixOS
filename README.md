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
  classDef flake fill:#5277C3,stroke:#fff,stroke-width:2px,color:#fff,font-weight:bold,rx:10,ry:10;
  classDef input fill:#E3F2FD,stroke:#5277C3,stroke-width:2px,color:#1565C0,rx:5,ry:5;
  classDef local fill:#E8F5E9,stroke:#2E7D32,stroke-width:2px,color:#1B5E20,rx:5,ry:5;
  classDef output fill:#FFF3E0,stroke:#E65100,stroke-width:2px,color:#E65100,rx:5,ry:5;
  Flake("flake.nix"):::flake

  subgraph Inputs ["Flake Inputs"]
    direction TB
    in_flake_parts(["flake-parts"]):::input
    in_home_manager(["home-manager"]):::input
    in_lanzaboote(["lanzaboote"]):::input
    in_nixos_hardware(["nixos-hardware"]):::input
    in_nixpkgs(["nixpkgs"]):::input
    in_nvf(["nvf"]):::input
  end
  Inputs --> Flake

  subgraph Local ["Local Repository"]
    direction TB
    loc_hosts["<b>hosts/</b><br/><small>desktop, laptop</small>"]:::local
    loc_modules["<b>modules/</b><br/><small>apps, cli, core, desktop, shells, users</small>"]:::local
  end
  Local --> Flake

  subgraph Outputs ["Flake Outputs"]
    direction TB
    subgraph out_devShells ["devShells"]
      direction TB
      out_devShells_x86_64_linux_pyqt("x86_64-linux.pyqt"):::output
      out_devShells_x86_64_linux_r("x86_64-linux.r"):::output
    end
    subgraph out_nixosConfigurations ["nixosConfigurations"]
      direction TB
      out_nixosConfigurations_desktop("desktop"):::output
      out_nixosConfigurations_laptop("laptop"):::output
    end
  end
  Flake --> Outputs
```
<!-- FLAKE_MAP_END -->
