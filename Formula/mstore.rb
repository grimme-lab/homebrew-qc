class Mstore < Formula
  desc "Modular structure store for testing"
  homepage "https://github.com/grimme-lab/mstore"
  url "https://github.com/grimme-lab/mstore/archive/v0.2.0.tar.gz"
  sha256 "95edba88afbc8013f57f4c818a97c0500cc40b158bed11234c061b2b6d7e480d"
  license "Apache-2.0"
  revision 1

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/mstore-0.2.0"
    sha256 cellar: :any,                 big_sur:      "9430b1ac9824d9dff5a281b7b943c74a22a5e68986fed75a86328aea16255dd6"
    sha256 cellar: :any,                 catalina:     "e88a5b37430fabb8544b255d4919d17466dfdd979b46a13b5246644b23f82bd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "63f3232343889c646c541864d4f817a63639907cba170cd319f39e7d7333175f"
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
