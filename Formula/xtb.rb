class Xtb < Formula
  desc "Semiemprical extended tight-binding program package"
  homepage "https://xtb-docs.readthedocs.io"
  url "https://github.com/grimme-lab/xtb/archive/refs/tags/v6.8.0.tar.gz"
  sha256 "73e3dc7d88b58309f35e7f3eab069cc3999a4211acd2ed98d768ffbd41c5acdf"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/grimme-lab/homebrew-qc/releases/download/xtb-6.7.1"
    sha256 cellar: :any, arm64_sequoia: "3243e26843ae694403a854ef99cc943f860accef0cca462e6c6d59aa8fd604d6"
    sha256 cellar: :any, arm64_sonoma:  "d24e721b4a050b4fd9fac457b73fade4e73ec2f6096fd23ce142615e42239ac9"
    sha256               x86_64_linux:  "4968a42446f47241731f337f89333d4c7ac3760c6c7109e4ea575b069ab4e816"
  end

  depends_on "asciidoctor" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "test-drive" => :build
  depends_on "dftd4"
  depends_on "gcc"
  depends_on "mctc-lib"
  depends_on "multicharge"
  depends_on "openblas"
  depends_on "tblite"
  fails_with gcc: "4"
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"
  fails_with :clang

  def install
    ENV.fortran
    meson_args = std_meson_args
    meson_args << "-Dlapack=openblas"
    meson_args << "-Dtblite=enabled"
    # meson_args << "-Dbuild_name=homebrew"
    # meson_args << "-Dxtb:fortran_link_args=-Wl,-stack_size,0x1000000" if OS.mac?
    system "meson", "setup", "_build", *meson_args
    system "meson", "compile", "-C", "_build"
    system "meson", "test", "-C", "_build", "--no-rebuild", "--num-processes", "1"
    system "meson", "install", "-C", "_build", "--no-rebuild"
  end

  test do
    system "#{bin}/xtb", "--version"

    (testpath/"water.xyz").write <<~EOS
      3

      O  0.000000  0.000000  0.119262
      H  0.000000  0.763239 -0.477047
      H  0.000000 -0.763239 -0.477047
    EOS

    energy_pattern = /\|\s*TOTAL ENERGY\s+([-+]?\d+\.\d+)\s+Eh\s*\|/

    native_output = shell_output("#{bin}/xtb #{testpath}/water.xyz --gfn 2 --norestart")
    native_match = native_output.match(energy_pattern)
    assert native_match, "Failed to extract total energy from native xtb output"
    native_energy = Float(native_match[1])
    assert_predicate native_energy, :finite?

    tblite_output = shell_output("#{bin}/xtb #{testpath}/water.xyz --gfn 2 --tblite --norestart")
    tblite_match = tblite_output.match(energy_pattern)
    assert tblite_match, "Failed to extract total energy from xtb --tblite output"
    tblite_energy = Float(tblite_match[1])
    assert_predicate tblite_energy, :finite?

    assert_in_delta native_energy, tblite_energy, 1e-7
  end
end
