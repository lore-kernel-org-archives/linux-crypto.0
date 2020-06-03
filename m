Return-Path: <SRS0=RCNv=7Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ADF4C433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 17:35:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6609220679
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 17:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbgFCRfL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jun 2020 13:35:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:31625 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726071AbgFCRfK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jun 2020 13:35:10 -0400
IronPort-SDR: HOet97ORLmpLHD1TzIi+xmiylM5ibbwUUkDMtd2etekn8z8dO6IM6BvemMDFNOvOZCyRgOXI2Q
 4EUBQwr2i0wA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2020 10:34:09 -0700
IronPort-SDR: HMudZBo+7/KWNkU/ljMsed42hg+bf1ej35fVdHoMmMC3Yy1c+F71t9hCro7lq3cib8FCOMK3rn
 NA3q3wC11KAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,468,1583222400"; 
   d="scan'208";a="304445561"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga002.fm.intel.com with ESMTP; 03 Jun 2020 10:34:07 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 1/3] crypto: qat - replace user types with kernel u types
Date:   Wed,  3 Jun 2020 18:33:44 +0100
Message-Id: <20200603173346.96967-2-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200603173346.96967-1-giovanni.cabiddu@intel.com>
References: <20200603173346.96967-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Wojciech Ziemba <wojciech.ziemba@intel.com>

Kernel source code should not include stdint.h types.
This patch replaces uintXX_t types with respective ones defined in kernel
headers.

Signed-off-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../crypto/qat/qat_common/adf_accel_devices.h | 54 ++++++++--------
 .../crypto/qat/qat_common/adf_accel_engine.c  |  4 +-
 drivers/crypto/qat/qat_common/adf_aer.c       |  2 +-
 .../crypto/qat/qat_common/adf_common_drv.h    | 12 ++--
 drivers/crypto/qat/qat_common/adf_ctl_drv.c   |  4 +-
 drivers/crypto/qat/qat_common/adf_dev_mgr.c   |  8 +--
 drivers/crypto/qat/qat_common/adf_transport.c | 62 +++++++++----------
 drivers/crypto/qat/qat_common/adf_transport.h |  4 +-
 .../qat_common/adf_transport_access_macros.h  |  6 +-
 .../qat/qat_common/adf_transport_internal.h   | 20 +++---
 drivers/crypto/qat/qat_common/icp_qat_uclo.h  |  6 +-
 drivers/crypto/qat/qat_common/qat_algs.c      | 54 ++++++++--------
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 12 ++--
 drivers/crypto/qat/qat_common/qat_hal.c       | 40 ++++++------
 drivers/crypto/qat/qat_common/qat_uclo.c      | 20 +++---
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   | 26 ++++----
 16 files changed, 167 insertions(+), 167 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index b3500bc4a558..c1db8c26afb6 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -59,8 +59,8 @@ struct adf_accel_pci {
 	struct pci_dev *pci_dev;
 	struct adf_accel_msix msix_entries;
 	struct adf_bar pci_bars[ADF_PCI_MAX_BARS];
-	uint8_t revid;
-	uint8_t sku;
+	u8 revid;
+	u8 sku;
 } __packed;
 
 enum dev_state {
@@ -100,7 +100,7 @@ static inline const char *get_sku_info(enum dev_sku_info info)
 struct adf_hw_device_class {
 	const char *name;
 	const enum adf_device_type type;
-	uint32_t instances;
+	u32 instances;
 } __packed;
 
 struct adf_cfg_device_data;
@@ -110,15 +110,15 @@ struct adf_etr_ring_data;
 
 struct adf_hw_device_data {
 	struct adf_hw_device_class *dev_class;
-	uint32_t (*get_accel_mask)(uint32_t fuse);
-	uint32_t (*get_ae_mask)(uint32_t fuse);
-	uint32_t (*get_sram_bar_id)(struct adf_hw_device_data *self);
-	uint32_t (*get_misc_bar_id)(struct adf_hw_device_data *self);
-	uint32_t (*get_etr_bar_id)(struct adf_hw_device_data *self);
-	uint32_t (*get_num_aes)(struct adf_hw_device_data *self);
-	uint32_t (*get_num_accels)(struct adf_hw_device_data *self);
-	uint32_t (*get_pf2vf_offset)(uint32_t i);
-	uint32_t (*get_vintmsk_offset)(uint32_t i);
+	u32 (*get_accel_mask)(u32 fuse);
+	u32 (*get_ae_mask)(u32 fuse);
+	u32 (*get_sram_bar_id)(struct adf_hw_device_data *self);
+	u32 (*get_misc_bar_id)(struct adf_hw_device_data *self);
+	u32 (*get_etr_bar_id)(struct adf_hw_device_data *self);
+	u32 (*get_num_aes)(struct adf_hw_device_data *self);
+	u32 (*get_num_accels)(struct adf_hw_device_data *self);
+	u32 (*get_pf2vf_offset)(u32 i);
+	u32 (*get_vintmsk_offset)(u32 i);
 	enum dev_sku_info (*get_sku)(struct adf_hw_device_data *self);
 	int (*alloc_irq)(struct adf_accel_dev *accel_dev);
 	void (*free_irq)(struct adf_accel_dev *accel_dev);
@@ -129,25 +129,25 @@ struct adf_hw_device_data {
 	int (*init_arb)(struct adf_accel_dev *accel_dev);
 	void (*exit_arb)(struct adf_accel_dev *accel_dev);
 	void (*get_arb_mapping)(struct adf_accel_dev *accel_dev,
-				const uint32_t **cfg);
+				const u32 **cfg);
 	void (*disable_iov)(struct adf_accel_dev *accel_dev);
 	void (*enable_ints)(struct adf_accel_dev *accel_dev);
 	int (*enable_vf2pf_comms)(struct adf_accel_dev *accel_dev);
 	void (*reset_device)(struct adf_accel_dev *accel_dev);
 	const char *fw_name;
 	const char *fw_mmp_name;
-	uint32_t fuses;
-	uint32_t accel_capabilities_mask;
-	uint32_t instance_id;
-	uint16_t accel_mask;
-	uint16_t ae_mask;
-	uint16_t tx_rings_mask;
-	uint8_t tx_rx_gap;
-	uint8_t num_banks;
-	uint8_t num_accel;
-	uint8_t num_logical_accel;
-	uint8_t num_engines;
-	uint8_t min_iov_compat_ver;
+	u32 fuses;
+	u32 accel_capabilities_mask;
+	u32 instance_id;
+	u16 accel_mask;
+	u16 ae_mask;
+	u16 tx_rings_mask;
+	u8 tx_rx_gap;
+	u8 num_banks;
+	u8 num_accel;
+	u8 num_logical_accel;
+	u8 num_engines;
+	u8 min_iov_compat_ver;
 } __packed;
 
 /* CSR write macro */
@@ -204,8 +204,8 @@ struct adf_accel_dev {
 			struct tasklet_struct pf2vf_bh_tasklet;
 			struct mutex vf2pf_lock; /* protect CSR access */
 			struct completion iov_msg_completion;
-			uint8_t compatible;
-			uint8_t pf_version;
+			u8 compatible;
+			u8 pf_version;
 		} vf;
 	};
 	bool is_vf;
