From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 4/7] crypto: qat - add support for c3xxx accel type
Date: Fri, 04 Dec 2015 16:56:34 -0800
Message-ID: <20151205005634.27411.61563.stgit@tstruk-mobl1>
References: <20151205005612.27411.60451.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, pingchao.yang@intel.com,
	qat-linux@intel.com, tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20270 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932092AbbLEA7o (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Dec 2015 19:59:44 -0500
In-Reply-To: <20151205005612.27411.60451.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add support for c3xxx accel type.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/Kconfig                       |   11 +
 drivers/crypto/qat/Makefile                      |    1 
 drivers/crypto/qat/qat_c3xxx/Makefile            |    3 
 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c |  248 ++++++++++++++++
 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h |   84 ++++++
 drivers/crypto/qat/qat_c3xxx/adf_drv.c           |  335 ++++++++++++++++++++++
 drivers/crypto/qat/qat_common/adf_cfg_common.h   |    1 
 drivers/crypto/qat/qat_common/adf_dev_mgr.c      |   36 ++
 8 files changed, 714 insertions(+), 5 deletions(-)
 create mode 100644 drivers/crypto/qat/qat_c3xxx/Makefile
 create mode 100644 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
 create mode 100644 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h
 create mode 100644 drivers/crypto/qat/qat_c3xxx/adf_drv.c

diff --git a/drivers/crypto/qat/Kconfig b/drivers/crypto/qat/Kconfig
index eefccf7..7b3e791 100644
--- a/drivers/crypto/qat/Kconfig
+++ b/drivers/crypto/qat/Kconfig
@@ -22,6 +22,17 @@ config CRYPTO_DEV_QAT_DH895xCC
 	  To compile this as a module, choose M here: the module
 	  will be called qat_dh895xcc.
 
+config CRYPTO_DEV_QAT_C3XXX
+	tristate "Support for Intel(R) C3XXX"
+	depends on X86 && PCI
+	select CRYPTO_DEV_QAT
+	help
+	  Support for Intel(R) C3xxx with Intel(R) QuickAssist Technology
+	  for accelerating crypto and compression workloads.
+
+	  To compile this as a module, choose M here: the module
+	  will be called qat_c3xxx.
+
 config CRYPTO_DEV_QAT_DH895xCCVF
 	tristate "Support for Intel(R) DH895xCC Virtual Function"
 	depends on X86 && PCI
diff --git a/drivers/crypto/qat/Makefile b/drivers/crypto/qat/Makefile
index a3ce0b7..e08d660 100644
--- a/drivers/crypto/qat/Makefile
+++ b/drivers/crypto/qat/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_CRYPTO_DEV_QAT) += qat_common/
 obj-$(CONFIG_CRYPTO_DEV_QAT_DH895xCC) += qat_dh895xcc/
+obj-$(CONFIG_CRYPTO_DEV_QAT_C3XXX) += qat_c3xxx/
 obj-$(CONFIG_CRYPTO_DEV_QAT_DH895xCCVF) += qat_dh895xccvf/
