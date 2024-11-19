class MctcLib < Formula
  desc "Modular computation tool chain library"
  homepage "https://grimme-lab.github.io/mctc-lib"
  url "https://github.com/grimme-lab/mctc-lib/releases/download/v0.3.2/mctc-lib-0.3.2.tar.xz"
  sha256 "8c4ebdf9d81272f0dfa0bfa6c7fecd51f1f3d83d3629c719298d9f349de6ee0b"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/mctc-lib-0.3.1"
    sha256 cellar: :any,                 monterey:     "2c30f90752bdcf9a5d9e9587b1c1cf07a9fb7aea6241135f99eacae51219d7e9"
    sha256 cellar: :any,                 big_sur:      "d7ae794a17647e2204473fffcb532a5f237e482f65b5d2a9b3ef84a605f9bd56"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1398ba8c6f7a61f0b59515e20a4cd89221ec9ab4b97c65682cbe6cd84bb98b14"
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
