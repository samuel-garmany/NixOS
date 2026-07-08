{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixossystem {
        system = "x86_64-linux";
	modules = [
	  ./desktop/configuration.nix
	  ./desktop/hardware-configuration.nix
        ];
      };
 
      #laptop = nixpkgs.lib.nixossystem {
        #system = "x86_64-linux";
	#modules = [
	  #./laptop/configuration.nix
	  #./laptop/hardware-configuration.nix
        #];
      #};
    };
  };
}
