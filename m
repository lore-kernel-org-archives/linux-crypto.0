Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6BEFC433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 20:52:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92A8561213
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 20:52:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233071AbhKJUze (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Nov 2021 15:55:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:55773 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233115AbhKJUzd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Nov 2021 15:55:33 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10164"; a="232611152"
X-IronPort-AV: E=Sophos;i="5.87,224,1631602800"; 
   d="scan'208";a="232611152"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 12:52:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,224,1631602800"; 
   d="scan'208";a="642663135"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga001.fm.intel.com with ESMTP; 10 Nov 2021 12:52:41 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        marco.chiappero@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 13/24] crypto: qat - add pfvf_ops
Date:   Wed, 10 Nov 2021 20:52:06 +0000
Message-Id: <20211110205217.99903-14-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110205217.99903-1-giovanni.cabiddu@intel.com>
References: <20211110205217.99903-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Marco Chiappero <marco.chiappero@intel.com>

Add pfvf_ops structure to isolate PFVF related functions inside the
adf_hw_device_data structure.

For GEN2, the structure is populated using one of the two helper
functions, adf_gen2_init_pf_pfvf_ops() or adf_gen2_init_vf_pfvf_ops(),
for the PF and VF driver respectively.

For the DH895XCC PF driver, the structure is populated using
adf_gen2_init_pf_pfvf_ops() but some of the functions are then
overwritten.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.c    |  2 +-
 .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c  |  6 +----
 .../qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c     |  3 +--
 .../crypto/qat/qat_c62x/adf_c62x_hw_data.c    |  6 +----
 .../qat/qat_c62xvf/adf_c62xvf_hw_data.c       |  3 +--
 drivers/crypto/qat/qat_common/Makefile        |  6 ++---
 .../crypto/qat/qat_common/adf_accel_devices.h | 17 +++++++------
 drivers/crypto/qat/qat_common/adf_gen2_pfvf.c | 24 +++++++++++++++----
 drivers/crypto/qat/qat_common/adf_gen2_pfvf.h | 17 +++++++++++--
 drivers/crypto/qat/qat_common/adf_init.c      |  2 +-
 drivers/crypto/qat/qat_common/adf_isr.c       |  8 +++----
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c |  8 +++----
 drivers/crypto/qat/qat_common/adf_sriov.c     |  6 ++---
 drivers/crypto/qat/qat_common/adf_vf2pf_msg.c |  2 +-
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   |  9 ++++---
 .../qat_dh895xccvf/adf_dh895xccvf_hw_data.c   |  3 +--
 16 files changed, 71 insertions(+), 51 deletions(-)

diff --git a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
index ab61eebb1b96..ac9c9cee8318 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -248,7 +248,7 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data)
 	hw_data->uof_get_ae_mask = uof_get_ae_mask;
 	hw_data->set_msix_rttable = set_msix_default_rttable;
 	hw_data->set_ssm_wdtimer = adf_gen4_set_ssm_wdtimer;
-	hw_data->enable_pfvf_comms = adf_pfvf_comms_disabled;
+	hw_data->pfvf_ops.enable_comms = adf_pfvf_comms_disabled;
 	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->min_iov_compat_ver = ADF_PFVF_COMPAT_THIS_VERSION;
 
diff --git a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
index aaf8e65887b8..d25f78660b8c 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
@@ -136,14 +136,10 @@ void adf_init_hw_data_c3xxx(struct adf_hw_device_data *hw_data)
 	hw_data->enable_ints = adf_enable_ints;
 	hw_data->reset_device = adf_reset_flr;
 	hw_data->set_ssm_wdtimer = adf_gen2_set_ssm_wdtimer;
-	hw_data->get_pf2vf_offset = adf_gen2_pf_get_pf2vf_offset;
-	hw_data->get_vf2pf_sources = adf_gen2_get_vf2pf_sources;
-	hw_data->enable_vf2pf_interrupts = adf_gen2_enable_vf2pf_interrupts;
-	hw_data->disable_vf2pf_interrupts = adf_gen2_disable_vf2pf_interrupts;
-	hw_data->enable_pfvf_comms = adf_enable_pf2vf_comms;
 	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->min_iov_compat_ver = ADF_PFVF_COMPAT_THIS_VERSION;
 
+	adf_gen2_init_pf_pfvf_ops(&hw_data->pfvf_ops);
 	adf_gen2_init_hw_csr_ops(&hw_data->csr_ops);
 }
 
diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c b/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
index ee61f69a8077..c39733320063 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
@@ -82,13 +82,12 @@ void adf_init_hw_data_c3xxxiov(struct adf_hw_device_data *hw_data)
 	hw_data->get_num_aes = get_num_aes;
 	hw_data->get_etr_bar_id = get_etr_bar_id;
 	hw_data->get_misc_bar_id = get_misc_bar_id;
-	hw_data->get_pf2vf_offset = adf_gen2_vf_get_pf2vf_offset;
 	hw_data->get_sku = get_sku;
 	hw_data->enable_ints = adf_vf_void_noop;
-	hw_data->enable_pfvf_comms = adf_enable_vf2pf_comms;
 	hw_data->min_iov_compat_ver = ADF_PFVF_COMPAT_THIS_VERSION;
 	hw_data->dev_class->instances++;
 	adf_devmgr_update_class_index(hw_data);
+	adf_gen2_init_vf_pfvf_ops(&hw_data->pfvf_ops);
 	adf_gen2_init_hw_csr_ops(&hw_data->csr_ops);
 }
 
diff --git a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
index 0d694c713797..f24a01e1bc1a 100644
--- a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
+++ b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
@@ -138,14 +138,10 @@ void adf_init_hw_data_c62x(struct adf_hw_device_data *hw_data)
 	hw_data->enable_ints = adf_enable_ints;
 	hw_data->reset_device = adf_reset_flr;
 	hw_data->set_ssm_wdtimer = adf_gen2_set_ssm_wdtimer;
-	hw_data->get_pf2vf_offset = adf_gen2_pf_get_pf2vf_offset;
-	hw_data->get_vf2pf_sources = adf_gen2_get_vf2pf_sources;
-	hw_data->enable_vf2pf_interrupts = adf_gen2_enable_vf2pf_interrupts;
-	hw_data->disable_vf2pf_interrupts = adf_gen2_disable_vf2pf_interrupts;
-	hw_data->enable_pfvf_comms = adf_enable_pf2vf_comms;
 	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->min_iov_compat_ver = ADF_PFVF_COMPAT_THIS_VERSION;
 
+	adf_gen2_init_pf_pfvf_ops(&hw_data->pfvf_ops);
 	adf_gen2_init_hw_csr_ops(&hw_data->csr_ops);
 }
 
diff --git a/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c b/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
index 407f3beee43c..03097bbe600a 100644
--- a/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
+++ b/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
@@ -82,13 +82,12 @@ void adf_init_hw_data_c62xiov(struct adf_hw_device_data *hw_data)
 	hw_data->get_num_aes = get_num_aes;
 	hw_data->get_etr_bar_id = get_etr_bar_id;
 	hw_data->get_misc_bar_id = get_misc_bar_id;
-	hw_data->get_pf2vf_offset = adf_gen2_vf_get_pf2vf_offset;
 	hw_data->get_sku = get_sku;
 	hw_data->enable_ints = adf_vf_void_noop;
-	hw_data->enable_pfvf_comms = adf_enable_vf2pf_comms;
 	hw_data->min_iov_compat_ver = ADF_PFVF_COMPAT_THIS_VERSION;
 	hw_data->dev_class->instances++;
 	adf_devmgr_update_class_index(hw_data);
+	adf_gen2_init_vf_pfvf_ops(&hw_data->pfvf_ops);
 	adf_gen2_init_hw_csr_ops(&hw_data->csr_ops);
 }
 
diff --git a/drivers/crypto/qat/qat_common/Makefile b/drivers/crypto/qat/qat_common/Makefile
index 3874e427d1f7..676aef6533e0 100644
--- a/drivers/crypto/qat/qat_common/Makefile
+++ b/drivers/crypto/qat/qat_common/Makefile
@@ -16,9 +16,9 @@ intel_qat-objs := adf_cfg.o \
 	qat_algs.o \
 	qat_asym_algs.o \
 	qat_uclo.o \
-	qat_hal.o \
-	adf_gen2_pfvf.o
+	qat_hal.o
 
 intel_qat-$(CONFIG_DEBUG_FS) += adf_transport_debug.o
 intel_qat-$(CONFIG_PCI_IOV) += adf_sriov.o adf_pf2vf_msg.o \
