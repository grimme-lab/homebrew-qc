class TomlF < Formula
  desc "TOML parser implementation for data serialization and deserialization in Fortran"
  homepage "https://github.com/toml-f/toml-f"
  url "https://github.com/toml-f/toml-f/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "e66d0e355a8a2e65fd5fc7cd4f00078dfbdbf1b3cc47b60f028c19467df4c337"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/toml-f-0.4.2"
    sha256 cellar: :any,                 arm64_sequoia: "ff3739e7d86f3baafd8031cfcb09f6f2cf2e1e907323e761a5d3c8b13612ccaf"
    sha256 cellar: :any,                 arm64_sonoma:  "c7606206ef78667fa1833ccb002f4f8212fa8a1d8649e727b02110a0d7f7369c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "747760e5e1f94ebab2e8c1ba8e17c6a8fbfff908a1ca6c4dd6117e9fcfa476bd"
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
    ### reintroduce as soon as issue (https://github.com/toml-f/toml-f/issues/152) is resolved ###
    # system "meson", "test", "-C", "_build", "--no-rebuild", "--num-processes", "1"
    system "meson", "install", "-C", "_build", "--no-rebuild"
  end

  test do
    system "pkg-config", "toml-f", "--modversion"
  end
end
