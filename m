Return-Path: <SRS0=qXKu=AK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 034B1C433E2
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 19:47:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4AEA2082F
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 19:47:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387740AbgF2TrT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:47:19 -0400
Received: from mga07.intel.com ([134.134.136.100]:58002 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729186AbgF2Tkj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:39 -0400
IronPort-SDR: A6Bn3OQW34lPnp8Bxx/SggFnEXro7lizrJYelmriwhB9+Sae4dtSd69DO68ECtewelFrjBNo5x
 PV/7JMBYbJSA==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="211091665"
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="211091665"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 10:16:36 -0700
IronPort-SDR: Bg4ZnOgQnlQj1ydFOYVZOeUJjmGEpBDb3BmrJMB2qJil8riUrHB63GrxzQIufUp3KBJ9DQErsP
 ykRTWNmNgjow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="264891337"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga007.fm.intel.com with ESMTP; 29 Jun 2020 10:16:35 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v3 1/4] crypto: qat - allow xts requests not multiple of block
Date:   Mon, 29 Jun 2020 18:16:17 +0100
Message-Id: <20200629171620.2989-2-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200629171620.2989-1-giovanni.cabiddu@intel.com>
References: <20200629171620.2989-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Allow AES-XTS requests that are not multiple of the block size.
If a request is smaller than the block size, return -EINVAL.

This fixes the following issue reported by the crypto testmgr self-test:

  alg: skcipher: qat_aes_xts encryption failed on test vector "random: len=116 klen=64"; expected_error=0, actual_error=-22, cfg="random: inplace may_sleep use_finup src_divs=[<reimport>45.85%@+4077, <flush>54.15%@alignmask+18]"

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

