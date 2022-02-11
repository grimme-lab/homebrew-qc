class MctcLib < Formula
  desc "Modular computation tool chain library"
  homepage "https://grimme-lab.github.io/mctc-lib"
  url "https://github.com/grimme-lab/mctc-lib/archive/v0.2.4.tar.gz"
  sha256 "ca728d129c4bb0a06ed37183e3a8e2659d5fbbec2278c3f6569fb638314129d1"
  license "Apache-2.0"

  depends_on "asciidoctor" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "gcc"
  fails_with gcc: "4"
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"
  fails_with :clang

  def install
    ENV.fortran
    meson_args = std_meson_args
    system "meson", "setup", "_build", *meson_args
    system "meson", "compile", "-C", "_build"
    system "meson", "test", "-C", "_build", "--no-rebuild", "--num-processes", "1"
    system "meson", "install", "-C", "_build", "--no-rebuild"
  end

  test do
    system "#{bin}/mctc-convert", "--version"
  end
end
