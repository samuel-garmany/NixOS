{
  config.hm.base = { ... }: {
    programs.bash.enable = true;
    programs.zoxide.enable = true;
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
  };
}
