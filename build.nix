{ pkgs ? import <nixpkgs> {} }:

pkgs.callPackage ./build/opendht.nix {}
