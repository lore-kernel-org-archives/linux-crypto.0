From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 12/35] crypto: padlock - Switch sha to shash
Date: Wed, 15 Jul 2009 15:16:05 +0800
Message-ID: <E1MQyij-0004zN-Ec@gondolin.me.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53626 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752605AbZGOHQI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:16:08 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyij-0004qO-U3
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:16:06 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: padlock - Switch sha to shash

This patch converts the padlock-sha implementation to shash.
In doing so the existing mechanism of storing the data until
final is no longer viable as we do not have a way of allocating
data in crypto_shash_init and then reliably freeing it.

This is just as well because a better way of handling the problem
is to hash everything but the last chunk using normal sha code
and then provide the intermediate result to the padlock device.

This is good enough because the primary application of padlock-sha
is IPsec and there the data is laid out in the form of an hmac
header followed by the rest of the packet.  In essence we can
provide all the data to the padlock as the hmac header only needs
to be hashed once.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/Kconfig       |    2 
 drivers/crypto/padlock-sha.c |  333 ++++++++++++++++++++-----------------------
 2 files changed, 156 insertions(+), 179 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 5b27692..1bb4b7f 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -13,7 +13,6 @@ if CRYPTO_HW
 config CRYPTO_DEV_PADLOCK
 	tristate "Support for VIA PadLock ACE"
 	depends on X86 && !UML
-	select CRYPTO_ALGAPI
 	help
 	  Some VIA processors come with an integrated crypto engine
 	  (so called VIA PadLock ACE, Advanced Cryptography Engine)
@@ -39,6 +38,7 @@ config CRYPTO_DEV_PADLOCK_AES
 config CRYPTO_DEV_PADLOCK_SHA
 	tristate "PadLock driver for SHA1 and SHA256 algorithms"
 	depends on CRYPTO_DEV_PADLOCK
+	select CRYPTO_HASH
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 	help
diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
index 868da54..fb6e6c3 100644
--- a/drivers/crypto/padlock-sha.c
+++ b/drivers/crypto/padlock-sha.c
@@ -24,73 +24,31 @@
 #include <asm/i387.h>
 #include "padlock.h"
 
