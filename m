Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02983C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 12:04:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDDD96322E
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 12:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbhKOMH3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 07:07:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:13648 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231263AbhKOMHA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 07:07:00 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10168"; a="233265552"
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="233265552"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 04:04:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="535486405"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga001.jf.intel.com with ESMTP; 15 Nov 2021 04:04:03 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        marco.chiappero@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 10/24] crypto: qat - relocate PFVF PF related logic
Date:   Mon, 15 Nov 2021 12:03:22 +0000
Message-Id: <20211115120336.22292-11-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115120336.22292-1-giovanni.cabiddu@intel.com>
References: <20211115120336.22292-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Marco Chiappero <marco.chiappero@intel.com>

Move device specific PFVF logic related to the PF to the newly created
adf_gen2_pfvf.c.
This refactory is done to isolate the GEN2 PFVF code into its own file
in preparation for the introduction of support for PFVF for GEN4
devices.

In addition the PFVF PF logic for dh895xcc has been isolated to
the file adf_dh895xcc_hw_data.c.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c  |  1 +
 .../crypto/qat/qat_c62x/adf_c62x_hw_data.c    |  1 +
 drivers/crypto/qat/qat_common/Makefile        |  3 +-
 .../crypto/qat/qat_common/adf_gen2_hw_data.c  | 48 ----------------
 .../crypto/qat/qat_common/adf_gen2_hw_data.h  | 13 -----
 drivers/crypto/qat/qat_common/adf_gen2_pfvf.c | 57 +++++++++++++++++++
 drivers/crypto/qat/qat_common/adf_gen2_pfvf.h | 19 +++++++
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   | 28 ++++++---
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.h   |  2 +
 9 files changed, 103 insertions(+), 69 deletions(-)
 create mode 100644 drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_gen2_pfvf.h

diff --git a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
index 1fa690219d92..0bc528004f79 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
@@ -4,6 +4,7 @@
 #include <adf_common_drv.h>
 #include <adf_pf2vf_msg.h>
 #include <adf_gen2_hw_data.h>
+#include <adf_gen2_pfvf.h>
 #include "adf_c3xxx_hw_data.h"
 #include "icp_qat_hw.h"
 
diff --git a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
index 0613db077689..9303f2dbcaf9 100644
--- a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
+++ b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
@@ -4,6 +4,7 @@
 #include <adf_common_drv.h>
 #include <adf_pf2vf_msg.h>
 #include <adf_gen2_hw_data.h>
+#include <adf_gen2_pfvf.h>
 #include "adf_c62x_hw_data.h"
 #include "icp_qat_hw.h"
 
diff --git a/drivers/crypto/qat/qat_common/Makefile b/drivers/crypto/qat/qat_common/Makefile
index 9c57abdf56b7..3874e427d1f7 100644
--- a/drivers/crypto/qat/qat_common/Makefile
+++ b/drivers/crypto/qat/qat_common/Makefile
@@ -16,7 +16,8 @@ intel_qat-objs := adf_cfg.o \
 	qat_algs.o \
 	qat_asym_algs.o \
 	qat_uclo.o \
-	qat_hal.o
+	qat_hal.o \
+	adf_gen2_pfvf.o
 
 intel_qat-$(CONFIG_DEBUG_FS) += adf_transport_debug.o
 intel_qat-$(CONFIG_PCI_IOV) += adf_sriov.o adf_pf2vf_msg.o \
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
index 262bdc05dab4..3b48fdaaff6d 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
+++ b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
@@ -4,54 +4,6 @@
 #include "icp_qat_hw.h"
 #include <linux/pci.h>
 
