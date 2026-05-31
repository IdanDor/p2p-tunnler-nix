# Run nix-build build3.nix

{ pkgs ? import <nixpkgs> {} }:

let
  opendht = pkgs.callPackage ./build.nix { };

  customBuildRustCrateForPkgs = pkgs: pkgs.buildRustCrate.override {
    defaultCrateOverrides = pkgs.defaultCrateOverrides // {
      opendht = attrs: {
        # This means build time, unlike buildInputs which is runtime.
        buildInputs = [
          opendht
          pkgs.pkg-config  # required for lookup.
          # required by opendht
          pkgs.gnutls
          pkgs.msgpack-cxx
          pkgs.fmt.dev
        ];
        PKG_CONFIG_PATH = "${opendht}/lib/pkgconfig";
      };
      wireguard-p2p = attrs: {
        buildInputs = [
          pkgs.fmt.dev
          pkgs.openssl.dev
          pkgs.nettle
          pkgs.boost
          pkgs.libargon2
          pkgs.jsoncpp
          pkgs.http-parser
        ];
      };
    };
  };
  # Generate from devenv shell using: `crate2nix generate` in ./wireguard-p2p
  crate = pkgs.callPackage ./wireguard-p2p/Cargo.nix {
    buildRustCrateForPkgs = customBuildRustCrateForPkgs;
  };
in
  crate.rootCrate.build