diff --git a/drivers/crypto/qat/qat_common/adf_accel_engine.c b/drivers/crypto/qat/qat_common/adf_accel_engine.c
index 00d4d13e33e8..c8ad85b882be 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_engine.c
+++ b/drivers/crypto/qat/qat_common/adf_accel_engine.c
@@ -74,7 +74,7 @@ int adf_ae_start(struct adf_accel_dev *accel_dev)
 {
 	struct adf_fw_loader_data *loader_data = accel_dev->fw_loader;
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	uint32_t ae_ctr, ae, max_aes = GET_MAX_ACCELENGINES(accel_dev);
+	u32 ae_ctr, ae, max_aes = GET_MAX_ACCELENGINES(accel_dev);
 
 	if (!hw_data->fw_name)
 		return 0;
@@ -95,7 +95,7 @@ int adf_ae_stop(struct adf_accel_dev *accel_dev)
 {
 	struct adf_fw_loader_data *loader_data = accel_dev->fw_loader;
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	uint32_t ae_ctr, ae, max_aes = GET_MAX_ACCELENGINES(accel_dev);
+	u32 ae_ctr, ae, max_aes = GET_MAX_ACCELENGINES(accel_dev);
 
 	if (!hw_data->fw_name)
 		return 0;
diff --git a/drivers/crypto/qat/qat_common/adf_aer.c b/drivers/crypto/qat/qat_common/adf_aer.c
index 35cdc0fbbe40..32102e27e559 100644
--- a/drivers/crypto/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/qat/qat_common/adf_aer.c
@@ -42,7 +42,7 @@ void adf_reset_sbr(struct adf_accel_dev *accel_dev)
 {
 	struct pci_dev *pdev = accel_to_pci_dev(accel_dev);
 	struct pci_dev *parent = pdev->bus->self;
-	uint16_t bridge_ctl = 0;
+	u16 bridge_ctl = 0;
 
 	if (!parent)
 		parent = pdev;
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index ae91203bb617..ebfcb4ea618d 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -79,11 +79,11 @@ int adf_devmgr_add_dev(struct adf_accel_dev *accel_dev,
 void adf_devmgr_rm_dev(struct adf_accel_dev *accel_dev,
 		       struct adf_accel_dev *pf);
 struct list_head *adf_devmgr_get_head(void);
-struct adf_accel_dev *adf_devmgr_get_dev_by_id(uint32_t id);
+struct adf_accel_dev *adf_devmgr_get_dev_by_id(u32 id);
 struct adf_accel_dev *adf_devmgr_get_first(void);
 struct adf_accel_dev *adf_devmgr_pci_to_accel_dev(struct pci_dev *pci_dev);
-int adf_devmgr_verify_id(uint32_t id);
-void adf_devmgr_get_num_dev(uint32_t *num);
+int adf_devmgr_verify_id(u32 id);
+void adf_devmgr_get_num_dev(u32 *num);
 int adf_devmgr_in_reset(struct adf_accel_dev *accel_dev);
 int adf_dev_started(struct adf_accel_dev *accel_dev);
 int adf_dev_restarting_notify(struct adf_accel_dev *accel_dev);
@@ -154,7 +154,7 @@ void qat_hal_set_pc(struct icp_qat_fw_loader_handle *handle,
 		    unsigned char ae, unsigned int ctx_mask, unsigned int upc);
 void qat_hal_wr_uwords(struct icp_qat_fw_loader_handle *handle,
 		       unsigned char ae, unsigned int uaddr,
-		       unsigned int words_num, uint64_t *uword);
+		       unsigned int words_num, u64 *uword);
 void qat_hal_wr_umem(struct icp_qat_fw_loader_handle *handle, unsigned char ae,
 		     unsigned int uword_addr, unsigned int words_num,
 		     unsigned int *data);
@@ -189,9 +189,9 @@ int qat_uclo_map_obj(struct icp_qat_fw_loader_handle *handle,
 int adf_sriov_configure(struct pci_dev *pdev, int numvfs);
 void adf_disable_sriov(struct adf_accel_dev *accel_dev);
 void adf_disable_vf2pf_interrupts(struct adf_accel_dev *accel_dev,
-				  uint32_t vf_mask);
+				  u32 vf_mask);
 void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev,
-				 uint32_t vf_mask);
+				 u32 vf_mask);
 void adf_enable_pf2vf_interrupts(struct adf_accel_dev *accel_dev);
 void adf_disable_pf2vf_interrupts(struct adf_accel_dev *accel_dev);
 
diff --git a/drivers/crypto/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
index 4d4589d4b64c..71d0c44aacca 100644
--- a/drivers/crypto/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
@@ -226,7 +226,7 @@ static int adf_ctl_is_device_in_use(int id)
 	return 0;
 }
 