-#define ADF_GEN2_PF2VF_OFFSET(i)	(0x3A000 + 0x280 + ((i) * 0x04))
-
-u32 adf_gen2_get_pf2vf_offset(u32 i)
-{
-	return ADF_GEN2_PF2VF_OFFSET(i);
-}
-EXPORT_SYMBOL_GPL(adf_gen2_get_pf2vf_offset);
-
-u32 adf_gen2_get_vf2pf_sources(void __iomem *pmisc_addr)
-{
-	u32 errsou3, errmsk3, vf_int_mask;
-
-	/* Get the interrupt sources triggered by VFs */
-	errsou3 = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRSOU3);
-	vf_int_mask = ADF_GEN2_ERR_REG_VF2PF(errsou3);
-
-	/* To avoid adding duplicate entries to work queue, clear
-	 * vf_int_mask_sets bits that are already masked in ERRMSK register.
-	 */
-	errmsk3 = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRMSK3);
-	vf_int_mask &= ~ADF_GEN2_ERR_REG_VF2PF(errmsk3);
-
-	return vf_int_mask;
-}
-EXPORT_SYMBOL_GPL(adf_gen2_get_vf2pf_sources);
-
-void adf_gen2_enable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask)
-{
-	/* Enable VF2PF Messaging Ints - VFs 0 through 15 per vf_mask[15:0] */
-	if (vf_mask & 0xFFFF) {
-		u32 val = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRMSK3)
-			  & ~ADF_GEN2_ERR_MSK_VF2PF(vf_mask);
-		ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK3, val);
-	}
-}
-EXPORT_SYMBOL_GPL(adf_gen2_enable_vf2pf_interrupts);
-
-void adf_gen2_disable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask)
-{
-	/* Disable VF2PF interrupts for VFs 0 through 15 per vf_mask[15:0] */
-	if (vf_mask & 0xFFFF) {
-		u32 val = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRMSK3)
-			  | ADF_GEN2_ERR_MSK_VF2PF(vf_mask);
-		ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK3, val);
-	}
-}
-EXPORT_SYMBOL_GPL(adf_gen2_disable_vf2pf_interrupts);
-
 u32 adf_gen2_get_num_accels(struct adf_hw_device_data *self)
 {
 	if (!self || !self->accel_mask)
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
index c169d704097d..448c97f740e7 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
+++ b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
@@ -136,19 +136,6 @@ do { \
 #define ADF_GEN2_CERRSSMSH(i)		((i) * 0x4000 + 0x10)
 #define ADF_GEN2_ERRSSMSH_EN		BIT(3)
 
- /* VF2PF interrupts */
-#define ADF_GEN2_ERRSOU3 (0x3A000 + 0x0C)
-#define ADF_GEN2_ERRSOU5 (0x3A000 + 0xD8)
-#define ADF_GEN2_ERRMSK3 (0x3A000 + 0x1C)
-#define ADF_GEN2_ERRMSK5 (0x3A000 + 0xDC)
-#define ADF_GEN2_ERR_REG_VF2PF(vf_src)	(((vf_src) & 0x01FFFE00) >> 9)
-#define ADF_GEN2_ERR_MSK_VF2PF(vf_mask)	(((vf_mask) & 0xFFFF) << 9)
-
-u32 adf_gen2_get_pf2vf_offset(u32 i);
-u32 adf_gen2_get_vf2pf_sources(void __iomem *pmisc_bar);
-void adf_gen2_enable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask);
-void adf_gen2_disable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask);
-
 u32 adf_gen2_get_num_accels(struct adf_hw_device_data *self);
 u32 adf_gen2_get_num_aes(struct adf_hw_device_data *self);
 void adf_gen2_enable_error_correction(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
new file mode 100644
index 000000000000..d4d79419daaa
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
@@ -0,0 +1,57 @@
+// SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
+/* Copyright(c) 2021 Intel Corporation */
+#include <linux/types.h>
+#include "adf_accel_devices.h"
+#include "adf_gen2_pfvf.h"
+
+ /* VF2PF interrupts */
+#define ADF_GEN2_ERR_REG_VF2PF(vf_src)	(((vf_src) & 0x01FFFE00) >> 9)
+#define ADF_GEN2_ERR_MSK_VF2PF(vf_mask)	(((vf_mask) & 0xFFFF) << 9)
+
+#define ADF_GEN2_PF2VF_OFFSET(i)	(0x3A000 + 0x280 + ((i) * 0x04))
+
+u32 adf_gen2_get_pf2vf_offset(u32 i)
+{
+	return ADF_GEN2_PF2VF_OFFSET(i);
+}
+EXPORT_SYMBOL_GPL(adf_gen2_get_pf2vf_offset);
+
+u32 adf_gen2_get_vf2pf_sources(void __iomem *pmisc_addr)
+{
+	u32 errsou3, errmsk3, vf_int_mask;
+
+	/* Get the interrupt sources triggered by VFs */
+	errsou3 = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRSOU3);
+	vf_int_mask = ADF_GEN2_ERR_REG_VF2PF(errsou3);
+
+	/* To avoid adding duplicate entries to work queue, clear
+	 * vf_int_mask_sets bits that are already masked in ERRMSK register.
+	 */
+	errmsk3 = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRMSK3);
+	vf_int_mask &= ~ADF_GEN2_ERR_REG_VF2PF(errmsk3);
+
+	return vf_int_mask;
+}
+EXPORT_SYMBOL_GPL(adf_gen2_get_vf2pf_sources);
+
+void adf_gen2_enable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask)
+{
+	/* Enable VF2PF Messaging Ints - VFs 0 through 15 per vf_mask[15:0] */
+	if (vf_mask & 0xFFFF) {
+		u32 val = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRMSK3)
+			  & ~ADF_GEN2_ERR_MSK_VF2PF(vf_mask);
+		ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK3, val);
+	}
+}
+EXPORT_SYMBOL_GPL(adf_gen2_enable_vf2pf_interrupts);
+
+void adf_gen2_disable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask)
+{
+	/* Disable VF2PF interrupts for VFs 0 through 15 per vf_mask[15:0] */
+	if (vf_mask & 0xFFFF) {
+		u32 val = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRMSK3)
+			  | ADF_GEN2_ERR_MSK_VF2PF(vf_mask);
+		ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK3, val);
+	}
+}
+EXPORT_SYMBOL_GPL(adf_gen2_disable_vf2pf_interrupts);
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.h b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.h
new file mode 100644
index 000000000000..0987e254e86b
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only) */
+/* Copyright(c) 2021 Intel Corporation */
+#ifndef ADF_GEN2_PFVF_H
+#define ADF_GEN2_PFVF_H
+
+#include <linux/types.h>
+#include "adf_accel_devices.h"
+
+#define ADF_GEN2_ERRSOU3 (0x3A000 + 0x0C)
+#define ADF_GEN2_ERRSOU5 (0x3A000 + 0xD8)
+#define ADF_GEN2_ERRMSK3 (0x3A000 + 0x1C)
+#define ADF_GEN2_ERRMSK5 (0x3A000 + 0xDC)
+
+u32 adf_gen2_get_pf2vf_offset(u32 i);
+u32 adf_gen2_get_vf2pf_sources(void __iomem *pmisc_bar);
+void adf_gen2_enable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask);
+void adf_gen2_disable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask);
+
+#endif /* ADF_GEN2_PFVF_H */
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index 8e2e1554dcf6..e134385b76a8 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -4,6 +4,7 @@
 #include <adf_pf2vf_msg.h>
 #include <adf_common_drv.h>
 #include <adf_gen2_hw_data.h>
