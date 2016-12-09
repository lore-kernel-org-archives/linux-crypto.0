From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 1/3] crypto: chacha20 - convert generic and x86 versions to skcipher
Date: Fri,  9 Dec 2016 14:33:51 +0000
Message-ID: <1481294033-23508-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1481294033-23508-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wj0-f172.google.com ([209.85.210.172]:34521 "EHLO
        mail-wj0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932594AbcLIOeD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Dec 2016 09:34:03 -0500
Received: by mail-wj0-f172.google.com with SMTP id tg4so16163076wjb.1
        for <linux-crypto@vger.kernel.org>; Fri, 09 Dec 2016 06:34:02 -0800 (PST)
In-Reply-To: <1481294033-23508-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This converts the ChaCha20 code from a blkcipher to a skcipher, which
is now the preferred way to implement symmetric block and stream ciphers.

This ports the generic and x86 versions at the same time because the
latter reuses routines of the former.

Note that the skcipher_walk() API guarantees that all presented blocks
except the final one are a multiple of the chunk size, so we can simplify
the encrypt() routine somewhat.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/chacha20_glue.c | 69 +++++++++---------
 crypto/chacha20_generic.c       | 73 ++++++++------------
 include/crypto/chacha20.h       |  6 +-
 3 files changed, 64 insertions(+), 84 deletions(-)

diff --git a/arch/x86/crypto/chacha20_glue.c b/arch/x86/crypto/chacha20_glue.c
index f910d1d449f0..78f75b07dc25 100644
--- a/arch/x86/crypto/chacha20_glue.c
+++ b/arch/x86/crypto/chacha20_glue.c
@@ -11,7 +11,7 @@
 
 #include <crypto/algapi.h>
 #include <crypto/chacha20.h>
-#include <linux/crypto.h>
+#include <crypto/internal/skcipher.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <asm/fpu/api.h>
@@ -63,36 +63,34 @@ static void chacha20_dosimd(u32 *state, u8 *dst, const u8 *src,
 	}
 }
 
