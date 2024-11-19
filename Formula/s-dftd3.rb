class SDftd3 < Formula
  desc "Simple reimplementation of DFT-D3"
  homepage "https://dftd3.readthedocs.io"
  url "https://github.com/dftd3/simple-dftd3/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "19400a176eb4dcee7b89181a5a5f0033fe6b05c52821e54896a98448761d003a"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/s-dftd3-0.7.0"
    sha256 cellar: :any,                 monterey:     "058234bee2a962c35fa0dac9f13c06e3c317a5bff9420897e955c36c2e9ab86d"
    sha256 cellar: :any,                 big_sur:      "6ddce011c0472a1009d2b82e1430b13122f42f4fb8342bc298bc06fc648a6595"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9c1d0dee40115d6f6b18a6fee5b495c36403521444f4fe88f6b84c568230989e"
  end

  depends_on "asciidoctor" => :build
  depends_on "meson" => :build
  depends_on "mstore" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gcc"
  depends_on "mctc-lib"
  depends_on "openblas"
  depends_on "toml-f"
  fails_with gcc: "4"
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"
  fails_with :clang

  def install
    ENV.fortran
    meson_args = std_meson_args
    meson_args << "-Dblas=custom"
    meson_args << "-Dblas_libs=openblas"
    system "meson", "setup", "_build", *meson_args
    system "meson", "compile", "-C", "_build"
    system "meson", "test", "-C", "_build", "--no-rebuild", "--num-processes", "1"
    system "meson", "install", "-C", "_build", "--no-rebuild"
  end

  test do
    system "#{bin}/s-dftd3", "--version"
  end
end
