{
  pkgs,
  ...
}: {
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



  # SUID wrappers --------------------------------------------------------
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
}