class Xtb < Formula
  desc "Semiemprical extended tight-binding program package"
  homepage "https://xtb-docs.readthedocs.io"
  url "https://github.com/grimme-lab/xtb/releases/download/v6.6.1/xtb-6.6.1-source.tar.xz"
  sha256 "de0b8d4515f3c878456d9f0f83d4922a55f2b4cbb9c56fe68df559ecd284ff86"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/xtb-6.6.1"
    sha256 cellar: :any, monterey:     "765a780985e332058a0288a6f22623ba06d07115bce7dc8af29037bcb5e92e1a"
    sha256 cellar: :any, big_sur:      "df658b218a4dbb132f190447638e3fc15f7d9c001eb576e80c13ea46e628274e"
    sha256               x86_64_linux: "d07351e809391edca09133abb2d34ff3cf866b3b00d34ed5dc353dc04dc1bdb3"
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
