From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 3/7] crypto: qat - move isr files to qat common so that they
 can be reused
Date: Fri, 04 Dec 2015 16:56:28 -0800
Message-ID: <20151205005628.27411.93867.stgit@tstruk-mobl1>
References: <20151205005612.27411.60451.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, pingchao.yang@intel.com,
	qat-linux@intel.com, tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:47088 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932085AbbLEA7j (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Dec 2015 19:59:39 -0500
In-Reply-To: <20151205005612.27411.60451.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Move qat_isr.c and qat_isrvf.c files to qat_common dir
so that they can be reused by all devices.
Remove adf_drv.h files because thay are not longer needed.
Move adf_dev_configure() function to qat_common so it can be reused.
Also some minor updates to common code for multidevice.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/Makefile             |    2 
 drivers/crypto/qat/qat_common/adf_accel_devices.h  |    4 
 drivers/crypto/qat/qat_common/adf_admin.c          |    4 
 drivers/crypto/qat/qat_common/adf_aer.c            |    2 
 drivers/crypto/qat/qat_common/adf_common_drv.h     |    9 -
 drivers/crypto/qat/qat_common/adf_ctl_drv.c        |    8 
 drivers/crypto/qat/qat_common/adf_hw_arbiter.c     |    8 
 drivers/crypto/qat/qat_common/adf_init.c           |   21 -
 drivers/crypto/qat/qat_common/adf_isr.c            |  348 ++++++++++++++++++++
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c      |   23 -
 drivers/crypto/qat/qat_common/adf_transport.c      |   20 -
 .../crypto/qat/qat_common/adf_transport_internal.h |    2 
 drivers/crypto/qat/qat_common/adf_vf_isr.c         |  280 ++++++++++++++++
 drivers/crypto/qat/qat_common/qat_crypto.c         |   92 +++++
 drivers/crypto/qat/qat_dh895xcc/Makefile           |    4 
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c |    5 
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h |    7 
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c          |   95 -----
 drivers/crypto/qat/qat_dh895xcc/adf_drv.h          |   58 ---
 drivers/crypto/qat/qat_dh895xcc/adf_isr.c          |  332 -------------------
 drivers/crypto/qat/qat_dh895xccvf/Makefile         |    4 
 .../qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c    |    5 
 .../qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.h    |   10 -
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c        |   87 -----
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.h        |   57 ---
 drivers/crypto/qat/qat_dh895xccvf/adf_isr.c        |  258 ---------------
 26 files changed, 768 insertions(+), 977 deletions(-)
 create mode 100644 drivers/crypto/qat/qat_common/adf_isr.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_vf_isr.c
 delete mode 100644 drivers/crypto/qat/qat_dh895xcc/adf_drv.h
 delete mode 100644 drivers/crypto/qat/qat_dh895xcc/adf_isr.c
 delete mode 100644 drivers/crypto/qat/qat_dh895xccvf/adf_drv.h
 delete mode 100644 drivers/crypto/qat/qat_dh895xccvf/adf_isr.c

diff --git a/drivers/crypto/qat/qat_common/Makefile b/drivers/crypto/qat/qat_common/Makefile
index 12f40a3..29c7c53 100644
--- a/drivers/crypto/qat/qat_common/Makefile
+++ b/drivers/crypto/qat/qat_common/Makefile
@@ -8,6 +8,8 @@ clean-files += qat_rsaprivkey-asn1.c qat_rsaprivkey-asn1.h
 
 obj-$(CONFIG_CRYPTO_DEV_QAT) += intel_qat.o
 intel_qat-objs := adf_cfg.o \
+	adf_isr.o \
+	adf_vf_isr.o \
 	adf_ctl_drv.o \
 	adf_dev_mgr.o \
 	adf_init.o \
diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 9786a2e..4d78ec0 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -67,6 +67,8 @@
 #define ADF_C3XXXIOV_PCI_DEVICE_ID 0x19e3
 #define ADF_ERRSOU3 (0x3A000 + 0x0C)
 #define ADF_ERRSOU5 (0x3A000 + 0xD8)
+#define ADF_DEVICE_FUSECTL_OFFSET 0x40
+#define ADF_DEVICE_LEGFUSE_OFFSET 0x4C
 #define ADF_PCI_MAX_BARS 3
 #define ADF_DEVICE_NAME_LENGTH 32
 #define ADF_ETR_MAX_RINGS_PER_BANK 16
@@ -178,11 +180,11 @@ struct adf_hw_device_data {
 	const char *fw_mmp_name;
 	uint32_t fuses;
 	uint32_t accel_capabilities_mask;
+	uint32_t instance_id;
 	uint16_t accel_mask;
 	uint16_t ae_mask;
 	uint16_t tx_rings_mask;
 	uint8_t tx_rx_gap;
-	uint8_t instance_id;
 	uint8_t num_banks;
 	uint8_t num_accel;
 	uint8_t num_logical_accel;
diff --git a/drivers/crypto/qat/qat_common/adf_admin.c b/drivers/crypto/qat/qat_common/adf_admin.c
index 147d755..eb557f6 100644
--- a/drivers/crypto/qat/qat_common/adf_admin.c
+++ b/drivers/crypto/qat/qat_common/adf_admin.c
@@ -51,6 +51,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include "adf_accel_devices.h"
+#include "adf_common_drv.h"
 #include "icp_qat_fw_init_admin.h"
 
 /* Admin Messages Registers */
@@ -234,7 +235,8 @@ int adf_init_admin_comms(struct adf_accel_dev *accel_dev)
 	struct adf_bar *pmisc =
 		&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
 	void __iomem *csr = pmisc->virt_addr;
-	void __iomem *mailbox = csr + ADF_DH895XCC_MAILBOX_BASE_OFFSET;
+	void __iomem *mailbox = (void __iomem *)((uintptr_t)csr +
+				 ADF_DH895XCC_MAILBOX_BASE_OFFSET);
 	u64 reg_val;
 
 	admin = kzalloc_node(sizeof(*accel_dev->admin), GFP_KERNEL,
diff --git a/drivers/crypto/qat/qat_common/adf_aer.c b/drivers/crypto/qat/qat_common/adf_aer.c
index d24cfd4..e78a1d7 100644
--- a/drivers/crypto/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/qat/qat_common/adf_aer.c
@@ -82,7 +82,7 @@ struct adf_reset_dev_data {
 	struct work_struct reset_work;
 };
 
-static void adf_dev_restore(struct adf_accel_dev *accel_dev)
+void adf_dev_restore(struct adf_accel_dev *accel_dev)
 {
 	struct pci_dev *pdev = accel_to_pci_dev(accel_dev);
 	struct pci_dev *parent = pdev->bus->self;
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index d482022..c03e286 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -54,7 +54,7 @@
 #include "icp_qat_hal.h"
 
 #define ADF_MAJOR_VERSION	0
-#define ADF_MINOR_VERSION	2
+#define ADF_MINOR_VERSION	6
 #define ADF_BUILD_VERSION	0
 #define ADF_DRV_VERSION		__stringify(ADF_MAJOR_VERSION) "." \
 				__stringify(ADF_MINOR_VERSION) "." \
@@ -143,6 +143,7 @@ int adf_ae_stop(struct adf_accel_dev *accel_dev);
 
 int adf_enable_aer(struct adf_accel_dev *accel_dev, struct pci_driver *adf);
 void adf_disable_aer(struct adf_accel_dev *accel_dev);
+void adf_dev_restore(struct adf_accel_dev *accel_dev);
 int adf_init_aer(void);
 void adf_exit_aer(void);
 int adf_init_admin_comms(struct adf_accel_dev *accel_dev);
@@ -159,6 +160,7 @@ int adf_init_etr_data(struct adf_accel_dev *accel_dev);
 void adf_cleanup_etr_data(struct adf_accel_dev *accel_dev);
 int qat_crypto_register(void);
 int qat_crypto_unregister(void);
+int qat_crypto_dev_config(struct adf_accel_dev *accel_dev);
 struct qat_crypto_instance *qat_crypto_get_instance_node(int node);
 void qat_crypto_put_instance(struct qat_crypto_instance *inst);
 void qat_alg_callback(void *resp);
@@ -168,6 +170,11 @@ void qat_algs_unregister(void);
 int qat_asym_algs_register(void);
 void qat_asym_algs_unregister(void);
 
+int adf_isr_resource_alloc(struct adf_accel_dev *accel_dev);
+void adf_isr_resource_free(struct adf_accel_dev *accel_dev);
+int adf_vf_isr_resource_alloc(struct adf_accel_dev *accel_dev);
+void adf_vf_isr_resource_free(struct adf_accel_dev *accel_dev);
+
 int qat_hal_init(struct adf_accel_dev *accel_dev);
 void qat_hal_deinit(struct icp_qat_fw_loader_handle *handle);
 void qat_hal_start(struct icp_qat_fw_loader_handle *handle, unsigned char ae,
diff --git a/drivers/crypto/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
index bd8dfa1..2e6d0c5 100644
--- a/drivers/crypto/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
@@ -198,7 +198,7 @@ static int adf_copy_key_value_data(struct adf_accel_dev *accel_dev,
 			goto out_err;
 		}
 
-		params_head = section_head->params;
+		params_head = section.params;
 
 		while (params_head) {
 			if (copy_from_user(&key_val, (void __user *)params_head,
@@ -342,12 +342,10 @@ static int adf_ctl_ioctl_dev_start(struct file *fp, unsigned int cmd,
 	if (ret)
 		return ret;
 
+	ret = -ENODEV;
 	accel_dev = adf_devmgr_get_dev_by_id(ctl_data->device_id);
-	if (!accel_dev) {
-		pr_err("QAT: Device %d not found\n", ctl_data->device_id);
-		ret = -ENODEV;
+	if (!accel_dev)
 		goto out;
-	}
 
 	if (!adf_dev_started(accel_dev)) {
 		dev_info(&GET_DEV(accel_dev),
diff --git a/drivers/crypto/qat/qat_common/adf_hw_arbiter.c b/drivers/crypto/qat/qat_common/adf_hw_arbiter.c
index 6849422..f267d9e 100644
--- a/drivers/crypto/qat/qat_common/adf_hw_arbiter.c
+++ b/drivers/crypto/qat/qat_common/adf_hw_arbiter.c
@@ -45,6 +45,7 @@
   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
 #include "adf_accel_devices.h"
+#include "adf_common_drv.h"
 #include "adf_transport_internal.h"
 
 #define ADF_ARB_NUM 4
@@ -124,19 +125,12 @@ int adf_init_arb(struct adf_accel_dev *accel_dev)
 }
 EXPORT_SYMBOL_GPL(adf_init_arb);
 
-/**
- * adf_update_ring_arb() - update ring arbitration rgister
- * @accel_dev:  Pointer to ring data.
- *
- * Function enables or disables rings for/from arbitration.
- */
 void adf_update_ring_arb(struct adf_etr_ring_data *ring)
 {
 	WRITE_CSR_ARB_RINGSRVARBEN(ring->bank->csr_addr,
 				   ring->bank->bank_number,
 				   ring->bank->ring_mask & 0xFF);
 }
-EXPORT_SYMBOL_GPL(adf_update_ring_arb);
 
 void adf_exit_arb(struct adf_accel_dev *accel_dev)
 {
diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
index d873eee..ef5575e 100644
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -62,15 +62,6 @@ static void adf_service_add(struct service_hndl *service)
 	mutex_unlock(&service_lock);
 }
 
-/**
- * adf_service_register() - Register acceleration service in the accel framework
- * @service:    Pointer to the service
- *
- * Function adds the acceleration service to the acceleration framework.
- * To be used by QAT device specific drivers.
- *
- * Return: 0 on success, error code otherwise.
- */
 int adf_service_register(struct service_hndl *service)
 {
 	service->init_status = 0;
@@ -78,7 +69,6 @@ int adf_service_register(struct service_hndl *service)
 	adf_service_add(service);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(adf_service_register);
 
 static void adf_service_remove(struct service_hndl *service)
 {
@@ -87,15 +77,6 @@ static void adf_service_remove(struct service_hndl *service)
 	mutex_unlock(&service_lock);
 }
 
-/**
- * adf_service_unregister() - Unregister acceleration service from the framework
- * @service:    Pointer to the service
- *
- * Function remove the acceleration service from the acceleration framework.
- * To be used by QAT device specific drivers.
- *
- * Return: 0 on success, error code otherwise.
- */
 int adf_service_unregister(struct service_hndl *service)
 {
 	if (service->init_status || service->start_status) {
@@ -105,7 +86,6 @@ int adf_service_unregister(struct service_hndl *service)
 	adf_service_remove(service);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(adf_service_unregister);
 
 /**
  * adf_dev_init() - Init data structures and services for the given accel device
@@ -366,6 +346,7 @@ void adf_dev_shutdown(struct adf_accel_dev *accel_dev)
 
 	hw_data->disable_iov(accel_dev);
 	adf_cleanup_etr_data(accel_dev);
+	adf_dev_restore(accel_dev);
 }
 EXPORT_SYMBOL_GPL(adf_dev_shutdown);
 
diff --git a/drivers/crypto/qat/qat_common/adf_isr.c b/drivers/crypto/qat/qat_common/adf_isr.c
new file mode 100644
index 0000000..b81f79a
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_isr.c
@@ -0,0 +1,348 @@
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
+#include "adf_accel_devices.h"
+#include "adf_common_drv.h"
+#include "adf_cfg.h"
+#include "adf_cfg_strings.h"
+#include "adf_cfg_common.h"
+#include "adf_transport_access_macros.h"
+#include "adf_transport_internal.h"
+
+static int adf_enable_msix(struct adf_accel_dev *accel_dev)
+{
+	struct adf_accel_pci *pci_dev_info = &accel_dev->accel_pci_dev;
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	u32 msix_num_entries = 1;
+
+	/* If SR-IOV is disabled, add entries for each bank */
+	if (!accel_dev->pf.vf_info) {
+		int i;
+
+		msix_num_entries += hw_data->num_banks;
+		for (i = 0; i < msix_num_entries; i++)
+			pci_dev_info->msix_entries.entries[i].entry = i;
+	} else {
+		pci_dev_info->msix_entries.entries[0].entry =
+			hw_data->num_banks;
+	}
+
+	if (pci_enable_msix_exact(pci_dev_info->pci_dev,
+				  pci_dev_info->msix_entries.entries,
+				  msix_num_entries)) {
+		dev_err(&GET_DEV(accel_dev), "Failed to enable MSI-X IRQ(s)\n");
+		return -EFAULT;
+	}
+	return 0;
+}
+
+static void adf_disable_msix(struct adf_accel_pci *pci_dev_info)
+{
+	pci_disable_msix(pci_dev_info->pci_dev);
+}
+
+static irqreturn_t adf_msix_isr_bundle(int irq, void *bank_ptr)
+{
+	struct adf_etr_bank_data *bank = bank_ptr;
+
+	WRITE_CSR_INT_FLAG_AND_COL(bank->csr_addr, bank->bank_number, 0);
+	tasklet_hi_schedule(&bank->resp_handler);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t adf_msix_isr_ae(int irq, void *dev_ptr)
+{
+	struct adf_accel_dev *accel_dev = dev_ptr;
+
+#ifdef CONFIG_PCI_IOV
+	/* If SR-IOV is enabled (vf_info is non-NULL), check for VF->PF ints */
+	if (accel_dev->pf.vf_info) {
+		struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+		struct adf_bar *pmisc =
+			&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
+		void __iomem *pmisc_bar_addr = pmisc->virt_addr;
+		u32 vf_mask;
+
+		/* Get the interrupt sources triggered by VFs */
+		vf_mask = ((ADF_CSR_RD(pmisc_bar_addr, ADF_ERRSOU5) &
+			    0x0000FFFF) << 16) |
+			  ((ADF_CSR_RD(pmisc_bar_addr, ADF_ERRSOU3) &
+			    0x01FFFE00) >> 9);
+
+		if (vf_mask) {
+			struct adf_accel_vf_info *vf_info;
+			bool irq_handled = false;
+			int i;
+
+			/* Disable VF2PF interrupts for VFs with pending ints */
+			adf_disable_vf2pf_interrupts(accel_dev, vf_mask);
+
+			/*
+			 * Schedule tasklets to handle VF2PF interrupt BHs
+			 * unless the VF is malicious and is attempting to
+			 * flood the host OS with VF2PF interrupts.
+			 */
+			for_each_set_bit(i, (const unsigned long *)&vf_mask,
+					 (sizeof(vf_mask) * BITS_PER_BYTE)) {
+				vf_info = accel_dev->pf.vf_info + i;
+
+				if (!__ratelimit(&vf_info->vf2pf_ratelimit)) {
+					dev_info(&GET_DEV(accel_dev),
+						 "Too many ints from VF%d\n",
+						  vf_info->vf_nr + 1);
+					continue;
+				}
+
+				/* Tasklet will re-enable ints from this VF */
+				tasklet_hi_schedule(&vf_info->vf2pf_bh_tasklet);
+				irq_handled = true;
+			}
+
+			if (irq_handled)
+				return IRQ_HANDLED;
+		}
+	}
+#endif /* CONFIG_PCI_IOV */
+
+	dev_dbg(&GET_DEV(accel_dev), "qat_dev%d spurious AE interrupt\n",
+		accel_dev->accel_id);
+
+	return IRQ_NONE;
+}
+
+static int adf_request_irqs(struct adf_accel_dev *accel_dev)
+{
+	struct adf_accel_pci *pci_dev_info = &accel_dev->accel_pci_dev;
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct msix_entry *msixe = pci_dev_info->msix_entries.entries;
+	struct adf_etr_data *etr_data = accel_dev->transport;
+	int ret, i = 0;
+	char *name;
+
+	/* Request msix irq for all banks unless SR-IOV enabled */
+	if (!accel_dev->pf.vf_info) {
+		for (i = 0; i < hw_data->num_banks; i++) {
+			struct adf_etr_bank_data *bank = &etr_data->banks[i];
+			unsigned int cpu, cpus = num_online_cpus();
+
+			name = *(pci_dev_info->msix_entries.names + i);
+			snprintf(name, ADF_MAX_MSIX_VECTOR_NAME,
+				 "qat%d-bundle%d", accel_dev->accel_id, i);
+			ret = request_irq(msixe[i].vector,
+					  adf_msix_isr_bundle, 0, name, bank);
+			if (ret) {
+				dev_err(&GET_DEV(accel_dev),
+					"failed to enable irq %d for %s\n",
+					msixe[i].vector, name);
+				return ret;
+			}
+
+			cpu = ((accel_dev->accel_id * hw_data->num_banks) +
+			       i) % cpus;
+			irq_set_affinity_hint(msixe[i].vector,
+					      get_cpu_mask(cpu));
+		}
+	}
+
+	/* Request msix irq for AE */
+	name = *(pci_dev_info->msix_entries.names + i);
+	snprintf(name, ADF_MAX_MSIX_VECTOR_NAME,
+		 "qat%d-ae-cluster", accel_dev->accel_id);
+	ret = request_irq(msixe[i].vector, adf_msix_isr_ae, 0, name, accel_dev);
+	if (ret) {
+		dev_err(&GET_DEV(accel_dev),
+			"failed to enable irq %d, for %s\n",
+			msixe[i].vector, name);
+		return ret;
+	}
+	return ret;
+}
+
+static void adf_free_irqs(struct adf_accel_dev *accel_dev)
+{
+	struct adf_accel_pci *pci_dev_info = &accel_dev->accel_pci_dev;
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct msix_entry *msixe = pci_dev_info->msix_entries.entries;
+	struct adf_etr_data *etr_data = accel_dev->transport;
+	int i = 0;
+
+	if (pci_dev_info->msix_entries.num_entries > 1) {
+		for (i = 0; i < hw_data->num_banks; i++) {
+			irq_set_affinity_hint(msixe[i].vector, NULL);
+			free_irq(msixe[i].vector, &etr_data->banks[i]);
+		}
+	}
+	irq_set_affinity_hint(msixe[i].vector, NULL);
+	free_irq(msixe[i].vector, accel_dev);
+}
+
+static int adf_isr_alloc_msix_entry_table(struct adf_accel_dev *accel_dev)
+{
+	int i;
+	char **names;
+	struct msix_entry *entries;
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	u32 msix_num_entries = 1;
+
+	/* If SR-IOV is disabled (vf_info is NULL), add entries for each bank */
+	if (!accel_dev->pf.vf_info)
+		msix_num_entries += hw_data->num_banks;
+
+	entries = kzalloc_node(msix_num_entries * sizeof(*entries),
+			       GFP_KERNEL, dev_to_node(&GET_DEV(accel_dev)));
+	if (!entries)
+		return -ENOMEM;
+
+	names = kcalloc(msix_num_entries, sizeof(char *), GFP_KERNEL);
+	if (!names) {
+		kfree(entries);
+		return -ENOMEM;
+	}
+	for (i = 0; i < msix_num_entries; i++) {
+		*(names + i) = kzalloc(ADF_MAX_MSIX_VECTOR_NAME, GFP_KERNEL);
+		if (!(*(names + i)))
+			goto err;
+	}
+	accel_dev->accel_pci_dev.msix_entries.num_entries = msix_num_entries;
+	accel_dev->accel_pci_dev.msix_entries.entries = entries;
+	accel_dev->accel_pci_dev.msix_entries.names = names;
+	return 0;
+err:
+	for (i = 0; i < msix_num_entries; i++)
+		kfree(*(names + i));
+	kfree(entries);
+	kfree(names);
+	return -ENOMEM;
+}
+
+static void adf_isr_free_msix_entry_table(struct adf_accel_dev *accel_dev)
+{
+	char **names = accel_dev->accel_pci_dev.msix_entries.names;
+	int i;
+
+	kfree(accel_dev->accel_pci_dev.msix_entries.entries);
+	for (i = 0; i < accel_dev->accel_pci_dev.msix_entries.num_entries; i++)
+		kfree(*(names + i));
+	kfree(names);
+}
+
+static int adf_setup_bh(struct adf_accel_dev *accel_dev)
+{
+	struct adf_etr_data *priv_data = accel_dev->transport;
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	int i;
+
+	for (i = 0; i < hw_data->num_banks; i++)
+		tasklet_init(&priv_data->banks[i].resp_handler,
+			     adf_response_handler,
+			     (unsigned long)&priv_data->banks[i]);
+	return 0;
+}
+
+static void adf_cleanup_bh(struct adf_accel_dev *accel_dev)
+{
+	struct adf_etr_data *priv_data = accel_dev->transport;
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	int i;
+
+	for (i = 0; i < hw_data->num_banks; i++) {
+		tasklet_disable(&priv_data->banks[i].resp_handler);
+		tasklet_kill(&priv_data->banks[i].resp_handler);
+	}
+}
+
+/**
+ * adf_vf_isr_resource_free() - Free IRQ for acceleration device
+ * @accel_dev:  Pointer to acceleration device.
+ *
+ * Function frees interrupts for acceleration device.
+ */
+void adf_isr_resource_free(struct adf_accel_dev *accel_dev)
+{
+	adf_free_irqs(accel_dev);
+	adf_cleanup_bh(accel_dev);
+	adf_disable_msix(&accel_dev->accel_pci_dev);
+	adf_isr_free_msix_entry_table(accel_dev);
+}
+EXPORT_SYMBOL_GPL(adf_isr_resource_free);
+
+/**
+ * adf_vf_isr_resource_alloc() - Allocate IRQ for acceleration device
+ * @accel_dev:  Pointer to acceleration device.
+ *
+ * Function allocates interrupts for acceleration device.
+ *
+ * Return: 0 on success, error code otherwise.
+ */
+int adf_isr_resource_alloc(struct adf_accel_dev *accel_dev)
+{
+	int ret;
+
+	ret = adf_isr_alloc_msix_entry_table(accel_dev);
+	if (ret)
+		return ret;
+	if (adf_enable_msix(accel_dev))
+		goto err_out;
+
+	if (adf_setup_bh(accel_dev))
+		goto err_out;
+
+	if (adf_request_irqs(accel_dev))
+		goto err_out;
+
+	return 0;
+err_out:
+	adf_isr_resource_free(accel_dev);
+	return -EFAULT;
+}
+EXPORT_SYMBOL_GPL(adf_isr_resource_alloc);
diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index 5fdbad8..b3875fd 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -45,8 +45,6 @@
   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
 
-#include <linux/pci.h>
-#include <linux/mutex.h>
 #include <linux/delay.h>
 #include "adf_accel_devices.h"
 #include "adf_common_drv.h"
@@ -58,12 +56,6 @@
 #define ADF_DH895XCC_ERRMSK5	(ADF_DH895XCC_EP_OFFSET + 0xDC)
 #define ADF_DH895XCC_ERRMSK5_VF2PF_U_MASK(vf_mask) (vf_mask >> 16)
 
-/**
- * adf_enable_pf2vf_interrupts() - Enable PF to VF interrupts
- * @accel_dev:  Pointer to acceleration device.
- *
- * Function enables PF to VF interrupts
- */
 void adf_enable_pf2vf_interrupts(struct adf_accel_dev *accel_dev)
 {
 	struct adf_accel_pci *pci_info = &accel_dev->accel_pci_dev;
@@ -73,14 +65,7 @@ void adf_enable_pf2vf_interrupts(struct adf_accel_dev *accel_dev)
 
 	ADF_CSR_WR(pmisc_bar_addr, hw_data->get_vintmsk_offset(0), 0x0);
 }
-EXPORT_SYMBOL_GPL(adf_enable_pf2vf_interrupts);
 
-/**
- * adf_disable_pf2vf_interrupts() - Disable PF to VF interrupts
- * @accel_dev:  Pointer to acceleration device.
- *
- * Function disables PF to VF interrupts
- */
 void adf_disable_pf2vf_interrupts(struct adf_accel_dev *accel_dev)
 {
 	struct adf_accel_pci *pci_info = &accel_dev->accel_pci_dev;
@@ -90,7 +75,6 @@ void adf_disable_pf2vf_interrupts(struct adf_accel_dev *accel_dev)
 
 	ADF_CSR_WR(pmisc_bar_addr, hw_data->get_vintmsk_offset(0), 0x2);
 }
-EXPORT_SYMBOL_GPL(adf_disable_pf2vf_interrupts);
 
 void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev,
 				 u32 vf_mask)
@@ -116,12 +100,6 @@ void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev,
 	}
 }
 
-/**
- * adf_disable_pf2vf_interrupts() - Disable VF to PF interrupts
- * @accel_dev:  Pointer to acceleration device.
- *
- * Function disables VF to PF interrupts
- */
 void adf_disable_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 vf_mask)
 {
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
@@ -144,7 +122,6 @@ void adf_disable_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 vf_mask)
 		ADF_CSR_WR(pmisc_addr, ADF_DH895XCC_ERRMSK5, reg);
 	}
 }
-EXPORT_SYMBOL_GPL(adf_disable_vf2pf_interrupts);
 
 static int __adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 {
diff --git a/drivers/crypto/qat/qat_common/adf_transport.c b/drivers/crypto/qat/qat_common/adf_transport.c
index 3865ae8..eff00cd 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.c
+++ b/drivers/crypto/qat/qat_common/adf_transport.c
@@ -122,7 +122,7 @@ int adf_send_message(struct adf_etr_ring_data *ring, uint32_t *msg)
 		return -EAGAIN;
 	}
 	spin_lock_bh(&ring->lock);
-	memcpy(ring->base_addr + ring->tail, msg,
+	memcpy((void *)((uintptr_t)ring->base_addr + ring->tail), msg,
 	       ADF_MSG_SIZE_TO_BYTES(ring->msg_size));
 
 	ring->tail = adf_modulo(ring->tail +
@@ -137,7 +137,7 @@ int adf_send_message(struct adf_etr_ring_data *ring, uint32_t *msg)
 static int adf_handle_response(struct adf_etr_ring_data *ring)
 {
 	uint32_t msg_counter = 0;
-	uint32_t *msg = (uint32_t *)(ring->base_addr + ring->head);
+	uint32_t *msg = (uint32_t *)((uintptr_t)ring->base_addr + ring->head);
 
 	while (*msg != ADF_RING_EMPTY_SIG) {
 		ring->callback((uint32_t *)msg);
@@ -146,7 +146,7 @@ static int adf_handle_response(struct adf_etr_ring_data *ring)
 					ADF_MSG_SIZE_TO_BYTES(ring->msg_size),
 					ADF_RING_SIZE_MODULO(ring->ring_size));
 		msg_counter++;
-		msg = (uint32_t *)(ring->base_addr + ring->head);
+		msg = (uint32_t *)((uintptr_t)ring->base_addr + ring->head);
 	}
 	if (msg_counter > 0) {
 		WRITE_CSR_RING_HEAD(ring->bank->csr_addr,
@@ -342,18 +342,7 @@ static void adf_ring_response_handler(struct adf_etr_bank_data *bank)
 	}
 }
 
-/**
- * adf_response_handler() - Bottom half handler response handler
- * @bank_addr:  Address of a ring bank for with the BH was scheduled.
- *
- * Function is the bottom half handler for the response from acceleration
- * device. There is one handler for every ring bank. Function checks all
- * communication rings in the bank.
- * To be used by QAT device specific drivers.
- *
- * Return: void
- */
-void adf_response_handler(unsigned long bank_addr)
+void adf_response_handler(uintptr_t bank_addr)
 {
 	struct adf_etr_bank_data *bank = (void *)bank_addr;
 
@@ -362,7 +351,6 @@ void adf_response_handler(unsigned long bank_addr)
 	WRITE_CSR_INT_FLAG_AND_COL(bank->csr_addr, bank->bank_number,
 				   bank->irq_mask);
 }
-EXPORT_SYMBOL_GPL(adf_response_handler);
 
 static inline int adf_get_cfg_int(struct adf_accel_dev *accel_dev,
 				  const char *section, const char *format,
diff --git a/drivers/crypto/qat/qat_common/adf_transport_internal.h b/drivers/crypto/qat/qat_common/adf_transport_internal.h
index a486962..bb88336 100644
--- a/drivers/crypto/qat/qat_common/adf_transport_internal.h
+++ b/drivers/crypto/qat/qat_common/adf_transport_internal.h
@@ -91,7 +91,7 @@ struct adf_etr_data {
 	struct dentry *debug;
 };
 
-void adf_response_handler(unsigned long bank_addr);
+void adf_response_handler(uintptr_t bank_addr);
 #ifdef CONFIG_DEBUG_FS
 #include <linux/debugfs.h>
 int adf_bank_debugfs_add(struct adf_etr_bank_data *bank);
diff --git a/drivers/crypto/qat/qat_common/adf_vf_isr.c b/drivers/crypto/qat/qat_common/adf_vf_isr.c
new file mode 100644
index 0000000..09427b3
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_vf_isr.c
@@ -0,0 +1,280 @@
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
+#include "adf_accel_devices.h"
+#include "adf_common_drv.h"
+#include "adf_cfg.h"
+#include "adf_cfg_strings.h"
+#include "adf_cfg_common.h"
+#include "adf_transport_access_macros.h"
+#include "adf_transport_internal.h"
+#include "adf_pf2vf_msg.h"
+
+#define ADF_VINTSOU_OFFSET	0x204
+#define ADF_VINTSOU_BUN		BIT(0)
+#define ADF_VINTSOU_PF2VF	BIT(1)
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
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct adf_bar *pmisc =
+			&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
+	void __iomem *pmisc_bar_addr = pmisc->virt_addr;
+	u32 msg;
+
+	/* Read the message from PF */
+	msg = ADF_CSR_RD(pmisc_bar_addr, hw_data->get_pf2vf_offset(0));
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
+	msg &= ~BIT(0);
+	ADF_CSR_WR(pmisc_bar_addr, hw_data->get_pf2vf_offset(0), msg);
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
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct adf_bar *pmisc =
+			&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
+	void __iomem *pmisc_bar_addr = pmisc->virt_addr;
+	u32 v_int;
+
+	/* Read VF INT source CSR to determine the source of VF interrupt */
+	v_int = ADF_CSR_RD(pmisc_bar_addr, ADF_VINTSOU_OFFSET);
+
+	/* Check for PF2VF interrupt */
+	if (v_int & ADF_VINTSOU_PF2VF) {
+		/* Disable PF to VF interrupt */
+		adf_disable_pf2vf_interrupts(accel_dev);
+
+		/* Schedule tasklet to handle interrupt BH */
+		tasklet_hi_schedule(&accel_dev->vf.pf2vf_bh_tasklet);
+		return IRQ_HANDLED;
+	}
+
+	/* Check bundle interrupt */
+	if (v_int & ADF_VINTSOU_BUN) {
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
+/**
+ * adf_vf_isr_resource_free() - Free IRQ for acceleration device
+ * @accel_dev:  Pointer to acceleration device.
+ *
+ * Function frees interrupts for acceleration device virtual function.
+ */
+void adf_vf_isr_resource_free(struct adf_accel_dev *accel_dev)
+{
+	struct pci_dev *pdev = accel_to_pci_dev(accel_dev);
+
+	irq_set_affinity_hint(pdev->irq, NULL);
+	free_irq(pdev->irq, (void *)accel_dev);
+	adf_cleanup_bh(accel_dev);
+	adf_cleanup_pf2vf_bh(accel_dev);
+	adf_disable_msi(accel_dev);
+}
+EXPORT_SYMBOL_GPL(adf_vf_isr_resource_free);
+
+/**
+ * adf_vf_isr_resource_alloc() - Allocate IRQ for acceleration device
+ * @accel_dev:  Pointer to acceleration device.
+ *
+ * Function allocates interrupts for acceleration device virtual function.
+ *
+ * Return: 0 on success, error code otherwise.
+ */
+int adf_vf_isr_resource_alloc(struct adf_accel_dev *accel_dev)
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
+	adf_vf_isr_resource_free(accel_dev);
+	return -EFAULT;
+}
+EXPORT_SYMBOL_GPL(adf_vf_isr_resource_alloc);
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
index 9425402..4d0c65b 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -49,6 +49,7 @@
 #include "adf_accel_devices.h"
 #include "adf_common_drv.h"
 #include "adf_transport.h"
+#include "adf_transport_access_macros.h"
 #include "adf_cfg.h"
 #include "adf_cfg_strings.h"
 #include "qat_crypto.h"
@@ -159,6 +160,97 @@ struct qat_crypto_instance *qat_crypto_get_instance_node(int node)
 	return inst;
 }
 
+/**
+ * qat_crypto_dev_config() - create dev config required to create crypto inst.
+ *
+ * @accel_dev: Pointer to acceleration device.
+ *
+ * Function creates device configuration required to create crypto instances
+ *
+ * Return: 0 on success, error code otherwise.
+ */
+int qat_crypto_dev_config(struct adf_accel_dev *accel_dev)
+{
+	int cpus = num_online_cpus();
+	int banks = GET_MAX_BANKS(accel_dev);
+	int instances = min(cpus, banks);
+	char key[ADF_CFG_MAX_KEY_LEN_IN_BYTES];
+	int i;
+	unsigned long val;
+
+	if (adf_cfg_section_add(accel_dev, ADF_KERNEL_SEC))
+		goto err;
+	if (adf_cfg_section_add(accel_dev, "Accelerator0"))
+		goto err;
+	for (i = 0; i < instances; i++) {
+		val = i;
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_BANK_NUM, i);
+		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+						key, (void *)&val, ADF_DEC))
+			goto err;
+
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_ETRMGR_CORE_AFFINITY,
+			 i);
+		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+						key, (void *)&val, ADF_DEC))
+			goto err;
+
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_SIZE, i);
+		val = 128;
+		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+						key, (void *)&val, ADF_DEC))
+			goto err;
+
+		val = 512;
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_SIZE, i);
+		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+						key, (void *)&val, ADF_DEC))
+			goto err;
+
+		val = 0;
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_TX, i);
+		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+						key, (void *)&val, ADF_DEC))
+			goto err;
+
+		val = 2;
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_TX, i);
+		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+						key, (void *)&val, ADF_DEC))
+			goto err;
+
+		val = 8;
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_RX, i);
+		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+						key, (void *)&val, ADF_DEC))
+			goto err;
+
+		val = 10;
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_RX, i);
+		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+						key, (void *)&val, ADF_DEC))
+			goto err;
+
+		val = ADF_COALESCING_DEF_TIME;
+		snprintf(key, sizeof(key), ADF_ETRMGR_COALESCE_TIMER_FORMAT, i);
+		if (adf_cfg_add_key_value_param(accel_dev, "Accelerator0",
+						key, (void *)&val, ADF_DEC))
+			goto err;
+	}
+
+	val = i;
+	if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+					ADF_NUM_CY, (void *)&val, ADF_DEC))
+		goto err;
+
+	set_bit(ADF_STATUS_CONFIGURED, &accel_dev->status);
+	return 0;
+err:
+	dev_err(&GET_DEV(accel_dev), "Failed to start QAT accel dev\n");
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(qat_crypto_dev_config);
+
 static int qat_crypto_create_instances(struct adf_accel_dev *accel_dev)
 {
 	int i;
diff --git a/drivers/crypto/qat/qat_dh895xcc/Makefile b/drivers/crypto/qat/qat_dh895xcc/Makefile
index 8c79c54..180a00e 100644
--- a/drivers/crypto/qat/qat_dh895xcc/Makefile
+++ b/drivers/crypto/qat/qat_dh895xcc/Makefile
@@ -1,5 +1,3 @@
 ccflags-y := -I$(src)/../qat_common
 obj-$(CONFIG_CRYPTO_DEV_QAT_DH895xCC) += qat_dh895xcc.o
-qat_dh895xcc-objs := adf_drv.o \
-		adf_isr.o \
-		adf_dh895xcc_hw_data.o
+qat_dh895xcc-objs := adf_drv.o adf_dh895xcc_hw_data.o
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index ff54257..6e1d5e1 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -48,7 +48,6 @@
 #include <adf_pf2vf_msg.h>
 #include <adf_common_drv.h>
 #include "adf_dh895xcc_hw_data.h"
-#include "adf_drv.h"
 
 /* Worker thread to service arbiter mappings based on dev SKUs */
 static const uint32_t thrd_to_arb_map_sku4[] = {
@@ -143,8 +142,8 @@ static enum dev_sku_info get_sku(struct adf_hw_device_data *self)
 	return DEV_SKU_UNKNOWN;
 }
 
-void adf_get_arbiter_mapping(struct adf_accel_dev *accel_dev,
-			     uint32_t const **arb_map_config)
+static void adf_get_arbiter_mapping(struct adf_accel_dev *accel_dev,
+				    u32 const **arb_map_config)
 {
 	switch (accel_dev->accel_pci_dev.sku) {
 	case DEV_SKU_1:
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
index 88dffb2..72eacfd 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
@@ -53,7 +53,6 @@
 #define ADF_DH895XCC_ETR_BAR 2
 #define ADF_DH895XCC_RX_RINGS_OFFSET 8
 #define ADF_DH895XCC_TX_RINGS_MASK 0xFF
-#define ADF_DH895XCC_FUSECTL_OFFSET 0x40
 #define ADF_DH895XCC_FUSECTL_SKU_MASK 0x300000
 #define ADF_DH895XCC_FUSECTL_SKU_SHIFT 20
 #define ADF_DH895XCC_FUSECTL_SKU_1 0x0
@@ -65,7 +64,6 @@
 #define ADF_DH895XCC_ACCELERATORS_REG_OFFSET 13
 #define ADF_DH895XCC_ACCELERATORS_MASK 0x3F
 #define ADF_DH895XCC_ACCELENGINES_MASK 0xFFF
-#define ADF_DH895XCC_LEGFUSE_OFFSET 0x4C
 #define ADF_DH895XCC_ETR_MAX_BANKS 32
 #define ADF_DH895XCC_SMIAPF0_MASK_OFFSET (0x3A000 + 0x28)
 #define ADF_DH895XCC_SMIAPF1_MASK_OFFSET (0x3A000 + 0x30)
@@ -80,11 +78,12 @@
 #define ADF_DH895XCC_CERRSSMSH(i) (i * 0x4000 + 0x10)
 #define ADF_DH895XCC_ERRSSMSH_EN BIT(3)
 
-#define ADF_DH895XCC_ERRSOU3	(0x3A000 + 0x00C)
-#define ADF_DH895XCC_ERRSOU5	(0x3A000 + 0x0D8)
 #define ADF_DH895XCC_PF2VF_OFFSET(i)	(0x3A000 + 0x280 + ((i) * 0x04))
 #define ADF_DH895XCC_VINTMSK_OFFSET(i)	(0x3A000 + 0x200 + ((i) * 0x04))
 /* FW names */
 #define ADF_DH895XCC_FW "qat_895xcc.bin"
 #define ADF_DH895XCC_MMP "qat_mmp.bin"
+
+void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data);
+void adf_clean_hw_data_dh895xcc(struct adf_hw_device_data *hw_data);
 #endif
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
index f933f7d..a8c4b92 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
@@ -60,11 +60,7 @@
 #include <adf_accel_devices.h>
 #include <adf_common_drv.h>
 #include <adf_cfg.h>
-#include <adf_transport_access_macros.h>
 #include "adf_dh895xcc_hw_data.h"
-#include "adf_drv.h"
-
-static const char adf_driver_name[] = ADF_DH895XCC_DEVICE_NAME;
 
 #define ADF_SYSTEM_DEVICE(device_id) \
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, device_id)}
@@ -80,7 +76,7 @@ static void adf_remove(struct pci_dev *dev);
 
 static struct pci_driver adf_driver = {
 	.id_table = adf_pci_tbl,
-	.name = adf_driver_name,
+	.name = ADF_DH895XCC_DEVICE_NAME,
 	.probe = adf_probe,
 	.remove = adf_remove,
 	.sriov_configure = adf_sriov_configure,
@@ -120,87 +116,6 @@ static void adf_cleanup_accel(struct adf_accel_dev *accel_dev)
 	adf_devmgr_rm_dev(accel_dev, NULL);
 }
 
