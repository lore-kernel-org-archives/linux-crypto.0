Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1FE0C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 11:45:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E9EF6113E
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 11:45:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240397AbhI1Lqn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Sep 2021 07:46:43 -0400
Received: from mga07.intel.com ([134.134.136.100]:37909 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240400AbhI1Lql (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Sep 2021 07:46:41 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10120"; a="288339062"
X-IronPort-AV: E=Sophos;i="5.85,329,1624345200"; 
   d="scan'208";a="288339062"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 04:45:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,329,1624345200"; 
   d="scan'208";a="562224772"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga002.fm.intel.com with ESMTP; 28 Sep 2021 04:45:00 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 07/12] crypto: qat - make pfvf send message direction agnostic
Date:   Tue, 28 Sep 2021 12:44:35 +0100
Message-Id: <20210928114440.355368-8-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210928114440.355368-1-giovanni.cabiddu@intel.com>
References: <20210928114440.355368-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Marco Chiappero <marco.chiappero@intel.com>

The functions adf_iov_putmsg() and __adf_iov_putmsg() are shared by both
PF and VF. Any logging or documentation should not refer to any specific
direction.

Make comments and log messages direction agnostic by replacing PF2VF
with PFVF. Also fix the wording for some related comments.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index cdef6c34524e..41f4b5643dbb 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -77,11 +77,11 @@ static int __adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 
 	mutex_lock(lock);
 
-	/* Check if PF2VF CSR is in use by remote function */
+	/* Check if the PFVF CSR is in use by remote function */
 	val = ADF_CSR_RD(pmisc_bar_addr, pf2vf_offset);
 	if ((val & remote_in_use_mask) == remote_in_use_pattern) {
 		dev_dbg(&GET_DEV(accel_dev),
-			"PF2VF CSR in use by remote function\n");
+			"PFVF CSR in use by remote function\n");
 		ret = -EBUSY;
 		goto out;
 	}
@@ -89,7 +89,7 @@ static int __adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 	msg &= ~local_in_use_mask;
 	msg |= local_in_use_pattern;
 
-	/* Attempt to get ownership of the PF2VF CSR */
+	/* Attempt to get ownership of the PFVF CSR */
 	ADF_CSR_WR(pmisc_bar_addr, pf2vf_offset, msg | int_bit);
 
 	/* Wait for confirmation from remote func it received the message */
@@ -111,7 +111,7 @@ static int __adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 		ret = -EIO;
 	}
 
-	/* Finished with PF2VF CSR; relinquish it and leave msg in CSR */
+	/* Finished with the PFVF CSR; relinquish it and leave msg in CSR */
 	ADF_CSR_WR(pmisc_bar_addr, pf2vf_offset, val & ~local_in_use_mask);
 out:
 	mutex_unlock(lock);
@@ -119,12 +119,13 @@ static int __adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 }
 
 /**
- * adf_iov_putmsg() - send PF2VF message
+ * adf_iov_putmsg() - send PFVF message
  * @accel_dev:  Pointer to acceleration device.
  * @msg:	Message to send
- * @vf_nr:	VF number to which the message will be sent
+ * @vf_nr:	VF number to which the message will be sent if on PF, ignored
+ *		otherwise
  *
- * Function sends a message from the PF to a VF
+ * Function sends a message through the PFVF channel
  *
  * Return: 0 on success, error code otherwise.
  */
-- 
2.31.1