-			       adf_vf2pf_msg.o adf_vf_isr.o
+			       adf_vf2pf_msg.o adf_vf_isr.o \
+			       adf_gen2_pfvf.o
diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 57d9ca08e611..67a362021997 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -147,6 +147,14 @@ struct adf_accel_dev;
 struct adf_etr_data;
 struct adf_etr_ring_data;
 
+struct adf_pfvf_ops {
+	int (*enable_comms)(struct adf_accel_dev *accel_dev);
+	u32 (*get_pf2vf_offset)(u32 i);
+	u32 (*get_vf2pf_sources)(void __iomem *pmisc_addr);
+	void (*enable_vf2pf_interrupts)(void __iomem *pmisc_bar_addr, u32 vf_mask);
+	void (*disable_vf2pf_interrupts)(void __iomem *pmisc_bar_addr, u32 vf_mask);
+};
+
 struct adf_hw_device_data {
 	struct adf_hw_device_class *dev_class;
 	u32 (*get_accel_mask)(struct adf_hw_device_data *self);
@@ -157,7 +165,6 @@ struct adf_hw_device_data {
 	u32 (*get_etr_bar_id)(struct adf_hw_device_data *self);
 	u32 (*get_num_aes)(struct adf_hw_device_data *self);
 	u32 (*get_num_accels)(struct adf_hw_device_data *self);
-	u32 (*get_pf2vf_offset)(u32 i);
 	void (*get_arb_info)(struct arb_info *arb_csrs_info);
 	void (*get_admin_info)(struct admin_info *admin_csrs_info);
 	enum dev_sku_info (*get_sku)(struct adf_hw_device_data *self);
@@ -176,17 +183,12 @@ struct adf_hw_device_data {
 				      bool enable);
 	void (*enable_ints)(struct adf_accel_dev *accel_dev);
 	void (*set_ssm_wdtimer)(struct adf_accel_dev *accel_dev);
-	int (*enable_pfvf_comms)(struct adf_accel_dev *accel_dev);
-	u32 (*get_vf2pf_sources)(void __iomem *pmisc_addr);
-	void (*enable_vf2pf_interrupts)(void __iomem *pmisc_bar_addr,
-					u32 vf_mask);
-	void (*disable_vf2pf_interrupts)(void __iomem *pmisc_bar_addr,
-					 u32 vf_mask);
 	void (*reset_device)(struct adf_accel_dev *accel_dev);
 	void (*set_msix_rttable)(struct adf_accel_dev *accel_dev);
 	char *(*uof_get_name)(u32 obj_num);
 	u32 (*uof_get_num_objs)(void);
 	u32 (*uof_get_ae_mask)(u32 obj_num);
+	struct adf_pfvf_ops pfvf_ops;
 	struct adf_hw_csr_ops csr_ops;
 	const char *fw_name;
 	const char *fw_mmp_name;
@@ -222,6 +224,7 @@ struct adf_hw_device_data {
 	GET_HW_DATA(accel_dev)->num_rings_per_bank
 #define GET_MAX_ACCELENGINES(accel_dev) (GET_HW_DATA(accel_dev)->num_engines)
 #define GET_CSR_OPS(accel_dev) (&(accel_dev)->hw_device->csr_ops)
+#define GET_PFVF_OPS(accel_dev) (&(accel_dev)->hw_device->pfvf_ops)
 #define accel_to_pci_dev(accel_ptr) accel_ptr->accel_pci_dev.pci_dev
 
 struct adf_admin_comms;
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
index ea8d34922374..58295e004f19 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
+++ b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2021 Intel Corporation */
 #include <linux/types.h>
 #include "adf_accel_devices.h"
+#include "adf_common_drv.h"
 #include "adf_gen2_pfvf.h"
 
  /* VF2PF interrupts */
@@ -11,17 +12,15 @@
 #define ADF_GEN2_PF_PF2VF_OFFSET(i)	(0x3A000 + 0x280 + ((i) * 0x04))
 #define ADF_GEN2_VF_PF2VF_OFFSET	0x200
 
-u32 adf_gen2_pf_get_pf2vf_offset(u32 i)
+static u32 adf_gen2_pf_get_pf2vf_offset(u32 i)
 {
 	return ADF_GEN2_PF_PF2VF_OFFSET(i);
 }
-EXPORT_SYMBOL_GPL(adf_gen2_pf_get_pf2vf_offset);
 
-u32 adf_gen2_vf_get_pf2vf_offset(u32 i)
+static u32 adf_gen2_vf_get_pf2vf_offset(u32 i)
 {
 	return ADF_GEN2_VF_PF2VF_OFFSET;
 }
-EXPORT_SYMBOL_GPL(adf_gen2_vf_get_pf2vf_offset);
 
 u32 adf_gen2_get_vf2pf_sources(void __iomem *pmisc_addr)
 {
@@ -62,3 +61,20 @@ void adf_gen2_disable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask)
 	}
 }
 EXPORT_SYMBOL_GPL(adf_gen2_disable_vf2pf_interrupts);
+
+void adf_gen2_init_pf_pfvf_ops(struct adf_pfvf_ops *pfvf_ops)
+{
+	pfvf_ops->enable_comms = adf_enable_pf2vf_comms;
+	pfvf_ops->get_pf2vf_offset = adf_gen2_pf_get_pf2vf_offset;
+	pfvf_ops->get_vf2pf_sources = adf_gen2_get_vf2pf_sources;
+	pfvf_ops->enable_vf2pf_interrupts = adf_gen2_enable_vf2pf_interrupts;
+	pfvf_ops->disable_vf2pf_interrupts = adf_gen2_disable_vf2pf_interrupts;
+}
+EXPORT_SYMBOL_GPL(adf_gen2_init_pf_pfvf_ops);
+
+void adf_gen2_init_vf_pfvf_ops(struct adf_pfvf_ops *pfvf_ops)
+{
+	pfvf_ops->enable_comms = adf_enable_vf2pf_comms;
+	pfvf_ops->get_pf2vf_offset = adf_gen2_vf_get_pf2vf_offset;
+}
+EXPORT_SYMBOL_GPL(adf_gen2_init_vf_pfvf_ops);
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.h b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.h
index a21787e3e550..f4045efaa7cd 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.h
+++ b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.h
@@ -11,10 +11,23 @@
 #define ADF_GEN2_ERRMSK3 (0x3A000 + 0x1C)
 #define ADF_GEN2_ERRMSK5 (0x3A000 + 0xDC)
 
-u32 adf_gen2_pf_get_pf2vf_offset(u32 i);
-u32 adf_gen2_vf_get_pf2vf_offset(u32 i);
 u32 adf_gen2_get_vf2pf_sources(void __iomem *pmisc_bar);
 void adf_gen2_enable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask);
 void adf_gen2_disable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask);
 
