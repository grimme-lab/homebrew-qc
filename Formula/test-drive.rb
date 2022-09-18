class TestDrive < Formula
  desc "Simple testing framework"
  homepage "https://github.com/fortran-lang/test-drive"
  url "https://github.com/fortran-lang/test-drive/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "f9c037a3c1727e98801c2375e6f2efde9881ac1f54b04be3bc928e094f5787a5"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/test-drive-0.4.0"
    sha256 cellar: :any,                 big_sur:      "4a3bc8175b1107fdfd8b6e77effb413333e853e69d5d1f98e258b69aa9d73773"
    sha256 cellar: :any,                 catalina:     "cbc920050e2a7f7acc2f8532349b31d1d9f76a58bad5fe5476f4ae679146ba4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "95ce8120d56b56ebb386207883fbb59f717d212c19fd4770a88e2650cb808e46"
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
