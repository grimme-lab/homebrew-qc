class TomlF < Formula
  desc "TOML parser implementation for data serialization and deserialization in Fortran"
  homepage "https://github.com/toml-f/toml-f"
  url "https://github.com/toml-f/toml-f/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "095814952e76283a689ea957aa5bd7fc748cbe24d4ffb3a34f4f564b792dd33c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/toml-f-0.5.2"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "9c4e7ada9df0bbd172b6f2e39a76944ae5ea9ead7919d510e46c94494ccc67e5"
    sha256 cellar: :any, arm64_sequoia: "1fcf4e3256a6e30909b9b68be340bad99b64e8ad26611126371a9645a17aae5f"
    sha256 cellar: :any, x86_64_linux:  "c9f4fc5c012b5db46c53e06efb6176d4bc7306b01fa55c5d6f5329991db6b139"
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
