{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    kiosk.url = "github:AriFordsham/kiosk-flake";
  };
  outputs = {self, nixpkgs, kiosk, ...}@attrs: {
    nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        (nixpkgs + /nixos/modules/virtualisation/hyperv-guest.nix)
        ./hardware-configuration.nix
        { boot.loader.grub.device = "nodev";}
        (kiosk + /netfree.nix)
        (kiosk + /kiosk.nix)
      ];
      specialArgs = attrs;
    };

    packages."x86_64-linux".default = self.nixosConfigurations."nixos".config.system.build.toplevel;
  };
} 