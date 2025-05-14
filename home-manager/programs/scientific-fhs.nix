{
  programs.scientific-fhs = {
    enable = true;
    juliaVersions = [
      {
        version = "1.11.4";
        default = true;
      }
    ];
    enableNVIDIA = false;
  };
}