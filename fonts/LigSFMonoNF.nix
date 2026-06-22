{ stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation {
    pname = "LigSFMonoNF";
    version = "1.0";

    src = fetchzip {
        url = "https://github.com/SparshaRay/dotfiles/raw/refs/heads/main/fonts/src/LigSFMonoNF.zip";
        sha256 = "zzHnR3i25gAjbZ2BOj+Z3XolyNS3xrEAcBnrsLe1kkc=";
        stripRoot = false;
    };

    installPhase = ''
        runHook preInstall
        mkdir -p $out/share/fonts/opentype
        install -Dm644 ./*.otf -t $out/share/fonts/opentype
        runHook postInstall
    '';
}
