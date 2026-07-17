{
  config.nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        poppler-utils
        texlive.combined.scheme-full
      ];
    };
}
