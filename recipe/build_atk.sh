#!/usr/bin/env bash

set -ex

#We must avoid very long shebangs here.
echo '#!/usr/bin/env bash' > g-ir-scanner
echo "${PREFIX}/bin/python ${PREFIX}/bin/g-ir-scanner \$*" >> g-ir-scanner
chmod +x ./g-ir-scanner
export PATH=${PWD}:${PATH}

meson builddir --prefix=$PREFIX --libdir=$PREFIX/lib
meson configure -Ddocs=false builddir
ninja -v -C builddir
ninja -C builddir install

cd $PREFIX
find . -type f -name "*.la" -exec rm -rf '{}' \; -print
