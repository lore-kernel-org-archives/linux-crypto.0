From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 9/16] crypto: glue_helper - Add skcipher xts helpers
Date: Wed, 02 Nov 2016 07:19:11 +0800
Message-ID: <E1c1iKl-0004D9-6m@gondolin.me.apana.org.au>
References: <20161101231648.GA15967@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60317 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752307AbcKAXTO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Nov 2016 19:19:14 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
        by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
        id 1c1iKl-00074U-Cx
        for <linux-crypto@vger.kernel.org>; Wed, 02 Nov 2016 10:19:11 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds xts helpers that use the skcipher interface rather
than blkcipher.  This will be used by aesni_intel.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 arch/x86/crypto/glue_helper.c             |   74 +++++++++++++++++++++++++++++-
 arch/x86/include/asm/crypto/glue_helper.h |   39 +++++++++++++++
 crypto/Kconfig                            |    2 
 3 files changed, 112 insertions(+), 3 deletions(-)

diff --git a/arch/x86/crypto/glue_helper.c b/arch/x86/crypto/glue_helper.c
index 6a85598..260a060 100644
--- a/arch/x86/crypto/glue_helper.c
+++ b/arch/x86/crypto/glue_helper.c
@@ -27,10 +27,10 @@
 
 #include <linux/module.h>
 #include <crypto/b128ops.h>
+#include <crypto/internal/skcipher.h>
 #include <crypto/lrw.h>
 #include <crypto/xts.h>
 #include <asm/crypto/glue_helper.h>
