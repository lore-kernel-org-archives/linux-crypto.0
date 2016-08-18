From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - fix aes-xts key sizes
Date: Thu, 18 Aug 2016 19:53:36 +0100
Message-ID: <1471546416-7164-1-git-send-email-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:18421 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754362AbcHSBdE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Aug 2016 21:33:04 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Increase value of supported key sizes for qat_aes_xts.
aes-xts keys consists of keys of equal size concatenated.

Reported-by: Wenqian Yu <wenqian.yu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 769148d..20f35df 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -1260,8 +1260,8 @@ static struct crypto_alg qat_algs[] = { {
 			.setkey = qat_alg_ablkcipher_xts_setkey,
 			.decrypt = qat_alg_ablkcipher_decrypt,
 			.encrypt = qat_alg_ablkcipher_encrypt,
-			.min_keysize = AES_MIN_KEY_SIZE,
-			.max_keysize = AES_MAX_KEY_SIZE,
+			.min_keysize = 2 * AES_MIN_KEY_SIZE,
+			.max_keysize = 2 * AES_MAX_KEY_SIZE,
 			.ivsize = AES_BLOCK_SIZE,
 		},
 	},
-- 
1.7.4.1
