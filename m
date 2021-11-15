Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D14C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 12:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF4F761B53
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 12:04:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbhKOMHJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 07:07:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:13626 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230170AbhKOMG6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 07:06:58 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10168"; a="233265547"
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="233265547"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 04:04:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="535486379"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga001.jf.intel.com with ESMTP; 15 Nov 2021 04:04:01 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        marco.chiappero@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 09/24] crypto: qat - handle retries due to collisions in adf_iov_putmsg()
Date:   Mon, 15 Nov 2021 12:03:21 +0000
Message-Id: <20211115120336.22292-10-giovanni.cabiddu@intel.com>
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

Rework __adf_iov_putmsg() to handle retries due to collisions
internally, removing the need for an external retry loop.
The functions __adf_iov_putmsg() and adf_iov_putmsg() have been merged
together maintaining the adf_iov_putmsg() name.

This will allow to use this function only for GEN2 devices, since
collision are peculiar of this generation and therefore should be
confined to the actual implementation of the transport/medium access.

Note that now adf_iov_putmsg() will retry to send a message only in case
of collisions and will now fail if an ACK is not received from the
remote function.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 52 +++++++------------
 1 file changed, 19 insertions(+), 33 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index 201744825e23..d98e3639c9d2 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -14,7 +14,7 @@
 					 ADF_PFVF_MSG_ACK_MAX_RETRY + \
 					 ADF_PFVF_MSG_COLLISION_DETECT_DELAY)
 
-static int __adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
+static int adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 {
 	struct adf_accel_pci *pci_info = &accel_dev->accel_pci_dev;
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
@@ -24,8 +24,9 @@ static int __adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 	u32 local_in_use_mask, local_in_use_pattern;
 	u32 remote_in_use_mask, remote_in_use_pattern;
 	struct mutex *lock;	/* lock preventing concurrent acces of CSR */
+	unsigned int retries = ADF_PFVF_MSG_MAX_RETRIES;
 	u32 int_bit;
-	int ret = 0;
+	int ret;
 
 	if (accel_dev->is_vf) {
 		pf2vf_offset = hw_data->get_pf2vf_offset(0);
@@ -45,20 +46,22 @@ static int __adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 		int_bit = ADF_PF2VF_INT;
 	}
 
+	msg &= ~local_in_use_mask;
+	msg |= local_in_use_pattern;
+
 	mutex_lock(lock);
 
+start:
+	ret = 0;
+
 	/* Check if the PFVF CSR is in use by remote function */
 	val = ADF_CSR_RD(pmisc_bar_addr, pf2vf_offset);
 	if ((val & remote_in_use_mask) == remote_in_use_pattern) {
 		dev_dbg(&GET_DEV(accel_dev),
 			"PFVF CSR in use by remote function\n");
-		ret = -EBUSY;
-		goto out;
+		goto retry;
 	}
 
-	msg &= ~local_in_use_mask;
-	msg |= local_in_use_pattern;
-
 	/* Attempt to get ownership of the PFVF CSR */
 	ADF_CSR_WR(pmisc_bar_addr, pf2vf_offset, msg | int_bit);
 
@@ -77,8 +80,7 @@ static int __adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 	if (val != msg) {
 		dev_dbg(&GET_DEV(accel_dev),
 			"Collision - PFVF CSR overwritten by remote function\n");
-		ret = -EIO;
-		goto out;
+		goto retry;
 	}
 
 	/* Finished with the PFVF CSR; relinquish it and leave msg in CSR */
@@ -86,31 +88,15 @@ static int __adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 out:
 	mutex_unlock(lock);
 	return ret;
-}
 
-/**
- * adf_iov_putmsg() - send PFVF message
- * @accel_dev:  Pointer to acceleration device.
- * @msg:	Message to send
- * @vf_nr:	VF number to which the message will be sent if on PF, ignored
- *		otherwise
- *
- * Function sends a message through the PFVF channel
- *
- * Return: 0 on success, error code otherwise.
- */
-static int adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
-{
-	u32 count = 0;
-	int ret;
-
-	do {
-		ret = __adf_iov_putmsg(accel_dev, msg, vf_nr);
-		if (ret)
-			msleep(ADF_PFVF_MSG_RETRY_DELAY);
-	} while (ret && (count++ < ADF_PFVF_MSG_MAX_RETRIES));
-
-	return ret;
+retry:
+	if (--retries) {
+		msleep(ADF_PFVF_MSG_RETRY_DELAY);
+		goto start;
+	} else {
+		ret = -EBUSY;
+		goto out;
+	}
 }
 
 /**
-- 
2.33.1

