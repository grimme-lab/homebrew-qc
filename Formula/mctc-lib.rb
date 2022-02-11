class MctcLib < Formula
  desc "Modular computation tool chain library"
  homepage "https://grimme-lab.github.io/mctc-lib"
  url "https://github.com/grimme-lab/mctc-lib/archive/v0.2.4.tar.gz"
  sha256 "ca728d129c4bb0a06ed37183e3a8e2659d5fbbec2278c3f6569fb638314129d1"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/awvwgk/homebrew-qc/releases/download/mctc-lib-0.2.4"
    sha256 cellar: :any,                 big_sur:      "7831fa1494e7cbf3bc3cc6f8029d9128e05ff32f256ee11ea8829ffe20e62d0c"
    sha256 cellar: :any,                 catalina:     "0bba6fbe2d29266addd4c6b74365dc0c9a2cd13774ed3d791b71f544bae24cfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4f04e14f85d280328eb60014064c00f749b7a85ede8faf2632d64e3922f5f02c"
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