-struct padlock_sha_ctx {
-	char		*data;
-	size_t		used;
-	int		bypass;
-	void (*f_sha_padlock)(const char *in, char *out, int count);
-	struct shash_desc *fallback;
+struct padlock_sha_desc {
+	struct shash_desc fallback;
 };
 
-static inline struct padlock_sha_ctx *ctx(struct crypto_tfm *tfm)
-{
-	return crypto_tfm_ctx(tfm);
-}
-
-/* We'll need aligned address on the stack */
-#define NEAREST_ALIGNED(ptr) \
-	((void *)ALIGN((size_t)(ptr), PADLOCK_ALIGNMENT))
-
-static struct crypto_alg sha1_alg, sha256_alg;
+struct padlock_sha_ctx {
+	struct crypto_shash *fallback;
+};
 
-static int padlock_sha_bypass(struct crypto_tfm *tfm)
+static int padlock_sha_init(struct shash_desc *desc)
 {
-	int err = 0;
-
-	if (ctx(tfm)->bypass)
-		goto out;
+	struct padlock_sha_desc *dctx = shash_desc_ctx(desc);
+	struct padlock_sha_ctx *ctx = crypto_shash_ctx(desc->tfm);
 
-	err = crypto_shash_init(ctx(tfm)->fallback);
-	if (err)
-		goto out;
-
-	if (ctx(tfm)->data && ctx(tfm)->used)
-		err = crypto_shash_update(ctx(tfm)->fallback, ctx(tfm)->data,
-					  ctx(tfm)->used);
-
-	ctx(tfm)->used = 0;
-	ctx(tfm)->bypass = 1;
-
-out:
-	return err;
+	dctx->fallback.tfm = ctx->fallback;
+	dctx->fallback.flags = desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
+	return crypto_shash_init(&dctx->fallback);
 }
 
-static void padlock_sha_init(struct crypto_tfm *tfm)
+static int padlock_sha_update(struct shash_desc *desc,
+			      const u8 *data, unsigned int length)
 {
-	ctx(tfm)->used = 0;
-	ctx(tfm)->bypass = 0;
-}
+	struct padlock_sha_desc *dctx = shash_desc_ctx(desc);
 
-static void padlock_sha_update(struct crypto_tfm *tfm,
-			const uint8_t *data, unsigned int length)
-{
-	int err;
-
-	/* Our buffer is always one page. */
-	if (unlikely(!ctx(tfm)->bypass &&
-		     (ctx(tfm)->used + length > PAGE_SIZE))) {
-		err = padlock_sha_bypass(tfm);
-		BUG_ON(err);
-	}
-
-	if (unlikely(ctx(tfm)->bypass)) {
-		err = crypto_shash_update(ctx(tfm)->fallback, data, length);
-		BUG_ON(err);
-		return;
-	}
-
-	memcpy(ctx(tfm)->data + ctx(tfm)->used, data, length);
-	ctx(tfm)->used += length;
+	dctx->fallback.flags = desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
+	return crypto_shash_update(&dctx->fallback, data, length);
 }
 
 static inline void padlock_output_block(uint32_t *src,
@@ -100,88 +58,138 @@ static inline void padlock_output_block(uint32_t *src,
 		*dst++ = swab32(*src++);
 }
 
-static void padlock_do_sha1(const char *in, char *out, int count)
+static int padlock_sha1_finup(struct shash_desc *desc, const u8 *in,
+			      unsigned int count, u8 *out)
 {
 	/* We can't store directly to *out as it may be unaligned. */
 	/* BTW Don't reduce the buffer size below 128 Bytes!
 	 *     PadLock microcode needs it that big. */
-	char buf[128+16];
-	char *result = NEAREST_ALIGNED(buf);
+	char result[128] __attribute__ ((aligned(PADLOCK_ALIGNMENT)));
+	struct padlock_sha_desc *dctx = shash_desc_ctx(desc);
+	struct sha1_state state;
+	unsigned int space;
+	unsigned int leftover;
 	int ts_state;
+	int err;
+
+	dctx->fallback.flags = desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
+	err = crypto_shash_export(&dctx->fallback, &state);
+	if (err)
+		goto out;
+
+	if (state.count + count > ULONG_MAX)
+		return crypto_shash_finup(&dctx->fallback, in, count, out);
+
+	leftover = ((state.count - 1) & (SHA1_BLOCK_SIZE - 1)) + 1;
+	space =  SHA1_BLOCK_SIZE - leftover;
+	if (space) {
+		if (count > space) {
+			err = crypto_shash_update(&dctx->fallback, in, space) ?:
+			      crypto_shash_export(&dctx->fallback, &state);
+			if (err)
+				goto out;
+			count -= space;
+			in += space;
+		} else {
+			memcpy(state.buffer + leftover, in, count);
+			in = state.buffer;
+			count += leftover;
+		}
+	}
+
+	memcpy(result, &state.state, SHA1_DIGEST_SIZE);
 
-	((uint32_t *)result)[0] = SHA1_H0;
-	((uint32_t *)result)[1] = SHA1_H1;
-	((uint32_t *)result)[2] = SHA1_H2;
-	((uint32_t *)result)[3] = SHA1_H3;
-	((uint32_t *)result)[4] = SHA1_H4;
- 
 	/* prevent taking the spurious DNA fault with padlock. */
 	ts_state = irq_ts_save();
 	asm volatile (".byte 0xf3,0x0f,0xa6,0xc8" /* rep xsha1 */
-		      : "+S"(in), "+D"(result)
-		      : "c"(count), "a"(0));
+		      : \
+		      : "c"(state.count + count), "a"(state.count), \
+			"S"(in), "D"(result));
 	irq_ts_restore(ts_state);
 
 	padlock_output_block((uint32_t *)result, (uint32_t *)out, 5);
+
+out:
+	return err;
 }
 
-static void padlock_do_sha256(const char *in, char *out, int count)
+static int padlock_sha1_final(struct shash_desc *desc, u8 *out)
+{
+	u8 buf[4];
+
+	return padlock_sha1_finup(desc, buf, 0, out);
+}
+
+static int padlock_sha256_finup(struct shash_desc *desc, const u8 *in,
+				unsigned int count, u8 *out)
 {
 	/* We can't store directly to *out as it may be unaligned. */
 	/* BTW Don't reduce the buffer size below 128 Bytes!
 	 *     PadLock microcode needs it that big. */
-	char buf[128+16];
-	char *result = NEAREST_ALIGNED(buf);
+	char result[128] __attribute__ ((aligned(PADLOCK_ALIGNMENT)));
+	struct padlock_sha_desc *dctx = shash_desc_ctx(desc);
+	struct sha256_state state;
+	unsigned int space;
+	unsigned int leftover;
 	int ts_state;
+	int err;
 
-	((uint32_t *)result)[0] = SHA256_H0;
-	((uint32_t *)result)[1] = SHA256_H1;
-	((uint32_t *)result)[2] = SHA256_H2;
-	((uint32_t *)result)[3] = SHA256_H3;
-	((uint32_t *)result)[4] = SHA256_H4;
-	((uint32_t *)result)[5] = SHA256_H5;
-	((uint32_t *)result)[6] = SHA256_H6;
-	((uint32_t *)result)[7] = SHA256_H7;
+	dctx->fallback.flags = desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
+	err = crypto_shash_export(&dctx->fallback, &state);
+	if (err)
+		goto out;
+
+	if (state.count + count > ULONG_MAX)
+		return crypto_shash_finup(&dctx->fallback, in, count, out);
+
+	leftover = ((state.count - 1) & (SHA256_BLOCK_SIZE - 1)) + 1;
+	space =  SHA256_BLOCK_SIZE - leftover;
+	if (space) {
+		if (count > space) {
+			err = crypto_shash_update(&dctx->fallback, in, space) ?:
+			      crypto_shash_export(&dctx->fallback, &state);
+			if (err)
+				goto out;
+			count -= space;
+			in += space;
+		} else {
+			memcpy(state.buf + leftover, in, count);
+			in = state.buf;
+			count += leftover;
+		}
+	}
+
+	memcpy(result, &state.state, SHA256_DIGEST_SIZE);
 
 	/* prevent taking the spurious DNA fault with padlock. */
 	ts_state = irq_ts_save();
 	asm volatile (".byte 0xf3,0x0f,0xa6,0xd0" /* rep xsha256 */
-		      : "+S"(in), "+D"(result)
-		      : "c"(count), "a"(0));
+		      : \
+		      : "c"(state.count + count), "a"(state.count), \
+			"S"(in), "D"(result));
 	irq_ts_restore(ts_state);
 
 	padlock_output_block((uint32_t *)result, (uint32_t *)out, 8);
+
+out:
+	return err;
 }
 
