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
  } @ inputs:
    {
      homeManagerModules.default = import ./nix/home-manager.nix;
    }
    // flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells = {
        default = pkgs.mkShell {
          shellHook = ''
          '';

          QML_IMPORT_PATH = pkgs.lib.makeSearchPath "lib/qt-6/qml" [
            pkgs.quickshell
            pkgs.qt6.qtdeclarative
          ];

          TZDIR = "${pkgs.tzdata}/share/zoneinfo";

          packages = [
            pkgs.go-task
            pkgs.quickshell
            pkgs.upower
            inputs.qml-language-server.packages.${system}.default
          ];
        };
      };
    });
}
