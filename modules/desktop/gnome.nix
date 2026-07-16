{
  config.nixos.base = { config, pkgs, lib, ... }: {
    # Enable the X11 windowing system.
    services.xserver.enable = true;
  
    # Enable the GNOME Desktop Environment.
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;
    services.displayManager.autoLogin.enable = true;
    services.displayManager.autoLogin.user = "user";
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
    environment.extraSetup = ''
      rm -f $out/share/applications/cups.desktop
      rm -f $out/share/applications/nvim.desktop
    '';
    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };
    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;
  };
}
