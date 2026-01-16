#!/usr/bin/env bash

set -ex

# # Avoid long shebangs and force build python + build g-ir-scanner
# echo '#!/usr/bin/env bash' > g-ir-scanner
# echo "${BUILD_PREFIX}/bin/python ${BUILD_PREFIX}/bin/g-ir-scanner \"\$@\"" >> g-ir-scanner
# chmod +x ./g-ir-scanner
# export PATH="${PWD}:${PATH}"

# Force build tools first (meson will pick g-ir-scanner from PATH)
export PATH="${BUILD_PREFIX}/bin:${PATH}"
cat > g-ir-scanner <<'EOF'
#!/usr/bin/env bash
exec "${BUILD_PREFIX}/bin/python" "${BUILD_PREFIX}/bin/g-ir-scanner" "$@"
EOF
chmod +x g-ir-scanner
export PATH="${PWD}:${PATH}"

meson setup builddir --prefix="$PREFIX" --libdir=lib -Ddocs=false
meson configure builddir
ninja -v -C builddir
ninja -C builddir install

cd $PREFIX
find . -type f -name "*.la" -exec rm -rf '{}' \; -print
