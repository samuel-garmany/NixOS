{
  config.nixos.desktop =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      # Configure nix-flatpak
      services.flatpak = {
        enable = true;
        packages = [
          "org.vinegarhq.Sober"
        ];
      };
    };
}