-static void padlock_sha_final(struct crypto_tfm *tfm, uint8_t *out)
+static int padlock_sha256_final(struct shash_desc *desc, u8 *out)
 {
-	int err;
-
-	if (unlikely(ctx(tfm)->bypass)) {
-		err = crypto_shash_final(ctx(tfm)->fallback, out);
-		BUG_ON(err);
-		ctx(tfm)->bypass = 0;
-		return;
-	}
+	u8 buf[4];
 
-	/* Pass the input buffer to PadLock microcode... */
-	ctx(tfm)->f_sha_padlock(ctx(tfm)->data, out, ctx(tfm)->used);
-
-	ctx(tfm)->used = 0;
+	return padlock_sha256_finup(desc, buf, 0, out);
 }
 
 static int padlock_cra_init(struct crypto_tfm *tfm)
 {
+	struct crypto_shash *hash = __crypto_shash_cast(tfm);
 	const char *fallback_driver_name = tfm->__crt_alg->cra_name;
+	struct padlock_sha_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct crypto_shash *fallback_tfm;
 	int err = -ENOMEM;
 
-	/* For now we'll allocate one page. This
-	 * could eventually be configurable one day. */
-	ctx(tfm)->data = (char *)__get_free_page(GFP_KERNEL);
-	if (!ctx(tfm)->data)
-		goto out;
-
 	/* Allocate a fallback and abort if it failed. */
 	fallback_tfm = crypto_alloc_shash(fallback_driver_name, 0,
 					  CRYPTO_ALG_NEED_FALLBACK);
@@ -189,94 +197,63 @@ static int padlock_cra_init(struct crypto_tfm *tfm)
 		printk(KERN_WARNING PFX "Fallback driver '%s' could not be loaded!\n",
 		       fallback_driver_name);
 		err = PTR_ERR(fallback_tfm);
-		goto out_free_page;
+		goto out;
 	}
 
