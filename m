Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FC4BC433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 12:04:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 287FE6322D
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 12:04:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbhKOMG5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 07:06:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:13629 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230170AbhKOMGo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 07:06:44 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10168"; a="233265516"
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="233265516"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 04:03:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="535486321"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga001.jf.intel.com with ESMTP; 15 Nov 2021 04:03:48 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        marco.chiappero@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 01/24] crypto: qat - fix undetected PFVF timeout in ACK loop
Date:   Mon, 15 Nov 2021 12:03:13 +0000
Message-Id: <20211115120336.22292-2-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115120336.22292-1-giovanni.cabiddu@intel.com>
References: <20211115120336.22292-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If the remote function did not ACK the reception of a message, the
function __adf_iov_putmsg() could detect it as a collision.

This was due to the fact that the collision and the timeout checks after
the ACK loop were in the wrong order. The timeout must be checked at the
end of the loop, so fix by swapping the order of the two checks.

Fixes: 9b768e8a3909 ("crypto: qat - detect PFVF collision after ACK")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Co-developed-by: Marco Chiappero <marco.chiappero@intel.com>
Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
---
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index 59860bdaedb6..99ee17c3d06b 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -107,6 +107,12 @@ static int __adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 		val = ADF_CSR_RD(pmisc_bar_addr, pf2vf_offset);
 	} while ((val & int_bit) && (count++ < ADF_PFVF_MSG_ACK_MAX_RETRY));
 
+	if (val & int_bit) {
+		dev_dbg(&GET_DEV(accel_dev), "ACK not received from remote\n");
+		val &= ~int_bit;
+		ret = -EIO;
+	}
+
 	if (val != msg) {
 		dev_dbg(&GET_DEV(accel_dev),
 			"Collision - PFVF CSR overwritten by remote function\n");
@@ -114,12 +120,6 @@ static int __adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 		goto out;
 	}
 
-	if (val & int_bit) {
-		dev_dbg(&GET_DEV(accel_dev), "ACK not received from remote\n");
-		val &= ~int_bit;
-		ret = -EIO;
-	}
-
 	/* Finished with the PFVF CSR; relinquish it and leave msg in CSR */
 	ADF_CSR_WR(pmisc_bar_addr, pf2vf_offset, val & ~local_in_use_mask);
 out:
-- 
2.33.1