-static int chacha20_simd(struct blkcipher_desc *desc, struct scatterlist *dst,
-			 struct scatterlist *src, unsigned int nbytes)
+static int chacha20_simd(struct skcipher_request *req)
 {
-	u32 *state, state_buf[16 + (CHACHA20_STATE_ALIGN / sizeof(u32)) - 1];
-	struct blkcipher_walk walk;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct chacha20_ctx *ctx = crypto_skcipher_ctx(tfm);
+	u32 state[16] __aligned(CHACHA20_STATE_ALIGN);
+	struct skcipher_walk walk;
 	int err;
 
-	if (nbytes <= CHACHA20_BLOCK_SIZE || !may_use_simd())
-		return crypto_chacha20_crypt(desc, dst, src, nbytes);
+	if (req->cryptlen <= CHACHA20_BLOCK_SIZE || !may_use_simd())
+		return crypto_chacha20_crypt(req);
 
-	state = (u32 *)roundup((uintptr_t)state_buf, CHACHA20_STATE_ALIGN);
+	err = skcipher_walk_virt(&walk, req, true);
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt_block(desc, &walk, CHACHA20_BLOCK_SIZE);
-
-	crypto_chacha20_init(state, crypto_blkcipher_ctx(desc->tfm), walk.iv);
+	crypto_chacha20_init(state, ctx, walk.iv);
 
 	kernel_fpu_begin();
 
 	while (walk.nbytes >= CHACHA20_BLOCK_SIZE) {
 		chacha20_dosimd(state, walk.dst.virt.addr, walk.src.virt.addr,
 				rounddown(walk.nbytes, CHACHA20_BLOCK_SIZE));
-		err = blkcipher_walk_done(desc, &walk,
-					  walk.nbytes % CHACHA20_BLOCK_SIZE);
+		err = skcipher_walk_done(&walk,
+					 walk.nbytes % CHACHA20_BLOCK_SIZE);
 	}
 
 	if (walk.nbytes) {
 		chacha20_dosimd(state, walk.dst.virt.addr, walk.src.virt.addr,
 				walk.nbytes);
-		err = blkcipher_walk_done(desc, &walk, 0);
+		err = skcipher_walk_done(&walk, 0);
 	}
 
 	kernel_fpu_end();
@@ -100,27 +98,22 @@ static int chacha20_simd(struct blkcipher_desc *desc, struct scatterlist *dst,
 	return err;
 }
 
-static struct crypto_alg alg = {
-	.cra_name		= "chacha20",
-	.cra_driver_name	= "chacha20-simd",
-	.cra_priority		= 300,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		= 1,
-	.cra_type		= &crypto_blkcipher_type,
-	.cra_ctxsize		= sizeof(struct chacha20_ctx),
-	.cra_alignmask		= sizeof(u32) - 1,
-	.cra_module		= THIS_MODULE,
-	.cra_u			= {
-		.blkcipher = {
-			.min_keysize	= CHACHA20_KEY_SIZE,
-			.max_keysize	= CHACHA20_KEY_SIZE,
-			.ivsize		= CHACHA20_IV_SIZE,
-			.geniv		= "seqiv",
-			.setkey		= crypto_chacha20_setkey,
-			.encrypt	= chacha20_simd,
-			.decrypt	= chacha20_simd,
-		},
-	},
+static struct skcipher_alg alg = {
+	.base.cra_name		= "chacha20",
+	.base.cra_driver_name	= "chacha20-simd",
+	.base.cra_priority	= 300,
+	.base.cra_blocksize	= 1,
+	.base.cra_ctxsize	= sizeof(struct chacha20_ctx),
+	.base.cra_alignmask	= sizeof(u32) - 1,
+	.base.cra_module	= THIS_MODULE,
+
+	.min_keysize		= CHACHA20_KEY_SIZE,
+	.max_keysize		= CHACHA20_KEY_SIZE,
+	.ivsize			= CHACHA20_IV_SIZE,
+	.chunksize		= CHACHA20_BLOCK_SIZE,
+	.setkey			= crypto_chacha20_setkey,
+	.encrypt		= chacha20_simd,
+	.decrypt		= chacha20_simd,
 };
 
 static int __init chacha20_simd_mod_init(void)
@@ -133,12 +126,12 @@ static int __init chacha20_simd_mod_init(void)
 			    boot_cpu_has(X86_FEATURE_AVX2) &&
 			    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL);
 #endif
-	return crypto_register_alg(&alg);
+	return crypto_register_skcipher(&alg);
 }
 
 static void __exit chacha20_simd_mod_fini(void)
 {
-	crypto_unregister_alg(&alg);
+	crypto_unregister_skcipher(&alg);
 }
 
 module_init(chacha20_simd_mod_init);
diff --git a/crypto/chacha20_generic.c b/crypto/chacha20_generic.c
index 1cab83146e33..8b3c04d625c3 100644
--- a/crypto/chacha20_generic.c
+++ b/crypto/chacha20_generic.c
@@ -10,10 +10,9 @@
  */
 
 #include <crypto/algapi.h>
-#include <linux/crypto.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
 #include <crypto/chacha20.h>
+#include <crypto/internal/skcipher.h>
+#include <linux/module.h>
 
 static inline u32 le32_to_cpuvp(const void *p)
 {
@@ -63,10 +62,10 @@ void crypto_chacha20_init(u32 *state, struct chacha20_ctx *ctx, u8 *iv)
 }
 EXPORT_SYMBOL_GPL(crypto_chacha20_init);
 
