{ config, ... }@topArgs:
{
  config.nixos.base =
    { pkgs, lib, ... }@nixosArgs:
    {
      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users."user" = {
        isNormalUser = true;
        description = "Samuel Garmany";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        packages = with pkgs; [
          #  thunderbird
        ];
      };

      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users."user" = topArgs.config.hm.base;
    };

  config.hm.base = { ... }: {
    home.stateVersion = "26.05";
  };
}
