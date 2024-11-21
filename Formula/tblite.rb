class Tblite < Formula
  desc "Light-weight tight-binding framework"
  homepage "https://github.com/tblite/tblite"
  url "https://github.com/tblite/tblite/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "c4a67dfbe04827095fd7598183e076fa3017a5a475c4f90fd28e78992dc19ea7"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/tblite-0.4.0"
    sha256 cellar: :any, arm64_sequoia: "939d9365457d04e24aa7d430a46a19e15ab3b7d8e22c716912d2850e4ff838fa"
    sha256 cellar: :any, arm64_sonoma:  "e0d0799e99971d7c1ab9eebee5b25427b9c10bec16712e394605b8df5b7cf54b"
    sha256               x86_64_linux:  "ae72d3575f5d5798a6e9e9196abf47cf55203e9f715fc0b3c33407d4ba4b2c63"
  end

  depends_on "asciidoctor" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "dftd4"
  depends_on "gcc"
  depends_on "mctc-lib"
  depends_on "mstore"
  depends_on "multicharge"
  depends_on "openblas"
  depends_on "s-dftd3"
  depends_on "toml-f"
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
    system "#{bin}/tblite", "--version"
  end
end
