class TomlF < Formula
  desc "TOML parser implementation for data serialization and deserialization in Fortran"
  homepage "https://toml-f.github.io/toml-f"
  url "https://github.com/toml-f/toml-f/archive/v0.2.2.tar.gz"
  sha256 "c3e5e1f57de00977b5e41d3a857ddb7e6b41f0b9116ed608cf89f295d9ef24c6"
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
    system "pkg-config", "toml-f", "--modversion"
  end
end
