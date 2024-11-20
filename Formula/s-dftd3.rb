class SDftd3 < Formula
  desc "Simple reimplementation of DFT-D3"
  homepage "https://dftd3.readthedocs.io"
  url "https://github.com/dftd3/simple-dftd3/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "3a12c04c490badc63054aca18ea7670d416fcc2152cfe9b8af220da57c39f942"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/s-dftd3-1.2.1"
    sha256 cellar: :any,                 arm64_sequoia: "7a32659620cf82a994943e6932743b4a6ac5f49750cb68da2cc7b09bb7f1fa22"
    sha256 cellar: :any,                 arm64_sonoma:  "ec3586ae0baa2d85045c73d59a2ee87841dbee56b9af74b0174b3fe996a5c7b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b75c16e73ca9de3512ff66c8140d2265791375f7fea5586e26d338d619745540"
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
