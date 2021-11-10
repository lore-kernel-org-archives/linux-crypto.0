Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6971DC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 20:52:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 554B4611F2
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 20:52:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233116AbhKJUzk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Nov 2021 15:55:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:55794 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233137AbhKJUzh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Nov 2021 15:55:37 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10164"; a="232611237"
X-IronPort-AV: E=Sophos;i="5.87,224,1631602800"; 
   d="scan'208";a="232611237"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 12:52:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,224,1631602800"; 
   d="scan'208";a="642663251"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga001.fm.intel.com with ESMTP; 10 Nov 2021 12:52:46 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        marco.chiappero@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 16/24] crypto: qat - abstract PFVF receive logic
Date:   Wed, 10 Nov 2021 20:52:09 +0000
Message-Id: <20211110205217.99903-17-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110205217.99903-1-giovanni.cabiddu@intel.com>
References: <20211110205217.99903-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Refactor the PFVF receive logic so it is common between PF and VF and
make it device specific.

This is in preparation for the introduction of PFVF support in the
qat_4xxx driver since the receive logic differs between QAT GEN2 and
QAT GEN4 devices.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Co-developed-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
---
 .../crypto/qat/qat_common/adf_accel_devices.h |  1 +
 drivers/crypto/qat/qat_common/adf_gen2_pfvf.c | 45 +++++++++++++++++++
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 41 ++++++++---------
 drivers/crypto/qat/qat_common/adf_vf2pf_msg.c | 38 +++++++---------
 4 files changed, 81 insertions(+), 44 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index d797f109cc36..a99800e51343 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -155,6 +155,7 @@ struct adf_pfvf_ops {
 	void (*enable_vf2pf_interrupts)(void __iomem *pmisc_bar_addr, u32 vf_mask);
 	void (*disable_vf2pf_interrupts)(void __iomem *pmisc_bar_addr, u32 vf_mask);
 	int (*send_msg)(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr);
+	u32 (*recv_msg)(struct adf_accel_dev *accel_dev, u8 vf_nr);
 };
 
 struct adf_hw_device_data {
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
index cb883cc8e45a..01dabac9ba28 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
+++ b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
@@ -156,6 +156,49 @@ static int adf_gen2_pfvf_send(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr
 	}
 }
 
+static u32 adf_gen2_pfvf_recv(struct adf_accel_dev *accel_dev, u8 vf_nr)
+{
+	struct adf_accel_pci *pci_info = &accel_dev->accel_pci_dev;
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	void __iomem *pmisc_addr =
+		pci_info->pci_bars[hw_data->get_misc_bar_id(hw_data)].virt_addr;
+	u32 pfvf_offset;
+	u32 msg_origin;
+	u32 int_bit;
+	u32 msg;
+
+	if (accel_dev->is_vf) {
+		pfvf_offset = GET_PFVF_OPS(accel_dev)->get_pf2vf_offset(0);
+		int_bit = ADF_PF2VF_INT;
+		msg_origin = ADF_PF2VF_MSGORIGIN_SYSTEM;
+	} else {
+		pfvf_offset = GET_PFVF_OPS(accel_dev)->get_vf2pf_offset(vf_nr);
+		int_bit = ADF_VF2PF_INT;
+		msg_origin = ADF_VF2PF_MSGORIGIN_SYSTEM;
+	}
+
+	/* Read message */
+	msg = ADF_CSR_RD(pmisc_addr, pfvf_offset);
+	if (!(msg & int_bit)) {
+		dev_info(&GET_DEV(accel_dev),
+			 "Spurious PFVF interrupt, msg %X. Ignored\n", msg);
+		return 0;
+	}
+
+	/* Ignore legacy non-system (non-kernel) VF2PF messages */
+	if (!(msg & msg_origin)) {
+		dev_dbg(&GET_DEV(accel_dev),
+			"Ignored non-system message (0x%x);\n", msg);
+		return 0;
+	}
+
+	/* To ACK, clear the INT bit */
+	msg &= ~int_bit;
+	ADF_CSR_WR(pmisc_addr, pfvf_offset, msg);
+
+	return msg;
+}
+
 void adf_gen2_init_pf_pfvf_ops(struct adf_pfvf_ops *pfvf_ops)
 {
 	pfvf_ops->enable_comms = adf_enable_pf2vf_comms;
@@ -165,6 +208,7 @@ void adf_gen2_init_pf_pfvf_ops(struct adf_pfvf_ops *pfvf_ops)
 	pfvf_ops->enable_vf2pf_interrupts = adf_gen2_enable_vf2pf_interrupts;
 	pfvf_ops->disable_vf2pf_interrupts = adf_gen2_disable_vf2pf_interrupts;
 	pfvf_ops->send_msg = adf_gen2_pfvf_send;
+	pfvf_ops->recv_msg = adf_gen2_pfvf_recv;
 }
 EXPORT_SYMBOL_GPL(adf_gen2_init_pf_pfvf_ops);
 
@@ -174,5 +218,6 @@ void adf_gen2_init_vf_pfvf_ops(struct adf_pfvf_ops *pfvf_ops)
 	pfvf_ops->get_pf2vf_offset = adf_gen2_vf_get_pfvf_offset;
 	pfvf_ops->get_vf2pf_offset = adf_gen2_vf_get_pfvf_offset;
 	pfvf_ops->send_msg = adf_gen2_pfvf_send;
