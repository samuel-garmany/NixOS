{
  config.nixos.desktop =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.lutris
      ];
    };
}
