class Mstore < Formula
  desc "Modular structure store for testing"
  homepage "https://github.com/grimme-lab/mstore"
  url "https://github.com/grimme-lab/mstore/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "c6743437baedfa900fc23220a00ea308750365262b998c73c3de65f7938bb282"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/mstore-0.4.0"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "baf69c42b74c64af2a212b091f2934212822a1d40cd6344a03fdf3cb4929c2a2"
    sha256 cellar: :any, arm64_sequoia: "86361f8f68f8ad6627752a5dd09716e9c70d01aeb177dfb1aa6fff12f0ec5fb7"
    sha256 cellar: :any, x86_64_linux:  "904d296d62f4921c148b25be1e71cac85e546d04a30e981841a7cef31c37093c"
  end

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
