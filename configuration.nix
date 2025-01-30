
{ config, pkgs, ... }:

let unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {

  # Services and setups --------------------------------------------------

    # Enable experimental features  -------------
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # For multithreading ------------------------
    environment.variables = {
      NIX_BUILD_CORES = 16;
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

    # For unfree softwares ----------------------
    nixpkgs.config.allowUnfree = true;

    # For automount -----------------------------
    services.udisks2.enable = true;
    security.polkit.extraConfig = ''
    // Allow udisks2 to mount devices without authentication for users in the "wheel" group
    polkit.addRule(function(action, subject) {
        if ((action.id == "org.freedesktop.udisks2.filesystem-mount-system" ||
            action.id == "org.freedesktop.udisks2.filesystem-mount") &&
            subject.isInGroup("wheel")) {
            return polkit.Result.YES;
        }
    });
    '';



  # Device settings ------------------------------------------------------

    # Imports -----------------------------------
    imports =
      [
        ./hardware-configuration.nix
#         ./nix-alien.nix
      ];

    # Bootloader --------------------------------
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.timeout = 0;                     # Do not show grub (press and hold down escape key to show)

    # Device name -------------------------------
    networking.hostName = "SparshaRay";

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



  # User account settings ------------------------------------------------
  users.users.sparsharay = {
    isNormalUser = true;
    description = "Sparsha Ray";
    extraGroups = [ "networkmanager" "wheel"];
    # openssh.authorizedKeys.keys = [
    #   "ssh-ed25519 <public-key> sparsharay@SparshaRay"
    # ];
  };



  # Packages -------------------------------------------------------------

    # Firefox -----------------------------------
    programs.firefox.enable = true;
    programs.git = {
      enable = true;
      config = {
        init.defaultBranch = "main";
      };
    };

    # ZSH ---------------------------------------
    users.defaultUserShell = pkgs.zsh;
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      shellAliases = {
        ez = "eza -la --long --tree --icons --git";
        zd = "zoxide";
        nt = "echo \"pw? : \" && sudo nixos-rebuild test --log-format internal-json -v |& nom --json";
        ns = "echo \"pw? : \" && sudo nixos-rebuild switch --log-format internal-json -v |& nom --json";
        update = "echo \"pw? : \" && sudo nixos-rebuild switch --upgrade-all --log-format internal-json -v |& nom --json";
        fuck = "thefuck";
      };
      ohMyZsh = {
        enable = true;
        plugins = [ "git" "thefuck"];
      };
    };

    # All other packages ------------------------
    environment.systemPackages = with pkgs; [

      # CLI and system utilities -----------
        # Make & build utils ----
        cmake
        gnumake
        automake
        autoconf
        ninja
        # Compilers -------------
        gcc
        gfortran
        ghc
        # Git utils -------------
        gh
        git
        # Libraries -------------
        glib
        haveged
        # Package utils ---------
        pacman
        # Shell utils -----------
        perl
        zoxide
        tldr
        bat
        eza
        ripgrep
        fd
        httpie
        diffsitter
        micro
        nix-output-monitor
        nh
        nvd
        comma
        thefuck
        nushell
        # Network utils ---------
        curl
        avahi
        # System utils ----------
        p7zip
        fzf
        findutils
        usbutils
        pciutils
        libglibutil
        util-linux
        procps
        exfatprogs
        # Wireless utils --------
        iw
        iproute2
        dnsmasq
        hostapd
        iptables
        wirelesstools
        # Input utils -----------
        ibus
        # Maintenance utils -----
        backintime
        nix-index
        pkg-config
        # Android utils ---------
        android-tools
        # Misc utils ------------
        aescrypt
        unrar
        ffmpeg_7-full

      # Hardware utilities -----------------
        # Processor utils --------
        linuxKernel.packages.linux_zen.ryzen-smu
        linuxKernel.packages.linux_zen.cpupower
        cpupower-gui
        ryzenadj
        # System management ------
        tlp
        iio-sensor-proxy
        # Hardware check utils ---
        hwinfo
        hw-probe
        hwloc
        dmidecode
        lm_sensors
        # Benchmark & stress -----
        geekbench
        stress-ng

      # Miscellaneous utilities ------------
        # Networking and internet -----
        cloudflare-warp
        protonvpn-gui
        rclone-browser
        rclone
        brave
        # webtorrent-desktop
        linux-wifi-hotspot
        sshuttle
        warp
        # Support ---------------------
        ventoy
        anydesk
        # Adtnlutils ------------------
        glaxnimate
        copyq
        meld
        filelight
        skanlite
        webcamoid
        stellarium
        # KDE suit --------------------
        kdePackages.kate
        kdePackages.kcalc
        kdePackages.kdeconnect-kde
        kdePackages.partitionmanager
        kdePackages.kmines
        kdePackages.ksystemlog
        kdePackages.ktorrent
        kdePackages.kdenlive

      # Software suit ----------------------
        # Office and notes ------------
          libreoffice
          texliveFull
          sioyek
          pdfarranger
          ocrmypdf
          obsidian
          xournalpp
        # Messaging -------------------
          telegram-desktop
          discord
        # Music and video -------------
          pulseeffects-legacy                    # ! [import irs and eqlzr jsons]
          youtube-music
          blanket
          vlc
          audacity
        # Electronics -----------------
          arduino
          ngspice
          kicad
        # Coding ----------------------
          processing
          vscode
          github-desktop
        # Image processing ------------
          siril
          rawtherapee
          darktable
          gimp
          inkscape
          krita
        # CAD and CFD -----------------
          freecad
          xflr5
          blender
        # Scientific ------------------
          octaveFull
          scilab-bin
          # geogebra6
          geogebra
          sageWithDoc

      # Ricing utils -----------------------
      rofi
      eww
      kdePackages.qtstyleplugin-kvantum
      # latte-dock                               # Enable when needed

      # Virtualization ---------------------
      wineWowPackages.stableFull
      bottles
      boxbuddy
      distrobox
      podman                                     # ! [inject insecure null policy json]
      appimage-run                               # ! [inject lib<>.so path via ENV manually]

      # Languages --------------------------
      micromamba
      julia                                      # Install the same version with Juliaup and install packages via distrobox
      typst
      # wolfram-engine
      # wolfram-notebook

      # Bengali keyboard -------------------
      fcitx5-openbangla-keyboard
      # ibus-engines.openbangla-keyboard

      # # Pending --------------------------
      # !TODO
      # ibus-avro
      # maliit-framework
      # maliit-keyboard
      # fusuma
      # ydotool
      # newm / niri
      # filecxx
      # mathematica wljs notebook
      # wvkbd
      # kitty

      # For fun ----------------------------
      oneko
      neofetch

    ];



  # Fonts ----------------------------------------------------------------
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      open-fonts
      helvetica-neue-lt-std
      lohit-fonts.bengali
      lohit-fonts.devanagari
      newcomputermodern
      (nerdfonts.override { fonts = ["Iosevka"]; })
      (callPackage ./fonts/HelveticaNeueCyr.nix { })
      (callPackage ./fonts/SFMono.nix { })
    ];
    fontconfig = {
      defaultFonts = {                             # Order decides fallback
        serif     = [ "Noto Sans, Noto Sans Bengali, Noto Sans Devanagari"];
        sansSerif = [ "Noto Sans, Noto Sans Bengali, Noto Sans Devanagari"];
        monospace = [ "Iosevka Md Ex Obl" ];
      };
    };
  };



  # SUID wrappers --------------------------------------------------------
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };



  # Select release, switch to LTS kernel, and make swap ------------------
  system.stateVersion = "24.05";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  swapDevices = [{
    device = "/swapfile";
    size = 16384;
  }];



  # Storage optimization, auto garbage collect and swap ------------------
  boot.loader.systemd-boot.configurationLimit = 5;
  nix = {
    gc.automatic = true;
    optimise.automatic = true;
  };



}
