{
  config.nixos.base =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      fonts.packages = with pkgs; [
        maple-mono.NF
      ];
    };
}
