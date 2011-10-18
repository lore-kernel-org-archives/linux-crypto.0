From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 10/18] crypto: twofish-x86_64-3way: add lrw support
Date: Tue, 18 Oct 2011 13:33:02 +0300
Message-ID: <20111018103302.3074.73749.stgit@localhost6.localdomain6>
References: <20111018103208.3074.11546.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:39279 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab1JRKdH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 Oct 2011 06:33:07 -0400
In-Reply-To: <20111018103208.3074.11546.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Patch adds LRW support for twofish-x86_64-3way by using lrw_crypt(). Patch has
been tested with tcrypt and automated filesystem tests.

Tcrypt benchmarks results (twofish-3way/twofish-asm speed ratios):

Intel Celeron T1600 (fam:6, model:15, step:13):

size	lrw-enc	lrw-dec
16B	0.99x	1.00x
64B	1.17x	1.17x
256B	1.26x	1.27x
1024B	1.30x	1.31x
8192B	1.31x	1.32x

AMD Phenom II 1055T (fam:16, model:10):

size	lrw-enc	lrw-dec
16B	1.06x	1.01x
64B	1.08x	1.14x
256B	1.19x	1.20x
1024B	1.21x	1.22x
8192B	1.23x	1.24x

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/twofish_glue_3way.c |  135 +++++++++++++++++++++++++++++++++++
 crypto/twofish_common.c             |   13 ++-
 include/crypto/twofish.h            |    2 +
 3 files changed, 145 insertions(+), 5 deletions(-)

diff --git a/arch/x86/crypto/twofish_glue_3way.c b/arch/x86/crypto/twofish_glue_3way.c
index 5ede9c4..fa9151d 100644
--- a/arch/x86/crypto/twofish_glue_3way.c
+++ b/arch/x86/crypto/twofish_glue_3way.c
@@ -32,6 +32,11 @@
 #include <crypto/algapi.h>
 #include <crypto/twofish.h>
 #include <crypto/b128ops.h>
+#include <crypto/lrw.h>
+
+#if defined(CONFIG_CRYPTO_LRW) || defined(CONFIG_CRYPTO_LRW_MODULE)
+#define HAS_LRW
+#endif
 
 /* regular block cipher functions from twofish_x86_64 module */
 asmlinkage void twofish_enc_blk(struct twofish_ctx *ctx, u8 *dst,
@@ -432,6 +437,124 @@ static struct crypto_alg blk_ctr_alg = {
 	},
 };
 
