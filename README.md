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
graph TD
  classDef flake fill:#5277C3,stroke:#fff,stroke-width:2px,color:#fff,font-weight:bold,rx:10,ry:10;
  classDef input fill:#7EBAE4,stroke:#5277C3,stroke-width:2px,color:#111,rx:5,ry:5;
  classDef local fill:#7EBAE4,stroke:#5277C3,stroke-width:2px,color:#111,rx:5,ry:5;
  classDef output fill:#5277C3,stroke:#7EBAE4,stroke-width:2px,color:#fff,rx:5,ry:5;
  Flake["<b>3. Evaluator (flake.nix)</b><hr/><i>Merges inputs with local<br/>code to produce outputs</i>"]:::flake

  subgraph Inputs [1. External Flake Inputs]
    direction TB
    in_flake_parts[flake-parts]:::input
    in_home_manager[home-manager]:::input
    in_lanzaboote[lanzaboote]:::input
    in_nixos_hardware[nixos-hardware]:::input
    in_nixpkgs[nixpkgs]:::input
    in_nvf[nvf]:::input
  end
  Inputs --> Flake

  subgraph Local [2. Local Repository (Source Code)]
    direction TB
    h_Hosts["<b>hosts/</b><hr/>- desktop<br/>- laptop"]:::local
    m_apps["<b>modules/apps/</b><hr/>- communication.nix<br/>- dev.nix<br/>- firefox.nix<br/>- gaming.nix<br/>- git.nix<br/>- joplin.nix<br/>- media.nix<br/>- neovim.nix<br/>- nextcloud.nix<br/>- office.nix<br/>- thunderbird.nix<br/>- writing.nix<br/>- zotero.nix"]:::local
    m_cli["<b>modules/cli/</b><hr/>- bat.nix<br/>- eza.nix<br/>- fzf.nix<br/>- utils.nix<br/>- zoxide.nix"]:::local
    m_core["<b>modules/core/</b><hr/>- boot.nix<br/>- hardware.nix<br/>- locale.nix<br/>- networking.nix<br/>- nix.nix<br/>- options.nix<br/>- packages.nix<br/>- security.nix<br/>- tailscale.nix"]:::local
    m_desktop["<b>modules/desktop/</b><hr/>- audio.nix<br/>- fonts.nix<br/>- gnome.nix<br/>- printing.nix"]:::local
    m_shells["<b>modules/shells/</b><hr/>- direnv.nix<br/>- fish.nix<br/>- pyqt.nix<br/>- r.nix<br/>- starship.nix"]:::local
    m_users["<b>modules/users/</b><hr/>- user.nix"]:::local
  end
  Local --> Flake

  subgraph Outputs [4. Final System Outputs]
    direction TB
    out_devShells_x86_64_linux_pyqt[devShells.x86_64-linux.pyqt]:::output
    out_devShells_x86_64_linux_r[devShells.x86_64-linux.r]:::output
    out_nixosConfigurations_desktop[nixosConfigurations.desktop]:::output
    out_nixosConfigurations_laptop[nixosConfigurations.laptop]:::output
  end
  Flake --> Outputs
```
<!-- FLAKE_MAP_END -->
