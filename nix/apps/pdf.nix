{ ... }:
{
  perSystem =
    { pkgs, lib, ... }:
    {
      apps.pdf = {
        type = "app";
        meta.description = "Export every lecture to build/Lxx/Lxx.pdf using a local browser";
        program = pkgs.writeShellApplication {
          name = "iw1-pdf";
          runtimeInputs = [
            pkgs.marp-cli
            pkgs.git
          ]
          ++ lib.optionals pkgs.stdenv.isLinux [ pkgs.chromium ];
          text = ''
            cd "$(git rev-parse --show-toplevel)"
            ${lib.optionalString pkgs.stdenv.isLinux ''export CHROME_PATH="''${CHROME_PATH:-${pkgs.chromium}/bin/chromium}"''}
            for d in lectures/L[0-9][0-9]; do
              n=$(basename "$d")
              mkdir -p "build/$n"
              marp -c .marprc.yml --no-stdin --pdf --pdf-notes "$d/$n.md" -o "build/$n/$n.pdf" "$@"
            done
            echo "PDFs are in ./build/"
          '';
        };
      };
    };
}
