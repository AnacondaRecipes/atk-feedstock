setlocal EnableDelayedExpansion
@echo on

set "MESON=%BUILD_PREFIX%\Scripts\meson.exe"
if not exist "%MESON%" (
  set "MESON=%BUILD_PREFIX%\python.exe %BUILD_PREFIX%\Scripts\meson-script.py"
)

:: set pkg-config path so that host deps can be found
:: (set as env var so it's used by both meson and during build with g-ir-scanner)
set "PKG_CONFIG_PATH=%LIBRARY_LIB%\pkgconfig;%LIBRARY_PREFIX%\share\pkgconfig"

:: get mixed path (forward slash) form of prefix so host prefix replacement works
set "LIBRARY_PREFIX_M=%LIBRARY_PREFIX:\=/%"

:: meson options
:: (set pkg_config_path so deps in host env can be found)
set ^"MESON_OPTIONS=^
  --prefix="%LIBRARY_PREFIX_M%" ^
  --libdir=lib ^
  --wrap-mode=nofallback ^
  --buildtype=release ^
  --backend=ninja ^
  -Ddocs=false ^
 ^"

%MESON% setup builddir !MESON_OPTIONS!
if errorlevel 1 exit 1

%MESON% configure builddir
if errorlevel 1 exit 1

ninja -v -C builddir -j %CPU_COUNT%
if errorlevel 1 exit 1

ninja -C builddir install -j %CPU_COUNT%
if errorlevel 1 exit 1
