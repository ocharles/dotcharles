{ lib, modulesPath, pkgs, ...}:
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  environment.systemPackages = [ pkgs.rclone ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/1d7aa6d7-c57e-4a6f-9c65-9cc8b2f1e9c6";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/01E4-83CD";
      fsType = "vfat";
    };

  fileSystems."/mnt/media" = {
    device = "/dev/disk/by-uuid/c10f8ccd-9eda-4016-8a93-c05974c70c07";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  fileSystems."/mnt/seedhost" = {
    device = "ultra:";
    fsType = "rclone";
    options = [
      "config=/etc/rclone.conf"
      "nodev"
      "nofail"
      "allow_other"
      "uid=1000"
      "dir_cache_time=0"
      "_netdev"
    ];
  };

  fileSystems."/mnt/media/Media/Seedhost-2" = {
    device = "Backblaze:ocharles-media";
    fsType = "rclone";
    depends = [ "/mnt/media" ];
    options = [
      "config=/etc/rclone.conf"
      "vfs_cache_mode=full" 
      "vfs_cache_max_size=10G"
      "allow_other"
      "umask=002"
      "uid=1000"
      "gid=100"
      "buffer_size=256M"
      "_netdev"
    ];
  };

  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 8;
}
