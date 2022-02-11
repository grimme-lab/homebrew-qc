class Dftd4 < Formula
  desc "Generally applicable, charge dependent London-dispersion correction"
  homepage "https://github.com/dftd4/dftd4"
  url "https://github.com/dftd4/dftd4/archive/v3.3.0.tar.gz"
  sha256 "60d4f30d97cae95a7b48a99e10848ef600b605f9da98c4893a6034bded1a7f24"
  license "LGPL-3.0-or-later"

  depends_on "asciidoctor" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gcc"
  depends_on "mctc-lib"
  depends_on "openblas"
  fails_with gcc: "4"
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"
  fails_with :clang

  def install
    ENV.fortran
    meson_args = std_meson_args
    meson_args << "-Dlapack=openblas"
    system "meson", "setup", "_build", *meson_args
    system "meson", "compile", "-C", "_build"
    system "meson", "test", "-C", "_build", "--no-rebuild", "--num-processes", "1"
    system "meson", "install", "-C", "_build", "--no-rebuild"
  end

  test do
    system "#{bin}/dftd4", "--version"
  end
end
