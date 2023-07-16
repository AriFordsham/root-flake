{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  };
  outputs = {self, nixpkgs, ...}@attrs: {
    nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        (nixpkgs + /nixos/modules/virtualisation/hyperv-guest.nix)
        /etc/nixos/hardware-configuration.nix
        { boot.loader.grub.device = "nodev";}
        ./netfree.nix
        ./kiosk.nix
      ];
      specialArgs = attrs;
    };

    packages."x86_64-linux".default = self.nixosConfigurations."nixos".config.system.build.toplevel;
  };
} 