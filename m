Return-Path: <SRS0=wtno=S7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 404CBC43219
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Apr 2019 15:44:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F25820675
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Apr 2019 15:44:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbfD2PoX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Apr 2019 11:44:23 -0400
Received: from mga14.intel.com ([192.55.52.115]:4157 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728438AbfD2PoX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Apr 2019 11:44:23 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Apr 2019 08:44:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,410,1549958400"; 
   d="scan'208";a="319990369"
Received: from silvixa00391824.ir.intel.com (HELO silvixa00391824.ger.corp.intel.com) ([10.237.222.24])
  by orsmga005.jf.intel.com with ESMTP; 29 Apr 2019 08:44:21 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Conor Mcloughlin <conor.mcloughlin@intel.com>,
        Sergey Portnoy <sergey.portnoy@intel.com>
Subject: [PATCH 4/7] crypto: qat - fix block size for aes ctr mode
Date:   Mon, 29 Apr 2019 16:43:18 +0100
Message-Id: <20190429154321.21098-4-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190429154321.21098-1-giovanni.cabiddu@intel.com>
References: <20190429154321.21098-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The block size for aes counter mode was improperly set to AES_BLOCK_SIZE.
This sets it to 1 as it is a stream cipher.

This problem was found with by the new extra run-time crypto self test.

Reviewed-by: Conor Mcloughlin <conor.mcloughlin@intel.com>
Tested-by: Sergey Portnoy <sergey.portnoy@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 6be3e7413beb..5ca5cf9f6be5 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -1273,7 +1273,7 @@ static struct crypto_alg qat_algs[] = { {
 	.cra_driver_name = "qat_aes_ctr",
 	.cra_priority = 4001,
 	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
-	.cra_blocksize = AES_BLOCK_SIZE,
+	.cra_blocksize = 1,
 	.cra_ctxsize = sizeof(struct qat_alg_ablkcipher_ctx),
 	.cra_alignmask = 0,
 	.cra_type = &crypto_ablkcipher_type,
-- 
2.20.1

