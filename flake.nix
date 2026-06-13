{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    crane.url = "github:ipetkov/crane";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    crane,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      craneLib = crane.mkLib pkgs;
    in {
      formatter = pkgs.alejandra;

      packages.default = craneLib.buildPackage {
        src = craneLib.cleanCargoSource ./.;

        # Add extra inputs here or any other derivation settings
        # doCheck = true;
        buildInputs = with pkgs; [
          kdePackages.extra-cmake-modules
          fcitx5
          libxkbcommon
          openssl
        ];
        nativeBuildInputs = with pkgs; [
          cmake
          kdePackages.extra-cmake-modules
          libxkbcommon
          pkg-config
          rustPlatform.bindgenHook # cf. https://github.com/NixOS/nixpkgs/issues/52447#issuecomment-1915060425
          fcitx5
        ];
      };
    });
}
