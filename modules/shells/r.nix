{
  perSystem = { pkgs, ... }: {
    devShells.r = pkgs.mkShell {
      packages = with pkgs; [
        # Core R and Pre-compiled CRAN Packages
        R
        rPackages.languageserver
        rPackages.rmarkdown
        rPackages.knitr
        rPackages.tidyverse
        rPackages.lubridate

        # Document Conversion Engine
        pandoc

        # Build tools
        pkg-config
        cmake
        gnumake
        gcc

        # System libraries for local R packages
        curl
        openssl
        libxml2
        libuv
        fontconfig
        fribidi
        harfbuzz
        libtiff
        libjpeg
        libwebp
      ];

      shellHook = ''
        mkdir -p .Rlibs
        export R_LIBS_USER="$(pwd)/.Rlibs"
      '';
    };
  };
}
