class Gcp < Formula
  desc "Geometrical Counter-Poise correction"
  homepage "https://github.com/grimme-lab/gcp"
  url "https://github.com/grimme-lab/gcp/archive/v2.3.1.tar.gz"
  sha256 "26c4d889062412c377459a4a939cbe12527dcdc5d89c99cf607f589ec86c5fe4"
  license "LGPL-3.0-or-later"
  revision 1

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/gcp-2.3.1"
    sha256 cellar: :any,                 big_sur:      "a210873f06bbb1a9a701e16b214993fdcc41fc9cc4c0931b85d33ae512bb72ac"
    sha256 cellar: :any,                 catalina:     "915e2cf9bbc5750dcf9d8739367871679d269323a1b5d45e88791209892f01dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b73ce843f26627d051745f62f95da6b521b580f4ec1ec68c5581814629795656"
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
