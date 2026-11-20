class SDftd3 < Formula
  desc "Simple reimplementation of DFT-D3"
  homepage "https://dftd3.readthedocs.io"
  url "https://github.com/dftd3/simple-dftd3/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "4d733eb6dbe8266fcfad67cef31de932a079f7c911f24f4b6efc594cd3d28803"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/s-dftd3-1.7.0"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "701efcd6148cee54254f6ac6fe0bb5f01728b45471d489b2f8084a00a5d042a6"
    sha256 cellar: :any, arm64_sequoia: "3c3fdb79be945f86340a3971546e4fb97def5b4990f77646dbad30836858485f"
    sha256 cellar: :any, x86_64_linux:  "a48c0fc0355751e82077e53d0a2dc7852e92144aece12706702639eb5e00c55b"
  end

  depends_on "asciidoctor" => :build
  depends_on "meson" => :build
  depends_on "mstore" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gcc"
  depends_on "mctc-lib"
  depends_on "openblas"
  depends_on "toml-f"
  fails_with gcc: "4"
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"
  fails_with :clang

  def install
    # GCC 16 strips bind(C) module procedures omitted from public in private modules
    inreplace "src/dftd3/api.f90",
              "public :: set_model_realspace_cutoff,",
              "public :: set_model_ghost_index, set_model_realspace_cutoff,"
    ENV.fortran
    meson_args = std_meson_args
    meson_args << "-Dblas=custom"
    meson_args << "-Dblas_libs=openblas"
    system "meson", "setup", "_build", *meson_args
    system "meson", "compile", "-C", "_build"
    system "meson", "test", "-C", "_build", "--no-rebuild", "--num-processes", "1"
    system "meson", "install", "-C", "_build", "--no-rebuild"
  end

  test do
    system "#{bin}/s-dftd3", "--version"
  end
end
