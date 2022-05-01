class Multicharge < Formula
  desc "Generally applicable, charge dependent London-dispersion correction"
  homepage "https://github.com/grimme-lab/multicharge"
  url "https://github.com/grimme-lab/multicharge/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "953e2ace2f4035b1fa8ecf680f90b5ce6ad5caae17c8d8ccbc2578b92b69d3e7"
  license "Apache-2.0"

  depends_on "asciidoctor" => :build
  depends_on "meson" => :build
  depends_on "mstore" => :build
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
    system "#{bin}/multicharge", "--version"
  end
end
