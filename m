From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 21/35] crypto: crypto4xx - Use crypto_ahash_set_reqsize
Date: Wed, 15 Jul 2009 15:16:15 +0800
Message-ID: <E1MQyit-00050g-4g@gondolin.me.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53641 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752649AbZGOHQS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:16:18 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyit-0004sv-MY
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:16:16 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: crypto4xx - Use crypto_ahash_set_reqsize

This patch makes crypto4xx use crypto_ahash_set_reqsize to avoid
accessing crypto_ahash directly.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/amcc/crypto4xx_alg.c  |    3 ++-
 drivers/crypto/amcc/crypto4xx_core.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_alg.c b/drivers/crypto/amcc/crypto4xx_alg.c
index 61b6e1b..a33243c 100644
--- a/drivers/crypto/amcc/crypto4xx_alg.c
+++ b/drivers/crypto/amcc/crypto4xx_alg.c
@@ -208,7 +208,8 @@ static int crypto4xx_hash_alg_init(struct crypto_tfm *tfm,
 		}
 	}
 
-	tfm->crt_ahash.reqsize = sizeof(struct crypto4xx_ctx);
+	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+				 sizeof(struct crypto4xx_ctx));
 	sa = (struct dynamic_sa_ctl *) ctx->sa_in;
 	set_dynamic_sa_command_0(sa, SA_SAVE_HASH, SA_NOT_SAVE_IV,
 				 SA_NOT_LOAD_HASH, SA_LOAD_IV_FROM_SA,
diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 4c0dfb2..cb7be42 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1001,7 +1001,8 @@ static int crypto4xx_alg_init(struct crypto_tfm *tfm)
 	if (alg->cra_type == &crypto_ablkcipher_type)
 		tfm->crt_ablkcipher.reqsize = sizeof(struct crypto4xx_ctx);
 	else if (alg->cra_type == &crypto_ahash_type)
-		tfm->crt_ahash.reqsize = sizeof(struct crypto4xx_ctx);
+		crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+					 sizeof(struct crypto4xx_ctx));
 
 	return 0;
 }
