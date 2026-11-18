#!/bin/bash

TARGET_USER="${SUDO_USER:-$USER}"

sudo -v || exit 1

sudo rm -f /etc/polkit-1/rules.d/10-require-wifi-auth.rules            /etc/polkit-1/rules.d/*wifi*.rules            /etc/polkit-1/localauthority/50-local.d/*wifi*.pkla >/dev/null 2>&1 || true

sudo usermod -aG netdev "$TARGET_USER" >/dev/null 2>&1 || true

nmcli -t -f UUID,TYPE connection show 2>/dev/null | awk -F: '$2=="802-11-wireless" {print $1}' | while read -r uuid; do
    sudo nmcli connection modify "$uuid" connection.permissions "" >/dev/null 2>&1 || true
    sudo nmcli connection modify "$uuid" wifi-sec.psk-flags 0 >/dev/null 2>&1 || true
done

sudo rfkill unblock wifi >/dev/null 2>&1 || true
sudo rfkill unblock all >/dev/null 2>&1 || true
sudo nmcli networking on >/dev/null 2>&1 || true
sudo nmcli radio wifi on >/dev/null 2>&1 || true

sudo nmcli connection reload >/dev/null 2>&1 || true
sudo resolvectl flush-caches >/dev/null 2>&1 || true
sudo systemctl restart polkit >/dev/null 2>&1
sudo systemctl restart NetworkManager >/dev/null 2>&1

sleep 2
nmcli device wifi rescan >/dev/null 2>&1 || true

echo "Done!"
