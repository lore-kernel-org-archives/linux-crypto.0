From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 29/35] crypto: crypto4xx - Switch to new style ahash
Date: Wed, 15 Jul 2009 15:16:23 +0800
Message-ID: <E1MQyj1-00051v-PT@gondolin.me.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:48355 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752948AbZGOHgo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:36:44 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyj3-0004vK-A1
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:16:26 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: crypto4xx - Switch to new style ahash

This patch changes crypto4xx to use the new style ahash type.
In particular, we now use ahash_alg to define ahash algorithms
instead of crypto_alg.

This is achieved by introducing a union that encapsulates the
new type and the existing crypto_alg structure.  They're told
apart through a u32 field containing the type value.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/amcc/crypto4xx_core.c |   85 ++++++++++++++++++++---------------
 drivers/crypto/amcc/crypto4xx_core.h |   25 +++++++++-
 include/crypto/internal/hash.h       |    6 ++
 3 files changed, 77 insertions(+), 39 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index cb7be42..857e35e 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -31,8 +31,6 @@
 #include <asm/dcr.h>
 #include <asm/dcr-regs.h>
 #include <asm/cacheflush.h>
-#include <crypto/internal/hash.h>
-#include <crypto/algapi.h>
 #include <crypto/aes.h>
 #include <crypto/sha.h>
 #include "crypto4xx_reg_def.h"
@@ -998,11 +996,15 @@ static int crypto4xx_alg_init(struct crypto_tfm *tfm)
 	ctx->sa_out_dma_addr = 0;
 	ctx->sa_len = 0;
 
-	if (alg->cra_type == &crypto_ablkcipher_type)
+	switch (alg->cra_flags & CRYPTO_ALG_TYPE_MASK) {
+	default:
 		tfm->crt_ablkcipher.reqsize = sizeof(struct crypto4xx_ctx);
-	else if (alg->cra_type == &crypto_ahash_type)
+		break;
+	case CRYPTO_ALG_TYPE_AHASH:
 		crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
 					 sizeof(struct crypto4xx_ctx));
+		break;
+	}
 
 	return 0;
 }