+#if defined(CONFIG_PCI_IOV)
+void adf_gen2_init_pf_pfvf_ops(struct adf_pfvf_ops *pfvf_ops);
+void adf_gen2_init_vf_pfvf_ops(struct adf_pfvf_ops *pfvf_ops);
+#else
+static inline void adf_gen2_init_pf_pfvf_ops(struct adf_pfvf_ops *pfvf_ops)
+{
+	pfvf_ops->enable_comms = adf_pfvf_comms_disabled;
+}
+
+static inline void adf_gen2_init_vf_pfvf_ops(struct adf_pfvf_ops *pfvf_ops)
+{
+	pfvf_ops->enable_comms = adf_pfvf_comms_disabled;
+}
+#endif
+
 #endif /* ADF_GEN2_PFVF_H */
diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
index e3749e5817d9..391d82a64a93 100644
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -117,7 +117,7 @@ int adf_dev_init(struct adf_accel_dev *accel_dev)
 	hw_data->enable_ints(accel_dev);
 	hw_data->enable_error_correction(accel_dev);
 
-	ret = hw_data->enable_pfvf_comms(accel_dev);
+	ret = hw_data->pfvf_ops.enable_comms(accel_dev);
 	if (ret)
 		return ret;
 
diff --git a/drivers/crypto/qat/qat_common/adf_isr.c b/drivers/crypto/qat/qat_common/adf_isr.c
index 2b4900c91308..358200c0d598 100644
--- a/drivers/crypto/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_isr.c
@@ -64,7 +64,7 @@ void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 vf_mask)
 	unsigned long flags;
 
 	spin_lock_irqsave(&accel_dev->pf.vf2pf_ints_lock, flags);
-	hw_data->enable_vf2pf_interrupts(pmisc_addr, vf_mask);
+	hw_data->pfvf_ops.enable_vf2pf_interrupts(pmisc_addr, vf_mask);
 	spin_unlock_irqrestore(&accel_dev->pf.vf2pf_ints_lock, flags);
 }
 