-static int adf_dev_configure(struct adf_accel_dev *accel_dev)
-{
-	int cpus = num_online_cpus();
-	int banks = GET_MAX_BANKS(accel_dev);
-	int instances = min(cpus, banks);
-	char key[ADF_CFG_MAX_KEY_LEN_IN_BYTES];
-	int i;
-	unsigned long val;
-
-	if (adf_cfg_section_add(accel_dev, ADF_KERNEL_SEC))
-		goto err;
-	if (adf_cfg_section_add(accel_dev, "Accelerator0"))
-		goto err;
-	for (i = 0; i < instances; i++) {
-		val = i;
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_BANK_NUM, i);
-		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, (void *)&val, ADF_DEC))
-			goto err;
-
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_ETRMGR_CORE_AFFINITY,
-			 i);
-		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, (void *)&val, ADF_DEC))
-			goto err;
-
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_SIZE, i);
-		val = 128;
-		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, (void *)&val, ADF_DEC))
-			goto err;
-
-		val = 512;
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_SIZE, i);
-		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, (void *)&val, ADF_DEC))
-			goto err;
-
-		val = 0;
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_TX, i);
-		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, (void *)&val, ADF_DEC))
-			goto err;
-
-		val = 2;
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_TX, i);
-		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, (void *)&val, ADF_DEC))
-			goto err;
-
-		val = 8;
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_RX, i);
-		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, (void *)&val, ADF_DEC))
-			goto err;
-
-		val = 10;
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_RX, i);
-		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, (void *)&val, ADF_DEC))
-			goto err;
-
-		val = ADF_COALESCING_DEF_TIME;
-		snprintf(key, sizeof(key), ADF_ETRMGR_COALESCE_TIMER_FORMAT, i);
-		if (adf_cfg_add_key_value_param(accel_dev, "Accelerator0",
-						key, (void *)&val, ADF_DEC))
-			goto err;
-	}
-
-	val = i;
-	if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-					ADF_NUM_CY, (void *)&val, ADF_DEC))
-		goto err;
-
-	set_bit(ADF_STATUS_CONFIGURED, &accel_dev->status);
-	return 0;
-err:
-	dev_err(&GET_DEV(accel_dev), "Failed to start QAT accel dev\n");
-	return -EINVAL;
-}
-
 static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct adf_accel_dev *accel_dev;
