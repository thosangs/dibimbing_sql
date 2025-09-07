{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-23.11"; # Or "unstable"

  # Collection of packages that are available in your shell
  packages = [
    pkgs.postgresql
  ];
}
