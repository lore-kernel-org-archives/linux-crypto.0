Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B889C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 20:52:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5019460F9E
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 20:52:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233144AbhKJUzj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Nov 2021 15:55:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:55781 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233115AbhKJUzf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Nov 2021 15:55:35 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10164"; a="232611206"
X-IronPort-AV: E=Sophos;i="5.87,224,1631602800"; 
   d="scan'208";a="232611206"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 12:52:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,224,1631602800"; 
   d="scan'208";a="642663213"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga001.fm.intel.com with ESMTP; 10 Nov 2021 12:52:44 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        marco.chiappero@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 15/24] crypto: qat - abstract PFVF send function
Date:   Wed, 10 Nov 2021 20:52:08 +0000
Message-Id: <20211110205217.99903-16-giovanni.cabiddu@intel.com>
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

Make the PFVF send function device specific.

This is in preparation for the introduction of PFVF support in the
qat_4xxx driver since the send logic differs between QAT GEN2 and
QAT GEN4 devices.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../crypto/qat/qat_common/adf_accel_devices.h |  1 +
 drivers/crypto/qat/qat_common/adf_gen2_pfvf.c | 96 +++++++++++++++++++
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 92 +-----------------
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.h |  3 +-
 4 files changed, 101 insertions(+), 91 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 08bb51321c32..d797f109cc36 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -154,6 +154,7 @@ struct adf_pfvf_ops {
 	u32 (*get_vf2pf_sources)(void __iomem *pmisc_addr);
 	void (*enable_vf2pf_interrupts)(void __iomem *pmisc_bar_addr, u32 vf_mask);
 	void (*disable_vf2pf_interrupts)(void __iomem *pmisc_bar_addr, u32 vf_mask);
+	int (*send_msg)(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr);
 };
 
 struct adf_hw_device_data {
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
index ba7ec7c313fb..cb883cc8e45a 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
+++ b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
@@ -1,9 +1,12 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
 /* Copyright(c) 2021 Intel Corporation */
+#include <linux/delay.h>
+#include <linux/mutex.h>
 #include <linux/types.h>
 #include "adf_accel_devices.h"
 #include "adf_common_drv.h"
 #include "adf_gen2_pfvf.h"
+#include "adf_pf2vf_msg.h"
 
  /* VF2PF interrupts */
 #define ADF_GEN2_ERR_REG_VF2PF(vf_src)	(((vf_src) & 0x01FFFE00) >> 9)
@@ -12,6 +15,12 @@
 #define ADF_GEN2_PF_PF2VF_OFFSET(i)	(0x3A000 + 0x280 + ((i) * 0x04))
 #define ADF_GEN2_VF_PF2VF_OFFSET	0x200
 
+#define ADF_PFVF_MSG_ACK_DELAY		2
+#define ADF_PFVF_MSG_ACK_MAX_RETRY	100
+
+#define ADF_PFVF_MSG_RETRY_DELAY	5
+#define ADF_PFVF_MSG_MAX_RETRIES	3
+
 static u32 adf_gen2_pf_get_pfvf_offset(u32 i)
 {
 	return ADF_GEN2_PF_PF2VF_OFFSET(i);
@@ -62,6 +71,91 @@ void adf_gen2_disable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask)
 }
 EXPORT_SYMBOL_GPL(adf_gen2_disable_vf2pf_interrupts);
 
