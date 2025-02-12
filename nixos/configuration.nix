# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # Home manager as a module
    ./hm-module.nix

    # Import packages
    ./packages.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;

  # Storage optimization and auto garbage collect ------------------
    gc.automatic = true;
    optimise.automatic = true;
  };

  # FIXME: Add the rest of your current configuration

  # Services and setups --------------------------------------------------

    # For multithreading ------------------------
    environment.variables = {
      NIX_BUILD_CORES = 16;
      FLAKE = "/run/media/sparsharay/groot/Softwares/LI2i1-14AHP9_spconfig/Nix/";
    };

    # X11 fallback for wayland ------------------
    programs.xwayland.enable = true;

    # For warp ----------------------------------
    systemd.packages = [ pkgs.cloudflare-warp ];
    systemd.targets.multi-user.wants = [ "warp-svc.service" ];

    # For networking-----------------------------
    services.avahi.enable = true;

    # For bluetooth -----------------------------
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    hardware.bluetooth.settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };

    hardware.pulseaudio = {
      enable = false;                            # ! [see bluetooth manual, set to true, debug]
      package = pkgs.pulseaudioFull;
    };

    hardware.enableRedistributableFirmware = true;

    # For samba ---------------------------------
    services.samba.enable = true;

    # For preload -------------------------------
    services.preload.enable = true;

    # For wine ----------------------------------
    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;

    # For cpupower ------------------------------
    services.cpupower-gui.enable = true;

    # For ADB -----------------------------------
    programs.adb.enable = true;

    # For hotspot -------------------------------
    # services.hostapd.enable = true;
    # services.dnsmasq.enable = true;

    # For tlp -----------------------------------
    services.power-profiles-daemon.enable = false;
    # boot.kernelParams = ["amd_pstate=\"active\""];         # Enable amd_pstate_epp driver
    services.tlp = {
      enable = true;
      settings = {
        # For battery ----------------------
        STOP_CHARGE_THRESH_BAT0 = 1;
        RESTORE_THRESHOLDS_ON_BAT = 1;
        # For CPU --------------------------
          # AC power ------------------
          CPU_BOOST_ON_AC = 1;
          CPU_DRIVER_OPMODE_ON_AC = "active";
          PLATFORM_PROFILE_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
          # BAT power -----------------
          CPU_BOOST_ON_BAT = 0;
          CPU_DRIVER_OPMODE_ON_BAT = "active";
          PLATFORM_PROFILE_ON_BAT = "low-power";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      };
    };

    # For raising power limits ------------------
    hardware.cpu.amd.ryzen-smu.enable = true;

    # For screen autorotation -------------------
    hardware.sensor.iio.enable = true;

    # For printer -------------------------------
    services.printing.enable = true;

    # For touchpad ------------------------------
    services.libinput.enable = true;

  # Device settings ------------------------------------------------------

    # Bootloader --------------------------------
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.timeout = 0;                     # Do not show grub (press and hold down escape key to show)

    # Time zone and internationalisation --------
    time.timeZone = "Asia/Kolkata";
    time.hardwareClockInLocalTime = true;
    i18n.defaultLocale = "en_IN";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_IN";
      LC_IDENTIFICATION = "en_IN";
      LC_MEASUREMENT = "en_IN";
      LC_MONETARY = "en_IN";
      LC_NAME = "en_IN";
      LC_NUMERIC = "en_IN";
      LC_PAPER = "en_IN";
      LC_TELEPHONE = "en_IN";
      LC_TIME = "en_IN";
    };

    # Device name -------------------------------
    networking.hostName = "SparshaRay";

  # Network settings -----------------------------------------------------

    # Enable networking -------------------------
    networking.networkmanager.enable = true;
    # networking.wireless.enable = true;         # Enables wireless support via wpa_supplicant

    # Proxy settings ----------------------------
    # networking.proxy.default = "http://172.16.2.250:3128";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Firewall settings -------------------------
    networking.firewall.enable = true;
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];

    # OpenSSH daemon settings -------------------
    # services.openssh = {
    #   enable = true;
    #   settings = {
    #     X11Forwarding = true;
    #     PermitRootLogin = "no";
    #     PasswordAuthentication = false;
    #   };
    #   openFirewall = true;
    # };

  # Desktop environment settings -----------------------------------------

    # Enable X11---------------------------------
    services.xserver.enable = true;
    services.xserver = {
        xkb.layout = "us";
        xkb.variant = "";
      };

    # Copilot key mapping _______________________
    # services.xserver.xkbOptions = "leftshift+leftmeta:control";
    # services.xserver.displayManager.gdm.enable = true;
    # services.xserver.displayManager.gdm.wayland = true;

    # Enable Plasma DE --------------------------
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.theme = "breeze";
    environment.systemPackages = [
      (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
        [General]
        background=/run/media/sparsharay/groot/Media/Desktop_wallpapers/16.png
      '')
    ];
    services.desktopManager.plasma6.enable = true;

    # Enable Hyprland ---------------------------
    # programs.hyprland.enable = true;
    # programs.hyprland.xwayland.enable = true;

    # ! Import ICM file separately --------------
    # [sRGB Color Space Profile.icm]



  # Sound settings -------------------------------------------------------

    # Enable sound with pipewire ----------------
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # jack.enable = true;                      # For JACK applications
      # media-session.enable = true;
    };

  # Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    # Replace with your username
    sparsharay = {
      # You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      # initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      description = "Sparsha Ray";
      # openssh.authorizedKeys.keys = [
      #   # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      # ];
      # Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = ["networkmanager" "wheel"];
    };
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  # services.openssh = {
  #   enable = true;
  #   settings = {
  #     # Opinionated: forbid root login through SSH.
  #     PermitRootLogin = "no";
  #     # Opinionated: use keys only.
  #     # Remove if you want to SSH using passwords
  #     PasswordAuthentication = false;
  #   };
  # };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  # Select release, limit configs, switch to LTS kernel, and make swap ------------------
  system.stateVersion = "24.05";
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  swapDevices = [{
    device = "/swapfile";
    size = 16384;
  }];
}
