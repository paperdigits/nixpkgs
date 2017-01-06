{ stdenv, fetchFromGitHub, pkgconfig, cmake, pixman, libpthreadstubs, gtkmm3, libXau
, libXdmcp, lcms2, libiptcdata, libcanberra_gtk3, fftw, expat, pcre, libsigcxx
}:

stdenv.mkDerivation rec {
  name = "rawtherapee-git-2017-01-04";

  src = fetchFromGitHub {
    owner = "Beep6581";
    repo = "RawTherapee";
    rev = "d8f5161ba5d27faa88674348049d193c8ff5485b";
    sha256 = "1zgixyryb6bpa419bg7fbnd857bzl23chpxhyl2xdh5rw9z4cv0s";
  };

  buildInputs = [ pkgconfig cmake pixman libpthreadstubs gtkmm3 libXau libXdmcp
    lcms2 libiptcdata libcanberra_gtk3 fftw expat pcre libsigcxx ];

  NIX_CFLAGS_COMPILE = "-std=gnu++11 -Wno-deprecated-declarations -Wno-unused-result";

  # Copy generated ReleaseInfo.cmake so we don't need git. File was
  # generated manually using `./tools/generateReleaseInfo` in the
  # source folder. Make sure to regenerate it when updating.
  preConfigure = ''
    cp ${./ReleaseInfo.cmake} ./ReleaseInfo.cmake
  '';

  enableParallelBuilding = true;

  meta = {
    description = "RAW converter and digital photo processing software";
    homepage = http://www.rawtherapee.com/;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ viric jcumming mahe the-kenny ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
