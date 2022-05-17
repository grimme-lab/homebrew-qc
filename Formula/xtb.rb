class Xtb < Formula
  desc "Semiemprical extended tight-binding program package"
  homepage "https://xtb-docs.readthedocs.io"
  url "https://github.com/grimme-lab/xtb/releases/download/v6.5.0/xtb-6.5.0-source.tar.xz"
  sha256 "5f780656bf7b440a8e1f753a9a877401a7d497fb3160762f48bdefc8a9914976"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/xtb-6.5.0"
    sha256 cellar: :any, big_sur:      "c6b252f983bfce641a7b7877c2203a6d124c493ed81bdca5ab73b4639cb15592"
    sha256 cellar: :any, catalina:     "c0d1ca90fc56e8b484a49f3bc59f481201b730ac3c37e4625037a6c212db91d9"
    sha256               x86_64_linux: "9fda3250e10de6bf13b39e04b7a066b9d7838e0b596ab3d93c8dc9a7035664da"
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
