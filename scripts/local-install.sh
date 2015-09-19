#!/usr/bin/env bash

# Stop script if any command returns non zero exit code

    set -e

# Set up environment

    VERSION="0.7.0"
    PLATFORM="Darwin"

    ZAS_ROOT="$HOME/Library/Application Support/Zas"

    ARCHIVE="zas-v${VERSION}+${PLATFORM}.tar.gz"

    ZASD_PLIST_PATH="$HOME/Library/LaunchAgents/com.zas.zasd.plist"
    FIREWALL_PLIST_PATH="/Library/LaunchDaemons/com.zas.firewall.plist"

# Create root directory

    mkdir -p "$ZAS_ROOT"

# Create apps directory

    mkdir -p "$HOME/.zas/apps"

# Create logs directory

    mkdir -p "$HOME/.zas/logs"

# Extract tarball

    cp -f "tmp/$ARCHIVE" "$ZAS_ROOT"

# Change into Zas root directory

    cd "$ZAS_ROOT"

# Extract tarball

    tar -xzf "$ARCHIVE"

# Create `current` symlink pointing to the downloaded version
    ln -sf "zas-v${VERSION}+${PLATFORM}" current

# Install zas daemon
    echo "Installing daemon"
    m4 --define USER_SHELL="${SHELL##*/}" --define ZAS_BINARY="$ZAS_ROOT/current/bin/zas" "$ZAS_ROOT/current/resources/com.zas.zasd.plist.template" > "${ZASD_PLIST_PATH}"

    launchctl bootstrap gui/"$UID" "${ZASD_PLIST_PATH}" 2>/dev/null
    launchctl enable gui/"$UID"/com.zas.zasd 2>/dev/null
    launchctl kickstart -k gui/"$UID"/com.zas.zasd 2>/dev/null

# Install DNS resolver

    echo "Installing DNS resolver"
    sudo cp -f current/resources/dev-resolver /etc/resolver/dev

# Install port forwarding

    echo "Installing port forward"
    sudo cp current/resources/com.zas.firewall.plist "${FIREWALL_PLIST_PATH}"

    sudo launchctl bootstrap system "${FIREWALL_PLIST_PATH}" 2>/dev/null
    sudo launchctl enable system/com.zas.firewall 2>/dev/null
    sudo launchctl kickstart -k system/com.zas.firewall 2>/dev/null

# Make sure the user knows it was completed successfully

    echo "Done"