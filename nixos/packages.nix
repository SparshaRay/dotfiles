{
  pkgs,
  # pkgs-unstable,
  pkgs-pinned,
  inputs,
  ...
}: {
  # Packages -------------------------------------------------------------

    # Fingerprint driver ------------------------
    services.fprintd.enable = true;

    # X11 fallback for wayland ------------------
    programs.xwayland.enable = true;

    # Niri --------------------------------------
    imports = [inputs.niri.nixosModules.niri];
    nixpkgs.overlays = [inputs.niri.overlays.niri];
    programs.niri = {
        enable = true;
        package = pkgs.niri-unstable;
    };
    niri-flake.cache.enable = true;

    # KDE connect -------------------------------
    programs.kdeconnect.enable = true;

    # For warp ----------------------------------
    systemd.packages = [ pkgs.cloudflare-warp ];
    systemd.targets.multi-user.wants = [ "warp-svc.service" ];

    # Fish shell ---------------------------------
    programs.fish.enable = true;

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
        yay
        # Shell utils -----------
        htop
        iotop
        smartmontools
        perl
        httpie
        micro
        nix-output-monitor
        minicom
        nvd
        comma
        nix-search-tv
        nushell
        shfmt
        tree
        yazi
        nh
        # Network utils ---------
        curl
        avahi
        ntfy-sh
        # System utils ----------
        p7zip
        zpaq
        findutils
        usbutils
        pciutils
        libglibutil
        util-linux
        procps
        exfatprogs
        ntfs3g
        unixtools.quota
        aha
        # Wireless utils --------
        iw
        nethogs
        iproute2
        dnsmasq
        hostapd
        iptables
        wirelesstools
        librespeed-cli
        # Maintenance utils -----
        nix-index
        pkg-config
        # Android utils ---------
        android-tools
        # Misc utils ------------
        aescrypt
        unrar
        ffmpeg_7-full
        imagemagick
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
        # rclone-ui
        rclone
        brave
        # parabolic
        yt-dlp
        sshuttle
        warp
        syncthing
        syncthingtray
        # protonvpn-gui
        # webtorrent-desktop
        immich-go
        immich-cli
        immich-public-proxy
        miraclecast
        gnome-network-displays
        anydesk
        # Adtnlutils ------------------
        vicinae
        glaxnimate
        copyq
        meld
        webcamoid
        baobab
        stellarium
        # nautilus
        # KDE suit --------------------
        kdePackages.kate
        kdePackages.qrca
        kdePackages.kcalc
        kdePackages.kdeconnect-kde
        kdePackages.partitionmanager
        kdePackages.kmines
        kdePackages.ksystemlog
        kdePackages.ktorrent
        kdePackages.kdenlive
        kdePackages.gwenview
        kdePackages.kde-gtk-config
        kdePackages.plasma-systemmonitor
        kdePackages.korganizer
        kdePackages.qtvirtualkeyboard
        # Keyboard --------------------
        maliit-keyboard
        maliit-framework

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
          # pulseeffects-legacy                    # ! [import irs and eqlzr jsons]
          pear-desktop
          blanket
          # vlc
          haruna
          audacity
          # davinci-resolve
        # Electronics -----------------
          arduino
          ngspice
          # kicad                                  # nah bro, too heavy, enable when necessary
        # Coding ----------------------
          processing
          vscode
          # zed-editor
          github-desktop
        # Image processing ------------
          siril
          rawtherapee
          darktable
          gimp
          inkscape
          krita
          # gyroflow
        # CAD and CFD -----------------
          freecad
          openmvg
          xflr5
          blender
          rerun
        # Scientific ------------------
          octave
          scilab-bin
          gnuastro
          graphviz
          geogebra6
          sage                                   # enable when needed
        # HPC -------------------------
          # htcondor                             # in pinned
        # LLMs/Local GenAI ------------
          # lmstudio
          aichat
          gemini-cli

      # Ricing utils -----------------------     # migrate to niri workflow
      # rofi
      # eww
      kdePackages.qtstyleplugin-kvantum

      # Virtualization ---------------------
      wineWow64Packages.stable
      winetricks
      quickemu
      bottles
      distrobox
      podman                                     # ! [inject insecure null policy json]
      boxbuddy
      # Languages --------------------------
      micromamba
      typst
      julia-bin
      docker
      uv
      # nodejs
      # ruby
      # rustc
      # cargo
      # meson
      # wolfram-engine                           # install wljs notebook in ubuntu
      # wolfram-notebook

      # # Pending --------------------------
      # !TODO
      # filecxx or equivalent

      # For fun ----------------------------
      oneko
      fastfetch
      cpufetch
      pokeget-rs
      uwuify

    # ]) ++ (with pkgs-unstable; [
      # Unstable packages -------------------
      # nh
      # vscode
      # nvidia-modprobe

    ]) ++ (with pkgs-pinned; [

      ventoy-full
      htcondor

      # build fails
      pulseeffects-legacy
      # gyroflow # full broken

    ]);

  # SUID wrappers --------------------------------------------------------
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
}
