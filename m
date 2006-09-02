From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/7] [CRYPTO] padlock: Convert padlock-sha to use crypto_hash
Date: Sat, 02 Sep 2006 21:06:53 +1000
Message-ID: <E1GJTKv-0001Fo-00@gondolin.me.apana.org.au>
References: <20060902110520.GA4690@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:45584 "EHLO
	arnor.apana.org.au") by vger.kernel.org with ESMTP id S1750988AbWIBLGx
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 2 Sep 2006 07:06:53 -0400
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Michal Ludvig <michal@logix.cz>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] padlock: Convert padlock-sha to use crypto_hash

This patch converts padlock-sha to use crypto_hash for its fallback.
It also changes the fallback selection to use selection by type instead
of name.  This is done through the new CRYPTO_ALG_NEED_FALLBACK bit,
which is set if and only if an algorithm needs a fallback of the same
type.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/padlock-sha.c |   91 ++++++++++++++++---------------------------
 include/linux/crypto.h       |    6 ++
 2 files changed, 41 insertions(+), 56 deletions(-)

diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
--- a/drivers/crypto/padlock-sha.c
+++ b/drivers/crypto/padlock-sha.c
@@ -12,10 +12,11 @@
  *
  */
 
+#include <crypto/algapi.h>
+#include <linux/err.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/errno.h>
-#include <linux/crypto.h>
 #include <linux/cryptohash.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
@@ -30,28 +31,17 @@
 #define SHA256_DIGEST_SIZE      32
 #define SHA256_HMAC_BLOCK_SIZE  64
 
-static char *sha1_fallback = SHA1_DEFAULT_FALLBACK;
-static char *sha256_fallback = SHA256_DEFAULT_FALLBACK;
-
-module_param(sha1_fallback, charp, 0644);
-module_param(sha256_fallback, charp, 0644);
-
-MODULE_PARM_DESC(sha1_fallback, "Fallback driver for SHA1. Default is "
-		 SHA1_DEFAULT_FALLBACK);
-MODULE_PARM_DESC(sha256_fallback, "Fallback driver for SHA256. Default is "
-		 SHA256_DEFAULT_FALLBACK);
-
 struct padlock_sha_ctx {
 	char		*data;
 	size_t		used;
 	int		bypass;
 	void (*f_sha_padlock)(const char *in, char *out, int count);
-	struct crypto_tfm *fallback_tfm;
+	struct hash_desc fallback;
 };
 
 static inline struct padlock_sha_ctx *ctx(struct crypto_tfm *tfm)
 {
-	return (struct padlock_sha_ctx *)(crypto_tfm_ctx(tfm));
+	return crypto_tfm_ctx(tfm);
 }
 
 /* We'll need aligned address on the stack */
