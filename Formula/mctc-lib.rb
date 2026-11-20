class MctcLib < Formula
  desc "Modular computation tool chain library"
  homepage "https://grimme-lab.github.io/mctc-lib"
  url "https://github.com/grimme-lab/mctc-lib/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "83ddeea24082d25c62db375ad8bd7f53e49e6d81dc834613b1da77b1ca8a8813"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/mctc-lib-0.3.2_1"
    sha256 cellar: :any,                 arm64_sequoia: "87b6e00e60355c7467b4e56275f30bc2d5768fdb1e92791405c382b6d966d4ea"
    sha256 cellar: :any,                 arm64_sonoma:  "1638ff71843ab3ba0948e7dbab91b1f4da49be247979d96861b35c2ef5c8ac1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4a91673320659291a10fc17b817cd6a6ab1eb0c00de3dc0fffcda0dedbd9c7b"
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
