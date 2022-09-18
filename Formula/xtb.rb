class Xtb < Formula
  desc "Semiemprical extended tight-binding program package"
  homepage "https://xtb-docs.readthedocs.io"
  url "https://github.com/grimme-lab/xtb/releases/download/v6.5.1/xtb-6.5.1-source.tar.xz"
  sha256 "0922205cc224fe79e28f3d75be4e10c03efa8f3f666aedec8346fed82b272cad"
  license "LGPL-3.0-or-later"
  revision 1

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/xtb-6.5.1"
    sha256 cellar: :any, big_sur:      "5abcecee164402e7e4e793d47e14a2fbbd1af6f3c7ffcf0f32ff479eb5c3c882"
    sha256 cellar: :any, catalina:     "28e729e79e71b30f417da4b6ff5586fd68e5c54f36bd61e7cb6aeda0e25f74ee"
    sha256               x86_64_linux: "2d3ed43fbcb6644d4897101c6c9cf628ef41619b5dffba78e1cdfbaf4e3dc4af"
  end

  depends_on "asciidoctor" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "test-drive" => :build
  depends_on "gcc"
  depends_on "mctc-lib"
  depends_on "openblas"
  fails_with gcc: "4"
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"
  fails_with :clang

  def install
    ENV.fortran
    meson_args = std_meson_args
    meson_args << "-Dla_backend=openblas"
    meson_args << "-Dbuild_name=homebrew"
    meson_args << "-Dfortran_link_args=-Wl,-stack_size,0x1000000" if OS.mac?
    system "meson", "setup", "_build", *meson_args
    system "meson", "compile", "-C", "_build"
    system "meson", "test", "-C", "_build", "--no-rebuild", "--num-processes", "1"
    system "meson", "install", "-C", "_build", "--no-rebuild"
  end

  test do
    system "#{bin}/xtb", "--version"
  end
end
