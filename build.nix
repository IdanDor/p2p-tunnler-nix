{ pkgs ? import <nixpkgs> {} }:
  pkgs.stdenv.mkDerivation {
  pname = "opendht";
  version = "3.5.8";

  src = ./opendht; # Path to your source code containing CMakeLists.txt

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