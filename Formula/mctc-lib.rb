class MctcLib < Formula
  desc "Modular computation tool chain library"
  homepage "https://grimme-lab.github.io/mctc-lib"
  url "https://github.com/grimme-lab/mctc-lib/archive/v0.3.0.tar.gz"
  sha256 "a697516bae03573e9ee43b8b72160584b35cc902e8f35c6024260241b154ec47"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/mctc-lib-0.3.0"
    sha256 cellar: :any,                 big_sur:      "d80cbf1cfbc150af5c0daa07b15537cc7b24e9037c501dcd345b1c548ef3ea36"
    sha256 cellar: :any,                 catalina:     "3d95cdc6a8932a9881ed20d5ced234c824cee07a38edf9e2b344fe1ee80a0d20"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e29656c0b79f0f612ec7464572747da444a8d5ca968d9cbf19e1be5909ae2e50"
  end

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
