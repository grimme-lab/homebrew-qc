class Mstore < Formula
  desc "Modular structure store for testing"
  homepage "https://github.com/grimme-lab/mstore"
  url "https://github.com/grimme-lab/mstore/archive/v0.2.0.tar.gz"
  sha256 "95edba88afbc8013f57f4c818a97c0500cc40b158bed11234c061b2b6d7e480d"
  license "Apache-2.0"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gcc"
  depends_on "mctc-lib"
  fails_with gcc: "4"
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"
  fails_with :clang

  def install
    ENV.fortran
    meson_args = std_meson_args
    system "meson", "setup", "_build", *meson_args
    system "meson", "compile", "-C", "_build"
    system "meson", "install", "-C", "_build", "--no-rebuild"
  end

  test do
    system "#{bin}/mstore-info"
  end
end
