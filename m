From: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
Subject: [PATCH v3 1/2] crypto: vmx - Use skcipher for cbc fallback
Date: Wed,  1 Mar 2017 10:58:20 -0300
Message-ID: <20170301135820.20670-1-pfsmorigo@linux.vnet.ibm.com>
References: <20170226192107.GA7129@gallifrey>
Cc: benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170226192107.GA7129@gallifrey>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
---
 drivers/crypto/vmx/aes_cbc.c | 47 ++++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/vmx/aes_cbc.c b/drivers/crypto/vmx/aes_cbc.c
index 94ad5c0..72a26eb 100644
--- a/drivers/crypto/vmx/aes_cbc.c
+++ b/drivers/crypto/vmx/aes_cbc.c
@@ -27,11 +27,12 @@
 #include <asm/switch_to.h>
 #include <crypto/aes.h>
 #include <crypto/scatterwalk.h>
+#include <crypto/skcipher.h>
 
 #include "aesp8-ppc.h"
 
 struct p8_aes_cbc_ctx {
-	struct crypto_blkcipher *fallback;
+	struct crypto_skcipher *fallback;
 	struct aes_key enc_key;
 	struct aes_key dec_key;
 };
@@ -39,7 +40,7 @@ struct p8_aes_cbc_ctx {
 static int p8_aes_cbc_init(struct crypto_tfm *tfm)
 {
 	const char *alg;
-	struct crypto_blkcipher *fallback;
+	struct crypto_skcipher *fallback;
 	struct p8_aes_cbc_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	if (!(alg = crypto_tfm_alg_name(tfm))) {
@@ -47,8 +48,9 @@ static int p8_aes_cbc_init(struct crypto_tfm *tfm)
 		return -ENOENT;
 	}
 
-	fallback =
-	    crypto_alloc_blkcipher(alg, 0, CRYPTO_ALG_NEED_FALLBACK);
+	fallback = crypto_alloc_skcipher(alg, 0,
+			CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
+
 	if (IS_ERR(fallback)) {
 		printk(KERN_ERR
 		       "Failed to allocate transformation for '%s': %ld\n",
@@ -56,11 +58,12 @@ static int p8_aes_cbc_init(struct crypto_tfm *tfm)
 		return PTR_ERR(fallback);
 	}
 	printk(KERN_INFO "Using '%s' as fallback implementation.\n",
-	       crypto_tfm_alg_driver_name((struct crypto_tfm *) fallback));
+		crypto_skcipher_driver_name(fallback));
+
 
-	crypto_blkcipher_set_flags(
+	crypto_skcipher_set_flags(
 		fallback,
-		crypto_blkcipher_get_flags((struct crypto_blkcipher *)tfm));
+		crypto_skcipher_get_flags((struct crypto_skcipher *)tfm));
 	ctx->fallback = fallback;
 
 	return 0;
@@ -71,7 +74,7 @@ static void p8_aes_cbc_exit(struct crypto_tfm *tfm)
 	struct p8_aes_cbc_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	if (ctx->fallback) {
-		crypto_free_blkcipher(ctx->fallback);
+		crypto_free_skcipher(ctx->fallback);
 		ctx->fallback = NULL;
 	}
 }
@@ -91,7 +94,7 @@ static int p8_aes_cbc_setkey(struct crypto_tfm *tfm, const u8 *key,
 	pagefault_enable();
 	preempt_enable();
 
-	ret += crypto_blkcipher_setkey(ctx->fallback, key, keylen);
+	ret += crypto_skcipher_setkey(ctx->fallback, key, keylen);
 	return ret;
 }
 
@@ -103,15 +106,14 @@ static int p8_aes_cbc_encrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	struct p8_aes_cbc_ctx *ctx =
 		crypto_tfm_ctx(crypto_blkcipher_tfm(desc->tfm));
-	struct blkcipher_desc fallback_desc = {
-		.tfm = ctx->fallback,
-		.info = desc->info,
-		.flags = desc->flags
-	};
 
 	if (in_interrupt()) {
-		ret = crypto_blkcipher_encrypt(&fallback_desc, dst, src,
-					       nbytes);
+		SKCIPHER_REQUEST_ON_STACK(req, ctx->fallback);
+		skcipher_request_set_tfm(req, ctx->fallback);
+		skcipher_request_set_callback(req, desc->flags, NULL, NULL);
+		skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
+		ret = crypto_skcipher_encrypt(req);
+		skcipher_request_zero(req);
 	} else {
 		preempt_disable();
 		pagefault_disable();
@@ -144,15 +146,14 @@ static int p8_aes_cbc_decrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	struct p8_aes_cbc_ctx *ctx =
 		crypto_tfm_ctx(crypto_blkcipher_tfm(desc->tfm));
-	struct blkcipher_desc fallback_desc = {
-		.tfm = ctx->fallback,
-		.info = desc->info,
-		.flags = desc->flags
-	};
 
 	if (in_interrupt()) {
-		ret = crypto_blkcipher_decrypt(&fallback_desc, dst, src,
-					       nbytes);
+		SKCIPHER_REQUEST_ON_STACK(req, ctx->fallback);
+		skcipher_request_set_tfm(req, ctx->fallback);
+		skcipher_request_set_callback(req, desc->flags, NULL, NULL);
+		skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
+		ret = crypto_skcipher_decrypt(req);
+		skcipher_request_zero(req);
 	} else {
 		preempt_disable();
 		pagefault_disable();
-- 
2.9.3
