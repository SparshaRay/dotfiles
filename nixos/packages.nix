{
  pkgs,
  pkgs-unstable,
  pkgs-pinned,
  ...
}: {
  # Packages -------------------------------------------------------------

    # Fingerprint driver ------------------------
    services.fprintd.enable = true;

    # X11 fallback for wayland ------------------
    programs.xwayland.enable = true;

    # Niri --------------------------------------
    programs.niri.enable = true;

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

    # AppImage ----------------------------------
    programs.appimage = {                        # ! [inject lib<>.so path via ENV manually if needed]
      enable = true;
      binfmt = true;
    };

    # Stirling pdf ------------------------------
    services.stirling-pdf.enable = true;

    # All other packages ------------------------
    environment.systemPackages = (with pkgs; [

      # CLI and system utilities -----------
        # Make & build utils ----
        cmake
        gnumake
        automake
        autoconf
        # ninja
        # bazelisk
        # Compilers -------------
        gcc
        gfortran
        # ghc
        # Git utils -------------
        gh
        git
        # Libraries -------------
        gsl
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
        nix-search-tv
        nushell
        shfmt
        # nh # in unstable
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
        # backintime
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
        peakperf
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
        kdePackages.filelight
        kdePackages.gwenview
        kdePackages.kde-gtk-config
        kdePackages.plasma-systemmonitor
        # kdePackages.qtvirtualkeyboard
        # kdePackages.skanlite

      # Software suit ----------------------
        # Office and notes ------------
          libreoffice
          texliveBasic
          # sioyek
          pdfarranger
          ocrmypdf
          obsidian
          xournalpp
          activitywatch
        # Messaging -------------------
          telegram-desktop
          discord
          slack
        # Music and video -------------
          pulseeffects-legacy                    # ! [import irs and eqlzr jsons]
          youtube-music
          blanket
          # vlc
          haruna
          audacity
          # davinci-resolve
        # Electronics -----------------
          arduino
          ngspice
          # kicad                                # nah bro, too heavy, enable when necessary
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
          gyroflow
        # CAD and CFD -----------------
          freecad
          xflr5
          blender
        # Scientific ------------------
          octave
          scilab-bin
          gnuastro
          geogebra
          sage

      # Ricing utils -----------------------
      # rofi
      # eww
      kdePackages.qtstyleplugin-kvantum
      # latte-dock                               # Broke aaaaaaaaaaaa, Enable when needed

      # Virtualization ---------------------
      wineWowPackages.stable
      winetricks
      quickemu
      bottles
      distrobox
      podman                                     # ! [inject insecure null policy json]
      boxbuddy
      # Languages --------------------------
      micromamba
      typst
      # nodejs
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
      fusuma
      ydotool
      # libinput-gestures
      # wmctrl
      # filecxx
      # wvkbd
      # squeekboard
      # kitty

      # For fun ----------------------------
      oneko
      neofetch

    ]) ++ (with pkgs-unstable; [
      # Unstable packages -------------------
      nh
      vscode
      # nvidia-modprobe
    ]) ++ (with pkgs-pinned; [
      ventoy-full
    ]);

  # SUID wrappers --------------------------------------------------------
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
}
