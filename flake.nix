{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    
    # Lanzaboote handles Secure Boot for NixOS
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, lanzaboote, ... }: {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
	modules = [
	  lanzaboote.nixosModules.lanzaboote
	  ./desktop/configuration.nix
	  ./desktop/hardware-configuration.nix
        ];
      };
 
      #laptop = nixpkgs.lib.nixosSystem {
        #system = "x86_64-linux";
	#modules = [
	  # lanzaboote.nixosModules.lanzaboote
	  #./laptop/configuration.nix
	  #./laptop/hardware-configuration.nix
        #];
      #};
    };
  };
}