@@ -255,7 +170,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	accel_dev->hw_device = hw_data;
 	adf_init_hw_data_dh895xcc(accel_dev->hw_device);
 	pci_read_config_byte(pdev, PCI_REVISION_ID, &accel_pci_dev->revid);
-	pci_read_config_dword(pdev, ADF_DH895XCC_FUSECTL_OFFSET,
+	pci_read_config_dword(pdev, ADF_DEVICE_FUSECTL_OFFSET,
 			      &hw_data->fuses);
 
 	/* Get Accelerators and Accelerators Engines masks */
@@ -310,13 +225,13 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 	}
 
-	if (pci_request_regions(pdev, adf_driver_name)) {
+	if (pci_request_regions(pdev, ADF_DH895XCC_DEVICE_NAME)) {
 		ret = -EFAULT;
 		goto out_err_disable;
 	}
 
 	/* Read accelerator capabilities mask */
-	pci_read_config_dword(pdev, ADF_DH895XCC_LEGFUSE_OFFSET,
+	pci_read_config_dword(pdev, ADF_DEVICE_LEGFUSE_OFFSET,
 			      &hw_data->accel_capabilities_mask);
 
 	/* Find and map all the device's BARS */
@@ -351,7 +266,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_err_free_reg;
 	}
 
-	ret = adf_dev_configure(accel_dev);
+	ret = qat_crypto_dev_config(accel_dev);
 	if (ret)
 		goto out_err_free_reg;
 
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.h b/drivers/crypto/qat/qat_dh895xcc/adf_drv.h
deleted file mode 100644
index 85ff245..0000000
--- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.h
+++ /dev/null
@@ -1,58 +0,0 @@
-/*
-  This file is provided under a dual BSD/GPLv2 license.  When using or
-  redistributing this file, you may do so under either license.
-
-  GPL LICENSE SUMMARY
-  Copyright(c) 2014 Intel Corporation.
-  This program is free software; you can redistribute it and/or modify
-  it under the terms of version 2 of the GNU General Public License as
-  published by the Free Software Foundation.
-
-  This program is distributed in the hope that it will be useful, but
-  WITHOUT ANY WARRANTY; without even the implied warranty of
-  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-  General Public License for more details.
-
-  Contact Information:
-  qat-linux@intel.com
-
-  BSD LICENSE
-  Copyright(c) 2014 Intel Corporation.
-  Redistribution and use in source and binary forms, with or without
-  modification, are permitted provided that the following conditions
-  are met:
-
-    * Redistributions of source code must retain the above copyright
-      notice, this list of conditions and the following disclaimer.
-    * Redistributions in binary form must reproduce the above copyright
-      notice, this list of conditions and the following disclaimer in
-      the documentation and/or other materials provided with the
-      distribution.
-    * Neither the name of Intel Corporation nor the names of its
-      contributors may be used to endorse or promote products derived
-      from this software without specific prior written permission.
-
-  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
-  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
-  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
-  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
-  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
-  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
-  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
-  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
-  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
-  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-*/
-#ifndef ADF_DH895x_DRV_H_
-#define ADF_DH895x_DRV_H_
-#include <adf_accel_devices.h>
-#include <adf_transport.h>
-
-void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data);
-void adf_clean_hw_data_dh895xcc(struct adf_hw_device_data *hw_data);
-int adf_isr_resource_alloc(struct adf_accel_dev *accel_dev);
-void adf_isr_resource_free(struct adf_accel_dev *accel_dev);
-void adf_get_arbiter_mapping(struct adf_accel_dev *accel_dev,
-			     uint32_t const **arb_map_config);
-#endif
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_isr.c b/drivers/crypto/qat/qat_dh895xcc/adf_isr.c
deleted file mode 100644
index 5570f78..0000000
--- a/drivers/crypto/qat/qat_dh895xcc/adf_isr.c
+++ /dev/null
@@ -1,332 +0,0 @@
-/*
-  This file is provided under a dual BSD/GPLv2 license.  When using or
-  redistributing this file, you may do so under either license.
-
-  GPL LICENSE SUMMARY
-  Copyright(c) 2014 Intel Corporation.
-  This program is free software; you can redistribute it and/or modify
-  it under the terms of version 2 of the GNU General Public License as
-  published by the Free Software Foundation.
-
-  This program is distributed in the hope that it will be useful, but
-  WITHOUT ANY WARRANTY; without even the implied warranty of
-  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-  General Public License for more details.
-
-  Contact Information:
-  qat-linux@intel.com
-
-  BSD LICENSE
-  Copyright(c) 2014 Intel Corporation.
-  Redistribution and use in source and binary forms, with or without
-  modification, are permitted provided that the following conditions
-  are met:
-
-    * Redistributions of source code must retain the above copyright
-      notice, this list of conditions and the following disclaimer.
-    * Redistributions in binary form must reproduce the above copyright
-      notice, this list of conditions and the following disclaimer in
-      the documentation and/or other materials provided with the
-      distribution.
-    * Neither the name of Intel Corporation nor the names of its
-      contributors may be used to endorse or promote products derived
-      from this software without specific prior written permission.
-
-  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
-  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
-  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
-  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
-  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
-  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
-  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
-  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
-  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
-  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-*/
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/types.h>
-#include <linux/pci.h>
-#include <linux/slab.h>
-#include <linux/errno.h>
-#include <linux/interrupt.h>
-#include <adf_accel_devices.h>
-#include <adf_common_drv.h>
-#include <adf_cfg.h>
-#include <adf_cfg_strings.h>
-#include <adf_cfg_common.h>
-#include <adf_transport_access_macros.h>
-#include <adf_transport_internal.h>
-#include "adf_drv.h"
-#include "adf_dh895xcc_hw_data.h"
-
-static int adf_enable_msix(struct adf_accel_dev *accel_dev)
-{
-	struct adf_accel_pci *pci_dev_info = &accel_dev->accel_pci_dev;
-	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	u32 msix_num_entries = 1;
-
-	/* If SR-IOV is disabled, add entries for each bank */
-	if (!accel_dev->pf.vf_info) {
-		int i;
-
-		msix_num_entries += hw_data->num_banks;
-		for (i = 0; i < msix_num_entries; i++)
-			pci_dev_info->msix_entries.entries[i].entry = i;
-	} else {
-		pci_dev_info->msix_entries.entries[0].entry =
-			hw_data->num_banks;
-	}
-
-	if (pci_enable_msix_exact(pci_dev_info->pci_dev,
-				  pci_dev_info->msix_entries.entries,
-				  msix_num_entries)) {
-		dev_err(&GET_DEV(accel_dev), "Failed to enable MSI-X IRQ(s)\n");
-		return -EFAULT;
-	}
-	return 0;
-}
-
-static void adf_disable_msix(struct adf_accel_pci *pci_dev_info)
-{
-	pci_disable_msix(pci_dev_info->pci_dev);
-}
-
-static irqreturn_t adf_msix_isr_bundle(int irq, void *bank_ptr)
-{
-	struct adf_etr_bank_data *bank = bank_ptr;
-
-	WRITE_CSR_INT_FLAG_AND_COL(bank->csr_addr, bank->bank_number, 0);
-	tasklet_hi_schedule(&bank->resp_handler);
-	return IRQ_HANDLED;
-}
-
-static irqreturn_t adf_msix_isr_ae(int irq, void *dev_ptr)
-{
-	struct adf_accel_dev *accel_dev = dev_ptr;
-
-#ifdef CONFIG_PCI_IOV
-	/* If SR-IOV is enabled (vf_info is non-NULL), check for VF->PF ints */
-	if (accel_dev->pf.vf_info) {
-		void __iomem *pmisc_bar_addr =
-		    (&GET_BARS(accel_dev)[ADF_DH895XCC_PMISC_BAR])->virt_addr;
-		u32 vf_mask;
-
-		/* Get the interrupt sources triggered by VFs */
-		vf_mask = ((ADF_CSR_RD(pmisc_bar_addr, ADF_DH895XCC_ERRSOU5) &
-			    0x0000FFFF) << 16) |
-			  ((ADF_CSR_RD(pmisc_bar_addr, ADF_DH895XCC_ERRSOU3) &
-			    0x01FFFE00) >> 9);
-
-		if (vf_mask) {
-			struct adf_accel_vf_info *vf_info;
-			bool irq_handled = false;
-			int i;
-
-			/* Disable VF2PF interrupts for VFs with pending ints */
-			adf_disable_vf2pf_interrupts(accel_dev, vf_mask);
-
-			/*
-			 * Schedule tasklets to handle VF2PF interrupt BHs
-			 * unless the VF is malicious and is attempting to
-			 * flood the host OS with VF2PF interrupts.
-			 */
-			for_each_set_bit(i, (const unsigned long *)&vf_mask,
-					 (sizeof(vf_mask) * BITS_PER_BYTE)) {
-				vf_info = accel_dev->pf.vf_info + i;
-
-				if (!__ratelimit(&vf_info->vf2pf_ratelimit)) {
-					dev_info(&GET_DEV(accel_dev),
-						 "Too many ints from VF%d\n",
-						  vf_info->vf_nr + 1);
-					continue;
-				}
-
-				/* Tasklet will re-enable ints from this VF */
-				tasklet_hi_schedule(&vf_info->vf2pf_bh_tasklet);
-				irq_handled = true;
-			}
-
-			if (irq_handled)
-				return IRQ_HANDLED;
-		}
-	}
-#endif /* CONFIG_PCI_IOV */
-
-	dev_dbg(&GET_DEV(accel_dev), "qat_dev%d spurious AE interrupt\n",
-		accel_dev->accel_id);
-
-	return IRQ_NONE;
-}
-
-static int adf_request_irqs(struct adf_accel_dev *accel_dev)
-{
-	struct adf_accel_pci *pci_dev_info = &accel_dev->accel_pci_dev;
-	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	struct msix_entry *msixe = pci_dev_info->msix_entries.entries;
-	struct adf_etr_data *etr_data = accel_dev->transport;
-	int ret, i = 0;
-	char *name;
-
-	/* Request msix irq for all banks unless SR-IOV enabled */
-	if (!accel_dev->pf.vf_info) {
-		for (i = 0; i < hw_data->num_banks; i++) {
-			struct adf_etr_bank_data *bank = &etr_data->banks[i];
-			unsigned int cpu, cpus = num_online_cpus();
-
-			name = *(pci_dev_info->msix_entries.names + i);
-			snprintf(name, ADF_MAX_MSIX_VECTOR_NAME,
-				 "qat%d-bundle%d", accel_dev->accel_id, i);
-			ret = request_irq(msixe[i].vector,
-					  adf_msix_isr_bundle, 0, name, bank);
-			if (ret) {
-				dev_err(&GET_DEV(accel_dev),
-					"failed to enable irq %d for %s\n",
-					msixe[i].vector, name);
-				return ret;
-			}
-
-			cpu = ((accel_dev->accel_id * hw_data->num_banks) +
-			       i) % cpus;
-			irq_set_affinity_hint(msixe[i].vector,
-					      get_cpu_mask(cpu));
-		}
-	}
-
-	/* Request msix irq for AE */
-	name = *(pci_dev_info->msix_entries.names + i);
-	snprintf(name, ADF_MAX_MSIX_VECTOR_NAME,
-		 "qat%d-ae-cluster", accel_dev->accel_id);
-	ret = request_irq(msixe[i].vector, adf_msix_isr_ae, 0, name, accel_dev);
-	if (ret) {
-		dev_err(&GET_DEV(accel_dev),
-			"failed to enable irq %d, for %s\n",
-			msixe[i].vector, name);
-		return ret;
-	}
-	return ret;
-}
-
-static void adf_free_irqs(struct adf_accel_dev *accel_dev)
-{
-	struct adf_accel_pci *pci_dev_info = &accel_dev->accel_pci_dev;
-	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	struct msix_entry *msixe = pci_dev_info->msix_entries.entries;
-	struct adf_etr_data *etr_data = accel_dev->transport;
-	int i = 0;
-
-	if (pci_dev_info->msix_entries.num_entries > 1) {
-		for (i = 0; i < hw_data->num_banks; i++) {
-			irq_set_affinity_hint(msixe[i].vector, NULL);
-			free_irq(msixe[i].vector, &etr_data->banks[i]);
-		}
-	}
-	irq_set_affinity_hint(msixe[i].vector, NULL);
-	free_irq(msixe[i].vector, accel_dev);
-}
-
-static int adf_isr_alloc_msix_entry_table(struct adf_accel_dev *accel_dev)
-{
-	int i;
-	char **names;
-	struct msix_entry *entries;
-	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	u32 msix_num_entries = 1;
-
-	/* If SR-IOV is disabled (vf_info is NULL), add entries for each bank */
-	if (!accel_dev->pf.vf_info)
-		msix_num_entries += hw_data->num_banks;
-
-	entries = kzalloc_node(msix_num_entries * sizeof(*entries),
-			       GFP_KERNEL, dev_to_node(&GET_DEV(accel_dev)));
-	if (!entries)
-		return -ENOMEM;
-
-	names = kcalloc(msix_num_entries, sizeof(char *), GFP_KERNEL);
-	if (!names) {
-		kfree(entries);
-		return -ENOMEM;
-	}
-	for (i = 0; i < msix_num_entries; i++) {
-		*(names + i) = kzalloc(ADF_MAX_MSIX_VECTOR_NAME, GFP_KERNEL);
-		if (!(*(names + i)))
-			goto err;
-	}
-	accel_dev->accel_pci_dev.msix_entries.num_entries = msix_num_entries;
-	accel_dev->accel_pci_dev.msix_entries.entries = entries;
-	accel_dev->accel_pci_dev.msix_entries.names = names;
-	return 0;
-err:
-	for (i = 0; i < msix_num_entries; i++)
-		kfree(*(names + i));
-	kfree(entries);
-	kfree(names);
-	return -ENOMEM;
-}
-
-static void adf_isr_free_msix_entry_table(struct adf_accel_dev *accel_dev)
-{
-	char **names = accel_dev->accel_pci_dev.msix_entries.names;
-	int i;
-
-	kfree(accel_dev->accel_pci_dev.msix_entries.entries);
-	for (i = 0; i < accel_dev->accel_pci_dev.msix_entries.num_entries; i++)
-		kfree(*(names + i));
-	kfree(names);
-}
-
-static int adf_setup_bh(struct adf_accel_dev *accel_dev)
-{
-	struct adf_etr_data *priv_data = accel_dev->transport;
-	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	int i;
-
-	for (i = 0; i < hw_data->num_banks; i++)
-		tasklet_init(&priv_data->banks[i].resp_handler,
-			     adf_response_handler,
-			     (unsigned long)&priv_data->banks[i]);
-	return 0;
-}
-
-static void adf_cleanup_bh(struct adf_accel_dev *accel_dev)
-{
-	struct adf_etr_data *priv_data = accel_dev->transport;
-	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	int i;
-
-	for (i = 0; i < hw_data->num_banks; i++) {
-		tasklet_disable(&priv_data->banks[i].resp_handler);
-		tasklet_kill(&priv_data->banks[i].resp_handler);
-	}
-}
-
-void adf_isr_resource_free(struct adf_accel_dev *accel_dev)
-{
-	adf_free_irqs(accel_dev);
-	adf_cleanup_bh(accel_dev);
-	adf_disable_msix(&accel_dev->accel_pci_dev);
-	adf_isr_free_msix_entry_table(accel_dev);
-}
-
-int adf_isr_resource_alloc(struct adf_accel_dev *accel_dev)
-{
-	int ret;
-
-	ret = adf_isr_alloc_msix_entry_table(accel_dev);
-	if (ret)
-		return ret;
-	if (adf_enable_msix(accel_dev))
-		goto err_out;
-
-	if (adf_setup_bh(accel_dev))
-		goto err_out;
-
-	if (adf_request_irqs(accel_dev))
-		goto err_out;
-
-	return 0;
-err_out:
-	adf_isr_resource_free(accel_dev);
-	return -EFAULT;
-}
diff --git a/drivers/crypto/qat/qat_dh895xccvf/Makefile b/drivers/crypto/qat/qat_dh895xccvf/Makefile
index 85399fc..5c3ccf8 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/Makefile
+++ b/drivers/crypto/qat/qat_dh895xccvf/Makefile
@@ -1,5 +1,3 @@
 ccflags-y := -I$(src)/../qat_common
 obj-$(CONFIG_CRYPTO_DEV_QAT_DH895xCCVF) += qat_dh895xccvf.o
