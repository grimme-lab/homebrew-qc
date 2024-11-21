class Gcp < Formula
  desc "Geometrical Counter-Poise correction"
  homepage "https://github.com/grimme-lab/gcp"
  url "https://github.com/grimme-lab/gcp/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "f8bb203c5af57e942c3f02967d1970b2fdcfcd2bb8fc60b999c8b4226324a730"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/gcp-2.3.2"
    sha256 cellar: :any,                 arm64_sequoia: "50e5f9313afa454f8a6dd412c69c6b99af52003a86431fa9b8e297670573a18d"
    sha256 cellar: :any,                 arm64_sonoma:  "b40b2372baf44080a86309a542de89500d8e4fe33adc738ba84ea819665e3df5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ba888ab45050d3d007c61279a251329ade25c9caa1b6a702a4e02484e9a82bb"
  end

  depends_on "asciidoctor" => :build
  depends_on "meson" => :build
  depends_on "mstore" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gcc"
  depends_on "mctc-lib"
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
    ### reintroduce as soon as issue (https://github.com/grimme-lab/gcp/issues/26) is resolved ###
    # system "meson", "test", "-C", "_build", "--no-rebuild", "--num-processes", "1"
    system "meson", "install", "-C", "_build", "--no-rebuild"
  end

  test do
    system "#{bin}/mctc-gcp", "--version"
  end
end
