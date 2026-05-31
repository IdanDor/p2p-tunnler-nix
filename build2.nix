# Run nix-build build2.nix

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
        # nativeBuildInputs = [ pkgs.breakpointHook ];
        # preBuild = ''
        #   echo "Testing hook..."
        #   exit 1 
        # '';
      };
    };
  };
  # Generate from devenv shell using: `crate2nix generate` in ./opendht-rs
  crate = pkgs.callPackage ./opendht-rs/Cargo.nix {
    buildRustCrateForPkgs = customBuildRustCrateForPkgs;
  };
in
  crate.rootCrate.build