-qat_dh895xccvf-objs := adf_drv.o \
-		adf_isr.o \
-		adf_dh895xccvf_hw_data.o
+qat_dh895xccvf-objs := adf_drv.o adf_dh895xccvf_hw_data.o
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
index a9a27ef..dc04ab6 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
@@ -48,7 +48,6 @@
 #include <adf_pf2vf_msg.h>
 #include <adf_common_drv.h>
 #include "adf_dh895xccvf_hw_data.h"
-#include "adf_drv.h"
 
 static struct adf_hw_device_class dh895xcciov_class = {
 	.name = ADF_DH895XCCVF_DEVICE_NAME,
@@ -136,7 +135,6 @@ static void adf_vf2pf_shutdown(struct adf_accel_dev *accel_dev)
 void adf_init_hw_data_dh895xcciov(struct adf_hw_device_data *hw_data)
 {
 	hw_data->dev_class = &dh895xcciov_class;
-	hw_data->instance_id = dh895xcciov_class.instances++;
 	hw_data->num_banks = ADF_DH895XCCIOV_ETR_MAX_BANKS;
 	hw_data->num_accel = ADF_DH895XCCIOV_MAX_ACCELERATORS;
 	hw_data->num_logical_accel = 1;
@@ -164,9 +162,12 @@ void adf_init_hw_data_dh895xcciov(struct adf_hw_device_data *hw_data)
 	hw_data->enable_ints = adf_vf_void_noop;
 	hw_data->enable_vf2pf_comms = adf_enable_vf2pf_comms;
 	hw_data->min_iov_compat_ver = ADF_PFVF_COMPATIBILITY_VERSION;
+	hw_data->dev_class->instances++;
+	adf_devmgr_update_class_index(hw_data);
 }
 
 void adf_clean_hw_data_dh895xcciov(struct adf_hw_device_data *hw_data)
 {
 	hw_data->dev_class->instances--;
+	adf_devmgr_update_class_index(hw_data);
 }
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.h b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.h
index 8f6babf..6ddc19b 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.h
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.h
@@ -56,13 +56,9 @@
 #define ADF_DH895XCCIOV_TX_RINGS_MASK 0xFF
 #define ADF_DH895XCCIOV_ETR_BAR 0
 #define ADF_DH895XCCIOV_ETR_MAX_BANKS 1
-
 #define ADF_DH895XCCIOV_PF2VF_OFFSET	0x200
-#define ADF_DH895XCC_PF2VF_PF2VFINT	BIT(0)
-
-#define ADF_DH895XCCIOV_VINTSOU_OFFSET	0x204
-#define ADF_DH895XCC_VINTSOU_BUN	BIT(0)
-#define ADF_DH895XCC_VINTSOU_PF2VF	BIT(1)
-
 #define ADF_DH895XCCIOV_VINTMSK_OFFSET	0x208
+
+void adf_init_hw_data_dh895xcciov(struct adf_hw_device_data *hw_data);
+void adf_clean_hw_data_dh895xcciov(struct adf_hw_device_data *hw_data);
 #endif
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
index 7bec249..f8cc4bf 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
@@ -60,11 +60,7 @@
 #include <adf_accel_devices.h>
 #include <adf_common_drv.h>
 #include <adf_cfg.h>
-#include <adf_transport_access_macros.h>
 #include "adf_dh895xccvf_hw_data.h"
-#include "adf_drv.h"
-
-static const char adf_driver_name[] = ADF_DH895XCCVF_DEVICE_NAME;
 
 #define ADF_SYSTEM_DEVICE(device_id) \
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, device_id)}
@@ -80,7 +76,7 @@ static void adf_remove(struct pci_dev *dev);
 
 static struct pci_driver adf_driver = {
 	.id_table = adf_pci_tbl,
-	.name = adf_driver_name,
+	.name = ADF_DH895XCCVF_DEVICE_NAME,
 	.probe = adf_probe,
 	.remove = adf_remove,
 };
