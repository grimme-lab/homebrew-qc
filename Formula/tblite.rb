class Tblite < Formula
  desc "Light-weight tight-binding framework"
  homepage "https://github.com/tblite/tblite"
  url "https://github.com/tblite/tblite/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "c4a67dfbe04827095fd7598183e076fa3017a5a475c4f90fd28e78992dc19ea7"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/tblite-0.3.0"
    sha256 cellar: :any, monterey:     "765a780985e332058a0288a6f22623ba06d07115bce7dc8af29037bcb5e92e1a"
    sha256 cellar: :any, big_sur:      "df658b218a4dbb132f190447638e3fc15f7d9c001eb576e80c13ea46e628274e"
    sha256               x86_64_linux: "d07351e809391edca09133abb2d34ff3cf866b3b00d34ed5dc353dc04dc1bdb3"
  end

  depends_on "asciidoctor" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "dftd4"
  depends_on "gcc"
  depends_on "mctc-lib"
  depends_on "mstore"
  depends_on "multicharge"
  depends_on "openblas"
  depends_on "s-dftd3"
  depends_on "toml-f"
  fails_with gcc: "4"
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"
  fails_with :clang

  def install
    ENV.fortran
    meson_args = std_meson_args
    meson_args << "-Dlapack=openblas"
    system "meson", "setup", "_build", *meson_args
    system "meson", "compile", "-C", "_build"
    system "meson", "test", "-C", "_build", "--no-rebuild", "--num-processes", "1"
    system "meson", "install", "-C", "_build", "--no-rebuild"
  end

  test do
    system "#{bin}/tblite", "--version"
  end
end
