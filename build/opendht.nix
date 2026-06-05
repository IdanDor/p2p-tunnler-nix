{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation rec {
  pname = "opendht";
  # version = "3.5.8";
  version = "3.7.1";

  src = pkgs.fetchFromGitHub {
    owner = "savoirfairelinux";
    repo = "${pname}";
    rev = "v${version}"; # Can be a tag or a specific commit hash
    hash = "sha256-AyuSl87qKqer4pid+oXLTszVwOrpQZf9B4DG/UuVFaA="; 
  };  # Path to your source code containing CMakeLists.txt
  
  # Tools required at build time (like compilers and build systems)
  nativeBuildInputs = [ 
    pkgs.cmake
    pkgs.pkg-config # Often needed for finding libraries
    pkgs.ninja
  ];
  
  # Libraries needed at runtime and link time
  buildInputs = with pkgs; [ 
    boost
    libargon2
    asio
    fmt.dev
    msgpack-cxx
    nettle
    gnutls
  ];
  
  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DOPENDHT_C=ON"
    "-DOPENDHT_PYTHON=OFF"
    "-DOPENDHT_PROXY_OPENSSL=OFF"
    "-DOPENDHT_HTTP=OFF"
    "-DOPENDHT_TOOLS=OFF"
    "-DBUILD_TESTING=OFF"
  ];
  
  cmakeBuildType = "MinSizeRel";
}