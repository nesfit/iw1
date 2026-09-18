{ inputs, ... }:
{
  perSystem =
    {
      config,
      pkgs,
      lib,
      system,
      ...
    }:
    let
      src = inputs.self.lib.slidesSrc;

      # Converts every lectures/Lxx/Lxx.md; `format` is passed to marp
      # (--html or --pdf). Images referenced from the slides are copied
      # next to the output so relative paths keep working.
      mkSlides =
        {
          name,
          format,
          ext,
          extraInputs ? [ ],
          env ? { },
        }:
        pkgs.stdenvNoCC.mkDerivation (
          {
            pname = "iw1-lectures-${name}";
            version = "0-unstable";
            inherit src;
            nativeBuildInputs = [ pkgs.marp-cli ] ++ extraInputs;
            buildPhase = ''
              runHook preBuild
              export HOME=$TMPDIR
              for d in lectures/L[0-9][0-9]; do
                n=$(basename "$d")
                mkdir -p "$out/$n"
                marp -c .marprc.yml --no-stdin ${format} "$d/$n.md" -o "$out/$n/$n.${ext}"
                if [ -d "$d/img" ]; then cp -r "$d/img" "$out/$n/"; fi
              done
              runHook postBuild
            '';
            dontInstall = true;
          }
          // env
        );
    in
    {
      packages = {
        # nix build .#lectures  -> result/L00/L00.html, ...
        lectures = mkSlides {
          name = "html";
          format = "--html";
          ext = "html";
        };
        default = config.packages.lectures;
      }
      # The attribute set's keys must not depend on `pkgs` (that comes from
      # `config` and would recurse), so the guard uses the plain `system` arg.
      // lib.optionalAttrs (lib.hasSuffix "-linux" system) {
        # nix build .#lectures-pdf -> result/L00/L00.pdf, ... (needs chromium,
        # so Linux only; on macOS use `nix run .#pdf` with a local browser).
        lectures-pdf = mkSlides {
          name = "pdf";
          format = "--pdf";
          ext = "pdf";
          extraInputs = [ pkgs.chromium ];
          env = {
            CHROME_PATH = "${pkgs.chromium}/bin/chromium";
            CHROME_NO_SANDBOX = "true";
            # The sandbox has no system fonts; Carlito is metric-compatible
            # with Calibri, which the old PowerPoint template used.
            FONTCONFIG_FILE = pkgs.makeFontsConf {
              fontDirectories = [
                pkgs.carlito
                pkgs.dejavu_fonts
                pkgs.noto-fonts
              ];
            };
          };
        };
      };
    };
}
