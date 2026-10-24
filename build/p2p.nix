# Build with: nix-build default.nix

{ pkgs ? import <nixpkgs> {} }:

let
  opendht = pkgs.callPackage ./opendht.nix { };
  
  p2p-tunnler = pkgs.fetchFromGitHub {
    owner = "IdanDor";
    repo = "p2p-tunnler";
    rev = "170f628847a20e8efd9eddac649af7bd7f46f3c2";
    hash = "sha256-gapS6qAt+2l4ezGwtWntsoi+MrnuOHo3XkvfzbETUkw=";
  };

  customBuildRustCrateForPkgs = pkgs: pkgs.buildRustCrate.override {
    defaultCrateOverrides = pkgs.defaultCrateOverrides // {
      opendht = attrs: {
        # The Rust wrapper links against the OpenDHT C++ library.
        nativeBuildInputs = [ pkgs.pkg-config ];
        buildInputs = [
          opendht
          pkgs.gnutls
          pkgs.msgpack-cxx
          pkgs.fmt.dev
        ];
        PKG_CONFIG_PATH = "${opendht}/lib/pkgconfig";
      };
      p2p-tunnler = attrs: {
        # Native libraries used by the OpenDHT wrapper at final link time.
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
  # Cargo.nix is generated from p2p-tunnler's Cargo.lock with crate2nix.
  crate = pkgs.callPackage "${p2p-tunnler}/Cargo.nix" {
    buildRustCrateForPkgs = customBuildRustCrateForPkgs;
  };
in
  crate.rootCrate.build
