{
  description = "My Shell";

  # Dependencies
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs: let
    pkgs = import nixpkgs {system = "x86_64-linux";};
  in
    {
      homeManagerModules.default = import ./nix/home-manager.nix;
    }
    // flake-utils.lib.eachDefaultSystem (system: {
      devShells = {
        default = pkgs.mkShell {
          shellHook = ''
          '';

          packages = with pkgs; [
            quickshell
          ];
        };
      };
    });
}
