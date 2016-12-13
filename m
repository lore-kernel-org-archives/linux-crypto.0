From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: [RFC PATCH v2] crypto: Add IV generation algorithms
Date: Tue, 13 Dec 2016 14:19:09 +0530
Message-ID: <1481618949-20086-2-git-send-email-binoy.jayan@linaro.org>
References: <1481618949-20086-1-git-send-email-binoy.jayan@linaro.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org,
        Rajendra <rnayak@codeaurora.org>,
        Binoy Jayan <binoy.jayan@linaro.org>
To: Oded <oded.golombek@arm.com>, Ofir <Ofir.Drang@arm.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1481618949-20086-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Currently, the iv generation algorithms are implemented in dm-crypt.c.
The goal is to move these algorithms from the dm layer to the kernel
crypto layer by implementing them as template ciphers so they can be
implemented in hardware for performance. As part of this patchset, the
iv-generation code is moved from the dm layer to the crypto layer and
adapt the dm-layer to send a whole 'bio' (as defined in the block layer)
at a time. Each bio contains the in memory representation of physically
contiguous disk blocks. The dm layer sets up a chained scatterlist of
these blocks split into physically contiguous segments in memory so that
DMA can be performed. The iv generation algorithms implemented in geniv.c
include plain, plain64, essiv, benbi, null, lmk and tcw.

When using multiple keys with the original dm-crypt, the key selection is
made based on the sector number as:

key_index = sector & (key_count - 1)

This restricts the usage of the same key for encrypting/decrypting a
single bio. One way to solve this is to move the key management code from
dm-crypt to cryto layer. But this seems tricky when using template ciphers
because, when multiple ciphers are instantiated from dm layer, each cipher
instance set with a unique subkey (part of the bigger master key) and
these instances themselves do not have access to each other's instances
or contexts. This way, a single instance cannot encryt/decrypt a whole bio.
This has to be fixed.

Not-signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
---
 crypto/Kconfig         |   10 +
 crypto/Makefile        |    1 +
 crypto/geniv.c         | 1294 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-crypt.c  |  894 +++++----------------------------
 include/crypto/geniv.h |   60 +++
 5 files changed, 1499 insertions(+), 760 deletions(-)
 create mode 100644 crypto/geniv.c
 create mode 100644 include/crypto/geniv.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 84d7148..dc33a33 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -326,6 +326,16 @@ config CRYPTO_CTS
 	  This mode is required for Kerberos gss mechanism support
 	  for AES encryption.
 
+config CRYPTO_GENIV
+	tristate "IV Generation for dm-crypt"
+	select CRYPTO_BLKCIPHER
+	help
+	  GENIV: IV Generation for dm-crypt
+	  Algorithms to generate Initialization Vector for ciphers
+	  used by dm-crypt.  The iv generation algorithms implemented
+	  as part of geniv include plain, plain64, essiv, benbi, null,
+	  lmk and tcw.
+
 config CRYPTO_ECB
 	tristate "ECB support"
 	select CRYPTO_BLKCIPHER
diff --git a/crypto/Makefile b/crypto/Makefile
index bd6a029..627ec76 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -75,6 +75,7 @@ obj-$(CONFIG_CRYPTO_TGR192) += tgr192.o
 obj-$(CONFIG_CRYPTO_GF128MUL) += gf128mul.o
 obj-$(CONFIG_CRYPTO_ECB) += ecb.o
 obj-$(CONFIG_CRYPTO_CBC) += cbc.o
+obj-$(CONFIG_CRYPTO_GENIV) += geniv.o
 obj-$(CONFIG_CRYPTO_PCBC) += pcbc.o
 obj-$(CONFIG_CRYPTO_CTS) += cts.o
 obj-$(CONFIG_CRYPTO_LRW) += lrw.o