+static int adf_gen2_pfvf_send(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
+{
+	struct adf_accel_pci *pci_info = &accel_dev->accel_pci_dev;
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	void __iomem *pmisc_bar_addr =
+		pci_info->pci_bars[hw_data->get_misc_bar_id(hw_data)].virt_addr;
+	u32 val, pfvf_offset, count = 0;
+	u32 local_in_use_mask, local_in_use_pattern;
+	u32 remote_in_use_mask, remote_in_use_pattern;
+	struct mutex *lock;	/* lock preventing concurrent acces of CSR */
+	unsigned int retries = ADF_PFVF_MSG_MAX_RETRIES;
+	u32 int_bit;
+	int ret;
+
+	if (accel_dev->is_vf) {
+		pfvf_offset = GET_PFVF_OPS(accel_dev)->get_vf2pf_offset(0);
+		lock = &accel_dev->vf.vf2pf_lock;
+		local_in_use_mask = ADF_VF2PF_IN_USE_BY_VF_MASK;
+		local_in_use_pattern = ADF_VF2PF_IN_USE_BY_VF;
+		remote_in_use_mask = ADF_PF2VF_IN_USE_BY_PF_MASK;
+		remote_in_use_pattern = ADF_PF2VF_IN_USE_BY_PF;
+		int_bit = ADF_VF2PF_INT;
+	} else {
+		pfvf_offset = GET_PFVF_OPS(accel_dev)->get_pf2vf_offset(vf_nr);
+		lock = &accel_dev->pf.vf_info[vf_nr].pf2vf_lock;
+		local_in_use_mask = ADF_PF2VF_IN_USE_BY_PF_MASK;
+		local_in_use_pattern = ADF_PF2VF_IN_USE_BY_PF;
+		remote_in_use_mask = ADF_VF2PF_IN_USE_BY_VF_MASK;
+		remote_in_use_pattern = ADF_VF2PF_IN_USE_BY_VF;
+		int_bit = ADF_PF2VF_INT;
+	}
+
+	msg &= ~local_in_use_mask;
+	msg |= local_in_use_pattern;
+
+	mutex_lock(lock);
+
+start:
+	ret = 0;
+
+	/* Check if the PFVF CSR is in use by remote function */
+	val = ADF_CSR_RD(pmisc_bar_addr, pfvf_offset);
+	if ((val & remote_in_use_mask) == remote_in_use_pattern) {
+		dev_dbg(&GET_DEV(accel_dev),
+			"PFVF CSR in use by remote function\n");
+		goto retry;
+	}
+
+	/* Attempt to get ownership of the PFVF CSR */
+	ADF_CSR_WR(pmisc_bar_addr, pfvf_offset, msg | int_bit);
+
+	/* Wait for confirmation from remote func it received the message */
+	do {
+		msleep(ADF_PFVF_MSG_ACK_DELAY);
+		val = ADF_CSR_RD(pmisc_bar_addr, pfvf_offset);
+	} while ((val & int_bit) && (count++ < ADF_PFVF_MSG_ACK_MAX_RETRY));
+
+	if (val & int_bit) {
+		dev_dbg(&GET_DEV(accel_dev), "ACK not received from remote\n");
+		val &= ~int_bit;
+		ret = -EIO;
+	}
+
+	if (val != msg) {
+		dev_dbg(&GET_DEV(accel_dev),
+			"Collision - PFVF CSR overwritten by remote function\n");
+		goto retry;
+	}
+
+	/* Finished with the PFVF CSR; relinquish it and leave msg in CSR */
+	ADF_CSR_WR(pmisc_bar_addr, pfvf_offset, val & ~local_in_use_mask);
+out:
+	mutex_unlock(lock);
+	return ret;
+
+retry:
+	if (--retries) {
+		msleep(ADF_PFVF_MSG_RETRY_DELAY);
+		goto start;
+	} else {
+		ret = -EBUSY;
+		goto out;
+	}
+}
+
 void adf_gen2_init_pf_pfvf_ops(struct adf_pfvf_ops *pfvf_ops)
 {
 	pfvf_ops->enable_comms = adf_enable_pf2vf_comms;
@@ -70,6 +164,7 @@ void adf_gen2_init_pf_pfvf_ops(struct adf_pfvf_ops *pfvf_ops)
 	pfvf_ops->get_vf2pf_sources = adf_gen2_get_vf2pf_sources;
 	pfvf_ops->enable_vf2pf_interrupts = adf_gen2_enable_vf2pf_interrupts;
 	pfvf_ops->disable_vf2pf_interrupts = adf_gen2_disable_vf2pf_interrupts;
+	pfvf_ops->send_msg = adf_gen2_pfvf_send;
 }
 EXPORT_SYMBOL_GPL(adf_gen2_init_pf_pfvf_ops);
 
@@ -78,5 +173,6 @@ void adf_gen2_init_vf_pfvf_ops(struct adf_pfvf_ops *pfvf_ops)
 	pfvf_ops->enable_comms = adf_enable_vf2pf_comms;
 	pfvf_ops->get_pf2vf_offset = adf_gen2_vf_get_pfvf_offset;
 	pfvf_ops->get_vf2pf_offset = adf_gen2_vf_get_pfvf_offset;
+	pfvf_ops->send_msg = adf_gen2_pfvf_send;
 }
 EXPORT_SYMBOL_GPL(adf_gen2_init_vf_pfvf_ops);
diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index c420ec03081b..074e521ed9e8 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
 /* Copyright(c) 2015 - 2020 Intel Corporation */
-#include <linux/delay.h>
 #include "adf_accel_devices.h"
 #include "adf_common_drv.h"
 #include "adf_pf2vf_msg.h"
@@ -8,97 +7,10 @@
 #define ADF_PFVF_MSG_COLLISION_DETECT_DELAY	10
 #define ADF_PFVF_MSG_ACK_DELAY			2
 #define ADF_PFVF_MSG_ACK_MAX_RETRY		100
-#define ADF_PFVF_MSG_RETRY_DELAY		5
-#define ADF_PFVF_MSG_MAX_RETRIES		3
 #define ADF_PFVF_MSG_RESP_TIMEOUT	(ADF_PFVF_MSG_ACK_DELAY * \
 					 ADF_PFVF_MSG_ACK_MAX_RETRY + \
 					 ADF_PFVF_MSG_COLLISION_DETECT_DELAY)
 
