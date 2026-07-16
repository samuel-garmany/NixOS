{
  config.nixos.base = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.git ];
  };

  config.hm.base = { ... }: {
    programs.git = {
      enable = true;
      ignores = [
        ".envrc"
        ".direnv/"
      ];
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
