{
  pkgs,
  ...
}: {
  # For multithreading ------------------------
  environment.variables = {
    NIX_BUILD_CORES = 16;
    NH_FLAKE = "/run/media/sparsharay/groot/Softwares/LI2i1-14AHP9_spconfig/Nix/";
  };

  # Fish --------------------------------------
  users.defaultUserShell = pkgs.fish;

  # virt-manager ------------------------------
  # programs.virt-manager.enable = true;
  # users.groups.libvirtd.members = ["sparsharay"];
  # virtualisation.libvirtd.enable = true;
  # virtualisation.spiceUSBRedirection.enable = true;

  # Fonts ----------------------------------------------------------------
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      open-fonts
      helvetica-neue-lt-std
      lohit-fonts.bengali
      lohit-fonts.devanagari
      newcomputermodern
      libertine
      nerd-fonts.iosevka
      iosevka
      iosevka-comfy.comfy-wide
      nerd-fonts.noto
      nerd-fonts.fira-mono
      maple-mono.NF
      (callPackage ../fonts/HelveticaNeueCyr.nix { })
      (callPackage ../fonts/SFMono.nix { })
    ];
    fontconfig = {
      defaultFonts = {                             # Order decides fallback
        serif     = [ "Noto Sans, Noto Sans Bengali, Noto Sans Devanagari"];
        sansSerif = [ "Noto Sans, Noto Sans Bengali, Noto Sans Devanagari"];
        monospace = [ "Iosevka Md Ex Obl" ];
      };
    };
  };

  # Services and setups --------------------------------------------------

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

    services.pulseaudio = {
      enable = false;                            # ! [see bluetooth manual, set to true, debug]
      # package = pkgs.pulseaudioFull;
    };

    hardware.enableRedistributableFirmware = true;

    # For samba ---------------------------------
    # services.samba.enable = true;

    # For immich --------------------------------
    services.immich = {
      enable = true;
      host = "127.0.0.1";
      port = 2200;
    };

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

    # For disabling man pages -------------------
    documentation.man.enable = false;
    documentation.info.enable = false;

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
    systemd.services.NetworkManager-wait-online.enable = false;
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
    #   # settings = {
    #   #   X11Forwarding = true;
    #   #   PermitRootLogin = "no";
    #   #   PasswordAuthentication = false;
    #   # };
    #   # openFirewall = true;
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
    services.desktopManager.plasma6.enable = true;

    # Enable ly ---------------------------------
    services.displayManager.ly.enable = true;
    services.displayManager.ly.settings = {
      asterisk = ".";
      clock = "%c";
    };

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
}