From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 3/4] crypto: serpent-sse2: add lrw support
Date: Wed, 09 Nov 2011 16:26:36 +0200
Message-ID: <20111109142636.23131.19098.stgit@localhost6.localdomain6>
References: <20111109142625.23131.66808.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:46253 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab1KIO0i (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Nov 2011 09:26:38 -0500
In-Reply-To: <20111109142625.23131.66808.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Patch adds LRW support for serpent-sse2 by using lrw_crypt(). Patch has been
tested with tcrypt and automated filesystem tests.

Tcrypt benchmarks results (serpent-sse2/serpent_generic speed ratios):

Benchmark results with tcrypt:

Intel Celeron T1600 (x86_64) (fam:6, model:15, step:13):
size    lrw-enc lrw-dec
16B     1.00x   0.96x
64B     1.01x   1.01x
256B    3.01x   2.97x
1024B   3.39x   3.33x
8192B   3.35x   3.33x

AMD Phenom II 1055T (x86_64) (fam:16, model:10):
size    lrw-enc lrw-dec
16B     0.98x   1.03x
64B     1.01x   1.04x
256B    2.10x   2.14x
1024B   2.28x   2.33x
8192B   2.30x   2.33x

Intel Atom N270 (i586):
size    lrw-enc lrw-dec
16B     0.97x   0.97x
64B     1.47x   1.50x
256B    1.72x   1.69x
1024B   1.88x   1.81x
8192B   1.84x   1.79x

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/serpent_sse2_glue.c |  211 +++++++++++++++++++++++++++++++++++
 crypto/serpent.c                    |   10 +-
 include/crypto/serpent.h            |    2 
 3 files changed, 221 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/serpent_sse2_glue.c b/arch/x86/crypto/serpent_sse2_glue.c
index d3c6938..a6d8941 100644
--- a/arch/x86/crypto/serpent_sse2_glue.c
+++ b/arch/x86/crypto/serpent_sse2_glue.c
@@ -39,12 +39,17 @@
 #include <crypto/cryptd.h>
 #include <crypto/b128ops.h>
 #include <crypto/ctr.h>
+#include <crypto/lrw.h>
 #include <asm/i387.h>
 #include <asm/serpent.h>
 #include <crypto/scatterwalk.h>
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
 
+#if defined(CONFIG_CRYPTO_LRW) || defined(CONFIG_CRYPTO_LRW_MODULE)
+#define HAS_LRW
+#endif
+
 struct async_serpent_ctx {
 	struct cryptd_ablkcipher *cryptd_tfm;
 };
@@ -460,6 +465,152 @@ static struct crypto_alg blk_ctr_alg = {
 	},
 };
 
