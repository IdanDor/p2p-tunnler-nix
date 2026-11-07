{
  description = "Nix packaging entrypoint for p2p-tunnler";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    p2p-tunnler = {
      url = "github:IdanDor/p2p-tunnler/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { p2p-tunnler, ... }: {
    inherit (p2p-tunnler)
      packages
      apps
      checks
      devShells
      formatter
      ;
  };
}
