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
  classDef detail fill:#f3f4f6,stroke:#5277C3,stroke-width:1px,color:#111,rx:5,ry:5;
  classDef item fill:#ffffff,stroke:#9ca3af,stroke-width:1px,color:#111,rx:3,ry:3;
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
    subgraph h_Hosts [Hosts]
      direction TB
      h_desktop[desktop]:::local
      h_laptop[laptop]:::local
    end
    subgraph m_Modules [Modules]
      direction TB
      subgraph cat_apps [Apps]
        direction TB
        m_apps_communication[communication.nix]:::local
        m_apps_dev[dev.nix]:::local
        m_apps_firefox[firefox.nix]:::local
        m_apps_gaming[gaming.nix]:::local
        m_apps_git[git.nix]:::local
        m_apps_joplin[joplin.nix]:::local
        m_apps_media[media.nix]:::local
        m_apps_neovim[neovim.nix]:::local
        m_apps_nextcloud[nextcloud.nix]:::local
        m_apps_office[office.nix]:::local
        m_apps_thunderbird[thunderbird.nix]:::local
        m_apps_writing[writing.nix]:::local
        m_apps_zotero[zotero.nix]:::local
      end
      subgraph cat_cli [Cli]
        direction TB
        m_cli_bat[bat.nix]:::local
        m_cli_eza[eza.nix]:::local
        m_cli_fzf[fzf.nix]:::local
        m_cli_utils[utils.nix]:::local
        m_cli_zoxide[zoxide.nix]:::local
      end
      subgraph cat_core [Core]
        direction TB
        m_core_boot[boot.nix]:::local
        m_core_hardware[hardware.nix]:::local
        m_core_locale[locale.nix]:::local
        m_core_networking[networking.nix]:::local
        m_core_nix[nix.nix]:::local
        m_core_options[options.nix]:::local
        m_core_packages[packages.nix]:::local
        m_core_security[security.nix]:::local
        m_core_tailscale[tailscale.nix]:::local
      end
      subgraph cat_desktop [Desktop]
        direction TB
        m_desktop_audio[audio.nix]:::local
        m_desktop_fonts[fonts.nix]:::local
        m_desktop_gnome[gnome.nix]:::local
        m_desktop_printing[printing.nix]:::local
      end
      subgraph cat_shells [Shells]
        direction TB
        m_shells_direnv[direnv.nix]:::local
        m_shells_fish[fish.nix]:::local
        m_shells_pyqt[pyqt.nix]:::local
        m_shells_r[r.nix]:::local
        m_shells_starship[starship.nix]:::local
      end
      subgraph cat_users [Users]
        direction TB
        m_users_user[user.nix]:::local
      end
    end
  end
  Local --> Flake

  subgraph Outputs [Flake Outputs]
    direction TB
    out_devShells_x86_64_linux_pyqt[devShells.x86_64-linux.pyqt]:::output
    out_devShells_x86_64_linux_pyqt_deps[Build Inputs]:::detail
    out_devShells_x86_64_linux_pyqt --- out_devShells_x86_64_linux_pyqt_deps
    out_devShells_x86_64_linux_pyqt_deps_p0[git]:::item
    out_devShells_x86_64_linux_pyqt_deps --- out_devShells_x86_64_linux_pyqt_deps_p0
    out_devShells_x86_64_linux_pyqt_deps_p1[cargo]:::item
    out_devShells_x86_64_linux_pyqt_deps --- out_devShells_x86_64_linux_pyqt_deps_p1
    out_devShells_x86_64_linux_pyqt_deps_p2[ffmpeg]:::item
    out_devShells_x86_64_linux_pyqt_deps --- out_devShells_x86_64_linux_pyqt_deps_p2
    out_devShells_x86_64_linux_pyqt_deps_p3[nodejs]:::item
    out_devShells_x86_64_linux_pyqt_deps --- out_devShells_x86_64_linux_pyqt_deps_p3
    out_devShells_x86_64_linux_pyqt_deps_more[...+ 2 more]:::item
    out_devShells_x86_64_linux_pyqt_deps --- out_devShells_x86_64_linux_pyqt_deps_more
    out_devShells_x86_64_linux_r[devShells.x86_64-linux.r]:::output
    out_devShells_x86_64_linux_r_deps[Build Inputs]:::detail
    out_devShells_x86_64_linux_r --- out_devShells_x86_64_linux_r_deps
    out_devShells_x86_64_linux_r_deps_p0[R]:::item
    out_devShells_x86_64_linux_r_deps --- out_devShells_x86_64_linux_r_deps_p0
    out_devShells_x86_64_linux_r_deps_p1[curl]:::item
    out_devShells_x86_64_linux_r_deps --- out_devShells_x86_64_linux_r_deps_p1
    out_devShells_x86_64_linux_r_deps_p2[fribidi]:::item
    out_devShells_x86_64_linux_r_deps --- out_devShells_x86_64_linux_r_deps_p2
    out_devShells_x86_64_linux_r_deps_p3[r-knitr]:::item
    out_devShells_x86_64_linux_r_deps --- out_devShells_x86_64_linux_r_deps_p3
    out_devShells_x86_64_linux_r_deps_more[...+ 17 more]:::item
    out_devShells_x86_64_linux_r_deps --- out_devShells_x86_64_linux_r_deps_more
    out_nixosConfigurations_desktop[nixosConfigurations.desktop]:::output
    out_nixosConfigurations_desktop_syspkgs[System Packages]:::detail
    out_nixosConfigurations_desktop --- out_nixosConfigurations_desktop_syspkgs
    out_nixosConfigurations_desktop_syspkgs_p0[⭐ steam]:::item
    out_nixosConfigurations_desktop_syspkgs --- out_nixosConfigurations_desktop_syspkgs_p0
    out_nixosConfigurations_desktop_syspkgs_p1[⭐ lutris]:::item
    out_nixosConfigurations_desktop_syspkgs --- out_nixosConfigurations_desktop_syspkgs_p1
    out_nixosConfigurations_desktop_syspkgs_p2[⭐ discord]:::item
    out_nixosConfigurations_desktop_syspkgs --- out_nixosConfigurations_desktop_syspkgs_p2
    out_nixosConfigurations_desktop_syspkgs_p3[xz]:::item
    out_nixosConfigurations_desktop_syspkgs --- out_nixosConfigurations_desktop_syspkgs_p3
    out_nixosConfigurations_desktop_syspkgs_p4[git]:::item
    out_nixosConfigurations_desktop_syspkgs --- out_nixosConfigurations_desktop_syspkgs_p4
    out_nixosConfigurations_desktop_syspkgs_more[...+ 216 more]:::item
    out_nixosConfigurations_desktop_syspkgs --- out_nixosConfigurations_desktop_syspkgs_more
    out_nixosConfigurations_desktop_hm_user[HM Packages: user]:::detail
    out_nixosConfigurations_desktop --- out_nixosConfigurations_desktop_hm_user
    out_nixosConfigurations_desktop_hm_user_p0[jq]:::item
    out_nixosConfigurations_desktop_hm_user --- out_nixosConfigurations_desktop_hm_user_p0
    out_nixosConfigurations_desktop_hm_user_p1[fd]:::item
    out_nixosConfigurations_desktop_hm_user --- out_nixosConfigurations_desktop_hm_user_p1
    out_nixosConfigurations_desktop_hm_user_p2[git]:::item
    out_nixosConfigurations_desktop_hm_user --- out_nixosConfigurations_desktop_hm_user_p2
    out_nixosConfigurations_desktop_hm_user_more[...+ 20 more]:::item
    out_nixosConfigurations_desktop_hm_user --- out_nixosConfigurations_desktop_hm_user_more
    out_nixosConfigurations_desktop_services[Services]:::detail
    out_nixosConfigurations_desktop --- out_nixosConfigurations_desktop_services
    out_nixosConfigurations_desktop_services_p0[gdm]:::item
    out_nixosConfigurations_desktop_services --- out_nixosConfigurations_desktop_services_p0
    out_nixosConfigurations_desktop_services_p1[iwd]:::item
    out_nixosConfigurations_desktop_services --- out_nixosConfigurations_desktop_services_p1
    out_nixosConfigurations_desktop_services_p2[dbus]:::item
    out_nixosConfigurations_desktop_services --- out_nixosConfigurations_desktop_services_p2
    out_nixosConfigurations_desktop_services_more[...+ 92 more]:::item
    out_nixosConfigurations_desktop_services --- out_nixosConfigurations_desktop_services_more
    out_nixosConfigurations_laptop[nixosConfigurations.laptop]:::output
    out_nixosConfigurations_laptop_syspkgs[System Packages]:::detail
    out_nixosConfigurations_laptop --- out_nixosConfigurations_laptop_syspkgs
    out_nixosConfigurations_laptop_syspkgs_p0[⭐ framework-tool]:::item
    out_nixosConfigurations_laptop_syspkgs --- out_nixosConfigurations_laptop_syspkgs_p0
    out_nixosConfigurations_laptop_syspkgs_p1[⭐ iio-sensor-proxy]:::item
    out_nixosConfigurations_laptop_syspkgs --- out_nixosConfigurations_laptop_syspkgs_p1
    out_nixosConfigurations_laptop_syspkgs_p2[xz]:::item
    out_nixosConfigurations_laptop_syspkgs --- out_nixosConfigurations_laptop_syspkgs_p2
    out_nixosConfigurations_laptop_syspkgs_p3[git]:::item
    out_nixosConfigurations_laptop_syspkgs --- out_nixosConfigurations_laptop_syspkgs_p3
    out_nixosConfigurations_laptop_syspkgs_more[...+ 213 more]:::item
    out_nixosConfigurations_laptop_syspkgs --- out_nixosConfigurations_laptop_syspkgs_more
    out_nixosConfigurations_laptop_hm_user[HM Packages: user]:::detail
    out_nixosConfigurations_laptop --- out_nixosConfigurations_laptop_hm_user
    out_nixosConfigurations_laptop_hm_user_p0[jq]:::item
    out_nixosConfigurations_laptop_hm_user --- out_nixosConfigurations_laptop_hm_user_p0
    out_nixosConfigurations_laptop_hm_user_p1[fd]:::item
    out_nixosConfigurations_laptop_hm_user --- out_nixosConfigurations_laptop_hm_user_p1
    out_nixosConfigurations_laptop_hm_user_p2[git]:::item
    out_nixosConfigurations_laptop_hm_user --- out_nixosConfigurations_laptop_hm_user_p2
    out_nixosConfigurations_laptop_hm_user_more[...+ 20 more]:::item
    out_nixosConfigurations_laptop_hm_user --- out_nixosConfigurations_laptop_hm_user_more
    out_nixosConfigurations_laptop_services[Services]:::detail
    out_nixosConfigurations_laptop --- out_nixosConfigurations_laptop_services
    out_nixosConfigurations_laptop_services_p0[gdm]:::item
    out_nixosConfigurations_laptop_services --- out_nixosConfigurations_laptop_services_p0
    out_nixosConfigurations_laptop_services_p1[iwd]:::item
    out_nixosConfigurations_laptop_services --- out_nixosConfigurations_laptop_services_p1
    out_nixosConfigurations_laptop_services_p2[dbus]:::item
    out_nixosConfigurations_laptop_services --- out_nixosConfigurations_laptop_services_p2
    out_nixosConfigurations_laptop_services_more[...+ 92 more]:::item
    out_nixosConfigurations_laptop_services --- out_nixosConfigurations_laptop_services_more
  end
  Flake --> Outputs
```
<!-- FLAKE_MAP_END -->
