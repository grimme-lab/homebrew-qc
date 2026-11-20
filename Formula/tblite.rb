class Tblite < Formula
  desc "Light-weight tight-binding framework"
  homepage "https://github.com/tblite/tblite"
  url "https://github.com/tblite/tblite/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "987e7ac801e25d87590550f8f1bbcf8f9b560e1673d0bc40586c854084c97fa7"
  license "LGPL-3.0-or-later"

  depends_on "asciidoctor" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "dftd4"
  depends_on "gcc"
  depends_on "mctc-lib"
  depends_on "mstore"
  depends_on "multicharge"
  depends_on "openblas"
  depends_on "s-dftd3"
  depends_on "toml-f"
  fails_with gcc: "4"
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"
  fails_with :clang

  resource "ddx" do
    url "https://github.com/ddsolvation/ddX/archive/refs/tags/v1.0.2.tar.gz"
    sha256 "84e6197167f77990f9fb6eff5e7313283ecb2376aa7707b5e4bec4df33a18f0f"
  end

  def install
    (buildpath/"subprojects/ddx").install resource("ddx")
    # GCC 16 strips bind(C) module procedures omitted from public in private modules
    inreplace "src/tblite/api/calculator.f90",
              "public :: get_singlepoint_api",
              "public :: get_singlepoint_api, set_calculator_guess_api, get_calculator_shell_count\n" \
              "public :: get_calculator_shell_map, get_calculator_angular_momenta\n" \
              "public :: get_calculator_orbital_count, get_calculator_orbital_map"
    inreplace "src/tblite/api/container.f90",
              "public :: vp_container, delete_container_api",
              "public :: vp_container, delete_container_api, push_back_api\n" \
              "public :: new_electric_field_api, new_spin_polarization_api"
    inreplace "src/tblite/api/double_dictionary.f90",
              "public :: vp_double_dictionary",
              "public :: vp_double_dictionary, delete_post_processing_api"
    inreplace "src/tblite/api/error.f90",
              "public :: vp_error",
              "public :: vp_error, set_error_api"
    inreplace "src/tblite/api/result.f90",
              "public :: vp_result,",
              "public :: save_result_wavefunction_api, load_result_wavefunction_api\n" \
              "public :: vp_result,"
    ENV.fortran
    meson_args = std_meson_args
    meson_args << "--wrap-mode=nodownload"
    meson_args << "-Dlapack=openblas"
    meson_args << "-Dddx:tests=false"
    system "meson", "setup", "_build", *meson_args
    system "meson", "compile", "-C", "_build"
    system "meson", "test", "-C", "_build", "--no-rebuild", "--num-processes", "1"
    system "meson", "install", "-C", "_build", "--no-rebuild"
  end

  test do
    system "#{bin}/tblite", "--version"
  end
end
