From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 8/35] crypto: padlock - Use shash fallback for sha
Date: Wed, 15 Jul 2009 15:16:01 +0800
Message-ID: <E1MQyif-0004yn-2y@gondolin.me.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53619 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752598AbZGOHQE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:16:04 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyif-0004p6-Mb
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:16:01 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: padlock - Use shash fallback for sha

This patch changes padlock sha fallback to shash instead of hash.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/padlock-sha.c |   82 +++++++++++++++++++++++++++----------------
 1 file changed, 52 insertions(+), 30 deletions(-)

diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
index a2c8e85..868da54 100644
--- a/drivers/crypto/padlock-sha.c
+++ b/drivers/crypto/padlock-sha.c
@@ -12,28 +12,24 @@
  *
  */
 
-#include <crypto/algapi.h>
+#include <crypto/internal/hash.h>
 #include <crypto/sha.h>
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/errno.h>
-#include <linux/cryptohash.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/scatterlist.h>
 #include <asm/i387.h>
 #include "padlock.h"
 
-#define SHA1_DEFAULT_FALLBACK	"sha1-generic"
-#define SHA256_DEFAULT_FALLBACK "sha256-generic"
-
 struct padlock_sha_ctx {
 	char		*data;
 	size_t		used;
 	int		bypass;
 	void (*f_sha_padlock)(const char *in, char *out, int count);
-	struct hash_desc fallback;
+	struct shash_desc *fallback;
 };
 
 static inline struct padlock_sha_ctx *ctx(struct crypto_tfm *tfm)
@@ -47,21 +43,26 @@ static inline struct padlock_sha_ctx *ctx(struct crypto_tfm *tfm)
 
 static struct crypto_alg sha1_alg, sha256_alg;
 
-static void padlock_sha_bypass(struct crypto_tfm *tfm)
+static int padlock_sha_bypass(struct crypto_tfm *tfm)
 {
+	int err = 0;
+
 	if (ctx(tfm)->bypass)
-		return;
+		goto out;
 
-	crypto_hash_init(&ctx(tfm)->fallback);
-	if (ctx(tfm)->data && ctx(tfm)->used) {
-		struct scatterlist sg;
+	err = crypto_shash_init(ctx(tfm)->fallback);
+	if (err)
+		goto out;
 
-		sg_init_one(&sg, ctx(tfm)->data, ctx(tfm)->used);
-		crypto_hash_update(&ctx(tfm)->fallback, &sg, sg.length);
-	}
+	if (ctx(tfm)->data && ctx(tfm)->used)
+		err = crypto_shash_update(ctx(tfm)->fallback, ctx(tfm)->data,
+					  ctx(tfm)->used);
 
 	ctx(tfm)->used = 0;
 	ctx(tfm)->bypass = 1;
+
+out:
+	return err;
 }
 
 static void padlock_sha_init(struct crypto_tfm *tfm)
@@ -73,15 +74,18 @@ static void padlock_sha_init(struct crypto_tfm *tfm)
 static void padlock_sha_update(struct crypto_tfm *tfm,
 			const uint8_t *data, unsigned int length)
 {
+	int err;
+
 	/* Our buffer is always one page. */
 	if (unlikely(!ctx(tfm)->bypass &&
-		     (ctx(tfm)->used + length > PAGE_SIZE)))
-		padlock_sha_bypass(tfm);
+		     (ctx(tfm)->used + length > PAGE_SIZE))) {
+		err = padlock_sha_bypass(tfm);
+		BUG_ON(err);
+	}
 
 	if (unlikely(ctx(tfm)->bypass)) {
-		struct scatterlist sg;
-		sg_init_one(&sg, (uint8_t *)data, length);
-		crypto_hash_update(&ctx(tfm)->fallback, &sg, length);
+		err = crypto_shash_update(ctx(tfm)->fallback, data, length);
+		BUG_ON(err);
 		return;
 	}
 
@@ -151,8 +155,11 @@ static void padlock_do_sha256(const char *in, char *out, int count)
 
 static void padlock_sha_final(struct crypto_tfm *tfm, uint8_t *out)
 {
+	int err;
+
 	if (unlikely(ctx(tfm)->bypass)) {
-		crypto_hash_final(&ctx(tfm)->fallback, out);
+		err = crypto_shash_final(ctx(tfm)->fallback, out);
+		BUG_ON(err);
 		ctx(tfm)->bypass = 0;
 		return;
 	}
@@ -166,27 +173,41 @@ static void padlock_sha_final(struct crypto_tfm *tfm, uint8_t *out)
 static int padlock_cra_init(struct crypto_tfm *tfm)
 {
 	const char *fallback_driver_name = tfm->__crt_alg->cra_name;
-	struct crypto_hash *fallback_tfm;
+	struct crypto_shash *fallback_tfm;
+	int err = -ENOMEM;
 
 	/* For now we'll allocate one page. This
 	 * could eventually be configurable one day. */
 	ctx(tfm)->data = (char *)__get_free_page(GFP_KERNEL);
 	if (!ctx(tfm)->data)
-		return -ENOMEM;
+		goto out;
 
 	/* Allocate a fallback and abort if it failed. */
-	fallback_tfm = crypto_alloc_hash(fallback_driver_name, 0,
-					 CRYPTO_ALG_ASYNC |
-					 CRYPTO_ALG_NEED_FALLBACK);
+	fallback_tfm = crypto_alloc_shash(fallback_driver_name, 0,
+					  CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(fallback_tfm)) {
 		printk(KERN_WARNING PFX "Fallback driver '%s' could not be loaded!\n",
 		       fallback_driver_name);
-		free_page((unsigned long)(ctx(tfm)->data));
-		return PTR_ERR(fallback_tfm);
+		err = PTR_ERR(fallback_tfm);
+		goto out_free_page;
 	}
 
-	ctx(tfm)->fallback.tfm = fallback_tfm;
+	ctx(tfm)->fallback = kmalloc(sizeof(struct shash_desc) +
+				     crypto_shash_descsize(fallback_tfm),
+				     GFP_KERNEL);
+	if (!ctx(tfm)->fallback)
+		goto out_free_tfm;
+
+	ctx(tfm)->fallback->tfm = fallback_tfm;
+	ctx(tfm)->fallback->flags = 0;
 	return 0;
+
+out_free_tfm:
+	crypto_free_shash(fallback_tfm);
+out_free_page:
+	free_page((unsigned long)(ctx(tfm)->data));
+out:
+	return err;
 }
 
 static int padlock_sha1_cra_init(struct crypto_tfm *tfm)
@@ -210,8 +231,9 @@ static void padlock_cra_exit(struct crypto_tfm *tfm)
 		ctx(tfm)->data = NULL;
 	}
 
-	crypto_free_hash(ctx(tfm)->fallback.tfm);
-	ctx(tfm)->fallback.tfm = NULL;
+	crypto_free_shash(ctx(tfm)->fallback->tfm);
+
+	kzfree(ctx(tfm)->fallback);
 }
 
 static struct crypto_alg sha1_alg = {