+#ifdef HAS_LRW
+
+struct crypt_priv {
+	struct serpent_ctx *ctx;
+	bool fpu_enabled;
+};
+
+static void encrypt_callback(void *priv, u8 *srcdst, unsigned int nbytes)
+{
+	const unsigned int bsize = SERPENT_BLOCK_SIZE;
+	struct crypt_priv *ctx = priv;
+	int i;
+
+	ctx->fpu_enabled = serpent_fpu_begin(ctx->fpu_enabled, nbytes);
+
+	if (nbytes == bsize * SERPENT_PARALLEL_BLOCKS) {
+		serpent_enc_blk_xway(ctx->ctx, srcdst, srcdst);
+		return;
+	}
+
+	for (i = 0; i < nbytes / bsize; i++, srcdst += bsize)
+		__serpent_encrypt(ctx->ctx, srcdst, srcdst);
+}
+
+static void decrypt_callback(void *priv, u8 *srcdst, unsigned int nbytes)
+{
+	const unsigned int bsize = SERPENT_BLOCK_SIZE;
+	struct crypt_priv *ctx = priv;
+	int i;
+
+	ctx->fpu_enabled = serpent_fpu_begin(ctx->fpu_enabled, nbytes);
+
+	if (nbytes == bsize * SERPENT_PARALLEL_BLOCKS) {
+		serpent_dec_blk_xway(ctx->ctx, srcdst, srcdst);
+		return;
+	}
+
+	for (i = 0; i < nbytes / bsize; i++, srcdst += bsize)
+		__serpent_decrypt(ctx->ctx, srcdst, srcdst);
+}
+
+struct serpent_lrw_ctx {
+	struct lrw_table_ctx lrw_table;
+	struct serpent_ctx serpent_ctx;
+};
+
+static int lrw_serpent_setkey(struct crypto_tfm *tfm, const u8 *key,
+			      unsigned int keylen)
+{
+	struct serpent_lrw_ctx *ctx = crypto_tfm_ctx(tfm);
+	int err;
+
+	err = __serpent_setkey(&ctx->serpent_ctx, key, keylen -
+							SERPENT_BLOCK_SIZE);
+	if (err)
+		return err;
+
+	return lrw_init_table(&ctx->lrw_table, key + keylen -
+						SERPENT_BLOCK_SIZE);
+}
+
+static int lrw_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct serpent_lrw_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	be128 buf[SERPENT_PARALLEL_BLOCKS];
+	struct crypt_priv crypt_ctx = {
+		.ctx = &ctx->serpent_ctx,
+		.fpu_enabled = false,
+	};
+	struct lrw_crypt_req req = {
+		.tbuf = buf,
+		.tbuflen = sizeof(buf),
+
+		.table_ctx = &ctx->lrw_table,
+		.crypt_ctx = &crypt_ctx,
+		.crypt_fn = encrypt_callback,
+	};
+	int ret;
+
+	ret = lrw_crypt(desc, dst, src, nbytes, &req);
+	serpent_fpu_end(crypt_ctx.fpu_enabled);
+
+	return ret;
+}
+
+static int lrw_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct serpent_lrw_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	be128 buf[SERPENT_PARALLEL_BLOCKS];
+	struct crypt_priv crypt_ctx = {
+		.ctx = &ctx->serpent_ctx,
+		.fpu_enabled = false,
+	};
+	struct lrw_crypt_req req = {
+		.tbuf = buf,
+		.tbuflen = sizeof(buf),
+
+		.table_ctx = &ctx->lrw_table,
+		.crypt_ctx = &crypt_ctx,
+		.crypt_fn = decrypt_callback,
+	};
+	int ret;
+
+	ret = lrw_crypt(desc, dst, src, nbytes, &req);
+	serpent_fpu_end(crypt_ctx.fpu_enabled);
+
+	return ret;
+}
+
+static void lrw_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct serpent_lrw_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	lrw_free_table(&ctx->lrw_table);
+}
+
+static struct crypto_alg blk_lrw_alg = {
+	.cra_name		= "__lrw-serpent-sse2",
+	.cra_driver_name	= "__driver-lrw-serpent-sse2",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= SERPENT_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct serpent_lrw_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(blk_lrw_alg.cra_list),
+	.cra_exit		= lrw_exit_tfm,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= SERPENT_MIN_KEY_SIZE +
+					  SERPENT_BLOCK_SIZE,
+			.max_keysize	= SERPENT_MAX_KEY_SIZE +
+					  SERPENT_BLOCK_SIZE,
+			.ivsize		= SERPENT_BLOCK_SIZE,
+			.setkey		= lrw_serpent_setkey,
+			.encrypt	= lrw_encrypt,
+			.decrypt	= lrw_decrypt,
+		},
+	},
+};
+
+#endif
+
 static int ablk_set_key(struct crypto_ablkcipher *tfm, const u8 *key,
 			unsigned int key_len)
 {
@@ -658,6 +809,48 @@ static struct crypto_alg ablk_ctr_alg = {
 	},
 };
 
