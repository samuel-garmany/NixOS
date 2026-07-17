# NixOS Configuration

Welcome to my NixOS configuration!

## Flake Map

<!-- FLAKE_MAP_START -->
```mermaid
graph TD
    node_0["flake"]
    node_1["devShells"]
    node_2["x86_64-linux"]
    node_3["pyqt
(derivation)"]
    node_4["r
(derivation)"]
    node_5["nixosConfigurations"]
    node_6["desktop
(nixos-configuration)"]
    node_7["laptop
(nixos-configuration)"]
    node_0 --> node_1
    node_1 --> node_2
    node_2 --> node_3
    node_2 --> node_4
    node_0 --> node_5
    node_5 --> node_6
    node_5 --> node_7
```
<!-- FLAKE_MAP_END -->
