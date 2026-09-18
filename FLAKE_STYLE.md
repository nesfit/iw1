# Flake structure conventions

The flake follows the netsearchpkgs layout (flake-parts + haumea + treefmt-nix):
every file under `./nix/` is a flake-parts module, auto-loaded by haumea, one
responsibility per file, attribute name derived from the file name.

```
flake.nix               entry point, inputs, systems, treefmt
lib/default.nix         shared helpers exported as flake.lib (slidesSrc)
nix/apps/               nix run .#<name>   (preview, pdf, pptx-dump)
nix/devShells/          nix develop
nix/packages/           nix build .#<name> (lectures, lectures-pdf)
```

- Use `follows` for every input that depends on nixpkgs.
- Apps always carry `meta.description`.
- Packages that need the repository content take it from
  `inputs.self.lib.slidesSrc`, a `lib.fileset` that includes only
  `lectures/` and `.marprc.yml`, so touching the exercises or `.tmp/`
  never rebuilds the slides.
- Browser-dependent outputs (PDF) are Linux-only packages guarded with
  `lib.optionalAttrs pkgs.stdenv.isLinux`; macOS uses the `pdf` app with a
  locally installed browser.
- `nix fmt` runs nixfmt over the Nix files; `nix flake check` must pass
  before pushing.
