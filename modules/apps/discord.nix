{
  config.nixos.desktop =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.discord
      ];
    };
}
