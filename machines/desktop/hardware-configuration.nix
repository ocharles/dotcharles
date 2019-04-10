# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "usbhid" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/ab9aaeac-5265-4f2d-8316-d348de35f7d1";
      fsType = "ext4";
    };

#  fileSystems."/mnt/router" =
#    { device = "192.168.2.1:/mnt/sda1";
#      fsType = "nfs";
#    };

  swapDevices = [ ];
}