From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 05/11] crypto: serpent-sse2 - split generic glue code to new
 helper module
Date: Mon, 18 Jun 2012 14:07:19 +0300
Message-ID: <20120618110719.28985.63181.stgit@localhost6.localdomain6>
References: <20120618110652.28985.70075.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:50784 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab2FRLHZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jun 2012 07:07:25 -0400
In-Reply-To: <20120618110652.28985.70075.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Now that serpent-sse2 glue code has been made generic, it can be split to
separate module.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/Makefile                  |    1 
 arch/x86/crypto/glue_helper.c             |  307 +++++++++++++++++++++++++
 arch/x86/crypto/serpent_sse2_glue.c       |  352 -----------------------------
 arch/x86/include/asm/crypto/glue_helper.h |  115 +++++++++
 crypto/Kconfig                            |    7 +
 5 files changed, 431 insertions(+), 351 deletions(-)
 create mode 100644 arch/x86/crypto/glue_helper.c
 create mode 100644 arch/x86/include/asm/crypto/glue_helper.h

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index ad74691..e908e5d 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -3,6 +3,7 @@
 #
 
 obj-$(CONFIG_CRYPTO_ABLK_HELPER_X86) += ablk_helper.o
+obj-$(CONFIG_CRYPTO_GLUE_HELPER_X86) += glue_helper.o
 
 obj-$(CONFIG_CRYPTO_AES_586) += aes-i586.o
 obj-$(CONFIG_CRYPTO_TWOFISH_586) += twofish-i586.o
