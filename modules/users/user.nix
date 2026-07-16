{
  config.nixos.base = { config, pkgs, lib, ... }: {
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
  };
}
