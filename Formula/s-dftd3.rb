class SDftd3 < Formula
  desc "Simple reimplementation of DFT-D3"
  homepage "https://dftd3.readthedocs.io"
  url "https://github.com/awvwgk/simple-dftd3/archive/v0.6.0.tar.gz"
  sha256 "4bef311f8e5a2c32141eddeea65615c3c8480f917cd884488ede059fb0962a50"
  license "LGPL-3.0-or-later"
  revision 1

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/s-dftd3-0.6.0"
    sha256 cellar: :any,                 big_sur:      "a41dd5c6f4cb10dfc5799188f49f0b7a74657f97e69bb2e2f89d39a6e5b25bd2"
    sha256 cellar: :any,                 catalina:     "24e6a538af7aa86b9af9934934acb2713e27af08d3b32356c15809e8caa51da3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0118c528c3e958c1eba1cdce7e22e0b0cdeca2fbf4032242a43388921f6118c3"
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
    inreplace "config/install-mod.py", /python$/, "python3"
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
