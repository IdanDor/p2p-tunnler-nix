{
  pkgs ? import <nixpkgs> { },
  source ? ../p2p-tunnler,
}:
pkgs.callPackage (source + "/nix/package.nix") { }
