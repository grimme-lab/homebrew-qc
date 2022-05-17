class Xtb < Formula
  desc "Semiemprical extended tight-binding program package"
  homepage "https://xtb-docs.readthedocs.io"
  url "https://github.com/grimme-lab/xtb/releases/download/v6.5.0/xtb-6.5.0-source.tar.xz"
  sha256 "5f780656bf7b440a8e1f753a9a877401a7d497fb3160762f48bdefc8a9914976"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/xtb-6.4.1"
    sha256 cellar: :any, big_sur:      "e1112bc71e3ecc47d99930cdadc6871ae79cf7f34855aa5bc1ffd873202a5895"
    sha256 cellar: :any, catalina:     "52e6892a0b08070fed1be89dfd8ac1f7d2a88986da57b6e2c6af6af3b1a99023"
    sha256               x86_64_linux: "53f29386748285027708a5ec2488668b55ccd010125b84f8849b08e147fe7c2f"
  end

  depends_on "asciidoctor" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "test-drive" => :build
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
    meson_args << "-Dla_backend=openblas"
    meson_args << "-Dbuild_name=homebrew"
    meson_args << "-Dfortran_link_args=-Wl,-stack_size,0x1000000" if OS.mac?
    system "meson", "setup", "_build", *meson_args
    system "meson", "compile", "-C", "_build"
    system "meson", "test", "-C", "_build", "--no-rebuild", "--num-processes", "1"
    system "meson", "install", "-C", "_build", "--no-rebuild"
  end

  test do
    system "#{bin}/xtb", "--version"
  end
end
