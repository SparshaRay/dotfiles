{pkgs, ...} : {

  programs.fish = {
    enable = true;
    functions = {
      fish_greeting = "echo $hostname && date +%s | md5sum";
    };
    shellInit = ''
          eval "$(micromamba shell hook --shell fish)"
          direnv hook fish | source
    '';
    shellAliases = {
            # cd = "z";
            ls = "eza";
    };
  };

  home.packages = with pkgs.fishPlugins; [
    # keep-sorted start
    z
    fzf-fish
    fifc
    sponge
    colored-man-pages
    tide
    plugin-sudope
    autopair
    fish-bd
    # keep-sorted end
  ]
  ++ (with pkgs; [
    # keep-sorted start
    tldr
    bat
    eza
    ripgrep
    fd
    fzf
    zoxide
    # keep-sorted end
  ]);

  home.sessionVariables = {
    fzf_preview_dir_cmd = "eza -1 --all";
    fzf_diff_highlighter = "diff-so-fancy";
    fzf_history_time_format = "%d-%m-%y";
    sponge_allow_previously_successful = "false";
  };

}