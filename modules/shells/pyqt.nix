{
  perSystem =
    { pkgs, ... }:
    let
      pythonEnv = pkgs.python312.withPackages (
        ps: with ps; [
          pip
          pyqt5
          virtualenv
        ]
      );
    in
    {
      devShells.fnt = pkgs.mkShell {
        packages = with pkgs; [
          pythonEnv
          ffmpeg
          git
          qt5.qtwayland
          nodejs_22
          cargo
        ];

        shellHook = ''
          # Enable Wayland support for Qt applications.
          export QT_QPA_PLATFORM="wayland;xcb"

          # Initialize a virtual environment if one does not exist,
          # inheriting system site-packages to expose PyQt5.
          if [ ! -d ".venv" ]; then
            python -m venv .venv --system-site-packages
          fi

          source .venv/bin/activate

          # Expose standard C libraries to pip-installed C-extensions.
          export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH"
        '';
      };
    };
}
