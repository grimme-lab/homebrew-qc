class SDftd3 < Formula
  desc "Simple reimplementation of DFT-D3"
  homepage "https://dftd3.readthedocs.io"
  url "https://github.com/awvwgk/simple-dftd3/archive/v0.5.1.tar.gz"
  sha256 "3d775608bf85cd389385a84ea5586ede57215ff9cff646480552ca835a9de9ca"
  license "LGPL-3.0-or-later"

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
