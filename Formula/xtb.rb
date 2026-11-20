class Xtb < Formula
  desc "Semiemprical extended tight-binding program package"
  homepage "https://xtb-docs.readthedocs.io"
  url "https://github.com/grimme-lab/xtb/archive/refs/tags/v6.8.0.tar.gz"
  sha256 "73e3dc7d88b58309f35e7f3eab069cc3999a4211acd2ed98d768ffbd41c5acdf"
  license "LGPL-3.0-or-later"

  depends_on "asciidoctor" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "test-drive" => :build
  depends_on "dftd4"
  depends_on "gcc"
  depends_on "mctc-lib"
  depends_on "multicharge"
  depends_on "openblas"
  depends_on "tblite"
  fails_with gcc: "4"
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"
  fails_with :clang

  def install
    ENV.fortran
    meson_args = std_meson_args
    meson_args << "-Dlapack=openblas"
    meson_args << "-Dtblite=enabled"
    # meson_args << "-Dbuild_name=homebrew"
    # meson_args << "-Dxtb:fortran_link_args=-Wl,-stack_size,0x1000000" if OS.mac?
    system "meson", "setup", "_build", *meson_args
    system "meson", "compile", "-C", "_build"
    system "meson", "test", "-C", "_build", "--no-rebuild", "--num-processes", "1"
    system "meson", "install", "-C", "_build", "--no-rebuild"
  end

  test do
    system "#{bin}/xtb", "--version"
  end
end
