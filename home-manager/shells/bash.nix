{pkgs, ...} : {

  programs.bash = {
    enable = true;
    historySize = 1000000;
    enableCompletion = true;
  };

}