+	pfvf_ops->recv_msg = adf_gen2_pfvf_recv;
 }
 EXPORT_SYMBOL_GPL(adf_gen2_init_vf_pfvf_ops);
diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index 074e521ed9e8..c064e8bab50d 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -40,6 +40,20 @@ int adf_send_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 msg)
 	return GET_PFVF_OPS(accel_dev)->send_msg(accel_dev, msg, 0);
 }
 
+/**
+ * adf_recv_vf2pf_msg() - receive a VF to PF message
+ * @accel_dev:	Pointer to acceleration device
+ * @vf_nr:	Number of the VF from where the message will be received
+ *
+ * This function allows the PF to receive a message from a specific VF.
+ *
+ * Return: a valid message on success, zero otherwise.
+ */
+static u32 adf_recv_vf2pf_msg(struct adf_accel_dev *accel_dev, u8 vf_nr)
+{
+	return GET_PFVF_OPS(accel_dev)->recv_msg(accel_dev, vf_nr);
+}
+
 /**
  * adf_send_vf2pf_req() - send VF2PF request message
  * @accel_dev:	Pointer to acceleration device.
@@ -163,31 +177,12 @@ static int adf_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr,
 
 bool adf_recv_and_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr)
 {
-	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	int bar_id = hw_data->get_misc_bar_id(hw_data);
-	struct adf_bar *pmisc = &GET_BARS(accel_dev)[bar_id];
-	void __iomem *pmisc_addr = pmisc->virt_addr;
-	u32 msg, resp = 0;
-
-	/* Read message from the VF */
-	msg = ADF_CSR_RD(pmisc_addr, hw_data->pfvf_ops.get_vf2pf_offset(vf_nr));
-	if (!(msg & ADF_VF2PF_INT)) {
-		dev_info(&GET_DEV(accel_dev),
-			 "Spurious VF2PF interrupt, msg %X. Ignored\n", msg);
-		return true;
-	}
+	u32 resp = 0;
+	u32 msg;
 
-	/* Ignore legacy non-system (non-kernel) VF2PF messages */
-	if (!(msg & ADF_VF2PF_MSGORIGIN_SYSTEM)) {
-		dev_dbg(&GET_DEV(accel_dev),
-			"Ignored non-system message from VF%d (0x%x);\n",
-			vf_nr + 1, msg);
+	msg = adf_recv_vf2pf_msg(accel_dev, vf_nr);
+	if (!msg)
 		return true;
-	}
-
-	/* To ACK, clear the VF2PFINT bit */
-	msg &= ~ADF_VF2PF_INT;
-	ADF_CSR_WR(pmisc_addr, hw_data->pfvf_ops.get_vf2pf_offset(vf_nr), msg);
 
 	if (adf_handle_vf2pf_msg(accel_dev, vf_nr, msg, &resp))
 		return false;
diff --git a/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c b/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
index d11eb60b3e86..f3660981ad6a 100644
--- a/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
@@ -47,6 +47,19 @@ void adf_vf2pf_notify_shutdown(struct adf_accel_dev *accel_dev)
 }
 EXPORT_SYMBOL_GPL(adf_vf2pf_notify_shutdown);
 
+/**
+ * adf_recv_pf2vf_msg() - receive a PF to VF message
+ * @accel_dev:	Pointer to acceleration device
+ *
+ * This function allows the VF to receive a message from the PF.
+ *
+ * Return: a valid message on success, zero otherwise.
+ */
+static u32 adf_recv_pf2vf_msg(struct adf_accel_dev *accel_dev)
+{
+	return GET_PFVF_OPS(accel_dev)->recv_msg(accel_dev, 0);
+}
+
 static bool adf_handle_pf2vf_msg(struct adf_accel_dev *accel_dev, u32 msg)
 {
 	switch ((msg & ADF_PF2VF_MSGTYPE_MASK) >> ADF_PF2VF_MSGTYPE_SHIFT) {
@@ -77,28 +90,11 @@ static bool adf_handle_pf2vf_msg(struct adf_accel_dev *accel_dev, u32 msg)
 
 bool adf_recv_and_handle_pf2vf_msg(struct adf_accel_dev *accel_dev)
 {
-	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	struct adf_bar *pmisc =
-			&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
-	void __iomem *pmisc_bar_addr = pmisc->virt_addr;
-	u32 offset = hw_data->pfvf_ops.get_pf2vf_offset(0);
 	u32 msg;
 
-	/* Read the message from PF */
-	msg = ADF_CSR_RD(pmisc_bar_addr, offset);
-	if (!(msg & ADF_PF2VF_INT)) {
-		dev_info(&GET_DEV(accel_dev),
-			 "Spurious PF2VF interrupt, msg %X. Ignored\n", msg);
-		return true;
-	}
-
-	if (!(msg & ADF_PF2VF_MSGORIGIN_SYSTEM))
-		/* Ignore legacy non-system (non-kernel) PF2VF messages */
-		return true;
-
-	/* To ack, clear the PF2VFINT bit */
-	msg &= ~ADF_PF2VF_INT;
-	ADF_CSR_WR(pmisc_bar_addr, offset, msg);
+	msg = adf_recv_pf2vf_msg(accel_dev);
+	if (msg)
+		return adf_handle_pf2vf_msg(accel_dev, msg);
 
-	return adf_handle_pf2vf_msg(accel_dev, msg);
+	return true;
 }
-- 
2.33.1

