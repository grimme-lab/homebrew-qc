class Gcp < Formula
  desc "Geometrical Counter-Poise correction"
  homepage "https://github.com/grimme-lab/gcp"
  url "https://github.com/grimme-lab/gcp/archive/v2.3.1.tar.gz"
  sha256 "26c4d889062412c377459a4a939cbe12527dcdc5d89c99cf607f589ec86c5fe4"
  license "LGPL-3.0-or-later"
  revision 1

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/gcp-2.3.1_1"
    sha256 cellar: :any,                 monterey:     "3fe4c8596c27a8bdc885a393f35c327936d6c4d826dede8ba58de19e74c617f3"
    sha256 cellar: :any,                 big_sur:      "04bb8a91ee9a45f812ab1f9cc55f274099ced52e5dad0621f497b1737c2acb73"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3f95bdc18bbfca051d337023a549ec3c1e1da3bf7a63bd8a6e041afcaf7d715b"
  end

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
