class Dftd4 < Formula
  desc "Generally applicable, charge dependent London-dispersion correction"
  homepage "https://github.com/dftd4/dftd4"
  url "https://github.com/dftd4/dftd4/releases/download/v3.5.0/dftd4-3.5.0-source.tar.xz"
  sha256 "d2bab992b5ef999fd13fec8eb1da9e9e8d94b8727a2e624d176086197a00a46f"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/dftd4-3.5.0"
    sha256 cellar: :any, monterey:     "abf8959d58e34cff739575dc7de872dd0aae6c7633fb44932926be87f0b07ccd"
    sha256 cellar: :any, big_sur:      "6055a827bc3f53d5e1bef61b6de276056084fc463341f70f9648c6599e447767"
    sha256               x86_64_linux: "7287a9a236c3c08bcb285c47a6853479141c17aabe69b35d5877baf6c388b342"
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
