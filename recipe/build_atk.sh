#!/usr/bin/env bash

set -ex

# Replace host g-ir-scanner with wrapper that runs build scanner with build python
mv -v "${PREFIX}/bin/g-ir-scanner" "${PREFIX}/bin/g-ir-scanner.real"

cat > "${PREFIX}/bin/g-ir-scanner" <<EOF
#!/usr/bin/env bash
exec "${BUILD_PREFIX}/bin/python" "${BUILD_PREFIX}/bin/g-ir-scanner" "\$@"
EOF
chmod +x "${PREFIX}/bin/g-ir-scanner"

meson setup builddir --prefix="$PREFIX" --libdir=lib -Ddocs=false
meson configure builddir
ninja -v -C builddir
ninja -C builddir install

cd $PREFIX
find . -type f -name "*.la" -exec rm -rf '{}' \; -print
