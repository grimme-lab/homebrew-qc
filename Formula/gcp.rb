class Gcp < Formula
  desc "Geometrical Counter-Poise correction"
  homepage "https://github.com/grimme-lab/gcp"
  url "https://github.com/grimme-lab/gcp/archive/v2.3.1.tar.gz"
  sha256 "26c4d889062412c377459a4a939cbe12527dcdc5d89c99cf607f589ec86c5fe4"
  license "LGPL-3.0-or-later"

  depends_on "asciidoctor" => :build
  depends_on "meson" => :build
  depends_on "mstore" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gcc"
  depends_on "mctc-lib"
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
    system "#{bin}/mctc-gcp", "--version"
  end
end
