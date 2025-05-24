# {
#     # programs.firefox.enable = true;

#     # these both are equivalent (see nix syntax)

#     programs.firefox = {
#         enable = true;

#         profiles.default = {
#             # https://mynixos.com/home-manager/option/programs.firefox.profiles.%3Cname%3E.settings
#             settings = {
#                 # the key `"ui.systemUsesDarkTheme"` is a string value
#                 # so "ui.systemUsesDarkTheme" != ui.systemUsesDarkTheme
#                 # so "ui.systemUsesDarkTheme" can not be written as ui = {SystemUsesDarkTheme = ...}
#                 # but that does not mean all strings in nix can not be nix attributes
#                 # eg - profiles.default.settings == profiles."default".settings
#                 # it will take some time to understand this

#                 # now the easiest way to get these settings values is to... just copy them from firefox
#                 # just configure firefox from ui and copy those changes from there to here
#                 # or copy from someone else's config
#                 "ui.systemUsesDarkTheme" = 1;
#             };
#         };

#         policies.ExtensionSettings = {
#             "addon@darkreader.org" = {
#                 install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/darkreader/latest.xpi";
#                 installation_mode = "normal_installed";
#             };
#         };
#     };
# }