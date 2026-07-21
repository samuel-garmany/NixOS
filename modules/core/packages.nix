{
  config.nixos.base = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      arduino-ide
      audacity
      bitwarden-desktop
      cine
      freecad
      freetube
      gimp
      hunspell
      hunspellDicts.en_US
      hyphenDicts.en_US
      inkscape
      jre8
      libreoffice
      ltex-ls
      obs-studio
      orca-slicer
      poppler-utils
      qgis
      slack
      texlive.combined.scheme-full
      unzip
      yubioath-flutter
      zoom-us
    ];
  };

  config.nixos.desktop = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      discord
      faugus-launcher
      prismlauncher
    ];
  };
}
