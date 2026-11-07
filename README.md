# p2p-tunnler Nix entrypoint

A flake entrypoint for [p2p-tunnler](https://github.com/IdanDor/p2p-tunnler).
The source repository owns the package, native OpenDHT recipe, crate overrides,
checks and development shell. This flake forwards those outputs and makes its
source input follow the same Nixpkgs. No git submodule checkout is needed for
flake builds or GitHub flake inputs.

```sh
nix build
nix run . -- --help
nix flake check --option allow-import-from-derivation false
nix develop
```

Use it from another flake:

```nix
inputs.p2p-tunnler = {
  url = "github:IdanDor/wireguard-p2p-nix/master";
  inputs.nixpkgs.follows = "nixpkgs";
};
# In the consumer's NixOS module:
environment.systemPackages = [ inputs.p2p-tunnler.packages.${pkgs.stdenv.hostPlatform.system}.default ];
```

There is no second consumer source input, copied build recipe, overlay or
import-from-derivation requirement. `packages.<system>.p2p-tunnler`, `apps`,
`checks`, `devShells` and `formatter` are also available. See the source
repository's [Nix guide](https://github.com/IdanDor/p2p-tunnler/blob/master/docs/nix.md).

## Updating and landing the two-repository change

The source revision in `flake.lock` matches the source submodule commit. Publish
the source commit before publishing this repository so that GitHub consumers can
fetch it. For subsequent updates, advance the source submodule to the published
commit and run `nix flake update p2p-tunnler` here. Commit the resulting lock and
gitlink together; never commit a lock pointing at a temporary local path.

To validate local source changes before publishing them:

```sh
nix flake check --no-write-lock-file \
  --override-input p2p-tunnler ./p2p-tunnler \
  --option allow-import-from-derivation false
```

The existing OpenDHT and Rust-wrapper gitlinks are retained for development;
Cargo.lock/Cargo.nix and the OpenDHT recipe pin the actual package dependencies.
Flake builds do not recursively initialize these submodules.
