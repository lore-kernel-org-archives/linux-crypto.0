From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: [RFC PATCH] crypto: Add IV generation algorithms
Date: Mon, 21 Nov 2016 15:40:09 +0530
Message-ID: <1479723009-11113-2-git-send-email-binoy.jayan@linaro.org>
References: <1479723009-11113-1-git-send-email-binoy.jayan@linaro.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org,
        Binoy Jayan <binoy.jayan@linaro.org>
To: Oded <oded.golombek@arm.com>, Ofir <Ofir.Drang@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1479723009-11113-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Currently, the iv generation algorithms are implemented in dm-crypt.c.
The goal is to move these algorithms from the dm layer to the kernel
crypto layer by implementing them as template ciphers so they can be used
in relation with algorithms like aes, and with multiple modes like cbc,
ecb etc. As part of this patchset, the iv-generation code is moved from the
dm layer to the crypto layer. The dm-layer can later be optimized to
encrypt larger block sizes in a single call to the crypto engine. The iv
generation algorithms implemented in geniv.c includes plain, plain64,
essiv, benbi, null, lmk and tcw. These templates are to be configured
and has to be invoked as:

crypto_alloc_skcipher("plain(cbc(aes))", 0, 0);
crypto_alloc_skcipher("essiv(cbc(aes))", 0, 0);
...

from the dm layer.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
---
 crypto/Kconfig            |    8 +
 crypto/Makefile           |    1 +
 crypto/geniv.c            | 1113 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-crypt.c     |  725 +++--------------------------
 include/crypto/geniv.h    |  109 +++++
 include/crypto/skcipher.h |   17 +
 6 files changed, 1309 insertions(+), 664 deletions(-)
 create mode 100644 crypto/geniv.c
 create mode 100644 include/crypto/geniv.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 84d7148..7125bc2 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -326,6 +326,14 @@ config CRYPTO_CTS
 	  This mode is required for Kerberos gss mechanism support
 	  for AES encryption.
 
+config CRYPTO_GENIV
+	tristate "IV Generation for dm-crypt"
+	select CRYPTO_BLKCIPHER
+	help
+	  GENIV: IV Generation for dm-crypt
+	  Algorithms to generate Initialization Vector for ciphers
+	  used by dm-crypt.
+
 config CRYPTO_ECB
 	tristate "ECB support"
 	select CRYPTO_BLKCIPHER
diff --git a/crypto/Makefile b/crypto/Makefile
index 99cc64a..fc81a82 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -74,6 +74,7 @@ obj-$(CONFIG_CRYPTO_TGR192) += tgr192.o
 obj-$(CONFIG_CRYPTO_GF128MUL) += gf128mul.o
 obj-$(CONFIG_CRYPTO_ECB) += ecb.o
 obj-$(CONFIG_CRYPTO_CBC) += cbc.o
+obj-$(CONFIG_CRYPTO_GENIV) += geniv.o
 obj-$(CONFIG_CRYPTO_PCBC) += pcbc.o
 obj-$(CONFIG_CRYPTO_CTS) += cts.o
 obj-$(CONFIG_CRYPTO_LRW) += lrw.o