diff --git a/drivers/crypto/qat/qat_c3xxx/Makefile b/drivers/crypto/qat/qat_c3xxx/Makefile
new file mode 100644
index 0000000..8f5fd48
--- /dev/null
+++ b/drivers/crypto/qat/qat_c3xxx/Makefile
@@ -0,0 +1,3 @@
+ccflags-y := -I$(src)/../qat_common
+obj-$(CONFIG_CRYPTO_DEV_QAT_C3XXX) += qat_c3xxx.o
+qat_c3xxx-objs := adf_drv.o adf_c3xxx_hw_data.o
diff --git a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
new file mode 100644
index 0000000..bda8f9f
--- /dev/null
+++ b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
@@ -0,0 +1,248 @@
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
+	* Redistributions of source code must retain the above copyright
+	  notice, this list of conditions and the following disclaimer.
+	* Redistributions in binary form must reproduce the above copyright
+	  notice, this list of conditions and the following disclaimer in
+	  the documentation and/or other materials provided with the
+	  distribution.
+	* Neither the name of Intel Corporation nor the names of its
+	  contributors may be used to endorse or promote products derived
+	  from this software without specific prior written permission.
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
+#include <adf_common_drv.h>
+#include <adf_pf2vf_msg.h>
+#include "adf_c3xxx_hw_data.h"
+
+/* Worker thread to service arbiter mappings based on dev SKUs */
+static const u32 thrd_to_arb_map_8_me_sku[] = {
+	0x10000888, 0x11000888, 0x10000888, 0x11000888, 0x10000888,
+	0x11000888, 0x10000888, 0x11000888, 0, 0
+};
+
+static const u32 thrd_to_arb_map_10_me_sku[] = {
+	0x12222AAA, 0x11222AAA, 0x12222AAA, 0x11222AAA, 0x12222AAA,
+	0x11222AAA, 0x12222AAA, 0x11222AAA, 0x12222AAA, 0x11222AAA
+};
+
+static struct adf_hw_device_class c3xxx_class = {
+	.name = ADF_C3XXX_DEVICE_NAME,
+	.type = DEV_C3XXX,
+	.instances = 0
+};
+
+static u32 get_accel_mask(u32 fuse)
+{
+	return (~fuse) >> ADF_C3XXX_ACCELERATORS_REG_OFFSET &
+		ADF_C3XXX_ACCELERATORS_MASK;
+}
+
+static u32 get_ae_mask(u32 fuse)
+{
+	return (~fuse) & ADF_C3XXX_ACCELENGINES_MASK;
+}
+
+static u32 get_num_accels(struct adf_hw_device_data *self)
+{
+	u32 i, ctr = 0;
+
+	if (!self || !self->accel_mask)
+		return 0;
+
+	for (i = 0; i < ADF_C3XXX_MAX_ACCELERATORS; i++) {
+		if (self->accel_mask & (1 << i))
+			ctr++;
+	}
+	return ctr;
+}
+
+static u32 get_num_aes(struct adf_hw_device_data *self)
+{
+	u32 i, ctr = 0;
+
+	if (!self || !self->ae_mask)
+		return 0;
+
+	for (i = 0; i < ADF_C3XXX_MAX_ACCELENGINES; i++) {
+		if (self->ae_mask & (1 << i))
+			ctr++;
+	}
+	return ctr;
+}
+
+static u32 get_misc_bar_id(struct adf_hw_device_data *self)
+{
+	return ADF_C3XXX_PMISC_BAR;
+}
+
+static u32 get_etr_bar_id(struct adf_hw_device_data *self)
+{
+	return ADF_C3XXX_ETR_BAR;
+}
+
+static u32 get_sram_bar_id(struct adf_hw_device_data *self)
+{
+	return ADF_C3XXX_SRAM_BAR;
+}
+
+static enum dev_sku_info get_sku(struct adf_hw_device_data *self)
+{
+	int aes = get_num_aes(self);
+
+	if (aes == 8)
+		return DEV_SKU_2;
+	else if (aes == 10)
+		return DEV_SKU_4;
+
+	return DEV_SKU_UNKNOWN;
+}
+
+static void adf_get_arbiter_mapping(struct adf_accel_dev *accel_dev,
+				    u32 const **arb_map_config)
+{
+	switch (accel_dev->accel_pci_dev.sku) {
+	case DEV_SKU_2:
+		*arb_map_config = thrd_to_arb_map_8_me_sku;
+		break;
+	case DEV_SKU_4:
+		*arb_map_config = thrd_to_arb_map_10_me_sku;
+		break;
+	default:
+		dev_err(&GET_DEV(accel_dev),
+			"The configuration doesn't match any SKU");
+		*arb_map_config = NULL;
+	}
+}
+
+static u32 get_pf2vf_offset(u32 i)
+{
+	return ADF_C3XXX_PF2VF_OFFSET(i);
+}
+
+static u32 get_vintmsk_offset(u32 i)
+{
+	return ADF_C3XXX_VINTMSK_OFFSET(i);
+}
+
+static void adf_enable_error_correction(struct adf_accel_dev *accel_dev)
+{
+	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
+	struct adf_bar *misc_bar = &GET_BARS(accel_dev)[ADF_C3XXX_PMISC_BAR];
+	void __iomem *csr = misc_bar->virt_addr;
+	unsigned int val, i;
+
+	/* Enable Accel Engine error detection & correction */
+	for (i = 0; i < hw_device->get_num_aes(hw_device); i++) {
+		val = ADF_CSR_RD(csr, ADF_C3XXX_AE_CTX_ENABLES(i));
+		val |= ADF_C3XXX_ENABLE_AE_ECC_ERR;
+		ADF_CSR_WR(csr, ADF_C3XXX_AE_CTX_ENABLES(i), val);
+		val = ADF_CSR_RD(csr, ADF_C3XXX_AE_MISC_CONTROL(i));
+		val |= ADF_C3XXX_ENABLE_AE_ECC_PARITY_CORR;
+		ADF_CSR_WR(csr, ADF_C3XXX_AE_MISC_CONTROL(i), val);
+	}
+
+	/* Enable shared memory error detection & correction */
+	for (i = 0; i < hw_device->get_num_accels(hw_device); i++) {
+		val = ADF_CSR_RD(csr, ADF_C3XXX_UERRSSMSH(i));
+		val |= ADF_C3XXX_ERRSSMSH_EN;
+		ADF_CSR_WR(csr, ADF_C3XXX_UERRSSMSH(i), val);
+		val = ADF_CSR_RD(csr, ADF_C3XXX_CERRSSMSH(i));
+		val |= ADF_C3XXX_ERRSSMSH_EN;
+		ADF_CSR_WR(csr, ADF_C3XXX_CERRSSMSH(i), val);
+	}
+}
+
+static void adf_enable_ints(struct adf_accel_dev *accel_dev)
+{
+	void __iomem *addr;
+
+	addr = (&GET_BARS(accel_dev)[ADF_C3XXX_PMISC_BAR])->virt_addr;
+
+	/* Enable bundle and misc interrupts */
+	ADF_CSR_WR(addr, ADF_C3XXX_SMIAPF0_MASK_OFFSET,
+		   ADF_C3XXX_SMIA0_MASK);
+	ADF_CSR_WR(addr, ADF_C3XXX_SMIAPF1_MASK_OFFSET,
+		   ADF_C3XXX_SMIA1_MASK);
+}
+
+static int adf_pf_enable_vf2pf_comms(struct adf_accel_dev *accel_dev)
+{
+	return 0;
+}
+
+void adf_init_hw_data_c3xxx(struct adf_hw_device_data *hw_data)
+{
+	hw_data->dev_class = &c3xxx_class;
+	hw_data->instance_id = c3xxx_class.instances++;
+	hw_data->num_banks = ADF_C3XXX_ETR_MAX_BANKS;
+	hw_data->num_accel = ADF_C3XXX_MAX_ACCELERATORS;
+	hw_data->num_logical_accel = 1;
+	hw_data->num_engines = ADF_C3XXX_MAX_ACCELENGINES;
+	hw_data->tx_rx_gap = ADF_C3XXX_RX_RINGS_OFFSET;
+	hw_data->tx_rings_mask = ADF_C3XXX_TX_RINGS_MASK;
+	hw_data->alloc_irq = adf_isr_resource_alloc;
+	hw_data->free_irq = adf_isr_resource_free;
+	hw_data->enable_error_correction = adf_enable_error_correction;
+	hw_data->get_accel_mask = get_accel_mask;
+	hw_data->get_ae_mask = get_ae_mask;
+	hw_data->get_num_accels = get_num_accels;
+	hw_data->get_num_aes = get_num_aes;
+	hw_data->get_sram_bar_id = get_sram_bar_id;
+	hw_data->get_etr_bar_id = get_etr_bar_id;
+	hw_data->get_misc_bar_id = get_misc_bar_id;
+	hw_data->get_pf2vf_offset = get_pf2vf_offset;
+	hw_data->get_vintmsk_offset = get_vintmsk_offset;
+	hw_data->get_sku = get_sku;
+	hw_data->fw_name = ADF_C3XXX_FW;
+	hw_data->fw_mmp_name = ADF_C3XXX_MMP;
+	hw_data->init_admin_comms = adf_init_admin_comms;
+	hw_data->exit_admin_comms = adf_exit_admin_comms;
+	hw_data->disable_iov = adf_disable_sriov;
+	hw_data->send_admin_init = adf_send_admin_init;
+	hw_data->init_arb = adf_init_arb;
+	hw_data->exit_arb = adf_exit_arb;
+	hw_data->get_arb_mapping = adf_get_arbiter_mapping;
+	hw_data->enable_ints = adf_enable_ints;
+	hw_data->enable_vf2pf_comms = adf_pf_enable_vf2pf_comms;
+	hw_data->min_iov_compat_ver = ADF_PFVF_COMPATIBILITY_VERSION;
+}
+
+void adf_clean_hw_data_c3xxx(struct adf_hw_device_data *hw_data)
+{
+	hw_data->dev_class->instances--;
+}
diff --git a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h
new file mode 100644
index 0000000..f2fa234
--- /dev/null
+++ b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h
@@ -0,0 +1,84 @@
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
+#ifndef ADF_C3XXX_HW_DATA_H_
+#define ADF_C3XXX_HW_DATA_H_
+
+/* PCIe configuration space */
+#define ADF_C3XXX_SRAM_BAR 0
+#define ADF_C3XXX_PMISC_BAR 1
+#define ADF_C3XXX_ETR_BAR 2
+#define ADF_C3XXX_RX_RINGS_OFFSET 8
+#define ADF_C3XXX_TX_RINGS_MASK 0xFF
+#define ADF_C3XXX_MAX_ACCELERATORS 3
+#define ADF_C3XXX_MAX_ACCELENGINES 6
+#define ADF_C3XXX_ACCELERATORS_REG_OFFSET 16
+#define ADF_C3XXX_ACCELERATORS_MASK 0x3
+#define ADF_C3XXX_ACCELENGINES_MASK 0x3F
+#define ADF_C3XXX_ETR_MAX_BANKS 16
+#define ADF_C3XXX_SMIAPF0_MASK_OFFSET (0x3A000 + 0x28)
+#define ADF_C3XXX_SMIAPF1_MASK_OFFSET (0x3A000 + 0x30)
+#define ADF_C3XXX_SMIA0_MASK 0xFFFF
+#define ADF_C3XXX_SMIA1_MASK 0x1
+/* Error detection and correction */
+#define ADF_C3XXX_AE_CTX_ENABLES(i) (i * 0x1000 + 0x20818)
+#define ADF_C3XXX_AE_MISC_CONTROL(i) (i * 0x1000 + 0x20960)
+#define ADF_C3XXX_ENABLE_AE_ECC_ERR BIT(28)
+#define ADF_C3XXX_ENABLE_AE_ECC_PARITY_CORR (BIT(24) | BIT(12))
+#define ADF_C3XXX_UERRSSMSH(i) (i * 0x4000 + 0x18)
+#define ADF_C3XXX_CERRSSMSH(i) (i * 0x4000 + 0x10)
+#define ADF_C3XXX_ERRSSMSH_EN BIT(3)
+
+#define ADF_C3XXX_PF2VF_OFFSET(i)	(0x3A000 + 0x280 + ((i) * 0x04))
+#define ADF_C3XXX_VINTMSK_OFFSET(i)	(0x3A000 + 0x200 + ((i) * 0x04))
+
+/* Firmware Binary */
+#define ADF_C3XXX_FW "qat_c3xxx.bin"
+#define ADF_C3XXX_MMP "qat_c3xxx_mmp.bin"
+
+void adf_init_hw_data_c3xxx(struct adf_hw_device_data *hw_data);
+void adf_clean_hw_data_c3xxx(struct adf_hw_device_data *hw_data);
+#endif
diff --git a/drivers/crypto/qat/qat_c3xxx/adf_drv.c b/drivers/crypto/qat/qat_c3xxx/adf_drv.c
new file mode 100644
index 0000000..e13bd08
--- /dev/null
+++ b/drivers/crypto/qat/qat_c3xxx/adf_drv.c
@@ -0,0 +1,335 @@
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
+#include "adf_c3xxx_hw_data.h"
+
+#define ADF_SYSTEM_DEVICE(device_id) \
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, device_id)}
+
+static const struct pci_device_id adf_pci_tbl[] = {
+	ADF_SYSTEM_DEVICE(ADF_C3XXX_PCI_DEVICE_ID),
+	{0,}
+};
+MODULE_DEVICE_TABLE(pci, adf_pci_tbl);
+
+static int adf_probe(struct pci_dev *dev, const struct pci_device_id *ent);
+static void adf_remove(struct pci_dev *dev);
+
+static struct pci_driver adf_driver = {
+	.id_table = adf_pci_tbl,
+	.name = ADF_C3XXX_DEVICE_NAME,
+	.probe = adf_probe,
+	.remove = adf_remove,
+	.sriov_configure = adf_sriov_configure,
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
+		case ADF_C3XXX_PCI_DEVICE_ID:
+			adf_clean_hw_data_c3xxx(accel_dev->hw_device);
+			break;
+		default:
+			break;
+		}
+		kfree(accel_dev->hw_device);
+		accel_dev->hw_device = NULL;
+	}
+	adf_cfg_dev_remove(accel_dev);
+	debugfs_remove(accel_dev->debugfs_dir);
+	adf_devmgr_rm_dev(accel_dev, NULL);
+}
+
+static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	struct adf_accel_dev *accel_dev;
+	struct adf_accel_pci *accel_pci_dev;
+	struct adf_hw_device_data *hw_data;
+	char name[ADF_DEVICE_NAME_LENGTH];
+	unsigned int i, bar_nr;
+	int ret, bar_mask;
+
+	switch (ent->device) {
+	case ADF_C3XXX_PCI_DEVICE_ID:
+		break;
+	default:
+		dev_err(&pdev->dev, "Invalid device 0x%x.\n", ent->device);
+		return -ENODEV;
+	}
+
+	if (num_possible_nodes() > 1 && dev_to_node(&pdev->dev) < 0) {
+		/* If the accelerator is connected to a node with no memory
+		 * there is no point in using the accelerator since the remote
+		 * memory transaction will be very slow. */
+		dev_err(&pdev->dev, "Invalid NUMA configuration.\n");
+		return -EINVAL;
+	}
+
+	accel_dev = kzalloc_node(sizeof(*accel_dev), GFP_KERNEL,
+				 dev_to_node(&pdev->dev));
+	if (!accel_dev)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&accel_dev->crypto_list);
+	accel_pci_dev = &accel_dev->accel_pci_dev;
+	accel_pci_dev->pci_dev = pdev;
+
+	/* Add accel device to accel table.
+	 * This should be called before adf_cleanup_accel is called */
+	if (adf_devmgr_add_dev(accel_dev, NULL)) {
+		dev_err(&pdev->dev, "Failed to add new accelerator device.\n");
+		kfree(accel_dev);
+		return -EFAULT;
+	}
+
+	accel_dev->owner = THIS_MODULE;
+	/* Allocate and configure device configuration structure */
+	hw_data = kzalloc_node(sizeof(*hw_data), GFP_KERNEL,
+			       dev_to_node(&pdev->dev));
+	if (!hw_data) {
+		ret = -ENOMEM;
+		goto out_err;
+	}
+
+	accel_dev->hw_device = hw_data;
+	adf_init_hw_data_c3xxx(accel_dev->hw_device);
+	pci_read_config_byte(pdev, PCI_REVISION_ID, &accel_pci_dev->revid);
+	pci_read_config_dword(pdev, ADF_DEVICE_FUSECTL_OFFSET,
+			      &hw_data->fuses);
+
+	/* Get Accelerators and Accelerators Engines masks */
+	hw_data->accel_mask = hw_data->get_accel_mask(hw_data->fuses);
+	hw_data->ae_mask = hw_data->get_ae_mask(hw_data->fuses);
+	accel_pci_dev->sku = hw_data->get_sku(hw_data);
+	/* If the device has no acceleration engines then ignore it. */
+	if (!hw_data->accel_mask || !hw_data->ae_mask ||
+	    ((~hw_data->ae_mask) & 0x01)) {
+		dev_err(&pdev->dev, "No acceleration units found");
+		ret = -EFAULT;
+		goto out_err;
+	}
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
+	if (pci_request_regions(pdev, ADF_C3XXX_DEVICE_NAME)) {
+		ret = -EFAULT;
+		goto out_err_disable;
+	}
+
+	/* Read accelerator capabilities mask */
+	pci_read_config_dword(pdev, ADF_DEVICE_LEGFUSE_OFFSET,
+			      &hw_data->accel_capabilities_mask);
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
+
+	if (adf_enable_aer(accel_dev, &adf_driver)) {
+		dev_err(&pdev->dev, "Failed to enable aer\n");
+		ret = -EFAULT;
+		goto out_err_free_reg;
+	}
+
+	if (pci_save_state(pdev)) {
+		dev_err(&pdev->dev, "Failed to save pci state\n");
+		ret = -ENOMEM;
+		goto out_err_free_reg;
+	}
+
+	ret = qat_crypto_dev_config(accel_dev);
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
+	adf_disable_aer(accel_dev);
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
+}
+
+module_init(adfdrv_init);
+module_exit(adfdrv_release);
+
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_AUTHOR("Intel");
+MODULE_DESCRIPTION("Intel(R) QuickAssist Technology");
+MODULE_VERSION(ADF_DRV_VERSION);
diff --git a/drivers/crypto/qat/qat_common/adf_cfg_common.h b/drivers/crypto/qat/qat_common/adf_cfg_common.h
index c697fb1..39884c9 100644
--- a/drivers/crypto/qat/qat_common/adf_cfg_common.h
+++ b/drivers/crypto/qat/qat_common/adf_cfg_common.h
@@ -72,6 +72,7 @@ enum adf_device_type {
 	DEV_UNKNOWN = 0,
 	DEV_DH895XCC,
 	DEV_DH895XCCVF,
+	DEV_C3XXX
 };
 
 struct adf_dev_status_info {
diff --git a/drivers/crypto/qat/qat_common/adf_dev_mgr.c b/drivers/crypto/qat/qat_common/adf_dev_mgr.c
index 8dfdb8f..b3ebb25 100644
--- a/drivers/crypto/qat/qat_common/adf_dev_mgr.c
+++ b/drivers/crypto/qat/qat_common/adf_dev_mgr.c
@@ -53,6 +53,7 @@ static LIST_HEAD(accel_table);
 static LIST_HEAD(vfs_table);
 static DEFINE_MUTEX(table_lock);
 static uint32_t num_devices;
+static u8 id_map[ADF_MAX_DEVICES];
 
 struct vf_id_map {
 	u32 bdf;
@@ -116,8 +117,10 @@ void adf_clean_vf_map(bool vf)
 	mutex_lock(&table_lock);
 	list_for_each_safe(ptr, tmp, &vfs_table) {
 		map = list_entry(ptr, struct vf_id_map, list);
-		if (map->bdf != -1)
+		if (map->bdf != -1) {
+			id_map[map->id] = 0;
 			num_devices--;
+		}
 
 		if (vf && map->bdf == -1)
 			continue;
@@ -154,6 +157,19 @@ void adf_devmgr_update_class_index(struct adf_hw_device_data *hw_data)
 }
 EXPORT_SYMBOL_GPL(adf_devmgr_update_class_index);
 
+static unsigned int adf_find_free_id(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < ADF_MAX_DEVICES; i++) {
+		if (!id_map[i]) {
+			id_map[i] = 1;
+			return i;
+		}
+	}
+	return ADF_MAX_DEVICES + 1;
+}
+
 /**
  * adf_devmgr_add_dev() - Add accel_dev to the acceleration framework
  * @accel_dev:  Pointer to acceleration device.
@@ -194,8 +210,12 @@ int adf_devmgr_add_dev(struct adf_accel_dev *accel_dev,
 		}
 
 		list_add_tail(&accel_dev->list, &accel_table);
-		accel_dev->accel_id = num_devices++;
-
+		accel_dev->accel_id = adf_find_free_id();
+		if (accel_dev->accel_id > ADF_MAX_DEVICES) {
+			ret = -EFAULT;
+			goto unlock;
+		}
+		num_devices++;
 		map = kzalloc(sizeof(*map), GFP_KERNEL);
 		if (!map) {
 			ret = -ENOMEM;
@@ -236,8 +256,13 @@ int adf_devmgr_add_dev(struct adf_accel_dev *accel_dev,
 			ret = -ENOMEM;
 			goto unlock;
 		}
-
-		accel_dev->accel_id = num_devices++;
+		accel_dev->accel_id = adf_find_free_id();
+		if (accel_dev->accel_id > ADF_MAX_DEVICES) {
+			kfree(map);
+			ret = -EFAULT;
+			goto unlock;
+		}
+		num_devices++;
 		list_add_tail(&accel_dev->list, &accel_table);
 		map->bdf = adf_get_vf_num(accel_dev);
 		map->id = accel_dev->accel_id;
@@ -271,6 +296,7 @@ void adf_devmgr_rm_dev(struct adf_accel_dev *accel_dev,
 {
 	mutex_lock(&table_lock);
 	if (!accel_dev->is_vf || (accel_dev->is_vf && !pf)) {
+		id_map[accel_dev->accel_id] = 0;
 		num_devices--;
 	} else if (accel_dev->is_vf && pf) {
 		struct vf_id_map *map, *next;
