# flake and cmake file adapted from https://github.com/outfoxxed/hyprland-plugin-nix
{
  description = "Hyprland window bar plugin";

  inputs = {
    hyprland.url = "github:horriblename/Hyprland/nix-pluginenv";
    nixpkgs.follows = "hyprland/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, hyprland, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        hyprpkgs = hyprland.packages.${system};
      in
      {
        packages.default = pkgs.callPackage ./derivation.nix {
          stdenv = pkgs.gcc12Stdenv;
          hyprland = hyprpkgs.hyprland;
          wlroots = hyprpkgs.wlroots-hyprland;
        };

        devShells.default = pkgs.mkShell.override { stdenv = pkgs.gcc12Stdenv; } {
          name = "hyprland-plugin-shell";
          nativeBuildInputs = with pkgs; [
            cmake
            pkg-config

            clang-tools_15
            bear
          ];

          buildInputs = with pkgs; [
            hyprpkgs.wlroots-hyprland
            libdrm
            pixman
          ];

          inputsFrom = [
            hyprpkgs.hyprland
            hyprpkgs.wlroots-hyprland
          ];

          #HYPRLAND_HEADERS = hyprpkgs.hyprland.src; - TODO
        };
      });
}
