{ config, lib, pkgs, ... }:
{
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

 #Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["amdgpu" "nvidia"];
  boot.kernelModules = [ "amdgpu" ];
  
  # environment.variables = {
  #   GBM_BACKEND = "nvidia-drm";
  #   LIBVA_DRIVER_NAME = "nvidia";
  #   __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  # };

  hardware.graphics.extraPackages = with pkgs; [
    amdvlk
    vulkan-loader
    vulkan-validation-layers
    vulkan-tools
  ];
  hardware.graphics.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];

  # environment.systemPackages = with pkgs; [
  #   vulkan-loader
  #   vulkan-validation-layers
  #   vulkan-tools
  #   mesa
  # ];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = lib.mkDefault true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = lib.mkDefault true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = lib.mkDefault false;

    prime = {
        amdgpuBusId = "PCI:6:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };

    #prime.offload.enable = true;
    #prime.offload.enableOffloadCmd = true;
     prime.reverseSync.enable = true;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  hardware.amdgpu.opencl.enable = lib.mkDefault false;
}  
