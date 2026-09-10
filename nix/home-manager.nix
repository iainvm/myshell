{ config, lib, pkgs, ... }:
let
  cfg = config.myshell;
in {
  options.myshell = {
    enable = lib.mkEnableOption "myshell Quickshell desktop shell";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.quickshell;
      description = "The quickshell package to run.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."quickshell/myshell".source = ../qml;

    systemd.user.services.myshell = {
      Unit = {
        Description = "My Quickshell desktop shell";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${lib.getExe cfg.package} -c myshell";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