-static int adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
-{
-	struct adf_accel_pci *pci_info = &accel_dev->accel_pci_dev;
-	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	void __iomem *pmisc_bar_addr =
-		pci_info->pci_bars[hw_data->get_misc_bar_id(hw_data)].virt_addr;
-	u32 val, pf2vf_offset, count = 0;
-	u32 local_in_use_mask, local_in_use_pattern;
-	u32 remote_in_use_mask, remote_in_use_pattern;
-	struct mutex *lock;	/* lock preventing concurrent acces of CSR */
-	unsigned int retries = ADF_PFVF_MSG_MAX_RETRIES;
-	u32 int_bit;
-	int ret;
-
-	if (accel_dev->is_vf) {
-		pf2vf_offset = hw_data->pfvf_ops.get_vf2pf_offset(0);
-		lock = &accel_dev->vf.vf2pf_lock;
-		local_in_use_mask = ADF_VF2PF_IN_USE_BY_VF_MASK;
-		local_in_use_pattern = ADF_VF2PF_IN_USE_BY_VF;
-		remote_in_use_mask = ADF_PF2VF_IN_USE_BY_PF_MASK;
-		remote_in_use_pattern = ADF_PF2VF_IN_USE_BY_PF;
-		int_bit = ADF_VF2PF_INT;
-	} else {
-		pf2vf_offset = hw_data->pfvf_ops.get_pf2vf_offset(vf_nr);
-		lock = &accel_dev->pf.vf_info[vf_nr].pf2vf_lock;
-		local_in_use_mask = ADF_PF2VF_IN_USE_BY_PF_MASK;
-		local_in_use_pattern = ADF_PF2VF_IN_USE_BY_PF;
-		remote_in_use_mask = ADF_VF2PF_IN_USE_BY_VF_MASK;
-		remote_in_use_pattern = ADF_VF2PF_IN_USE_BY_VF;
-		int_bit = ADF_PF2VF_INT;
-	}
-
-	msg &= ~local_in_use_mask;
-	msg |= local_in_use_pattern;
-
-	mutex_lock(lock);
-
-start:
-	ret = 0;
-
-	/* Check if the PFVF CSR is in use by remote function */
-	val = ADF_CSR_RD(pmisc_bar_addr, pf2vf_offset);
-	if ((val & remote_in_use_mask) == remote_in_use_pattern) {
-		dev_dbg(&GET_DEV(accel_dev),
-			"PFVF CSR in use by remote function\n");
-		goto retry;
-	}
-
-	/* Attempt to get ownership of the PFVF CSR */
-	ADF_CSR_WR(pmisc_bar_addr, pf2vf_offset, msg | int_bit);
-
-	/* Wait for confirmation from remote func it received the message */
-	do {
-		msleep(ADF_PFVF_MSG_ACK_DELAY);
-		val = ADF_CSR_RD(pmisc_bar_addr, pf2vf_offset);
-	} while ((val & int_bit) && (count++ < ADF_PFVF_MSG_ACK_MAX_RETRY));
-
-	if (val & int_bit) {
-		dev_dbg(&GET_DEV(accel_dev), "ACK not received from remote\n");
-		val &= ~int_bit;
-		ret = -EIO;
-	}
-
-	if (val != msg) {
-		dev_dbg(&GET_DEV(accel_dev),
-			"Collision - PFVF CSR overwritten by remote function\n");
-		goto retry;
-	}
-
-	/* Finished with the PFVF CSR; relinquish it and leave msg in CSR */
-	ADF_CSR_WR(pmisc_bar_addr, pf2vf_offset, val & ~local_in_use_mask);
-out:
-	mutex_unlock(lock);
-	return ret;
-
-retry:
-	if (--retries) {
-		msleep(ADF_PFVF_MSG_RETRY_DELAY);
-		goto start;
-	} else {
-		ret = -EBUSY;
-		goto out;
-	}
-}
-
 /**
  * adf_send_pf2vf_msg() - send PF to VF message
  * @accel_dev:	Pointer to acceleration device
@@ -111,7 +23,7 @@ static int adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
  */
 static int adf_send_pf2vf_msg(struct adf_accel_dev *accel_dev, u8 vf_nr, u32 msg)
 {
-	return adf_iov_putmsg(accel_dev, msg, vf_nr);
+	return GET_PFVF_OPS(accel_dev)->send_msg(accel_dev, msg, vf_nr);
 }
 
 /**
@@ -125,7 +37,7 @@ static int adf_send_pf2vf_msg(struct adf_accel_dev *accel_dev, u8 vf_nr, u32 msg
  */
 int adf_send_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 msg)
 {
-	return adf_iov_putmsg(accel_dev, msg, 0);
+	return GET_PFVF_OPS(accel_dev)->send_msg(accel_dev, msg, 0);
 }
 
 /**
diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.h b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.h
index a7d8f8367345..73eb8f13ad09 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.h
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.h
@@ -49,7 +49,8 @@
  *
  * When a PF or VF attempts to send a message in the lower or upper 16 bits,
  * respectively, the other 16 bits are written to first with a defined
- * IN_USE_BY pattern as part of a collision control scheme (see adf_iov_putmsg).
+ * IN_USE_BY pattern as part of a collision control scheme (see function
+ * adf_gen2_pfvf_send() in adf_pf2vf_msg.c).
  */
 
 #define ADF_PFVF_COMPAT_THIS_VERSION		0x1	/* PF<->VF compat */
-- 
2.33.1