+#include <adf_gen2_pfvf.h>
 #include "adf_dh895xcc_hw_data.h"
 #include "icp_qat_hw.h"
 
@@ -114,14 +115,19 @@ static void adf_enable_ints(struct adf_accel_dev *accel_dev)
 
 static u32 get_vf2pf_sources(void __iomem *pmisc_bar)
 {
-	u32 errsou5, errmsk5, vf_int_mask;
+	u32 errsou3, errmsk3, errsou5, errmsk5, vf_int_mask;
 
-	vf_int_mask = adf_gen2_get_vf2pf_sources(pmisc_bar);
+	/* Get the interrupt sources triggered by VFs */
+	errsou3 = ADF_CSR_RD(pmisc_bar, ADF_GEN2_ERRSOU3);
+	vf_int_mask = ADF_DH895XCC_ERR_REG_VF2PF_L(errsou3);
 
-	/* Get the interrupt sources triggered by VFs, but to avoid duplicates
-	 * in the work queue, clear vf_int_mask_sets bits that are already
-	 * masked in ERRMSK register.
+	/* To avoid adding duplicate entries to work queue, clear
+	 * vf_int_mask_sets bits that are already masked in ERRMSK register.
 	 */
+	errmsk3 = ADF_CSR_RD(pmisc_bar, ADF_GEN2_ERRMSK3);
+	vf_int_mask &= ~ADF_DH895XCC_ERR_REG_VF2PF_L(errmsk3);
+
+	/* Do the same for ERRSOU5 */
 	errsou5 = ADF_CSR_RD(pmisc_bar, ADF_GEN2_ERRSOU5);
 	errmsk5 = ADF_CSR_RD(pmisc_bar, ADF_GEN2_ERRMSK5);
 	vf_int_mask |= ADF_DH895XCC_ERR_REG_VF2PF_U(errsou5);
@@ -133,7 +139,11 @@ static u32 get_vf2pf_sources(void __iomem *pmisc_bar)
 static void enable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask)
 {
 	/* Enable VF2PF Messaging Ints - VFs 0 through 15 per vf_mask[15:0] */
-	adf_gen2_enable_vf2pf_interrupts(pmisc_addr, vf_mask);
+	if (vf_mask & 0xFFFF) {
+		u32 val = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRMSK3)
+			  & ~ADF_DH895XCC_ERR_MSK_VF2PF_L(vf_mask);
+		ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK3, val);
+	}
 
 	/* Enable VF2PF Messaging Ints - VFs 16 through 31 per vf_mask[31:16] */
 	if (vf_mask >> 16) {
@@ -147,7 +157,11 @@ static void enable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask)
 static void disable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask)
 {
 	/* Disable VF2PF interrupts for VFs 0 through 15 per vf_mask[15:0] */
-	adf_gen2_disable_vf2pf_interrupts(pmisc_addr, vf_mask);
+	if (vf_mask & 0xFFFF) {
+		u32 val = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRMSK3)
+			  | ADF_DH895XCC_ERR_MSK_VF2PF_L(vf_mask);
+		ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK3, val);
+	}
 
 	/* Disable VF2PF interrupts for VFs 16 through 31 per vf_mask[31:16] */
 	if (vf_mask >> 16) {
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
index 0af34dd8708a..aa17272a1507 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
@@ -25,6 +25,8 @@
 #define ADF_DH895XCC_SMIA1_MASK 0x1
 
 /* Masks for VF2PF interrupts */
+#define ADF_DH895XCC_ERR_REG_VF2PF_L(vf_src)	(((vf_src) & 0x01FFFE00) >> 9)
+#define ADF_DH895XCC_ERR_MSK_VF2PF_L(vf_mask)	(((vf_mask) & 0xFFFF) << 9)
 #define ADF_DH895XCC_ERR_REG_VF2PF_U(vf_src)	(((vf_src) & 0x0000FFFF) << 16)
 #define ADF_DH895XCC_ERR_MSK_VF2PF_U(vf_mask)	((vf_mask) >> 16)
 
-- 
2.33.1

