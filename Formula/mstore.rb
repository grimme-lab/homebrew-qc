class Mstore < Formula
  desc "Modular structure store for testing"
  homepage "https://github.com/grimme-lab/mstore"
  url "https://github.com/grimme-lab/mstore/archive/v0.2.0.tar.gz"
  sha256 "95edba88afbc8013f57f4c818a97c0500cc40b158bed11234c061b2b6d7e480d"
  license "Apache-2.0"
  revision 2

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/mstore-0.2.0_1"
    sha256 cellar: :any,                 big_sur:      "c931df766ef4249b63022b5891c02a47be5d7a03c1f714662866cf7cc57188ae"
    sha256 cellar: :any,                 catalina:     "df7c7e3d791c9ddbd4ac54af1409f9010b2569341f010c299919c677e922abe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f3775e3c41670cfd90b4ecf659b9cfc08dd6024b3810b61ef57972d888ccb6da"
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
    inreplace "config/install-mod.py", /python$/, "python3"
    meson_args = std_meson_args
    system "meson", "setup", "_build", *meson_args
    system "meson", "compile", "-C", "_build"
    system "meson", "install", "-C", "_build", "--no-rebuild"
  end

  test do
    system "#{bin}/mstore-info"
  end
end