@@ -77,7 +77,7 @@ void adf_disable_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 vf_mask)
 	unsigned long flags;
 
 	spin_lock_irqsave(&accel_dev->pf.vf2pf_ints_lock, flags);
-	hw_data->disable_vf2pf_interrupts(pmisc_addr, vf_mask);
+	hw_data->pfvf_ops.disable_vf2pf_interrupts(pmisc_addr, vf_mask);
 	spin_unlock_irqrestore(&accel_dev->pf.vf2pf_ints_lock, flags);
 }
 
@@ -90,7 +90,7 @@ static void adf_disable_vf2pf_interrupts_irq(struct adf_accel_dev *accel_dev,
 	void __iomem *pmisc_addr = pmisc->virt_addr;
 
 	spin_lock(&accel_dev->pf.vf2pf_ints_lock);
-	hw_data->disable_vf2pf_interrupts(pmisc_addr, vf_mask);
+	hw_data->pfvf_ops.disable_vf2pf_interrupts(pmisc_addr, vf_mask);
 	spin_unlock(&accel_dev->pf.vf2pf_ints_lock);
 }
 
@@ -104,7 +104,7 @@ static bool adf_handle_vf2pf_int(struct adf_accel_dev *accel_dev)
 	unsigned long vf_mask;
 
 	/* Get the interrupt sources triggered by VFs */
-	vf_mask = hw_data->get_vf2pf_sources(pmisc_addr);
+	vf_mask = hw_data->pfvf_ops.get_vf2pf_sources(pmisc_addr);
 
 	if (vf_mask) {
 		struct adf_accel_vf_info *vf_info;
diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index d98e3639c9d2..78dc8aea4866 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -29,7 +29,7 @@ static int adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 	int ret;
 
 	if (accel_dev->is_vf) {
-		pf2vf_offset = hw_data->get_pf2vf_offset(0);
+		pf2vf_offset = hw_data->pfvf_ops.get_pf2vf_offset(0);
 		lock = &accel_dev->vf.vf2pf_lock;
 		local_in_use_mask = ADF_VF2PF_IN_USE_BY_VF_MASK;
 		local_in_use_pattern = ADF_VF2PF_IN_USE_BY_VF;
@@ -37,7 +37,7 @@ static int adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 		remote_in_use_pattern = ADF_PF2VF_IN_USE_BY_PF;
 		int_bit = ADF_VF2PF_INT;
 	} else {
-		pf2vf_offset = hw_data->get_pf2vf_offset(vf_nr);
+		pf2vf_offset = hw_data->pfvf_ops.get_pf2vf_offset(vf_nr);
 		lock = &accel_dev->pf.vf_info[vf_nr].pf2vf_lock;
 		local_in_use_mask = ADF_PF2VF_IN_USE_BY_PF_MASK;
 		local_in_use_pattern = ADF_PF2VF_IN_USE_BY_PF;
@@ -258,7 +258,7 @@ bool adf_recv_and_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr)
 	u32 msg, resp = 0;
 
 	/* Read message from the VF */
-	msg = ADF_CSR_RD(pmisc_addr, hw_data->get_pf2vf_offset(vf_nr));
+	msg = ADF_CSR_RD(pmisc_addr, hw_data->pfvf_ops.get_pf2vf_offset(vf_nr));
 	if (!(msg & ADF_VF2PF_INT)) {
 		dev_info(&GET_DEV(accel_dev),
 			 "Spurious VF2PF interrupt, msg %X. Ignored\n", msg);
@@ -275,7 +275,7 @@ bool adf_recv_and_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr)
 
 	/* To ACK, clear the VF2PFINT bit */
 	msg &= ~ADF_VF2PF_INT;
-	ADF_CSR_WR(pmisc_addr, hw_data->get_pf2vf_offset(vf_nr), msg);
+	ADF_CSR_WR(pmisc_addr, hw_data->pfvf_ops.get_pf2vf_offset(vf_nr), msg);
 
 	if (adf_handle_vf2pf_msg(accel_dev, vf_nr, msg, &resp))
 		return false;
diff --git a/drivers/crypto/qat/qat_common/adf_sriov.c b/drivers/crypto/qat/qat_common/adf_sriov.c
index b1a814ac1d67..342063406c19 100644
--- a/drivers/crypto/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/qat/qat_common/adf_sriov.c
@@ -70,7 +70,7 @@ static int adf_enable_sriov(struct adf_accel_dev *accel_dev)
 		hw_data->configure_iov_threads(accel_dev, true);
 
 	/* Enable VF to PF interrupts for all VFs */
-	if (hw_data->get_pf2vf_offset)
+	if (hw_data->pfvf_ops.get_pf2vf_offset)
 		adf_enable_vf2pf_interrupts(accel_dev, BIT_ULL(totalvfs) - 1);
 
 	/*
@@ -100,13 +100,13 @@ void adf_disable_sriov(struct adf_accel_dev *accel_dev)
 	if (!accel_dev->pf.vf_info)
 		return;
 
-	if (hw_data->get_pf2vf_offset)
+	if (hw_data->pfvf_ops.get_pf2vf_offset)
 		adf_pf2vf_notify_restarting(accel_dev);
 
 	pci_disable_sriov(accel_to_pci_dev(accel_dev));
 
 	/* Disable VF to PF interrupts */
-	if (hw_data->get_pf2vf_offset)
+	if (hw_data->pfvf_ops.get_pf2vf_offset)
 		adf_disable_vf2pf_interrupts(accel_dev, GENMASK(31, 0));
 
 	/* Clear Valid bits in AE Thread to PCIe Function Mapping */
diff --git a/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c b/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
index 01a6e68f256b..d11eb60b3e86 100644
--- a/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
@@ -81,7 +81,7 @@ bool adf_recv_and_handle_pf2vf_msg(struct adf_accel_dev *accel_dev)
 	struct adf_bar *pmisc =
 			&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
 	void __iomem *pmisc_bar_addr = pmisc->virt_addr;
-	u32 offset = hw_data->get_pf2vf_offset(0);
+	u32 offset = hw_data->pfvf_ops.get_pf2vf_offset(0);
 	u32 msg;
 
 	/* Read the message from PF */
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index 54378e9efaec..30216a987f72 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -202,14 +202,13 @@ void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data)
 	hw_data->get_arb_mapping = adf_get_arbiter_mapping;
 	hw_data->enable_ints = adf_enable_ints;
 	hw_data->reset_device = adf_reset_sbr;
