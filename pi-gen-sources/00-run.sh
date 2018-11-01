#!/bin/bash -e
touch "${ROOTFS_DIR}/boot/ssh"
install -m 755 files/rc.local		"${ROOTFS_DIR}/etc/"
install -m 755 files/stage_flash    "${ROOTFS_DIR}/etc/"
install -m 666 files/teslausb_setup_variables.conf.sample    "${ROOTFS_DIR}/boot/"
install -m 666 files/wpa_supplicant.conf.sample    "${ROOTFS_DIR}/boot/"
install -d "${ROOTFS_DIR}/root/bin"
install -m 755 files/enable_wifi.sh "${ROOTFS_DIR}/root/bin"

# Below here is the rest of the stage2 (builds the Stretch lite image)
# run script commented out just to give guidance on things that can be done. 

# install -m 755 files/teslausb_setup_scripts/bin/* "${ROOTFS_DIR}/root/bin/"
# install -d "${ROOTFS_DIR}/root/bin/tmp"
# install -m 755 files/teslausb_setup_scripts/tmp/* "${ROOTFS_DIR}/root/bin/tmp/"

# on_chroot << EOF
# systemctl disable hwclock.sh
# systemctl disable nfs-common
# systemctl disable rpcbind
# systemctl disable ssh
# systemctl enable regenerate_ssh_host_keys
# EOF

# if [ "${USE_QEMU}" = "1" ]; then
# 	echo "enter QEMU mode"
# 	install -m 644 files/90-qemu.rules "${ROOTFS_DIR}/etc/udev/rules.d/"
# 	on_chroot << EOF
# systemctl disable resize2fs_once
# EOF
# 	echo "leaving QEMU mode"
# else
# 	on_chroot << EOF
# systemctl enable resize2fs_once
# EOF
# fi

# on_chroot << \EOF
# for GRP in input spi i2c gpio; do
# 	groupadd -f -r "$GRP"
# done
# for GRP in adm dialout cdrom audio users sudo video games plugdev input gpio spi i2c netdev; do
#   adduser pi $GRP
# done
# EOF

# on_chroot << EOF
# setupcon --force --save-only -v
# EOF

# on_chroot << EOF
# usermod --pass='*' root
# EOF

# rm -f "${ROOTFS_DIR}/etc/ssh/"ssh_host_*_key*
