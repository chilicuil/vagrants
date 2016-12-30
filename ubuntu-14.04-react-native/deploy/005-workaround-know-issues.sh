#!/bin/sh
set -xe

[ -d /vagrant ] && cd /vagrant

#prevent http://stackoverflow.com/questions/16748737/grunt-watch-error-waiting-fatal-error-watch-enospc
npm dedupe
grep 'fs.inotify.max_user_watches=524288' /etc/sysctl.conf || \
    printf "%s\\n" 'fs.inotify.max_user_watches=524288' | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

#ensure that user vagrant owns everything in /vagrant
[ -d /vagrant ] && chown -R vagrant:vagrant /vagrant/* /vagrant/.[!.]*

#add extra usb rules, http://askubuntu.com/questions/461729/ubuntu-is-not-detecting-my-android-device
cat << EOF | sudo tee /etc/udev/rules.d/51-android.rules
SUBSYSTEM=="usb", ATTRS{idVendor}=="0bb4", MODE="0666", GROUP="${USER}"
SUBSYSTEM=="usb", ATTRS{idVendor}=="0e79", MODE="0666", GROUP="${USER}"
SUBSYSTEM=="usb", ATTRS{idVendor}=="0502", MODE="0666", GROUP="${USER}"
SUBSYSTEM=="usb", ATTRS{idVendor}=="0b05", MODE="0666", GROUP="${USER}"
SUBSYSTEM=="usb", ATTRS{idVendor}=="413c", MODE="0666", GROUP="${USER}"
SUBSYSTEM=="usb", ATTRS{idVendor}=="0489", MODE="0666", GROUP="${USER}"
SUBSYSTEM=="usb", ATTRS{idVendor}=="091e", MODE="0666", GROUP="${USER}"
SUBSYSTEM=="usb", ATTRS{idVendor}=="18d1", MODE="0666", GROUP="${USER}"
SUBSYSTEM=="usb", ATTRS{idVendor}=="0bb4", MODE="0666", GROUP="${USER}"
SUBSYSTEM=="usb", ATTRS{idVendor}=="12d1", MODE="0666", GROUP="${USER}"
SUBSYSTEM=="usb", ATTRS{idVendor}=="24e3", MODE="0666", GROUP="${USER}"
SUBSYSTEM=="usb", ATTRS{idVendor}=="2116", MODE="0666", GROUP="${USER}"
SUBSYSTEM=="usb", ATTRS{idVendor}=="0482", MODE="0666", GROUP="${USER}"
SUBSYSTEM=="usb", ATTRS{idVendor}=="17ef", MODE="0666", GROUP="${USER}"
SUBSYSTEM=="usb", ATTRS{idVendor}=="1004", MODE="0666", GROUP="${USER}"
SUBSYSTEM=="usb", ATTRS{idVendor}=="22b8", MODE="0666", GROUP="${USER}"
SUBSYSTEM=="usb", ATTRS{idVendor}=="0409", MODE="0666", GROUP="${USER}"
SUBSYSTEM=="usb", ATTRS{idVendor}=="2080", MODE="0666", GROUP="${USER}"
SUBSYSTEM=="usb", ATTRS{idVendor}=="0955", MODE="0666", GROUP="${USER}"
SUBSYSTEM=="usb", ATTRS{idVendor}=="2257", MODE="0666", GROUP="${USER}"
SUBSYSTEM=="usb", ATTRS{idVendor}=="10a9", MODE="0666", GROUP="${USER}"
SUBSYSTEM=="usb", ATTRS{idVendor}=="1d4d", MODE="0666", GROUP="${USER}"
SUBSYSTEM=="usb", ATTRS{idVendor}=="0471", MODE="0666", GROUP="${USER}"
SUBSYSTEM=="usb", ATTRS{idVendor}=="04da", MODE="0666", GROUP="${USER}"
SUBSYSTEM=="usb", ATTRS{idVendor}=="05c6", MODE="0666", GROUP="${USER}"
SUBSYSTEM=="usb", ATTRS{idVendor}=="1f53", MODE="0666", GROUP="${USER}"
SUBSYSTEM=="usb", ATTRS{idVendor}=="04e8", MODE="0666", GROUP="${USER}"
SUBSYSTEM=="usb", ATTRS{idVendor}=="04dd", MODE="0666", GROUP="${USER}"
SUBSYSTEM=="usb", ATTRS{idVendor}=="0fce", MODE="0666", GROUP="${USER}"
SUBSYSTEM=="usb", ATTRS{idVendor}=="0930", MODE="0666", GROUP="${USER}"
SUBSYSTEM=="usb", ATTRS{idVendor}=="19d2", MODE="0666", GROUP="${USER}"
EOF

sudo chmod a+r /etc/udev/rules.d/51-android.rules
sudo udevadm control --reload-rules
sudo service udev restart
sudo udevadm trigger
