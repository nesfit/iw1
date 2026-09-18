{ inputs, ... }:
{
  perSystem =
    { pkgs, lib, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages =
          with pkgs;
          [
            marp-cli
            (python3.withPackages (p: [ p.python-pptx ]))
            nil
            nixfmt-rfc-style
          ]
          ++ lib.optionals stdenv.isLinux [ chromium ];

        # marp-cli needs a browser only for PDF/PPTX/PNG export; on macOS it
        # finds the installed Chrome/Edge itself.
        shellHook = lib.optionalString pkgs.stdenv.isLinux ''
          export CHROME_PATH=${pkgs.chromium}/bin/chromium
        '';
      };
    };
}
