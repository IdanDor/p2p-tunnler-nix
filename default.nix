{ pkgs ? import <nixpkgs> {} }:

pkgs.callPackage ./build/p2p.nix { }