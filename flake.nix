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

    qml-language-server = {
      url = "github:cushycush/qml-language-server";
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

          packages = [
            pkgs.go-task
            pkgs.quickshell
            inputs.qml-language-server.packages.${pkgs.stdenv.hostPlatform.system}.default
          ];
        };
      };
    });
}
