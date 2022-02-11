class SDftd3 < Formula
  desc "Simple reimplementation of DFT-D3"
  homepage "https://dftd3.readthedocs.io"
  url "https://github.com/awvwgk/simple-dftd3/archive/v0.5.1.tar.gz"
  sha256 "3d775608bf85cd389385a84ea5586ede57215ff9cff646480552ca835a9de9ca"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/awvwgk/homebrew-qc/releases/download/s-dftd3-0.5.1"
    sha256 cellar: :any,                 big_sur:      "7fdc38fe58af3269dfbd0add9759e2755281be0c6e18cba71cc26bf795810b66"
    sha256 cellar: :any,                 catalina:     "b44fb64695d91f10f256172fab6ca8accc4684f91b5fbddc3e0254df791e4973"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2a6eb6f8d67150dd5035255d838a6e7d8b8fc2b5c5838930b62f9552250e079c"
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
