{
  config.nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        zotero
      ];

      programs.firefox.policies.ExtensionSettings = {
        "zotero@chnm.gmu.edu" = {
          install_url = "https://www.zotero.org/download/connector/dl?browser=firefox";
          installation_mode = "force_installed";
          updates_disabled = true;
        };
      };
    };
}
