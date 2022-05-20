class Crest < Formula
  desc "Conformer-Rotamer Ensemble Sampling Tool"
  homepage "https://xtb-docs.readthedocs.io/en/latest/crest.html"
  url "https://github.com/grimme-lab/crest/archive/refs/tags/v2.12.tar.gz"
  sha256 "390f0ac0aedafbd6bb75974fcffefe7e0232ad6c4ea0ab4f1a77e656a3ce263d"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/crest-2.12"
    sha256 cellar: :any, big_sur:      "ce91a18333211489c2747921542760520eb2a9e3d47fbd2c1533d38271f3a1c9"
    sha256 cellar: :any, catalina:     "f1734306faed4757c437fbc2dec363f7842cfd76031c1d32b7609f3327a01f4e"
    sha256               x86_64_linux: "14981799b9da38bd1332e68ba4dd891c5e492d14f5d4465e7e1936928d185746"
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
