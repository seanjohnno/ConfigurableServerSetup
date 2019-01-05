Unattended-Upgrade::Allowed-Origins {
	"${distro_id}:${distro_codename}-security";
};

Unattended-Upgrade::Mail "$UNATTENDED_UPGRADES_SENDTO_EMAIL";

Unattended-Upgrade::Remove-Unused-Dependencies "true";

Unattended-Upgrade::Automatic-Reboot "true";

// Can be "10:00" or "now"
Unattended-Upgrade::Automatic-Reboot-Time "$UNATTENDED_UPGRADES_UPDATE_TIME";