diff --git a/crypto/geniv.c b/crypto/geniv.c
new file mode 100644
index 0000000..46988d5
--- /dev/null
+++ b/crypto/geniv.c
@@ -0,0 +1,1113 @@
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
+struct crypto_geniv_req_ctx {
+	struct skcipher_request subreq CRYPTO_MINALIGN_ATTR;
+};
+
+static struct crypto_skcipher *any_tfm(struct geniv_ctx_data *cd)
+{
+	return cd->tfm;
+}
+
+static int crypt_iv_plain_gen(struct geniv_ctx_data *cd, u8 *iv,
+			      struct dm_crypt_request *dmreq)
+{
+	memset(iv, 0, cd->iv_size);
+	*(__le32 *)iv = cpu_to_le32(dmreq->iv_sector & 0xffffffff);
+
+	return 0;
+}
+
+static int crypt_iv_plain64_gen(struct geniv_ctx_data *cd, u8 *iv,
+				struct dm_crypt_request *dmreq)
+{
+	memset(iv, 0, cd->iv_size);
+	*(__le64 *)iv = cpu_to_le64(dmreq->iv_sector);
+
+	return 0;
+}
+
+/* Initialise ESSIV - compute salt but no local memory allocations */
+static int crypt_iv_essiv_init(struct geniv_ctx_data *cd)
+{
+	struct geniv_essiv_private *essiv = &cd->iv_gen_private.essiv;
+	struct scatterlist sg;
+	struct crypto_cipher *essiv_tfm;
+	int err;
+	AHASH_REQUEST_ON_STACK(req, essiv->hash_tfm);
+
+	sg_init_one(&sg, cd->key, cd->key_size);
+	ahash_request_set_tfm(req, essiv->hash_tfm);
+	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP, NULL, NULL);
+	ahash_request_set_crypt(req, &sg, essiv->salt, cd->key_size);
+
+	err = crypto_ahash_digest(req);
+	ahash_request_zero(req);
+	if (err)
+		return err;
+
+	essiv_tfm = cd->iv_private;
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
+static int crypt_iv_essiv_wipe(struct geniv_ctx_data *cd)
+{
+	struct geniv_essiv_private *essiv = &cd->iv_gen_private.essiv;
+	unsigned int salt_size = crypto_ahash_digestsize(essiv->hash_tfm);
+	struct crypto_cipher *essiv_tfm;
+	int r, err = 0;
+
+	memset(essiv->salt, 0, salt_size);
+
+	essiv_tfm = cd->iv_private;
+	r = crypto_cipher_setkey(essiv_tfm, essiv->salt, salt_size);
+	if (r)
+		err = r;
+
+	return err;
+}
+
+/* Set up per cpu cipher state */
+static struct crypto_cipher *setup_essiv_cpu(struct geniv_ctx_data *cd,
+					     u8 *salt, unsigned int saltsize)
+{
+	struct crypto_cipher *essiv_tfm;
+	int err;
+
+	/* Setup the essiv_tfm with the given salt */
+	essiv_tfm = crypto_alloc_cipher(cd->cipher, 0, CRYPTO_ALG_ASYNC);
+
+	if (IS_ERR(essiv_tfm)) {
+		pr_err("Error allocating crypto tfm for ESSIV\n");
+		return essiv_tfm;
+	}
+
+	if (crypto_cipher_blocksize(essiv_tfm) !=
+	    crypto_skcipher_ivsize(any_tfm(cd))) {
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
+static void crypt_iv_essiv_dtr(struct geniv_ctx_data *cd)
+{
+	struct crypto_cipher *essiv_tfm;
+	struct geniv_essiv_private *essiv = &cd->iv_gen_private.essiv;
+
+	crypto_free_ahash(essiv->hash_tfm);
+	essiv->hash_tfm = NULL;
+
+	kzfree(essiv->salt);
+	essiv->salt = NULL;
+
+	essiv_tfm = cd->iv_private;
+
+	if (essiv_tfm)
+		crypto_free_cipher(essiv_tfm);
+
+	cd->iv_private = NULL;
+}
+
+static int crypt_iv_essiv_ctr(struct geniv_ctx_data *cd)
+{
+	struct crypto_cipher *essiv_tfm = NULL;
+	struct crypto_ahash *hash_tfm = NULL;
+	u8 *salt = NULL;
+	int err;
+
+	if (!cd->ivopts) {
+		pr_err("Digest algorithm missing for ESSIV mode\n");
+		return -EINVAL;
+	}
+
+	/* Allocate hash algorithm */
+	hash_tfm = crypto_alloc_ahash(cd->ivopts, 0, CRYPTO_ALG_ASYNC);
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
+	cd->iv_gen_private.essiv.salt = salt;
+	cd->iv_gen_private.essiv.hash_tfm = hash_tfm;
+
+	essiv_tfm = setup_essiv_cpu(cd, salt,
+				crypto_ahash_digestsize(hash_tfm));
+	if (IS_ERR(essiv_tfm)) {
+		crypt_iv_essiv_dtr(cd);
+		return PTR_ERR(essiv_tfm);
+	}
+	cd->iv_private = essiv_tfm;
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
+static int crypt_iv_essiv_gen(struct geniv_ctx_data *cd, u8 *iv,
+			      struct dm_crypt_request *dmreq)
+{
+	struct crypto_cipher *essiv_tfm = cd->iv_private;
+
+	memset(iv, 0, cd->iv_size);
+	*(__le64 *)iv = cpu_to_le64(dmreq->iv_sector);
+	crypto_cipher_encrypt_one(essiv_tfm, iv, iv);
+
+	return 0;
+}
+
+static int crypt_iv_benbi_ctr(struct geniv_ctx_data *cd)
+{
+	unsigned int bs = crypto_skcipher_blocksize(any_tfm(cd));
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
+	cd->iv_gen_private.benbi.shift = 9 - log;
+
+	return 0;
+}
+
+static int crypt_iv_benbi_gen(struct geniv_ctx_data *cd, u8 *iv,
+			      struct dm_crypt_request *dmreq)
+{
+	__be64 val;
+
+	memset(iv, 0, cd->iv_size - sizeof(u64)); /* rest is cleared below */
+
+	val = cpu_to_be64(((u64) dmreq->iv_sector <<
+			  cd->iv_gen_private.benbi.shift) + 1);
+	put_unaligned(val, (__be64 *)(iv + cd->iv_size - sizeof(u64)));
+
+	return 0;
+}
+
+static int crypt_iv_null_gen(struct geniv_ctx_data *cd, u8 *iv,
+			     struct dm_crypt_request *dmreq)
+{
+	memset(iv, 0, cd->iv_size);
+
+	return 0;
+}
+
+static void crypt_iv_lmk_dtr(struct geniv_ctx_data *cd)
+{
+	struct geniv_lmk_private *lmk = &cd->iv_gen_private.lmk;
+
+	if (lmk->hash_tfm && !IS_ERR(lmk->hash_tfm))
+		crypto_free_shash(lmk->hash_tfm);
+	lmk->hash_tfm = NULL;
+
+	kzfree(lmk->seed);
+	lmk->seed = NULL;
+}
+
+static int crypt_iv_lmk_ctr(struct geniv_ctx_data *cd)
+{
+	struct geniv_lmk_private *lmk = &cd->iv_gen_private.lmk;
+
+	lmk->hash_tfm = crypto_alloc_shash("md5", 0, 0);
+	if (IS_ERR(lmk->hash_tfm)) {
+		pr_err("Error initializing LMK hash; err=%ld\n",
+				PTR_ERR(lmk->hash_tfm));
+		return PTR_ERR(lmk->hash_tfm);
+	}
+
+	/* No seed in LMK version 2 */
+	if (cd->key_parts == cd->tfms_count) {
+		lmk->seed = NULL;
+		return 0;
+	}
+
+	lmk->seed = kzalloc(LMK_SEED_SIZE, GFP_KERNEL);
+	if (!lmk->seed) {
+		crypt_iv_lmk_dtr(cd);
+		pr_err("Error kmallocing seed storage in LMK\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int crypt_iv_lmk_init(struct geniv_ctx_data *cd)
+{
+	struct geniv_lmk_private *lmk = &cd->iv_gen_private.lmk;
+	int subkey_size = cd->key_size / cd->key_parts;
+
+	/* LMK seed is on the position of LMK_KEYS + 1 key */
+	if (lmk->seed)
+		memcpy(lmk->seed, cd->key + (cd->tfms_count * subkey_size),
+		       crypto_shash_digestsize(lmk->hash_tfm));
+
+	return 0;
+}
+
+static int crypt_iv_lmk_wipe(struct geniv_ctx_data *cd)
+{
+	struct geniv_lmk_private *lmk = &cd->iv_gen_private.lmk;
+
+	if (lmk->seed)
+		memset(lmk->seed, 0, LMK_SEED_SIZE);
+
+	return 0;
+}
+
+static int crypt_iv_lmk_one(struct geniv_ctx_data *cd, u8 *iv,
+			    struct dm_crypt_request *dmreq, u8 *data)
+{
+	struct geniv_lmk_private *lmk = &cd->iv_gen_private.lmk;
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
+	buf[0] = cpu_to_le32(dmreq->iv_sector & 0xFFFFFFFF);
+	buf[1] = cpu_to_le32((((u64)dmreq->iv_sector >> 32) & 0x00FFFFFF)
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
+	memcpy(iv, &md5state.hash, cd->iv_size);
+
+	return 0;
+}
+
+static int crypt_iv_lmk_gen(struct geniv_ctx_data *cd, u8 *iv,
+			      struct dm_crypt_request *dmreq)
+{
+	u8 *src;
+	int r = 0;
+
+	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE) {
+		src = kmap_atomic(sg_page(&dmreq->sg_in));
+		r = crypt_iv_lmk_one(cd, iv, dmreq, src + dmreq->sg_in.offset);
+		kunmap_atomic(src);
+	} else
+		memset(iv, 0, cd->iv_size);
+
+	return r;
+}
+
+static int crypt_iv_lmk_post(struct geniv_ctx_data *cd, u8 *iv,
+			     struct dm_crypt_request *dmreq)
+{
+	u8 *dst;
+	int r;
+
+	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE)
+		return 0;
+
+	dst = kmap_atomic(sg_page(&dmreq->sg_out));
+	r = crypt_iv_lmk_one(cd, iv, dmreq, dst + dmreq->sg_out.offset);
+
+	/* Tweak the first block of plaintext sector */
+	if (!r)
+		crypto_xor(dst + dmreq->sg_out.offset, iv, cd->iv_size);
+
+	kunmap_atomic(dst);
+	return r;
+}
+
+static void crypt_iv_tcw_dtr(struct geniv_ctx_data *cd)
+{
+	struct geniv_tcw_private *tcw = &cd->iv_gen_private.tcw;
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
+static int crypt_iv_tcw_ctr(struct geniv_ctx_data *cd)
+{
+	struct geniv_tcw_private *tcw = &cd->iv_gen_private.tcw;
+
+	if (cd->key_size <= (cd->iv_size + TCW_WHITENING_SIZE)) {
+		pr_err("Wrong key size (%d) for TCW. Choose a value > %d bytes\n",
+			cd->key_size,
+			cd->iv_size + TCW_WHITENING_SIZE);
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
+	tcw->iv_seed = kzalloc(cd->iv_size, GFP_KERNEL);
+	tcw->whitening = kzalloc(TCW_WHITENING_SIZE, GFP_KERNEL);
+	if (!tcw->iv_seed || !tcw->whitening) {
+		crypt_iv_tcw_dtr(cd);
+		pr_err("Error allocating seed storage in TCW\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int crypt_iv_tcw_init(struct geniv_ctx_data *cd)
+{
+	struct geniv_tcw_private *tcw = &cd->iv_gen_private.tcw;
+	int key_offset = cd->key_size - cd->iv_size - TCW_WHITENING_SIZE;
+
+	memcpy(tcw->iv_seed, &cd->key[key_offset], cd->iv_size);
+	memcpy(tcw->whitening, &cd->key[key_offset + cd->iv_size],
+	       TCW_WHITENING_SIZE);
+
+	return 0;
+}
+
+static int crypt_iv_tcw_wipe(struct geniv_ctx_data *cd)
+{
+	struct geniv_tcw_private *tcw = &cd->iv_gen_private.tcw;
+
+	memset(tcw->iv_seed, 0, cd->iv_size);
+	memset(tcw->whitening, 0, TCW_WHITENING_SIZE);
+
+	return 0;
+}
+
+static int crypt_iv_tcw_whitening(struct geniv_ctx_data *cd,
+				  struct dm_crypt_request *dmreq, u8 *data)
+{
+	struct geniv_tcw_private *tcw = &cd->iv_gen_private.tcw;
+	__le64 sector = cpu_to_le64(dmreq->iv_sector);
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
+	for (i = 0; i < ((1 << SECTOR_SHIFT) / 8); i++)
+		crypto_xor(data + i * 8, buf, 8);
+out:
+	memzero_explicit(buf, sizeof(buf));
+	return r;
+}
+
+static int crypt_iv_tcw_gen(struct geniv_ctx_data *cd, u8 *iv,
+			      struct dm_crypt_request *dmreq)
+{
+	struct geniv_tcw_private *tcw = &cd->iv_gen_private.tcw;
+	__le64 sector = cpu_to_le64(dmreq->iv_sector);
+	u8 *src;
+	int r = 0;
+
+	/* Remove whitening from ciphertext */
+	if (bio_data_dir(dmreq->ctx->bio_in) != WRITE) {
+		src = kmap_atomic(sg_page(&dmreq->sg_in));
+		r = crypt_iv_tcw_whitening(cd, dmreq,
+					   src + dmreq->sg_in.offset);
+		kunmap_atomic(src);
+	}
+
+	/* Calculate IV */
+	memcpy(iv, tcw->iv_seed, cd->iv_size);
+	crypto_xor(iv, (u8 *)&sector, 8);
+	if (cd->iv_size > 8)
+		crypto_xor(&iv[8], (u8 *)&sector, cd->iv_size - 8);
+
+	return r;
+}
+
+static int crypt_iv_tcw_post(struct geniv_ctx_data *cd, u8 *iv,
+			     struct dm_crypt_request *dmreq)
+{
+	u8 *dst;
+	int r;
+
+	if (bio_data_dir(dmreq->ctx->bio_in) != WRITE)
+		return 0;
+
+	/* Apply whitening on ciphertext */
+	dst = kmap_atomic(sg_page(&dmreq->sg_out));
+	r = crypt_iv_tcw_whitening(cd, dmreq, dst + dmreq->sg_out.offset);
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
+static int geniv_setkey_set(struct geniv_ctx_data *cd)
+{
+	int ret = 0;
+
+	if (cd->iv_gen_ops && cd->iv_gen_ops->init)
+		ret = cd->iv_gen_ops->init(cd);
+	return ret;
+}
+
+static int geniv_setkey_wipe(struct geniv_ctx_data *cd)
+{
+	int ret = 0;
+
+	if (cd->iv_gen_ops && cd->iv_gen_ops->wipe) {
+		ret = cd->iv_gen_ops->wipe(cd);
+		if (ret)
+			return ret;
+	}
+	return ret;
+}
+
+static int geniv_setkey_init_ctx(struct geniv_ctx_data *cd)
+{
+	int ret = -EINVAL;
+
+	pr_debug("IV Generation algorithm : %s\n", cd->ivmode);
+
+	if (cd->ivmode == NULL)
+		cd->iv_gen_ops = NULL;
+	else if (strcmp(cd->ivmode, "plain") == 0)
+		cd->iv_gen_ops = &crypt_iv_plain_ops;
+	else if (strcmp(cd->ivmode, "plain64") == 0)
+		cd->iv_gen_ops = &crypt_iv_plain64_ops;
+	else if (strcmp(cd->ivmode, "essiv") == 0)
+		cd->iv_gen_ops = &crypt_iv_essiv_ops;
+	else if (strcmp(cd->ivmode, "benbi") == 0)
+		cd->iv_gen_ops = &crypt_iv_benbi_ops;
+	else if (strcmp(cd->ivmode, "null") == 0)
+		cd->iv_gen_ops = &crypt_iv_null_ops;
+	else if (strcmp(cd->ivmode, "lmk") == 0)
+		cd->iv_gen_ops = &crypt_iv_lmk_ops;
+	else if (strcmp(cd->ivmode, "tcw") == 0) {
+		cd->iv_gen_ops = &crypt_iv_tcw_ops;
+		cd->key_parts += 2; /* IV + whitening */
+		cd->key_extra_size = cd->iv_size + TCW_WHITENING_SIZE;
+	} else {
+		ret = -EINVAL;
+		pr_err("Invalid IV mode %s\n", cd->ivmode);
+		goto end;
+	}
+
+	/* Allocate IV */
+	if (cd->iv_gen_ops && cd->iv_gen_ops->ctr) {
+		ret = cd->iv_gen_ops->ctr(cd);
+		if (ret < 0) {
+			pr_err("Error creating IV for %s\n", cd->ivmode);
+			goto end;
+		}
+	}
+
+	/* Initialize IV (set keys for ESSIV etc) */
+	if (cd->iv_gen_ops && cd->iv_gen_ops->init) {
+		ret = cd->iv_gen_ops->init(cd);
+		if (ret < 0)
+			pr_err("Error creating IV for %s\n", cd->ivmode);
+	}
+	ret = 0;
+end:
+	return ret;
+}
+
+static int crypto_geniv_set_ctx(struct crypto_skcipher *cipher,
+				void *newctx, unsigned int len)
+{
+	struct geniv_ctx *ctx = crypto_skcipher_ctx(cipher);
+	/*
+	 * TODO:
+	 * Do we really need this API or can we append the context
+	 * 'struct geniv_ctx' to the cipher from dm-crypt and use
+	 * the same here.
+	 */
+	memcpy(ctx, (char *) newctx, len);
+	return geniv_setkey_init_ctx(&ctx->data);
+}
+
+static int crypto_geniv_setkey(struct crypto_skcipher *parent,
+				const u8 *key, unsigned int keylen)
+{
+	struct geniv_ctx *ctx = crypto_skcipher_ctx(parent);
+	struct crypto_skcipher *child = ctx->child;
+	int err;
+
+	pr_debug("SETKEY Operation : %d\n", ctx->data.keyop);
+
+	switch (ctx->data.keyop) {
+	case SETKEY_OP_INIT:
+		err = geniv_setkey_init_ctx(&ctx->data);
+		break;
+	case SETKEY_OP_SET:
+		err = geniv_setkey_set(&ctx->data);
+		break;
+	case SETKEY_OP_WIPE:
+		err = geniv_setkey_wipe(&ctx->data);
+		break;
+	}
+
+	crypto_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(child, crypto_skcipher_get_flags(parent) &
+					 CRYPTO_TFM_REQ_MASK);
+	err = crypto_skcipher_setkey(child, key, keylen);
+	crypto_skcipher_set_flags(parent, crypto_skcipher_get_flags(child) &
+					  CRYPTO_TFM_RES_MASK);
+	return err;
+}
+
+static struct dm_crypt_request *dmreq_of_req(struct crypto_skcipher *tfm,
+					     struct skcipher_request *req)
+{
+	struct geniv_ctx *ctx;
+
+	ctx = crypto_skcipher_ctx(tfm);
+	return (struct dm_crypt_request *) ((char *) req + ctx->data.dmoffset);
+}
+
+
+static void geniv_async_done(struct crypto_async_request *async_req, int error)
+{
+	struct skcipher_request *req = async_req->data;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct geniv_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct geniv_ctx_data *cd = &ctx->data;
+	struct dm_crypt_request *dmreq = dmreq_of_req(tfm, req);
+	struct convert_context *cctx = dmreq->ctx;
+	unsigned long align = crypto_skcipher_alignmask(tfm);
+	struct crypto_geniv_req_ctx *rctx =
+		(void *) PTR_ALIGN((u8 *)skcipher_request_ctx(req), align + 1);
+	struct skcipher_request *subreq = &rctx->subreq;
+
+	/*
+	 * A request from crypto driver backlog is going to be processed now,
+	 * finish the completion and continue in crypt_convert().
+	 * (Callback will be called for the second time for this request.)
+	 */
+	if (error == -EINPROGRESS) {
+		complete(&cctx->restart);
+		return;
+	}
+
+	if (!error && cd->iv_gen_ops && cd->iv_gen_ops->post)
+		error = cd->iv_gen_ops->post(cd, req->iv, dmreq);
+
+	skcipher_request_set_callback(subreq, req->base.flags,
+				      req->base.complete, req->base.data);
+	skcipher_request_complete(req, error);
+}
+
+static inline int crypto_geniv_crypt(struct skcipher_request *req, bool encrypt)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct geniv_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct geniv_ctx_data *cd = &ctx->data;
+	struct crypto_skcipher *child = ctx->child;
+	struct dm_crypt_request *dmreq;
+	unsigned long align = crypto_skcipher_alignmask(tfm);
+	struct crypto_geniv_req_ctx *rctx =
+		(void *) PTR_ALIGN((u8 *)skcipher_request_ctx(req), align + 1);
+	struct skcipher_request *subreq = &rctx->subreq;
+	int ret = 0;
+	u8 *iv = req->iv;
+
+	dmreq = dmreq_of_req(tfm, req);
+
+	if (cd->iv_gen_ops)
+		ret = cd->iv_gen_ops->generator(cd, iv, dmreq);
+
+	if (ret < 0) {
+		pr_err("Error in generating IV ret: %d\n", ret);
+		goto end;
+	}
+
+	skcipher_request_set_tfm(subreq, child);
+	skcipher_request_set_callback(subreq, req->base.flags,
+				      geniv_async_done, req);
+	skcipher_request_set_crypt(subreq, req->src, req->dst,
+				   req->cryptlen, iv);
+
+	if (encrypt)
+		ret = crypto_skcipher_encrypt(subreq);
+	else
+		ret = crypto_skcipher_decrypt(subreq);
+
+	if (!ret && cd->iv_gen_ops && cd->iv_gen_ops->post)
+		ret = cd->iv_gen_ops->post(cd, iv, dmreq);
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
+	struct geniv_ctx_data *cd;
+	struct crypto_skcipher *cipher;
+	unsigned long align;
+	unsigned int reqsize, extrasize;
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
+	/* Set the current cipher's extra context parameters
+	 * Format of req structure, the context and the extra context
+	 * This is set by the caller of the cipher
+	 *   struct skcipher_request   --+
+	 *      context                  |   Request context
+	 *      padding                --+
+	 *   struct dm_crypt_request   --+
+	 *      padding                  |   Extra context
+	 *   IV                        --+
+	 */
+	cd = &ctx->data;
+	cd->dmoffset  = sizeof(struct skcipher_request);
+	cd->dmoffset += crypto_skcipher_reqsize(tfm);
+	cd->dmoffset  = ALIGN(cd->dmoffset,
+			__alignof__(struct dm_crypt_request));
+	extrasize = cd->dmoffset + sizeof(struct dm_crypt_request);
+
+	return 0;
+}
+
+static void crypto_geniv_exit_tfm(struct crypto_skcipher *tfm)
+{
+	struct geniv_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct geniv_ctx_data *cd = &ctx->data;
+
+	if (cd->iv_gen_ops && cd->iv_gen_ops->dtr)
+		cd->iv_gen_ops->dtr(cd);
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
+	/*
+	 * if (crypto_skcipher_alg_ivsize(alg) != 16)
+	 *	goto err_drop_spawn;
+	 */
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
+	inst->alg.set_ctx = crypto_geniv_set_ctx;
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
index a276883..05c2677 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -29,26 +29,13 @@
 #include <crypto/md5.h>
 #include <crypto/algapi.h>
 #include <crypto/skcipher.h>
+#include <crypto/geniv.h>
 
 #include <linux/device-mapper.h>
 
 #define DM_MSG_PREFIX "crypt"
 
 /*
- * context holding the current state of a multi-part conversion
- */
-struct convert_context {
-	struct completion restart;
-	struct bio *bio_in;
-	struct bio *bio_out;
-	struct bvec_iter iter_in;
-	struct bvec_iter iter_out;
-	sector_t cc_sector;
-	atomic_t cc_pending;
-	struct skcipher_request *req;
-};
-
-/*
  * per bio private data
  */
 struct dm_crypt_io {
@@ -65,13 +52,6 @@ struct dm_crypt_io {
 	struct rb_node rb_node;
 } CRYPTO_MINALIGN_ATTR;
 
-struct dm_crypt_request {
-	struct convert_context *ctx;
-	struct scatterlist sg_in;
-	struct scatterlist sg_out;
-	sector_t iv_sector;
-};
-
 struct crypt_config;
 
 struct crypt_iv_operations {
@@ -141,7 +121,6 @@ struct crypt_config {
 	char *cipher;
 	char *cipher_string;
 
-	struct crypt_iv_operations *iv_gen_ops;
 	union {
 		struct iv_essiv_private essiv;
 		struct iv_benbi_private benbi;
@@ -241,567 +220,6 @@ static struct crypto_skcipher *any_tfm(struct crypt_config *cc)
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
@@ -862,12 +280,6 @@ static int crypt_convert_block(struct crypt_config *cc,
 	bio_advance_iter(ctx->bio_in, &ctx->iter_in, 1 << SECTOR_SHIFT);
 	bio_advance_iter(ctx->bio_out, &ctx->iter_out, 1 << SECTOR_SHIFT);
 
-	if (cc->iv_gen_ops) {
-		r = cc->iv_gen_ops->generator(cc, iv, dmreq);
-		if (r < 0)
-			return r;
-	}
-
 	skcipher_request_set_crypt(req, &dmreq->sg_in, &dmreq->sg_out,
 				   1 << SECTOR_SHIFT, iv);
 
@@ -876,9 +288,6 @@ static int crypt_convert_block(struct crypt_config *cc,
 	else
 		r = crypto_skcipher_decrypt(req);
 
-	if (!r && cc->iv_gen_ops && cc->iv_gen_ops->post)
-		r = cc->iv_gen_ops->post(cc, iv, dmreq);
-
 	return r;
 }
 
@@ -1363,19 +772,6 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
 	struct dm_crypt_io *io = container_of(ctx, struct dm_crypt_io, ctx);
 	struct crypt_config *cc = io->cc;
 
-	/*
-	 * A request from crypto driver backlog is going to be processed now,
-	 * finish the completion and continue in crypt_convert().
-	 * (Callback will be called for the second time for this request.)
-	 */
-	if (error == -EINPROGRESS) {
-		complete(&ctx->restart);
-		return;
-	}
-
-	if (!error && cc->iv_gen_ops && cc->iv_gen_ops->post)
-		error = cc->iv_gen_ops->post(cc, iv_of_dmreq(cc, dmreq), dmreq);
-
 	if (error < 0)
 		io->error = -EIO;
 
@@ -1517,6 +913,39 @@ static int crypt_set_key(struct crypt_config *cc, char *key)
 	return r;
 }
 
+static void crypt_init_context(struct dm_target *ti, char *key,
+			      struct crypto_skcipher *tfm,
+			      char *ivmode, char *ivopts)
+{
+	struct crypt_config *cc = ti->private;
+	struct geniv_ctx *ctx = (struct geniv_ctx *) (tfm + 1);
+
+	ctx->data.iv_size = crypto_skcipher_ivsize(tfm);
+	ctx->data.cipher = cc->cipher;
+	ctx->data.ivmode = ivmode;
+	ctx->data.tfms_count = cc->tfms_count;
+	ctx->data.tfm = tfm;
+	ctx->data.ivopts = ivopts;
+	ctx->data.key_size = cc->key_size;
+	ctx->data.key_parts = cc->key_parts;
+	ctx->data.key = cc->key;
+}
+
+static int crypt_init_all_cpus(struct dm_target *ti, char *key,
+			       char *ivmode, char *ivopts)
+{
+	struct crypt_config *cc = ti->private;
+	int ret, i;
+
+	for (i = 0; i < cc->tfms_count; i++)
+		crypt_init_context(ti, key, cc->tfms[i], ivmode, ivopts);
+
+	ret = crypt_set_key(cc, key);
+	if (ret < 0)
+		ti->error = "Error decoding and setting key";
+	return ret;
+}
+
 static int crypt_wipe_key(struct crypt_config *cc)
 {
 	clear_bit(DM_CRYPT_KEY_VALID, &cc->flags);
@@ -1550,9 +979,6 @@ static void crypt_dtr(struct dm_target *ti)
 	mempool_destroy(cc->page_pool);
 	mempool_destroy(cc->req_pool);
 
-	if (cc->iv_gen_ops && cc->iv_gen_ops->dtr)
-		cc->iv_gen_ops->dtr(cc);
-
 	if (cc->dev)
 		dm_put_device(ti, cc->dev);
 
@@ -1629,8 +1055,14 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 	if (!cipher_api)
 		goto bad_mem;
 
-	ret = snprintf(cipher_api, CRYPTO_MAX_ALG_NAME,
-		       "%s(%s)", chainmode, cipher);
+create_cipher:
+	/* Call underlying cipher directly if it does not support iv */
+	if (ivmode)
+		ret = snprintf(cipher_api, CRYPTO_MAX_ALG_NAME, "%s(%s(%s))",
+				ivmode, chainmode, cipher);
+	else
+		ret = snprintf(cipher_api, CRYPTO_MAX_ALG_NAME, "%s(%s)",
+				chainmode, cipher);
 	if (ret < 0) {
 		kfree(cipher_api);
 		goto bad_mem;
@@ -1652,23 +1084,10 @@ static int crypt_ctr_cipher(struct dm_target *ti,
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
@@ -1680,39 +1099,14 @@ static int crypt_ctr_cipher(struct dm_target *ti,
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
@@ -2007,6 +1401,18 @@ static void crypt_resume(struct dm_target *ti)
 	clear_bit(DM_CRYPT_SUSPENDED, &cc->flags);
 }
 
+static void crypt_setkey_op_allcpus(struct crypt_config *cc,
+				    enum setkey_op keyop)
+{
+	int i;
+	struct geniv_ctx *ctx;
+
+	for (i = 0; i < cc->tfms_count; i++) {
+		ctx = (struct geniv_ctx *) (cc->tfms[i] + 1);
+		ctx->data.keyop = keyop;
+	}
+}
+
 /* Message interface
  *	key set <key>
  *	key wipe
@@ -2014,7 +1420,6 @@ static void crypt_resume(struct dm_target *ti)
 static int crypt_message(struct dm_target *ti, unsigned argc, char **argv)
 {
 	struct crypt_config *cc = ti->private;
-	int ret = -EINVAL;
 
 	if (argc < 2)
 		goto error;
@@ -2025,19 +1430,11 @@ static int crypt_message(struct dm_target *ti, unsigned argc, char **argv)
 			return -EINVAL;
 		}
 		if (argc == 3 && !strcasecmp(argv[1], "set")) {
-			ret = crypt_set_key(cc, argv[2]);
-			if (ret)
-				return ret;
-			if (cc->iv_gen_ops && cc->iv_gen_ops->init)
-				ret = cc->iv_gen_ops->init(cc);
-			return ret;
+			crypt_setkey_op_allcpus(cc, SETKEY_OP_SET);
+			return crypt_set_key(cc, argv[2]);
 		}
 		if (argc == 2 && !strcasecmp(argv[1], "wipe")) {
-			if (cc->iv_gen_ops && cc->iv_gen_ops->wipe) {
-				ret = cc->iv_gen_ops->wipe(cc);
-				if (ret)
-					return ret;
-			}
+			crypt_setkey_op_allcpus(cc, SETKEY_OP_WIPE);
 			return crypt_wipe_key(cc);
 		}
 	}
diff --git a/include/crypto/geniv.h b/include/crypto/geniv.h
new file mode 100644
index 0000000..1325843
--- /dev/null
+++ b/include/crypto/geniv.h
@@ -0,0 +1,109 @@
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
+#define SECTOR_SHIFT            9
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
+#define LMK_SEED_SIZE 64 /* hash + 0 */
+struct geniv_lmk_private {
+	struct crypto_shash *hash_tfm;
+	u8 *seed;
+};
+
+#define TCW_WHITENING_SIZE 16
+struct geniv_tcw_private {
+	struct crypto_shash *crc32_tfm;
+	u8 *iv_seed;
+	u8 *whitening;
+};
+
+enum setkey_op {
+	SETKEY_OP_INIT,
+	SETKEY_OP_SET,
+	SETKEY_OP_WIPE,
+};
+
+/*
+ * context holding the current state of a multi-part conversion
+ */
+struct convert_context {
+	struct completion restart;
+	struct bio *bio_in;
+	struct bio *bio_out;
+	struct bvec_iter iter_in;
+	struct bvec_iter iter_out;
+	sector_t cc_sector;
+	atomic_t cc_pending;
+	struct skcipher_request *req;
+};
+
+struct dm_crypt_request {
+	struct convert_context *ctx;
+	struct scatterlist sg_in;
+	struct scatterlist sg_out;
+	sector_t iv_sector;
+};
+
+
+struct geniv_ctx_data;
+
+struct geniv_operations {
+	int (*ctr)(struct geniv_ctx_data *cd);
+	void (*dtr)(struct geniv_ctx_data *cd);
+	int (*init)(struct geniv_ctx_data *cd);
+	int (*wipe)(struct geniv_ctx_data *cd);
+	int (*generator)(struct geniv_ctx_data *req, u8 *iv,
+			 struct dm_crypt_request *dmreq);
+	int (*post)(struct geniv_ctx_data *cd, u8 *iv,
+			 struct dm_crypt_request *dmreq);
+};
+
+struct geniv_ctx_data {
+	unsigned int tfms_count;
+	char *ivmode;
+	unsigned int iv_size;
+	char *ivopts;
+	unsigned int dmoffset;
+
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
+struct geniv_ctx {
+	struct crypto_skcipher *child;
+	struct geniv_ctx_data data;
+};
+
+#endif
+
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index cc4d98a..290c848 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -122,6 +122,8 @@ struct crypto_skcipher {
 struct skcipher_alg {
 	int (*setkey)(struct crypto_skcipher *tfm, const u8 *key,
 	              unsigned int keylen);
+	int (*set_ctx)(struct crypto_skcipher *tfm, void *ctx,
+		       unsigned int len);
 	int (*encrypt)(struct skcipher_request *req);
 	int (*decrypt)(struct skcipher_request *req);
 	int (*init)(struct crypto_skcipher *tfm);
@@ -366,6 +368,21 @@ static inline int crypto_skcipher_setkey(struct crypto_skcipher *tfm,
 {
 	return tfm->setkey(tfm, key, keylen);
 }
+/**
+ * crypto_skcipher_set_ctx() - set initial context for cipher
+ * @tfm: cipher handle
+ * @ctx: buffer holding the context data
+ * @len: length of the context data structure
+ *
+ */
+static inline void crypto_skcipher_set_ctx(struct crypto_skcipher *tfm,
+					 void *ctx, unsigned int len)
+{
+	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
+
+	alg->set_ctx(tfm, ctx, len);
+}
+
 
 static inline bool crypto_skcipher_has_setkey(struct crypto_skcipher *tfm)
 {
-- 
Binoy Jayan
