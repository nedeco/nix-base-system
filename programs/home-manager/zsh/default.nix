{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.nedeco.zsh;

  inherit (pkgs) fetchFromGitHub;
  inherit (lib) mkOrder;
in
{
  options.nedeco.zsh = {
    enable = lib.mkEnableOption "nedeco.zsh";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;

      enableCompletion = true;

      autosuggestion.enable = false;

      syntaxHighlighting = {
        enable = true;

        highlighters = [
          "main"
          "brackets"
          "cursor"
        ];
      };

      plugins = [
        {
          # https://github.com/zsh-users/zsh-autosuggestions
          name = "zsh-autosuggestions";
          src = fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-autosuggestions";
            tag = "v0.7.1";
            hash = "sha256-vpTyYq9ZgfgdDsWzjxVAE7FZH4MALMNZIFyEOBLm5Qo=";
          };
        }

        {
          # https://github.com/trystan2k/zsh-tab-title
          name = "zsh-tab-title";
          src = fetchFromGitHub {
            owner = "trystan2k";
            repo = "zsh-tab-title";
            tag = "v3.1.0";
            hash = "sha256-YvAN8c2++WRJYGblstZKWCWrCl0byXQqFryTA35/Ao0=";
          };
        }
      ];

      initContent = lib.mkMerge [
        (mkOrder 500 # sh
          ''
            # Options
            setopt AUTO_CD
            setopt AUTO_PUSHD
            setopt INTERACTIVE_COMMENTS

            # Keymaps
            bindkey '^[[1;3C' forward-word  # Alt+Right
            bindkey '^[[1;3D' backward-word # Alt+Left

            # Plugins
            ZSH_AUTOSUGGEST_STRATEGY=(completion)

            ZSH_TAB_TITLE_ENABLE_FULL_COMMAND=true
            ZSH_TAB_TITLE_DEFAULT_DISABLE_PREFIX=true
            ZSH_TAB_TITLE_ADDITIONAL_TERMS='ghostty|wezterm'
          ''
        )

        (mkOrder 1000 # sh
          ''
            # PATH
            if [[ -d "$HOME/.bin" ]]; then
              path=("$HOME/.bin" $path)
              export PATH
            fi
          ''
        )

        (mkOrder 1500 # sh
          ''
            # nedeco Functions
            () {
              local nedeco_functions="$HOME/.zsh/nedeco_functions"
              if [[ -d $nedeco_functions ]]; then
                typeset -TUg +x FPATH=$nedeco_functions:$FPATH fpath
                autoload ''${=$(cd "$nedeco_functions" && echo *)}
              fi
            }
          ''
        )
      ];
    };

    home.file.".zsh/nedeco_functions" = {
      source = ./functions;
      recursive = true;
    };
  };
}