-	ctx(tfm)->fallback = kmalloc(sizeof(struct shash_desc) +
-				     crypto_shash_descsize(fallback_tfm),
-				     GFP_KERNEL);
-	if (!ctx(tfm)->fallback)
-		goto out_free_tfm;
-
-	ctx(tfm)->fallback->tfm = fallback_tfm;
-	ctx(tfm)->fallback->flags = 0;
+	ctx->fallback = fallback_tfm;
+	hash->descsize += crypto_shash_descsize(fallback_tfm);
 	return 0;
 
-out_free_tfm:
-	crypto_free_shash(fallback_tfm);
-out_free_page:
-	free_page((unsigned long)(ctx(tfm)->data));
 out:
 	return err;
 }
 
-static int padlock_sha1_cra_init(struct crypto_tfm *tfm)
-{
-	ctx(tfm)->f_sha_padlock = padlock_do_sha1;
-
-	return padlock_cra_init(tfm);
-}
-
-static int padlock_sha256_cra_init(struct crypto_tfm *tfm)
-{
-	ctx(tfm)->f_sha_padlock = padlock_do_sha256;
-
-	return padlock_cra_init(tfm);
-}
-
 static void padlock_cra_exit(struct crypto_tfm *tfm)
 {
-	if (ctx(tfm)->data) {
-		free_page((unsigned long)(ctx(tfm)->data));
-		ctx(tfm)->data = NULL;
-	}
-
-	crypto_free_shash(ctx(tfm)->fallback->tfm);
+	struct padlock_sha_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	kzfree(ctx(tfm)->fallback);
+	crypto_free_shash(ctx->fallback);
 }
 
