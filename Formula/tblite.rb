class Tblite < Formula
  desc "Light-weight tight-binding framework"
  homepage "https://github.com/tblite/tblite"
  url "https://github.com/tblite/tblite/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "987e7ac801e25d87590550f8f1bbcf8f9b560e1673d0bc40586c854084c97fa7"
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

  resource "ddx" do
    url "https://github.com/ddsolvation/ddX/archive/refs/tags/v1.0.2.tar.gz"
    sha256 "84e6197167f77990f9fb6eff5e7313283ecb2376aa7707b5e4bec4df33a18f0f"
  end

  def install
    (buildpath/"subprojects/ddx").install resource("ddx")
    ENV.fortran
    meson_args = std_meson_args
    meson_args << "--wrap-mode=nodownload"
    meson_args << "-Dlapack=openblas"
    meson_args << "-Dddx:tests=false"
    system "meson", "setup", "_build", *meson_args
    system "meson", "compile", "-C", "_build"
    system "meson", "test", "-C", "_build", "--no-rebuild", "--num-processes", "1"
    system "meson", "install", "-C", "_build", "--no-rebuild"
  end

  test do
    system "#{bin}/tblite", "--version"
  end
end
