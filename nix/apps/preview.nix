{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      apps.preview = {
        type = "app";
        meta.description = "Live-preview the lectures in a browser (marp --server --watch)";
        program = pkgs.writeShellApplication {
          name = "iw1-preview";
          runtimeInputs = [
            pkgs.marp-cli
            pkgs.git
          ];
          text = ''
            cd "$(git rev-parse --show-toplevel)"
            exec marp -c .marprc.yml --server --watch lectures "$@"
          '';
        };
      };
    };
}
