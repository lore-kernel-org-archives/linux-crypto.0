Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 795B2C4332F
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Dec 2021 09:12:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbhLPJMM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Dec 2021 04:12:12 -0500
Received: from mga12.intel.com ([192.55.52.136]:9719 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232948AbhLPJMH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Dec 2021 04:12:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639645927; x=1671181927;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U6dvBEu1BouYkIMWbmnfTopexIZnXZofSykWPA1ErQg=;
  b=mIE8ChhzDYPWcnkQFZkNIixo4OwDAzt4kPD6YVXicbO0vT8+5Brj2TJi
   3hJXrtmSTSMegjDqcS2qm2jeh+2JQQzDvDioUrKYxE58VquqEScbXypce
   /rcJugGpQmYigQljliNz855Vm/yW0RBHRNr+NZXMhoEFDTqsh0xNtjTQ4
   CpqC90oj2avpya4Pmkcx2W1Ah8tUPyxNyq6F2wayVik3Bl13OTge1qQiR
   PwyzABLCM1aaOLtYTE7UqmAI6BZ9eyyrDb2luXzY5OrGys5lIh4ICwAZa
   28Y9icdx6BINQ0Zu7yTtzXS2yxGBrAqtDBK8W4cCcVuHXkoMT+X9mfY3Q
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="219458486"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="219458486"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 01:11:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="465968657"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by orsmga006.jf.intel.com with ESMTP; 16 Dec 2021 01:11:50 -0800
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com, marco.chiappero@intel.com,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH 21/24] crypto: qat - add PFVF support to the GEN4 host driver
Date:   Thu, 16 Dec 2021 09:13:31 +0000
Message-Id: <20211216091334.402420-22-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211216091334.402420-1-marco.chiappero@intel.com>
References: <20211216091334.402420-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

So far PFVF support for GEN4 devices has been kept effectively disabled
due to lack of support. This patch adds all the GEN4 specific logic to
make PFVF fully functional on PF.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
---
 .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.c    |  10 +-
 drivers/crypto/qat/qat_common/Makefile        |   2 +-
 drivers/crypto/qat/qat_common/adf_gen4_pfvf.c | 148 ++++++++++++++++++
 drivers/crypto/qat/qat_common/adf_gen4_pfvf.h |  17 ++
 drivers/crypto/qat/qat_common/adf_pfvf_msg.h  |  29 +++-
 5 files changed, 196 insertions(+), 10 deletions(-)
 create mode 100644 drivers/crypto/qat/qat_common/adf_gen4_pfvf.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_gen4_pfvf.h

diff --git a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
index 67cd20f443ab..ef71aa4efd64 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -4,6 +4,7 @@
 #include <adf_accel_devices.h>
 #include <adf_common_drv.h>
 #include <adf_gen4_hw_data.h>
+#include <adf_gen4_pfvf.h>
 #include "adf_4xxx_hw_data.h"
 #include "icp_qat_hw.h"
 
@@ -228,12 +229,6 @@ static u32 uof_get_ae_mask(u32 obj_num)
 	return adf_4xxx_fw_config[obj_num].ae_mask;
 }
 
-static u32 get_vf2pf_sources(void __iomem *pmisc_addr)
-{
-	/* For the moment do not report vf2pf sources */
-	return 0;
-}
-
 void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data)
 {
 	hw_data->dev_class = &adf_4xxx_class;
@@ -278,12 +273,11 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data)
 	hw_data->uof_get_ae_mask = uof_get_ae_mask;
 	hw_data->set_msix_rttable = set_msix_default_rttable;
 	hw_data->set_ssm_wdtimer = adf_gen4_set_ssm_wdtimer;
-	hw_data->pfvf_ops.enable_comms = adf_pfvf_comms_disabled;
-	hw_data->pfvf_ops.get_vf2pf_sources = get_vf2pf_sources;
 	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->ring_pair_reset = adf_gen4_ring_pair_reset;
 
 	adf_gen4_init_hw_csr_ops(&hw_data->csr_ops);
+	adf_gen4_init_pf_pfvf_ops(&hw_data->pfvf_ops);
 }
 
 void adf_clean_hw_data_4xxx(struct adf_hw_device_data *hw_data)
diff --git a/drivers/crypto/qat/qat_common/Makefile b/drivers/crypto/qat/qat_common/Makefile
index 80f6cb424753..7e191a42a5c7 100644
--- a/drivers/crypto/qat/qat_common/Makefile
+++ b/drivers/crypto/qat/qat_common/Makefile
@@ -22,4 +22,4 @@ intel_qat-$(CONFIG_DEBUG_FS) += adf_transport_debug.o
 intel_qat-$(CONFIG_PCI_IOV) += adf_sriov.o adf_vf_isr.o adf_pfvf_utils.o \
 			       adf_pfvf_pf_msg.o adf_pfvf_pf_proto.o \
 			       adf_pfvf_vf_msg.o adf_pfvf_vf_proto.o \
