From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 1/5] crypto: qat - Move adf admin and adf hw arbitrer to
 common code
Date: Fri, 07 Aug 2015 11:34:20 -0700
Message-ID: <20150807183419.630.42078.stgit@tstruk-mobl1>
References: <20150807183414.630.25889.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, bhelgaas@google.com,
	linux-pci@vger.kernel.org, qat-linux@intel.com,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20150807183414.630.25889.stgit@tstruk-mobl1>
Sender: linux-pci-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Adf admin and HW arbiter function can be used by dh895xcc specific code
well as the new dh895xccvf and future devices so moving them to
qat_common so that they can be shared.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/Makefile             |    2 
 drivers/crypto/qat/qat_common/adf_accel_devices.h  |    5 -
 drivers/crypto/qat/qat_common/adf_admin.c          |  185 ++++++++++++++++++++
 drivers/crypto/qat/qat_common/adf_common_drv.h     |    7 +
 drivers/crypto/qat/qat_common/adf_hw_arbiter.c     |  168 ++++++++++++++++++
 drivers/crypto/qat/qat_common/adf_init.c           |   84 +--------
 drivers/crypto/qat/qat_common/adf_transport.c      |    7 -
 drivers/crypto/qat/qat_common/qat_crypto.c         |    3 
 drivers/crypto/qat/qat_dh895xcc/Makefile           |    5 -
 drivers/crypto/qat/qat_dh895xcc/adf_admin.c        |  145 ----------------
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c |    6 -
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h |    5 -
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c          |    3 
 drivers/crypto/qat/qat_dh895xcc/adf_drv.h          |    9 -
 drivers/crypto/qat/qat_dh895xcc/adf_hw_arbiter.c   |  159 -----------------
 drivers/crypto/qat/qat_dh895xcc/qat_admin.c        |  107 ------------
 16 files changed, 378 insertions(+), 522 deletions(-)
 create mode 100644 drivers/crypto/qat/qat_common/adf_admin.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_hw_arbiter.c
 delete mode 100644 drivers/crypto/qat/qat_dh895xcc/adf_admin.c
 delete mode 100644 drivers/crypto/qat/qat_dh895xcc/adf_hw_arbiter.c
 delete mode 100644 drivers/crypto/qat/qat_dh895xcc/qat_admin.c

diff --git a/drivers/crypto/qat/qat_common/Makefile b/drivers/crypto/qat/qat_common/Makefile
index 184605f..e5fe4e7 100644
--- a/drivers/crypto/qat/qat_common/Makefile
+++ b/drivers/crypto/qat/qat_common/Makefile
@@ -9,6 +9,8 @@ intel_qat-objs := adf_cfg.o \
 	adf_accel_engine.o \
 	adf_aer.o \
 	adf_transport.o \
+	adf_admin.o \
+	adf_hw_arbiter.o \
 	qat_crypto.o \
 	qat_algs.o \
 	qat_rsakey-asn1.o \
diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 99cbce6..a7d3d11 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -141,15 +141,16 @@ struct adf_hw_device_data {
 	uint32_t (*get_num_aes)(struct adf_hw_device_data *self);
 	uint32_t (*get_num_accels)(struct adf_hw_device_data *self);
 	enum dev_sku_info (*get_sku)(struct adf_hw_device_data *self);
-	void (*hw_arb_ring_enable)(struct adf_etr_ring_data *ring);
-	void (*hw_arb_ring_disable)(struct adf_etr_ring_data *ring);
 	int (*alloc_irq)(struct adf_accel_dev *accel_dev);
 	void (*free_irq)(struct adf_accel_dev *accel_dev);
 	void (*enable_error_correction)(struct adf_accel_dev *accel_dev);
 	int (*init_admin_comms)(struct adf_accel_dev *accel_dev);
 	void (*exit_admin_comms)(struct adf_accel_dev *accel_dev);
+	int (*send_admin_init)(struct adf_accel_dev *accel_dev);
 	int (*init_arb)(struct adf_accel_dev *accel_dev);
 	void (*exit_arb)(struct adf_accel_dev *accel_dev);
+	void (*get_arb_mapping)(struct adf_accel_dev *accel_dev,
+				const uint32_t **cfg);
 	void (*enable_ints)(struct adf_accel_dev *accel_dev);
 	const char *fw_name;
 	const char *fw_mmp_name;
diff --git a/drivers/crypto/qat/qat_common/adf_admin.c b/drivers/crypto/qat/qat_common/adf_admin.c
new file mode 100644
index 0000000..0a76168
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_admin.c
@@ -0,0 +1,185 @@
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
+#include <linux/types.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/pci.h>
+#include <linux/dma-mapping.h>
+#include "adf_accel_devices.h"
+#include "icp_qat_fw_init_admin.h"
+
+/* Admin Messages Registers */
+#define ADF_DH895XCC_ADMINMSGUR_OFFSET (0x3A000 + 0x574)
+#define ADF_DH895XCC_ADMINMSGLR_OFFSET (0x3A000 + 0x578)
+#define ADF_DH895XCC_MAILBOX_BASE_OFFSET 0x20970
+#define ADF_DH895XCC_MAILBOX_STRIDE 0x1000
+#define ADF_ADMINMSG_LEN 32
+
+struct adf_admin_comms {
+	dma_addr_t phy_addr;
+	void *virt_addr;
+	void __iomem *mailbox_addr;
+	struct mutex lock;	/* protects adf_admin_comms struct */
+};
+
+static int adf_put_admin_msg_sync(struct adf_accel_dev *accel_dev, u32 ae,
+				  void *in, void *out)
+{
+	struct adf_admin_comms *admin = accel_dev->admin;
+	int offset = ae * ADF_ADMINMSG_LEN * 2;
+	void __iomem *mailbox = admin->mailbox_addr;
+	int mb_offset = ae * ADF_DH895XCC_MAILBOX_STRIDE;
+	int times, received;
+
+	mutex_lock(&admin->lock);
+
+	if (ADF_CSR_RD(mailbox, mb_offset) == 1) {
+		mutex_unlock(&admin->lock);
+		return -EAGAIN;
+	}
+
+	memcpy(admin->virt_addr + offset, in, ADF_ADMINMSG_LEN);
+	ADF_CSR_WR(mailbox, mb_offset, 1);
+	received = 0;
+	for (times = 0; times < 50; times++) {
+		msleep(20);
+		if (ADF_CSR_RD(mailbox, mb_offset) == 0) {
+			received = 1;
+			break;
+		}
+	}
+	if (received)
+		memcpy(out, admin->virt_addr + offset +
+		       ADF_ADMINMSG_LEN, ADF_ADMINMSG_LEN);
+	else
+		dev_err(&GET_DEV(accel_dev),
+			"Failed to send admin msg to accelerator\n");
+
+	mutex_unlock(&admin->lock);
+	return received ? 0 : -EFAULT;
+}
+
+static int adf_send_admin_cmd(struct adf_accel_dev *accel_dev, int cmd)
+{
+	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
+	struct icp_qat_fw_init_admin_req req;
+	struct icp_qat_fw_init_admin_resp resp;
+	int i;
+
+	memset(&req, 0, sizeof(struct icp_qat_fw_init_admin_req));
+	req.init_admin_cmd_id = cmd;
+	for (i = 0; i < hw_device->get_num_aes(hw_device); i++) {
+		memset(&resp, 0, sizeof(struct icp_qat_fw_init_admin_resp));
+		if (adf_put_admin_msg_sync(accel_dev, i, &req, &resp) ||
+		    resp.init_resp_hdr.status)
+			return -EFAULT;
+	}
+	return 0;
+}
+
+/**
+ * adf_send_admin_init() - Function sends init message to FW
+ * @accel_dev: Pointer to acceleration device.
+ *
+ * Function sends admin init message to the FW
+ *
+ * Return: 0 on success, error code otherwise.
+ */
+int adf_send_admin_init(struct adf_accel_dev *accel_dev)
+{
+	return adf_send_admin_cmd(accel_dev, ICP_QAT_FW_INIT_ME);
+}
+EXPORT_SYMBOL_GPL(adf_send_admin_init);
+
+int adf_init_admin_comms(struct adf_accel_dev *accel_dev)
+{
+	struct adf_admin_comms *admin;
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct adf_bar *pmisc =
+		&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
+	void __iomem *csr = pmisc->virt_addr;
+	void __iomem *mailbox = csr + ADF_DH895XCC_MAILBOX_BASE_OFFSET;
+	u64 reg_val;
+
+	admin = kzalloc_node(sizeof(*accel_dev->admin), GFP_KERNEL,
+			     dev_to_node(&GET_DEV(accel_dev)));
+	if (!admin)
+		return -ENOMEM;
+	admin->virt_addr = dma_zalloc_coherent(&GET_DEV(accel_dev), PAGE_SIZE,
+					       &admin->phy_addr, GFP_KERNEL);
+	if (!admin->virt_addr) {
+		dev_err(&GET_DEV(accel_dev), "Failed to allocate dma buff\n");
+		kfree(admin);
+		return -ENOMEM;
+	}
+	reg_val = (u64)admin->phy_addr;
+	ADF_CSR_WR(csr, ADF_DH895XCC_ADMINMSGUR_OFFSET, reg_val >> 32);
+	ADF_CSR_WR(csr, ADF_DH895XCC_ADMINMSGLR_OFFSET, reg_val);
+	mutex_init(&admin->lock);
+	admin->mailbox_addr = mailbox;
+	accel_dev->admin = admin;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(adf_init_admin_comms);
+
+void adf_exit_admin_comms(struct adf_accel_dev *accel_dev)
+{
+	struct adf_admin_comms *admin = accel_dev->admin;
+
+	if (!admin)
+		return;
+
+	if (admin->virt_addr)
+		dma_free_coherent(&GET_DEV(accel_dev), PAGE_SIZE,
+				  admin->virt_addr, admin->phy_addr);
+
+	mutex_destroy(&admin->lock);
+	kfree(admin);
+	accel_dev->admin = NULL;
+}
+EXPORT_SYMBOL_GPL(adf_exit_admin_comms);
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index 3c33fee..7935a38 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -91,7 +91,6 @@ struct service_hndl {
 	unsigned long start_status;
 	char *name;
 	struct list_head list;
-	int admin;
 };
 
 static inline int get_current_node(void)
@@ -135,6 +134,12 @@ int adf_enable_aer(struct adf_accel_dev *accel_dev, struct pci_driver *adf);
 void adf_disable_aer(struct adf_accel_dev *accel_dev);
 int adf_init_aer(void);
 void adf_exit_aer(void);
+int adf_init_admin_comms(struct adf_accel_dev *accel_dev);
+void adf_exit_admin_comms(struct adf_accel_dev *accel_dev);
+int adf_send_admin_init(struct adf_accel_dev *accel_dev);
+int adf_init_arb(struct adf_accel_dev *accel_dev);
+void adf_exit_arb(struct adf_accel_dev *accel_dev);
+void adf_update_ring_arb(struct adf_etr_ring_data *ring);
 
 int adf_dev_get(struct adf_accel_dev *accel_dev);
 void adf_dev_put(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/qat/qat_common/adf_hw_arbiter.c b/drivers/crypto/qat/qat_common/adf_hw_arbiter.c
new file mode 100644
index 0000000..6849422
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_hw_arbiter.c
@@ -0,0 +1,168 @@
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
+#include "adf_accel_devices.h"
+#include "adf_transport_internal.h"
+
+#define ADF_ARB_NUM 4
+#define ADF_ARB_REQ_RING_NUM 8
+#define ADF_ARB_REG_SIZE 0x4
+#define ADF_ARB_WTR_SIZE 0x20
+#define ADF_ARB_OFFSET 0x30000
+#define ADF_ARB_REG_SLOT 0x1000
+#define ADF_ARB_WTR_OFFSET 0x010
+#define ADF_ARB_RO_EN_OFFSET 0x090
+#define ADF_ARB_WQCFG_OFFSET 0x100
+#define ADF_ARB_WRK_2_SER_MAP_OFFSET 0x180
+#define ADF_ARB_RINGSRVARBEN_OFFSET 0x19C
+
+#define WRITE_CSR_ARB_RINGSRVARBEN(csr_addr, index, value) \
+	ADF_CSR_WR(csr_addr, ADF_ARB_RINGSRVARBEN_OFFSET + \
+	(ADF_ARB_REG_SLOT * index), value)
+
+#define WRITE_CSR_ARB_RESPORDERING(csr_addr, index, value) \
+	ADF_CSR_WR(csr_addr, (ADF_ARB_OFFSET + \
+	ADF_ARB_RO_EN_OFFSET) + (ADF_ARB_REG_SIZE * index), value)
+
+#define WRITE_CSR_ARB_WEIGHT(csr_addr, arb, index, value) \
+	ADF_CSR_WR(csr_addr, (ADF_ARB_OFFSET + \
+	ADF_ARB_WTR_OFFSET) + (ADF_ARB_WTR_SIZE * arb) + \
+	(ADF_ARB_REG_SIZE * index), value)
+
+#define WRITE_CSR_ARB_SARCONFIG(csr_addr, index, value) \
+	ADF_CSR_WR(csr_addr, ADF_ARB_OFFSET + \
+	(ADF_ARB_REG_SIZE * index), value)
+
+#define WRITE_CSR_ARB_WRK_2_SER_MAP(csr_addr, index, value) \
+	ADF_CSR_WR(csr_addr, (ADF_ARB_OFFSET + \
+	ADF_ARB_WRK_2_SER_MAP_OFFSET) + \
+	(ADF_ARB_REG_SIZE * index), value)
+
+#define WRITE_CSR_ARB_WQCFG(csr_addr, index, value) \
+	ADF_CSR_WR(csr_addr, (ADF_ARB_OFFSET + \
+	ADF_ARB_WQCFG_OFFSET) + (ADF_ARB_REG_SIZE * index), value)
+
+int adf_init_arb(struct adf_accel_dev *accel_dev)
+{
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	void __iomem *csr = accel_dev->transport->banks[0].csr_addr;
+	u32 arb_cfg = 0x1 << 31 | 0x4 << 4 | 0x1;
+	u32 arb, i;
+	const u32 *thd_2_arb_cfg;
+
+	/* Service arb configured for 32 bytes responses and
+	 * ring flow control check enabled. */
+	for (arb = 0; arb < ADF_ARB_NUM; arb++)
+		WRITE_CSR_ARB_SARCONFIG(csr, arb, arb_cfg);
+
+	/* Setup service weighting */
+	for (arb = 0; arb < ADF_ARB_NUM; arb++)
+		for (i = 0; i < ADF_ARB_REQ_RING_NUM; i++)
+			WRITE_CSR_ARB_WEIGHT(csr, arb, i, 0xFFFFFFFF);
+
+	/* Setup ring response ordering */
+	for (i = 0; i < ADF_ARB_REQ_RING_NUM; i++)
+		WRITE_CSR_ARB_RESPORDERING(csr, i, 0xFFFFFFFF);
+
+	/* Setup worker queue registers */
+	for (i = 0; i < hw_data->num_engines; i++)
+		WRITE_CSR_ARB_WQCFG(csr, i, i);
+
+	/* Map worker threads to service arbiters */
+	hw_data->get_arb_mapping(accel_dev, &thd_2_arb_cfg);
+
+	if (!thd_2_arb_cfg)
+		return -EFAULT;
+
+	for (i = 0; i < hw_data->num_engines; i++)
+		WRITE_CSR_ARB_WRK_2_SER_MAP(csr, i, *(thd_2_arb_cfg + i));
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(adf_init_arb);
+
+/**
+ * adf_update_ring_arb() - update ring arbitration rgister
+ * @accel_dev:  Pointer to ring data.
+ *
+ * Function enables or disables rings for/from arbitration.
+ */
+void adf_update_ring_arb(struct adf_etr_ring_data *ring)
+{
+	WRITE_CSR_ARB_RINGSRVARBEN(ring->bank->csr_addr,
+				   ring->bank->bank_number,
+				   ring->bank->ring_mask & 0xFF);
+}
+EXPORT_SYMBOL_GPL(adf_update_ring_arb);
+
+void adf_exit_arb(struct adf_accel_dev *accel_dev)
+{
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	void __iomem *csr;
+	unsigned int i;
+
+	if (!accel_dev->transport)
+		return;
+
+	csr = accel_dev->transport->banks[0].csr_addr;
+
+	/* Reset arbiter configuration */
+	for (i = 0; i < ADF_ARB_NUM; i++)
+		WRITE_CSR_ARB_SARCONFIG(csr, i, 0);
+
+	/* Shutdown work queue */
+	for (i = 0; i < hw_data->num_engines; i++)
+		WRITE_CSR_ARB_WQCFG(csr, i, 0);
+
+	/* Unmap worker threads to service arbiters */
+	for (i = 0; i < hw_data->num_engines; i++)
+		WRITE_CSR_ARB_WRK_2_SER_MAP(csr, i, 0);
+
+	/* Disable arbitration on all rings */
+	for (i = 0; i < GET_MAX_BANKS(accel_dev); i++)
+		WRITE_CSR_ARB_RINGSRVARBEN(csr, i, 0);
+}
+EXPORT_SYMBOL_GPL(adf_exit_arb);
diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
index 9a90b28..1aaa5fd 100644
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -177,20 +177,6 @@ int adf_dev_init(struct adf_accel_dev *accel_dev)
 	 */
 	list_for_each(list_itr, &service_table) {
 		service = list_entry(list_itr, struct service_hndl, list);
-		if (!service->admin)
-			continue;
-		if (service->event_hld(accel_dev, ADF_EVENT_INIT)) {
-			dev_err(&GET_DEV(accel_dev),
-				"Failed to initialise service %s\n",
-				service->name);
-			return -EFAULT;
-		}
-		set_bit(accel_dev->accel_id, &service->init_status);
-	}
-	list_for_each(list_itr, &service_table) {
-		service = list_entry(list_itr, struct service_hndl, list);
-		if (service->admin)
-			continue;
 		if (service->event_hld(accel_dev, ADF_EVENT_INIT)) {
 			dev_err(&GET_DEV(accel_dev),
 				"Failed to initialise service %s\n",
@@ -218,6 +204,7 @@ EXPORT_SYMBOL_GPL(adf_dev_init);
  */
 int adf_dev_start(struct adf_accel_dev *accel_dev)
 {
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	struct service_hndl *service;
 	struct list_head *list_itr;
 
@@ -229,22 +216,13 @@ int adf_dev_start(struct adf_accel_dev *accel_dev)
 	}
 	set_bit(ADF_STATUS_AE_STARTED, &accel_dev->status);
 
-	list_for_each(list_itr, &service_table) {
-		service = list_entry(list_itr, struct service_hndl, list);
-		if (!service->admin)
-			continue;
-		if (service->event_hld(accel_dev, ADF_EVENT_START)) {
-			dev_err(&GET_DEV(accel_dev),
-				"Failed to start service %s\n",
-				service->name);
-			return -EFAULT;
-		}
-		set_bit(accel_dev->accel_id, &service->start_status);
+	if (hw_data->send_admin_init(accel_dev)) {
+		dev_err(&GET_DEV(accel_dev), "Failed to send init message\n");
+		return -EFAULT;
 	}
+
 	list_for_each(list_itr, &service_table) {
 		service = list_entry(list_itr, struct service_hndl, list);
-		if (service->admin)
-			continue;
 		if (service->event_hld(accel_dev, ADF_EVENT_START)) {
 			dev_err(&GET_DEV(accel_dev),
 				"Failed to start service %s\n",
@@ -300,8 +278,6 @@ int adf_dev_stop(struct adf_accel_dev *accel_dev)
 
 	list_for_each(list_itr, &service_table) {
 		service = list_entry(list_itr, struct service_hndl, list);
-		if (service->admin)
-			continue;
 		if (!test_bit(accel_dev->accel_id, &service->start_status))
 			continue;
 		ret = service->event_hld(accel_dev, ADF_EVENT_STOP);
@@ -312,19 +288,6 @@ int adf_dev_stop(struct adf_accel_dev *accel_dev)
 			clear_bit(accel_dev->accel_id, &service->start_status);
 		}
 	}
-	list_for_each(list_itr, &service_table) {
-		service = list_entry(list_itr, struct service_hndl, list);
-		if (!service->admin)
-			continue;
-		if (!test_bit(accel_dev->accel_id, &service->start_status))
-			continue;
-		if (service->event_hld(accel_dev, ADF_EVENT_STOP))
-			dev_err(&GET_DEV(accel_dev),
-				"Failed to shutdown service %s\n",
-				service->name);
-		else
-			clear_bit(accel_dev->accel_id, &service->start_status);
-	}
 
 	if (wait)
 		msleep(100);
@@ -375,21 +338,6 @@ void adf_dev_shutdown(struct adf_accel_dev *accel_dev)
 
 	list_for_each(list_itr, &service_table) {
 		service = list_entry(list_itr, struct service_hndl, list);
-		if (service->admin)
-			continue;
-		if (!test_bit(accel_dev->accel_id, &service->init_status))
-			continue;
-		if (service->event_hld(accel_dev, ADF_EVENT_SHUTDOWN))
-			dev_err(&GET_DEV(accel_dev),
-				"Failed to shutdown service %s\n",
-				service->name);
-		else
-			clear_bit(accel_dev->accel_id, &service->init_status);
-	}
-	list_for_each(list_itr, &service_table) {
-		service = list_entry(list_itr, struct service_hndl, list);
-		if (!service->admin)
-			continue;
 		if (!test_bit(accel_dev->accel_id, &service->init_status))
 			continue;
 		if (service->event_hld(accel_dev, ADF_EVENT_SHUTDOWN))
@@ -426,17 +374,6 @@ int adf_dev_restarting_notify(struct adf_accel_dev *accel_dev)
 
 	list_for_each(list_itr, &service_table) {
 		service = list_entry(list_itr, struct service_hndl, list);
-		if (service->admin)
-			continue;
-		if (service->event_hld(accel_dev, ADF_EVENT_RESTARTING))
-			dev_err(&GET_DEV(accel_dev),
-				"Failed to restart service %s.\n",
-				service->name);
-	}
-	list_for_each(list_itr, &service_table) {
-		service = list_entry(list_itr, struct service_hndl, list);
-		if (!service->admin)
-			continue;
 		if (service->event_hld(accel_dev, ADF_EVENT_RESTARTING))
 			dev_err(&GET_DEV(accel_dev),
 				"Failed to restart service %s.\n",
@@ -452,17 +389,6 @@ int adf_dev_restarted_notify(struct adf_accel_dev *accel_dev)
 
 	list_for_each(list_itr, &service_table) {
 		service = list_entry(list_itr, struct service_hndl, list);
-		if (service->admin)
-			continue;
-		if (service->event_hld(accel_dev, ADF_EVENT_RESTARTED))
-			dev_err(&GET_DEV(accel_dev),
-				"Failed to restart service %s.\n",
-				service->name);
-	}
-	list_for_each(list_itr, &service_table) {
-		service = list_entry(list_itr, struct service_hndl, list);
-		if (!service->admin)
-			continue;
 		if (service->event_hld(accel_dev, ADF_EVENT_RESTARTED))
 			dev_err(&GET_DEV(accel_dev),
 				"Failed to restart service %s.\n",
diff --git a/drivers/crypto/qat/qat_common/adf_transport.c b/drivers/crypto/qat/qat_common/adf_transport.c
index df0331d..d5d8198 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.c
+++ b/drivers/crypto/qat/qat_common/adf_transport.c
@@ -285,7 +285,7 @@ int adf_create_ring(struct adf_accel_dev *accel_dev, const char *section,
 		goto err;
 
 	/* Enable HW arbitration for the given ring */
-	accel_dev->hw_device->hw_arb_ring_enable(ring);
+	adf_update_ring_arb(ring);
 
 	if (adf_ring_debugfs_add(ring, ring_name)) {
 		dev_err(&GET_DEV(accel_dev),
@@ -302,14 +302,13 @@ int adf_create_ring(struct adf_accel_dev *accel_dev, const char *section,
 err:
 	adf_cleanup_ring(ring);
 	adf_unreserve_ring(bank, ring_num);
-	accel_dev->hw_device->hw_arb_ring_disable(ring);
+	adf_update_ring_arb(ring);
 	return ret;
 }
 
 void adf_remove_ring(struct adf_etr_ring_data *ring)
 {
 	struct adf_etr_bank_data *bank = ring->bank;
-	struct adf_accel_dev *accel_dev = bank->accel_dev;
 
 	/* Disable interrupts for the given ring */
 	adf_disable_ring_irq(bank, ring->ring_number);
@@ -322,7 +321,7 @@ void adf_remove_ring(struct adf_etr_ring_data *ring)
 	adf_ring_debugfs_rm(ring);
 	adf_unreserve_ring(bank, ring->ring_number);
 	/* Disable HW arbitration for the given ring */
-	accel_dev->hw_device->hw_arb_ring_disable(ring);
+	adf_update_ring_arb(ring);
 	adf_cleanup_ring(ring);
 }
 
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
index e23ce6f..359ae94 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -152,7 +152,6 @@ static int qat_crypto_create_instances(struct adf_accel_dev *accel_dev)
 
 	INIT_LIST_HEAD(&accel_dev->crypto_list);
 	strlcpy(key, ADF_NUM_CY, sizeof(key));
-
 	if (adf_cfg_get_param_value(accel_dev, SEC, key, val))
 		return -EFAULT;
 
@@ -181,7 +180,9 @@ static int qat_crypto_create_instances(struct adf_accel_dev *accel_dev)
 
 		if (kstrtoul(val, 10, &num_msg_sym))
 			goto err;
+
 		num_msg_sym = num_msg_sym >> 1;
+
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_SIZE, i);
 		if (adf_cfg_get_param_value(accel_dev, SEC, key, val))
 			goto err;
diff --git a/drivers/crypto/qat/qat_dh895xcc/Makefile b/drivers/crypto/qat/qat_dh895xcc/Makefile
index 25171c5..8c79c54 100644
--- a/drivers/crypto/qat/qat_dh895xcc/Makefile
+++ b/drivers/crypto/qat/qat_dh895xcc/Makefile
@@ -2,7 +2,4 @@ ccflags-y := -I$(src)/../qat_common
 obj-$(CONFIG_CRYPTO_DEV_QAT_DH895xCC) += qat_dh895xcc.o
 qat_dh895xcc-objs := adf_drv.o \
 		adf_isr.o \
-		adf_dh895xcc_hw_data.o \
-		adf_hw_arbiter.o \
-		qat_admin.o \
-		adf_admin.o
+		adf_dh895xcc_hw_data.o
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_admin.c b/drivers/crypto/qat/qat_dh895xcc/adf_admin.c
deleted file mode 100644
index e466606..0000000
--- a/drivers/crypto/qat/qat_dh895xcc/adf_admin.c
+++ /dev/null
@@ -1,145 +0,0 @@
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
-#include <linux/types.h>
-#include <linux/mutex.h>
-#include <linux/slab.h>
-#include <linux/delay.h>
-#include <linux/pci.h>
-#include <linux/dma-mapping.h>
-#include <adf_accel_devices.h>
-#include "adf_drv.h"
-#include "adf_dh895xcc_hw_data.h"
-
-#define ADF_ADMINMSG_LEN 32
-
-struct adf_admin_comms {
-	dma_addr_t phy_addr;
-	void *virt_addr;
-	void __iomem *mailbox_addr;
-	struct mutex lock;	/* protects adf_admin_comms struct */
-};
-
-int adf_put_admin_msg_sync(struct adf_accel_dev *accel_dev,
-			   uint32_t ae, void *in, void *out)
-{
-	struct adf_admin_comms *admin = accel_dev->admin;
-	int offset = ae * ADF_ADMINMSG_LEN * 2;
-	void __iomem *mailbox = admin->mailbox_addr;
-	int mb_offset = ae * ADF_DH895XCC_MAILBOX_STRIDE;
-	int times, received;
-
-	mutex_lock(&admin->lock);
-
-	if (ADF_CSR_RD(mailbox, mb_offset) == 1) {
-		mutex_unlock(&admin->lock);
-		return -EAGAIN;
-	}
-
-	memcpy(admin->virt_addr + offset, in, ADF_ADMINMSG_LEN);
-	ADF_CSR_WR(mailbox, mb_offset, 1);
-	received = 0;
-	for (times = 0; times < 50; times++) {
-		msleep(20);
-		if (ADF_CSR_RD(mailbox, mb_offset) == 0) {
-			received = 1;
-			break;
-		}
-	}
-	if (received)
-		memcpy(out, admin->virt_addr + offset +
-		       ADF_ADMINMSG_LEN, ADF_ADMINMSG_LEN);
-	else
-		dev_err(&GET_DEV(accel_dev),
-			"Failed to send admin msg to accelerator\n");
-
-	mutex_unlock(&admin->lock);
-	return received ? 0 : -EFAULT;
-}
-
-int adf_init_admin_comms(struct adf_accel_dev *accel_dev)
-{
-	struct adf_admin_comms *admin;
-	struct adf_bar *pmisc = &GET_BARS(accel_dev)[ADF_DH895XCC_PMISC_BAR];
-	void __iomem *csr = pmisc->virt_addr;
-	void __iomem *mailbox = csr + ADF_DH895XCC_MAILBOX_BASE_OFFSET;
-	uint64_t reg_val;
-
-	admin = kzalloc_node(sizeof(*accel_dev->admin), GFP_KERNEL,
-			     dev_to_node(&GET_DEV(accel_dev)));
-	if (!admin)
-		return -ENOMEM;
-	admin->virt_addr = dma_zalloc_coherent(&GET_DEV(accel_dev), PAGE_SIZE,
-					       &admin->phy_addr, GFP_KERNEL);
-	if (!admin->virt_addr) {
-		dev_err(&GET_DEV(accel_dev), "Failed to allocate dma buff\n");
-		kfree(admin);
-		return -ENOMEM;
-	}
-	reg_val = (uint64_t)admin->phy_addr;
-	ADF_CSR_WR(csr, ADF_DH895XCC_ADMINMSGUR_OFFSET, reg_val >> 32);
-	ADF_CSR_WR(csr, ADF_DH895XCC_ADMINMSGLR_OFFSET, reg_val);
-	mutex_init(&admin->lock);
-	admin->mailbox_addr = mailbox;
-	accel_dev->admin = admin;
-	return 0;
-}
-
-void adf_exit_admin_comms(struct adf_accel_dev *accel_dev)
-{
-	struct adf_admin_comms *admin = accel_dev->admin;
-
-	if (!admin)
-		return;
-
-	if (admin->virt_addr)
-		dma_free_coherent(&GET_DEV(accel_dev), PAGE_SIZE,
-				  admin->virt_addr, admin->phy_addr);
-
-	mutex_destroy(&admin->lock);
-	kfree(admin);
-	accel_dev->admin = NULL;
-}
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index 155ace9..a3b1be8 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -45,8 +45,8 @@
   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
 #include <adf_accel_devices.h>
+#include <adf_common_drv.h>
 #include "adf_dh895xcc_hw_data.h"
-#include "adf_common_drv.h"
 #include "adf_drv.h"
 
 /* Worker thread to service arbiter mappings based on dev SKUs */
@@ -215,8 +215,6 @@ void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data)
 	hw_data->alloc_irq = adf_isr_resource_alloc;
 	hw_data->free_irq = adf_isr_resource_free;
 	hw_data->enable_error_correction = adf_enable_error_correction;
-	hw_data->hw_arb_ring_enable = adf_update_ring_arb_enable;
-	hw_data->hw_arb_ring_disable = adf_update_ring_arb_enable;
 	hw_data->get_accel_mask = get_accel_mask;
 	hw_data->get_ae_mask = get_ae_mask;
 	hw_data->get_num_accels = get_num_accels;
@@ -229,8 +227,10 @@ void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data)
 	hw_data->fw_mmp_name = ADF_DH895XCC_MMP;
 	hw_data->init_admin_comms = adf_init_admin_comms;
 	hw_data->exit_admin_comms = adf_exit_admin_comms;
+	hw_data->send_admin_init = adf_send_admin_init;
 	hw_data->init_arb = adf_init_arb;
 	hw_data->exit_arb = adf_exit_arb;
+	hw_data->get_arb_mapping = adf_get_arbiter_mapping;
 	hw_data->enable_ints = adf_enable_ints;
 }
 
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
index a4963a9..d410afb 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
@@ -80,11 +80,6 @@
 #define ADF_DH895XCC_CERRSSMSH(i) (i * 0x4000 + 0x10)
 #define ADF_DH895XCC_ERRSSMSH_EN BIT(3)
 
-/* Admin Messages Registers */
-#define ADF_DH895XCC_ADMINMSGUR_OFFSET (0x3A000 + 0x574)
-#define ADF_DH895XCC_ADMINMSGLR_OFFSET (0x3A000 + 0x578)
-#define ADF_DH895XCC_MAILBOX_BASE_OFFSET 0x20970
-#define ADF_DH895XCC_MAILBOX_STRIDE 0x1000
 /* FW names */
 #define ADF_DH895XCC_FW "qat_895xcc.bin"
 #define ADF_DH895XCC_MMP "qat_mmp.bin"
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
index 4abeca1..1837c32 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
@@ -386,8 +386,6 @@ static void adf_remove(struct pci_dev *pdev)
 static int __init adfdrv_init(void)
 {
 	request_module("intel_qat");
-	if (qat_admin_register())
-		return -EFAULT;
 
 	if (pci_register_driver(&adf_driver)) {
 		pr_err("QAT: Driver initialization failed\n");
@@ -399,7 +397,6 @@ static int __init adfdrv_init(void)
 static void __exit adfdrv_release(void)
 {
 	pci_unregister_driver(&adf_driver);
-	qat_admin_unregister();
 }
 
 module_init(adfdrv_init);
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.h b/drivers/crypto/qat/qat_dh895xcc/adf_drv.h
index a2fbb6c..85ff245 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.h
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_drv.h
@@ -53,15 +53,6 @@ void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data);
 void adf_clean_hw_data_dh895xcc(struct adf_hw_device_data *hw_data);
 int adf_isr_resource_alloc(struct adf_accel_dev *accel_dev);
 void adf_isr_resource_free(struct adf_accel_dev *accel_dev);
-void adf_update_ring_arb_enable(struct adf_etr_ring_data *ring);
 void adf_get_arbiter_mapping(struct adf_accel_dev *accel_dev,
 			     uint32_t const **arb_map_config);
-int adf_init_admin_comms(struct adf_accel_dev *accel_dev);
-void adf_exit_admin_comms(struct adf_accel_dev *accel_dev);
-int adf_put_admin_msg_sync(struct adf_accel_dev *accel_dev,
-			   uint32_t ae, void *in, void *out);
-int qat_admin_register(void);
-int qat_admin_unregister(void);
-int adf_init_arb(struct adf_accel_dev *accel_dev);
-void adf_exit_arb(struct adf_accel_dev *accel_dev);
 #endif
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_hw_arbiter.c b/drivers/crypto/qat/qat_dh895xcc/adf_hw_arbiter.c
deleted file mode 100644
index 1864bdb..0000000
--- a/drivers/crypto/qat/qat_dh895xcc/adf_hw_arbiter.c
+++ /dev/null
@@ -1,159 +0,0 @@
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
-#include <adf_accel_devices.h>
-#include <adf_transport_internal.h>
-#include "adf_drv.h"
-
-#define ADF_ARB_NUM 4
-#define ADF_ARB_REQ_RING_NUM 8
-#define ADF_ARB_REG_SIZE 0x4
-#define ADF_ARB_WTR_SIZE 0x20
-#define ADF_ARB_OFFSET 0x30000
-#define ADF_ARB_REG_SLOT 0x1000
-#define ADF_ARB_WTR_OFFSET 0x010
-#define ADF_ARB_RO_EN_OFFSET 0x090
-#define ADF_ARB_WQCFG_OFFSET 0x100
-#define ADF_ARB_WRK_2_SER_MAP_OFFSET 0x180
-#define ADF_ARB_WRK_2_SER_MAP 10
-#define ADF_ARB_RINGSRVARBEN_OFFSET 0x19C
-
-#define WRITE_CSR_ARB_RINGSRVARBEN(csr_addr, index, value) \
-	ADF_CSR_WR(csr_addr, ADF_ARB_RINGSRVARBEN_OFFSET + \
-	(ADF_ARB_REG_SLOT * index), value)
-
-#define WRITE_CSR_ARB_RESPORDERING(csr_addr, index, value) \
-	ADF_CSR_WR(csr_addr, (ADF_ARB_OFFSET + \
-	ADF_ARB_RO_EN_OFFSET) + (ADF_ARB_REG_SIZE * index), value)
-
-#define WRITE_CSR_ARB_WEIGHT(csr_addr, arb, index, value) \
-	ADF_CSR_WR(csr_addr, (ADF_ARB_OFFSET + \
-	ADF_ARB_WTR_OFFSET) + (ADF_ARB_WTR_SIZE * arb) + \
-	(ADF_ARB_REG_SIZE * index), value)
-
-#define WRITE_CSR_ARB_SARCONFIG(csr_addr, index, value) \
-	ADF_CSR_WR(csr_addr, ADF_ARB_OFFSET + \
-	(ADF_ARB_REG_SIZE * index), value)
-
-#define WRITE_CSR_ARB_WRK_2_SER_MAP(csr_addr, index, value) \
-	ADF_CSR_WR(csr_addr, (ADF_ARB_OFFSET + \
-	ADF_ARB_WRK_2_SER_MAP_OFFSET) + \
-	(ADF_ARB_REG_SIZE * index), value)
-
-#define WRITE_CSR_ARB_WQCFG(csr_addr, index, value) \
-	ADF_CSR_WR(csr_addr, (ADF_ARB_OFFSET + \
-	ADF_ARB_WQCFG_OFFSET) + (ADF_ARB_REG_SIZE * index), value)
-
-int adf_init_arb(struct adf_accel_dev *accel_dev)
-{
-	void __iomem *csr = accel_dev->transport->banks[0].csr_addr;
-	uint32_t arb_cfg = 0x1 << 31 | 0x4 << 4 | 0x1;
-	uint32_t arb, i;
-	const uint32_t *thd_2_arb_cfg;
-
-	/* Service arb configured for 32 bytes responses and
-	 * ring flow control check enabled. */
-	for (arb = 0; arb < ADF_ARB_NUM; arb++)
-		WRITE_CSR_ARB_SARCONFIG(csr, arb, arb_cfg);
-
-	/* Setup service weighting */
-	for (arb = 0; arb < ADF_ARB_NUM; arb++)
-		for (i = 0; i < ADF_ARB_REQ_RING_NUM; i++)
-			WRITE_CSR_ARB_WEIGHT(csr, arb, i, 0xFFFFFFFF);
-
-	/* Setup ring response ordering */
-	for (i = 0; i < ADF_ARB_REQ_RING_NUM; i++)
-		WRITE_CSR_ARB_RESPORDERING(csr, i, 0xFFFFFFFF);
-
-	/* Setup worker queue registers */
-	for (i = 0; i < ADF_ARB_WRK_2_SER_MAP; i++)
-		WRITE_CSR_ARB_WQCFG(csr, i, i);
-
-	/* Map worker threads to service arbiters */
-	adf_get_arbiter_mapping(accel_dev, &thd_2_arb_cfg);
-
-	if (!thd_2_arb_cfg)
-		return -EFAULT;
-
-	for (i = 0; i < ADF_ARB_WRK_2_SER_MAP; i++)
-		WRITE_CSR_ARB_WRK_2_SER_MAP(csr, i, *(thd_2_arb_cfg + i));
-
-	return 0;
-}
-
-void adf_update_ring_arb_enable(struct adf_etr_ring_data *ring)
-{
-	WRITE_CSR_ARB_RINGSRVARBEN(ring->bank->csr_addr,
-				   ring->bank->bank_number,
-				   ring->bank->ring_mask & 0xFF);
-}
-
-void adf_exit_arb(struct adf_accel_dev *accel_dev)
-{
-	void __iomem *csr;
-	unsigned int i;
-
-	if (!accel_dev->transport)
-		return;
-
-	csr = accel_dev->transport->banks[0].csr_addr;
-
-	/* Reset arbiter configuration */
-	for (i = 0; i < ADF_ARB_NUM; i++)
-		WRITE_CSR_ARB_SARCONFIG(csr, i, 0);
-
-	/* Shutdown work queue */
-	for (i = 0; i < ADF_ARB_WRK_2_SER_MAP; i++)
-		WRITE_CSR_ARB_WQCFG(csr, i, 0);
-
-	/* Unmap worker threads to service arbiters */
-	for (i = 0; i < ADF_ARB_WRK_2_SER_MAP; i++)
-		WRITE_CSR_ARB_WRK_2_SER_MAP(csr, i, 0);
-
-	/* Disable arbitration on all rings */
-	for (i = 0; i < GET_MAX_BANKS(accel_dev); i++)
-		WRITE_CSR_ARB_RINGSRVARBEN(csr, i, 0);
-}
diff --git a/drivers/crypto/qat/qat_dh895xcc/qat_admin.c b/drivers/crypto/qat/qat_dh895xcc/qat_admin.c
deleted file mode 100644
index 55b7a8e..0000000
--- a/drivers/crypto/qat/qat_dh895xcc/qat_admin.c
+++ /dev/null
@@ -1,107 +0,0 @@
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
-#include <icp_qat_fw_init_admin.h>
-#include <adf_accel_devices.h>
-#include <adf_common_drv.h>
-#include "adf_drv.h"
-
-static struct service_hndl qat_admin;
-
-static int qat_send_admin_cmd(struct adf_accel_dev *accel_dev, int cmd)
-{
-	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
-	struct icp_qat_fw_init_admin_req req;
-	struct icp_qat_fw_init_admin_resp resp;
-	int i;
-
-	memset(&req, 0, sizeof(struct icp_qat_fw_init_admin_req));
-	req.init_admin_cmd_id = cmd;
-	for (i = 0; i < hw_device->get_num_aes(hw_device); i++) {
-		memset(&resp, 0, sizeof(struct icp_qat_fw_init_admin_resp));
-		if (adf_put_admin_msg_sync(accel_dev, i, &req, &resp) ||
-		    resp.init_resp_hdr.status)
-			return -EFAULT;
-	}
-	return 0;
-}
-
-static int qat_admin_start(struct adf_accel_dev *accel_dev)
-{
-	return qat_send_admin_cmd(accel_dev, ICP_QAT_FW_INIT_ME);
-}
-
-static int qat_admin_event_handler(struct adf_accel_dev *accel_dev,
-				   enum adf_event event)
-{
-	int ret;
-
-	switch (event) {
-	case ADF_EVENT_START:
-		ret = qat_admin_start(accel_dev);
-		break;
-	case ADF_EVENT_STOP:
-	case ADF_EVENT_INIT:
-	case ADF_EVENT_SHUTDOWN:
-	default:
-		ret = 0;
-	}
-	return ret;
-}
-
-int qat_admin_register(void)
-{
-	memset(&qat_admin, 0, sizeof(struct service_hndl));
-	qat_admin.event_hld = qat_admin_event_handler;
-	qat_admin.name = "qat_admin";
-	qat_admin.admin = 1;
-	return adf_service_register(&qat_admin);
-}
-
-int qat_admin_unregister(void)
-{
-	return adf_service_unregister(&qat_admin);
-}
