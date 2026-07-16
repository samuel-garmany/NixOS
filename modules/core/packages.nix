{
  config.nixos.base =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      # List packages installed in system profile. To search, run:
      # $ nix search wget
      environment.systemPackages = with pkgs; [
        # Core
        ptyxis
        unzip
        sbctl

        # Productivity
        jre8
        libreoffice
        hunspell
        hunspellDicts.en_US
        hyphenDicts.en_US
        #obsidian
        joplin-desktop
        poppler-utils
        texlive.combined.scheme-full
        zotero

        # Media & Modeling
        audacity
        cine
        freecad
        freetube
        gimp
        obs-studio
        orca-slicer
        qgis
        slack

        # GNOME
        baobab
        bitwarden-desktop
        blanket
        foliate
        gnome-calculator
        gnome-characters
        gnome-clocks
        gnome-connections
        gnome-firmware
        gnome-font-viewer
        gnome-maps
        gnome-network-displays
        gnome-text-editor
        gnome-weather
        inkscape
        loupe
        papers
        pika-backup
        snapshot
        vaults
        yubioath-flutter
        zoom-us
      ];
    };
}
