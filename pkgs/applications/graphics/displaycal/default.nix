{ lib
, pkgs
#, buildPythonPackage
, fetchFromGitHub
#, python3
, dbus
, pkgconf
, glib
, gtk3
, libXxf86vm
, fetchpatch
, python3Packages
}:
with python3Packages;
buildPythonApplication rec {
  pname = "displaycal-py3";
  version = "3.9.10";

  src = fetchFromGitHub {
    owner = "eoyilmaz";
    repo = pname;
    rev = version;
    sha256 = "sha256-t/lj6Jw5B9jDqjvAPXPb1XDqNhZ0MWypKZvigxFIbIY=";
   };

  buildInputs = [ dbus pkgconf glib gtk3 libXxf86vm ];

  propagatedBuildInputs = [
    attrdict
    build
    certifi
    dbus-python
    distro
    numpy
    pillow
    PyChromecast
    send2trash
    wxPython_4_1
    zeroconf
  ];

  prePatch = ''
    substituteInPlace setup.py --replace 'calendar.timegm(time.strptime(lastmod, "%Y-%m-%dT%H:%M:%SZ"))' 'time.time()'
  '';

  preConfigure = ''
    mkdir dist
    cp {misc,dist}/net.displaycal.DisplayCAL.appdata.xml
    #touch dist/copyright
    #mkdir -p $out
    #ln -s $out/share/DisplayCAL $out/Resources

    # Dependencies not correctly detected; not sure if we need this?
    # sed -i \
    #   -e '/dbus-python/d' \
    #   setup.cfg requirements.txt
  '';

  # 2022-12-19 Don't need
  # pythonImportsCheck = [ "displaycal.py3" ];

  meta = with lib; {
    description = "DisplayCAL Modernization Project";
    homepage = "https://github.com/eoyilmaz/displaycal-py3";
    license = licenses.gpl3;
    maintainers = with maintainers; [ paperdigits ];
  };
}
