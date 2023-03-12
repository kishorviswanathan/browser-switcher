#!/bin/bash
set -e

# Installer for Browser Switcher

INSTALL_DIR="$HOME/.local/bin"
DESKTOP_DIR="$HOME/.local/share/applications"

LATEST_TAG="$( curl -Ls https://api.github.com/repos/kishorv06/browser-switcher/releases/latest | grep "tag_name" | cut -d ':' -f2 | sed 's/ "\(.*\)",/\1/' )"

ARCH="$( uname -m )"
if [ "$ARCH" == "x86_64" ]; then
  GOARCH="amd64"
elif [ "$ARCH" == "i686" ]; then
  GOARCH="386"
elif [ "$ARCH" == "armv7l" ]; then
  GOARCH="arm"
elif [ "$ARCH" == "aarch64" ]; then
  GOARCH="arm64"
else
  echo "Unsupported architecture: $ARCH"
  exit 1
fi

echo "Downloading Browser Switcher ${LATEST_TAG}"
curl -L -o "/tmp/browser-switcher" "https://github.com/kishorv06/browser-switcher/releases/download/${LATEST_TAG}/browser-switcher-${LATEST_TAG}-linux-${GOARCH}"

echo "Installing..."
chmod +x "/tmp/browser-switcher"
mkdir -p "$INSTALL_DIR"
mv "/tmp/browser-switcher" "$INSTALL_DIR/browser-switcher"

echo "Setting default browser..."
mkdir -p "$DESKTOP_DIR"
cat << EOF > "$DESKTOP_DIR/browser-switcher.desktop"
[Desktop Entry]
Version=1.0
Name=Browser Switcher
GenericName=Browser Switcher
Comment=Launch browser based on URL matching
Exec=$INSTALL_DIR/browser-switcher "%u"
StartupNotify=true
Terminal=false
Icon=browser
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml_xml;image/webp;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;
EOF
chmod +x "$DESKTOP_DIR/browser-switcher.desktop"
xdg-settings set default-web-browser browser-switcher.desktop

echo "Installed Successfully!!"
