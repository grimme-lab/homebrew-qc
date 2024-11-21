class Dftd4 < Formula
  desc "Generally applicable, charge dependent London-dispersion correction"
  homepage "https://github.com/dftd4/dftd4"
  url "https://github.com/dftd4/dftd4/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "f00b244759eff2c4f54b80a40673440ce951b6ddfa5eee1f46124297e056f69c"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/dftd4-3.7.0"
    sha256 cellar: :any, arm64_sequoia: "0c7f4e737a87a3158ecefcbe9cd4002d9f50903c3617fed3415e67e3ad45b5f2"
    sha256 cellar: :any, arm64_sonoma:  "0522dda0078770e0f337cf683655af88d03b73a8da3bf9d677191c96a452c5cf"
    sha256               x86_64_linux:  "635c04978955b6308bf7757d4da46d324baa7b7ed8cfa2711265928fcebd23ca"
  end

  depends_on "asciidoctor" => :build
  depends_on "meson" => :build
  depends_on "mstore" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gcc"
  depends_on "mctc-lib"
  depends_on "multicharge"
  depends_on "openblas"
  fails_with gcc: "4"
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"
  fails_with :clang

  def install
    ENV.fortran
    meson_args = std_meson_args
    meson_args << "-Dlapack=openblas"
    system "meson", "setup", "_build", *meson_args
    system "meson", "compile", "-C", "_build"
    system "meson", "test", "-C", "_build", "--no-rebuild", "--num-processes", "1"
    system "meson", "install", "-C", "_build", "--no-rebuild"
  end

  test do
    system "#{bin}/dftd4", "--version"
  end
end
