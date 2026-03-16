#!/usr/bin/env bash
set -euo pipefail

# Publish pipeline for the god-mode pilot app into the self-hosted F-Droid repo.
#
# Usage:
#   tooling/fdroid/publish-god-mode.sh
#
# Expected local layout:
#   ~/GitProjects/MC_AndroidApp
#   ~/GitProjects/MC_AndroidApp_FDroid

ROOT="$HOME/GitProjects/MC_AndroidApp"
APP_DIR="$ROOT/god-mode"
FDROID_DIR="$HOME/GitProjects/MC_AndroidApp_FDroid"
APK_UNSIGNED="$APP_DIR/app/build/outputs/apk/release/app-release-unsigned.apk"
OUTPUT_JSON="$APP_DIR/app/build/outputs/apk/release/output-metadata.json"
FDROID_APK="$FDROID_DIR/repo/com.marxs.androidgodmode_9.apk"
APP_KEYSTORE="$FDROID_DIR/.local/keys/god-mode-release.keystore"
APP_ALIAS="god-mode-release"
APP_PASS="godmode-release-pass"
REPO_PASS="fdroid-repo-pass"
JAVA_HOME_DEFAULT="/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"
ANDROID_HOME_DEFAULT="$HOME/Library/Android/sdk"
APKSIGNER_DEFAULT="$ANDROID_HOME_DEFAULT/build-tools/34.0.0/apksigner"
FDROID_BIN_DEFAULT="$HOME/Library/Python/3.9/bin/fdroid"
PAGES_REPO_URL="https://github.com/mmmmmmarcus/MC_AndroidApp_FDroid"
PAGES_FEED_URL="https://mmmmmmarcus.github.io/MC_AndroidApp_FDroid/repo"
PACKAGE_NAME="com.marxs.androidgodmode"

export JAVA_HOME="${JAVA_HOME:-$JAVA_HOME_DEFAULT}"
export ANDROID_HOME="${ANDROID_HOME:-$ANDROID_HOME_DEFAULT}"
export PATH="$JAVA_HOME/bin:$HOME/Library/Python/3.9/bin:$PATH"
APKSIGNER="${APKSIGNER:-$APKSIGNER_DEFAULT}"
FDROID_BIN="${FDROID_BIN:-$FDROID_BIN_DEFAULT}"
export FDROID_KEY_STORE_PASS="${FDROID_KEY_STORE_PASS:-$REPO_PASS}"
export FDROID_KEY_PASS="${FDROID_KEY_PASS:-$REPO_PASS}"

require() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing required command: $1" >&2
    exit 1
  }
}

require git
require python3
require "$FDROID_BIN"
require "$APKSIGNER"

if [ ! -d "$APP_DIR" ] || [ ! -d "$FDROID_DIR" ]; then
  echo "Expected repos not found under ~/GitProjects" >&2
  exit 1
fi

if [ ! -f "$APP_KEYSTORE" ]; then
  echo "Missing app signing keystore: $APP_KEYSTORE" >&2
  exit 1
fi

echo "==> Building god-mode release APK"
cd "$APP_DIR"
cat > local.properties <<EOF
sdk.dir=$ANDROID_HOME
EOF
./gradlew assembleRelease

if [ ! -f "$OUTPUT_JSON" ]; then
  echo "Missing output metadata: $OUTPUT_JSON" >&2
  exit 1
fi

VERSION_CODE=$(python3 - <<'PY'
import json, pathlib
p = pathlib.Path.home()/"GitProjects/MC_AndroidApp/god-mode/app/build/outputs/apk/release/output-metadata.json"
data = json.loads(p.read_text())
print(data["elements"][0]["versionCode"])
PY
)
VERSION_NAME=$(python3 - <<'PY'
import json, pathlib
p = pathlib.Path.home()/"GitProjects/MC_AndroidApp/god-mode/app/build/outputs/apk/release/output-metadata.json"
data = json.loads(p.read_text())
print(data["elements"][0]["versionName"])
PY
)
FDROID_APK="$FDROID_DIR/repo/${PACKAGE_NAME}_${VERSION_CODE}.apk"

echo "==> Signing APK for package $PACKAGE_NAME version $VERSION_NAME ($VERSION_CODE)"
cp "$APK_UNSIGNED" "$FDROID_APK"
"$APKSIGNER" sign \
  --ks "$APP_KEYSTORE" \
  --ks-key-alias "$APP_ALIAS" \
  --ks-pass pass:"$APP_PASS" \
  --key-pass pass:"$APP_PASS" \
  "$FDROID_APK"
"$APKSIGNER" verify --verbose "$FDROID_APK"

echo "==> Updating F-Droid repo indexes"
cd "$FDROID_DIR"
rm -rf repo/status tmp
rm -f "repo/${PACKAGE_NAME}_"*.apk.idsig || true
"$FDROID_BIN" update -c --pretty -W warn
"$FDROID_BIN" update --pretty -W warn
rm -rf repo/status tmp
rm -f "repo/${PACKAGE_NAME}_"*.apk.idsig || true

echo "==> Publishing to GitHub Pages backing repo"
git add .gitignore metadata "$FDROID_APK" repo/entry.jar repo/entry.json repo/index-v1.jar repo/index-v1.json repo/index-v2.json repo/index.css repo/index.html repo/index.jar repo/index.png repo/index.xml repo/icons repo/icons-120 repo/icons-160 repo/icons-240 repo/icons-320 repo/icons-480 repo/icons-640 repo/diff
if ! git diff --cached --quiet; then
  git commit -m "Publish god-mode ${VERSION_NAME} to F-Droid repo"
  git push
else
  echo "No publishable changes detected in F-Droid repo"
fi

echo
echo "Done."
echo "Feed URL: $PAGES_FEED_URL"
echo "Repo GitHub: $PAGES_REPO_URL"
echo "Published APK: $FDROID_APK"
