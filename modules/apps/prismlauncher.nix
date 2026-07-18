{
  config.nixos.desktop =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.prismlauncher
      ];
    };
}
