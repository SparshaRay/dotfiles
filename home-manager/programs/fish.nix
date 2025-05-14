{
  programs.fish = {
    enable = true;
    functions = {
      fish_greeting = "echo $hostname && date +%s | md5sum";
    };
  };
}