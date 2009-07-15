From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 35/35] crypto: crypto4xx - Disable SHA implementation
Date: Wed, 15 Jul 2009 15:16:30 +0800
Message-ID: <E1MQyj8-00052n-8j@gondolin.me.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:48343 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752915AbZGOHgb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:36:31 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyj8-0004x8-JQ
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:16:30 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: crypto4xx - Disable SHA implementation

The crypto4xx SHA implementation keeps the hash state in the tfm
data structure.  This breaks a fundamental requirement of ahash
implementations that they must be reentrant.

This patch disables the broken implementation.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/amcc/crypto4xx_core.c |   19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 857e35e..46e899a 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1144,25 +1144,6 @@ struct crypto4xx_alg_common crypto4xx_alg[] = {
 			}
 		}
 	}},
-	/* Hash SHA1 */
-	{ .type = CRYPTO_ALG_TYPE_AHASH, .u.hash = {
-		.init		= crypto4xx_hash_init,
-		.update		= crypto4xx_hash_update,
-		.final  	= crypto4xx_hash_final,
-		.digest 	= crypto4xx_hash_digest,
-		.halg.digestsize = SHA1_DIGEST_SIZE,
-		.halg.base	= {
-			.cra_name	= "sha1",
-			.cra_driver_name = "sha1-ppc4xx",
-			.cra_priority	= CRYPTO4XX_CRYPTO_PRIORITY,
-			.cra_flags	= CRYPTO_ALG_ASYNC,
-			.cra_blocksize	= SHA1_BLOCK_SIZE,
-			.cra_ctxsize	= sizeof(struct crypto4xx_ctx),
-			.cra_init	= crypto4xx_sha1_alg_init,
-			.cra_exit	= crypto4xx_alg_exit,
-			.cra_module	= THIS_MODULE,
-		}
-	}},
 };
 
 /**
