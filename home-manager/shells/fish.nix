{pkgs, ...} : {

  programs.fish = {
    enable = true;
    functions = {
      fish_greeting = "eval \"$(micromamba shell hook --shell fish)\" & direnv hook fish | source & echo $hostname && date +%s | md5sum";
    };
    shellAliases = {
            ls = "eza";
            # cd = "z"; # doesnt work for some reason
    };
  };

  programs.eza      = {enable = true; icons = "auto"; extraOptions = ["--group-directories-first" "--header"];};
  programs.bat      = {enable = true; };
  programs.fd       = {enable = true; hidden = true; };
  programs.ripgrep  = {enable = true; };
  programs.tealdeer = {enable = true; };
  programs.fzf.enableFishIntegration = true;
  # programs.zoxide.enableFishIntegration = true;

  home.packages = with pkgs.fishPlugins; [
    z
    # done
    forgit
    fzf-fish
    fifc
    # sponge
    colored-man-pages
    tide
    plugin-sudope
    autopair
    fish-bd
  ]
  ++ (with pkgs; [
    tealdeer
    ripgrep-all
    fzf
    # zoxide
  ]);

  home.sessionVariables = {
    fzf_preview_dir_cmd = "eza -1 --all";
    fzf_diff_highlighter = "diff-so-fancy";
    fzf_history_time_format = "%d-%m-%y";
    # sponge_allow_previously_successful = "true";
  };

}