diff --git a/arch/x86/crypto/glue_helper.c b/arch/x86/crypto/glue_helper.c
new file mode 100644
index 0000000..4854f0f
--- /dev/null
+++ b/arch/x86/crypto/glue_helper.c
@@ -0,0 +1,307 @@
+/*
+ * Shared glue code for 128bit block ciphers
+ *
+ * Copyright (c) 2012 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
+ *
+ * CBC & ECB parts based on code (crypto/cbc.c,ecb.c) by:
+ *   Copyright (c) 2006 Herbert Xu <herbert@gondor.apana.org.au>
+ * CTR part based on code (crypto/ctr.c) by:
+ *   (C) Copyright IBM Corp. 2007 - Joy Latten <latten@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
+ * USA
+ *
+ */
+
+#include <linux/module.h>
+#include <crypto/b128ops.h>
+#include <crypto/lrw.h>
+#include <crypto/xts.h>
+#include <asm/crypto/glue_helper.h>
+#include <crypto/scatterwalk.h>
+
+static int __glue_ecb_crypt_128bit(const struct common_glue_ctx *gctx,
+				   struct blkcipher_desc *desc,
+				   struct blkcipher_walk *walk)
+{
+	void *ctx = crypto_blkcipher_ctx(desc->tfm);
+	const unsigned int bsize = 128 / 8;
+	unsigned int nbytes, i, func_bytes;
+	bool fpu_enabled = false;
+	int err;
+
+	err = blkcipher_walk_virt(desc, walk);
+
+	while ((nbytes = walk->nbytes)) {
+		u8 *wsrc = walk->src.virt.addr;
+		u8 *wdst = walk->dst.virt.addr;
+
+		fpu_enabled = glue_fpu_begin(bsize, gctx->fpu_blocks_limit,
+					     desc, fpu_enabled, nbytes);
+
+		for (i = 0; i < gctx->num_funcs; i++) {
+			func_bytes = bsize * gctx->funcs[i].num_blocks;
+
+			/* Process multi-block batch */
+			if (nbytes >= func_bytes) {
+				do {
+					gctx->funcs[i].fn_u.ecb(ctx, wdst,
+								wsrc);
+
+					wsrc += func_bytes;
+					wdst += func_bytes;
+					nbytes -= func_bytes;
+				} while (nbytes >= func_bytes);
+
+				if (nbytes < bsize)
+					goto done;
+			}
+		}
+
+done:
+		err = blkcipher_walk_done(desc, walk, nbytes);
+	}
+
+	glue_fpu_end(fpu_enabled);
+	return err;
+}
+
+int glue_ecb_crypt_128bit(const struct common_glue_ctx *gctx,
+			  struct blkcipher_desc *desc, struct scatterlist *dst,
+			  struct scatterlist *src, unsigned int nbytes)
+{
+	struct blkcipher_walk walk;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	return __glue_ecb_crypt_128bit(gctx, desc, &walk);
+}
+EXPORT_SYMBOL_GPL(glue_ecb_crypt_128bit);
+
+static unsigned int __glue_cbc_encrypt_128bit(const common_glue_func_t fn,
+					      struct blkcipher_desc *desc,
+					      struct blkcipher_walk *walk)
+{
+	void *ctx = crypto_blkcipher_ctx(desc->tfm);
+	const unsigned int bsize = 128 / 8;
+	unsigned int nbytes = walk->nbytes;
+	u128 *src = (u128 *)walk->src.virt.addr;
+	u128 *dst = (u128 *)walk->dst.virt.addr;
+	u128 *iv = (u128 *)walk->iv;
+
+	do {
+		u128_xor(dst, src, iv);
+		fn(ctx, (u8 *)dst, (u8 *)dst);
+		iv = dst;
+
+		src += 1;
+		dst += 1;
+		nbytes -= bsize;
+	} while (nbytes >= bsize);
+
+	u128_xor((u128 *)walk->iv, (u128 *)walk->iv, iv);
+	return nbytes;
+}
+
+int glue_cbc_encrypt_128bit(const common_glue_func_t fn,
+			    struct blkcipher_desc *desc,
+			    struct scatterlist *dst,
+			    struct scatterlist *src, unsigned int nbytes)
+{
+	struct blkcipher_walk walk;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	while ((nbytes = walk.nbytes)) {
+		nbytes = __glue_cbc_encrypt_128bit(fn, desc, &walk);
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(glue_cbc_encrypt_128bit);
+
+static unsigned int
+__glue_cbc_decrypt_128bit(const struct common_glue_ctx *gctx,
+			  struct blkcipher_desc *desc,
+			  struct blkcipher_walk *walk)
+{
+	void *ctx = crypto_blkcipher_ctx(desc->tfm);
+	const unsigned int bsize = 128 / 8;
+	unsigned int nbytes = walk->nbytes;
+	u128 *src = (u128 *)walk->src.virt.addr;
+	u128 *dst = (u128 *)walk->dst.virt.addr;
+	u128 last_iv;
+	unsigned int num_blocks, func_bytes;
+	unsigned int i;
+
+	/* Start of the last block. */
+	src += nbytes / bsize - 1;
+	dst += nbytes / bsize - 1;
+
+	last_iv = *src;
+
+	for (i = 0; i < gctx->num_funcs; i++) {
+		num_blocks = gctx->funcs[i].num_blocks;
+		func_bytes = bsize * num_blocks;
+
+		/* Process multi-block batch */
+		if (nbytes >= func_bytes) {
+			do {
+				nbytes -= func_bytes - bsize;
+				src -= num_blocks - 1;
+				dst -= num_blocks - 1;
+
+				gctx->funcs[i].fn_u.cbc(ctx, dst, src);
+
+				nbytes -= bsize;
+				if (nbytes < bsize)
+					goto done;
+
+				u128_xor(dst, dst, src - 1);
+				src -= 1;
+				dst -= 1;
+			} while (nbytes >= func_bytes);
+
+			if (nbytes < bsize)
+				goto done;
+		}
+	}
+
+done:
+	u128_xor(dst, dst, (u128 *)walk->iv);
+	*(u128 *)walk->iv = last_iv;
+
+	return nbytes;
+}
+
+int glue_cbc_decrypt_128bit(const struct common_glue_ctx *gctx,
+			    struct blkcipher_desc *desc,
+			    struct scatterlist *dst,
+			    struct scatterlist *src, unsigned int nbytes)
+{
+	const unsigned int bsize = 128 / 8;
+	bool fpu_enabled = false;
+	struct blkcipher_walk walk;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	while ((nbytes = walk.nbytes)) {
+		fpu_enabled = glue_fpu_begin(bsize, gctx->fpu_blocks_limit,
+					     desc, fpu_enabled, nbytes);
+		nbytes = __glue_cbc_decrypt_128bit(gctx, desc, &walk);
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+
+	glue_fpu_end(fpu_enabled);
+	return err;
+}
+EXPORT_SYMBOL_GPL(glue_cbc_decrypt_128bit);
+
+static void glue_ctr_crypt_final_128bit(const common_glue_ctr_func_t fn_ctr,
+					struct blkcipher_desc *desc,
+					struct blkcipher_walk *walk)
+{
+	void *ctx = crypto_blkcipher_ctx(desc->tfm);
+	u8 *src = (u8 *)walk->src.virt.addr;
+	u8 *dst = (u8 *)walk->dst.virt.addr;
+	unsigned int nbytes = walk->nbytes;
+	u128 ctrblk;
+	u128 tmp;
+
+	be128_to_u128(&ctrblk, (be128 *)walk->iv);
+
+	memcpy(&tmp, src, nbytes);
+	fn_ctr(ctx, &tmp, &tmp, &ctrblk);
+	memcpy(dst, &tmp, nbytes);
+
+	u128_to_be128((be128 *)walk->iv, &ctrblk);
+}
+EXPORT_SYMBOL_GPL(glue_ctr_crypt_final_128bit);
+
+static unsigned int __glue_ctr_crypt_128bit(const struct common_glue_ctx *gctx,
+					    struct blkcipher_desc *desc,
+					    struct blkcipher_walk *walk)
+{
+	const unsigned int bsize = 128 / 8;
+	void *ctx = crypto_blkcipher_ctx(desc->tfm);
+	unsigned int nbytes = walk->nbytes;
+	u128 *src = (u128 *)walk->src.virt.addr;
+	u128 *dst = (u128 *)walk->dst.virt.addr;
+	u128 ctrblk;
+	unsigned int num_blocks, func_bytes;
+	unsigned int i;
+
+	be128_to_u128(&ctrblk, (be128 *)walk->iv);
+
+	/* Process multi-block batch */
+	for (i = 0; i < gctx->num_funcs; i++) {
+		num_blocks = gctx->funcs[i].num_blocks;
+		func_bytes = bsize * num_blocks;
+
+		if (nbytes >= func_bytes) {
+			do {
+				gctx->funcs[i].fn_u.ctr(ctx, dst, src, &ctrblk);
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
+	u128_to_be128((be128 *)walk->iv, &ctrblk);
+	return nbytes;
+}
+
+int glue_ctr_crypt_128bit(const struct common_glue_ctx *gctx,
+			  struct blkcipher_desc *desc, struct scatterlist *dst,
+			  struct scatterlist *src, unsigned int nbytes)
+{
+	const unsigned int bsize = 128 / 8;
+	bool fpu_enabled = false;
+	struct blkcipher_walk walk;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	err = blkcipher_walk_virt_block(desc, &walk, bsize);
+
+	while ((nbytes = walk.nbytes) >= bsize) {
+		fpu_enabled = glue_fpu_begin(bsize, gctx->fpu_blocks_limit,
+					     desc, fpu_enabled, nbytes);
+		nbytes = __glue_ctr_crypt_128bit(gctx, desc, &walk);
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+
+	glue_fpu_end(fpu_enabled);
+
+	if (walk.nbytes) {
+		glue_ctr_crypt_final_128bit(
+			gctx->funcs[gctx->num_funcs - 1].fn_u.ctr, desc, &walk);
+		err = blkcipher_walk_done(desc, &walk, 0);
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(glue_ctr_crypt_128bit);
+
+MODULE_LICENSE("GPL");
diff --git a/arch/x86/crypto/serpent_sse2_glue.c b/arch/x86/crypto/serpent_sse2_glue.c
index 8c86239..49a32ee 100644
--- a/arch/x86/crypto/serpent_sse2_glue.c
+++ b/arch/x86/crypto/serpent_sse2_glue.c
@@ -41,359 +41,9 @@
 #include <crypto/ctr.h>
 #include <crypto/lrw.h>
 #include <crypto/xts.h>
-#include <asm/i387.h>
 #include <asm/serpent-sse2.h>
 #include <asm/crypto/ablk_helper.h>
-#include <crypto/scatterwalk.h>
-#include <linux/workqueue.h>
-#include <linux/spinlock.h>
-
-typedef void (*common_glue_func_t)(void *ctx, u8 *dst, const u8 *src);
-typedef void (*common_glue_cbc_func_t)(void *ctx, u128 *dst, const u128 *src);
-typedef void (*common_glue_ctr_func_t)(void *ctx, u128 *dst, const u128 *src,
-				       u128 *iv);
-
-#define GLUE_FUNC_CAST(fn) ((common_glue_func_t)(fn))
-#define GLUE_CBC_FUNC_CAST(fn) ((common_glue_cbc_func_t)(fn))
-#define GLUE_CTR_FUNC_CAST(fn) ((common_glue_ctr_func_t)(fn))
-
-struct common_glue_func_entry {
-	unsigned int num_blocks; /* number of blocks that @fn will process */
-	union {
-		common_glue_func_t ecb;
-		common_glue_cbc_func_t cbc;
-		common_glue_ctr_func_t ctr;
-	} fn_u;
-};
-
-struct common_glue_ctx {
-	unsigned int num_funcs;
-	int fpu_blocks_limit; /* -1 means fpu not needed at all */
-
-	/*
-	 * First funcs entry must have largest num_blocks and last funcs entry
-	 * must have num_blocks == 1!
-	 */
-	struct common_glue_func_entry funcs[];
-};
-
-static inline bool glue_fpu_begin(unsigned int bsize, int fpu_blocks_limit,
-				  struct blkcipher_desc *desc,
-				  bool fpu_enabled, unsigned int nbytes)
-{
-	if (likely(fpu_blocks_limit < 0))
-		return false;
-
-	if (fpu_enabled)
-		return true;
-
-	/*
-	 * Vector-registers are only used when chunk to be processed is large
-	 * enough, so do not enable FPU until it is necessary.
-	 */
-	if (nbytes < bsize * (unsigned int)fpu_blocks_limit)
-		return false;
-
-	if (desc) {
-		/* prevent sleeping if FPU is in use */
-		desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
-	}
-
-	kernel_fpu_begin();
-	return true;
-}
-
-static inline void glue_fpu_end(bool fpu_enabled)
-{
-	if (fpu_enabled)
-		kernel_fpu_end();
-}
-
-static int __glue_ecb_crypt_128bit(const struct common_glue_ctx *gctx,
-				   struct blkcipher_desc *desc,
-				   struct blkcipher_walk *walk)
-{
-	void *ctx = crypto_blkcipher_ctx(desc->tfm);
-	const unsigned int bsize = 128 / 8;
-	unsigned int nbytes, i, func_bytes;
-	bool fpu_enabled = false;
-	int err;
-
-	err = blkcipher_walk_virt(desc, walk);
-
-	while ((nbytes = walk->nbytes)) {
-		u8 *wsrc = walk->src.virt.addr;
-		u8 *wdst = walk->dst.virt.addr;
-
-		fpu_enabled = glue_fpu_begin(bsize, gctx->fpu_blocks_limit,
-					     desc, fpu_enabled, nbytes);
-
-		for (i = 0; i < gctx->num_funcs; i++) {
-			func_bytes = bsize * gctx->funcs[i].num_blocks;
-
-			/* Process multi-block batch */
-			if (nbytes >= func_bytes) {
-				do {
-					gctx->funcs[i].fn_u.ecb(ctx, wdst,
-								wsrc);
-
-					wsrc += func_bytes;
-					wdst += func_bytes;
-					nbytes -= func_bytes;
-				} while (nbytes >= func_bytes);
-
-				if (nbytes < bsize)
-					goto done;
-			}
-		}
-
-done:
-		err = blkcipher_walk_done(desc, walk, nbytes);
-	}
-
-	glue_fpu_end(fpu_enabled);
-	return err;
-}
-
-int glue_ecb_crypt_128bit(const struct common_glue_ctx *gctx,
-			  struct blkcipher_desc *desc, struct scatterlist *dst,
-			  struct scatterlist *src, unsigned int nbytes)
-{
-	struct blkcipher_walk walk;
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return __glue_ecb_crypt_128bit(gctx, desc, &walk);
-}
-
-static unsigned int __glue_cbc_encrypt_128bit(const common_glue_func_t fn,
-					      struct blkcipher_desc *desc,
-					      struct blkcipher_walk *walk)
-{
-	void *ctx = crypto_blkcipher_ctx(desc->tfm);
-	const unsigned int bsize = 128 / 8;
-	unsigned int nbytes = walk->nbytes;
-	u128 *src = (u128 *)walk->src.virt.addr;
-	u128 *dst = (u128 *)walk->dst.virt.addr;
-	u128 *iv = (u128 *)walk->iv;
-
-	do {
-		u128_xor(dst, src, iv);
-		fn(ctx, (u8 *)dst, (u8 *)dst);
-		iv = dst;
-
-		src += 1;
-		dst += 1;
-		nbytes -= bsize;
-	} while (nbytes >= bsize);
-
-	u128_xor((u128 *)walk->iv, (u128 *)walk->iv, iv);
-	return nbytes;
-}
-
-int glue_cbc_encrypt_128bit(const common_glue_func_t fn,
-			    struct blkcipher_desc *desc,
-			    struct scatterlist *dst,
-			    struct scatterlist *src, unsigned int nbytes)
-{
-	struct blkcipher_walk walk;
-	int err;
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
-
-	while ((nbytes = walk.nbytes)) {
-		nbytes = __glue_cbc_encrypt_128bit(fn, desc, &walk);
-		err = blkcipher_walk_done(desc, &walk, nbytes);
-	}
-
-	return err;
-}
-
-static unsigned int
-__glue_cbc_decrypt_128bit(const struct common_glue_ctx *gctx,
-			  struct blkcipher_desc *desc,
-			  struct blkcipher_walk *walk)
-{
-	void *ctx = crypto_blkcipher_ctx(desc->tfm);
-	const unsigned int bsize = 128 / 8;
-	unsigned int nbytes = walk->nbytes;
-	u128 *src = (u128 *)walk->src.virt.addr;
-	u128 *dst = (u128 *)walk->dst.virt.addr;
-	u128 last_iv;
-	unsigned int num_blocks, func_bytes;
-	unsigned int i;
-
-	/* Start of the last block. */
-	src += nbytes / bsize - 1;
-	dst += nbytes / bsize - 1;
-
-	last_iv = *src;
-
-	for (i = 0; i < gctx->num_funcs; i++) {
-		num_blocks = gctx->funcs[i].num_blocks;
-		func_bytes = bsize * num_blocks;
-
-		/* Process multi-block batch */
-		if (nbytes >= func_bytes) {
-			do {
-				nbytes -= func_bytes - bsize;
-				src -= num_blocks - 1;
-				dst -= num_blocks - 1;
-
-				gctx->funcs[i].fn_u.cbc(ctx, dst, src);
-
-				nbytes -= bsize;
-				if (nbytes < bsize)
-					goto done;
-
-				u128_xor(dst, dst, src - 1);
-				src -= 1;
-				dst -= 1;
-			} while (nbytes >= func_bytes);
-
-			if (nbytes < bsize)
-				goto done;
-		}
-	}
-
-done:
-	u128_xor(dst, dst, (u128 *)walk->iv);
-	*(u128 *)walk->iv = last_iv;
-
-	return nbytes;
-}
-
-int glue_cbc_decrypt_128bit(const struct common_glue_ctx *gctx,
-			    struct blkcipher_desc *desc,
-			    struct scatterlist *dst,
-			    struct scatterlist *src, unsigned int nbytes)
-{
-	const unsigned int bsize = 128 / 8;
-	bool fpu_enabled = false;
-	struct blkcipher_walk walk;
-	int err;
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
-
-	while ((nbytes = walk.nbytes)) {
-		fpu_enabled = glue_fpu_begin(bsize, gctx->fpu_blocks_limit,
-					     desc, fpu_enabled, nbytes);
-		nbytes = __glue_cbc_decrypt_128bit(gctx, desc, &walk);
-		err = blkcipher_walk_done(desc, &walk, nbytes);
-	}
-
-	glue_fpu_end(fpu_enabled);
-	return err;
-}
-
-static inline void u128_to_be128(be128 *dst, const u128 *src)
-{
-	dst->a = cpu_to_be64(src->a);
-	dst->b = cpu_to_be64(src->b);
-}
-
-static inline void be128_to_u128(u128 *dst, const be128 *src)
-{
-	dst->a = be64_to_cpu(src->a);
-	dst->b = be64_to_cpu(src->b);
-}
-
-static inline void u128_inc(u128 *i)
-{
-	i->b++;
-	if (!i->b)
-		i->a++;
-}
-
-static void glue_ctr_crypt_final_128bit(const common_glue_ctr_func_t fn_ctr,
-					struct blkcipher_desc *desc,
-					struct blkcipher_walk *walk)
-{
-	void *ctx = crypto_blkcipher_ctx(desc->tfm);
-	u8 *src = (u8 *)walk->src.virt.addr;
-	u8 *dst = (u8 *)walk->dst.virt.addr;
-	unsigned int nbytes = walk->nbytes;
-	u128 ctrblk;
-	u128 tmp;
-
-	be128_to_u128(&ctrblk, (be128 *)walk->iv);
-
-	memcpy(&tmp, src, nbytes);
-	fn_ctr(ctx, &tmp, &tmp, &ctrblk);
-	memcpy(dst, &tmp, nbytes);
-
-	u128_to_be128((be128 *)walk->iv, &ctrblk);
-}
-
-static unsigned int __glue_ctr_crypt_128bit(const struct common_glue_ctx *gctx,
-					    struct blkcipher_desc *desc,
-					    struct blkcipher_walk *walk)
-{
-	const unsigned int bsize = 128 / 8;
-	void *ctx = crypto_blkcipher_ctx(desc->tfm);
-	unsigned int nbytes = walk->nbytes;
-	u128 *src = (u128 *)walk->src.virt.addr;
-	u128 *dst = (u128 *)walk->dst.virt.addr;
-	u128 ctrblk;
-	unsigned int num_blocks, func_bytes;
-	unsigned int i;
-
-	be128_to_u128(&ctrblk, (be128 *)walk->iv);
-
-	/* Process multi-block batch */
-	for (i = 0; i < gctx->num_funcs; i++) {
-		num_blocks = gctx->funcs[i].num_blocks;
-		func_bytes = bsize * num_blocks;
-
-		if (nbytes >= func_bytes) {
-			do {
-				gctx->funcs[i].fn_u.ctr(ctx, dst, src, &ctrblk);
-
-				src += num_blocks;
-				dst += num_blocks;
-				nbytes -= func_bytes;
-			} while (nbytes >= func_bytes);
-
-			if (nbytes < bsize)
-				goto done;
-		}
-	}
-
-done:
-	u128_to_be128((be128 *)walk->iv, &ctrblk);
-	return nbytes;
-}
-
-int glue_ctr_crypt_128bit(const struct common_glue_ctx *gctx,
-			  struct blkcipher_desc *desc, struct scatterlist *dst,
-			  struct scatterlist *src, unsigned int nbytes)
-{
-	const unsigned int bsize = 128 / 8;
-	bool fpu_enabled = false;
-	struct blkcipher_walk walk;
-	int err;
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt_block(desc, &walk, bsize);
-
-	while ((nbytes = walk.nbytes) >= bsize) {
-		fpu_enabled = glue_fpu_begin(bsize, gctx->fpu_blocks_limit,
-					     desc, fpu_enabled, nbytes);
-		nbytes = __glue_ctr_crypt_128bit(gctx, desc, &walk);
-		err = blkcipher_walk_done(desc, &walk, nbytes);
-	}
-
-	glue_fpu_end(fpu_enabled);
-
-	if (walk.nbytes) {
-		glue_ctr_crypt_final_128bit(
-			gctx->funcs[gctx->num_funcs - 1].fn_u.ctr, desc, &walk);
-		err = blkcipher_walk_done(desc, &walk, 0);
-	}
-
-	return err;
-}
+#include <asm/crypto/glue_helper.h>
 
 static void serpent_decrypt_cbc_xway(void *ctx, u128 *dst, const u128 *src)
 {
diff --git a/arch/x86/include/asm/crypto/glue_helper.h b/arch/x86/include/asm/crypto/glue_helper.h
new file mode 100644
index 0000000..3e408bd
--- /dev/null
+++ b/arch/x86/include/asm/crypto/glue_helper.h
@@ -0,0 +1,115 @@
+/*
+ * Shared glue code for 128bit block ciphers
+ */
+
+#ifndef _CRYPTO_GLUE_HELPER_H
+#define _CRYPTO_GLUE_HELPER_H
+
+#include <linux/kernel.h>
+#include <linux/crypto.h>
+#include <asm/i387.h>
+#include <crypto/b128ops.h>
+
+typedef void (*common_glue_func_t)(void *ctx, u8 *dst, const u8 *src);
+typedef void (*common_glue_cbc_func_t)(void *ctx, u128 *dst, const u128 *src);
+typedef void (*common_glue_ctr_func_t)(void *ctx, u128 *dst, const u128 *src,
+				       u128 *iv);
+
+#define GLUE_FUNC_CAST(fn) ((common_glue_func_t)(fn))
+#define GLUE_CBC_FUNC_CAST(fn) ((common_glue_cbc_func_t)(fn))
+#define GLUE_CTR_FUNC_CAST(fn) ((common_glue_ctr_func_t)(fn))
+
+struct common_glue_func_entry {
+	unsigned int num_blocks; /* number of blocks that @fn will process */
+	union {
+		common_glue_func_t ecb;
+		common_glue_cbc_func_t cbc;
+		common_glue_ctr_func_t ctr;
+	} fn_u;
+};
+
+struct common_glue_ctx {
+	unsigned int num_funcs;
+	int fpu_blocks_limit; /* -1 means fpu not needed at all */
+
+	/*
+	 * First funcs entry must have largest num_blocks and last funcs entry
+	 * must have num_blocks == 1!
+	 */
+	struct common_glue_func_entry funcs[];
+};
+
+static inline bool glue_fpu_begin(unsigned int bsize, int fpu_blocks_limit,
+				  struct blkcipher_desc *desc,
+				  bool fpu_enabled, unsigned int nbytes)
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
+	if (desc) {
+		/* prevent sleeping if FPU is in use */
+		desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	}
+
+	kernel_fpu_begin();
+	return true;
+}
+
+static inline void glue_fpu_end(bool fpu_enabled)
+{
+	if (fpu_enabled)
+		kernel_fpu_end();
+}
+
+static inline void u128_to_be128(be128 *dst, const u128 *src)
+{
+	dst->a = cpu_to_be64(src->a);
+	dst->b = cpu_to_be64(src->b);
+}
+
+static inline void be128_to_u128(u128 *dst, const be128 *src)
+{
+	dst->a = be64_to_cpu(src->a);
+	dst->b = be64_to_cpu(src->b);
+}
+
+static inline void u128_inc(u128 *i)
+{
+	i->b++;
+	if (!i->b)
+		i->a++;
+}
+
+extern int glue_ecb_crypt_128bit(const struct common_glue_ctx *gctx,
+				 struct blkcipher_desc *desc,
+				 struct scatterlist *dst,
+				 struct scatterlist *src, unsigned int nbytes);
+
+extern int glue_cbc_encrypt_128bit(const common_glue_func_t fn,
+				   struct blkcipher_desc *desc,
+				   struct scatterlist *dst,
+				   struct scatterlist *src,
+				   unsigned int nbytes);
+
+extern int glue_cbc_decrypt_128bit(const struct common_glue_ctx *gctx,
+				   struct blkcipher_desc *desc,
+				   struct scatterlist *dst,
+				   struct scatterlist *src,
+				   unsigned int nbytes);
+
+extern int glue_ctr_crypt_128bit(const struct common_glue_ctx *gctx,
+				 struct blkcipher_desc *desc,
+				 struct scatterlist *dst,
+				 struct scatterlist *src, unsigned int nbytes);
+
+#endif /* _CRYPTO_GLUE_HELPER_H */
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 471cc46..92b4697 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -179,6 +179,11 @@ config CRYPTO_ABLK_HELPER_X86
 	depends on X86
 	select CRYPTO_CRYPTD
 
+config CRYPTO_GLUE_HELPER_X86
+	tristate
+	depends on X86
+	select CRYPTO_ALGAPI
+
 comment "Authenticated Encryption with Associated Data"
 
 config CRYPTO_CCM
@@ -793,6 +798,7 @@ config CRYPTO_SERPENT_SSE2_X86_64
 	select CRYPTO_ALGAPI
 	select CRYPTO_CRYPTD
 	select CRYPTO_ABLK_HELPER_X86
+	select CRYPTO_GLUE_HELPER_X86
 	select CRYPTO_SERPENT
 	select CRYPTO_LRW
 	select CRYPTO_XTS
@@ -814,6 +820,7 @@ config CRYPTO_SERPENT_SSE2_586
 	select CRYPTO_ALGAPI
 	select CRYPTO_CRYPTD
 	select CRYPTO_ABLK_HELPER_X86
+	select CRYPTO_GLUE_HELPER_X86
 	select CRYPTO_SERPENT
 	select CRYPTO_LRW
 	select CRYPTO_XTS
