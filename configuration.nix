{
  lib,
  pkgs,
  config,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/sd-card/sd-image-aarch64.nix") ];
  networking = {
    hostName = "nixpi";
    networkmanager.enable = true;
  };
  users.users = {
    nixpi = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "docker"
      ];
      initialHashedPassword = "";
    };
    root.initialHashedPassword = "";
  };
  services = {
    openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PermitEmptyPasswords = true;
        PermitRootLogin = "yes";
        UseDns = true;
        PasswordAuthentication = false;
      };
    };
    dnsmasq.enable = true;
  };
  console.keyMap = "de_CH-latin1";
  environment = {
    systemPackages = with pkgs; [
      vim
      gitMinimal
      curl
      docker
      docker-compose
    ];
    etc = lib.listToAttrs (
      map
        (
          c:
          let
            f = "/${c}.nix";
          in
          {
            name = "nixos" + f;
            value = {
              inherit (config.users.groups.wheel) gid;
              mode = "0660";
              text = builtins.readFile (./. + f);
            };
          }
        )
        [
          "configuration"
          "flake"
        ]
    );
  };
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };
  nix.settings.extra-experimental-features = [
    "nix-command"
    "flakes"
  ];
  sdImage.compressImage = false;
  system.stateVersion = "25.11";
}
