{
  config.nixos.laptop =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      imports = [
        ./hardware-configuration.nix
      ];

      networking.hostName = "laptop"; # Define your hostname.

      system.stateVersion = "26.05"; # Did you read the comment?
    };
}
