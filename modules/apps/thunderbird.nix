{
  config.nixos.base =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
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
    };
}
