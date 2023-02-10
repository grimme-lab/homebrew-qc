class Dftd4 < Formula
  desc "Generally applicable, charge dependent London-dispersion correction"
  homepage "https://github.com/dftd4/dftd4"
  url "https://github.com/dftd4/dftd4/releases/download/v3.5.0/dftd4-3.5.0-source.tar.xz"
  sha256 "d2bab992b5ef999fd13fec8eb1da9e9e8d94b8727a2e624d176086197a00a46f"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/dftd4-3.4.0"
    sha256 cellar: :any, big_sur:      "c5accb72c42670fa6671864236c1856635fb7599e774721eafff918905a39dab"
    sha256 cellar: :any, catalina:     "47560d89590b1c213ccd792ef4f8350b9a6ac059cfbcc6f2ae2540227e951416"
    sha256               x86_64_linux: "27fbf43359e21692494e303be37ad3f6d47c22d0eaf5af9d7988542387425f6a"
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
