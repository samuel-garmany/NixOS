{ lib, config, ... }: {
  options.nixos = {
    base = lib.mkOption {
      type = lib.types.deferredModule;
    };
    desktop = lib.mkOption {
      type = lib.types.deferredModule;
    };
    laptop = lib.mkOption {
      type = lib.types.deferredModule;
    };
  };

  # Merge base into both desktop and laptop
  config.nixos.desktop = config.nixos.base;
  config.nixos.laptop = config.nixos.base;
}
