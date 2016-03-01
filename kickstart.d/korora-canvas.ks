%include fedora-live-workstation.ks
%include korora-base.ks

%packages

# removing groups brought in by fedora-live-base.ks
@base-x
@guest-desktop-agents
-@standard
@core
@fonts
-@input-methods
@dial-up
-@multimedia
@hardware-support
-@printing

# removing groups brought in by fedora-workstation-packages.ks
@base-x                                                                                          
@core
-@firefox
@fonts
@guest-desktop-agents
@hardware-support
-@libreoffice
-@multimedia
-@networkmanager-submodules
-@printing
-@workstation-product

# removing packages brought in by fedora-workstation-packages.ks
-aajohan-comfortaa-fonts
-fedora-productimg-workstation

# removing groups brought in by korora
-@admin-tools
-@standard
@fonts
-@input-methods
-@printing

# Base GNOME desktop for Canvas
#avahi
@critical-path-gnome
#deja-dup
#deja-dup-nautilus
#file-roller
#file-roller-nautilus
#firewall-config
gedit
gnome-bluetooth
#gnome-calculator
#gnome-clocks
gnome-getting-started-docs
gnome-initial-setup
#gnome-screenshot
gnome-session-wayland-session
-gnome-software
gvfs-afc
gvfs-afp
gvfs-archive
gvfs-fuse
gvfs-goa
gvfs-gphoto2
gvfs-mtp
gvfs-smb
mousetweaks
nautilus-open-terminal
nautilus-sendto
orca
PackageKit-command-not-found
PackageKit-gstreamer-plugin
yumex-dnf

# Korora essentials
canvas
korora-backgrounds-gnome
-korora-backgrounds-extras-gnome
korora-extras
korora-icon-theme
korora-productimg-workstation
korora-welcome
plymouth-theme-korora

# Release packages
adobe-release
google-chrome-release
google-earth-release
google-talkplugin-release
rpmfusion-nonfree-release
rpmfusion-free-release
virtualbox-release

# Korora GNOME config
#gnome-shell-theme-korora
arc-theme
gnome-shell-extension-dash-to-dock
gnome-shell-extension-drive-menu
gnome-shell-extension-places-menu
gnome-shell-extension-user-theme
gnome-shell-extension-weather
gnome-tweak-tool
korora-settings-gnome

# Networking
NetworkManager-adsl
NetworkManager-bluetooth
NetworkManager-iodine-gnome
NetworkManager-l2tp
NetworkManager-openconnect
NetworkManager-openswan-gnome
NetworkManager-openvpn-gnome
NetworkManager-pptp-gnome
NetworkManager-ssh-gnome
NetworkManager-vpnc-gnome
NetworkManager-wifi
NetworkManager-wwan

# Fonts
hack-fonts
open-sans-fonts

# Essential utilities
bash-completion
fprintd-pam
mlocate

%end


%post

# set arc theme
cat >> /usr/share/glib-2.0/schemas/org.korora.gschema.override << EOF

[org.gnome.shell.extensions.user-theme]
name="Arc"

[org.gnome.desktop.interface]
gtk-theme="Arc"
monospace-font-name="Hack 11"

[org.gnome.desktop.background]                                                                   
show-desktop-icons=false
picture-uri='file:///usr/share/backgrounds/korora/default/korora.xml'

[org.gnome.desktop.screensaver]
picture-uri='file:///usr/share/backgrounds/korora/default/korora.xml'

[org.gnome.desktop.wm.preferences]
titlebar-font='Open Sans 10'
titlebar-uses-system-font=false

[org.gnome.evolution.mail]
monospace-font='Hack 12'
use-custom-font=true
variable-width-font='Open Sans 12'

[org.gnome.gedit.plugins.externaltools]
font='Hack 10'
use-system-font=false

[org.gnome.gedit.plugins.pythonconsole]
font='Hack 10'
use-system-font=false

[org.gnome.gedit.preferences.editor]
editor-font='Hack 12'
use-default-font=false

[org.gnome.gedit.preferences.print]
print-font-body-pango='Hack 9'
print-font-header-pango='Open Sans 11'
print-font-numbers-pango='Open Sans 8'

[org.gnome.gnote]
custom-font-face='Open Sans 11'
enable-custom-font=true

[org.gnome.nautilus.desktop]
font='Open Sans 10'

EOF

cat >> /etc/rc.d/init.d/livesys << EOF

# KP - disable screensaver locking
cat >> /usr/share/glib-2.0/schemas/org.gnome.desktop.screensaver.gschema.override << FOE

[org.gnome.desktop.screensaver]
lock-enabled=false
FOE

# KP - hide the lock screen option
cat >> /usr/share/glib-2.0/schemas/org.gnome.desktop.lockdown.gschema.override << FOE

[org.gnome.desktop.lockdown]
disable-lock-screen=true
FOE

# KP - turn off screensaver
gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory --type bool --set /apps/gnome-screensaver/idle_activation_enabled false

# KP - configure our favourite apps for live
  cat >> /usr/share/glib-2.0/schemas/org.korora.gschema.override << FOE

[org.gnome.shell]
favorite-apps=['firefox.desktop', 'evolution.desktop', 'vlc.desktop', 'shotwell.desktop', 'libreoffice-writer.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Documents.desktop', 'anaconda.desktop']
FOE

# rebuild schema cache with any overrides we installed
glib-compile-schemas /usr/share/glib-2.0/schemas

# make sure to set the right permissions and selinux contexts
chown -R liveuser:liveuser /home/liveuser/
restorecon -R /home/liveuser/

EOF

%end