class Multicharge < Formula
  desc "Generally applicable, charge dependent London-dispersion correction"
  homepage "https://github.com/grimme-lab/multicharge"
  url "https://github.com/grimme-lab/multicharge/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "2fcc1f80871f404f005e9db458ffaec95bb28a19516a0245278cd3175b63a6b2"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/multicharge-0.2.0_1"
    sha256 cellar: :any, monterey:     "f7f107024178eef05bf839735e4a77004ef9a4de549241ba5ecc1c0470047006"
    sha256 cellar: :any, big_sur:      "ff8fb2db6a37c8561dbdac6c5289eab39f92885f1b803771b61aec5dd98c48ed"
    sha256               x86_64_linux: "56257fef8886115759749bff74792e1c528d728f6183e3acd45ee2d8ec3e8d45"
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
