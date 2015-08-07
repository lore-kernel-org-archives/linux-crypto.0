From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 3/5] crypto: qat - Add qat dh895xcc VF driver
Date: Fri, 07 Aug 2015 11:34:31 -0700
Message-ID: <20150807183431.630.84165.stgit@tstruk-mobl1>
References: <20150807183414.630.25889.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, bhelgaas@google.com,
	linux-pci@vger.kernel.org, qat-linux@intel.com,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:37857 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946203AbbHGSft (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Aug 2015 14:35:49 -0400
In-Reply-To: <20150807183414.630.25889.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add code specific for the dh895xcc virtual function.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/Kconfig                         |   11 +
 drivers/crypto/qat/Makefile                        |    1 
 drivers/crypto/qat/qat_dh895xccvf/Makefile         |    5 
 .../qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c    |  172 +++++++++
 .../qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.h    |   68 +++
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c        |  393 ++++++++++++++++++++
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.h        |   57 +++
 drivers/crypto/qat/qat_dh895xccvf/adf_isr.c        |  258 +++++++++++++
 8 files changed, 965 insertions(+)
 create mode 100644 drivers/crypto/qat/qat_dh895xccvf/Makefile
 create mode 100644 drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
 create mode 100644 drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.h
 create mode 100644 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
 create mode 100644 drivers/crypto/qat/qat_dh895xccvf/adf_drv.h
 create mode 100644 drivers/crypto/qat/qat_dh895xccvf/adf_isr.c

diff --git a/drivers/crypto/qat/Kconfig b/drivers/crypto/qat/Kconfig
index d8c3d59..95a9566 100644
--- a/drivers/crypto/qat/Kconfig
+++ b/drivers/crypto/qat/Kconfig
@@ -21,3 +21,14 @@ config CRYPTO_DEV_QAT_DH895xCC
 
 	  To compile this as a module, choose M here: the module
 	  will be called qat_dh895xcc.
+
+config CRYPTO_DEV_QAT_DH895xCCVF
+	tristate "Support for Intel(R) DH895xCC Virtual Function"
+	select PCI_IOV
+
+	help
+	  Support for Intel(R) DH895xcc with Intel(R) QuickAssist Technology
+	  Virtual Function for accelerating crypto and compression workloads.
+
+	  To compile this as a module, choose M here: the module
+	  will be called qat_dh895xccvf.
diff --git a/drivers/crypto/qat/Makefile b/drivers/crypto/qat/Makefile
index d11481b..a3ce0b7 100644
--- a/drivers/crypto/qat/Makefile
+++ b/drivers/crypto/qat/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_CRYPTO_DEV_QAT) += qat_common/
 obj-$(CONFIG_CRYPTO_DEV_QAT_DH895xCC) += qat_dh895xcc/
