{
  config.nixos.base = { pkgs, ... }: {
    # Enable fish system-wide
    # It is recommended to enable fish system-wide, even when using home-manager,
    # to ensure that vendor completions provided by packages in the system profile are available.
    programs.fish.enable = true;
  };

  config.hm.base = { pkgs, ... }: {
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set -g fish_greeting
      '';
      shellAliases = {
        ls = "eza";
        ll = "eza -l";
        la = "eza -la";
        cat = "bat";
      };
    };

    programs.starship = {
      enable = true;
    };

    programs.eza = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.bat = {
      enable = true;
    };

    programs.fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;

    home.packages = with pkgs; [
      fd
      ripgrep
      jq
      tldr
      btop
    ];
  };
}