diff --git a/crypto/geniv.c b/crypto/geniv.c
new file mode 100644
index 0000000..ac81a49
--- /dev/null
+++ b/crypto/geniv.c
@@ -0,0 +1,1294 @@
+/*
+ * geniv: IV generation algorithms
+ *
+ * Copyright (c) 2016, Linaro Ltd.
+ * Copyright (C) 2006-2015 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2013 Milan Broz <gmazyland@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+
+#include <crypto/algapi.h>
+#include <crypto/internal/skcipher.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/log2.h>
+#include <linux/module.h>
+#include <linux/scatterlist.h>
+#include <linux/slab.h>
+#include <linux/completion.h>
+#include <linux/crypto.h>
+#include <linux/workqueue.h>
+#include <linux/backing-dev.h>
+#include <linux/atomic.h>
+#include <linux/rbtree.h>
+#include <crypto/hash.h>
+#include <crypto/md5.h>
+#include <crypto/algapi.h>
+#include <crypto/skcipher.h>
+#include <asm/unaligned.h>
+#include <crypto/geniv.h>
+
+struct geniv_ctx;
+struct crypto_geniv_req_ctx;
+
+/* Sub request for each of the skcipher_request's for a segment */
+struct crypto_geniv_subreq {
+	struct skcipher_request req CRYPTO_MINALIGN_ATTR;
+	struct crypto_geniv_req_ctx *rctx;
+};
+
+struct crypto_geniv_req_ctx {
+	struct crypto_geniv_subreq *subreqs;
+	struct scatterlist *src;
+	struct scatterlist *dst;
+	bool is_write;
+	sector_t iv_sector;
+	unsigned int nents;
+	u8 *iv;
+	struct completion restart;
+	atomic_t req_pending;
+	struct skcipher_request *req;
+};
+
+struct geniv_operations {
+	int (*ctr)(struct geniv_ctx *ctx);
+	void (*dtr)(struct geniv_ctx *ctx);
+	int (*init)(struct geniv_ctx *ctx);
+	int (*wipe)(struct geniv_ctx *ctx);
+	int (*generator)(struct geniv_ctx *ctx,
+			 struct crypto_geniv_req_ctx *rctx, int n);
+	int (*post)(struct geniv_ctx *ctx,
+		    struct crypto_geniv_req_ctx *rctx, int n);
+};
+
+struct geniv_essiv_private {
+	struct crypto_ahash *hash_tfm;
+	u8 *salt;
+};
+
+struct geniv_benbi_private {
+	int shift;
+};
+
+struct geniv_lmk_private {
+	struct crypto_shash *hash_tfm;
+	u8 *seed;
+};
+
+struct geniv_tcw_private {
+	struct crypto_shash *crc32_tfm;
+	u8 *iv_seed;
+	u8 *whitening;
+};
+
+struct geniv_ctx {
+	struct crypto_skcipher *child;
+	unsigned int tfms_count;
+	char *ivmode;
+	unsigned int iv_size;
+	char *ivopts;
+	char *cipher;
+	struct geniv_operations *iv_gen_ops;
+	union {
+		struct geniv_essiv_private essiv;
+		struct geniv_benbi_private benbi;
+		struct geniv_lmk_private lmk;
+		struct geniv_tcw_private tcw;
+	} iv_gen_private;
+	void *iv_private;
+	struct crypto_skcipher *tfm;
+	unsigned int key_size;
+	unsigned int key_extra_size;
+	unsigned int key_parts;      /* independent parts in key buffer */
+	enum setkey_op keyop;
+	char *msg;
+	u8 *key;
+};
+
+static struct crypto_skcipher *any_tfm(struct geniv_ctx *ctx)
+{
+	return ctx->tfm;
+}
+
+static inline
+struct crypto_geniv_req_ctx *geniv_req_ctx(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	unsigned long align = crypto_skcipher_alignmask(tfm);
+
+	return (void *) PTR_ALIGN((u8 *)skcipher_request_ctx(req), align + 1);
+}
+
+static int crypt_iv_plain_gen(struct geniv_ctx *ctx,
+			      struct crypto_geniv_req_ctx *rctx, int n)
+{
+	u8 *iv = rctx->iv;
+
+	memset(iv, 0, ctx->iv_size);
+	*(__le32 *)iv = cpu_to_le32(rctx->iv_sector & 0xffffffff);
+
+	return 0;
+}
+
+static int crypt_iv_plain64_gen(struct geniv_ctx *ctx,
+				struct crypto_geniv_req_ctx *rctx, int n)
+{
+	u8 *iv = rctx->iv;
+
+	memset(iv, 0, ctx->iv_size);
+	*(__le64 *)iv = cpu_to_le64(rctx->iv_sector);
+
+	return 0;
+}
+
+/* Initialise ESSIV - compute salt but no local memory allocations */
+static int crypt_iv_essiv_init(struct geniv_ctx *ctx)
+{
+	struct geniv_essiv_private *essiv = &ctx->iv_gen_private.essiv;
+	struct scatterlist sg;
+	struct crypto_cipher *essiv_tfm;
+	int err;
+	AHASH_REQUEST_ON_STACK(req, essiv->hash_tfm);
+
+	sg_init_one(&sg, ctx->key, ctx->key_size);
+	ahash_request_set_tfm(req, essiv->hash_tfm);
+	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP, NULL, NULL);
+	ahash_request_set_crypt(req, &sg, essiv->salt, ctx->key_size);
+
+	err = crypto_ahash_digest(req);
+	ahash_request_zero(req);
+	if (err)
+		return err;
+
+	essiv_tfm = ctx->iv_private;
+
+	err = crypto_cipher_setkey(essiv_tfm, essiv->salt,
+			    crypto_ahash_digestsize(essiv->hash_tfm));
+	if (err)
+		return err;
+
+	return 0;
+}
+
+/* Wipe salt and reset key derived from volume key */
+static int crypt_iv_essiv_wipe(struct geniv_ctx *ctx)
+{
+	struct geniv_essiv_private *essiv = &ctx->iv_gen_private.essiv;
+	unsigned int salt_size = crypto_ahash_digestsize(essiv->hash_tfm);
+	struct crypto_cipher *essiv_tfm;
+	int r, err = 0;
+
+	memset(essiv->salt, 0, salt_size);
+
+	essiv_tfm = ctx->iv_private;
+	r = crypto_cipher_setkey(essiv_tfm, essiv->salt, salt_size);
+	if (r)
+		err = r;
+
+	return err;
+}
+
+/* Set up per cpu cipher state */
+static struct crypto_cipher *setup_essiv_cpu(struct geniv_ctx *ctx,
+					     u8 *salt, unsigned int saltsize)
+{
+	struct crypto_cipher *essiv_tfm;
+	int err;
+
+	/* Setup the essiv_tfm with the given salt */
+	essiv_tfm = crypto_alloc_cipher(ctx->cipher, 0, CRYPTO_ALG_ASYNC);
+
+	if (IS_ERR(essiv_tfm)) {
+		pr_err("Error allocating crypto tfm for ESSIV\n");
+		return essiv_tfm;
+	}
+
+	if (crypto_cipher_blocksize(essiv_tfm) !=
+	    crypto_skcipher_ivsize(any_tfm(ctx))) {
+		pr_err("Block size of ESSIV cipher does not match IV size of block cipher\n");
+		crypto_free_cipher(essiv_tfm);
+		return ERR_PTR(-EINVAL);
+	}
+
+	err = crypto_cipher_setkey(essiv_tfm, salt, saltsize);
+	if (err) {
+		pr_err("Failed to set key for ESSIV cipher\n");
+		crypto_free_cipher(essiv_tfm);
+		return ERR_PTR(err);
+	}
+	return essiv_tfm;
+}
+
+static void crypt_iv_essiv_dtr(struct geniv_ctx *ctx)
+{
+	struct crypto_cipher *essiv_tfm;
+	struct geniv_essiv_private *essiv = &ctx->iv_gen_private.essiv;
+
+	crypto_free_ahash(essiv->hash_tfm);
+	essiv->hash_tfm = NULL;
+
+	kzfree(essiv->salt);
+	essiv->salt = NULL;
+
+	essiv_tfm = ctx->iv_private;
+
+	if (essiv_tfm)
+		crypto_free_cipher(essiv_tfm);
+
+	ctx->iv_private = NULL;
+}
+
+static int crypt_iv_essiv_ctr(struct geniv_ctx *ctx)
+{
+	struct crypto_cipher *essiv_tfm = NULL;
+	struct crypto_ahash *hash_tfm = NULL;
+	u8 *salt = NULL;
+	int err;
+
+	if (!ctx->ivopts) {
+		pr_err("Digest algorithm missing for ESSIV mode\n");
+		return -EINVAL;
+	}
+
+	/* Allocate hash algorithm */
+	hash_tfm = crypto_alloc_ahash(ctx->ivopts, 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(hash_tfm)) {
+		err = PTR_ERR(hash_tfm);
+		pr_err("Error initializing ESSIV hash. err=%d\n", err);
+		goto bad;
+	}
+
+	salt = kzalloc(crypto_ahash_digestsize(hash_tfm), GFP_KERNEL);
+	if (!salt) {
+		err = -ENOMEM;
+		goto bad;
+	}
+
+	ctx->iv_gen_private.essiv.salt = salt;
+	ctx->iv_gen_private.essiv.hash_tfm = hash_tfm;
+
+	essiv_tfm = setup_essiv_cpu(ctx, salt,
+				crypto_ahash_digestsize(hash_tfm));
+	if (IS_ERR(essiv_tfm)) {
+		crypt_iv_essiv_dtr(ctx);
+		return PTR_ERR(essiv_tfm);
+	}
+	ctx->iv_private = essiv_tfm;
+
+	return 0;
+
+bad:
+	if (hash_tfm && !IS_ERR(hash_tfm))
+		crypto_free_ahash(hash_tfm);
+	kfree(salt);
+	return err;
+}
+
+static int crypt_iv_essiv_gen(struct geniv_ctx *ctx,
+			      struct crypto_geniv_req_ctx *rctx, int n)
+{
+	u8 *iv = rctx->iv;
+	struct crypto_cipher *essiv_tfm = ctx->iv_private;
+
+	memset(iv, 0, ctx->iv_size);
+	*(__le64 *)iv = cpu_to_le64(rctx->iv_sector);
+	crypto_cipher_encrypt_one(essiv_tfm, iv, iv);
+
+	return 0;
+}
+
+static int crypt_iv_benbi_ctr(struct geniv_ctx *ctx)
+{
+	unsigned int bs = crypto_skcipher_blocksize(any_tfm(ctx));
+	int log = ilog2(bs);
+
+	/* we need to calculate how far we must shift the sector count
+	 * to get the cipher block count, we use this shift in _gen
+	 */
+
+	if (1 << log != bs) {
+		pr_err("cypher blocksize is not a power of 2\n");
+		return -EINVAL;
+	}
+
+	if (log > 9) {
+		pr_err("cypher blocksize is > 512\n");
+		return -EINVAL;
+	}
+
+	ctx->iv_gen_private.benbi.shift = 9 - log;
+
+	return 0;
+}
+
+static int crypt_iv_benbi_gen(struct geniv_ctx *ctx,
+			      struct crypto_geniv_req_ctx *rctx, int n)
+{
+	u8 *iv = rctx->iv;
+	__be64 val;
+
+	memset(iv, 0, ctx->iv_size - sizeof(u64)); /* rest is cleared below */
+
+	val = cpu_to_be64(((u64) rctx->iv_sector <<
+			  ctx->iv_gen_private.benbi.shift) + 1);
+	put_unaligned(val, (__be64 *)(iv + ctx->iv_size - sizeof(u64)));
+
+	return 0;
+}
+
+static int crypt_iv_null_gen(struct geniv_ctx *ctx,
+			     struct crypto_geniv_req_ctx *rctx, int n)
+{
+	u8 *iv = rctx->iv;
+
+	memset(iv, 0, ctx->iv_size);
+	return 0;
+}
+
+static void crypt_iv_lmk_dtr(struct geniv_ctx *ctx)
+{
+	struct geniv_lmk_private *lmk = &ctx->iv_gen_private.lmk;
+
+	if (lmk->hash_tfm && !IS_ERR(lmk->hash_tfm))
+		crypto_free_shash(lmk->hash_tfm);
+	lmk->hash_tfm = NULL;
+
+	kzfree(lmk->seed);
+	lmk->seed = NULL;
+}
+
+static int crypt_iv_lmk_ctr(struct geniv_ctx *ctx)
+{
+	struct geniv_lmk_private *lmk = &ctx->iv_gen_private.lmk;
+
+	lmk->hash_tfm = crypto_alloc_shash("md5", 0, 0);
+	if (IS_ERR(lmk->hash_tfm)) {
+		pr_err("Error initializing LMK hash; err=%ld\n",
+				PTR_ERR(lmk->hash_tfm));
+		return PTR_ERR(lmk->hash_tfm);
+	}
+
+	/* No seed in LMK version 2 */
+	if (ctx->key_parts == ctx->tfms_count) {
+		lmk->seed = NULL;
+		return 0;
+	}
+
+	lmk->seed = kzalloc(LMK_SEED_SIZE, GFP_KERNEL);
+	if (!lmk->seed) {
+		crypt_iv_lmk_dtr(ctx);
+		pr_err("Error kmallocing seed storage in LMK\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int crypt_iv_lmk_init(struct geniv_ctx *ctx)
+{
+	struct geniv_lmk_private *lmk = &ctx->iv_gen_private.lmk;
+	int subkey_size = ctx->key_size / ctx->key_parts;
+
+	/* LMK seed is on the position of LMK_KEYS + 1 key */
+	if (lmk->seed)
+		memcpy(lmk->seed, ctx->key + (ctx->tfms_count * subkey_size),
+		       crypto_shash_digestsize(lmk->hash_tfm));
+
+	return 0;
+}
+
+static int crypt_iv_lmk_wipe(struct geniv_ctx *ctx)
+{
+	struct geniv_lmk_private *lmk = &ctx->iv_gen_private.lmk;
+
+	if (lmk->seed)
+		memset(lmk->seed, 0, LMK_SEED_SIZE);
+
+	return 0;
+}
+
+static int crypt_iv_lmk_one(struct geniv_ctx *ctx, u8 *iv,
+			    struct crypto_geniv_req_ctx *rctx, u8 *data)
+{
+	struct geniv_lmk_private *lmk = &ctx->iv_gen_private.lmk;
+	struct md5_state md5state;
+	__le32 buf[4];
+	int i, r;
+	SHASH_DESC_ON_STACK(desc, lmk->hash_tfm);
+
+	desc->tfm = lmk->hash_tfm;
+	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	r = crypto_shash_init(desc);
+	if (r)
+		return r;
+
+	if (lmk->seed) {
+		r = crypto_shash_update(desc, lmk->seed, LMK_SEED_SIZE);
+		if (r)
+			return r;
+	}
+
+	/* Sector is always 512B, block size 16, add data of blocks 1-31 */
+	r = crypto_shash_update(desc, data + 16, 16 * 31);
+	if (r)
+		return r;
+
+	/* Sector is cropped to 56 bits here */
+	buf[0] = cpu_to_le32(rctx->iv_sector & 0xFFFFFFFF);
+	buf[1] = cpu_to_le32((((u64)rctx->iv_sector >> 32) & 0x00FFFFFF)
+			     | 0x80000000);
+	buf[2] = cpu_to_le32(4024);
+	buf[3] = 0;
+	r = crypto_shash_update(desc, (u8 *)buf, sizeof(buf));
+	if (r)
+		return r;
+
+	/* No MD5 padding here */
+	r = crypto_shash_export(desc, &md5state);
+	if (r)
+		return r;
+
+	for (i = 0; i < MD5_HASH_WORDS; i++)
+		__cpu_to_le32s(&md5state.hash[i]);
+	memcpy(iv, &md5state.hash, ctx->iv_size);
+
+	return 0;
+}
+
+static int crypt_iv_lmk_gen(struct geniv_ctx *ctx,
+			    struct crypto_geniv_req_ctx *rctx, int n)
+{
+	u8 *src;
+	u8 *iv = rctx->iv;
+	int r = 0;
+
+	if (rctx->is_write) {
+		src = kmap_atomic(sg_page(&rctx->src[n]));
+		r = crypt_iv_lmk_one(ctx, iv, rctx, src + rctx->src[n].offset);
+		kunmap_atomic(src);
+	} else
+		memset(iv, 0, ctx->iv_size);
+
+	return r;
+}
+
+static int crypt_iv_lmk_post(struct geniv_ctx *ctx,
+			     struct crypto_geniv_req_ctx *rctx, int n)
+{
+	u8 *dst;
+	u8 *iv = rctx->iv;
+	int r;
+
+	if (rctx->is_write)
+		return 0;
+
+	dst = kmap_atomic(sg_page(&rctx->dst[n]));
+	r = crypt_iv_lmk_one(ctx, iv, rctx, dst + rctx->dst[n].offset);
+
+	/* Tweak the first block of plaintext sector */
+	if (!r)
+		crypto_xor(dst + rctx->dst[n].offset, iv, ctx->iv_size);
+
+	kunmap_atomic(dst);
+	return r;
+}
+
+static void crypt_iv_tcw_dtr(struct geniv_ctx *ctx)
+{
+	struct geniv_tcw_private *tcw = &ctx->iv_gen_private.tcw;
+
+	kzfree(tcw->iv_seed);
+	tcw->iv_seed = NULL;
+	kzfree(tcw->whitening);
+	tcw->whitening = NULL;
+
+	if (tcw->crc32_tfm && !IS_ERR(tcw->crc32_tfm))
+		crypto_free_shash(tcw->crc32_tfm);
+	tcw->crc32_tfm = NULL;
+}
+
+static int crypt_iv_tcw_ctr(struct geniv_ctx *ctx)
+{
+	struct geniv_tcw_private *tcw = &ctx->iv_gen_private.tcw;
+
+	if (ctx->key_size <= (ctx->iv_size + TCW_WHITENING_SIZE)) {
+		pr_err("Wrong key size (%d) for TCW. Choose a value > %d bytes\n",
+			ctx->key_size,
+			ctx->iv_size + TCW_WHITENING_SIZE);
+		return -EINVAL;
+	}
+
+	tcw->crc32_tfm = crypto_alloc_shash("crc32", 0, 0);
+	if (IS_ERR(tcw->crc32_tfm)) {
+		pr_err("Error initializing CRC32 in TCW; err=%ld\n",
+			PTR_ERR(tcw->crc32_tfm));
+		return PTR_ERR(tcw->crc32_tfm);
+	}
+
+	tcw->iv_seed = kzalloc(ctx->iv_size, GFP_KERNEL);
+	tcw->whitening = kzalloc(TCW_WHITENING_SIZE, GFP_KERNEL);
+	if (!tcw->iv_seed || !tcw->whitening) {
+		crypt_iv_tcw_dtr(ctx);
+		pr_err("Error allocating seed storage in TCW\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int crypt_iv_tcw_init(struct geniv_ctx *ctx)
+{
+	struct geniv_tcw_private *tcw = &ctx->iv_gen_private.tcw;
+	int key_offset = ctx->key_size - ctx->iv_size - TCW_WHITENING_SIZE;
+
+	memcpy(tcw->iv_seed, &ctx->key[key_offset], ctx->iv_size);
+	memcpy(tcw->whitening, &ctx->key[key_offset + ctx->iv_size],
+	       TCW_WHITENING_SIZE);
+
+	return 0;
+}
+
+static int crypt_iv_tcw_wipe(struct geniv_ctx *ctx)
+{
+	struct geniv_tcw_private *tcw = &ctx->iv_gen_private.tcw;
+
+	memset(tcw->iv_seed, 0, ctx->iv_size);
+	memset(tcw->whitening, 0, TCW_WHITENING_SIZE);
+
+	return 0;
+}
+
+static int crypt_iv_tcw_whitening(struct geniv_ctx *ctx,
+				  struct crypto_geniv_req_ctx *rctx, u8 *data)
+{
+	struct geniv_tcw_private *tcw = &ctx->iv_gen_private.tcw;
+	__le64 sector = cpu_to_le64(rctx->iv_sector);
+	u8 buf[TCW_WHITENING_SIZE];
+	int i, r;
+	SHASH_DESC_ON_STACK(desc, tcw->crc32_tfm);
+
+	/* xor whitening with sector number */
+	memcpy(buf, tcw->whitening, TCW_WHITENING_SIZE);
+	crypto_xor(buf, (u8 *)&sector, 8);
+	crypto_xor(&buf[8], (u8 *)&sector, 8);
+
+	/* calculate crc32 for every 32bit part and xor it */
+	desc->tfm = tcw->crc32_tfm;
+	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+	for (i = 0; i < 4; i++) {
+		r = crypto_shash_init(desc);
+		if (r)
+			goto out;
+		r = crypto_shash_update(desc, &buf[i * 4], 4);
+		if (r)
+			goto out;
+		r = crypto_shash_final(desc, &buf[i * 4]);
+		if (r)
+			goto out;
+	}
+	crypto_xor(&buf[0], &buf[12], 4);
+	crypto_xor(&buf[4], &buf[8], 4);
+
+	/* apply whitening (8 bytes) to whole sector */
+	for (i = 0; i < (SECTOR_SIZE / 8); i++)
+		crypto_xor(data + i * 8, buf, 8);
+out:
+	memzero_explicit(buf, sizeof(buf));
+	return r;
+}
+
+static int crypt_iv_tcw_gen(struct geniv_ctx *ctx,
+			    struct crypto_geniv_req_ctx *rctx, int n)
+{
+	u8 *iv = rctx->iv;
+	struct geniv_tcw_private *tcw = &ctx->iv_gen_private.tcw;
+	__le64 sector = cpu_to_le64(rctx->iv_sector);
+	u8 *src;
+	int r = 0;
+
+	/* Remove whitening from ciphertext */
+	if (!rctx->is_write) {
+		src = kmap_atomic(sg_page(&rctx->src[n]));
+		r = crypt_iv_tcw_whitening(ctx, rctx,
+					   src + rctx->src[n].offset);
+		kunmap_atomic(src);
+	}
+
+	/* Calculate IV */
+	memcpy(iv, tcw->iv_seed, ctx->iv_size);
+	crypto_xor(iv, (u8 *)&sector, 8);
+	if (ctx->iv_size > 8)
+		crypto_xor(&iv[8], (u8 *)&sector, ctx->iv_size - 8);
+
+	return r;
+}
+
+static int crypt_iv_tcw_post(struct geniv_ctx *ctx,
+			     struct crypto_geniv_req_ctx *rctx, int n)
+{
+	u8 *dst;
+	int r;
+
+	if (!rctx->is_write)
+		return 0;
+
+	/* Apply whitening on ciphertext */
+	dst = kmap_atomic(sg_page(&rctx->dst[n]));
+	r = crypt_iv_tcw_whitening(ctx, rctx, dst + rctx->dst[n].offset);
+	kunmap_atomic(dst);
+
+	return r;
+}
+
+static struct geniv_operations crypt_iv_plain_ops = {
+	.generator = crypt_iv_plain_gen
+};
+
+static struct geniv_operations crypt_iv_plain64_ops = {
+	.generator = crypt_iv_plain64_gen
+};
+
+static struct geniv_operations crypt_iv_essiv_ops = {
+	.ctr       = crypt_iv_essiv_ctr,
+	.dtr       = crypt_iv_essiv_dtr,
+	.init      = crypt_iv_essiv_init,
+	.wipe      = crypt_iv_essiv_wipe,
+	.generator = crypt_iv_essiv_gen
+};
+
+static struct geniv_operations crypt_iv_benbi_ops = {
+	.ctr	   = crypt_iv_benbi_ctr,
+	.generator = crypt_iv_benbi_gen
+};
+
+static struct geniv_operations crypt_iv_null_ops = {
+	.generator = crypt_iv_null_gen
+};
+
+static struct geniv_operations crypt_iv_lmk_ops = {
+	.ctr	   = crypt_iv_lmk_ctr,
+	.dtr	   = crypt_iv_lmk_dtr,
+	.init	   = crypt_iv_lmk_init,
+	.wipe	   = crypt_iv_lmk_wipe,
+	.generator = crypt_iv_lmk_gen,
+	.post	   = crypt_iv_lmk_post
+};
+
+static struct geniv_operations crypt_iv_tcw_ops = {
+	.ctr	   = crypt_iv_tcw_ctr,
+	.dtr	   = crypt_iv_tcw_dtr,
+	.init	   = crypt_iv_tcw_init,
+	.wipe	   = crypt_iv_tcw_wipe,
+	.generator = crypt_iv_tcw_gen,
+	.post	   = crypt_iv_tcw_post
+};
+
+static int geniv_setkey_set(struct geniv_ctx *ctx)
+{
+	int ret = 0;
+
+	if (ctx->iv_gen_ops && ctx->iv_gen_ops->init)
+		ret = ctx->iv_gen_ops->init(ctx);
+	return ret;
+}
+
+static int geniv_setkey_wipe(struct geniv_ctx *ctx)
+{
+	int ret = 0;
+
+	if (ctx->iv_gen_ops && ctx->iv_gen_ops->wipe) {
+		ret = ctx->iv_gen_ops->wipe(ctx);
+		if (ret)
+			return ret;
+	}
+	return ret;
+}
+
+static int geniv_setkey_init_ctx(struct geniv_ctx *ctx)
+{
+	int ret = -EINVAL;
+
+	pr_debug("IV Generation algorithm : %s\n", ctx->ivmode);
+
+	if (ctx->ivmode == NULL)
+		ctx->iv_gen_ops = NULL;
+	else if (strcmp(ctx->ivmode, "plain") == 0)
+		ctx->iv_gen_ops = &crypt_iv_plain_ops;
+	else if (strcmp(ctx->ivmode, "plain64") == 0)
+		ctx->iv_gen_ops = &crypt_iv_plain64_ops;
+	else if (strcmp(ctx->ivmode, "essiv") == 0)
+		ctx->iv_gen_ops = &crypt_iv_essiv_ops;
+	else if (strcmp(ctx->ivmode, "benbi") == 0)
+		ctx->iv_gen_ops = &crypt_iv_benbi_ops;
+	else if (strcmp(ctx->ivmode, "null") == 0)
+		ctx->iv_gen_ops = &crypt_iv_null_ops;
+	else if (strcmp(ctx->ivmode, "lmk") == 0)
+		ctx->iv_gen_ops = &crypt_iv_lmk_ops;
+	else if (strcmp(ctx->ivmode, "tcw") == 0) {
+		ctx->iv_gen_ops = &crypt_iv_tcw_ops;
+		ctx->key_parts += 2; /* IV + whitening */
+		ctx->key_extra_size = ctx->iv_size + TCW_WHITENING_SIZE;
+	} else {
+		ret = -EINVAL;
+		pr_err("Invalid IV mode %s\n", ctx->ivmode);
+		goto end;
+	}
+
+	/* Allocate IV */
+	if (ctx->iv_gen_ops && ctx->iv_gen_ops->ctr) {
+		ret = ctx->iv_gen_ops->ctr(ctx);
+		if (ret < 0) {
+			pr_err("Error creating IV for %s\n", ctx->ivmode);
+			goto end;
+		}
+	}
+
+	/* Initialize IV (set keys for ESSIV etc) */
+	if (ctx->iv_gen_ops && ctx->iv_gen_ops->init) {
+		ret = ctx->iv_gen_ops->init(ctx);
+		if (ret < 0)
+			pr_err("Error creating IV for %s\n", ctx->ivmode);
+	}
+	ret = 0;
+end:
+	return ret;
+}
+
+/* Initialize the cipher's context with the key, ivmode and other parameters.
+ * Also allocate IV generation template ciphers and initialize them.
+ */
+
+static int geniv_setkey_init(struct crypto_skcipher *parent,
+			     struct geniv_key_info *info)
+{
+	struct geniv_ctx *ctx = crypto_skcipher_ctx(parent);
+
+	ctx->tfm = parent;
+	ctx->iv_size = crypto_skcipher_ivsize(parent);
+	ctx->tfms_count = info->tfms_count;
+	ctx->cipher = info->cipher;
+	ctx->key = info->key;
+	ctx->key_size = info->key_size;
+	ctx->key_parts = info->key_parts;
+	ctx->ivmode = info->ivmode;
+	ctx->ivopts = info->ivopts;
+	return geniv_setkey_init_ctx(ctx);
+}
+
+static int crypto_geniv_setkey(struct crypto_skcipher *parent,
+				const u8 *key, unsigned int keylen)
+{
+	int err;
+	struct geniv_ctx *ctx = crypto_skcipher_ctx(parent);
+	struct crypto_skcipher *child = ctx->child;
+	struct geniv_key_info *info = (struct geniv_key_info *) key;
+
+	pr_debug("SETKEY Operation : %d\n", info->keyop);
+
+	switch (info->keyop) {
+	case SETKEY_OP_INIT:
+		err = geniv_setkey_init(parent, info);
+		break;
+	case SETKEY_OP_SET:
+		err = geniv_setkey_set(ctx);
+		break;
+	case SETKEY_OP_WIPE:
+		err = geniv_setkey_wipe(ctx);
+		break;
+	}
+
+	crypto_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(child, crypto_skcipher_get_flags(parent) &
+					 CRYPTO_TFM_REQ_MASK);
+	err = crypto_skcipher_setkey(child, info->subkey, info->subkey_size);
+	crypto_skcipher_set_flags(parent, crypto_skcipher_get_flags(child) &
+					  CRYPTO_TFM_RES_MASK);
+	return err;
+}
+
+/* Asynchronous IO completion callback for each sector in a segment. When all
+ * pending i/o are completed the parent cipher's async function is called.
+ */
+
+static void geniv_async_done(struct crypto_async_request *async_req, int error)
+{
+	struct crypto_geniv_subreq *subreq =
+		(struct crypto_geniv_subreq *) async_req->data;
+	struct crypto_geniv_req_ctx *rctx = subreq->rctx;
+	struct skcipher_request *req = rctx->req;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct geniv_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int n = subreq - rctx->subreqs;
+
+	/*
+	 * A request from crypto driver backlog is going to be processed now,
+	 * finish the completion and continue in crypt_convert().
+	 * (Callback will be called for the second time for this request.)
+	 */
+	if (error == -EINPROGRESS) {
+		complete(&rctx->restart);
+		return;
+	}
+
+	if (!error && ctx->iv_gen_ops && ctx->iv_gen_ops->post)
+		error = ctx->iv_gen_ops->post(ctx, rctx, n);
+
+	/* req_pending needs to be checked before req->base.complete is called
+	 * as we need 'req_pending' to be equal to 1 to ensure all subrequests
+	 * are processed before freeing subreq array
+	 */
+	if (!atomic_dec_and_test(&rctx->req_pending)) {
+		/* Call the parent cipher's completion function */
+		skcipher_request_complete(req, error);
+		kfree(rctx->subreqs);
+		kfree(rctx->src);
+		kfree(rctx->dst);
+	}
+}
+
+/* Split scatterlist of segments into scatterlist of sectors so that unique IVs
+ * could be generated for each 512-byte sector. This split may not be necessary
+ * for example when these ciphers are modelled in hardware, where in can make
+ * use of the hardware's IV generation capabilities.
+ */
+static unsigned int geniv_split_req(struct scatterlist *sg,
+				    struct scatterlist **sg2_ptr,
+				    unsigned int segments)
+{
+	unsigned int i, j, nents = 0, off, len;
+	struct scatterlist *sg2;
+
+	for (i = 0; i < segments ; i++)
+		nents += sg[i].length / SECTOR_SIZE;
+
+	pr_debug("geniv: splitting scatterlist with %d segments into %d ents\n",
+		 segments, nents);
+	sg2 = kcalloc(nents, sizeof(struct scatterlist), GFP_KERNEL);
+	*sg2_ptr = sg2;
+	for (i = 0, j = 0; i < segments ; i++) {
+
+		off = sg[i].offset;
+		len = sg[i].length;
+
+		for (; len > 0; j++) {
+			sg_set_page(&sg2[j], sg_page(&sg[i]), SECTOR_SIZE, off);
+			off += SECTOR_SIZE;
+			len -= SECTOR_SIZE;
+		}
+	}
+	return nents;
+}
+
+/* Common encryt/decrypt function for geniv template cipher. Before the crypto
+ * operation, it splits the memory segments (in the scatterlist) into 512 byte
+ * sectors. The initialization vector(IV) used is based on a unique sector
+ * number which is generated here.
+ */
+static inline int crypto_geniv_crypt(struct skcipher_request *req, bool encrypt)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct geniv_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct crypto_geniv_req_ctx *rctx = geniv_req_ctx(req);
+	struct crypto_geniv_subreq *subreqs;
+	struct geniv_req_info *rinfo = (struct geniv_req_info *) req->iv;
+	int i, bytes, cryptlen, ret = 0, n1, n2;
+	char *str = encrypt ? "encrypt" : "decrypt";
+
+	/* Instance of 'struct geniv_req_info' is stored in IV ptr */
+	rctx->is_write = rinfo->is_write;
+	rctx->iv_sector = rinfo->iv_sector;
+	rctx->nents = rinfo->nents;
+	rctx->iv = rinfo->iv;
+
+	pr_debug("geniv:%s: starting sector=%d, #segments=%u\n", str,
+		 (unsigned int) rctx->iv_sector, rctx->nents);
+
+	cryptlen = req->cryptlen;
+	n1 = geniv_split_req(req->src, &rctx->src, rctx->nents);
+	n2 = geniv_split_req(req->dst, &rctx->dst, rctx->nents);
+	rctx->nents = n1 > n2 ? n1 : n2;
+
+	subreqs = kcalloc(rctx->nents, sizeof(struct crypto_geniv_subreq),
+			  GFP_KERNEL);
+	rctx->subreqs = subreqs;
+	rctx->req = req;
+
+	init_completion(&rctx->restart);
+	atomic_set(&rctx->req_pending, 1);
+	for (i = 0; i < rctx->nents; i++) {
+		struct skcipher_request *subreq = &subreqs[i].req;
+
+		subreqs[i].rctx = rctx;
+		atomic_inc(&rctx->req_pending);
+		if (ctx->iv_gen_ops)
+			ret = ctx->iv_gen_ops->generator(ctx, rctx, i);
+
+		if (ret < 0) {
+			pr_err("Error in generating IV ret: %d\n", ret);
+			goto end;
+		}
+
+		skcipher_request_set_tfm(subreq, ctx->child);
+		skcipher_request_set_callback(subreq, req->base.flags,
+					      geniv_async_done, &subreqs[i]);
+
+		bytes = cryptlen < SECTOR_SIZE ? cryptlen : SECTOR_SIZE;
+
+		skcipher_request_set_crypt(subreq, &rctx->src[i],
+					   &rctx->dst[i], bytes, rctx->iv);
+		cryptlen -= bytes;
+
+		if (encrypt)
+			ret = crypto_skcipher_encrypt(subreq);
+		else
+			ret = crypto_skcipher_decrypt(subreq);
+
+
+		if (!ret && ctx->iv_gen_ops && ctx->iv_gen_ops->post)
+			ret = ctx->iv_gen_ops->post(ctx, rctx, i);
+
+		switch (ret) {
+		/*
+		 * The request was queued by a crypto driver
+		 * but the driver request queue is full, let's wait.
+		 */
+		case -EBUSY:
+			wait_for_completion(&rctx->restart);
+			reinit_completion(&rctx->restart);
+			/* fall through */
+		/*
+		 * The request is queued and processed asynchronously,
+		 * completion function geniv_async_done() is called.
+		 */
+		case -EINPROGRESS:
+			rctx->iv_sector++;
+			cond_resched();
+			break;
+		/*
+		 * The request was already processed (synchronously).
+		 */
+		case 0:
+			atomic_dec(&rctx->req_pending);
+			rctx->iv_sector++;
+			cond_resched();
+			continue;
+
+		/* There was an error while processing the request. */
+		default:
+			atomic_dec(&rctx->req_pending);
+			return ret;
+		}
+
+		if (ret)
+			break;
+	}
+
+	if (atomic_read(&rctx->req_pending) == 1) {
+		pr_debug("geniv:%s: Freeing subreq and scatterlists\n", str);
+		kfree(subreqs);
+		kfree(rctx->src);
+		kfree(rctx->dst);
+	}
+
+end:
+	return ret;
+}
+
+static int crypto_geniv_encrypt(struct skcipher_request *req)
+{
+	return crypto_geniv_crypt(req, true);
+}
+
+static int crypto_geniv_decrypt(struct skcipher_request *req)
+{
+	return crypto_geniv_crypt(req, false);
+}
+
+static int crypto_geniv_init_tfm(struct crypto_skcipher *tfm)
+{
+	struct skcipher_instance *inst = skcipher_alg_instance(tfm);
+	struct crypto_skcipher_spawn *spawn = skcipher_instance_ctx(inst);
+	struct geniv_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct crypto_skcipher *cipher;
+	unsigned long align;
+	unsigned int reqsize;
+
+	cipher = crypto_spawn_skcipher2(spawn);
+	if (IS_ERR(cipher))
+		return PTR_ERR(cipher);
+
+	ctx->child = cipher;
+
+	/* Setup the current cipher's request structure */
+	align = crypto_skcipher_alignmask(tfm);
+	align &= ~(crypto_tfm_ctx_alignment() - 1);
+	reqsize = align + sizeof(struct crypto_geniv_req_ctx) +
+		  crypto_skcipher_reqsize(cipher);
+	crypto_skcipher_set_reqsize(tfm, reqsize);
+
+	return 0;
+}
+
+static void crypto_geniv_exit_tfm(struct crypto_skcipher *tfm)
+{
+	struct geniv_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	if (ctx->iv_gen_ops && ctx->iv_gen_ops->dtr)
+		ctx->iv_gen_ops->dtr(ctx);
+
+	crypto_free_skcipher(ctx->child);
+}
+
+static void crypto_geniv_free(struct skcipher_instance *inst)
+{
+	struct crypto_skcipher_spawn *spawn = skcipher_instance_ctx(inst);
+
+	crypto_drop_skcipher(spawn);
+	kfree(inst);
+}
+
+static int crypto_geniv_create(struct crypto_template *tmpl,
+				 struct rtattr **tb, char *algname)
+{
+	struct crypto_attr_type *algt;
+	struct skcipher_instance *inst;
+	struct skcipher_alg *alg;
+	struct crypto_skcipher_spawn *spawn;
+	const char *cipher_name;
+	int err;
+
+	algt = crypto_get_attr_type(tb);
+
+	if (IS_ERR(algt))
+		return PTR_ERR(algt);
+
+	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
+		return -EINVAL;
+
+	cipher_name = crypto_attr_alg_name(tb[1]);
+
+	if (IS_ERR(cipher_name))
+		return PTR_ERR(cipher_name);
+
+	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
+	if (!inst)
+		return -ENOMEM;
+
+	spawn = skcipher_instance_ctx(inst);
+
+	crypto_set_skcipher_spawn(spawn, skcipher_crypto_instance(inst));
+	err = crypto_grab_skcipher2(spawn, cipher_name, 0,
+				    crypto_requires_sync(algt->type,
+							 algt->mask));
+
+	if (err)
+		goto err_free_inst;
+
+	alg = crypto_spawn_skcipher_alg(spawn);
+
+	/* We only support 16-byte blocks. */
+	err = -EINVAL;
+
+	if (!is_power_of_2(alg->base.cra_blocksize))
+		goto err_drop_spawn;
+
+	err = -ENAMETOOLONG;
+	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME, "%s(%s)",
+		     algname, alg->base.cra_name) >= CRYPTO_MAX_ALG_NAME)
+		goto err_drop_spawn;
+	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+		     "%s(%s)", algname, alg->base.cra_driver_name) >=
+	    CRYPTO_MAX_ALG_NAME)
+		goto err_drop_spawn;
+
+	inst->alg.base.cra_flags = CRYPTO_ALG_TYPE_BLKCIPHER;
+	inst->alg.base.cra_priority = alg->base.cra_priority;
+	inst->alg.base.cra_blocksize = alg->base.cra_blocksize;
+	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
+	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.ivsize = alg->base.cra_blocksize;
+	inst->alg.chunksize = crypto_skcipher_alg_chunksize(alg);
+	inst->alg.min_keysize = crypto_skcipher_alg_min_keysize(alg);
+	inst->alg.max_keysize = crypto_skcipher_alg_max_keysize(alg);
+
+	inst->alg.setkey = crypto_geniv_setkey;
+	inst->alg.encrypt = crypto_geniv_encrypt;
+	inst->alg.decrypt = crypto_geniv_decrypt;
+
+	inst->alg.base.cra_ctxsize = sizeof(struct geniv_ctx);
+
+	inst->alg.init = crypto_geniv_init_tfm;
+	inst->alg.exit = crypto_geniv_exit_tfm;
+
+	inst->free = crypto_geniv_free;
+
+	err = skcipher_register_instance(tmpl, inst);
+	if (err)
+		goto err_drop_spawn;
+
+out:
+	return err;
+
+err_drop_spawn:
+	crypto_drop_skcipher(spawn);
+err_free_inst:
+	kfree(inst);
+	goto out;
+}
+
+static int crypto_plain_create(struct crypto_template *tmpl,
+				struct rtattr **tb)
+{
+	return crypto_geniv_create(tmpl, tb, "plain");
+}
+
+static int crypto_plain64_create(struct crypto_template *tmpl,
+				struct rtattr **tb)
+{
+	return crypto_geniv_create(tmpl, tb, "plain64");
+}
+
+static int crypto_essiv_create(struct crypto_template *tmpl,
+				struct rtattr **tb)
+{
+	return crypto_geniv_create(tmpl, tb, "essiv");
+}
+
+static int crypto_benbi_create(struct crypto_template *tmpl,
+				struct rtattr **tb)
+{
+	return crypto_geniv_create(tmpl, tb, "benbi");
+}
+
+static int crypto_null_create(struct crypto_template *tmpl,
+				struct rtattr **tb)
+{
+	return crypto_geniv_create(tmpl, tb, "null");
+}
+
+static int crypto_lmk_create(struct crypto_template *tmpl,
+				struct rtattr **tb)
+{
+	return crypto_geniv_create(tmpl, tb, "lmk");
+}
+
+static int crypto_tcw_create(struct crypto_template *tmpl,
+				struct rtattr **tb)
+{
+	return crypto_geniv_create(tmpl, tb, "tcw");
+}
+
+static struct crypto_template crypto_plain_tmpl = {
+	.name   = "plain",
+	.create = crypto_plain_create,
+	.module = THIS_MODULE,
+};
+
+static struct crypto_template crypto_plain64_tmpl = {
+	.name   = "plain64",
+	.create = crypto_plain64_create,
+	.module = THIS_MODULE,
+};
+
+static struct crypto_template crypto_essiv_tmpl = {
+	.name   = "essiv",
+	.create = crypto_essiv_create,
+	.module = THIS_MODULE,
+};
+
+static struct crypto_template crypto_benbi_tmpl = {
+	.name   = "benbi",
+	.create = crypto_benbi_create,
+	.module = THIS_MODULE,
+};
+
+static struct crypto_template crypto_null_tmpl = {
+	.name   = "null",
+	.create = crypto_null_create,
+	.module = THIS_MODULE,
+};
+
+static struct crypto_template crypto_lmk_tmpl = {
+	.name   = "lmk",
+	.create = crypto_lmk_create,
+	.module = THIS_MODULE,
+};
+
+static struct crypto_template crypto_tcw_tmpl = {
+	.name   = "tcw",
+	.create = crypto_tcw_create,
+	.module = THIS_MODULE,
+};
+
+static int __init crypto_geniv_module_init(void)
+{
+	int err;
+
+	err = crypto_register_template(&crypto_plain_tmpl);
+	if (err)
+		goto out;
+
+	err = crypto_register_template(&crypto_plain64_tmpl);
+	if (err)
+		goto out_undo_plain;
+
+	err = crypto_register_template(&crypto_essiv_tmpl);
+	if (err)
+		goto out_undo_plain64;
+
+	err = crypto_register_template(&crypto_benbi_tmpl);
+	if (err)
+		goto out_undo_essiv;
+
+	err = crypto_register_template(&crypto_null_tmpl);
+	if (err)
+		goto out_undo_benbi;
+
+	err = crypto_register_template(&crypto_lmk_tmpl);
+	if (err)
+		goto out_undo_null;
+
+	err = crypto_register_template(&crypto_tcw_tmpl);
+	if (!err)
+		goto out;
+
+	crypto_unregister_template(&crypto_lmk_tmpl);
+out_undo_null:
+	crypto_unregister_template(&crypto_null_tmpl);
+out_undo_benbi:
+	crypto_unregister_template(&crypto_benbi_tmpl);
+out_undo_essiv:
+	crypto_unregister_template(&crypto_essiv_tmpl);
+out_undo_plain64:
+	crypto_unregister_template(&crypto_plain64_tmpl);
+out_undo_plain:
+	crypto_unregister_template(&crypto_plain_tmpl);
+out:
+	return err;
+}
+
+static void __exit crypto_geniv_module_exit(void)
+{
+	crypto_unregister_template(&crypto_plain_tmpl);
+	crypto_unregister_template(&crypto_plain64_tmpl);
+	crypto_unregister_template(&crypto_essiv_tmpl);
+	crypto_unregister_template(&crypto_benbi_tmpl);
+	crypto_unregister_template(&crypto_null_tmpl);
+	crypto_unregister_template(&crypto_lmk_tmpl);
+	crypto_unregister_template(&crypto_tcw_tmpl);
+}
+
+module_init(crypto_geniv_module_init);
+module_exit(crypto_geniv_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("IV generation algorithms");
+MODULE_ALIAS_CRYPTO("geniv");
+
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index a276883..1d565d8 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -29,10 +29,12 @@
 #include <crypto/md5.h>
 #include <crypto/algapi.h>
 #include <crypto/skcipher.h>
+#include <crypto/geniv.h>
 
 #include <linux/device-mapper.h>
 
 #define DM_MSG_PREFIX "crypt"
+#define MAX_SG_LIST 1024
 
 /*
  * context holding the current state of a multi-part conversion
@@ -67,47 +69,13 @@ struct dm_crypt_io {
 
 struct dm_crypt_request {
 	struct convert_context *ctx;
-	struct scatterlist sg_in;
-	struct scatterlist sg_out;
+	struct scatterlist *sg_in;
+	struct scatterlist *sg_out;
 	sector_t iv_sector;
 };
 
 struct crypt_config;
 
-struct crypt_iv_operations {
-	int (*ctr)(struct crypt_config *cc, struct dm_target *ti,
-		   const char *opts);
-	void (*dtr)(struct crypt_config *cc);
-	int (*init)(struct crypt_config *cc);
-	int (*wipe)(struct crypt_config *cc);
-	int (*generator)(struct crypt_config *cc, u8 *iv,
-			 struct dm_crypt_request *dmreq);
-	int (*post)(struct crypt_config *cc, u8 *iv,
-		    struct dm_crypt_request *dmreq);
-};
-
-struct iv_essiv_private {
-	struct crypto_ahash *hash_tfm;
-	u8 *salt;
-};
-
-struct iv_benbi_private {
-	int shift;
-};
-
-#define LMK_SEED_SIZE 64 /* hash + 0 */
-struct iv_lmk_private {
-	struct crypto_shash *hash_tfm;
-	u8 *seed;
-};
-
-#define TCW_WHITENING_SIZE 16
-struct iv_tcw_private {
-	struct crypto_shash *crc32_tfm;
-	u8 *iv_seed;
-	u8 *whitening;
-};
-
 /*
  * Crypt: maps a linear range of a block device
  * and encrypts / decrypts at the same time.
@@ -141,13 +109,6 @@ struct crypt_config {
 	char *cipher;
 	char *cipher_string;
 
-	struct crypt_iv_operations *iv_gen_ops;
-	union {
-		struct iv_essiv_private essiv;
-		struct iv_benbi_private benbi;
-		struct iv_lmk_private lmk;
-		struct iv_tcw_private tcw;
-	} iv_gen_private;
 	sector_t iv_offset;
 	unsigned int iv_size;
 
@@ -241,567 +202,6 @@ static struct crypto_skcipher *any_tfm(struct crypt_config *cc)
  * http://article.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/454
  */
 
-static int crypt_iv_plain_gen(struct crypt_config *cc, u8 *iv,
-			      struct dm_crypt_request *dmreq)
-{
-	memset(iv, 0, cc->iv_size);
-	*(__le32 *)iv = cpu_to_le32(dmreq->iv_sector & 0xffffffff);
-
-	return 0;
-}
-
-static int crypt_iv_plain64_gen(struct crypt_config *cc, u8 *iv,
-				struct dm_crypt_request *dmreq)
-{
-	memset(iv, 0, cc->iv_size);
-	*(__le64 *)iv = cpu_to_le64(dmreq->iv_sector);
-
-	return 0;
-}
-
-/* Initialise ESSIV - compute salt but no local memory allocations */
-static int crypt_iv_essiv_init(struct crypt_config *cc)
-{
-	struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
-	AHASH_REQUEST_ON_STACK(req, essiv->hash_tfm);
-	struct scatterlist sg;
-	struct crypto_cipher *essiv_tfm;
-	int err;
-
-	sg_init_one(&sg, cc->key, cc->key_size);
-	ahash_request_set_tfm(req, essiv->hash_tfm);
-	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP, NULL, NULL);
-	ahash_request_set_crypt(req, &sg, essiv->salt, cc->key_size);
-
-	err = crypto_ahash_digest(req);
-	ahash_request_zero(req);
-	if (err)
-		return err;
-
-	essiv_tfm = cc->iv_private;
-
-	err = crypto_cipher_setkey(essiv_tfm, essiv->salt,
-			    crypto_ahash_digestsize(essiv->hash_tfm));
-	if (err)
-		return err;
-
-	return 0;
-}
-
-/* Wipe salt and reset key derived from volume key */
-static int crypt_iv_essiv_wipe(struct crypt_config *cc)
-{
-	struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
-	unsigned salt_size = crypto_ahash_digestsize(essiv->hash_tfm);
-	struct crypto_cipher *essiv_tfm;
-	int r, err = 0;
-
-	memset(essiv->salt, 0, salt_size);
-
-	essiv_tfm = cc->iv_private;
-	r = crypto_cipher_setkey(essiv_tfm, essiv->salt, salt_size);
-	if (r)
-		err = r;
-
-	return err;
-}
-
-/* Set up per cpu cipher state */
-static struct crypto_cipher *setup_essiv_cpu(struct crypt_config *cc,
-					     struct dm_target *ti,
-					     u8 *salt, unsigned saltsize)
-{
-	struct crypto_cipher *essiv_tfm;
-	int err;
-
-	/* Setup the essiv_tfm with the given salt */
-	essiv_tfm = crypto_alloc_cipher(cc->cipher, 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(essiv_tfm)) {
-		ti->error = "Error allocating crypto tfm for ESSIV";
-		return essiv_tfm;
-	}
-
-	if (crypto_cipher_blocksize(essiv_tfm) !=
-	    crypto_skcipher_ivsize(any_tfm(cc))) {
-		ti->error = "Block size of ESSIV cipher does "
-			    "not match IV size of block cipher";
-		crypto_free_cipher(essiv_tfm);
-		return ERR_PTR(-EINVAL);
-	}
-
-	err = crypto_cipher_setkey(essiv_tfm, salt, saltsize);
-	if (err) {
-		ti->error = "Failed to set key for ESSIV cipher";
-		crypto_free_cipher(essiv_tfm);
-		return ERR_PTR(err);
-	}
-
-	return essiv_tfm;
-}
-
-static void crypt_iv_essiv_dtr(struct crypt_config *cc)
-{
-	struct crypto_cipher *essiv_tfm;
-	struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
-
-	crypto_free_ahash(essiv->hash_tfm);
-	essiv->hash_tfm = NULL;
-
-	kzfree(essiv->salt);
-	essiv->salt = NULL;
-
-	essiv_tfm = cc->iv_private;
-
-	if (essiv_tfm)
-		crypto_free_cipher(essiv_tfm);
-
-	cc->iv_private = NULL;
-}
-
-static int crypt_iv_essiv_ctr(struct crypt_config *cc, struct dm_target *ti,
-			      const char *opts)
-{
-	struct crypto_cipher *essiv_tfm = NULL;
-	struct crypto_ahash *hash_tfm = NULL;
-	u8 *salt = NULL;
-	int err;
-
-	if (!opts) {
-		ti->error = "Digest algorithm missing for ESSIV mode";
-		return -EINVAL;
-	}
-
-	/* Allocate hash algorithm */
-	hash_tfm = crypto_alloc_ahash(opts, 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(hash_tfm)) {
-		ti->error = "Error initializing ESSIV hash";
-		err = PTR_ERR(hash_tfm);
-		goto bad;
-	}
-
-	salt = kzalloc(crypto_ahash_digestsize(hash_tfm), GFP_KERNEL);
-	if (!salt) {
-		ti->error = "Error kmallocing salt storage in ESSIV";
-		err = -ENOMEM;
-		goto bad;
-	}
-
-	cc->iv_gen_private.essiv.salt = salt;
-	cc->iv_gen_private.essiv.hash_tfm = hash_tfm;
-
-	essiv_tfm = setup_essiv_cpu(cc, ti, salt,
-				crypto_ahash_digestsize(hash_tfm));
-	if (IS_ERR(essiv_tfm)) {
-		crypt_iv_essiv_dtr(cc);
-		return PTR_ERR(essiv_tfm);
-	}
-	cc->iv_private = essiv_tfm;
-
-	return 0;
-
-bad:
-	if (hash_tfm && !IS_ERR(hash_tfm))
-		crypto_free_ahash(hash_tfm);
-	kfree(salt);
-	return err;
-}
-
-static int crypt_iv_essiv_gen(struct crypt_config *cc, u8 *iv,
-			      struct dm_crypt_request *dmreq)
-{
-	struct crypto_cipher *essiv_tfm = cc->iv_private;
-
-	memset(iv, 0, cc->iv_size);
-	*(__le64 *)iv = cpu_to_le64(dmreq->iv_sector);
-	crypto_cipher_encrypt_one(essiv_tfm, iv, iv);
-
-	return 0;
-}
-
-static int crypt_iv_benbi_ctr(struct crypt_config *cc, struct dm_target *ti,
-			      const char *opts)
-{
-	unsigned bs = crypto_skcipher_blocksize(any_tfm(cc));
-	int log = ilog2(bs);
-
-	/* we need to calculate how far we must shift the sector count
-	 * to get the cipher block count, we use this shift in _gen */
-
-	if (1 << log != bs) {
-		ti->error = "cypher blocksize is not a power of 2";
-		return -EINVAL;
-	}
-
-	if (log > 9) {
-		ti->error = "cypher blocksize is > 512";
-		return -EINVAL;
-	}
-
-	cc->iv_gen_private.benbi.shift = 9 - log;
-
-	return 0;
-}
-
-static void crypt_iv_benbi_dtr(struct crypt_config *cc)
-{
-}
-
-static int crypt_iv_benbi_gen(struct crypt_config *cc, u8 *iv,
-			      struct dm_crypt_request *dmreq)
-{
-	__be64 val;
-
-	memset(iv, 0, cc->iv_size - sizeof(u64)); /* rest is cleared below */
-
-	val = cpu_to_be64(((u64)dmreq->iv_sector << cc->iv_gen_private.benbi.shift) + 1);
-	put_unaligned(val, (__be64 *)(iv + cc->iv_size - sizeof(u64)));
-
-	return 0;
-}
-
-static int crypt_iv_null_gen(struct crypt_config *cc, u8 *iv,
-			     struct dm_crypt_request *dmreq)
-{
-	memset(iv, 0, cc->iv_size);
-
-	return 0;
-}
-
-static void crypt_iv_lmk_dtr(struct crypt_config *cc)
-{
-	struct iv_lmk_private *lmk = &cc->iv_gen_private.lmk;
-
-	if (lmk->hash_tfm && !IS_ERR(lmk->hash_tfm))
-		crypto_free_shash(lmk->hash_tfm);
-	lmk->hash_tfm = NULL;
-
-	kzfree(lmk->seed);
-	lmk->seed = NULL;
-}
-
-static int crypt_iv_lmk_ctr(struct crypt_config *cc, struct dm_target *ti,
-			    const char *opts)
-{
-	struct iv_lmk_private *lmk = &cc->iv_gen_private.lmk;
-
-	lmk->hash_tfm = crypto_alloc_shash("md5", 0, 0);
-	if (IS_ERR(lmk->hash_tfm)) {
-		ti->error = "Error initializing LMK hash";
-		return PTR_ERR(lmk->hash_tfm);
-	}
-
-	/* No seed in LMK version 2 */
-	if (cc->key_parts == cc->tfms_count) {
-		lmk->seed = NULL;
-		return 0;
-	}
-
-	lmk->seed = kzalloc(LMK_SEED_SIZE, GFP_KERNEL);
-	if (!lmk->seed) {
-		crypt_iv_lmk_dtr(cc);
-		ti->error = "Error kmallocing seed storage in LMK";
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
-static int crypt_iv_lmk_init(struct crypt_config *cc)
-{
-	struct iv_lmk_private *lmk = &cc->iv_gen_private.lmk;
-	int subkey_size = cc->key_size / cc->key_parts;
-
-	/* LMK seed is on the position of LMK_KEYS + 1 key */
-	if (lmk->seed)
-		memcpy(lmk->seed, cc->key + (cc->tfms_count * subkey_size),
-		       crypto_shash_digestsize(lmk->hash_tfm));
-
-	return 0;
-}
-
-static int crypt_iv_lmk_wipe(struct crypt_config *cc)
-{
-	struct iv_lmk_private *lmk = &cc->iv_gen_private.lmk;
-
-	if (lmk->seed)
-		memset(lmk->seed, 0, LMK_SEED_SIZE);
-
-	return 0;
-}
-
-static int crypt_iv_lmk_one(struct crypt_config *cc, u8 *iv,
-			    struct dm_crypt_request *dmreq,
-			    u8 *data)
-{
-	struct iv_lmk_private *lmk = &cc->iv_gen_private.lmk;
-	SHASH_DESC_ON_STACK(desc, lmk->hash_tfm);
-	struct md5_state md5state;
-	__le32 buf[4];
-	int i, r;
-
-	desc->tfm = lmk->hash_tfm;
-	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
-
-	r = crypto_shash_init(desc);
-	if (r)
-		return r;
-
-	if (lmk->seed) {
-		r = crypto_shash_update(desc, lmk->seed, LMK_SEED_SIZE);
-		if (r)
-			return r;
-	}
-
-	/* Sector is always 512B, block size 16, add data of blocks 1-31 */
-	r = crypto_shash_update(desc, data + 16, 16 * 31);
-	if (r)
-		return r;
-
-	/* Sector is cropped to 56 bits here */
-	buf[0] = cpu_to_le32(dmreq->iv_sector & 0xFFFFFFFF);
-	buf[1] = cpu_to_le32((((u64)dmreq->iv_sector >> 32) & 0x00FFFFFF) | 0x80000000);
-	buf[2] = cpu_to_le32(4024);
-	buf[3] = 0;
-	r = crypto_shash_update(desc, (u8 *)buf, sizeof(buf));
-	if (r)
-		return r;
-
-	/* No MD5 padding here */
-	r = crypto_shash_export(desc, &md5state);
-	if (r)
-		return r;
-
-	for (i = 0; i < MD5_HASH_WORDS; i++)
-		__cpu_to_le32s(&md5state.hash[i]);
-	memcpy(iv, &md5state.hash, cc->iv_size);
-
-	return 0;
-}
-
-static int crypt_iv_lmk_gen(struct crypt_config *cc, u8 *iv,
-			    struct dm_crypt_request *dmreq)
-{
-	u8 *src;
-	int r = 0;
-
-	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE) {
-		src = kmap_atomic(sg_page(&dmreq->sg_in));
-		r = crypt_iv_lmk_one(cc, iv, dmreq, src + dmreq->sg_in.offset);
-		kunmap_atomic(src);
-	} else
-		memset(iv, 0, cc->iv_size);
-
-	return r;
-}
-
-static int crypt_iv_lmk_post(struct crypt_config *cc, u8 *iv,
-			     struct dm_crypt_request *dmreq)
-{
-	u8 *dst;
-	int r;
-
-	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE)
-		return 0;
-
-	dst = kmap_atomic(sg_page(&dmreq->sg_out));
-	r = crypt_iv_lmk_one(cc, iv, dmreq, dst + dmreq->sg_out.offset);
-
-	/* Tweak the first block of plaintext sector */
-	if (!r)
-		crypto_xor(dst + dmreq->sg_out.offset, iv, cc->iv_size);
-
-	kunmap_atomic(dst);
-	return r;
-}
-
-static void crypt_iv_tcw_dtr(struct crypt_config *cc)
-{
-	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
-
-	kzfree(tcw->iv_seed);
-	tcw->iv_seed = NULL;
-	kzfree(tcw->whitening);
-	tcw->whitening = NULL;
-
-	if (tcw->crc32_tfm && !IS_ERR(tcw->crc32_tfm))
-		crypto_free_shash(tcw->crc32_tfm);
-	tcw->crc32_tfm = NULL;
-}
-
-static int crypt_iv_tcw_ctr(struct crypt_config *cc, struct dm_target *ti,
-			    const char *opts)
-{
-	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
-
-	if (cc->key_size <= (cc->iv_size + TCW_WHITENING_SIZE)) {
-		ti->error = "Wrong key size for TCW";
-		return -EINVAL;
-	}
-
-	tcw->crc32_tfm = crypto_alloc_shash("crc32", 0, 0);
-	if (IS_ERR(tcw->crc32_tfm)) {
-		ti->error = "Error initializing CRC32 in TCW";
-		return PTR_ERR(tcw->crc32_tfm);
-	}
-
-	tcw->iv_seed = kzalloc(cc->iv_size, GFP_KERNEL);
-	tcw->whitening = kzalloc(TCW_WHITENING_SIZE, GFP_KERNEL);
-	if (!tcw->iv_seed || !tcw->whitening) {
-		crypt_iv_tcw_dtr(cc);
-		ti->error = "Error allocating seed storage in TCW";
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
-static int crypt_iv_tcw_init(struct crypt_config *cc)
-{
-	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
-	int key_offset = cc->key_size - cc->iv_size - TCW_WHITENING_SIZE;
-
-	memcpy(tcw->iv_seed, &cc->key[key_offset], cc->iv_size);
-	memcpy(tcw->whitening, &cc->key[key_offset + cc->iv_size],
-	       TCW_WHITENING_SIZE);
-
-	return 0;
-}
-
-static int crypt_iv_tcw_wipe(struct crypt_config *cc)
-{
-	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
-
-	memset(tcw->iv_seed, 0, cc->iv_size);
-	memset(tcw->whitening, 0, TCW_WHITENING_SIZE);
-
-	return 0;
-}
-
-static int crypt_iv_tcw_whitening(struct crypt_config *cc,
-				  struct dm_crypt_request *dmreq,
-				  u8 *data)
-{
-	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
-	__le64 sector = cpu_to_le64(dmreq->iv_sector);
-	u8 buf[TCW_WHITENING_SIZE];
-	SHASH_DESC_ON_STACK(desc, tcw->crc32_tfm);
-	int i, r;
-
-	/* xor whitening with sector number */
-	memcpy(buf, tcw->whitening, TCW_WHITENING_SIZE);
-	crypto_xor(buf, (u8 *)&sector, 8);
-	crypto_xor(&buf[8], (u8 *)&sector, 8);
-
-	/* calculate crc32 for every 32bit part and xor it */
-	desc->tfm = tcw->crc32_tfm;
-	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
-	for (i = 0; i < 4; i++) {
-		r = crypto_shash_init(desc);
-		if (r)
-			goto out;
-		r = crypto_shash_update(desc, &buf[i * 4], 4);
-		if (r)
-			goto out;
-		r = crypto_shash_final(desc, &buf[i * 4]);
-		if (r)
-			goto out;
-	}
-	crypto_xor(&buf[0], &buf[12], 4);
-	crypto_xor(&buf[4], &buf[8], 4);
-
-	/* apply whitening (8 bytes) to whole sector */
-	for (i = 0; i < ((1 << SECTOR_SHIFT) / 8); i++)
-		crypto_xor(data + i * 8, buf, 8);
-out:
-	memzero_explicit(buf, sizeof(buf));
-	return r;
-}
-
-static int crypt_iv_tcw_gen(struct crypt_config *cc, u8 *iv,
-			    struct dm_crypt_request *dmreq)
-{
-	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
-	__le64 sector = cpu_to_le64(dmreq->iv_sector);
-	u8 *src;
-	int r = 0;
-
-	/* Remove whitening from ciphertext */
-	if (bio_data_dir(dmreq->ctx->bio_in) != WRITE) {
-		src = kmap_atomic(sg_page(&dmreq->sg_in));
-		r = crypt_iv_tcw_whitening(cc, dmreq, src + dmreq->sg_in.offset);
-		kunmap_atomic(src);
-	}
-
-	/* Calculate IV */
-	memcpy(iv, tcw->iv_seed, cc->iv_size);
-	crypto_xor(iv, (u8 *)&sector, 8);
-	if (cc->iv_size > 8)
-		crypto_xor(&iv[8], (u8 *)&sector, cc->iv_size - 8);
-
-	return r;
-}
-
-static int crypt_iv_tcw_post(struct crypt_config *cc, u8 *iv,
-			     struct dm_crypt_request *dmreq)
-{
-	u8 *dst;
-	int r;
-
-	if (bio_data_dir(dmreq->ctx->bio_in) != WRITE)
-		return 0;
-
-	/* Apply whitening on ciphertext */
-	dst = kmap_atomic(sg_page(&dmreq->sg_out));
-	r = crypt_iv_tcw_whitening(cc, dmreq, dst + dmreq->sg_out.offset);
-	kunmap_atomic(dst);
-
-	return r;
-}
-
-static struct crypt_iv_operations crypt_iv_plain_ops = {
-	.generator = crypt_iv_plain_gen
-};
-
-static struct crypt_iv_operations crypt_iv_plain64_ops = {
-	.generator = crypt_iv_plain64_gen
-};
-
-static struct crypt_iv_operations crypt_iv_essiv_ops = {
-	.ctr       = crypt_iv_essiv_ctr,
-	.dtr       = crypt_iv_essiv_dtr,
-	.init      = crypt_iv_essiv_init,
-	.wipe      = crypt_iv_essiv_wipe,
-	.generator = crypt_iv_essiv_gen
-};
-
-static struct crypt_iv_operations crypt_iv_benbi_ops = {
-	.ctr	   = crypt_iv_benbi_ctr,
-	.dtr	   = crypt_iv_benbi_dtr,
-	.generator = crypt_iv_benbi_gen
-};
-
-static struct crypt_iv_operations crypt_iv_null_ops = {
-	.generator = crypt_iv_null_gen
-};
-
-static struct crypt_iv_operations crypt_iv_lmk_ops = {
-	.ctr	   = crypt_iv_lmk_ctr,
-	.dtr	   = crypt_iv_lmk_dtr,
-	.init	   = crypt_iv_lmk_init,
-	.wipe	   = crypt_iv_lmk_wipe,
-	.generator = crypt_iv_lmk_gen,
-	.post	   = crypt_iv_lmk_post
-};
-
-static struct crypt_iv_operations crypt_iv_tcw_ops = {
-	.ctr	   = crypt_iv_tcw_ctr,
-	.dtr	   = crypt_iv_tcw_dtr,
-	.init	   = crypt_iv_tcw_init,
-	.wipe	   = crypt_iv_tcw_wipe,
-	.generator = crypt_iv_tcw_gen,
-	.post	   = crypt_iv_tcw_post
-};
-
 static void crypt_convert_init(struct crypt_config *cc,
 			       struct convert_context *ctx,
 			       struct bio *bio_out, struct bio *bio_in,
@@ -836,52 +236,6 @@ static u8 *iv_of_dmreq(struct crypt_config *cc,
 		crypto_skcipher_alignmask(any_tfm(cc)) + 1);
 }
 
-static int crypt_convert_block(struct crypt_config *cc,
-			       struct convert_context *ctx,
-			       struct skcipher_request *req)
-{
-	struct bio_vec bv_in = bio_iter_iovec(ctx->bio_in, ctx->iter_in);
-	struct bio_vec bv_out = bio_iter_iovec(ctx->bio_out, ctx->iter_out);
-	struct dm_crypt_request *dmreq;
-	u8 *iv;
-	int r;
-
-	dmreq = dmreq_of_req(cc, req);
-	iv = iv_of_dmreq(cc, dmreq);
-
-	dmreq->iv_sector = ctx->cc_sector;
-	dmreq->ctx = ctx;
-	sg_init_table(&dmreq->sg_in, 1);
-	sg_set_page(&dmreq->sg_in, bv_in.bv_page, 1 << SECTOR_SHIFT,
-		    bv_in.bv_offset);
-
-	sg_init_table(&dmreq->sg_out, 1);
-	sg_set_page(&dmreq->sg_out, bv_out.bv_page, 1 << SECTOR_SHIFT,
-		    bv_out.bv_offset);
-
-	bio_advance_iter(ctx->bio_in, &ctx->iter_in, 1 << SECTOR_SHIFT);
-	bio_advance_iter(ctx->bio_out, &ctx->iter_out, 1 << SECTOR_SHIFT);
-
-	if (cc->iv_gen_ops) {
-		r = cc->iv_gen_ops->generator(cc, iv, dmreq);
-		if (r < 0)
-			return r;
-	}
-
-	skcipher_request_set_crypt(req, &dmreq->sg_in, &dmreq->sg_out,
-				   1 << SECTOR_SHIFT, iv);
-
-	if (bio_data_dir(ctx->bio_in) == WRITE)
-		r = crypto_skcipher_encrypt(req);
-	else
-		r = crypto_skcipher_decrypt(req);
-
-	if (!r && cc->iv_gen_ops && cc->iv_gen_ops->post)
-		r = cc->iv_gen_ops->post(cc, iv, dmreq);
-
-	return r;
-}
-
 static void kcryptd_async_done(struct crypto_async_request *async_req,
 			       int error);
 
@@ -916,57 +270,94 @@ static void crypt_free_req(struct crypt_config *cc,
 /*
  * Encrypt / decrypt data from one bio to another one (can be the same one)
  */
-static int crypt_convert(struct crypt_config *cc,
-			 struct convert_context *ctx)
+
+static int crypt_convert_bio(struct crypt_config *cc,
+			     struct convert_context *ctx)
 {
+	unsigned int cryptlen, n1, n2, nents, i = 0, bytes = 0;
+	struct skcipher_request *req;
+	struct dm_crypt_request *dmreq;
+	struct geniv_req_info rinfo;
+	struct bio_vec bv_in, bv_out;
 	int r;
+	u8 *iv;
 
 	atomic_set(&ctx->cc_pending, 1);
+	crypt_alloc_req(cc, ctx);
 
-	while (ctx->iter_in.bi_size && ctx->iter_out.bi_size) {
+	req = ctx->req;
+	dmreq = dmreq_of_req(cc, req);
+	iv = iv_of_dmreq(cc, dmreq);
 
-		crypt_alloc_req(cc, ctx);
+	n1 = bio_segments(ctx->bio_in);
+	n2 = bio_segments(ctx->bio_in);
+	nents = n1 > n2 ? n1 : n2;
+	nents = nents > MAX_SG_LIST ? MAX_SG_LIST : nents;
+	cryptlen = ctx->iter_in.bi_size;
 
-		atomic_inc(&ctx->cc_pending);
+	DMDEBUG("dm-crypt:%s: segments:[in=%u, out=%u] bi_size=%u\n",
+		bio_data_dir(ctx->bio_in) == WRITE ? "write" : "read",
+		n1, n2, cryptlen);
 
-		r = crypt_convert_block(cc, ctx, ctx->req);
+	dmreq->sg_in  = kcalloc(nents, sizeof(struct scatterlist), GFP_KERNEL);
+	dmreq->sg_out = kcalloc(nents, sizeof(struct scatterlist), GFP_KERNEL);
 
-		switch (r) {
-		/*
-		 * The request was queued by a crypto driver
-		 * but the driver request queue is full, let's wait.
-		 */
-		case -EBUSY:
-			wait_for_completion(&ctx->restart);
-			reinit_completion(&ctx->restart);
-			/* fall through */
-		/*
-		 * The request is queued and processed asynchronously,
-		 * completion function kcryptd_async_done() will be called.
-		 */
-		case -EINPROGRESS:
-			ctx->req = NULL;
-			ctx->cc_sector++;
-			continue;
-		/*
-		 * The request was already processed (synchronously).
-		 */
-		case 0:
-			atomic_dec(&ctx->cc_pending);
-			ctx->cc_sector++;
-			cond_resched();
-			continue;
-
-		/* There was an error while processing the request. */
-		default:
-			atomic_dec(&ctx->cc_pending);
-			return r;
-		}
+	dmreq->ctx = ctx;
+
+	sg_init_table(dmreq->sg_in, nents);
+	sg_init_table(dmreq->sg_out, nents);
+
+	while (ctx->iter_in.bi_size && ctx->iter_out.bi_size && i < nents) {
+		bv_in = bio_iter_iovec(ctx->bio_in, ctx->iter_in);
+		bv_out = bio_iter_iovec(ctx->bio_out, ctx->iter_out);
+
+		sg_set_page(&dmreq->sg_in[i], bv_in.bv_page, bv_in.bv_len,
+			    bv_in.bv_offset);
+		sg_set_page(&dmreq->sg_out[i], bv_out.bv_page, bv_out.bv_len,
+			    bv_out.bv_offset);
+
+		bio_advance_iter(ctx->bio_in, &ctx->iter_in, bv_in.bv_len);
+		bio_advance_iter(ctx->bio_out, &ctx->iter_out, bv_out.bv_len);
+
+		bytes += bv_in.bv_len;
+		i++;
 	}
 
-	return 0;
+	DMDEBUG("dm-crypt: Processed %u of %u bytes\n", bytes, cryptlen);
+
+	rinfo.is_write = bio_data_dir(ctx->bio_in) == WRITE;
+	rinfo.iv_sector = ctx->cc_sector;
+	rinfo.nents = nents;
+	rinfo.iv = iv;
+
+	skcipher_request_set_crypt(req, dmreq->sg_in, dmreq->sg_out,
+				   bytes, &rinfo);
+
+	if (bio_data_dir(ctx->bio_in) == WRITE)
+		r = crypto_skcipher_encrypt(req);
+	else
+		r = crypto_skcipher_decrypt(req);
+
+	switch (r) {
+	/* The request was queued so wait. */
+	case -EBUSY:
+		wait_for_completion(&ctx->restart);
+		reinit_completion(&ctx->restart);
+		/* fall through */
+	/*
+	 * The request is queued and processed asynchronously,
+	 * completion function kcryptd_async_done() is called.
+	 */
+	case -EINPROGRESS:
+		ctx->req = NULL;
+		cond_resched();
+		break;
+	}
+
+	return r;
 }
 
+
 static void crypt_free_buffer_pages(struct crypt_config *cc, struct bio *clone);
 
 /*
@@ -1072,11 +463,17 @@ static void crypt_dec_pending(struct dm_crypt_io *io)
 {
 	struct crypt_config *cc = io->cc;
 	struct bio *base_bio = io->base_bio;
+	struct dm_crypt_request *dmreq;
 	int error = io->error;
 
 	if (!atomic_dec_and_test(&io->io_pending))
 		return;
 
+	dmreq = dmreq_of_req(cc, io->ctx.req);
+	DMDEBUG("dm-crypt: Freeing scatterlists [sync]\n");
+	kfree(dmreq->sg_in);
+	kfree(dmreq->sg_out);
+
 	if (io->ctx.req)
 		crypt_free_req(cc, io->ctx.req, base_bio);
 
@@ -1315,7 +712,7 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 	sector += bio_sectors(clone);
 
 	crypt_inc_pending(io);
-	r = crypt_convert(cc, &io->ctx);
+	r = crypt_convert_bio(cc, &io->ctx);
 	if (r)
 		io->error = -EIO;
 	crypt_finished = atomic_dec_and_test(&io->ctx.cc_pending);
@@ -1345,7 +742,8 @@ static void kcryptd_crypt_read_convert(struct dm_crypt_io *io)
 	crypt_convert_init(cc, &io->ctx, io->base_bio, io->base_bio,
 			   io->sector);
 
-	r = crypt_convert(cc, &io->ctx);
+	r = crypt_convert_bio(cc, &io->ctx);
+
 	if (r < 0)
 		io->error = -EIO;
 
@@ -1373,12 +771,13 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
 		return;
 	}
 
-	if (!error && cc->iv_gen_ops && cc->iv_gen_ops->post)
-		error = cc->iv_gen_ops->post(cc, iv_of_dmreq(cc, dmreq), dmreq);
-
 	if (error < 0)
 		io->error = -EIO;
 
+	DMDEBUG("dm-crypt: Freeing scatterlists and request struct [async]\n");
+	kfree(dmreq->sg_in);
+	kfree(dmreq->sg_out);
+
 	crypt_free_req(cc, req_of_dmreq(cc, dmreq), io->base_bio);
 
 	if (!atomic_dec_and_test(&ctx->cc_pending))
@@ -1471,7 +870,8 @@ static int crypt_alloc_tfms(struct crypt_config *cc, char *ciphermode)
 	return 0;
 }
 
-static int crypt_setkey_allcpus(struct crypt_config *cc)
+static int crypt_setkey_allcpus(struct crypt_config *cc, enum setkey_op keyop,
+				char *ivmode, char *ivopts)
 {
 	unsigned subkey_size;
 	int err = 0, i, r;
@@ -1480,9 +880,13 @@ static int crypt_setkey_allcpus(struct crypt_config *cc)
 	subkey_size = (cc->key_size - cc->key_extra_size) >> ilog2(cc->tfms_count);
 
 	for (i = 0; i < cc->tfms_count; i++) {
-		r = crypto_skcipher_setkey(cc->tfms[i],
-					   cc->key + (i * subkey_size),
-					   subkey_size);
+		DECLARE_GENIV_KEY(kinfo, keyop, cc->tfms_count, cc->cipher,
+				  cc->key, cc->key_size,
+				  cc->key + (subkey_size * i), subkey_size,
+				  cc->key_parts, ivmode, ivopts);
+
+		r = crypto_skcipher_setkey(cc->tfms[i], (u8 *) &kinfo,
+					   sizeof(kinfo));
 		if (r)
 			err = r;
 	}
@@ -1490,7 +894,8 @@ static int crypt_setkey_allcpus(struct crypt_config *cc)
 	return err;
 }
 
-static int crypt_set_key(struct crypt_config *cc, char *key)
+static int crypt_set_key(struct crypt_config *cc, enum setkey_op keyop,
+			 char *key, char *ivmode, char *ivopts)
 {
 	int r = -EINVAL;
 	int key_string_len = strlen(key);
@@ -1508,7 +913,7 @@ static int crypt_set_key(struct crypt_config *cc, char *key)
 
 	set_bit(DM_CRYPT_KEY_VALID, &cc->flags);
 
-	r = crypt_setkey_allcpus(cc);
+	r = crypt_setkey_allcpus(cc, keyop, ivmode, ivopts);
 
 out:
 	/* Hex key string not needed after here, so wipe it. */
@@ -1517,12 +922,24 @@ static int crypt_set_key(struct crypt_config *cc, char *key)
 	return r;
 }
 
+static int crypt_init_all_cpus(struct dm_target *ti, char *key,
+			       char *ivmode, char *ivopts)
+{
+	struct crypt_config *cc = ti->private;
+	int ret;
+
+	ret = crypt_set_key(cc, SETKEY_OP_INIT, key, ivmode, ivopts);
+	if (ret < 0)
+		ti->error = "Error decoding and setting key";
+	return ret;
+}
+
 static int crypt_wipe_key(struct crypt_config *cc)
 {
 	clear_bit(DM_CRYPT_KEY_VALID, &cc->flags);
 	memset(&cc->key, 0, cc->key_size * sizeof(u8));
 
-	return crypt_setkey_allcpus(cc);
+	return crypt_setkey_allcpus(cc, SETKEY_OP_WIPE, NULL, NULL);
 }
 
 static void crypt_dtr(struct dm_target *ti)
@@ -1550,9 +967,6 @@ static void crypt_dtr(struct dm_target *ti)
 	mempool_destroy(cc->page_pool);
 	mempool_destroy(cc->req_pool);
 
-	if (cc->iv_gen_ops && cc->iv_gen_ops->dtr)
-		cc->iv_gen_ops->dtr(cc);
-
 	if (cc->dev)
 		dm_put_device(ti, cc->dev);
 
@@ -1629,8 +1043,16 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 	if (!cipher_api)
 		goto bad_mem;
 
-	ret = snprintf(cipher_api, CRYPTO_MAX_ALG_NAME,
-		       "%s(%s)", chainmode, cipher);
+create_cipher:
+	/* For those ciphers which do not support IVs,
+	 * use the 'null' template cipher
+	 */
+
+	if (!ivmode)
+		ivmode = "null";
+
+	ret = snprintf(cipher_api, CRYPTO_MAX_ALG_NAME, "%s(%s(%s))",
+		       ivmode, chainmode, cipher);
 	if (ret < 0) {
 		kfree(cipher_api);
 		goto bad_mem;
@@ -1652,23 +1074,10 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 	else if (ivmode) {
 		DMWARN("Selected cipher does not support IVs");
 		ivmode = NULL;
+		goto create_cipher;
 	}
 
-	/* Choose ivmode, see comments at iv code. */
-	if (ivmode == NULL)
-		cc->iv_gen_ops = NULL;
-	else if (strcmp(ivmode, "plain") == 0)
-		cc->iv_gen_ops = &crypt_iv_plain_ops;
-	else if (strcmp(ivmode, "plain64") == 0)
-		cc->iv_gen_ops = &crypt_iv_plain64_ops;
-	else if (strcmp(ivmode, "essiv") == 0)
-		cc->iv_gen_ops = &crypt_iv_essiv_ops;
-	else if (strcmp(ivmode, "benbi") == 0)
-		cc->iv_gen_ops = &crypt_iv_benbi_ops;
-	else if (strcmp(ivmode, "null") == 0)
-		cc->iv_gen_ops = &crypt_iv_null_ops;
-	else if (strcmp(ivmode, "lmk") == 0) {
-		cc->iv_gen_ops = &crypt_iv_lmk_ops;
+	if (strcmp(ivmode, "lmk") == 0) {
 		/*
 		 * Version 2 and 3 is recognised according
 		 * to length of provided multi-key string.
@@ -1680,39 +1089,14 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 			cc->key_extra_size = cc->key_size / cc->key_parts;
 		}
 	} else if (strcmp(ivmode, "tcw") == 0) {
-		cc->iv_gen_ops = &crypt_iv_tcw_ops;
 		cc->key_parts += 2; /* IV + whitening */
 		cc->key_extra_size = cc->iv_size + TCW_WHITENING_SIZE;
-	} else {
-		ret = -EINVAL;
-		ti->error = "Invalid IV mode";
-		goto bad;
 	}
 
 	/* Initialize and set key */
-	ret = crypt_set_key(cc, key);
-	if (ret < 0) {
-		ti->error = "Error decoding and setting key";
+	ret = crypt_init_all_cpus(ti, key, ivmode, ivopts);
+	if (ret < 0)
 		goto bad;
-	}
-
-	/* Allocate IV */
-	if (cc->iv_gen_ops && cc->iv_gen_ops->ctr) {
-		ret = cc->iv_gen_ops->ctr(cc, ti, ivopts);
-		if (ret < 0) {
-			ti->error = "Error creating IV";
-			goto bad;
-		}
-	}
-
-	/* Initialize IV (set keys for ESSIV etc) */
-	if (cc->iv_gen_ops && cc->iv_gen_ops->init) {
-		ret = cc->iv_gen_ops->init(cc);
-		if (ret < 0) {
-			ti->error = "Error initialising IV";
-			goto bad;
-		}
-	}
 
 	ret = 0;
 bad:
@@ -1934,8 +1318,9 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
 	if (bio_data_dir(io->base_bio) == READ) {
 		if (kcryptd_io_read(io, GFP_NOWAIT))
 			kcryptd_queue_read(io);
-	} else
+	} else {
 		kcryptd_queue_crypt(io);
+	}
 
 	return DM_MAPIO_SUBMITTED;
 }
@@ -2014,7 +1399,6 @@ static void crypt_resume(struct dm_target *ti)
 static int crypt_message(struct dm_target *ti, unsigned argc, char **argv)
 {
 	struct crypt_config *cc = ti->private;
-	int ret = -EINVAL;
 
 	if (argc < 2)
 		goto error;
@@ -2025,19 +1409,9 @@ static int crypt_message(struct dm_target *ti, unsigned argc, char **argv)
 			return -EINVAL;
 		}
 		if (argc == 3 && !strcasecmp(argv[1], "set")) {
-			ret = crypt_set_key(cc, argv[2]);
-			if (ret)
-				return ret;
-			if (cc->iv_gen_ops && cc->iv_gen_ops->init)
-				ret = cc->iv_gen_ops->init(cc);
-			return ret;
+			return crypt_set_key(cc, SETKEY_OP_SET, argv[2], 0, 0);
 		}
 		if (argc == 2 && !strcasecmp(argv[1], "wipe")) {
-			if (cc->iv_gen_ops && cc->iv_gen_ops->wipe) {
-				ret = cc->iv_gen_ops->wipe(cc);
-				if (ret)
-					return ret;
-			}
 			return crypt_wipe_key(cc);
 		}
 	}
diff --git a/include/crypto/geniv.h b/include/crypto/geniv.h
new file mode 100644
index 0000000..df9f953
--- /dev/null
+++ b/include/crypto/geniv.h
@@ -0,0 +1,60 @@
+/*
+ * geniv: common data structures for IV generation algorithms
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+#ifndef _CRYPTO_GENIV_
+#define _CRYPTO_GENIV_
+
+#define SECTOR_SHIFT		9
+#define SECTOR_SIZE		(1 << SECTOR_SHIFT)
+
+#define LMK_SEED_SIZE		64 /* hash + 0 */
+#define TCW_WHITENING_SIZE	16
+
+enum setkey_op {
+	SETKEY_OP_INIT,
+	SETKEY_OP_SET,
+	SETKEY_OP_WIPE,
+};
+
+struct geniv_key_info {
+	enum setkey_op keyop;
+	unsigned int tfms_count;
+	char *cipher;
+	u8 *key;
+	u8 *subkey;
+	unsigned int key_size;
+	unsigned int subkey_size;
+	unsigned int key_parts;
+	char *ivmode;
+	char *ivopts;
+};
+
+#define DECLARE_GENIV_KEY(c, op, n, p, k, sz, skey, ssz, kp, m, opts)	\
+	struct geniv_key_info c = {					\
+		.keyop = op,						\
+		.tfms_count = n,					\
+		.cipher = p,						\
+		.key = k,						\
+		.key_size = sz,						\
+		.subkey = skey,						\
+		.subkey_size = ssz,					\
+		.key_parts = kp,					\
+		.ivmode = m,						\
+		.ivopts = opts,						\
+	}
+
+struct geniv_req_info {
+	bool is_write;
+	sector_t iv_sector;
+	unsigned int nents;
+	u8 *iv;
+};
+
+#endif
+
-- 
Binoy Jayan

