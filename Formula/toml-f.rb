class TomlF < Formula
  desc "TOML parser implementation for data serialization and deserialization in Fortran"
  homepage "https://toml-f.github.io/toml-f"
  url "https://github.com/toml-f/toml-f/archive/v0.2.2.tar.gz"
  sha256 "c3e5e1f57de00977b5e41d3a857ddb7e6b41f0b9116ed608cf89f295d9ef24c6"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/toml-f-0.2.2"
    sha256 cellar: :any,                 big_sur:      "b8a0e56bcc31d153880d1c16732f9a670d27abd2e976086f0ffb39f941ff4341"
    sha256 cellar: :any,                 catalina:     "81b128c1b3d81af0a9568ab40b4f352f379ae04df02597fa1e9851a93e2e666d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a801393ee4a9e6f45bf80f93dab497527114c88e89d3943183b29cee35955df3"
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
    inreplace "config/install-mod.py", /python$/, "python3"
    meson_args = std_meson_args
    system "meson", "setup", "_build", *meson_args
    system "meson", "compile", "-C", "_build"
    selected_tests = ["version", "fpm", "tftest", "example-1.1", "example-2.2", "decoder"]
    system "meson", "test", "-C", "_build", "--no-rebuild", "--num-processes", "1", *selected_tests
    system "meson", "install", "-C", "_build", "--no-rebuild"
  end

  test do
    system "pkg-config", "toml-f", "--modversion"
  end
end
