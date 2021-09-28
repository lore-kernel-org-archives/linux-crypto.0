Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75647C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 11:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A748610E6
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 11:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240392AbhI1Lqf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Sep 2021 07:46:35 -0400
Received: from mga07.intel.com ([134.134.136.100]:37909 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240395AbhI1Lqe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Sep 2021 07:46:34 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10120"; a="288339047"
X-IronPort-AV: E=Sophos;i="5.85,329,1624345200"; 
   d="scan'208";a="288339047"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 04:44:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,329,1624345200"; 
   d="scan'208";a="562224649"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga002.fm.intel.com with ESMTP; 28 Sep 2021 04:44:53 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 03/12] crypto: qat - remove unnecessary collision prevention step in PFVF
Date:   Tue, 28 Sep 2021 12:44:31 +0100
Message-Id: <20210928114440.355368-4-giovanni.cabiddu@intel.com>
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

The initial version of the PFVF protocol included an initial "carrier
sensing" to get ownership of the channel.

Collisions can happen anyway, the extra wait and test does not prevent
collisions, it instead slows the communication down, so remove it.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 20 +------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index 5a41beb8f20f..d3f6ff68d45d 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -126,28 +126,10 @@ static int __adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 		goto out;
 	}
 
-	/* Attempt to get ownership of PF2VF CSR */
 	msg &= ~local_in_use_mask;
 	msg |= local_in_use_pattern;
-	ADF_CSR_WR(pmisc_bar_addr, pf2vf_offset, msg);
 
-	/* Wait in case remote func also attempting to get ownership */
-	msleep(ADF_IOV_MSG_COLLISION_DETECT_DELAY);
-
-	val = ADF_CSR_RD(pmisc_bar_addr, pf2vf_offset);
-	if ((val & local_in_use_mask) != local_in_use_pattern) {
-		dev_dbg(&GET_DEV(accel_dev),
-			"PF2VF CSR in use by remote - collision detected\n");
-		ret = -EBUSY;
-		goto out;
-	}
-
-	/*
-	 * This function now owns the PV2VF CSR.  The IN_USE_BY pattern must
-	 * remain in the PF2VF CSR for all writes including ACK from remote
-	 * until this local function relinquishes the CSR.  Send the message
-	 * by interrupting the remote.
-	 */
+	/* Attempt to get ownership of the PF2VF CSR */
 	ADF_CSR_WR(pmisc_bar_addr, pf2vf_offset, msg | int_bit);
 
 	/* Wait for confirmation from remote func it received the message */
-- 
2.31.1

