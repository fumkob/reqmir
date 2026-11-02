#!/bin/bash
# Matches on the Info.plist version, not the app name: the name differs between this machine
# (Xcode-27.1.0.app) and the GitHub runners (Xcode_27.1.app).
set -euo pipefail

if [[ -n "${DEVELOPER_DIR:-}" ]]; then
    echo "$DEVELOPER_DIR"
    exit 0
fi

wanted="$(tr -d '[:space:]' < "$(dirname "$0")/../.xcode-version")"
for app in /Applications/Xcode*.app; do
    version="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$app/Contents/Info.plist" 2>/dev/null || true)"
    if [[ "$version" == "$wanted" ]]; then
        echo "$app/Contents/Developer"
        exit 0
    fi
done

echo "error: Xcode $wanted was not found in /Applications. Install it, or set DEVELOPER_DIR" >&2
exit 1
