{
  lib,
  inputs,
  h,
}:
{
  # Source tree needed to build the slides: the lectures plus the Marp config.
  # Keeps the exercises, .git and .tmp out of the build input.
  slidesSrc = lib.fileset.toSource {
    root = ../.;
    fileset = lib.fileset.unions [
      ../lectures
      ../.marprc.yml
    ];
  };
}
