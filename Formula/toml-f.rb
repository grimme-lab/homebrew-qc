class TomlF < Formula
  desc "TOML parser implementation for data serialization and deserialization in Fortran"
  homepage "https://toml-f.readthedocs.io"
  url "https://github.com/toml-f/toml-f/releases/download/v0.3.1/toml-f-0.3.1.tar.xz"
  sha256 "7f40f60c8d9ffbb1b99fb051a3e6682c7dd04d7479aa1cf770eff8174b02544f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/toml-f-0.3.1"
    sha256 cellar: :any,                 monterey:     "b08b1e9cae3a7dce27ebedcc343b9c60ff03cd49bfca2ca419670d8cb98980d2"
    sha256 cellar: :any,                 big_sur:      "50385634653e12d9d36a7943ecdbe2465258710b37aa97bb2375610e92c9bf1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "53c47daed9db4abe0da84c2d86550b0f8b2a674c9d8519b30e3068de82c723c7"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "test-drive" => :build
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
    system "pkg-config", "toml-f", "--modversion"
  end
end
