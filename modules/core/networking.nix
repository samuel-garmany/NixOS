{
  config.nixos.base =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      # Configure network proxy if necessary
      # networking.proxy.default = "http://user:password@proxy:port/";
      # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

      # Enable networking
      networking.networkmanager.enable = true;
      # Specify the Wi-Fi backend used for the device.
      # Currently supported are wpa_supplicant or iwd (experimental).
      networking.networkmanager.wifi.backend = "iwd";

      # Allow iwd to read user-specific configuration/certificate files (e.g. in ~/.joinnow)
      # while protecting user data from modification by the service.
      # From systemd.exec(5): "Setting this to 'read-only' is useful to protect user data
      # from modification by the service, while still allowing the service to read user-specific
      # configuration files."
      systemd.services.iwd.serviceConfig.ProtectHome = "read-only";

      services.tailscale.enable = true;
      security.apparmor.enable = true;
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

    };
}
