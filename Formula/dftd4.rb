class Dftd4 < Formula
  desc "Generally applicable, charge dependent London-dispersion correction"
  homepage "https://github.com/dftd4/dftd4"
  url "https://github.com/dftd4/dftd4/archive/v3.4.0.tar.gz"
  sha256 "f3b0a16a952817ae48e819626e13676fba3b61c8beea47b0f8ada2fbb679fb7b"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/dftd4-3.3.0"
    sha256 cellar: :any, big_sur:      "e3c1df2da7db92ede15bfd0fa5e60269f400af313bc67d03c729fed7d8b240b0"
    sha256 cellar: :any, catalina:     "55567df5c17ed6b289d91fd1027bd3dbc11a3e5d77a385dec0541c7d8b252d38"
    sha256               x86_64_linux: "bfee04ba34bb9cfecb54919c3db76d2a0d8e09fb8dc79ff42eed31cd27123f08"
  end

  depends_on "asciidoctor" => :build
  depends_on "meson" => :build
  depends_on "mstore" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gcc"
  depends_on "mctc-lib"
  depends_on "multicharge"
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
    system "meson", "setup", "_build", *meson_args
    system "meson", "compile", "-C", "_build"
    system "meson", "test", "-C", "_build", "--no-rebuild", "--num-processes", "1"
    system "meson", "install", "-C", "_build", "--no-rebuild"
  end

  test do
    system "#{bin}/dftd4", "--version"
  end
end
