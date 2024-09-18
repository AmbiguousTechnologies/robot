{
  boot.loader.systemd-boot.enable = true;
  fileSystems."/" = {
    device = "/dev/vda1";
    fsType = "ext4";
  };
  nixpkgs.hostPlatform = "x86_64-linux";
}