-#include <crypto/scatterwalk.h>
 
 static int __glue_ecb_crypt_128bit(const struct common_glue_ctx *gctx,
 				   struct blkcipher_desc *desc,
@@ -339,6 +339,41 @@ static unsigned int __glue_xts_crypt_128bit(const struct common_glue_ctx *gctx,
 	return nbytes;
 }
 
+static unsigned int __glue_xts_req_128bit(const struct common_glue_ctx *gctx,
+					  void *ctx,
+					  struct skcipher_walk *walk)
+{
+	const unsigned int bsize = 128 / 8;
+	unsigned int nbytes = walk->nbytes;
+	u128 *src = walk->src.virt.addr;
+	u128 *dst = walk->dst.virt.addr;
+	unsigned int num_blocks, func_bytes;
+	unsigned int i;
+
+	/* Process multi-block batch */
+	for (i = 0; i < gctx->num_funcs; i++) {
+		num_blocks = gctx->funcs[i].num_blocks;
+		func_bytes = bsize * num_blocks;
+
+		if (nbytes >= func_bytes) {
+			do {
+				gctx->funcs[i].fn_u.xts(ctx, dst, src,
+							walk->iv);
+
+				src += num_blocks;
+				dst += num_blocks;
+				nbytes -= func_bytes;
+			} while (nbytes >= func_bytes);
+
+			if (nbytes < bsize)
+				goto done;
+		}
+	}
+
+done:
+	return nbytes;
+}
+
 /* for implementations implementing faster XTS IV generator */
 int glue_xts_crypt_128bit(const struct common_glue_ctx *gctx,
 			  struct blkcipher_desc *desc, struct scatterlist *dst,
@@ -379,6 +414,43 @@ int glue_xts_crypt_128bit(const struct common_glue_ctx *gctx,
 }
 EXPORT_SYMBOL_GPL(glue_xts_crypt_128bit);
 
+int glue_xts_req_128bit(const struct common_glue_ctx *gctx,
+			struct skcipher_request *req,
+			common_glue_func_t tweak_fn, void *tweak_ctx,
+			void *crypt_ctx)
+{
+	const unsigned int bsize = 128 / 8;
+	struct skcipher_walk walk;
+	bool fpu_enabled = false;
+	unsigned int nbytes;
+	int err;
+
+	err = skcipher_walk_virt(&walk, req, false);
+	nbytes = walk.nbytes;
+	if (!nbytes)
+		return err;
+
+	/* set minimum length to bsize, for tweak_fn */
+	fpu_enabled = glue_skwalk_fpu_begin(bsize, gctx->fpu_blocks_limit,
+					    &walk, fpu_enabled,
+					    nbytes < bsize ? bsize : nbytes);
+
+	/* calculate first value of T */
+	tweak_fn(tweak_ctx, walk.iv, walk.iv);
+
+	while (nbytes) {
+		nbytes = __glue_xts_req_128bit(gctx, crypt_ctx, &walk);
+
+		err = skcipher_walk_done(&walk, nbytes);
+		nbytes = walk.nbytes;
+	}
+
+	glue_fpu_end(fpu_enabled);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(glue_xts_req_128bit);
+
 void glue_xts_crypt_128bit_one(void *ctx, u128 *dst, const u128 *src, le128 *iv,
 			       common_glue_func_t fn)
 {
diff --git a/arch/x86/include/asm/crypto/glue_helper.h b/arch/x86/include/asm/crypto/glue_helper.h
index 03bb106..29e53ea 100644
--- a/arch/x86/include/asm/crypto/glue_helper.h
+++ b/arch/x86/include/asm/crypto/glue_helper.h
@@ -5,8 +5,8 @@
 #ifndef _CRYPTO_GLUE_HELPER_H
 #define _CRYPTO_GLUE_HELPER_H
 
+#include <crypto/internal/skcipher.h>
 #include <linux/kernel.h>
-#include <linux/crypto.h>
 #include <asm/fpu/api.h>
 #include <crypto/b128ops.h>
 
@@ -69,6 +69,31 @@ static inline bool glue_fpu_begin(unsigned int bsize, int fpu_blocks_limit,
 	return true;
 }
 
+static inline bool glue_skwalk_fpu_begin(unsigned int bsize,
+					 int fpu_blocks_limit,
+					 struct skcipher_walk *walk,
+					 bool fpu_enabled, unsigned int nbytes)
+{
+	if (likely(fpu_blocks_limit < 0))
+		return false;
+
+	if (fpu_enabled)
+		return true;
+
+	/*
+	 * Vector-registers are only used when chunk to be processed is large
+	 * enough, so do not enable FPU until it is necessary.
+	 */
+	if (nbytes < bsize * (unsigned int)fpu_blocks_limit)
+		return false;
+
+	/* prevent sleeping if FPU is in use */
+	skcipher_walk_atomise(walk);
+
+	kernel_fpu_begin();
+	return true;
+}
+
 static inline void glue_fpu_end(bool fpu_enabled)
 {
 	if (fpu_enabled)
@@ -139,6 +164,18 @@ extern int glue_xts_crypt_128bit(const struct common_glue_ctx *gctx,
 				 common_glue_func_t tweak_fn, void *tweak_ctx,
 				 void *crypt_ctx);
 
+extern int glue_xts_crypt_128bit(const struct common_glue_ctx *gctx,
+				 struct blkcipher_desc *desc,
+				 struct scatterlist *dst,
+				 struct scatterlist *src, unsigned int nbytes,
+				 common_glue_func_t tweak_fn, void *tweak_ctx,
+				 void *crypt_ctx);
+
+extern int glue_xts_req_128bit(const struct common_glue_ctx *gctx,
+			       struct skcipher_request *req,
+			       common_glue_func_t tweak_fn, void *tweak_ctx,
+			       void *crypt_ctx);
+
 extern void glue_xts_crypt_128bit_one(void *ctx, u128 *dst, const u128 *src,
 				      le128 *iv, common_glue_func_t fn);
 
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 3d31181..87a09c7 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -253,7 +253,7 @@ config CRYPTO_SIMD
 config CRYPTO_GLUE_HELPER_X86
 	tristate
 	depends on X86
-	select CRYPTO_ALGAPI
+	select CRYPTO_BLKCIPHER
 
 config CRYPTO_ENGINE
 	tristate
