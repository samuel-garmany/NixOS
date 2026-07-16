{
  config.nixos.base = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.git ];
  };

  config.hm.base = { ... }: {
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "Samuel Garmany";
          email = "samuel@example.com";
        };
        init.defaultBranch = "main";
      };
    };
  };
}
