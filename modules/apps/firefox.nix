{
  config.nixos.base =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
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
            #"network.trr.mode" = 3;
            #"network.trr.uri" = "https://dns.quad9.net/dns-query";
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
    };
}
