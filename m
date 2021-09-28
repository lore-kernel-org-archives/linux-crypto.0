Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8640EC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 11:44:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69626611C3
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 11:44:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240389AbhI1Lqb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Sep 2021 07:46:31 -0400
Received: from mga07.intel.com ([134.134.136.100]:37909 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231202AbhI1Lqb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Sep 2021 07:46:31 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10120"; a="288339033"
X-IronPort-AV: E=Sophos;i="5.85,329,1624345200"; 
   d="scan'208";a="288339033"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 04:44:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,329,1624345200"; 
   d="scan'208";a="562224612"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga002.fm.intel.com with ESMTP; 28 Sep 2021 04:44:50 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: [PATCH 01/12] crypto: qat - detect PFVF collision after ACK
Date:   Tue, 28 Sep 2021 12:44:29 +0100
Message-Id: <20210928114440.355368-2-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210928114440.355368-1-giovanni.cabiddu@intel.com>
References: <20210928114440.355368-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Detect a PFVF collision between the local and the remote function by
checking if the message on the PFVF CSR has been overwritten.
This is done after the remote function confirms that the message has
been received, by clearing the interrupt bit, or the maximum number of
attempts (ADF_IOV_MSG_ACK_MAX_RETRY) to check the CSR has been exceeded.

Fixes: ed8ccaef52fa ("crypto: qat - Add support for SRIOV")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Co-developed-by: Marco Chiappero <marco.chiappero@intel.com>
Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
---
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index 976b9ab7617c..789a4135e28c 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -156,6 +156,13 @@ static int __adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 		val = ADF_CSR_RD(pmisc_bar_addr, pf2vf_offset);
 	} while ((val & int_bit) && (count++ < ADF_IOV_MSG_ACK_MAX_RETRY));
 
+	if (val != msg) {
+		dev_dbg(&GET_DEV(accel_dev),
+			"Collision - PFVF CSR overwritten by remote function\n");
+		ret = -EIO;
+		goto out;
+	}
+
 	if (val & int_bit) {
 		dev_dbg(&GET_DEV(accel_dev), "ACK not received from remote\n");
 		val &= ~int_bit;
-- 
2.31.1

