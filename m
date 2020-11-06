Return-Path: <SRS0=5ZxX=EM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 457B0C55179
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:28:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFC99206C1
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:28:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbgKFL2h (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Nov 2020 06:28:37 -0500
Received: from mga07.intel.com ([134.134.136.100]:59373 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727170AbgKFL2h (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Nov 2020 06:28:37 -0500
IronPort-SDR: bLffMUXydhzrKm+YGZGH32YMDVib7kyCthhWSFC6gD6IerRQknFgXqRj3DiobiXeUOTOHgKd4D
 l+X9MDzPY7gg==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="233698279"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="233698279"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 03:28:36 -0800
IronPort-SDR: kpVVwjK6t7fECH3sQRjlsBmt7vOhdh4fZbWJPnNNUMgpZKTXGGvOfBrkDSFkDmi7vWyjQTQTKX
 lv0WFYS7FNKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="529779171"
Received: from haps801-neoncity02.sh.intel.com ([10.67.114.160])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2020 03:28:35 -0800
From:   Jack Xu <jack.xu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Jack Xu <jack.xu@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH 02/32] crypto: qat - loader: fix status check in qat_hal_put_rel_rd_xfer()
Date:   Fri,  6 Nov 2020 19:27:40 +0800
Message-Id: <20201106112810.2566-3-jack.xu@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201106112810.2566-1-jack.xu@intel.com>
References: <20201106112810.2566-1-jack.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The return value of qat_hal_rd_ae_csr() is always a CSR value and never
a status and should not be stored in the status variable of
qat_hal_put_rel_rd_xfer().

This removes the assignment as qat_hal_rd_ae_csr() is not expected to
fail.
A more comprehensive handling of the theoretical corner case which could
result in a fail will be submitted in a separate patch.

Fixes: 8c9478a400b7 ("crypto: qat - reduce stack size with KASAN")
Signed-off-by: Jack Xu <jack.xu@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
---
 drivers/crypto/qat/qat_common/qat_hal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index bc07199459e7..5da8475ed876 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -1149,7 +1149,7 @@ static int qat_hal_put_rel_rd_xfer(struct icp_qat_fw_loader_handle *handle,
 	unsigned short mask;
 	unsigned short dr_offset = 0x10;
 
-	status = ctx_enables = qat_hal_rd_ae_csr(handle, ae, CTX_ENABLES);
+	ctx_enables = qat_hal_rd_ae_csr(handle, ae, CTX_ENABLES);
 	if (CE_INUSE_CONTEXTS & ctx_enables) {
 		if (ctx & 0x1) {
 			pr_err("QAT: bad 4-ctx mode,ctx=0x%x\n", ctx);
-- 
2.25.4

