class TestDrive < Formula
  desc "Simple testing framework"
  homepage "https://github.com/fortran-lang/test-drive"
  url "https://github.com/fortran-lang/test-drive/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "33c486fac95fabf8050757b92f552d816aabb46dc820a8d25dde6676eb5eb626"
  license any_of: ["Apache-2.0", "MIT"]

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
