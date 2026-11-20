class Dftd4 < Formula
  desc "Generally applicable, charge dependent London-dispersion correction"
  homepage "https://github.com/dftd4/dftd4"
  url "https://github.com/dftd4/dftd4/archive/refs/tags/v4.3.1.tar.gz"
  sha256 "01651dd3df06f0875ed4e710ee82f7dcb621edb262d6d22068dea818b915f5da"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/dftd4-4.3.1"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "1a4c6591b7ec874567425f4a63414dd9c8f1982622ccf63af52b0f29b297be11"
    sha256 cellar: :any, arm64_sequoia: "5d23434412574881a7cb04e61ec376ea62a12bd946001784aa4bc69fc69fd53e"
    sha256 cellar: :any, x86_64_linux:  "7227c5449a119727b202d87acff16f62eb57c4f34a69027551e8ed9226f50c8e"
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
