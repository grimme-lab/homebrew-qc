class TestDrive < Formula
  desc "Simple testing framework"
  homepage "https://github.com/fortran-lang/test-drive"
  url "https://github.com/fortran-lang/test-drive/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "f9c037a3c1727e98801c2375e6f2efde9881ac1f54b04be3bc928e094f5787a5"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/test-drive-0.4.0_1"
    sha256 cellar: :any,                 monterey:     "8e9c3b25991d02cd3bdd606024ea626cabee5de772f0bf2e4868923e060b2582"
    sha256 cellar: :any,                 big_sur:      "778fa8981f6b940a935586fcff4c8d29c0e9e1a2050de1f2fecfc42cbfcf9950"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6d68a7a6bad4992074c6779e54e918fc72971185b825e3ffb8d08fccc53d7a4d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :test
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
    system "pkg-config", "test-drive", "--modversion"
  end
end
