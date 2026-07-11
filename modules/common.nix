# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Bootloader.
  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    loader.efi.canTouchEfiVariables = true;

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

    plymouth = {
      enable = true;
    };

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=auto"
    ];

    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 0;
  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable flakes and the nix command
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Weekly garbage collect
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  zramSwap.enable = true;
  systemd.oomd.enable = true;
  services.fwupd.enable = true;
  services.fprintd.enable = true;

  # Allow insecure electron to use obsidian
  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
  ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  services.tailscale.enable = true;
  security.apparmor.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "user";

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  services.xserver.excludePackages = [ pkgs.xterm ];
  environment.gnome.excludePackages = with pkgs; [
    epiphany
    simple-scan
    seahorse
    gnome-music
    gnome-calendar
    gnome-contacts
    showtime
    system-config-printer
    gnome-console
    gnome-tour
    yelp
    decibels
  ];

  # Disable the NixOS manual
  documentation.nixos.enable = false;

  environment.extraSetup = ''
    rm -f $out/share/applications/cups.desktop
    rm -f $out/share/applications/nvim.desktop
  '';

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

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

  # Install firefox.
  # Settings are pulled from privacyguides
  programs.firefox = {
    enable = true;
    policies = {
      # Telemetry & Studies
      DisableTelemetry = true;
      DisableFirefoxStudies = true;

      PasswordManagerEnabled = false;

      SearchEngines = {
        Default = "Brave";
        Add = [
          {
            Name = "Brave";
            URLTemplate = "https://search.brave.com/search?q={searchTerms}";
            Method = "GET";
          }
        ];
      };

      #SanitizeOnShutdown = {
      #  Cache = true;
      #  Cookies = true;
      #  Downloads = true;
      #  FormData = true;
      #  History = false; # Example: Keep history, clear everything else
      #  Sessions = true;
      #  SiteSettings = false;
      #  OfflineApps = true;
      #  Locked = true; # Prevents changing this setting in the Firefox UI
      #};

      Preferences = {
        # Vertical Tabs
        "sidebar.verticalTabs" = true;

        # Restore session
        "browser.startup.page" = 3;

        # Search Suggestions
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.suggest.quicksuggest.nonlinear" = false;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;

        # Sponsored Content
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

        # Enhanced Tracking Protection
        "browser.contentblocking.category" = "strict";

        # Cookies & Sessions
        "network.cookie.lifetimePolicy" = 0;

        # Telemetry
        "datareporting.policy.dataSubmissionEnabled" = false;
        "browser.discovery.enabled" = false;
        "browser.ping-centre.telemetry" = false;

        # Website Advertising Preferences
        "dom.private-attribution.submission.enabled" = false;

        # HTTPS-Only Mode
        "dom.security.https_only_mode" = true;

        # DNS over HTTPS
        "network.trr.mode" = 3;
        "network.trr.uri" = "https://dns.quad9.net/dns-query";
      };

      ExtensionSettings =
        let
          moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
        in
        {
          "*".installation_mode = "blocked";

          "uBlock0@raymondhill.net" = {
            install_url = moz "ublock-origin";
            installation_mode = "force_installed";
            updates_disabled = true;
          };

          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            install_url = moz "bitwarden-password-manager";
            installation_mode = "force_installed";
            updates_disabled = true;
          };

          "@testpilot-containers" = {
            install_url = moz "multi-account-containers";
            installation_mode = "force_installed";
            updates_disabled = true;
          };

          "zotero@chnm.gmu.edu" = {
            install_url = "https://www.zotero.org/download/connector/dl?browser=firefox";
            installation_mode = "force_installed";
            updates_disabled = true;
          };
        };
    };
  };

  # Config also taken from privacy guides
  programs.thunderbird = {
    enable = true;
    policies = {
      DisableTelemetry = true;

      Preferences = {
        # Allow Thunderbird to send technical/interaction data (Telemetry)
        "datareporting.healthreport.uploadEnabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "browser.ping-centre.telemetry" = false;

        # Remember websites and links I've visited
        # Setting this to false disables history tracking
        "places.history.enabled" = false;

        # Accept cookies from sites
        # 0 = Accept All Cookies
        # 2 = Reject all cookies (Privacy guides recommended)
        # 4 = Reject Cross-Site Tracking Cookies
        "network.cookie.cookieBehavior" = 4;
      };
    };
  };
  programs.zoxide.enable = true;

  # For Yubikey
  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.pcscd.enable = true;

  fonts.packages = with pkgs; [
    maple-mono.NF
  ];

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
    nextcloud-client
    obsidian
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

}