@@ -121,83 +117,6 @@ static void adf_cleanup_accel(struct adf_accel_dev *accel_dev)
 	adf_devmgr_rm_dev(accel_dev, pf);
 }
 
-static int adf_dev_configure(struct adf_accel_dev *accel_dev)
-{
-	char key[ADF_CFG_MAX_KEY_LEN_IN_BYTES];
-	unsigned long val, bank = 0;
-
-	if (adf_cfg_section_add(accel_dev, ADF_KERNEL_SEC))
-		goto err;
-	if (adf_cfg_section_add(accel_dev, "Accelerator0"))
-		goto err;
-
-	snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_BANK_NUM, 0);
-	if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC, key,
-					(void *)&bank, ADF_DEC))
-		goto err;
-
-	val = bank;
-	snprintf(key, sizeof(key), ADF_CY "%d" ADF_ETRMGR_CORE_AFFINITY, 0);
-	if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC, key,
-					(void *)&val, ADF_DEC))
-		goto err;
-
-	snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_SIZE, 0);
-
-	val = 128;
-	if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC, key,
-					(void *)&val, ADF_DEC))
-		goto err;
-
-	val = 512;
-	snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_SIZE, 0);
-	if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-					key, (void *)&val, ADF_DEC))
-		goto err;
-
-	val = 0;
-	snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_TX, 0);
-	if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-					key, (void *)&val, ADF_DEC))
-		goto err;
-
-	val = 2;
-	snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_TX, 0);
-	if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-					key, (void *)&val, ADF_DEC))
-		goto err;
-
-	val = 8;
-	snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_RX, 0);
-	if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-					key, (void *)&val, ADF_DEC))
-		goto err;
-
-	val = 10;
-	snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_RX, 0);
-	if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-					key, (void *)&val, ADF_DEC))
-			goto err;
-
-	val = ADF_COALESCING_DEF_TIME;
-	snprintf(key, sizeof(key), ADF_ETRMGR_COALESCE_TIMER_FORMAT,
-		 (int)bank);
-	if (adf_cfg_add_key_value_param(accel_dev, "Accelerator0",
-					key, (void *)&val, ADF_DEC))
-		goto err;
-
-	val = 1;
-	if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-					ADF_NUM_CY, (void *)&val, ADF_DEC))
-		goto err;
-
-	set_bit(ADF_STATUS_CONFIGURED, &accel_dev->status);
-	return 0;
-err:
-	dev_err(&GET_DEV(accel_dev), "Failed to configure QAT accel dev\n");
-	return -EINVAL;
-}
-
 static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct adf_accel_dev *accel_dev;