+#ifdef HAS_LRW
+
+static int ablk_lrw_init(struct crypto_tfm *tfm)
+{
+	struct cryptd_ablkcipher *cryptd_tfm;
+
+	cryptd_tfm = cryptd_alloc_ablkcipher("__driver-lrw-serpent-sse2", 0, 0);
+	if (IS_ERR(cryptd_tfm))
+		return PTR_ERR(cryptd_tfm);
+	ablk_init_common(tfm, cryptd_tfm);
+	return 0;
+}
+
+static struct crypto_alg ablk_lrw_alg = {
+	.cra_name		= "lrw(serpent)",
+	.cra_driver_name	= "lrw-serpent-sse2",
+	.cra_priority		= 400,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= SERPENT_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct async_serpent_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(ablk_lrw_alg.cra_list),
+	.cra_init		= ablk_lrw_init,
+	.cra_exit		= ablk_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize	= SERPENT_MIN_KEY_SIZE +
+					  SERPENT_BLOCK_SIZE,
+			.max_keysize	= SERPENT_MAX_KEY_SIZE +
+					  SERPENT_BLOCK_SIZE,
+			.ivsize		= SERPENT_BLOCK_SIZE,
+			.setkey		= ablk_set_key,
+			.encrypt	= ablk_encrypt,
+			.decrypt	= ablk_decrypt,
+		},
+	},
+};
+
+#endif
+
 static int __init serpent_sse2_init(void)
 {
 	int err;
@@ -685,8 +878,22 @@ static int __init serpent_sse2_init(void)
 	err = crypto_register_alg(&ablk_ctr_alg);
 	if (err)
 		goto ablk_ctr_err;
+#ifdef HAS_LRW
+	err = crypto_register_alg(&blk_lrw_alg);
+	if (err)
+		goto blk_lrw_err;
+	err = crypto_register_alg(&ablk_lrw_alg);
+	if (err)
+		goto ablk_lrw_err;
+#endif
 	return err;
 
+#ifdef HAS_LRW
+ablk_lrw_err:
+	crypto_unregister_alg(&blk_lrw_alg);
+blk_lrw_err:
+	crypto_unregister_alg(&ablk_ctr_alg);
+#endif
 ablk_ctr_err:
 	crypto_unregister_alg(&ablk_cbc_alg);
 ablk_cbc_err:
@@ -703,6 +910,10 @@ blk_ecb_err:
 
 static void __exit serpent_sse2_exit(void)
 {
+#ifdef HAS_LRW
+	crypto_unregister_alg(&ablk_lrw_alg);
+	crypto_unregister_alg(&blk_lrw_alg);
+#endif
 	crypto_unregister_alg(&ablk_ctr_alg);
 	crypto_unregister_alg(&ablk_cbc_alg);
 	crypto_unregister_alg(&ablk_ecb_alg);
diff --git a/crypto/serpent.c b/crypto/serpent.c
index eb61630..7cc2cae 100644
--- a/crypto/serpent.c
+++ b/crypto/serpent.c
@@ -206,9 +206,9 @@
 	x1 ^= x4;	x3 ^= x4;	x4 &= x0;	\
 	x4 ^= x2;
 
-int serpent_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen)
+int __serpent_setkey(struct serpent_ctx *ctx, const u8 *key,
+		     unsigned int keylen)
 {
-	struct serpent_ctx *ctx = crypto_tfm_ctx(tfm);
 	u32 *k = ctx->expkey;
 	u8  *k8 = (u8 *)k;
 	u32 r0,r1,r2,r3,r4;
@@ -349,6 +349,12 @@ int serpent_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(__serpent_setkey);
+
+int serpent_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen)
+{
+	return __serpent_setkey(crypto_tfm_ctx(tfm), key, keylen);
+}
 EXPORT_SYMBOL_GPL(serpent_setkey);
 
 void __serpent_encrypt(struct serpent_ctx *ctx, u8 *dst, const u8 *src)
diff --git a/include/crypto/serpent.h b/include/crypto/serpent.h
index 40df885..b7e0941 100644
--- a/include/crypto/serpent.h
+++ b/include/crypto/serpent.h
@@ -17,6 +17,8 @@ struct serpent_ctx {
 	u32 expkey[SERPENT_EXPKEY_WORDS];
 };
 
+int __serpent_setkey(struct serpent_ctx *ctx, const u8 *key,
+		     unsigned int keylen);
 int serpent_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen);
 
 void __serpent_encrypt(struct serpent_ctx *ctx, u8 *dst, const u8 *src);