-static void adf_ctl_stop_devices(uint32_t id)
+static void adf_ctl_stop_devices(u32 id)
 {
 	struct adf_accel_dev *accel_dev;
 
@@ -330,7 +330,7 @@ static int adf_ctl_ioctl_dev_start(struct file *fp, unsigned int cmd,
 static int adf_ctl_ioctl_get_num_devices(struct file *fp, unsigned int cmd,
 					 unsigned long arg)
 {
-	uint32_t num_devices = 0;
+	u32 num_devices = 0;
 
 	adf_devmgr_get_num_dev(&num_devices);
 	if (copy_to_user((void __user *)arg, &num_devices, sizeof(num_devices)))
diff --git a/drivers/crypto/qat/qat_common/adf_dev_mgr.c b/drivers/crypto/qat/qat_common/adf_dev_mgr.c
index e663054a11d5..72753af056b3 100644
--- a/drivers/crypto/qat/qat_common/adf_dev_mgr.c
+++ b/drivers/crypto/qat/qat_common/adf_dev_mgr.c
@@ -8,7 +8,7 @@
 static LIST_HEAD(accel_table);
 static LIST_HEAD(vfs_table);
 static DEFINE_MUTEX(table_lock);
-static uint32_t num_devices;
+static u32 num_devices;
 static u8 id_map[ADF_MAX_DEVICES];
 
 struct vf_id_map {
@@ -311,7 +311,7 @@ struct adf_accel_dev *adf_devmgr_pci_to_accel_dev(struct pci_dev *pci_dev)
 }
 EXPORT_SYMBOL_GPL(adf_devmgr_pci_to_accel_dev);
 
-struct adf_accel_dev *adf_devmgr_get_dev_by_id(uint32_t id)
+struct adf_accel_dev *adf_devmgr_get_dev_by_id(u32 id)
 {
 	struct list_head *itr;
 	int real_id;
@@ -336,7 +336,7 @@ struct adf_accel_dev *adf_devmgr_get_dev_by_id(uint32_t id)
 	return NULL;
 }
 
-int adf_devmgr_verify_id(uint32_t id)
+int adf_devmgr_verify_id(u32 id)
 {
 	if (id == ADF_CFG_ALL_DEVICES)
 		return 0;
@@ -363,7 +363,7 @@ static int adf_get_num_dettached_vfs(void)
 	return vfs;
 }
 
-void adf_devmgr_get_num_dev(uint32_t *num)
+void adf_devmgr_get_num_dev(u32 *num)
 {
 	*num = num_devices - adf_get_num_dettached_vfs();
 }
diff --git a/drivers/crypto/qat/qat_common/adf_transport.c b/drivers/crypto/qat/qat_common/adf_transport.c
index 4625881a8832..2ad774017200 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.c
+++ b/drivers/crypto/qat/qat_common/adf_transport.c
@@ -7,22 +7,22 @@
 #include "adf_cfg.h"
 #include "adf_common_drv.h"
 
-static inline uint32_t adf_modulo(uint32_t data, uint32_t shift)
+static inline u32 adf_modulo(u32 data, u32 shift)
 {
-	uint32_t div = data >> shift;
-	uint32_t mult = div << shift;
+	u32 div = data >> shift;
+	u32 mult = div << shift;
 
 	return data - mult;
 }
 
-static inline int adf_check_ring_alignment(uint64_t addr, uint64_t size)
+static inline int adf_check_ring_alignment(u64 addr, u64 size)
 {
 	if (((size - 1) & addr) != 0)
 		return -EFAULT;
 	return 0;
 }
 
-static int adf_verify_ring_size(uint32_t msg_size, uint32_t msg_num)
+static int adf_verify_ring_size(u32 msg_size, u32 msg_num)
 {
 	int i = ADF_MIN_RING_SIZE;
 
@@ -33,7 +33,7 @@ static int adf_verify_ring_size(uint32_t msg_size, uint32_t msg_num)
 	return ADF_DEFAULT_RING_SIZE;
 }
 
-static int adf_reserve_ring(struct adf_etr_bank_data *bank, uint32_t ring)
+static int adf_reserve_ring(struct adf_etr_bank_data *bank, u32 ring)
 {
 	spin_lock(&bank->lock);
 	if (bank->ring_mask & (1 << ring)) {
@@ -45,14 +45,14 @@ static int adf_reserve_ring(struct adf_etr_bank_data *bank, uint32_t ring)
 	return 0;
 }
 
-static void adf_unreserve_ring(struct adf_etr_bank_data *bank, uint32_t ring)
+static void adf_unreserve_ring(struct adf_etr_bank_data *bank, u32 ring)
 {
 	spin_lock(&bank->lock);
 	bank->ring_mask &= ~(1 << ring);
 	spin_unlock(&bank->lock);
 }
 
-static void adf_enable_ring_irq(struct adf_etr_bank_data *bank, uint32_t ring)
+static void adf_enable_ring_irq(struct adf_etr_bank_data *bank, u32 ring)
 {
 	spin_lock_bh(&bank->lock);
 	bank->irq_mask |= (1 << ring);
@@ -62,7 +62,7 @@ static void adf_enable_ring_irq(struct adf_etr_bank_data *bank, uint32_t ring)
 			      bank->irq_coalesc_timer);
 }
 
-static void adf_disable_ring_irq(struct adf_etr_bank_data *bank, uint32_t ring)
+static void adf_disable_ring_irq(struct adf_etr_bank_data *bank, u32 ring)
 {
 	spin_lock_bh(&bank->lock);
 	bank->irq_mask &= ~(1 << ring);
@@ -70,7 +70,7 @@ static void adf_disable_ring_irq(struct adf_etr_bank_data *bank, uint32_t ring)
 	WRITE_CSR_INT_COL_EN(bank->csr_addr, bank->bank_number, bank->irq_mask);
 }
 
-int adf_send_message(struct adf_etr_ring_data *ring, uint32_t *msg)
+int adf_send_message(struct adf_etr_ring_data *ring, u32 *msg)
 {
 	if (atomic_add_return(1, ring->inflights) >
 	    ADF_MAX_INFLIGHTS(ring->ring_size, ring->msg_size)) {
@@ -92,18 +92,18 @@ int adf_send_message(struct adf_etr_ring_data *ring, uint32_t *msg)
 
 static int adf_handle_response(struct adf_etr_ring_data *ring)
 {
-	uint32_t msg_counter = 0;
-	uint32_t *msg = (uint32_t *)((uintptr_t)ring->base_addr + ring->head);
+	u32 msg_counter = 0;
+	u32 *msg = (u32 *)((uintptr_t)ring->base_addr + ring->head);
 
 	while (*msg != ADF_RING_EMPTY_SIG) {
-		ring->callback((uint32_t *)msg);
+		ring->callback((u32 *)msg);
 		atomic_dec(ring->inflights);
 		*msg = ADF_RING_EMPTY_SIG;
 		ring->head = adf_modulo(ring->head +
 					ADF_MSG_SIZE_TO_BYTES(ring->msg_size),
 					ADF_RING_SIZE_MODULO(ring->ring_size));
 		msg_counter++;
-		msg = (uint32_t *)((uintptr_t)ring->base_addr + ring->head);
+		msg = (u32 *)((uintptr_t)ring->base_addr + ring->head);
 	}
 	if (msg_counter > 0)
 		WRITE_CSR_RING_HEAD(ring->bank->csr_addr,
@@ -114,7 +114,7 @@ static int adf_handle_response(struct adf_etr_ring_data *ring)
 
 static void adf_configure_tx_ring(struct adf_etr_ring_data *ring)
 {
-	uint32_t ring_config = BUILD_RING_CONFIG(ring->ring_size);
+	u32 ring_config = BUILD_RING_CONFIG(ring->ring_size);
 
 	WRITE_CSR_RING_CONFIG(ring->bank->csr_addr, ring->bank->bank_number,
 			      ring->ring_number, ring_config);
@@ -122,7 +122,7 @@ static void adf_configure_tx_ring(struct adf_etr_ring_data *ring)
 
 static void adf_configure_rx_ring(struct adf_etr_ring_data *ring)
 {
-	uint32_t ring_config =
+	u32 ring_config =
 			BUILD_RESP_RING_CONFIG(ring->ring_size,
 					       ADF_RING_NEAR_WATERMARK_512,
 					       ADF_RING_NEAR_WATERMARK_0);
@@ -136,8 +136,8 @@ static int adf_init_ring(struct adf_etr_ring_data *ring)
 	struct adf_etr_bank_data *bank = ring->bank;
 	struct adf_accel_dev *accel_dev = bank->accel_dev;
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	uint64_t ring_base;
-	uint32_t ring_size_bytes =
+	u64 ring_base;
+	u32 ring_size_bytes =
 			ADF_SIZE_TO_RING_SIZE_IN_BYTES(ring->ring_size);
 
 	ring_size_bytes = ADF_RING_SIZE_BYTES_MIN(ring_size_bytes);
@@ -171,7 +171,7 @@ static int adf_init_ring(struct adf_etr_ring_data *ring)
 
 static void adf_cleanup_ring(struct adf_etr_ring_data *ring)
 {
-	uint32_t ring_size_bytes =
+	u32 ring_size_bytes =
 			ADF_SIZE_TO_RING_SIZE_IN_BYTES(ring->ring_size);
 	ring_size_bytes = ADF_RING_SIZE_BYTES_MIN(ring_size_bytes);
 
@@ -184,8 +184,8 @@ static void adf_cleanup_ring(struct adf_etr_ring_data *ring)
 }
 
 int adf_create_ring(struct adf_accel_dev *accel_dev, const char *section,
-		    uint32_t bank_num, uint32_t num_msgs,
-		    uint32_t msg_size, const char *ring_name,
+		    u32 bank_num, u32 num_msgs,
+		    u32 msg_size, const char *ring_name,
 		    adf_callback_fn callback, int poll_mode,
 		    struct adf_etr_ring_data **ring_ptr)
 {
@@ -193,7 +193,7 @@ int adf_create_ring(struct adf_accel_dev *accel_dev, const char *section,
 	struct adf_etr_bank_data *bank;
 	struct adf_etr_ring_data *ring;
 	char val[ADF_CFG_MAX_VAL_LEN_IN_BYTES];
-	uint32_t ring_num;
+	u32 ring_num;
 	int ret;
 
 	if (bank_num >= GET_MAX_BANKS(accel_dev)) {
@@ -286,7 +286,7 @@ void adf_remove_ring(struct adf_etr_ring_data *ring)
 
 static void adf_ring_response_handler(struct adf_etr_bank_data *bank)
 {
-	uint32_t empty_rings, i;
+	u32 empty_rings, i;
 
 	empty_rings = READ_CSR_E_STAT(bank->csr_addr, bank->bank_number);
 	empty_rings = ~empty_rings & bank->irq_mask;
@@ -309,7 +309,7 @@ void adf_response_handler(uintptr_t bank_addr)
 
 static inline int adf_get_cfg_int(struct adf_accel_dev *accel_dev,
 				  const char *section, const char *format,
-				  uint32_t key, uint32_t *value)
+				  u32 key, u32 *value)
 {
 	char key_buf[ADF_CFG_MAX_KEY_LEN_IN_BYTES];
 	char val_buf[ADF_CFG_MAX_VAL_LEN_IN_BYTES];
@@ -326,7 +326,7 @@ static inline int adf_get_cfg_int(struct adf_accel_dev *accel_dev,
 
 static void adf_get_coalesc_timer(struct adf_etr_bank_data *bank,
 				  const char *section,
-				  uint32_t bank_num_in_accel)
+				  u32 bank_num_in_accel)
 {
 	if (adf_get_cfg_int(bank->accel_dev, section,
 			    ADF_ETRMGR_COALESCE_TIMER_FORMAT,
@@ -340,12 +340,12 @@ static void adf_get_coalesc_timer(struct adf_etr_bank_data *bank,
 
 static int adf_init_bank(struct adf_accel_dev *accel_dev,
 			 struct adf_etr_bank_data *bank,
-			 uint32_t bank_num, void __iomem *csr_addr)
+			 u32 bank_num, void __iomem *csr_addr)
 {
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	struct adf_etr_ring_data *ring;
 	struct adf_etr_ring_data *tx_ring;
-	uint32_t i, coalesc_enabled = 0;
+	u32 i, coalesc_enabled = 0;
 
 	memset(bank, 0, sizeof(*bank));
 	bank->bank_number = bank_num;
@@ -417,8 +417,8 @@ int adf_init_etr_data(struct adf_accel_dev *accel_dev)
 	struct adf_etr_data *etr_data;
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	void __iomem *csr_addr;
-	uint32_t size;
-	uint32_t num_banks = 0;
+	u32 size;
+	u32 num_banks = 0;
 	int i, ret;
 
 	etr_data = kzalloc_node(sizeof(*etr_data), GFP_KERNEL,
@@ -464,7 +464,7 @@ EXPORT_SYMBOL_GPL(adf_init_etr_data);
 
 static void cleanup_bank(struct adf_etr_bank_data *bank)
 {
-	uint32_t i;
+	u32 i;
 
 	for (i = 0; i < ADF_ETR_MAX_RINGS_PER_BANK; i++) {
 		struct adf_accel_dev *accel_dev = bank->accel_dev;
@@ -484,7 +484,7 @@ static void cleanup_bank(struct adf_etr_bank_data *bank)
 static void adf_cleanup_etr_handles(struct adf_accel_dev *accel_dev)
 {
 	struct adf_etr_data *etr_data = accel_dev->transport;
-	uint32_t i, num_banks = GET_MAX_BANKS(accel_dev);
+	u32 i, num_banks = GET_MAX_BANKS(accel_dev);
 
 	for (i = 0; i < num_banks; i++)
 		cleanup_bank(&etr_data->banks[i]);
diff --git a/drivers/crypto/qat/qat_common/adf_transport.h b/drivers/crypto/qat/qat_common/adf_transport.h
index 0faea1032b93..2c95f1697c76 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.h
+++ b/drivers/crypto/qat/qat_common/adf_transport.h
@@ -10,10 +10,10 @@ struct adf_etr_ring_data;
 typedef void (*adf_callback_fn)(void *resp_msg);
 
 int adf_create_ring(struct adf_accel_dev *accel_dev, const char *section,
-		    uint32_t bank_num, uint32_t num_mgs, uint32_t msg_size,
+		    u32 bank_num, u32 num_mgs, u32 msg_size,
 		    const char *ring_name, adf_callback_fn callback,
 		    int poll_mode, struct adf_etr_ring_data **ring_ptr);
 
-int adf_send_message(struct adf_etr_ring_data *ring, uint32_t *msg);
+int adf_send_message(struct adf_etr_ring_data *ring, u32 *msg);
 void adf_remove_ring(struct adf_etr_ring_data *ring);
 #endif
diff --git a/drivers/crypto/qat/qat_common/adf_transport_access_macros.h b/drivers/crypto/qat/qat_common/adf_transport_access_macros.h
index 1a943f948100..950d1988556c 100644
--- a/drivers/crypto/qat/qat_common/adf_transport_access_macros.h
+++ b/drivers/crypto/qat/qat_common/adf_transport_access_macros.h
@@ -88,9 +88,9 @@
 		ADF_RING_CSR_RING_CONFIG + (ring << 2), value)
 #define WRITE_CSR_RING_BASE(csr_base_addr, bank, ring, value) \
 do { \
-	uint32_t l_base = 0, u_base = 0; \
-	l_base = (uint32_t)(value & 0xFFFFFFFF); \
-	u_base = (uint32_t)((value & 0xFFFFFFFF00000000ULL) >> 32); \
+	u32 l_base = 0, u_base = 0; \
+	l_base = (u32)(value & 0xFFFFFFFF); \
+	u_base = (u32)((value & 0xFFFFFFFF00000000ULL) >> 32); \
 	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) + \
 		ADF_RING_CSR_RING_LBASE + (ring << 2), l_base);	\
 	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) + \
diff --git a/drivers/crypto/qat/qat_common/adf_transport_internal.h b/drivers/crypto/qat/qat_common/adf_transport_internal.h
index fc610ea31869..df4c7195daae 100644
--- a/drivers/crypto/qat/qat_common/adf_transport_internal.h
+++ b/drivers/crypto/qat/qat_common/adf_transport_internal.h
@@ -19,12 +19,12 @@ struct adf_etr_ring_data {
 	adf_callback_fn callback;
 	struct adf_etr_bank_data *bank;
 	dma_addr_t dma_addr;
-	uint16_t head;
-	uint16_t tail;
-	uint8_t ring_number;
-	uint8_t ring_size;
-	uint8_t msg_size;
-	uint8_t reserved;
+	u16 head;
+	u16 tail;
+	u8 ring_number;
+	u8 ring_size;
+	u8 msg_size;
+	u8 reserved;
 	struct adf_etr_ring_debug_entry *ring_debug;
 } __packed;
 
@@ -33,13 +33,13 @@ struct adf_etr_bank_data {
 	struct tasklet_struct resp_handler;
 	void __iomem *csr_addr;
 	struct adf_accel_dev *accel_dev;
-	uint32_t irq_coalesc_timer;
-	uint16_t ring_mask;
-	uint16_t irq_mask;
+	u32 irq_coalesc_timer;
+	u16 ring_mask;
+	u16 irq_mask;
 	spinlock_t lock;	/* protects bank data struct */
 	struct dentry *bank_debug_dir;
 	struct dentry *bank_debug_cfg;
-	uint32_t bank_number;
+	u32 bank_number;
 } __packed;
 
 struct adf_etr_data {
diff --git a/drivers/crypto/qat/qat_common/icp_qat_uclo.h b/drivers/crypto/qat/qat_common/icp_qat_uclo.h
index dbb58eacc395..8fe1ec344fa2 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_uclo.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_uclo.h
@@ -132,7 +132,7 @@ struct icp_qat_uof_encap_obj {
 struct icp_qat_uclo_encap_uwblock {
 	unsigned int start_addr;
 	unsigned int words_num;
-	uint64_t micro_words;
+	u64 micro_words;
 };
 
 struct icp_qat_uclo_encap_page {
@@ -171,7 +171,7 @@ struct icp_qat_uclo_objhdr {
 struct icp_qat_uof_strtable {
 	unsigned int table_len;
 	unsigned int reserved;
-	uint64_t strings;
+	u64 strings;
 };
 
 struct icp_qat_uclo_objhandle {
@@ -191,7 +191,7 @@ struct icp_qat_uclo_objhandle {
 	unsigned int ae_num;
 	unsigned int ustore_phy_size;
 	void *obj_buf;
-	uint64_t *uword_buf;
+	u64 *uword_buf;
 };
 
 struct icp_qat_uof_uword_block {
diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 00e10a4d578a..4f2c402a5de1 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -34,15 +34,15 @@ static DEFINE_MUTEX(algs_lock);
 static unsigned int active_devs;
 
 struct qat_alg_buf {
-	uint32_t len;
-	uint32_t resrvd;
-	uint64_t addr;
+	u32 len;
+	u32 resrvd;
+	u64 addr;
 } __packed;
 
 struct qat_alg_buf_list {
-	uint64_t resrvd;
-	uint32_t num_bufs;
-	uint32_t num_mapped_bufs;
+	u64 resrvd;
+	u32 num_bufs;
+	u32 num_mapped_bufs;
 	struct qat_alg_buf bufers[];
 } __packed __aligned(64);
 
@@ -107,7 +107,7 @@ static int qat_get_inter_state_size(enum icp_qat_hw_auth_algo qat_hash_alg)
 
 static int qat_alg_do_precomputes(struct icp_qat_hw_auth_algo_blk *hash,
 				  struct qat_alg_aead_ctx *ctx,
-				  const uint8_t *auth_key,
+				  const u8 *auth_key,
 				  unsigned int auth_keylen)
 {
 	SHASH_DESC_ON_STACK(shash, ctx->hash_tfm);
@@ -423,7 +423,7 @@ static int qat_alg_aead_init_dec_session(struct crypto_aead *aead_tfm,
 static void qat_alg_skcipher_init_com(struct qat_alg_skcipher_ctx *ctx,
 				      struct icp_qat_fw_la_bulk_req *req,
 				      struct icp_qat_hw_cipher_algo_blk *cd,
-				      const uint8_t *key, unsigned int keylen)
+				      const u8 *key, unsigned int keylen)
 {
 	struct icp_qat_fw_comn_req_hdr_cd_pars *cd_pars = &req->cd_pars;
 	struct icp_qat_fw_comn_req_hdr *header = &req->comn_hdr;
@@ -443,7 +443,7 @@ static void qat_alg_skcipher_init_com(struct qat_alg_skcipher_ctx *ctx,
 }
 
 static void qat_alg_skcipher_init_enc(struct qat_alg_skcipher_ctx *ctx,
-				      int alg, const uint8_t *key,
+				      int alg, const u8 *key,
 				      unsigned int keylen, int mode)
 {
 	struct icp_qat_hw_cipher_algo_blk *enc_cd = ctx->enc_cd;
@@ -456,7 +456,7 @@ static void qat_alg_skcipher_init_enc(struct qat_alg_skcipher_ctx *ctx,
 }
 
 static void qat_alg_skcipher_init_dec(struct qat_alg_skcipher_ctx *ctx,
-				      int alg, const uint8_t *key,
+				      int alg, const u8 *key,
 				      unsigned int keylen, int mode)
 {
 	struct icp_qat_hw_cipher_algo_blk *dec_cd = ctx->dec_cd;
@@ -534,7 +534,7 @@ static int qat_alg_aead_init_sessions(struct crypto_aead *tfm, const u8 *key,
 }
 
 static int qat_alg_skcipher_init_sessions(struct qat_alg_skcipher_ctx *ctx,
-					  const uint8_t *key,
+					  const u8 *key,
 					  unsigned int keylen,
 					  int mode)
 {
@@ -548,7 +548,7 @@ static int qat_alg_skcipher_init_sessions(struct qat_alg_skcipher_ctx *ctx,
 	return 0;
 }
 
-static int qat_alg_aead_rekey(struct crypto_aead *tfm, const uint8_t *key,
+static int qat_alg_aead_rekey(struct crypto_aead *tfm, const u8 *key,
 			      unsigned int keylen)
 {
 	struct qat_alg_aead_ctx *ctx = crypto_aead_ctx(tfm);
@@ -562,7 +562,7 @@ static int qat_alg_aead_rekey(struct crypto_aead *tfm, const uint8_t *key,
 					  ICP_QAT_HW_CIPHER_CBC_MODE);
 }
 
-static int qat_alg_aead_newkey(struct crypto_aead *tfm, const uint8_t *key,
+static int qat_alg_aead_newkey(struct crypto_aead *tfm, const u8 *key,
 			       unsigned int keylen)
 {
 	struct qat_alg_aead_ctx *ctx = crypto_aead_ctx(tfm);
@@ -614,7 +614,7 @@ static int qat_alg_aead_newkey(struct crypto_aead *tfm, const uint8_t *key,
 	return ret;
 }
 
-static int qat_alg_aead_setkey(struct crypto_aead *tfm, const uint8_t *key,
+static int qat_alg_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 			       unsigned int keylen)
 {
 	struct qat_alg_aead_ctx *ctx = crypto_aead_ctx(tfm);
@@ -776,7 +776,7 @@ static void qat_aead_alg_callback(struct icp_qat_fw_la_resp *qat_resp,
 	struct qat_alg_aead_ctx *ctx = qat_req->aead_ctx;
 	struct qat_crypto_instance *inst = ctx->inst;
 	struct aead_request *areq = qat_req->aead_req;
-	uint8_t stat_filed = qat_resp->comn_resp.comn_status;
+	u8 stat_filed = qat_resp->comn_resp.comn_status;
 	int res = 0, qat_res = ICP_QAT_FW_COMN_RESP_CRYPTO_STAT_GET(stat_filed);
 
 	qat_alg_free_bufl(inst, qat_req);
@@ -791,7 +791,7 @@ static void qat_skcipher_alg_callback(struct icp_qat_fw_la_resp *qat_resp,
 	struct qat_alg_skcipher_ctx *ctx = qat_req->skcipher_ctx;
 	struct qat_crypto_instance *inst = ctx->inst;
 	struct skcipher_request *sreq = qat_req->skcipher_req;
-	uint8_t stat_filed = qat_resp->comn_resp.comn_status;
+	u8 stat_filed = qat_resp->comn_resp.comn_status;
 	struct device *dev = &GET_DEV(ctx->inst->accel_dev);
 	int res = 0, qat_res = ICP_QAT_FW_COMN_RESP_CRYPTO_STAT_GET(stat_filed);
 
@@ -843,18 +843,18 @@ static int qat_alg_aead_dec(struct aead_request *areq)
 	qat_req->aead_ctx = ctx;
 	qat_req->aead_req = areq;
 	qat_req->cb = qat_aead_alg_callback;
-	qat_req->req.comn_mid.opaque_data = (uint64_t)(__force long)qat_req;
+	qat_req->req.comn_mid.opaque_data = (u64)(__force long)qat_req;
 	qat_req->req.comn_mid.src_data_addr = qat_req->buf.blp;
 	qat_req->req.comn_mid.dest_data_addr = qat_req->buf.bloutp;
 	cipher_param = (void *)&qat_req->req.serv_specif_rqpars;
 	cipher_param->cipher_length = cipher_length;
 	cipher_param->cipher_offset = areq->assoclen;
 	memcpy(cipher_param->u.cipher_IV_array, areq->iv, AES_BLOCK_SIZE);
-	auth_param = (void *)((uint8_t *)cipher_param + sizeof(*cipher_param));
+	auth_param = (void *)((u8 *)cipher_param + sizeof(*cipher_param));
 	auth_param->auth_off = 0;
 	auth_param->auth_len = areq->assoclen + cipher_param->cipher_length;
 	do {
-		ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
+		ret = adf_send_message(ctx->inst->sym_tx, (u32 *)msg);
 	} while (ret == -EAGAIN && ctr++ < 10);
 
 	if (ret == -EAGAIN) {
@@ -873,7 +873,7 @@ static int qat_alg_aead_enc(struct aead_request *areq)
 	struct icp_qat_fw_la_cipher_req_params *cipher_param;
 	struct icp_qat_fw_la_auth_req_params *auth_param;
 	struct icp_qat_fw_la_bulk_req *msg;
-	uint8_t *iv = areq->iv;
+	u8 *iv = areq->iv;
 	int ret, ctr = 0;
 
 	if (!areq->cryptlen)
@@ -891,11 +891,11 @@ static int qat_alg_aead_enc(struct aead_request *areq)
 	qat_req->aead_ctx = ctx;
 	qat_req->aead_req = areq;
 	qat_req->cb = qat_aead_alg_callback;
-	qat_req->req.comn_mid.opaque_data = (uint64_t)(__force long)qat_req;
+	qat_req->req.comn_mid.opaque_data = (u64)(__force long)qat_req;
 	qat_req->req.comn_mid.src_data_addr = qat_req->buf.blp;
 	qat_req->req.comn_mid.dest_data_addr = qat_req->buf.bloutp;
 	cipher_param = (void *)&qat_req->req.serv_specif_rqpars;
-	auth_param = (void *)((uint8_t *)cipher_param + sizeof(*cipher_param));
+	auth_param = (void *)((u8 *)cipher_param + sizeof(*cipher_param));
 
 	memcpy(cipher_param->u.cipher_IV_array, iv, AES_BLOCK_SIZE);
 	cipher_param->cipher_length = areq->cryptlen;
@@ -905,7 +905,7 @@ static int qat_alg_aead_enc(struct aead_request *areq)
 	auth_param->auth_len = areq->assoclen + areq->cryptlen;
 
 	do {
-		ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
+		ret = adf_send_message(ctx->inst->sym_tx, (u32 *)msg);
 	} while (ret == -EAGAIN && ctr++ < 10);
 
 	if (ret == -EAGAIN) {
@@ -1042,7 +1042,7 @@ static int qat_alg_skcipher_encrypt(struct skcipher_request *req)
 	qat_req->skcipher_ctx = ctx;
 	qat_req->skcipher_req = req;
 	qat_req->cb = qat_skcipher_alg_callback;
-	qat_req->req.comn_mid.opaque_data = (uint64_t)(__force long)qat_req;
+	qat_req->req.comn_mid.opaque_data = (u64)(__force long)qat_req;
 	qat_req->req.comn_mid.src_data_addr = qat_req->buf.blp;
 	qat_req->req.comn_mid.dest_data_addr = qat_req->buf.bloutp;
 	cipher_param = (void *)&qat_req->req.serv_specif_rqpars;
@@ -1051,7 +1051,7 @@ static int qat_alg_skcipher_encrypt(struct skcipher_request *req)
 	cipher_param->u.s.cipher_IV_ptr = qat_req->iv_paddr;
 	memcpy(qat_req->iv, req->iv, AES_BLOCK_SIZE);
 	do {
-		ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
+		ret = adf_send_message(ctx->inst->sym_tx, (u32 *)msg);
 	} while (ret == -EAGAIN && ctr++ < 10);
 
 	if (ret == -EAGAIN) {
@@ -1102,7 +1102,7 @@ static int qat_alg_skcipher_decrypt(struct skcipher_request *req)
 	qat_req->skcipher_ctx = ctx;
 	qat_req->skcipher_req = req;
 	qat_req->cb = qat_skcipher_alg_callback;
-	qat_req->req.comn_mid.opaque_data = (uint64_t)(__force long)qat_req;
+	qat_req->req.comn_mid.opaque_data = (u64)(__force long)qat_req;
 	qat_req->req.comn_mid.src_data_addr = qat_req->buf.blp;
 	qat_req->req.comn_mid.dest_data_addr = qat_req->buf.bloutp;
 	cipher_param = (void *)&qat_req->req.serv_specif_rqpars;
@@ -1111,7 +1111,7 @@ static int qat_alg_skcipher_decrypt(struct skcipher_request *req)
 	cipher_param->u.s.cipher_IV_ptr = qat_req->iv_paddr;
 	memcpy(qat_req->iv, req->iv, AES_BLOCK_SIZE);
 	do {
-		ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
+		ret = adf_send_message(ctx->inst->sym_tx, (u32 *)msg);
 	} while (ret == -EAGAIN && ctr++ < 10);
 
 	if (ret == -EAGAIN) {
diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 6cd67b06979b..846569ec9066 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -339,12 +339,12 @@ static int qat_dh_compute_value(struct kpp_request *req)
 
 	msg->pke_mid.src_data_addr = qat_req->phy_in;
 	msg->pke_mid.dest_data_addr = qat_req->phy_out;
-	msg->pke_mid.opaque = (uint64_t)(__force long)qat_req;
+	msg->pke_mid.opaque = (u64)(__force long)qat_req;
 	msg->input_param_count = n_input_params;
 	msg->output_param_count = 1;
 
 	do {
-		ret = adf_send_message(ctx->inst->pke_tx, (uint32_t *)msg);
+		ret = adf_send_message(ctx->inst->pke_tx, (u32 *)msg);
 	} while (ret == -EBUSY && ctr++ < 100);
 
 	if (!ret)
@@ -734,11 +734,11 @@ static int qat_rsa_enc(struct akcipher_request *req)
 
 	msg->pke_mid.src_data_addr = qat_req->phy_in;
 	msg->pke_mid.dest_data_addr = qat_req->phy_out;
-	msg->pke_mid.opaque = (uint64_t)(__force long)qat_req;
+	msg->pke_mid.opaque = (u64)(__force long)qat_req;
 	msg->input_param_count = 3;
 	msg->output_param_count = 1;
 	do {
-		ret = adf_send_message(ctx->inst->pke_tx, (uint32_t *)msg);
+		ret = adf_send_message(ctx->inst->pke_tx, (u32 *)msg);
 	} while (ret == -EBUSY && ctr++ < 100);
 
 	if (!ret)
@@ -882,7 +882,7 @@ static int qat_rsa_dec(struct akcipher_request *req)
 
 	msg->pke_mid.src_data_addr = qat_req->phy_in;
 	msg->pke_mid.dest_data_addr = qat_req->phy_out;
-	msg->pke_mid.opaque = (uint64_t)(__force long)qat_req;
+	msg->pke_mid.opaque = (u64)(__force long)qat_req;
 	if (ctx->crt_mode)
 		msg->input_param_count = 6;
 	else
@@ -890,7 +890,7 @@ static int qat_rsa_dec(struct akcipher_request *req)
 
 	msg->output_param_count = 1;
 	do {
-		ret = adf_send_message(ctx->inst->pke_tx, (uint32_t *)msg);
+		ret = adf_send_message(ctx->inst->pke_tx, (u32 *)msg);
 	} while (ret == -EBUSY && ctr++ < 100);
 
 	if (!ret)
diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index 9a80da0b3b28..fa467e0f8285 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -34,13 +34,13 @@
 
 #define AE(handle, ae) handle->hal_handle->aes[ae]
 
-static const uint64_t inst_4b[] = {
+static const u64 inst_4b[] = {
 	0x0F0400C0000ull, 0x0F4400C0000ull, 0x0F040000300ull, 0x0F440000300ull,
 	0x0FC066C0000ull, 0x0F0000C0300ull, 0x0F0000C0300ull, 0x0F0000C0300ull,
 	0x0A021000000ull
 };
 
-static const uint64_t inst[] = {
+static const u64 inst[] = {
 	0x0F0000C0000ull, 0x0F000000380ull, 0x0D805000011ull, 0x0FC082C0300ull,
 	0x0F0000C0300ull, 0x0F0000C0300ull, 0x0F0000C0300ull, 0x0F0000C0300ull,
 	0x0A0643C0000ull, 0x0BAC0000301ull, 0x0D802000101ull, 0x0F0000C0001ull,
@@ -502,7 +502,7 @@ static void qat_hal_disable_ctx(struct icp_qat_fw_loader_handle *handle,
 	qat_hal_wr_ae_csr(handle, ae, CTX_ENABLES, ctx);
 }
 
-static uint64_t qat_hal_parity_64bit(uint64_t word)
+static u64 qat_hal_parity_64bit(u64 word)
 {
 	word ^= word >> 1;
 	word ^= word >> 2;
@@ -513,9 +513,9 @@ static uint64_t qat_hal_parity_64bit(uint64_t word)
 	return word & 1;
 }
 
-static uint64_t qat_hal_set_uword_ecc(uint64_t uword)
+static u64 qat_hal_set_uword_ecc(u64 uword)
 {
-	uint64_t bit0_mask = 0xff800007fffULL, bit1_mask = 0x1f801ff801fULL,
+	u64 bit0_mask = 0xff800007fffULL, bit1_mask = 0x1f801ff801fULL,
 		bit2_mask = 0xe387e0781e1ULL, bit3_mask = 0x7cb8e388e22ULL,
 		bit4_mask = 0xaf5b2c93244ULL, bit5_mask = 0xf56d5525488ULL,
 		bit6_mask = 0xdaf69a46910ULL;
@@ -534,7 +534,7 @@ static uint64_t qat_hal_set_uword_ecc(uint64_t uword)
 
 void qat_hal_wr_uwords(struct icp_qat_fw_loader_handle *handle,
 		       unsigned char ae, unsigned int uaddr,
-		       unsigned int words_num, uint64_t *uword)
+		       unsigned int words_num, u64 *uword)
 {
 	unsigned int ustore_addr;
 	unsigned int i;
@@ -544,7 +544,7 @@ void qat_hal_wr_uwords(struct icp_qat_fw_loader_handle *handle,
 	qat_hal_wr_ae_csr(handle, ae, USTORE_ADDRESS, uaddr);
 	for (i = 0; i < words_num; i++) {
 		unsigned int uwrd_lo, uwrd_hi;
-		uint64_t tmp;
+		u64 tmp;
 
 		tmp = qat_hal_set_uword_ecc(uword[i]);
 		uwrd_lo = (unsigned int)(tmp & 0xffffffff);
@@ -600,7 +600,7 @@ static int qat_hal_clear_gpr(struct icp_qat_fw_loader_handle *handle)
 		csr_val |= CE_NN_MODE;
 		qat_hal_wr_ae_csr(handle, ae, CTX_ENABLES, csr_val);
 		qat_hal_wr_uwords(handle, ae, 0, ARRAY_SIZE(inst),
-				  (uint64_t *)inst);
+				  (u64 *)inst);
 		qat_hal_wr_indr_csr(handle, ae, ctx_mask, CTX_STS_INDIRECT,
 				    handle->hal_handle->upc_mask &
 				    INIT_PC_VALUE);
@@ -777,7 +777,7 @@ void qat_hal_set_pc(struct icp_qat_fw_loader_handle *handle,
 
 static void qat_hal_get_uwords(struct icp_qat_fw_loader_handle *handle,
 			       unsigned char ae, unsigned int uaddr,
-			       unsigned int words_num, uint64_t *uword)
+			       unsigned int words_num, u64 *uword)
 {
 	unsigned int i, uwrd_lo, uwrd_hi;
 	unsigned int ustore_addr, misc_control;
@@ -827,11 +827,11 @@ void qat_hal_wr_umem(struct icp_qat_fw_loader_handle *handle,
 #define MAX_EXEC_INST 100
 static int qat_hal_exec_micro_inst(struct icp_qat_fw_loader_handle *handle,
 				   unsigned char ae, unsigned char ctx,
-				   uint64_t *micro_inst, unsigned int inst_num,
+				   u64 *micro_inst, unsigned int inst_num,
 				   int code_off, unsigned int max_cycle,
 				   unsigned int *endpc)
 {
-	uint64_t savuwords[MAX_EXEC_INST];
+	u64 savuwords[MAX_EXEC_INST];
 	unsigned int ind_lm_addr0, ind_lm_addr1;
 	unsigned int ind_lm_addr_byte0, ind_lm_addr_byte1;
 	unsigned int ind_cnt_sig;
@@ -928,7 +928,7 @@ static int qat_hal_rd_rel_reg(struct icp_qat_fw_loader_handle *handle,
 	unsigned int ctxarb_cntl, ustore_addr, ctx_enables;
 	unsigned short reg_addr;
 	int status = 0;
-	uint64_t insts, savuword;
+	u64 insts, savuword;
 
 	reg_addr = qat_hal_get_reg_addr(reg_type, reg_num);
 	if (reg_addr == BAD_REGADDR) {
@@ -940,7 +940,7 @@ static int qat_hal_rd_rel_reg(struct icp_qat_fw_loader_handle *handle,
 		insts = 0xA070000000ull | (reg_addr & 0x3ff);
 		break;
 	default:
-		insts = (uint64_t)0xA030000000ull | ((reg_addr & 0x3ff) << 10);
+		insts = (u64)0xA030000000ull | ((reg_addr & 0x3ff) << 10);
 		break;
 	}
 	savctx = qat_hal_rd_ae_csr(handle, ae, ACTIVE_CTX_STATUS);
@@ -986,7 +986,7 @@ static int qat_hal_wr_rel_reg(struct icp_qat_fw_loader_handle *handle,
 			      unsigned short reg_num, unsigned int data)
 {
 	unsigned short src_hiaddr, src_lowaddr, dest_addr, data16hi, data16lo;
-	uint64_t insts[] = {
+	u64 insts[] = {
 		0x0F440000000ull,
 		0x0F040000000ull,
 		0x0F0000C0300ull,
@@ -1032,13 +1032,13 @@ int qat_hal_get_ins_num(void)
 	return ARRAY_SIZE(inst_4b);
 }
 
-static int qat_hal_concat_micro_code(uint64_t *micro_inst,
+static int qat_hal_concat_micro_code(u64 *micro_inst,
 				     unsigned int inst_num, unsigned int size,
 				     unsigned int addr, unsigned int *value)
 {
 	int i;
 	unsigned int cur_value;
-	const uint64_t *inst_arr;
+	const u64 *inst_arr;
 	int fixup_offset;
 	int usize = 0;
 	int orig_num;
@@ -1063,7 +1063,7 @@ static int qat_hal_concat_micro_code(uint64_t *micro_inst,
 
 static int qat_hal_exec_micro_init_lm(struct icp_qat_fw_loader_handle *handle,
 				      unsigned char ae, unsigned char ctx,
-				      int *pfirst_exec, uint64_t *micro_inst,
+				      int *pfirst_exec, u64 *micro_inst,
 				      unsigned int inst_num)
 {
 	int stat = 0;
@@ -1096,7 +1096,7 @@ int qat_hal_batch_wr_lm(struct icp_qat_fw_loader_handle *handle,
 			struct icp_qat_uof_batch_init *lm_init_header)
 {
 	struct icp_qat_uof_batch_init *plm_init;
-	uint64_t *micro_inst_arry;
+	u64 *micro_inst_arry;
 	int micro_inst_num;
 	int alloc_inst_size;
 	int first_exec = 1;
@@ -1106,7 +1106,7 @@ int qat_hal_batch_wr_lm(struct icp_qat_fw_loader_handle *handle,
 	alloc_inst_size = lm_init_header->size;
 	if ((unsigned int)alloc_inst_size > handle->hal_handle->max_ustore)
 		alloc_inst_size = handle->hal_handle->max_ustore;
-	micro_inst_arry = kmalloc_array(alloc_inst_size, sizeof(uint64_t),
+	micro_inst_arry = kmalloc_array(alloc_inst_size, sizeof(u64),
 					GFP_KERNEL);
 	if (!micro_inst_arry)
 		return -ENOMEM;
@@ -1185,7 +1185,7 @@ static int qat_hal_put_rel_wr_xfer(struct icp_qat_fw_loader_handle *handle,
 	    data16low;
 	unsigned short reg_mask;
 	int status = 0;
-	uint64_t micro_inst[] = {
+	u64 micro_inst[] = {
 		0x0F440000000ull,
 		0x0F040000000ull,
 		0x0A000000000ull,
diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index 3f079e336f64..4cc1f436b075 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -367,16 +367,16 @@ static int qat_uclo_init_ustore(struct icp_qat_fw_loader_handle *handle,
 	unsigned int ustore_size;
 	unsigned int patt_pos;
 	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
-	uint64_t *fill_data;
+	u64 *fill_data;
 
 	uof_image = image->img_ptr;
-	fill_data = kcalloc(ICP_QAT_UCLO_MAX_USTORE, sizeof(uint64_t),
+	fill_data = kcalloc(ICP_QAT_UCLO_MAX_USTORE, sizeof(u64),
 			    GFP_KERNEL);
 	if (!fill_data)
 		return -ENOMEM;
 	for (i = 0; i < ICP_QAT_UCLO_MAX_USTORE; i++)
 		memcpy(&fill_data[i], &uof_image->fill_pattern,
-		       sizeof(uint64_t));
+		       sizeof(u64));
 	page = image->page;
 
 	for (ae = 0; ae < handle->hal_handle->ae_max_num; ae++) {
@@ -937,7 +937,7 @@ static int qat_uclo_parse_uof_obj(struct icp_qat_fw_loader_handle *handle)
 		pr_err("QAT: UOF incompatible\n");
 		return -EINVAL;
 	}
-	obj_handle->uword_buf = kcalloc(UWORD_CPYBUF_SIZE, sizeof(uint64_t),
+	obj_handle->uword_buf = kcalloc(UWORD_CPYBUF_SIZE, sizeof(u64),
 					GFP_KERNEL);
 	if (!obj_handle->uword_buf)
 		return -ENOMEM;
@@ -1141,7 +1141,7 @@ static int qat_uclo_map_suof(struct icp_qat_fw_loader_handle *handle,
 	return 0;
 }
 
-#define ADD_ADDR(high, low)  ((((uint64_t)high) << 32) + low)
+#define ADD_ADDR(high, low)  ((((u64)high) << 32) + low)
 #define BITS_IN_DWORD 32
 
 static int qat_uclo_auth_fw(struct icp_qat_fw_loader_handle *handle,
@@ -1470,10 +1470,10 @@ void qat_uclo_del_uof_obj(struct icp_qat_fw_loader_handle *handle)
 
 static void qat_uclo_fill_uwords(struct icp_qat_uclo_objhandle *obj_handle,
 				 struct icp_qat_uclo_encap_page *encap_page,
-				 uint64_t *uword, unsigned int addr_p,
-				 unsigned int raddr, uint64_t fill)
+				 u64 *uword, unsigned int addr_p,
+				 unsigned int raddr, u64 fill)
 {
-	uint64_t uwrd = 0;
+	u64 uwrd = 0;
 	unsigned int i;
 
 	if (!encap_page) {
@@ -1503,12 +1503,12 @@ static void qat_uclo_wr_uimage_raw_page(struct icp_qat_fw_loader_handle *handle,
 {
 	unsigned int uw_physical_addr, uw_relative_addr, i, words_num, cpylen;
 	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
-	uint64_t fill_pat;
+	u64 fill_pat;
 
 	/* load the page starting at appropriate ustore address */
 	/* get fill-pattern from an image -- they are all the same */
 	memcpy(&fill_pat, obj_handle->ae_uimage[0].img_ptr->fill_pattern,
-	       sizeof(uint64_t));
+	       sizeof(u64));
 	uw_physical_addr = encap_page->beg_addr_p;
 	uw_relative_addr = 0;
 	words_num = encap_page->micro_words_num;
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index 0461040303a2..b975c263446d 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -6,13 +6,13 @@
 #include "adf_dh895xcc_hw_data.h"
 
 /* Worker thread to service arbiter mappings based on dev SKUs */
-static const uint32_t thrd_to_arb_map_sku4[] = {
+static const u32 thrd_to_arb_map_sku4[] = {
 	0x12222AAA, 0x11666666, 0x12222AAA, 0x11666666,
 	0x12222AAA, 0x11222222, 0x12222AAA, 0x11222222,
 	0x00000000, 0x00000000, 0x00000000, 0x00000000
 };
 
-static const uint32_t thrd_to_arb_map_sku6[] = {
+static const u32 thrd_to_arb_map_sku6[] = {
 	0x12222AAA, 0x11666666, 0x12222AAA, 0x11666666,
 	0x12222AAA, 0x11222222, 0x12222AAA, 0x11222222,
 	0x12222AAA, 0x11222222, 0x12222AAA, 0x11222222
@@ -24,20 +24,20 @@ static struct adf_hw_device_class dh895xcc_class = {
 	.instances = 0
 };
 
-static uint32_t get_accel_mask(uint32_t fuse)
+static u32 get_accel_mask(u32 fuse)
 {
 	return (~fuse) >> ADF_DH895XCC_ACCELERATORS_REG_OFFSET &
 			  ADF_DH895XCC_ACCELERATORS_MASK;
 }
 
-static uint32_t get_ae_mask(uint32_t fuse)
+static u32 get_ae_mask(u32 fuse)
 {
 	return (~fuse) & ADF_DH895XCC_ACCELENGINES_MASK;
 }
 
-static uint32_t get_num_accels(struct adf_hw_device_data *self)
+static u32 get_num_accels(struct adf_hw_device_data *self)
 {
-	uint32_t i, ctr = 0;
+	u32 i, ctr = 0;
 
 	if (!self || !self->accel_mask)
 		return 0;
@@ -49,9 +49,9 @@ static uint32_t get_num_accels(struct adf_hw_device_data *self)
 	return ctr;
 }
 
-static uint32_t get_num_aes(struct adf_hw_device_data *self)
+static u32 get_num_aes(struct adf_hw_device_data *self)
 {
-	uint32_t i, ctr = 0;
+	u32 i, ctr = 0;
 
 	if (!self || !self->ae_mask)
 		return 0;
@@ -63,17 +63,17 @@ static uint32_t get_num_aes(struct adf_hw_device_data *self)
 	return ctr;
 }
 
-static uint32_t get_misc_bar_id(struct adf_hw_device_data *self)
+static u32 get_misc_bar_id(struct adf_hw_device_data *self)
 {
 	return ADF_DH895XCC_PMISC_BAR;
 }
 
-static uint32_t get_etr_bar_id(struct adf_hw_device_data *self)
+static u32 get_etr_bar_id(struct adf_hw_device_data *self)
 {
 	return ADF_DH895XCC_ETR_BAR;
 }
 
-static uint32_t get_sram_bar_id(struct adf_hw_device_data *self)
+static u32 get_sram_bar_id(struct adf_hw_device_data *self)
 {
 	return ADF_DH895XCC_SRAM_BAR;
 }
@@ -117,12 +117,12 @@ static void adf_get_arbiter_mapping(struct adf_accel_dev *accel_dev,
 	}
 }
 
-static uint32_t get_pf2vf_offset(uint32_t i)
+static u32 get_pf2vf_offset(u32 i)
 {
 	return ADF_DH895XCC_PF2VF_OFFSET(i);
 }
 
-static uint32_t get_vintmsk_offset(uint32_t i)
+static u32 get_vintmsk_offset(u32 i)
 {
 	return ADF_DH895XCC_VINTMSK_OFFSET(i);
 }
-- 
2.26.2

