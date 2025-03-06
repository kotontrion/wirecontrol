{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    astal = {
      url = "github:aylur/astal?ref=pull/297/head";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, astal }: let
    system = "x86_64-linux";
    overlays = [
      (import ./blueprint-compiler-0.16.nix)
    ];
    pkgs = import nixpkgs {
      inherit system overlays;
    };
  in {
    packages.${system}.default = pkgs.stdenv.mkDerivation {
      name = "wirecontrol";
      src = ./.;

      nativeBuildInputs = with pkgs; [
        meson
        ninja
        pkg-config
        vala
        gobject-introspection
        desktop-file-utils
        pkgs.blueprint-compiler
      ];

      buildInputs = with pkgs; [
        astal.packages.${system}.wireplumber
        gtk4
        libadwaita
      ];
    };
  };
}
