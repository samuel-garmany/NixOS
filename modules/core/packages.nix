{
  config.nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        bitwarden-desktop
        ptyxis
        unzip
        yubioath-flutter
      ];
    };
}
