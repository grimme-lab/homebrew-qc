class MctcLib < Formula
  desc "Modular computation tool chain library"
  homepage "https://grimme-lab.github.io/mctc-lib"
  url "https://github.com/grimme-lab/mctc-lib/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "83ddeea24082d25c62db375ad8bd7f53e49e6d81dc834613b1da77b1ca8a8813"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/mctc-lib-0.7.0"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "997c80a9fc926ac65d02923fdc7b0af4014f1263a146f292010d0ede9379fedb"
    sha256 cellar: :any, arm64_sequoia: "2d7df01f1cb6cf200cb22008dbef04820a11307111ae0e5e83f648bfe4700f89"
    sha256 cellar: :any, x86_64_linux:  "7b1df39238bb26c28fce41a3bf64e8f34e0d69ebb045a6da82b6efe88e92d443"
  end

  depends_on "asciidoctor" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "gcc"
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
    system "meson", "test", "-C", "_build", "--no-rebuild", "--num-processes", "1"
    system "meson", "install", "-C", "_build", "--no-rebuild"
  end

  test do
    system "#{bin}/mctc-convert", "--version"
  end
end
