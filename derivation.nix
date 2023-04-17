{ lib
, stdenv
, fetchFromGitHub
, cmake
, hyprland
, pkg-config
, cairo
, hyprland-protocols
, libdrm
, libinput
, libxkbcommon
, mesa
, pango
, udis86
, wayland
, wayland-protocols
, wayland-scanner
, pciutils
, wlroots
, libxcb
, xcbutilwm
, xwayland
  # , wf-touch
, version ? "git"
}: stdenv.mkDerivation {
  pname = "hyprland-hyprbars";
  inherit version;
  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprland-plugins";
    sparseCheckout = [
      "hyprbars"
    ];
    rev = "bb1437add2df7f76147f7beb430365637fc2c35e";
    sha256 = "sha256-4j4B+ZMyTYY7cJJ1yjMRel0Z/zJXlL3r1ID9MeStU4o=";
  };

  HYPRLAND_HEADERS = "${hyprland.dev}/include";

  patches = [
    ./cmake.patch
  ];

  outputs = [ "out" ];

  nativeBuildInputs = [ pkg-config cmake ];

  buildInputs = [
    hyprland
    cairo
    hyprland-protocols
    libdrm
    libinput
    libxkbcommon
    mesa
    pango
    udis86
    wayland
    wayland-protocols
    wayland-scanner
    pciutils
    wlroots

    libxcb
    xcbutilwm
    xwayland
  ];

  meta = with lib; {
    homepage = "https://github.com/hyprwm/hyprland-plugins";
    description = "Hyprland window bar plugin";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
