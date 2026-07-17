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

      /*
        =============================================================================
        802.1X Enterprise Wi-Fi Protocol (e.g. Eduroam & CU Secure)
        =============================================================================
        
        By default, NixOS provides a declarative approach to system configuration. 
        However, defining NetworkManager profiles involving private keys or passwords 
        purely declaratively requires storing secrets in the world-readable `/nix/store`. 
        Without a dedicated secrets management tool (e.g., `sops-nix`), this poses a 
        significant security risk. 
        
        Therefore, the recommended standard approach for Enterprise Wi-Fi on NixOS 
        is to utilize NetworkManager's imperative configuration for secrets, while 
        storing the necessary certificates in a mutable system directory.

        To reproduce this setup on a new machine:

        1. Execute the university-provided JoinNow (SecureW2) script. This will 
           imperatively generate the NetworkManager profiles and place certificates 
           into `~/.joinnow`.
        2. The `wpa_supplicant` backend operates under a strict systemd sandbox 
           (`ProtectHome=true`) and cannot read certificates left in `~/.joinnow`. 
           Move ALL certificates (public CA certs and private client certs) to a 
           secure system directory:
             sudo mkdir -p /var/lib/NetworkManager/certs
             sudo cp -r ~/.joinnow/* /var/lib/NetworkManager/certs/
             sudo chown -R root:root /var/lib/NetworkManager/certs
             sudo chmod -R 600 /var/lib/NetworkManager/certs
             sudo chmod 700 /var/lib/NetworkManager/certs
             sudo chmod 700 /var/lib/NetworkManager/certs/tls-client-certs
        3. Update the NetworkManager profiles (`nmcli connection modify`) to point 
           to the correct system paths (`/var/lib/NetworkManager/certs/...`).
        4. Disable MAC address randomization for networks that aggressively filter 
           unknown hardware addresses (e.g., eduroam):
             nmcli connection modify "eduroam [uuid]" 802-11-wireless.mac-address-randomization 1
      */

      # Enable networking
      networking.networkmanager.enable = true;
      # Specify the Wi-Fi backend used for the device.
      # Currently supported are wpa_supplicant or iwd (experimental).
      # networking.networkmanager.wifi.backend = "iwd";



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
