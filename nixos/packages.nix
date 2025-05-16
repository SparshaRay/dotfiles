{
  pkgs,
  pkgs-unstable,
  pkgs-pinned,
  ...
}: {
  # Packages -------------------------------------------------------------

    # X11 fallback for wayland ------------------
    programs.xwayland.enable = true;

    # For warp ----------------------------------
    systemd.packages = [ pkgs.cloudflare-warp ];
    systemd.targets.multi-user.wants = [ "warp-svc.service" ];

    # Fish shell ---------------------------------
    programs.fish = {
        enable = true;
    #     shellInit = ''
    #       eval "$(micromamba shell hook --shell fish)"
    #       direnv hook fish | source
    #     '';
    #     # interactiveShellInit = ''
    #     #   set fish_greeting # Disable greeting
    #     # '';
    };

    # programs.nh.enable = true;
    programs.java.enable = true;

    # Nix-ld ------------------------------------
    programs.nix-ld.enable = true;

    # Firefox -----------------------------------
    programs.firefox.enable = true;

    # Git ---------------------------------------
    programs.git = {
      enable = true;
      config = {
        init.defaultBranch = "main";
      };
    };

    # All other packages ------------------------
    environment.systemPackages = (with pkgs; [

      # CLI and system utilities -----------
        # Fish Plugins ----------
        # fishPlugins.z
        # fishPlugins.fzf-fish
        # fishPlugins.fifc
        # fishPlugins.sponge
        # fishPlugins.colored-man-pages
        # fishPlugins.tide
        # fishPlugins.plugin-sudope
        # fishPlugins.autopair
        # fishPlugins.fish-bd
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
        httpie
        diffsitter
        micro
        nix-output-monitor
        minicom
        nvd
        comma
        nushell
        shfmt
        # nh # in unstable
        # tldr
        # bat
        # eza
        # ripgrep
        # fd
        # fzf        
        # Network utils ---------
        curl
        avahi
        # System utils ----------
        p7zip
        findutils
        usbutils
        pciutils
        libglibutil
        util-linux
        procps
        exfatprogs
        ntfs3g
        unixtools.quota
        # Wireless utils --------
        iw
        iproute2
        dnsmasq
        hostapd
        iptables
        wirelesstools
        librespeed-cli
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
        preload
        samba

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
        rclone-browser
        rclone
        brave
        linux-wifi-hotspot
        sshuttle
        warp
        syncthing
        syncthingtray
        # protonvpn-gui
        # webtorrent-desktop
        # Support ---------------------
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
          activitywatch
        # Messaging -------------------
          telegram-desktop
          discord
        # Music and video -------------
          pulseeffects-legacy                    # ! [import irs and eqlzr jsons]
          youtube-music
          blanket
          vlc
          audacity
          # davinci-resolve
        # Electronics -----------------
          arduino
          ngspice
          kicad
        # Coding ----------------------
          processing
          # vscode
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
          gnuastro
          geogebra
          sageWithDoc

      # Ricing utils -----------------------
      # rofi
      # eww
      kdePackages.qtstyleplugin-kvantum
      latte-dock                                # Enable when needed

      # Virtualization ---------------------
      wineWowPackages.stableFull
      winetricks
      quickemu
      bottles
      appimage-run                               # ! [inject lib<>.so path via ENV manually]

      # Languages --------------------------
      micromamba
      typst
      # ruby
      # rustc
      # cargo
      # meson
      # uv
      # julia                                    # Install via scientific fhs
      # docker
      # wolfram-engine                           # install wljs notebook in ubuntu
      # wolfram-notebook

      # Bengali keyboard -------------------
      # fcitx5-openbangla-keyboard
      # ibus-engines.openbangla-keyboard

      # # Pending --------------------------
      # !TODO
      # ibus-avro
      # maliit-framework
      # maliit-keyboard
      # onboard
      # fusuma
      # ydotool
      # newm / niri
      # filecxx
      # wvkbd
      # kitty

      # For fun ----------------------------
      oneko
      neofetch

    ]) ++ (with pkgs-unstable; [
      # Unstable packages -------------------
      # uv
      nh
      vscode
    ]) ++ (with pkgs-pinned; [
        ventoy-full
        distrobox
        podman                           # ! [inject insecure null policy json]
        boxbuddy
    ]);

  # SUID wrappers --------------------------------------------------------
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
}
