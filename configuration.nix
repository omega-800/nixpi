{
  pkgs,
  config,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/sd-card/sd-image-aarch64.nix") ];
  networking.hostName = "nixpi";
  users.users."nixpi" = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "changeme";
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
  environment = {
    systemPackages = with pkgs; [
      vim
      gitMinimal
      curl
    ];
    etc."nixos/configuration.nix" = {
      inherit (config.users.groups.wheel) gid;
      mode = "0660";
      text = builtins.readFile (./. + "/configuration.nix");
    };
  };
  nix.settings.extra-experimental-features = [
    "nix-command"
    "flakes"
  ];
  sdImage.compressImage = false;
  image.fileName = "nixpi.img";
  system.stateVersion = "25.11";
}
