From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] Reduced reqsize in qat_algs
Date: Tue, 19 Jan 2016 17:34:04 +0000
Message-ID: <1453224844-426-1-git-send-email-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, tadeusz.struk@intel.com,
	"Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:61359 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932414AbcASReJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Jan 2016 12:34:09 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Cabiddu, Giovanni <giovanni.cabiddu@intel.com>

req_alloc functions already take into account the request data structure
when allocating memory.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 59e4c3af..1e8852a8 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -1064,8 +1064,7 @@ static int qat_alg_aead_init(struct crypto_aead *tfm,
 	if (IS_ERR(ctx->hash_tfm))
 		return PTR_ERR(ctx->hash_tfm);
 	ctx->qat_hash_alg = hash;
-	crypto_aead_set_reqsize(tfm, sizeof(struct aead_request) +
-				     sizeof(struct qat_crypto_request));
+	crypto_aead_set_reqsize(tfm, sizeof(struct qat_crypto_request));
 	return 0;
 }
 
@@ -1114,8 +1113,7 @@ static int qat_alg_ablkcipher_init(struct crypto_tfm *tfm)
 	struct qat_alg_ablkcipher_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	spin_lock_init(&ctx->lock);
-	tfm->crt_ablkcipher.reqsize = sizeof(struct ablkcipher_request) +
-					sizeof(struct qat_crypto_request);
+	tfm->crt_ablkcipher.reqsize = sizeof(struct qat_crypto_request);
 	ctx->tfm = tfm;
 	return 0;
 }
-- 
1.7.4.1