-int crypto_chacha20_setkey(struct crypto_tfm *tfm, const u8 *key,
+int crypto_chacha20_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			   unsigned int keysize)
 {
-	struct chacha20_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct chacha20_ctx *ctx = crypto_skcipher_ctx(tfm);
 	int i;
 
 	if (keysize != CHACHA20_KEY_SIZE)
@@ -79,66 +78,54 @@ int crypto_chacha20_setkey(struct crypto_tfm *tfm, const u8 *key,
 }
 EXPORT_SYMBOL_GPL(crypto_chacha20_setkey);
 
-int crypto_chacha20_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
-			  struct scatterlist *src, unsigned int nbytes)
+int crypto_chacha20_crypt(struct skcipher_request *req)
 {
-	struct blkcipher_walk walk;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct chacha20_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_walk walk;
 	u32 state[16];
 	int err;
 
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt_block(desc, &walk, CHACHA20_BLOCK_SIZE);
-
-	crypto_chacha20_init(state, crypto_blkcipher_ctx(desc->tfm), walk.iv);
+	err = skcipher_walk_virt(&walk, req, true);
 
-	while (walk.nbytes >= CHACHA20_BLOCK_SIZE) {
-		chacha20_docrypt(state, walk.dst.virt.addr, walk.src.virt.addr,
-				 rounddown(walk.nbytes, CHACHA20_BLOCK_SIZE));
-		err = blkcipher_walk_done(desc, &walk,
-					  walk.nbytes % CHACHA20_BLOCK_SIZE);
-	}
+	crypto_chacha20_init(state, ctx, walk.iv);
 
-	if (walk.nbytes) {
+	while (walk.nbytes > 0) {
 		chacha20_docrypt(state, walk.dst.virt.addr, walk.src.virt.addr,
 				 walk.nbytes);
-		err = blkcipher_walk_done(desc, &walk, 0);
+		err = skcipher_walk_done(&walk, 0);
 	}
 
 	return err;
 }
 EXPORT_SYMBOL_GPL(crypto_chacha20_crypt);
 
-static struct crypto_alg alg = {
-	.cra_name		= "chacha20",
-	.cra_driver_name	= "chacha20-generic",
-	.cra_priority		= 100,
-	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		= 1,
-	.cra_type		= &crypto_blkcipher_type,
-	.cra_ctxsize		= sizeof(struct chacha20_ctx),
-	.cra_alignmask		= sizeof(u32) - 1,
-	.cra_module		= THIS_MODULE,
-	.cra_u			= {
-		.blkcipher = {
-			.min_keysize	= CHACHA20_KEY_SIZE,
-			.max_keysize	= CHACHA20_KEY_SIZE,
-			.ivsize		= CHACHA20_IV_SIZE,
-			.geniv		= "seqiv",
-			.setkey		= crypto_chacha20_setkey,
-			.encrypt	= crypto_chacha20_crypt,
-			.decrypt	= crypto_chacha20_crypt,
-		},
-	},
+static struct skcipher_alg alg = {
+	.base.cra_name		= "chacha20",
+	.base.cra_driver_name	= "chacha20-generic",
+	.base.cra_priority	= 100,
+	.base.cra_blocksize	= 1,
+	.base.cra_ctxsize	= sizeof(struct chacha20_ctx),
+	.base.cra_alignmask	= sizeof(u32) - 1,
+	.base.cra_module	= THIS_MODULE,
+
+	.min_keysize		= CHACHA20_KEY_SIZE,
+	.max_keysize		= CHACHA20_KEY_SIZE,
+	.ivsize			= CHACHA20_IV_SIZE,
+	.chunksize		= CHACHA20_BLOCK_SIZE,
+	.setkey			= crypto_chacha20_setkey,
+	.encrypt		= crypto_chacha20_crypt,
+	.decrypt		= crypto_chacha20_crypt,
 };
 
 static int __init chacha20_generic_mod_init(void)
 {
-	return crypto_register_alg(&alg);
+	return crypto_register_skcipher(&alg);
 }
 
 static void __exit chacha20_generic_mod_fini(void)
 {
-	crypto_unregister_alg(&alg);
+	crypto_unregister_skcipher(&alg);
 }
 
 module_init(chacha20_generic_mod_init);
diff --git a/include/crypto/chacha20.h b/include/crypto/chacha20.h
index 20d20f681a72..445fc45f4b5b 100644
--- a/include/crypto/chacha20.h
+++ b/include/crypto/chacha20.h
@@ -5,6 +5,7 @@
 #ifndef _CRYPTO_CHACHA20_H
 #define _CRYPTO_CHACHA20_H
 
+#include <crypto/skcipher.h>
 #include <linux/types.h>
 #include <linux/crypto.h>
 
@@ -18,9 +19,8 @@ struct chacha20_ctx {
 
 void chacha20_block(u32 *state, void *stream);
 void crypto_chacha20_init(u32 *state, struct chacha20_ctx *ctx, u8 *iv);
-int crypto_chacha20_setkey(struct crypto_tfm *tfm, const u8 *key,
+int crypto_chacha20_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			   unsigned int keysize);
-int crypto_chacha20_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
-			  struct scatterlist *src, unsigned int nbytes);
+int crypto_chacha20_crypt(struct skcipher_request *req);
 
 #endif
-- 
2.7.4
