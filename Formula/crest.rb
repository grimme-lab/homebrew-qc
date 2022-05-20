class Crest < Formula
  desc "Conformer-Rotamer Ensemble Sampling Tool"
  homepage "https://xtb-docs.readthedocs.io/en/latest/crest.html"
  url "https://github.com/grimme-lab/crest/archive/refs/tags/v2.12.tar.gz"
  sha256 "390f0ac0aedafbd6bb75974fcffefe7e0232ad6c4ea0ab4f1a77e656a3ce263d"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/crest-2.11.2"
    sha256 cellar: :any, big_sur:      "6cf5f1c8c4e0cbef60d39d80782ba68fa52d7e0ef7028c1016660df3c2c6d562"
    sha256 cellar: :any, catalina:     "e4bd7e7883969b275ebc034738e979f58f817a538e07b0db2a206fae9511815e"
    sha256               x86_64_linux: "ad443630938783c90a35b02e4cb1550e2e00c2529804ee5d7bacc8a26d96710e"
  end

  depends_on "asciidoctor" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gcc"
  depends_on "openblas"
  depends_on "xtb"
  fails_with gcc: "4"
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"
  fails_with :clang

  def install
    ENV.fortran
    meson_args = std_meson_args
    meson_args << "-Dla_backend=openblas"
    meson_args << "-Dfortran_args=-ffree-line-length-none"
    meson_args << "-Dfortran_link_args=-Wl,-stack_size,0x1000000" if OS.mac?
    system "meson", "setup", "_build", *meson_args
    system "meson", "compile", "-C", "_build"
    system "meson", "install", "-C", "_build", "--no-rebuild"
  end

  test do
    system "#{bin}/crest", "--version"
  end
end
