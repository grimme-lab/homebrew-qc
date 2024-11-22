class Crest < Formula
  desc "Conformer-Rotamer Ensemble Sampling Tool"
  homepage "https://xtb-docs.readthedocs.io/en/latest/crest.html"
  url "https://github.com/crest-lab/crest/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "f5d00d41c18a6f999ec8c890aa56d4b7ac8b1bf52a8c6d48c1d151c0126f7793"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/crest-2.12_1"
    sha256 cellar: :any, monterey:     "120d2eb2f22e0e231132501ad1080540ea1283ace3509595ed4cae6f33087a8b"
    sha256 cellar: :any, big_sur:      "482bbce8acb7881987332d84443c47d300c633157ed6d0b1586d9b02661cf6c4"
    sha256               x86_64_linux: "d53845fc5bd3a67c07a0afd881f55f02bc4acfef36e1d65bdd618147ec2078a0"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gcc"
  depends_on "openblas"
  depends_on "tblite"
  depends_on "test-drive"
  depends_on "xtb"
  fails_with gcc: "4"
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"
  fails_with :clang

  def install
    ENV.fortran
    system "cmake", "-B", "_build", "-GNinja", *std_cmake_args
    system "ninja", "-C", "_build"
    system "ctest", "-C", "_build", "--output-on-failure", "--parallel", "1", "-R", "'^crest/'"
    system "ninja", "-C", "_build", "install"
  end

  test do
    system "#{bin}/crest", "--version"
  end
end
