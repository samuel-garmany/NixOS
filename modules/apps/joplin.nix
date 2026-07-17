{
  config.nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        joplin-desktop
      ];

      programs.firefox.policies.ExtensionSettings = {
        "{8419486a-54e9-11e8-9401-ac9e17909436}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4094039/joplin_web_clipper-2.11.2.xpi";
          installation_mode = "force_installed";
          updates_disabled = true;
        };
      };
    };
}