@@ -65,14 +55,12 @@ static void padlock_sha_bypass(struct cr
 	if (ctx(tfm)->bypass)
 		return;
 
-	BUG_ON(!ctx(tfm)->fallback_tfm);
-
-	crypto_digest_init(ctx(tfm)->fallback_tfm);
+	crypto_hash_init(&ctx(tfm)->fallback);
 	if (ctx(tfm)->data && ctx(tfm)->used) {
 		struct scatterlist sg;
 
 		sg_set_buf(&sg, ctx(tfm)->data, ctx(tfm)->used);
-		crypto_digest_update(ctx(tfm)->fallback_tfm, &sg, 1);
+		crypto_hash_update(&ctx(tfm)->fallback, &sg, sg.length);
 	}
 
 	ctx(tfm)->used = 0;
@@ -95,9 +83,8 @@ static void padlock_sha_update(struct cr
 
 	if (unlikely(ctx(tfm)->bypass)) {
 		struct scatterlist sg;
-		BUG_ON(!ctx(tfm)->fallback_tfm);
 		sg_set_buf(&sg, (uint8_t *)data, length);
-		crypto_digest_update(ctx(tfm)->fallback_tfm, &sg, 1);
+		crypto_hash_update(&ctx(tfm)->fallback, &sg, length);
 		return;
 	}
 
@@ -160,8 +147,7 @@ static void padlock_do_sha256(const char
 static void padlock_sha_final(struct crypto_tfm *tfm, uint8_t *out)
 {
 	if (unlikely(ctx(tfm)->bypass)) {
-		BUG_ON(!ctx(tfm)->fallback_tfm);
-		crypto_digest_final(ctx(tfm)->fallback_tfm, out);
+		crypto_hash_final(&ctx(tfm)->fallback, out);
 		ctx(tfm)->bypass = 0;
 		return;
 	}
@@ -172,8 +158,11 @@ static void padlock_sha_final(struct cry
 	ctx(tfm)->used = 0;
 }
 
-static int padlock_cra_init(struct crypto_tfm *tfm, const char *fallback_driver_name)
+static int padlock_cra_init(struct crypto_tfm *tfm)
 {
+	const char *fallback_driver_name = tfm->__crt_alg->cra_name;
+	struct crypto_hash *fallback_tfm;
+
 	/* For now we'll allocate one page. This
 	 * could eventually be configurable one day. */
 	ctx(tfm)->data = (char *)__get_free_page(GFP_KERNEL);
@@ -181,14 +170,17 @@ static int padlock_cra_init(struct crypt
 		return -ENOMEM;
 
 	/* Allocate a fallback and abort if it failed. */
-	ctx(tfm)->fallback_tfm = crypto_alloc_tfm(fallback_driver_name, 0);
-	if (!ctx(tfm)->fallback_tfm) {
+	fallback_tfm = crypto_alloc_hash(fallback_driver_name, 0,
+					 CRYPTO_ALG_ASYNC |
+					 CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(fallback_tfm)) {
 		printk(KERN_WARNING PFX "Fallback driver '%s' could not be loaded!\n",
 		       fallback_driver_name);
 		free_page((unsigned long)(ctx(tfm)->data));
-		return -ENOENT;
+		return PTR_ERR(fallback_tfm);
 	}
 
+	ctx(tfm)->fallback.tfm = fallback_tfm;
 	return 0;
 }
 
@@ -196,14 +188,14 @@ static int padlock_sha1_cra_init(struct 
 {
 	ctx(tfm)->f_sha_padlock = padlock_do_sha1;
 
-	return padlock_cra_init(tfm, sha1_fallback);
+	return padlock_cra_init(tfm);
 }
 
 static int padlock_sha256_cra_init(struct crypto_tfm *tfm)
 {
 	ctx(tfm)->f_sha_padlock = padlock_do_sha256;
 
-	return padlock_cra_init(tfm, sha256_fallback);
+	return padlock_cra_init(tfm);
 }
 
 static void padlock_cra_exit(struct crypto_tfm *tfm)
@@ -213,16 +205,16 @@ static void padlock_cra_exit(struct cryp
 		ctx(tfm)->data = NULL;
 	}
 
-	BUG_ON(!ctx(tfm)->fallback_tfm);
-	crypto_free_tfm(ctx(tfm)->fallback_tfm);
-	ctx(tfm)->fallback_tfm = NULL;
+	crypto_free_hash(ctx(tfm)->fallback.tfm);
+	ctx(tfm)->fallback.tfm = NULL;
 }
 
 static struct crypto_alg sha1_alg = {
 	.cra_name		=	"sha1",
 	.cra_driver_name	=	"sha1-padlock",
 	.cra_priority		=	PADLOCK_CRA_PRIORITY,
-	.cra_flags		=	CRYPTO_ALG_TYPE_DIGEST,
+	.cra_flags		=	CRYPTO_ALG_TYPE_DIGEST |
+					CRYPTO_ALG_NEED_FALLBACK,
 	.cra_blocksize		=	SHA1_HMAC_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct padlock_sha_ctx),
 	.cra_module		=	THIS_MODULE,
@@ -243,7 +235,8 @@ static struct crypto_alg sha256_alg = {
 	.cra_name		=	"sha256",
 	.cra_driver_name	=	"sha256-padlock",
 	.cra_priority		=	PADLOCK_CRA_PRIORITY,
-	.cra_flags		=	CRYPTO_ALG_TYPE_DIGEST,
+	.cra_flags		=	CRYPTO_ALG_TYPE_DIGEST |
+					CRYPTO_ALG_NEED_FALLBACK,
 	.cra_blocksize		=	SHA256_HMAC_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct padlock_sha_ctx),
 	.cra_module		=	THIS_MODULE,
@@ -262,29 +255,15 @@ static struct crypto_alg sha256_alg = {
 
 static void __init padlock_sha_check_fallbacks(void)
 {
-	struct crypto_tfm *tfm;
-
-	/* We'll try to allocate one TFM for each fallback
-	 * to test that the modules are available. */
-	tfm = crypto_alloc_tfm(sha1_fallback, 0);
-	if (!tfm) {
-		printk(KERN_WARNING PFX "Couldn't load fallback module for '%s'. Tried '%s'.\n",
-		       sha1_alg.cra_name, sha1_fallback);
-	} else {
-		printk(KERN_NOTICE PFX "Fallback for '%s' is driver '%s' (prio=%d)\n", sha1_alg.cra_name,
-		       crypto_tfm_alg_driver_name(tfm), crypto_tfm_alg_priority(tfm));
-		crypto_free_tfm(tfm);
-	}
-
-	tfm = crypto_alloc_tfm(sha256_fallback, 0);
-	if (!tfm) {
-		printk(KERN_WARNING PFX "Couldn't load fallback module for '%s'. Tried '%s'.\n",
-		       sha256_alg.cra_name, sha256_fallback);
-	} else {
-		printk(KERN_NOTICE PFX "Fallback for '%s' is driver '%s' (prio=%d)\n", sha256_alg.cra_name,
-		       crypto_tfm_alg_driver_name(tfm), crypto_tfm_alg_priority(tfm));
-		crypto_free_tfm(tfm);
-	}
+	if (!crypto_has_hash("sha1", 0, CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_NEED_FALLBACK))
+		printk(KERN_WARNING PFX
+		       "Couldn't load fallback module for sha1.\n");
+
+	if (!crypto_has_hash("sha256", 0, CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_NEED_FALLBACK))
+		printk(KERN_WARNING PFX
+		       "Couldn't load fallback module for sha256.\n");
 }
 
 static int __init padlock_init(void)
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -43,6 +43,12 @@
 #define CRYPTO_ALG_ASYNC		0x00000080
 
 /*
+ * Set this bit if and only if the algorithm requires another algorithm of
+ * the same type to handle corner cases.
+ */
+#define CRYPTO_ALG_NEED_FALLBACK	0x00000100
+
+/*
  * Transform masks and values (for crt_flags).
  */
 #define CRYPTO_TFM_MODE_MASK		0x000000ff

-- 
VGER BF report: H 0
