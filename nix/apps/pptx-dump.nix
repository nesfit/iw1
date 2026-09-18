{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      apps.pptx-dump = {
        type = "app";
        meta.description = "Dump the text, notes, links and media of a .pptx (source for converting old decks to Markdown)";
        program = pkgs.writeShellApplication {
          name = "iw1-pptx-dump";
          runtimeInputs = [ (pkgs.python3.withPackages (p: [ p.python-pptx ])) ];
          text = ''
            exec python3 ${../../tools/pptx-dump.py} "$@"
          '';
        };
      };
    };
}