-	hw_data->get_pf2vf_offset = adf_gen2_pf_get_pf2vf_offset;
-	hw_data->get_vf2pf_sources = get_vf2pf_sources;
-	hw_data->enable_vf2pf_interrupts = enable_vf2pf_interrupts;
-	hw_data->disable_vf2pf_interrupts = disable_vf2pf_interrupts;
-	hw_data->enable_pfvf_comms = adf_enable_pf2vf_comms;
 	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->min_iov_compat_ver = ADF_PFVF_COMPAT_THIS_VERSION;
 
+	adf_gen2_init_pf_pfvf_ops(&hw_data->pfvf_ops);
+	hw_data->pfvf_ops.get_vf2pf_sources = get_vf2pf_sources;
+	hw_data->pfvf_ops.enable_vf2pf_interrupts = enable_vf2pf_interrupts;
+	hw_data->pfvf_ops.disable_vf2pf_interrupts = disable_vf2pf_interrupts;
 	adf_gen2_init_hw_csr_ops(&hw_data->csr_ops);
 }
 
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
index 30d862226026..2e2ef6b5bd2a 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
@@ -82,13 +82,12 @@ void adf_init_hw_data_dh895xcciov(struct adf_hw_device_data *hw_data)
 	hw_data->get_num_aes = get_num_aes;
 	hw_data->get_etr_bar_id = get_etr_bar_id;
 	hw_data->get_misc_bar_id = get_misc_bar_id;
-	hw_data->get_pf2vf_offset = adf_gen2_vf_get_pf2vf_offset;
 	hw_data->get_sku = get_sku;
 	hw_data->enable_ints = adf_vf_void_noop;
-	hw_data->enable_pfvf_comms = adf_enable_vf2pf_comms;
 	hw_data->min_iov_compat_ver = ADF_PFVF_COMPAT_THIS_VERSION;
 	hw_data->dev_class->instances++;
 	adf_devmgr_update_class_index(hw_data);
+	adf_gen2_init_vf_pfvf_ops(&hw_data->pfvf_ops);
 	adf_gen2_init_hw_csr_ops(&hw_data->csr_ops);
 }
 
-- 
2.33.1

