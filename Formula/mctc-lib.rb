class MctcLib < Formula
  desc "Modular computation tool chain library"
  homepage "https://grimme-lab.github.io/mctc-lib"
  url "https://github.com/grimme-lab/mctc-lib/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "b18b06f80e6274b353dd091c12b3a83217033ce0bd80471b54cf486cc60c0251"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/mctc-lib-0.3.2"
    sha256 cellar: :any,                 arm64_sonoma: "44eb06c6225a036c16dc0ed4a889253fc2a7fcf5c4e354c8c15ccb856208d912"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "95a387a54084e644dadebb0dbfb5408abc0f720102dcec95beb960f1a78cd05f"
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
