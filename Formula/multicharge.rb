class Multicharge < Formula
  desc "Generally applicable, charge dependent London-dispersion correction"
  homepage "https://github.com/grimme-lab/multicharge"
  url "https://github.com/grimme-lab/multicharge/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "2fcc1f80871f404f005e9db458ffaec95bb28a19516a0245278cd3175b63a6b2"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/multicharge-0.3.0"
    sha256 cellar: :any, arm64_sequoia: "734fe9a324427b17d51f6097ee5b29452a0b465c10a78ba069b7cb32e2c281f5"
    sha256 cellar: :any, arm64_sonoma:  "260cb8b1cd76c47f34d534d9d8f873b35d84e81f7d38bb30b541c103104210f7"
    sha256               x86_64_linux:  "8c1c8790e1b8cc703bcd2afdace20b1869e6dc009d0a797dcaa090c9f1078782"
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