-			       adf_gen2_pfvf.o
+			       adf_gen2_pfvf.o adf_gen4_pfvf.o
diff --git a/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c b/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c
new file mode 100644
index 000000000000..8efbedf63bc8
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c
@@ -0,0 +1,148 @@
+// SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
+/* Copyright(c) 2021 Intel Corporation */
+#include <linux/iopoll.h>
+#include <linux/mutex.h>
+#include <linux/types.h>
+#include "adf_accel_devices.h"
+#include "adf_common_drv.h"
+#include "adf_gen4_pfvf.h"
+#include "adf_pfvf_pf_proto.h"
+#include "adf_pfvf_utils.h"
+
+#define ADF_4XXX_MAX_NUM_VFS		16
+
+#define ADF_4XXX_PF2VM_OFFSET(i)	(0x40B010 + ((i) * 0x20))
+#define ADF_4XXX_VM2PF_OFFSET(i)	(0x40B014 + ((i) * 0x20))
+
+/* VF2PF interrupt source registers */
+#define ADF_4XXX_VM2PF_SOU(i)		(0x41A180 + ((i) * 4))
+#define ADF_4XXX_VM2PF_MSK(i)		(0x41A1C0 + ((i) * 4))
+#define ADF_4XXX_VM2PF_INT_EN_MSK	BIT(0)
+
+#define ADF_PFVF_GEN4_MSGTYPE_SHIFT	2
+#define ADF_PFVF_GEN4_MSGTYPE_MASK	0x3F
+#define ADF_PFVF_GEN4_MSGDATA_SHIFT	8
+#define ADF_PFVF_GEN4_MSGDATA_MASK	0xFFFFFF
+
+static const struct pfvf_csr_format csr_gen4_fmt = {
+	{ ADF_PFVF_GEN4_MSGTYPE_SHIFT, ADF_PFVF_GEN4_MSGTYPE_MASK },
+	{ ADF_PFVF_GEN4_MSGDATA_SHIFT, ADF_PFVF_GEN4_MSGDATA_MASK },
+};
+
+static u32 adf_gen4_pf_get_pf2vf_offset(u32 i)
+{
+	return ADF_4XXX_PF2VM_OFFSET(i);
+}
+
+static u32 adf_gen4_pf_get_vf2pf_offset(u32 i)
+{
+	return ADF_4XXX_VM2PF_OFFSET(i);
+}
+
+static u32 adf_gen4_get_vf2pf_sources(void __iomem *pmisc_addr)
+{
+	int i;
+	u32 sou, mask;
+	int num_csrs = ADF_4XXX_MAX_NUM_VFS;
+	u32 vf_mask = 0;
+
+	for (i = 0; i < num_csrs; i++) {
+		sou = ADF_CSR_RD(pmisc_addr, ADF_4XXX_VM2PF_SOU(i));
+		mask = ADF_CSR_RD(pmisc_addr, ADF_4XXX_VM2PF_MSK(i));
+		sou &= ~mask;
+		vf_mask |= sou << i;
+	}
+
+	return vf_mask;
+}
+
+static void adf_gen4_enable_vf2pf_interrupts(void __iomem *pmisc_addr,
+					     u32 vf_mask)
+{
+	int num_csrs = ADF_4XXX_MAX_NUM_VFS;
+	unsigned long mask = vf_mask;
+	unsigned int val;
+	int i;
+
+	for_each_set_bit(i, &mask, num_csrs) {
+		unsigned int offset = ADF_4XXX_VM2PF_MSK(i);
+
+		val = ADF_CSR_RD(pmisc_addr, offset) & ~ADF_4XXX_VM2PF_INT_EN_MSK;
+		ADF_CSR_WR(pmisc_addr, offset, val);
+	}
+}
+
+static void adf_gen4_disable_vf2pf_interrupts(void __iomem *pmisc_addr,
+					      u32 vf_mask)
+{
+	int num_csrs = ADF_4XXX_MAX_NUM_VFS;
+	unsigned long mask = vf_mask;
+	unsigned int val;
+	int i;
+
+	for_each_set_bit(i, &mask, num_csrs) {
+		unsigned int offset = ADF_4XXX_VM2PF_MSK(i);
+
+		val = ADF_CSR_RD(pmisc_addr, offset) | ADF_4XXX_VM2PF_INT_EN_MSK;
+		ADF_CSR_WR(pmisc_addr, offset, val);
+	}
+}
+
+static int adf_gen4_pfvf_send(struct adf_accel_dev *accel_dev,
+			      struct pfvf_message msg, u32 pfvf_offset,
+			      struct mutex *csr_lock)
+{
+	void __iomem *pmisc_addr = adf_get_pmisc_base(accel_dev);
+	u32 csr_val;
+	int ret;
+
+	csr_val = adf_pfvf_csr_msg_of(accel_dev, msg, &csr_gen4_fmt);
+	if (unlikely(!csr_val))
+		return -EINVAL;
+
+	mutex_lock(csr_lock);
+
+	ADF_CSR_WR(pmisc_addr, pfvf_offset, csr_val | ADF_PFVF_INT);
+
+	/* Wait for confirmation from remote that it received the message */
+	ret = read_poll_timeout(ADF_CSR_RD, csr_val, !(csr_val & ADF_PFVF_INT),
+				ADF_PFVF_MSG_ACK_DELAY_US,
+				ADF_PFVF_MSG_ACK_MAX_DELAY_US,
+				true, pmisc_addr, pfvf_offset);
+	if (ret < 0)
+		dev_dbg(&GET_DEV(accel_dev), "ACK not received from remote\n");
+
+	mutex_unlock(csr_lock);
+	return ret;
+}
+
+static struct pfvf_message adf_gen4_pfvf_recv(struct adf_accel_dev *accel_dev,
+					      u32 pfvf_offset, u8 compat_ver)
+{
+	void __iomem *pmisc_addr = adf_get_pmisc_base(accel_dev);
+	u32 csr_val;
+
+	/* Read message from the CSR */
+	csr_val = ADF_CSR_RD(pmisc_addr, pfvf_offset);
+
+	/* We can now acknowledge the message reception by clearing the
+	 * interrupt bit
+	 */
+	ADF_CSR_WR(pmisc_addr, pfvf_offset, csr_val & ~ADF_PFVF_INT);
+
+	/* Return the pfvf_message format */
+	return adf_pfvf_message_of(accel_dev, csr_val, &csr_gen4_fmt);
+}
+
+void adf_gen4_init_pf_pfvf_ops(struct adf_pfvf_ops *pfvf_ops)
+{
+	pfvf_ops->enable_comms = adf_enable_pf2vf_comms;
+	pfvf_ops->get_pf2vf_offset = adf_gen4_pf_get_pf2vf_offset;
+	pfvf_ops->get_vf2pf_offset = adf_gen4_pf_get_vf2pf_offset;
+	pfvf_ops->get_vf2pf_sources = adf_gen4_get_vf2pf_sources;
+	pfvf_ops->enable_vf2pf_interrupts = adf_gen4_enable_vf2pf_interrupts;
+	pfvf_ops->disable_vf2pf_interrupts = adf_gen4_disable_vf2pf_interrupts;
+	pfvf_ops->send_msg = adf_gen4_pfvf_send;
+	pfvf_ops->recv_msg = adf_gen4_pfvf_recv;
+}
+EXPORT_SYMBOL_GPL(adf_gen4_init_pf_pfvf_ops);
diff --git a/drivers/crypto/qat/qat_common/adf_gen4_pfvf.h b/drivers/crypto/qat/qat_common/adf_gen4_pfvf.h
new file mode 100644
index 000000000000..17d1b774d4a8
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_gen4_pfvf.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only) */
+/* Copyright(c) 2021 Intel Corporation */
+#ifndef ADF_GEN4_PFVF_H
+#define ADF_GEN4_PFVF_H
+
+#include "adf_accel_devices.h"
+
+#ifdef CONFIG_PCI_IOV
+void adf_gen4_init_pf_pfvf_ops(struct adf_pfvf_ops *pfvf_ops);
+#else
+static inline void adf_gen4_init_pf_pfvf_ops(struct adf_pfvf_ops *pfvf_ops)
+{
+	pfvf_ops->enable_comms = adf_pfvf_comms_disabled;
+}
+#endif
+
+#endif /* ADF_GEN4_PFVF_H */
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_msg.h b/drivers/crypto/qat/qat_common/adf_pfvf_msg.h
index 1d3cad7d4999..f00e9e2c585b 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_msg.h
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_msg.h
@@ -6,7 +6,8 @@
 #include <linux/bits.h>
 
 /*
- * PF<->VF Messaging
+ * PF<->VF Gen2 Messaging format
+ *
  * The PF has an array of 32-bit PF2VF registers, one for each VF.  The
  * PF can access all these registers; each VF can access only the one
  * register associated with that particular VF.
@@ -53,6 +54,32 @@
  * respectively, the other 16 bits are written to first with a defined
  * IN_USE_BY pattern as part of a collision control scheme (see function
  * adf_gen2_pfvf_send() in adf_pf2vf_msg.c).
+ *
+ *
+ * PF<->VF Gen4 Messaging format
+ *
+ * Similarly to the gen2 messaging format, 32-bit long registers are used for
+ * communication between PF and VFs. However, each VF and PF share a pair of
+ * 32-bits register to avoid collisions: one for PV to VF messages and one
+ * for VF to PF messages.
+ *
+ * Both the Interrupt bit and the Message Origin bit retain the same position
+ * and meaning, although non-system messages are now deprecated and not
+ * expected.
+ *
+ *  31 30              9  8  7  6  5  4  3  2  1  0
+ *  _______________________________________________
+ * |  |  |   . . .   |  |  |  |  |  |  |  |  |  |  |
+ * +-----------------------------------------------+
+ *  \_____________________/ \_______________/  ^  ^
+ *             ^                     ^         |  |
+ *             |                     |         |  PF/VF Int
+ *             |                     |         Message Origin
+ *             |                     Message Type
+ *             Message-specific Data/Reserved
+ *
+ * For both formats, the message reception is acknowledged by lowering the
+ * interrupt bit on the register where the message was sent.
  */
 
 /* PFVF message common bits */
-- 
2.31.1