+obj-$(CONFIG_CRYPTO_DEV_QAT_DH895xCCVF) += qat_dh895xccvf/
diff --git a/drivers/crypto/qat/qat_dh895xccvf/Makefile b/drivers/crypto/qat/qat_dh895xccvf/Makefile
new file mode 100644
index 0000000..85399fc
--- /dev/null
+++ b/drivers/crypto/qat/qat_dh895xccvf/Makefile
@@ -0,0 +1,5 @@
+ccflags-y := -I$(src)/../qat_common
+obj-$(CONFIG_CRYPTO_DEV_QAT_DH895xCCVF) += qat_dh895xccvf.o
+qat_dh895xccvf-objs := adf_drv.o \
+		adf_isr.o \
+		adf_dh895xccvf_hw_data.o
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
new file mode 100644
index 0000000..7bbf846
--- /dev/null
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
@@ -0,0 +1,172 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2015 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2015 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#include <adf_accel_devices.h>
+#include <adf_pf2vf_msg.h>
+#include <adf_common_drv.h>
+#include "adf_dh895xccvf_hw_data.h"
+#include "adf_drv.h"
+
+static struct adf_hw_device_class dh895xcciov_class = {
+	.name = ADF_DH895XCCVF_DEVICE_NAME,
+	.type = DEV_DH895XCCVF,
+	.instances = 0
+};
+
+static u32 get_accel_mask(u32 fuse)
+{
+	return ADF_DH895XCCIOV_ACCELERATORS_MASK;
+}
+
+static u32 get_ae_mask(u32 fuse)
+{
+	return ADF_DH895XCCIOV_ACCELENGINES_MASK;
+}
+
+static u32 get_num_accels(struct adf_hw_device_data *self)
+{
+	return ADF_DH895XCCIOV_MAX_ACCELERATORS;
+}
+
+static u32 get_num_aes(struct adf_hw_device_data *self)
+{
+	return ADF_DH895XCCIOV_MAX_ACCELENGINES;
+}
+
+static u32 get_misc_bar_id(struct adf_hw_device_data *self)
+{
+	return ADF_DH895XCCIOV_PMISC_BAR;
+}
+
+static u32 get_etr_bar_id(struct adf_hw_device_data *self)
+{
+	return ADF_DH895XCCIOV_ETR_BAR;
+}
+
+static enum dev_sku_info get_sku(struct adf_hw_device_data *self)
+{
+	return DEV_SKU_VF;
+}
+
+static u32 get_pf2vf_offset(u32 i)
+{
+	return ADF_DH895XCCIOV_PF2VF_OFFSET;
+}
+
+static u32 get_vintmsk_offset(u32 i)
+{
+	return ADF_DH895XCCIOV_VINTMSK_OFFSET;
+}
+
+static int adf_vf_int_noop(struct adf_accel_dev *accel_dev)
+{
+	return 0;
+}
+
+static void adf_vf_void_noop(struct adf_accel_dev *accel_dev)
+{
+}
+
+static int adf_vf2pf_init(struct adf_accel_dev *accel_dev)
+{
+	u32 msg = (ADF_VF2PF_MSGORIGIN_SYSTEM |
+		(ADF_VF2PF_MSGTYPE_INIT << ADF_VF2PF_MSGTYPE_SHIFT));
+
+	if (adf_iov_putmsg(accel_dev, msg, 0)) {
+		dev_err(&GET_DEV(accel_dev),
+			"Failed to send Init event to PF\n");
+		return -EFAULT;
+	}
+	return 0;
+}
+
+static void adf_vf2pf_shutdown(struct adf_accel_dev *accel_dev)
+{
+	u32 msg = (ADF_VF2PF_MSGORIGIN_SYSTEM |
+	    (ADF_VF2PF_MSGTYPE_SHUTDOWN << ADF_VF2PF_MSGTYPE_SHIFT));
+
+	if (adf_iov_putmsg(accel_dev, msg, 0))
+		dev_err(&GET_DEV(accel_dev),
+			"Failed to send Shutdown event to PF\n");
+}
+
+void adf_init_hw_data_dh895xcciov(struct adf_hw_device_data *hw_data)
+{
+	hw_data->dev_class = &dh895xcciov_class;
+	hw_data->instance_id = dh895xcciov_class.instances++;
+	hw_data->num_banks = ADF_DH895XCCIOV_ETR_MAX_BANKS;
+	hw_data->num_accel = ADF_DH895XCCIOV_MAX_ACCELERATORS;
+	hw_data->num_logical_accel = 1;
+	hw_data->num_engines = ADF_DH895XCCIOV_MAX_ACCELENGINES;
+	hw_data->tx_rx_gap = ADF_DH895XCCIOV_RX_RINGS_OFFSET;
+	hw_data->tx_rings_mask = ADF_DH895XCCIOV_TX_RINGS_MASK;
+	hw_data->alloc_irq = adf_isr_resource_alloc;
+	hw_data->free_irq = adf_isr_resource_free;
+	hw_data->enable_error_correction = adf_vf_void_noop;
+	hw_data->init_admin_comms = adf_vf_int_noop;
+	hw_data->exit_admin_comms = adf_vf_void_noop;
+	hw_data->send_admin_init = adf_vf2pf_init;
+	hw_data->init_arb = adf_vf_int_noop;
+	hw_data->exit_arb = adf_vf_void_noop;
+	hw_data->disable_iov = adf_vf2pf_shutdown;
+	hw_data->get_accel_mask = get_accel_mask;
+	hw_data->get_ae_mask = get_ae_mask;
+	hw_data->get_num_accels = get_num_accels;
+	hw_data->get_num_aes = get_num_aes;
+	hw_data->get_etr_bar_id = get_etr_bar_id;
+	hw_data->get_misc_bar_id = get_misc_bar_id;
+	hw_data->get_pf2vf_offset = get_pf2vf_offset;
+	hw_data->get_vintmsk_offset = get_vintmsk_offset;
+	hw_data->get_sku = get_sku;
+	hw_data->enable_ints = adf_vf_void_noop;
+	hw_data->enable_vf2pf_comms = adf_enable_vf2pf_comms;
+	hw_data->min_iov_compat_ver = ADF_PFVF_COMPATIBILITY_VERSION;
+}
+
+void adf_clean_hw_data_dh895xcciov(struct adf_hw_device_data *hw_data)
+{
+	hw_data->dev_class->instances--;
+}
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.h b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.h
new file mode 100644
index 0000000..8f6babf
--- /dev/null
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.h
@@ -0,0 +1,68 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2015 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2015 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#ifndef ADF_DH895XVF_HW_DATA_H_
+#define ADF_DH895XVF_HW_DATA_H_
+
+#define ADF_DH895XCCIOV_PMISC_BAR 1
+#define ADF_DH895XCCIOV_ACCELERATORS_MASK 0x1
+#define ADF_DH895XCCIOV_ACCELENGINES_MASK 0x1
+#define ADF_DH895XCCIOV_MAX_ACCELERATORS 1
+#define ADF_DH895XCCIOV_MAX_ACCELENGINES 1
+#define ADF_DH895XCCIOV_RX_RINGS_OFFSET 8
+#define ADF_DH895XCCIOV_TX_RINGS_MASK 0xFF
+#define ADF_DH895XCCIOV_ETR_BAR 0
+#define ADF_DH895XCCIOV_ETR_MAX_BANKS 1
+
+#define ADF_DH895XCCIOV_PF2VF_OFFSET	0x200
+#define ADF_DH895XCC_PF2VF_PF2VFINT	BIT(0)
+
+#define ADF_DH895XCCIOV_VINTSOU_OFFSET	0x204
+#define ADF_DH895XCC_VINTSOU_BUN	BIT(0)
+#define ADF_DH895XCC_VINTSOU_PF2VF	BIT(1)
+
+#define ADF_DH895XCCIOV_VINTMSK_OFFSET	0x208
+#endif
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
new file mode 100644
index 0000000..789426f
--- /dev/null
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
@@ -0,0 +1,393 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/errno.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/platform_device.h>
+#include <linux/workqueue.h>
+#include <linux/io.h>
+#include <adf_accel_devices.h>
+#include <adf_common_drv.h>
+#include <adf_cfg.h>
+#include <adf_transport_access_macros.h>
+#include "adf_dh895xccvf_hw_data.h"
+#include "adf_drv.h"
+
+static const char adf_driver_name[] = ADF_DH895XCCVF_DEVICE_NAME;
+
+#define ADF_SYSTEM_DEVICE(device_id) \
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, device_id)}
+
+static const struct pci_device_id adf_pci_tbl[] = {
+	ADF_SYSTEM_DEVICE(ADF_DH895XCCIOV_PCI_DEVICE_ID),
+	{0,}
+};
+MODULE_DEVICE_TABLE(pci, adf_pci_tbl);
+
+static int adf_probe(struct pci_dev *dev, const struct pci_device_id *ent);
+static void adf_remove(struct pci_dev *dev);
+
+static struct pci_driver adf_driver = {
+	.id_table = adf_pci_tbl,
+	.name = adf_driver_name,
+	.probe = adf_probe,
+	.remove = adf_remove,
+};
+
+static void adf_cleanup_pci_dev(struct adf_accel_dev *accel_dev)
+{
+	pci_release_regions(accel_dev->accel_pci_dev.pci_dev);
+	pci_disable_device(accel_dev->accel_pci_dev.pci_dev);
+}
+
+static void adf_cleanup_accel(struct adf_accel_dev *accel_dev)
+{
+	struct adf_accel_pci *accel_pci_dev = &accel_dev->accel_pci_dev;
+	struct adf_accel_dev *pf;
+	int i;
+
+	for (i = 0; i < ADF_PCI_MAX_BARS; i++) {
+		struct adf_bar *bar = &accel_pci_dev->pci_bars[i];
+
+		if (bar->virt_addr)
+			pci_iounmap(accel_pci_dev->pci_dev, bar->virt_addr);
+	}
+
+	if (accel_dev->hw_device) {
+		switch (accel_pci_dev->pci_dev->device) {
+		case ADF_DH895XCCIOV_PCI_DEVICE_ID:
+			adf_clean_hw_data_dh895xcciov(accel_dev->hw_device);
+			break;
+		default:
+			break;
+		}
+		kfree(accel_dev->hw_device);
+		accel_dev->hw_device = NULL;
+	}
+	adf_cfg_dev_remove(accel_dev);
+	debugfs_remove(accel_dev->debugfs_dir);
+	pf = adf_devmgr_pci_to_accel_dev(accel_pci_dev->pci_dev->physfn);
+	adf_devmgr_rm_dev(accel_dev, pf);
+}
+
+static int adf_dev_configure(struct adf_accel_dev *accel_dev)
+{
+	char key[ADF_CFG_MAX_KEY_LEN_IN_BYTES];
+	unsigned long val, bank = 0;
+
+	if (adf_cfg_section_add(accel_dev, ADF_KERNEL_SEC))
+		goto err;
+	if (adf_cfg_section_add(accel_dev, "Accelerator0"))
+		goto err;
+
+	snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_BANK_NUM, 0);
+	if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC, key,
+					(void *)&bank, ADF_DEC))
+		goto err;
+
+	val = bank;
+	snprintf(key, sizeof(key), ADF_CY "%d" ADF_ETRMGR_CORE_AFFINITY, 0);
+	if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC, key,
+					(void *)&val, ADF_DEC))
+		goto err;
+
+	snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_SIZE, 0);
+
+	val = 128;
+	if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC, key,
+					(void *)&val, ADF_DEC))
+		goto err;
+
+	val = 512;
+	snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_SIZE, 0);
+	if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+					key, (void *)&val, ADF_DEC))
+		goto err;
+
+	val = 0;
+	snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_TX, 0);
+	if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+					key, (void *)&val, ADF_DEC))
+		goto err;
+
+	val = 2;
+	snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_TX, 0);
+	if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+					key, (void *)&val, ADF_DEC))
+		goto err;
+
+	val = 8;
+	snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_RX, 0);
+	if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+					key, (void *)&val, ADF_DEC))
+		goto err;
+
+	val = 10;
+	snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_RX, 0);
+	if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+					key, (void *)&val, ADF_DEC))
+			goto err;
+
+	val = ADF_COALESCING_DEF_TIME;
+	snprintf(key, sizeof(key), ADF_ETRMGR_COALESCE_TIMER_FORMAT,
+		 (int)bank);
+	if (adf_cfg_add_key_value_param(accel_dev, "Accelerator0",
+					key, (void *)&val, ADF_DEC))
+		goto err;
+
+	val = 1;
+	if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+					ADF_NUM_CY, (void *)&val, ADF_DEC))
+		goto err;
+
+	set_bit(ADF_STATUS_CONFIGURED, &accel_dev->status);
+	return 0;
+err:
+	dev_err(&GET_DEV(accel_dev), "Failed to configure QAT accel dev\n");
+	return -EINVAL;
+}
+
+static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	struct adf_accel_dev *accel_dev;
+	struct adf_accel_dev *pf;
+	struct adf_accel_pci *accel_pci_dev;
+	struct adf_hw_device_data *hw_data;
+	char name[ADF_DEVICE_NAME_LENGTH];
+	unsigned int i, bar_nr;
+	int ret, bar_mask;
+
+	switch (ent->device) {
+	case ADF_DH895XCCIOV_PCI_DEVICE_ID:
+		break;
+	default:
+		dev_err(&pdev->dev, "Invalid device 0x%x.\n", ent->device);
+		return -ENODEV;
+	}
+
+	accel_dev = kzalloc_node(sizeof(*accel_dev), GFP_KERNEL,
+				 dev_to_node(&pdev->dev));
+	if (!accel_dev)
+		return -ENOMEM;
+
+	accel_dev->is_vf = true;
+	pf = adf_devmgr_pci_to_accel_dev(pdev->physfn);
+	accel_pci_dev = &accel_dev->accel_pci_dev;
+	accel_pci_dev->pci_dev = pdev;
+
+	/* Add accel device to accel table */
+	if (adf_devmgr_add_dev(accel_dev, pf)) {
+		dev_err(&pdev->dev, "Failed to add new accelerator device.\n");
+		kfree(accel_dev);
+		return -EFAULT;
+	}
+	INIT_LIST_HEAD(&accel_dev->crypto_list);
+
+	accel_dev->owner = THIS_MODULE;
+	/* Allocate and configure device configuration structure */
+	hw_data = kzalloc_node(sizeof(*hw_data), GFP_KERNEL,
+			       dev_to_node(&pdev->dev));
+	if (!hw_data) {
+		ret = -ENOMEM;
+		goto out_err;
+	}
+	accel_dev->hw_device = hw_data;
+	switch (ent->device) {
+	case ADF_DH895XCCIOV_PCI_DEVICE_ID:
+		adf_init_hw_data_dh895xcciov(accel_dev->hw_device);
+		break;
+	default:
+		ret = -ENODEV;
+		goto out_err;
+	}
+
+	/* Get Accelerators and Accelerators Engines masks */
+	hw_data->accel_mask = hw_data->get_accel_mask(hw_data->fuses);
+	hw_data->ae_mask = hw_data->get_ae_mask(hw_data->fuses);
+	accel_pci_dev->sku = hw_data->get_sku(hw_data);
+
+	/* Create dev top level debugfs entry */
+	snprintf(name, sizeof(name), "%s%s_%02x:%02d.%02d",
+		 ADF_DEVICE_NAME_PREFIX, hw_data->dev_class->name,
+		 pdev->bus->number, PCI_SLOT(pdev->devfn),
+		 PCI_FUNC(pdev->devfn));
+
+	accel_dev->debugfs_dir = debugfs_create_dir(name, NULL);
+	if (!accel_dev->debugfs_dir) {
+		dev_err(&pdev->dev, "Could not create debugfs dir %s\n", name);
+		ret = -EINVAL;
+		goto out_err;
+	}
+
+	/* Create device configuration table */
+	ret = adf_cfg_dev_add(accel_dev);
+	if (ret)
+		goto out_err;
+
+	/* enable PCI device */
+	if (pci_enable_device(pdev)) {
+		ret = -EFAULT;
+		goto out_err;
+	}
+
+	/* set dma identifier */
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
+		if ((pci_set_dma_mask(pdev, DMA_BIT_MASK(32)))) {
+			dev_err(&pdev->dev, "No usable DMA configuration\n");
+			ret = -EFAULT;
+			goto out_err_disable;
+		} else {
+			pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
+		}
+
+	} else {
+		pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+	}
+
+	if (pci_request_regions(pdev, adf_driver_name)) {
+		ret = -EFAULT;
+		goto out_err_disable;
+	}
+
+	/* Find and map all the device's BARS */
+	i = 0;
+	bar_mask = pci_select_bars(pdev, IORESOURCE_MEM);
+	for_each_set_bit(bar_nr, (const unsigned long *)&bar_mask,
+			 ADF_PCI_MAX_BARS * 2) {
+		struct adf_bar *bar = &accel_pci_dev->pci_bars[i++];
+
+		bar->base_addr = pci_resource_start(pdev, bar_nr);
+		if (!bar->base_addr)
+			break;
+		bar->size = pci_resource_len(pdev, bar_nr);
+		bar->virt_addr = pci_iomap(accel_pci_dev->pci_dev, bar_nr, 0);
+		if (!bar->virt_addr) {
+			dev_err(&pdev->dev, "Failed to map BAR %d\n", bar_nr);
+			ret = -EFAULT;
+			goto out_err_free_reg;
+		}
+	}
+	pci_set_master(pdev);
+	/* Completion for VF2PF request/response message exchange */
+	init_completion(&accel_dev->vf.iov_msg_completion);
+
+	ret = adf_dev_configure(accel_dev);
+	if (ret)
+		goto out_err_free_reg;
+
+	ret = adf_dev_init(accel_dev);
+	if (ret)
+		goto out_err_dev_shutdown;
+
+	ret = adf_dev_start(accel_dev);
+	if (ret)
+		goto out_err_dev_stop;
+
+	return ret;
+
+out_err_dev_stop:
+	adf_dev_stop(accel_dev);
+out_err_dev_shutdown:
+	adf_dev_shutdown(accel_dev);
+out_err_free_reg:
+	pci_release_regions(accel_pci_dev->pci_dev);
+out_err_disable:
+	pci_disable_device(accel_pci_dev->pci_dev);
+out_err:
+	adf_cleanup_accel(accel_dev);
+	kfree(accel_dev);
+	return ret;
+}
+
+static void adf_remove(struct pci_dev *pdev)
+{
+	struct adf_accel_dev *accel_dev = adf_devmgr_pci_to_accel_dev(pdev);
+
+	if (!accel_dev) {
+		pr_err("QAT: Driver removal failed\n");
+		return;
+	}
+	if (adf_dev_stop(accel_dev))
+		dev_err(&GET_DEV(accel_dev), "Failed to stop QAT accel dev\n");
+
+	adf_dev_shutdown(accel_dev);
+	adf_cleanup_accel(accel_dev);
+	adf_cleanup_pci_dev(accel_dev);
+	kfree(accel_dev);
+}
+
+static int __init adfdrv_init(void)
+{
+	request_module("intel_qat");
+
+	if (pci_register_driver(&adf_driver)) {
+		pr_err("QAT: Driver initialization failed\n");
+		return -EFAULT;
+	}
+	return 0;
+}
+
+static void __exit adfdrv_release(void)
+{
+	pci_unregister_driver(&adf_driver);
+	adf_clean_vf_map(true);
+}
+
+module_init(adfdrv_init);
+module_exit(adfdrv_release);
+
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_AUTHOR("Intel");
+MODULE_DESCRIPTION("Intel(R) QuickAssist Technology");
+MODULE_VERSION(ADF_DRV_VERSION);
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.h b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.h
new file mode 100644
index 0000000..041d2a0
--- /dev/null
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.h
@@ -0,0 +1,57 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#ifndef ADF_DH895xVF_DRV_H_
+#define ADF_DH895xVF_DRV_H_
+#include <adf_accel_devices.h>
+#include <adf_transport.h>
+
+void adf_init_hw_data_dh895xcciov(struct adf_hw_device_data *hw_data);
+void adf_clean_hw_data_dh895xcciov(struct adf_hw_device_data *hw_data);
+int adf_isr_resource_alloc(struct adf_accel_dev *accel_dev);
+void adf_isr_resource_free(struct adf_accel_dev *accel_dev);
+void adf_update_ring_arb_enable(struct adf_etr_ring_data *ring);
+#endif
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_isr.c b/drivers/crypto/qat/qat_dh895xccvf/adf_isr.c
new file mode 100644
index 0000000..7fdc84a
--- /dev/null
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_isr.c
@@ -0,0 +1,258 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/pci.h>
+#include <linux/slab.h>
+#include <linux/errno.h>
+#include <linux/interrupt.h>
+#include <adf_accel_devices.h>
+#include <adf_common_drv.h>
+#include <adf_cfg.h>
+#include <adf_cfg_strings.h>
+#include <adf_cfg_common.h>
+#include <adf_transport_access_macros.h>
+#include <adf_transport_internal.h>
+#include <adf_pf2vf_msg.h>
+#include "adf_drv.h"
+#include "adf_dh895xccvf_hw_data.h"
+
+static int adf_enable_msi(struct adf_accel_dev *accel_dev)
+{
+	struct adf_accel_pci *pci_dev_info = &accel_dev->accel_pci_dev;
+	int stat = pci_enable_msi(pci_dev_info->pci_dev);
+
+	if (stat) {
+		dev_err(&GET_DEV(accel_dev),
+			"Failed to enable MSI interrupts\n");
+		return stat;
+	}
+
+	accel_dev->vf.irq_name = kzalloc(ADF_MAX_MSIX_VECTOR_NAME, GFP_KERNEL);
+	if (!accel_dev->vf.irq_name)
+		return -ENOMEM;
+
+	return stat;
+}
+
+static void adf_disable_msi(struct adf_accel_dev *accel_dev)
+{
+	struct pci_dev *pdev = accel_to_pci_dev(accel_dev);
+
+	kfree(accel_dev->vf.irq_name);
+	pci_disable_msi(pdev);
+}
+
+static void adf_pf2vf_bh_handler(void *data)
+{
+	struct adf_accel_dev *accel_dev = data;
+	void __iomem *pmisc_bar_addr =
+		(&GET_BARS(accel_dev)[ADF_DH895XCCIOV_PMISC_BAR])->virt_addr;
+	u32 msg;
+
+	/* Read the message from PF */
+	msg = ADF_CSR_RD(pmisc_bar_addr, ADF_DH895XCCIOV_PF2VF_OFFSET);
+
+	if (!(msg & ADF_PF2VF_MSGORIGIN_SYSTEM))
+		/* Ignore legacy non-system (non-kernel) PF2VF messages */
+		goto err;
+
+	switch ((msg & ADF_PF2VF_MSGTYPE_MASK) >> ADF_PF2VF_MSGTYPE_SHIFT) {
+	case ADF_PF2VF_MSGTYPE_RESTARTING:
+		dev_dbg(&GET_DEV(accel_dev),
+			"Restarting msg received from PF 0x%x\n", msg);
+		adf_dev_stop(accel_dev);
+		break;
+	case ADF_PF2VF_MSGTYPE_VERSION_RESP:
+		dev_dbg(&GET_DEV(accel_dev),
+			"Version resp received from PF 0x%x\n", msg);
+		accel_dev->vf.pf_version =
+			(msg & ADF_PF2VF_VERSION_RESP_VERS_MASK) >>
+			ADF_PF2VF_VERSION_RESP_VERS_SHIFT;
+		accel_dev->vf.compatible =
+			(msg & ADF_PF2VF_VERSION_RESP_RESULT_MASK) >>
+			ADF_PF2VF_VERSION_RESP_RESULT_SHIFT;
+		complete(&accel_dev->vf.iov_msg_completion);
+		break;
+	default:
+		goto err;
+	}
+
+	/* To ack, clear the PF2VFINT bit */
+	msg &= ~ADF_DH895XCC_PF2VF_PF2VFINT;
+	ADF_CSR_WR(pmisc_bar_addr, ADF_DH895XCCIOV_PF2VF_OFFSET, msg);
+
+	/* Re-enable PF2VF interrupts */
+	adf_enable_pf2vf_interrupts(accel_dev);
+	return;
+err:
+	dev_err(&GET_DEV(accel_dev),
+		"Unknown message from PF (0x%x); leaving PF2VF ints disabled\n",
+		msg);
+}
+
+static int adf_setup_pf2vf_bh(struct adf_accel_dev *accel_dev)
+{
+	tasklet_init(&accel_dev->vf.pf2vf_bh_tasklet,
+		     (void *)adf_pf2vf_bh_handler, (unsigned long)accel_dev);
+
+	mutex_init(&accel_dev->vf.vf2pf_lock);
+	return 0;
+}
+
+static void adf_cleanup_pf2vf_bh(struct adf_accel_dev *accel_dev)
+{
+	tasklet_disable(&accel_dev->vf.pf2vf_bh_tasklet);
+	tasklet_kill(&accel_dev->vf.pf2vf_bh_tasklet);
+	mutex_destroy(&accel_dev->vf.vf2pf_lock);
+}
+
+static irqreturn_t adf_isr(int irq, void *privdata)
+{
+	struct adf_accel_dev *accel_dev = privdata;
+	void __iomem *pmisc_bar_addr =
+		(&GET_BARS(accel_dev)[ADF_DH895XCCIOV_PMISC_BAR])->virt_addr;
+	u32 v_int;
+
+	/* Read VF INT source CSR to determine the source of VF interrupt */
+	v_int = ADF_CSR_RD(pmisc_bar_addr, ADF_DH895XCCIOV_VINTSOU_OFFSET);
+
+	/* Check for PF2VF interrupt */
+	if (v_int & ADF_DH895XCC_VINTSOU_PF2VF) {
+		/* Disable PF to VF interrupt */
+		adf_disable_pf2vf_interrupts(accel_dev);
+
+		/* Schedule tasklet to handle interrupt BH */
+		tasklet_hi_schedule(&accel_dev->vf.pf2vf_bh_tasklet);
+		return IRQ_HANDLED;
+	}
+
+	/* Check bundle interrupt */
+	if (v_int & ADF_DH895XCC_VINTSOU_BUN) {
+		struct adf_etr_data *etr_data = accel_dev->transport;
+		struct adf_etr_bank_data *bank = &etr_data->banks[0];
+
+		/* Disable Flag and Coalesce Ring Interrupts */
+		WRITE_CSR_INT_FLAG_AND_COL(bank->csr_addr, bank->bank_number,
+					   0);
+		tasklet_hi_schedule(&bank->resp_handler);
+		return IRQ_HANDLED;
+	}
+
+	return IRQ_NONE;
+}
+
+static int adf_request_msi_irq(struct adf_accel_dev *accel_dev)
+{
+	struct pci_dev *pdev = accel_to_pci_dev(accel_dev);
+	unsigned int cpu;
+	int ret;
+
+	snprintf(accel_dev->vf.irq_name, ADF_MAX_MSIX_VECTOR_NAME,
+		 "qat_%02x:%02d.%02d", pdev->bus->number, PCI_SLOT(pdev->devfn),
+		 PCI_FUNC(pdev->devfn));
+	ret = request_irq(pdev->irq, adf_isr, 0, accel_dev->vf.irq_name,
+			  (void *)accel_dev);
+	if (ret) {
+		dev_err(&GET_DEV(accel_dev), "failed to enable irq for %s\n",
+			accel_dev->vf.irq_name);
+		return ret;
+	}
+	cpu = accel_dev->accel_id % num_online_cpus();
+	irq_set_affinity_hint(pdev->irq, get_cpu_mask(cpu));
+
+	return ret;
+}
+
+static int adf_setup_bh(struct adf_accel_dev *accel_dev)
+{
+	struct adf_etr_data *priv_data = accel_dev->transport;
+
+	tasklet_init(&priv_data->banks[0].resp_handler, adf_response_handler,
+		     (unsigned long)priv_data->banks);
+	return 0;
+}
+
+static void adf_cleanup_bh(struct adf_accel_dev *accel_dev)
+{
+	struct adf_etr_data *priv_data = accel_dev->transport;
+
+	tasklet_disable(&priv_data->banks[0].resp_handler);
+	tasklet_kill(&priv_data->banks[0].resp_handler);
+}
+
+void adf_isr_resource_free(struct adf_accel_dev *accel_dev)
+{
+	struct pci_dev *pdev = accel_to_pci_dev(accel_dev);
+
+	irq_set_affinity_hint(pdev->irq, NULL);
+	free_irq(pdev->irq, (void *)accel_dev);
+	adf_cleanup_bh(accel_dev);
+	adf_cleanup_pf2vf_bh(accel_dev);
+	adf_disable_msi(accel_dev);
+}
+
+int adf_isr_resource_alloc(struct adf_accel_dev *accel_dev)
+{
+	if (adf_enable_msi(accel_dev))
+		goto err_out;
+
+	if (adf_setup_pf2vf_bh(accel_dev))
+		goto err_out;
+
+	if (adf_setup_bh(accel_dev))
+		goto err_out;
+
+	if (adf_request_msi_irq(accel_dev))
+		goto err_out;
+
+	return 0;
+err_out:
+	adf_isr_resource_free(accel_dev);
+	return -EFAULT;
+}
