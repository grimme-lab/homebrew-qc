class Multicharge < Formula
  desc "Generally applicable, charge dependent London-dispersion correction"
  homepage "https://github.com/grimme-lab/multicharge"
  url "https://github.com/grimme-lab/multicharge/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "129ab0325663e9155b5d91c4364199cec5fc0cbecdfe047cc24a37aa2f7a50e0"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/multicharge-0.6.0"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "98eef5ae0dbdf9761182b03cd645ff1a4f7642517711bbee5ba5c27b9b54cec7"
    sha256 cellar: :any, arm64_sequoia: "ce25ccb22b7ac5a463a433de96a886463aa0c3073636d50d521dbf3d93329826"
    sha256 cellar: :any, x86_64_linux:  "cfca20e66393f887ded7fd9c7efb26a6d8d59836a4e248d4709db2f18d4b0bff"
  end

  depends_on "asciidoctor" => :build
  depends_on "meson" => :build
  depends_on "mstore" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
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
    system "meson", "setup", "_build", *meson_args
    system "meson", "compile", "-C", "_build"
    system "meson", "test", "-C", "_build", "--no-rebuild", "--num-processes", "1"
    system "meson", "install", "-C", "_build", "--no-rebuild"
  end

  test do
    system "#{bin}/multicharge", "--version"
  end
end
