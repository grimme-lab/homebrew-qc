class Crest < Formula
  desc "Conformer-Rotamer Ensemble Sampling Tool"
  homepage "https://xtb-docs.readthedocs.io/en/latest/crest.html"
  url "https://github.com/grimme-lab/crest/archive/refs/tags/v2.12.tar.gz"
  sha256 "390f0ac0aedafbd6bb75974fcffefe7e0232ad6c4ea0ab4f1a77e656a3ce263d"
  license "LGPL-3.0-or-later"
  revision 1

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/crest-2.12_1"
    sha256 cellar: :any, monterey:     "120d2eb2f22e0e231132501ad1080540ea1283ace3509595ed4cae6f33087a8b"
    sha256 cellar: :any, big_sur:      "482bbce8acb7881987332d84443c47d300c633157ed6d0b1586d9b02661cf6c4"
    sha256               x86_64_linux: "d53845fc5bd3a67c07a0afd881f55f02bc4acfef36e1d65bdd618147ec2078a0"
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
