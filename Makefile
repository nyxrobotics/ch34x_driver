ifeq ($(KERNELRELEASE), )

KER_VER := $(if $(KERNELRELEASE),$(KERNELRELEASE),$(shell uname -r))
KER_SRC := $(if $(KERNEL_SRC),$(KERNEL_SRC),/lib/modules/$(KER_VER)/build)
MOD_DIR := kernel/drivers/usb/serial
MODDESTDIR := /lib/modules/$(KER_VER)/kernel/drivers/usb/serial

PWD :=$(shell pwd)
default:
	$(MAKE) -C $(KER_SRC) INSTALL_MOD_DIR=$(MOD_DIR) M=$(PWD)
clean:
	rm -rf .tmp_versions Module.symvers *.mod.c *.o *.ko .*.cmd Module.markers modules.order
load:
	modprobe usbserial
	insmod ch34x.ko
install:
	install -p -m 644 ch34x.ko $(MODDESTDIR)
	@if [ -a /lib/modules/$(KER_VER)/kernel/drivers/usb/serial/ch341.ko ] ; then modprobe -r ch341; fi;
	@if [ -a /lib/modules/$(KER_VER)/kernel/drivers/usb/serial/ch340.ko ] ; then modprobe -r ch340; fi;
	@echo "blacklist ch340\nblacklist ch341" > /etc/modprobe.d/ch34x.conf
	/sbin/depmod -a
# 	$(MAKE) -C $(KER_SRC) INSTALL_MOD_DIR=$(MOD_DIR) M=$(PWD) modules_install

unload:
	rmmod ch34x
else
	obj-m := ch34x.o
endif
