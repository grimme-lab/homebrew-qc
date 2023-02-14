class Mstore < Formula
  desc "Modular structure store for testing"
  homepage "https://github.com/grimme-lab/mstore"
  url "https://github.com/grimme-lab/mstore/archive/v0.2.0.tar.gz"
  sha256 "95edba88afbc8013f57f4c818a97c0500cc40b158bed11234c061b2b6d7e480d"
  license "Apache-2.0"
  revision 2

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/mstore-0.2.0_2"
    sha256 cellar: :any,                 monterey:     "725732a3d64f3a9a2befa971d337878d2157bb5790f609ac2f7e72a908798873"
    sha256 cellar: :any,                 big_sur:      "84c05cfec49454e4621f1bc169c12e40a391fc005d653ca2d334517bcf6d8216"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4da57ed6d710233a9331a74edc95dcefa52c153d2f8c458797414b44db11e832"
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