-static struct crypto_alg sha1_alg = {
-	.cra_name		=	"sha1",
-	.cra_driver_name	=	"sha1-padlock",
-	.cra_priority		=	PADLOCK_CRA_PRIORITY,
-	.cra_flags		=	CRYPTO_ALG_TYPE_DIGEST |
-					CRYPTO_ALG_NEED_FALLBACK,
-	.cra_blocksize		=	SHA1_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct padlock_sha_ctx),
-	.cra_module		=	THIS_MODULE,
-	.cra_list		=	LIST_HEAD_INIT(sha1_alg.cra_list),
-	.cra_init		=	padlock_sha1_cra_init,
-	.cra_exit		=	padlock_cra_exit,
-	.cra_u			=	{
-		.digest = {
-			.dia_digestsize	=	SHA1_DIGEST_SIZE,
-			.dia_init   	= 	padlock_sha_init,
-			.dia_update 	=	padlock_sha_update,
-			.dia_final  	=	padlock_sha_final,
-		}
+static struct shash_alg sha1_alg = {
+	.digestsize	=	SHA1_DIGEST_SIZE,
+	.init   	= 	padlock_sha_init,
+	.update 	=	padlock_sha_update,
+	.finup  	=	padlock_sha1_finup,
+	.final  	=	padlock_sha1_final,
+	.descsize	=	sizeof(struct padlock_sha_desc),
+	.base		=	{
+		.cra_name		=	"sha1",
+		.cra_driver_name	=	"sha1-padlock",
+		.cra_priority		=	PADLOCK_CRA_PRIORITY,
+		.cra_flags		=	CRYPTO_ALG_TYPE_SHASH |
+						CRYPTO_ALG_NEED_FALLBACK,
+		.cra_blocksize		=	SHA1_BLOCK_SIZE,
+		.cra_ctxsize		=	sizeof(struct padlock_sha_ctx),
+		.cra_module		=	THIS_MODULE,
+		.cra_init		=	padlock_cra_init,
+		.cra_exit		=	padlock_cra_exit,
 	}
 };
 
-static struct crypto_alg sha256_alg = {
-	.cra_name		=	"sha256",
-	.cra_driver_name	=	"sha256-padlock",
-	.cra_priority		=	PADLOCK_CRA_PRIORITY,
-	.cra_flags		=	CRYPTO_ALG_TYPE_DIGEST |
-					CRYPTO_ALG_NEED_FALLBACK,
-	.cra_blocksize		=	SHA256_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct padlock_sha_ctx),
-	.cra_module		=	THIS_MODULE,
-	.cra_list		=	LIST_HEAD_INIT(sha256_alg.cra_list),
-	.cra_init		=	padlock_sha256_cra_init,
-	.cra_exit		=	padlock_cra_exit,
-	.cra_u			=	{
-		.digest = {
-			.dia_digestsize	=	SHA256_DIGEST_SIZE,
-			.dia_init   	= 	padlock_sha_init,
-			.dia_update 	=	padlock_sha_update,
-			.dia_final  	=	padlock_sha_final,
-		}
+static struct shash_alg sha256_alg = {
+	.digestsize	=	SHA256_DIGEST_SIZE,
+	.init   	= 	padlock_sha_init,
+	.update 	=	padlock_sha_update,
+	.finup  	=	padlock_sha256_finup,
+	.final  	=	padlock_sha256_final,
+	.descsize	=	sizeof(struct padlock_sha_desc),
+	.base		=	{
+		.cra_name		=	"sha256",
+		.cra_driver_name	=	"sha256-padlock",
+		.cra_priority		=	PADLOCK_CRA_PRIORITY,
+		.cra_flags		=	CRYPTO_ALG_TYPE_SHASH |
+						CRYPTO_ALG_NEED_FALLBACK,
+		.cra_blocksize		=	SHA256_BLOCK_SIZE,
+		.cra_ctxsize		=	sizeof(struct padlock_sha_ctx),
+		.cra_module		=	THIS_MODULE,
+		.cra_init		=	padlock_cra_init,
+		.cra_exit		=	padlock_cra_exit,
 	}
 };
 
@@ -294,11 +271,11 @@ static int __init padlock_init(void)
 		return -ENODEV;
 	}
 
-	rc = crypto_register_alg(&sha1_alg);
+	rc = crypto_register_shash(&sha1_alg);
 	if (rc)
 		goto out;
 
-	rc = crypto_register_alg(&sha256_alg);
+	rc = crypto_register_shash(&sha256_alg);
 	if (rc)
 		goto out_unreg1;
 
@@ -307,7 +284,7 @@ static int __init padlock_init(void)
 	return 0;
 
 out_unreg1:
-	crypto_unregister_alg(&sha1_alg);
+	crypto_unregister_shash(&sha1_alg);
 out:
 	printk(KERN_ERR PFX "VIA PadLock SHA1/SHA256 initialization failed.\n");
 	return rc;
@@ -315,8 +292,8 @@ out:
 
 static void __exit padlock_fini(void)
 {
-	crypto_unregister_alg(&sha1_alg);
-	crypto_unregister_alg(&sha256_alg);
+	crypto_unregister_shash(&sha1_alg);
+	crypto_unregister_shash(&sha256_alg);
 }
 
 module_init(padlock_init);