@@ -1016,7 +1018,8 @@ static void crypto4xx_alg_exit(struct crypto_tfm *tfm)
 }
 
 int crypto4xx_register_alg(struct crypto4xx_device *sec_dev,
-			   struct crypto_alg *crypto_alg, int array_size)
+			   struct crypto4xx_alg_common *crypto_alg,
+			   int array_size)
 {
 	struct crypto4xx_alg *alg;
 	int i;
@@ -1028,13 +1031,18 @@ int crypto4xx_register_alg(struct crypto4xx_device *sec_dev,
 			return -ENOMEM;
 
 		alg->alg = crypto_alg[i];
-		INIT_LIST_HEAD(&alg->alg.cra_list);
-		if (alg->alg.cra_init == NULL)
-			alg->alg.cra_init = crypto4xx_alg_init;
-		if (alg->alg.cra_exit == NULL)
-			alg->alg.cra_exit = crypto4xx_alg_exit;
 		alg->dev = sec_dev;
-		rc = crypto_register_alg(&alg->alg);
+
+		switch (alg->alg.type) {
+		case CRYPTO_ALG_TYPE_AHASH:
+			rc = crypto_register_ahash(&alg->alg.u.hash);
+			break;
+
+		default:
+			rc = crypto_register_alg(&alg->alg.u.cipher);
+			break;
+		}
+
 		if (rc) {
 			list_del(&alg->entry);
 			kfree(alg);
@@ -1052,7 +1060,14 @@ static void crypto4xx_unregister_alg(struct crypto4xx_device *sec_dev)
 
 	list_for_each_entry_safe(alg, tmp, &sec_dev->alg_list, entry) {
 		list_del(&alg->entry);
-		crypto_unregister_alg(&alg->alg);
+		switch (alg->alg.type) {
+		case CRYPTO_ALG_TYPE_AHASH:
+			crypto_unregister_ahash(&alg->alg.u.hash);
+			break;
+
+		default:
+			crypto_unregister_alg(&alg->alg.u.cipher);
+		}
 		kfree(alg);
 	}
 }
@@ -1105,17 +1120,18 @@ static irqreturn_t crypto4xx_ce_interrupt_handler(int irq, void *data)
 /**
  * Supported Crypto Algorithms
  */
-struct crypto_alg crypto4xx_alg[] = {
+struct crypto4xx_alg_common crypto4xx_alg[] = {
 	/* Crypto AES modes */
-	{
+	{ .type = CRYPTO_ALG_TYPE_ABLKCIPHER, .u.cipher = {
 		.cra_name 	= "cbc(aes)",
 		.cra_driver_name = "cbc-aes-ppc4xx",
 		.cra_priority 	= CRYPTO4XX_CRYPTO_PRIORITY,
 		.cra_flags 	= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 		.cra_blocksize 	= AES_BLOCK_SIZE,
 		.cra_ctxsize 	= sizeof(struct crypto4xx_ctx),
-		.cra_alignmask 	= 0,
 		.cra_type 	= &crypto_ablkcipher_type,
+		.cra_init	= crypto4xx_alg_init,
+		.cra_exit	= crypto4xx_alg_exit,
 		.cra_module 	= THIS_MODULE,
 		.cra_u 		= {
 			.ablkcipher = {
@@ -1127,29 +1143,26 @@ struct crypto_alg crypto4xx_alg[] = {
 				.decrypt 	= crypto4xx_decrypt,
 			}
 		}
-	},
+	}},
 	/* Hash SHA1 */
-	{
-		.cra_name	= "sha1",
-		.cra_driver_name = "sha1-ppc4xx",
-		.cra_priority	= CRYPTO4XX_CRYPTO_PRIORITY,
-		.cra_flags	= CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
-		.cra_blocksize	= SHA1_BLOCK_SIZE,
-		.cra_ctxsize	= sizeof(struct crypto4xx_ctx),
-		.cra_alignmask	= 0,
-		.cra_type	= &crypto_ahash_type,
-		.cra_init	= crypto4xx_sha1_alg_init,
-		.cra_module	= THIS_MODULE,
-		.cra_u		= {
-			.ahash = {
-				.digestsize 	= SHA1_DIGEST_SIZE,
-				.init		= crypto4xx_hash_init,
-				.update		= crypto4xx_hash_update,
-				.final  	= crypto4xx_hash_final,
-				.digest 	= crypto4xx_hash_digest,
-			}
+	{ .type = CRYPTO_ALG_TYPE_AHASH, .u.hash = {
+		.init		= crypto4xx_hash_init,
+		.update		= crypto4xx_hash_update,
+		.final  	= crypto4xx_hash_final,
+		.digest 	= crypto4xx_hash_digest,
+		.halg.digestsize = SHA1_DIGEST_SIZE,
+		.halg.base	= {
+			.cra_name	= "sha1",
+			.cra_driver_name = "sha1-ppc4xx",
+			.cra_priority	= CRYPTO4XX_CRYPTO_PRIORITY,
+			.cra_flags	= CRYPTO_ALG_ASYNC,
+			.cra_blocksize	= SHA1_BLOCK_SIZE,
+			.cra_ctxsize	= sizeof(struct crypto4xx_ctx),
+			.cra_init	= crypto4xx_sha1_alg_init,
+			.cra_exit	= crypto4xx_alg_exit,
+			.cra_module	= THIS_MODULE,
 		}
-	},
+	}},
 };
 
 /**
diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
index 1ef1034..da9cbe3 100644
--- a/drivers/crypto/amcc/crypto4xx_core.h
+++ b/drivers/crypto/amcc/crypto4xx_core.h
@@ -22,6 +22,8 @@
 #ifndef __CRYPTO4XX_CORE_H__
 #define __CRYPTO4XX_CORE_H__
 
+#include <crypto/internal/hash.h>
+
 #define PPC460SX_SDR0_SRST                      0x201
 #define PPC405EX_SDR0_SRST                      0x200
 #define PPC460EX_SDR0_SRST                      0x201
@@ -138,14 +140,31 @@ struct crypto4xx_req_ctx {
 	u16 sa_len;
 };
 
+struct crypto4xx_alg_common {
+	u32 type;
+	union {
+		struct crypto_alg cipher;
+		struct ahash_alg hash;
+	} u;
+};
+
 struct crypto4xx_alg {
 	struct list_head  entry;
-	struct crypto_alg alg;
+	struct crypto4xx_alg_common alg;
 	struct crypto4xx_device *dev;
 };
 
-#define crypto_alg_to_crypto4xx_alg(x) \
-		container_of(x, struct crypto4xx_alg, alg)
+static inline struct crypto4xx_alg *crypto_alg_to_crypto4xx_alg(
+	struct crypto_alg *x)
+{
+	switch (x->cra_flags & CRYPTO_ALG_TYPE_MASK) {
+	case CRYPTO_ALG_TYPE_AHASH:
+		return container_of(__crypto_ahash_alg(x),
+				    struct crypto4xx_alg, alg.u.hash);
+	}
+
+	return container_of(x, struct crypto4xx_alg, alg.u.cipher);
+}
 
 extern int crypto4xx_alloc_sa(struct crypto4xx_ctx *ctx, u32 size);
 extern void crypto4xx_free_sa(struct crypto4xx_ctx *ctx);
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 9d30316..e3a8251 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -103,6 +103,12 @@ static inline void *crypto_ahash_ctx(struct crypto_ahash *tfm)
 	return crypto_tfm_ctx(crypto_ahash_tfm(tfm));
 }
 
+static inline struct ahash_alg *__crypto_ahash_alg(struct crypto_alg *alg)
+{
+	return container_of(__crypto_hash_alg_common(alg), struct ahash_alg,
+			    halg);
+}
+
 static inline struct old_ahash_alg *crypto_old_ahash_alg(
 	struct crypto_ahash *tfm)
 {
