class TestDrive < Formula
  desc "Simple testing framework"
  homepage "https://github.com/fortran-lang/test-drive"
  url "https://github.com/fortran-lang/test-drive/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "e7d99209de0d1c4faebf3be64303a3adf2940c07cf86d47858c4032c5d38dfc2"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/test-drive-0.5.0"
    sha256 cellar: :any,                 arm64_sequoia: "fe877225d7f3fd6bb714975562b94f39b37ba4f12e616c6a6647cc61cad4dec4"
    sha256 cellar: :any,                 arm64_sonoma:  "2e5aa83778b0c5b5b3a985ff872b6545a0e9d6e2b38d675ddbf334df7fc82bb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7205de1f685065271e8beb8772b660c25b71241ffa4b1e52f24b963f2a54a25c"
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
