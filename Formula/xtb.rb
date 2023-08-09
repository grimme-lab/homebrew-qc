class Xtb < Formula
  desc "Semiemprical extended tight-binding program package"
  homepage "https://xtb-docs.readthedocs.io"
  url "https://github.com/grimme-lab/xtb/releases/download/v6.6.1/xtb-6.6.1-source.tar.xz"
  sha256 "de0b8d4515f3c878456d9f0f83d4922a55f2b4cbb9c56fe68df559ecd284ff86"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/xtb-6.6.0"
    sha256 cellar: :any, monterey:     "c6eb80ed5ff049beb37b0149da2b1686b073ef409cbf46f37836cd30e9322002"
    sha256 cellar: :any, big_sur:      "2fb487a2ad27c9ec4e2fcc11ee785654880caea5c8a54e1adde6247f2a6e1ee5"
    sha256               x86_64_linux: "041ea0164fa596a7b5ce5e4c30a8db48bbdbbbc521140628798589c4c4132838"
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
    meson_args << "-Dlapack=openblas"
    meson_args << "-Dtblite=disabled"
    meson_args << "-Dbuild_name=homebrew"
    meson_args << "-Dxtb:fortran_link_args=-Wl,-stack_size,0x1000000" if OS.mac?
    system "meson", "setup", "_build", *meson_args
    system "meson", "compile", "-C", "_build"
    system "meson", "test", "-C", "_build", "--no-rebuild", "--num-processes", "1"
    system "meson", "install", "-C", "_build", "--no-rebuild"
  end

  test do
    system "#{bin}/xtb", "--version"
  end
end
