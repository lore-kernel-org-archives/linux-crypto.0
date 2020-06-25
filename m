Return-Path: <SRS0=hy52=AG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8F42C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jun 2020 12:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3607206C3
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jun 2020 12:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404849AbgFYM70 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Jun 2020 08:59:26 -0400
Received: from mga04.intel.com ([192.55.52.120]:8441 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404845AbgFYM7Z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Jun 2020 08:59:25 -0400
IronPort-SDR: 8dkTcGN2cuPi5L2JbSyE8QxejyxaArGJtl6ixyRwifHWHZZHn5Yado7IfJNhoVtbM7hBMrTxvg
 ohO2Tko+Jg6A==
X-IronPort-AV: E=McAfee;i="6000,8403,9662"; a="142362230"
X-IronPort-AV: E=Sophos;i="5.75,279,1589266800"; 
   d="scan'208";a="142362230"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2020 05:59:25 -0700
IronPort-SDR: pwUsEcq/QHSC79Qy4GmC0YE2XC+IDap+A7LZOwwSqtwpyOm/dxTyI6do2qIH1p9QtZg+w9ze9X
 8zDsrz9dG4wQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,279,1589266800"; 
   d="scan'208";a="301979111"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga004.fm.intel.com with ESMTP; 25 Jun 2020 05:59:24 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 1/4] crypto: qat - allow xts requests not multiple of block
Date:   Thu, 25 Jun 2020 13:59:01 +0100
Message-Id: <20200625125904.142840-2-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200625125904.142840-1-giovanni.cabiddu@intel.com>
References: <20200625125904.142840-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Allow aes xts requests that are not multiple of the block size.
If a request is smaller than the block size, return -EINVAL.

This fixes the following issue reported by the crypto testmgr self-test:
alg: skcipher: qat_aes_xts encryption failed on test vector "random:
len=116 klen=64"; expected_error=0, actual_error=-22, cfg="random:
inplace may_sleep use_finup src_divs=[<reimport>45.85%@+4077,
<flush>54.15%@alignmask+18]"

Fixes: 96ee111a659e ("crypto: qat - return error for block...")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 833d1a75666f..6bea6f868395 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -11,6 +11,7 @@
 #include <crypto/hmac.h>
 #include <crypto/algapi.h>
 #include <crypto/authenc.h>
+#include <crypto/xts.h>
 #include <linux/dma-mapping.h>
 #include "adf_accel_devices.h"
 #include "adf_transport.h"
@@ -1058,6 +1059,14 @@ static int qat_alg_skcipher_blk_encrypt(struct skcipher_request *req)
 	return qat_alg_skcipher_encrypt(req);
 }
 
+static int qat_alg_skcipher_xts_encrypt(struct skcipher_request *req)
+{
+	if (req->cryptlen < XTS_BLOCK_SIZE)
+		return -EINVAL;
+
+	return qat_alg_skcipher_encrypt(req);
+}
+
 static int qat_alg_skcipher_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *stfm = crypto_skcipher_reqtfm(req);
@@ -1117,6 +1126,15 @@ static int qat_alg_skcipher_blk_decrypt(struct skcipher_request *req)
 
 	return qat_alg_skcipher_decrypt(req);
 }
+
+static int qat_alg_skcipher_xts_decrypt(struct skcipher_request *req)
+{
+	if (req->cryptlen < XTS_BLOCK_SIZE)
+		return -EINVAL;
+
+	return qat_alg_skcipher_decrypt(req);
+}
+
 static int qat_alg_aead_init(struct crypto_aead *tfm,
 			     enum icp_qat_hw_auth_algo hash,
 			     const char *hash_name)
@@ -1310,8 +1328,8 @@ static struct skcipher_alg qat_skciphers[] = { {
 	.init = qat_alg_skcipher_init_tfm,
 	.exit = qat_alg_skcipher_exit_tfm,
 	.setkey = qat_alg_skcipher_xts_setkey,
-	.decrypt = qat_alg_skcipher_blk_decrypt,
-	.encrypt = qat_alg_skcipher_blk_encrypt,
+	.decrypt = qat_alg_skcipher_xts_decrypt,
+	.encrypt = qat_alg_skcipher_xts_encrypt,
 	.min_keysize = 2 * AES_MIN_KEY_SIZE,
 	.max_keysize = 2 * AES_MAX_KEY_SIZE,
 	.ivsize = AES_BLOCK_SIZE,
-- 
2.26.2

