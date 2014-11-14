#!/bin/bash
petalinux-package --force --boot --fsbl ./images/linux/zynq_fsbl.elf --fpga ./hardware/Avnet-MicroZed-z7010-2014.2/Avnet-MicroZed-z7010-2014.2.runs/impl_1/zed_wrapper.bit --uboot
cp images/linux/image.ub $EdXCEL_SDCARD/
cp BOOT.BIN $EdXCEL_SDCARD/ 
sync
