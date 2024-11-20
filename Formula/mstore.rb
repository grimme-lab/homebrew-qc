class Mstore < Formula
  desc "Modular structure store for testing"
  homepage "https://github.com/grimme-lab/mstore"
  url "https://github.com/grimme-lab/mstore/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "56b3d778629eb74b8a515cd53c727d04609f858a07f8d3555fd5fd392a206dcc"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/mstore-0.3.0"
    sha256 cellar: :any,                 arm64_sequoia: "339fc420ea7eb4ae2168dd9457fdc11a6cd9d3ea3b9fbdb5b37b9064c0a5d2d9"
    sha256 cellar: :any,                 arm64_sonoma:  "a6d7eef98167025ef116becea0b6bf969e3059a7aca1e9b224a30b029f3f5d17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd33107a1caa02702e471691bb4cb5354c75cbf9f44a87be606ced9aadc02329"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gcc"
  depends_on "mctc-lib"
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
    system "meson", "install", "-C", "_build", "--no-rebuild"
  end

  test do
    system "#{bin}/mstore-info"
  end
end
