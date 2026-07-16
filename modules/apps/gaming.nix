{
  config.nixos.desktop =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
      };

      programs.gamemode.enable = true;

      environment.systemPackages = with pkgs; [
        discord
        lutris
        prismlauncher
      ];
    };
}