@@ -288,7 +207,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 	}
 
-	if (pci_request_regions(pdev, adf_driver_name)) {
+	if (pci_request_regions(pdev, ADF_DH895XCCVF_DEVICE_NAME)) {
 		ret = -EFAULT;
 		goto out_err_disable;
 	}
@@ -315,7 +234,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* Completion for VF2PF request/response message exchange */
 	init_completion(&accel_dev->vf.iov_msg_completion);
 
-	ret = adf_dev_configure(accel_dev);
+	ret = qat_crypto_dev_config(accel_dev);
 	if (ret)
 		goto out_err_free_reg;
 
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.h b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.h
deleted file mode 100644
index e270e4a..0000000
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.h
+++ /dev/null
@@ -1,57 +0,0 @@
-/*
-  This file is provided under a dual BSD/GPLv2 license.  When using or
-  redistributing this file, you may do so under either license.
-
-  GPL LICENSE SUMMARY
-  Copyright(c) 2014 Intel Corporation.
-  This program is free software; you can redistribute it and/or modify
-  it under the terms of version 2 of the GNU General Public License as
-  published by the Free Software Foundation.
-
-  This program is distributed in the hope that it will be useful, but
-  WITHOUT ANY WARRANTY; without even the implied warranty of
-  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-  General Public License for more details.
-
-  Contact Information:
-  qat-linux@intel.com
-
-  BSD LICENSE
-  Copyright(c) 2014 Intel Corporation.
-  Redistribution and use in source and binary forms, with or without
-  modification, are permitted provided that the following conditions
-  are met:
-
-    * Redistributions of source code must retain the above copyright
-      notice, this list of conditions and the following disclaimer.
-    * Redistributions in binary form must reproduce the above copyright
-      notice, this list of conditions and the following disclaimer in
-      the documentation and/or other materials provided with the
-      distribution.
-    * Neither the name of Intel Corporation nor the names of its
-      contributors may be used to endorse or promote products derived
-      from this software without specific prior written permission.
-
-  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
-  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
-  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
-  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
-  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
-  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
-  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
-  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
-  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
-  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-*/
-#ifndef ADF_DH895xVF_DRV_H_
-#define ADF_DH895xVF_DRV_H_
-#include <adf_accel_devices.h>
-#include <adf_transport.h>
-
-void adf_init_hw_data_dh895xcciov(struct adf_hw_device_data *hw_data);
-void adf_clean_hw_data_dh895xcciov(struct adf_hw_device_data *hw_data);
-int adf_vf_isr_resource_alloc(struct adf_accel_dev *accel_dev);
-void adf_vf_isr_resource_free(struct adf_accel_dev *accel_dev);
-void adf_update_ring_arb_enable(struct adf_etr_ring_data *ring);
-#endif
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_isr.c b/drivers/crypto/qat/qat_dh895xccvf/adf_isr.c
deleted file mode 100644
index 87c5d8a..0000000
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_isr.c
+++ /dev/null
@@ -1,258 +0,0 @@
-/*
-  This file is provided under a dual BSD/GPLv2 license.  When using or
-  redistributing this file, you may do so under either license.
-
-  GPL LICENSE SUMMARY
-  Copyright(c) 2014 Intel Corporation.
-  This program is free software; you can redistribute it and/or modify
-  it under the terms of version 2 of the GNU General Public License as
-  published by the Free Software Foundation.
-
-  This program is distributed in the hope that it will be useful, but
-  WITHOUT ANY WARRANTY; without even the implied warranty of
-  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-  General Public License for more details.
-
-  Contact Information:
-  qat-linux@intel.com
-
-  BSD LICENSE
-  Copyright(c) 2014 Intel Corporation.
-  Redistribution and use in source and binary forms, with or without
-  modification, are permitted provided that the following conditions
-  are met:
-
-    * Redistributions of source code must retain the above copyright
-      notice, this list of conditions and the following disclaimer.
-    * Redistributions in binary form must reproduce the above copyright
-      notice, this list of conditions and the following disclaimer in
-      the documentation and/or other materials provided with the
-      distribution.
-    * Neither the name of Intel Corporation nor the names of its
-      contributors may be used to endorse or promote products derived
-      from this software without specific prior written permission.
-
-  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
-  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
-  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
-  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
-  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
-  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
-  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
-  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
-  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
-  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-*/
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/types.h>
-#include <linux/pci.h>
-#include <linux/slab.h>
-#include <linux/errno.h>
-#include <linux/interrupt.h>
-#include <adf_accel_devices.h>
-#include <adf_common_drv.h>
-#include <adf_cfg.h>
-#include <adf_cfg_strings.h>
-#include <adf_cfg_common.h>
-#include <adf_transport_access_macros.h>
-#include <adf_transport_internal.h>
-#include <adf_pf2vf_msg.h>
-#include "adf_drv.h"
-#include "adf_dh895xccvf_hw_data.h"
-
-static int adf_enable_msi(struct adf_accel_dev *accel_dev)
-{
-	struct adf_accel_pci *pci_dev_info = &accel_dev->accel_pci_dev;
-	int stat = pci_enable_msi(pci_dev_info->pci_dev);
-
-	if (stat) {
-		dev_err(&GET_DEV(accel_dev),
-			"Failed to enable MSI interrupts\n");
-		return stat;
-	}
-
-	accel_dev->vf.irq_name = kzalloc(ADF_MAX_MSIX_VECTOR_NAME, GFP_KERNEL);
-	if (!accel_dev->vf.irq_name)
-		return -ENOMEM;
-
-	return stat;
-}
-
-static void adf_disable_msi(struct adf_accel_dev *accel_dev)
-{
-	struct pci_dev *pdev = accel_to_pci_dev(accel_dev);
-
-	kfree(accel_dev->vf.irq_name);
-	pci_disable_msi(pdev);
-}
-
-static void adf_pf2vf_bh_handler(void *data)
-{
-	struct adf_accel_dev *accel_dev = data;
-	void __iomem *pmisc_bar_addr =
-		(&GET_BARS(accel_dev)[ADF_DH895XCCIOV_PMISC_BAR])->virt_addr;
-	u32 msg;
-
-	/* Read the message from PF */
-	msg = ADF_CSR_RD(pmisc_bar_addr, ADF_DH895XCCIOV_PF2VF_OFFSET);
-
-	if (!(msg & ADF_PF2VF_MSGORIGIN_SYSTEM))
-		/* Ignore legacy non-system (non-kernel) PF2VF messages */
-		goto err;
-
-	switch ((msg & ADF_PF2VF_MSGTYPE_MASK) >> ADF_PF2VF_MSGTYPE_SHIFT) {
-	case ADF_PF2VF_MSGTYPE_RESTARTING:
-		dev_dbg(&GET_DEV(accel_dev),
-			"Restarting msg received from PF 0x%x\n", msg);
-		adf_dev_stop(accel_dev);
-		break;
-	case ADF_PF2VF_MSGTYPE_VERSION_RESP:
-		dev_dbg(&GET_DEV(accel_dev),
-			"Version resp received from PF 0x%x\n", msg);
-		accel_dev->vf.pf_version =
-			(msg & ADF_PF2VF_VERSION_RESP_VERS_MASK) >>
-			ADF_PF2VF_VERSION_RESP_VERS_SHIFT;
-		accel_dev->vf.compatible =
-			(msg & ADF_PF2VF_VERSION_RESP_RESULT_MASK) >>
-			ADF_PF2VF_VERSION_RESP_RESULT_SHIFT;
-		complete(&accel_dev->vf.iov_msg_completion);
-		break;
-	default:
-		goto err;
-	}
-
-	/* To ack, clear the PF2VFINT bit */
-	msg &= ~ADF_DH895XCC_PF2VF_PF2VFINT;
-	ADF_CSR_WR(pmisc_bar_addr, ADF_DH895XCCIOV_PF2VF_OFFSET, msg);
-
-	/* Re-enable PF2VF interrupts */
-	adf_enable_pf2vf_interrupts(accel_dev);
-	return;
-err:
-	dev_err(&GET_DEV(accel_dev),
-		"Unknown message from PF (0x%x); leaving PF2VF ints disabled\n",
-		msg);
-}
-
-static int adf_setup_pf2vf_bh(struct adf_accel_dev *accel_dev)
-{
-	tasklet_init(&accel_dev->vf.pf2vf_bh_tasklet,
-		     (void *)adf_pf2vf_bh_handler, (unsigned long)accel_dev);
-
-	mutex_init(&accel_dev->vf.vf2pf_lock);
-	return 0;
-}
-
-static void adf_cleanup_pf2vf_bh(struct adf_accel_dev *accel_dev)
-{
-	tasklet_disable(&accel_dev->vf.pf2vf_bh_tasklet);
-	tasklet_kill(&accel_dev->vf.pf2vf_bh_tasklet);
-	mutex_destroy(&accel_dev->vf.vf2pf_lock);
-}
-
-static irqreturn_t adf_isr(int irq, void *privdata)
-{
-	struct adf_accel_dev *accel_dev = privdata;
-	void __iomem *pmisc_bar_addr =
-		(&GET_BARS(accel_dev)[ADF_DH895XCCIOV_PMISC_BAR])->virt_addr;
-	u32 v_int;
-
-	/* Read VF INT source CSR to determine the source of VF interrupt */
-	v_int = ADF_CSR_RD(pmisc_bar_addr, ADF_DH895XCCIOV_VINTSOU_OFFSET);
-
-	/* Check for PF2VF interrupt */
-	if (v_int & ADF_DH895XCC_VINTSOU_PF2VF) {
-		/* Disable PF to VF interrupt */
-		adf_disable_pf2vf_interrupts(accel_dev);
-
-		/* Schedule tasklet to handle interrupt BH */
-		tasklet_hi_schedule(&accel_dev->vf.pf2vf_bh_tasklet);
-		return IRQ_HANDLED;
-	}
-
-	/* Check bundle interrupt */
-	if (v_int & ADF_DH895XCC_VINTSOU_BUN) {
-		struct adf_etr_data *etr_data = accel_dev->transport;
-		struct adf_etr_bank_data *bank = &etr_data->banks[0];
-
-		/* Disable Flag and Coalesce Ring Interrupts */
-		WRITE_CSR_INT_FLAG_AND_COL(bank->csr_addr, bank->bank_number,
-					   0);
-		tasklet_hi_schedule(&bank->resp_handler);
-		return IRQ_HANDLED;
-	}
-
-	return IRQ_NONE;
-}
-
-static int adf_request_msi_irq(struct adf_accel_dev *accel_dev)
-{
-	struct pci_dev *pdev = accel_to_pci_dev(accel_dev);
-	unsigned int cpu;
-	int ret;
-
-	snprintf(accel_dev->vf.irq_name, ADF_MAX_MSIX_VECTOR_NAME,
-		 "qat_%02x:%02d.%02d", pdev->bus->number, PCI_SLOT(pdev->devfn),
-		 PCI_FUNC(pdev->devfn));
-	ret = request_irq(pdev->irq, adf_isr, 0, accel_dev->vf.irq_name,
-			  (void *)accel_dev);
-	if (ret) {
-		dev_err(&GET_DEV(accel_dev), "failed to enable irq for %s\n",
-			accel_dev->vf.irq_name);
-		return ret;
-	}
-	cpu = accel_dev->accel_id % num_online_cpus();
-	irq_set_affinity_hint(pdev->irq, get_cpu_mask(cpu));
-
-	return ret;
-}
-
-static int adf_setup_bh(struct adf_accel_dev *accel_dev)
-{
-	struct adf_etr_data *priv_data = accel_dev->transport;
-
-	tasklet_init(&priv_data->banks[0].resp_handler, adf_response_handler,
-		     (unsigned long)priv_data->banks);
-	return 0;
-}
-
-static void adf_cleanup_bh(struct adf_accel_dev *accel_dev)
-{
-	struct adf_etr_data *priv_data = accel_dev->transport;
-
-	tasklet_disable(&priv_data->banks[0].resp_handler);
-	tasklet_kill(&priv_data->banks[0].resp_handler);
-}
-
-void adf_vf_isr_resource_free(struct adf_accel_dev *accel_dev)
-{
-	struct pci_dev *pdev = accel_to_pci_dev(accel_dev);
-
-	irq_set_affinity_hint(pdev->irq, NULL);
-	free_irq(pdev->irq, (void *)accel_dev);
-	adf_cleanup_bh(accel_dev);
-	adf_cleanup_pf2vf_bh(accel_dev);
-	adf_disable_msi(accel_dev);
-}
-
-int adf_vf_isr_resource_alloc(struct adf_accel_dev *accel_dev)
-{
-	if (adf_enable_msi(accel_dev))
-		goto err_out;
-
-	if (adf_setup_pf2vf_bh(accel_dev))
-		goto err_out;
-
-	if (adf_setup_bh(accel_dev))
-		goto err_out;
-
-	if (adf_request_msi_irq(accel_dev))
-		goto err_out;
-
-	return 0;
-err_out:
-	adf_vf_isr_resource_free(accel_dev);
-	return -EFAULT;
-}