+#ifdef HAS_LRW
+
+static void encrypt_callback(void *priv, u8 *srcdst, unsigned int nbytes)
+{
+	const unsigned int bsize = TF_BLOCK_SIZE;
+	struct twofish_ctx *ctx = priv;
+	int i;
+
+	if (nbytes == 3 * bsize) {
+		twofish_enc_blk_3way(ctx, srcdst, srcdst);
+		return;
+	}
+
+	for (i = 0; i < nbytes / bsize; i++, srcdst += bsize)
+		twofish_enc_blk(ctx, srcdst, srcdst);
+}
+
+static void decrypt_callback(void *priv, u8 *srcdst, unsigned int nbytes)
+{
+	const unsigned int bsize = TF_BLOCK_SIZE;
+	struct twofish_ctx *ctx = priv;
+	int i;
+
+	if (nbytes == 3 * bsize) {
+		twofish_dec_blk_3way(ctx, srcdst, srcdst);
+		return;
+	}
+
+	for (i = 0; i < nbytes / bsize; i++, srcdst += bsize)
+		twofish_dec_blk(ctx, srcdst, srcdst);
+}
+
+struct twofish_lrw_ctx {
+	struct lrw_table_ctx lrw_table;
+	struct twofish_ctx twofish_ctx;
+};
+
+static int lrw_twofish_setkey(struct crypto_tfm *tfm, const u8 *key,
+			      unsigned int keylen)
+{
+	struct twofish_lrw_ctx *ctx = crypto_tfm_ctx(tfm);
+	int err;
+
+	err = __twofish_setkey(&ctx->twofish_ctx, key, keylen - TF_BLOCK_SIZE,
+			       &tfm->crt_flags);
+	if (err)
+		return err;
+
+	return lrw_init_table(&ctx->lrw_table, key + keylen - TF_BLOCK_SIZE);
+}
+
+static int lrw_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct twofish_lrw_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	be128 buf[3];
+	struct lrw_crypt_req req = {
+		.tbuf = buf,
+		.tbuflen = sizeof(buf),
+
+		.table_ctx = &ctx->lrw_table,
+		.crypt_ctx = &ctx->twofish_ctx,
+		.crypt_fn = encrypt_callback,
+	};
+
+	return lrw_crypt(desc, dst, src, nbytes, &req);
+}
+
+static int lrw_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		       struct scatterlist *src, unsigned int nbytes)
+{
+	struct twofish_lrw_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	be128 buf[3];
+	struct lrw_crypt_req req = {
+		.tbuf = buf,
+		.tbuflen = sizeof(buf),
+
+		.table_ctx = &ctx->lrw_table,
+		.crypt_ctx = &ctx->twofish_ctx,
+		.crypt_fn = decrypt_callback,
+	};
+
+	return lrw_crypt(desc, dst, src, nbytes, &req);
+}
+
+static void lrw_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct twofish_lrw_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	lrw_free_table(&ctx->lrw_table);
+}
+
+static struct crypto_alg blk_lrw_alg = {
+	.cra_name		= "lrw(twofish)",
+	.cra_driver_name	= "lrw-twofish-3way",
+	.cra_priority		= 300,
+	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		= TF_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct twofish_lrw_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_blkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(blk_lrw_alg.cra_list),
+	.cra_exit		= lrw_exit_tfm,
+	.cra_u = {
+		.blkcipher = {
+			.min_keysize	= TF_MIN_KEY_SIZE + TF_BLOCK_SIZE,
+			.max_keysize	= TF_MAX_KEY_SIZE + TF_BLOCK_SIZE,
+			.ivsize		= TF_BLOCK_SIZE,
+			.setkey		= lrw_twofish_setkey,
+			.encrypt	= lrw_encrypt,
+			.decrypt	= lrw_decrypt,
+		},
+	},
+};
+
+#endif
+
 int __init init(void)
 {
 	int err;
@@ -445,9 +568,18 @@ int __init init(void)
 	err = crypto_register_alg(&blk_ctr_alg);
 	if (err)
 		goto ctr_err;
+#ifdef HAS_LRW
+	err = crypto_register_alg(&blk_lrw_alg);
+	if (err)
+		goto blk_lrw_err;
+#endif
 
 	return 0;
 
+#ifdef HAS_LRW
+blk_lrw_err:
+	crypto_unregister_alg(&blk_ctr_alg);
+#endif
 ctr_err:
 	crypto_unregister_alg(&blk_cbc_alg);
 cbc_err:
@@ -458,6 +590,9 @@ ecb_err:
 
 void __exit fini(void)
 {
+#ifdef HAS_LRW
+	crypto_unregister_alg(&blk_lrw_alg);
+#endif
 	crypto_unregister_alg(&blk_ctr_alg);
 	crypto_unregister_alg(&blk_cbc_alg);
 	crypto_unregister_alg(&blk_ecb_alg);
diff --git a/crypto/twofish_common.c b/crypto/twofish_common.c
index 0af216c..5f62c4f 100644
--- a/crypto/twofish_common.c
+++ b/crypto/twofish_common.c
@@ -580,12 +580,9 @@ static const u8 calc_sb_tbl[512] = {
    ctx->a[(j) + 1] = rol32(y, 9)
 
 /* Perform the key setup. */
-int twofish_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int key_len)
+int __twofish_setkey(struct twofish_ctx *ctx, const u8 *key,
+		     unsigned int key_len, u32 *flags)
 {
-
-	struct twofish_ctx *ctx = crypto_tfm_ctx(tfm);
-	u32 *flags = &tfm->crt_flags;
-
 	int i, j, k;
 
 	/* Temporaries for CALC_K. */
@@ -701,7 +698,13 @@ int twofish_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int key_len)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(__twofish_setkey);
 
+int twofish_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int key_len)
+{
+	return __twofish_setkey(crypto_tfm_ctx(tfm), key, key_len,
+				&tfm->crt_flags);
+}
 EXPORT_SYMBOL_GPL(twofish_setkey);
 
 MODULE_LICENSE("GPL");
diff --git a/include/crypto/twofish.h b/include/crypto/twofish.h
index c408522..095c901 100644
--- a/include/crypto/twofish.h
+++ b/include/crypto/twofish.h
@@ -17,6 +17,8 @@ struct twofish_ctx {
 	u32 s[4][256], w[8], k[32];
 };
 
+int __twofish_setkey(struct twofish_ctx *ctx, const u8 *key,
+		     unsigned int key_len, u32 *flags);
 int twofish_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int key_len);
 
 #endif
