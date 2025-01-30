
{ pkgs, ... }:

let
  nix-alien-pkgs = import (
    builtins.fetchTarball "https://github.com/thiagokokada/nix-alien/tarball/master"
  ) { };
in
{
  environment.systemPackages = with nix-alien-pkgs; [
    nix-alien
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
        stdenv.cc.cc
        openssl
        xorg.libXcomposite
        xorg.libXtst
        xorg.libXrandr
        xorg.libXext
        xorg.libX11
        xorg.libXfixes
        libGL
        libGLU
        libva
        pipewire
        xorg.libxcb
        xorg.libXdamage
        xorg.libxshmfence
        xorg.libXxf86vm
        libelf
        # Essential
        glib
        gtk2
        bzip2
        # To fix silent failures
        xorg.libXinerama
        xorg.libXcursor
        xorg.libXrender
        xorg.libXScrnSaver
        xorg.libXi
        xorg.libSM
        xorg.libICE
        gnome2.GConf
        nspr
        nss
        cups
        libcap
        SDL2
        libusb1
        dbus-glib
        ffmpeg
        # Miscellaneous requirements
        libudev0-shim
        # Games requirements
        xorg.libXt
        xorg.libXmu
        libogg
        libvorbis
        SDL
        SDL2_image
        glew110
        libidn
        tbb
        # Runtime requirements
        flac
        freeglut
        libjpeg
        libpng
        libpng12
        libsamplerate
        libmikmod
        libtheora
        libtiff
        pixman
        speex
        SDL_image
        SDL_ttf
        SDL_mixer
        SDL2_ttf
        SDL2_mixer
        libappindicator-gtk2
        libdbusmenu-gtk2
        libindicator-gtk2
        libcaca
        libcanberra
        libgcrypt
        libvpx
        librsvg
        xorg.libXft
        libvdpau
        gnome2.pango
        cairo
        atk
        gdk-pixbuf
        fontconfig
        freetype
        dbus
        alsaLib
        expat
        # For electron
        libdrm
        mesa
        libxkbcommon
    ];
}
