{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.nedeco.git;
in
{
  options.nedeco.git = {
    enable = lib.mkEnableOption "nedeco.git";
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      lfs.enable = true;

      difftastic = {
        enable = true;
      };

      extraConfig = {
        core = {
          whitespace = "trailing-space,space-before-tab";
          autocrlf = "input";
        };

        pull = {
          rebase = true;
        };

        push = {
          default = "simple";
          autoSetupRemote = true;
          followTags = true;
        };

        fetch = {
          prune = true;
          pruneTags = true;
          all = true;
        };

        branch = {
          sort = "-committerdate";
        };

        tag = {
          sort = "version:refname";
        };

        merge = {
          mergiraf = {
            name = "mergiraf";
            driver = "${lib.getExe pkgs.mergiraf} merge --git %O %A %B -s %S -x %X -y %Y -p %P -l %L";
          };

          yarn = {
            name = "yarn";
            driver = "yarn install";
          };
        };

        mergetool = {
          nixfmt = {
            cmd = "${lib.getExe pkgs.nixfmt-rfc-style} --mergetool \"$BASE\" \"$LOCAL\" \"$REMOTE\" \"$MERGED\"";
            trustExitCode = true;
          };
        };

        rebase = {
          updateRefs = true;
        };

        rerere = {
          enabled = true;
          autoupdate = true;
        };

        diff = {
          pandoc = {
            textconv = "${lib.getExe pkgs.pandoc} --to=markdown";
            prompt = false;
          };
        };

        init = {
          defaultBranch = "master";
        };

        color = {
          ui = "auto";
        };

        column = {
          ui = "auto";
        };

        help = {
          autocorrect = "prompt";
        };

        apply = {
          whitespace = "fix";
        };
      };

      ignores = [
        "*~"
        "*.swp"
        ".direnv/"
        ".DS_Store"
      ];

      attributes = [
        # specific
        "yarn.lock merge=yarn"
        ".gitattributes export-ignore"
        ".gitignore export-ignore"
        ".gitkeep export-ignore"
        # mergiraf
        "*.java merge=mergiraf"
        "*.kt merge=mergiraf"
        "*.rs merge=mergiraf"
        "*.go merge=mergiraf"
        "*.js merge=mergiraf"
        "*.jsx merge=mergiraf"
        "*.mjs merge=mergiraf"
        "*.json merge=mergiraf"
        "*.yml merge=mergiraf"
        "*.yaml merge=mergiraf"
        "*.toml merge=mergiraf"
        "*.html merge=mergiraf"
        "*.htm merge=mergiraf"
        "*.xhtml merge=mergiraf"
        "*.xml merge=mergiraf"
        "*.c merge=mergiraf"
        "*.h merge=mergiraf"
        "*.cc merge=mergiraf"
        "*.cpp merge=mergiraf"
        "*.hpp merge=mergiraf"
        "*.cs merge=mergiraf"
        "*.dart merge=mergiraf"
        "*.dts merge=mergiraf"
        "*.scala merge=mergiraf"
        "*.sbt merge=mergiraf"
        "*.ts merge=mergiraf"
        "*.tsx merge=mergiraf"
        "*.py merge=mergiraf"
        "*.php merge=mergiraf"
        "*.phtml merge=mergiraf"
        "*.sol merge=mergiraf"
        "*.lua merge=mergiraf"
        "*.rb merge=mergiraf"
        "*.nix merge=mergiraf"
        "*.sv merge=mergiraf"
        "*.svh merge=mergiraf"
        # pandoc
        "*.docx diff=pandoc"
        "*.epub diff=pandoc"
        "*.odt diff=pandoc"
        # other
        "*.age binary"
        "*.bat eol=crlf"
        "*.cmd eol=crlf"
        "*.ps1 eol=crlf"
      ];
    };

    home.sessionVariables.GIT_CEILING_DIRECTORIES = "/Users";
  };
}
