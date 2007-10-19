From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [RFC 4/5] [crypto] geode: add fallback for unsupported modes.
Date: Fri, 19 Oct 2007 12:03:52 +0200
Message-ID: <1192788233-14968-5-git-send-email-linux-crypto@ml.breakpoint.cc>
References: <1192788233-14968-1-git-send-email-linux-crypto@ml.breakpoint.cc>
Cc: linux-crypto@vger.kernel.org,
	Sebastian Siewior <sebastian@breakpoint.cc>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60856 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756484AbXJSKDz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Oct 2007 06:03:55 -0400
In-Reply-To: <1192788233-14968-1-git-send-email-linux-crypto@ml.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Sebastian Siewior <sebastian@breakpoint.cc>

The Geode AES crypto engine supports only 128 bit long key. This
patch adds fallback for other key sizes which are required by the
AES standard.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 drivers/crypto/geode-aes.c |  188 +++++++++++++++++++++++++++++++++++++++-----
 drivers/crypto/geode-aes.h |    6 ++
 2 files changed, 173 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index da6164a..761d600 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -118,14 +118,82 @@ static int
 geode_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int len)
 {
 	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
+	unsigned int type;
+	unsigned int ret;
 
-	if (len != AES_KEY_LENGTH) {
+	op->keylen = len;
+
+	if (len == AES_KEY_LENGTH) {
+		memcpy(op->key, key, len);
+		return 0;
+	}
+
+	if (len != 24 && len != 32) {
+		/* not supported at all */
 		tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
 		return -EINVAL;
 	}
 
-	memcpy(op->key, key, len);
-	return 0;
+	/*
+	 * The requested key size is not supported by HW, do a fallback
+	 */
+
+	type = tfm->__crt_alg->cra_flags & CRYPTO_ALG_TYPE_MASK;
+
+	/* propagate requested flags to the fallback driver */
+	op->fallback.blk->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
+	op->fallback.blk->base.crt_flags |= (tfm->crt_flags & CRYPTO_TFM_REQ_MASK);
+
+	if (type == CRYPTO_ALG_TYPE_BLKCIPHER) {
+		ret = crypto_blkcipher_setkey(op->fallback.blk, key, len);
+
+	} else if (type == CRYPTO_ALG_TYPE_CIPHER) {
+		ret = crypto_cipher_setkey(op->fallback.cip, key, len);
+
+	} else {
+		printk(KERN_ERR "Neither a cipher nor a block cipher. %x / %x\n",
+				type, tfm->crt_flags);
+		return -EINVAL;
+	}
+
+	if (ret) {
+		tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
+		tfm->crt_flags |= (op->fallback.blk->base.crt_flags & CRYPTO_TFM_RES_MASK);
+	}
+	return ret;
+}
+
+static int fallback_blk_dec(struct blkcipher_desc *desc,
+		struct scatterlist *dst, struct scatterlist *src,
+		unsigned int nbytes)
+{
+	unsigned int ret;
+	struct crypto_blkcipher *tfm;
+	struct geode_aes_op *op = crypto_blkcipher_ctx(desc->tfm);
+
+	tfm = desc->tfm;
+	desc->tfm = op->fallback.blk;
+
+	ret = crypto_blkcipher_decrypt(desc, dst, src, nbytes);
+
+	desc->tfm = tfm;
+	return ret;
+}
+static int fallback_blk_enc(struct blkcipher_desc *desc,
+		struct scatterlist *dst, struct scatterlist *src,
+		unsigned int nbytes)
+{
+	unsigned int ret;
+	struct crypto_blkcipher *tfm;
+	struct geode_aes_op *op = crypto_blkcipher_ctx(desc->tfm);
+
+	tfm = desc->tfm;
+	desc->tfm = op->fallback.blk;
+
+	ret = crypto_blkcipher_encrypt(desc, dst, src, nbytes);
+
+	desc->tfm = tfm;
+	return ret;
 }
 
 static void
@@ -133,8 +201,10 @@ geode_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
 
-	if ((out == NULL) || (in == NULL))
+	if (unlikely(op->keylen != 16)) {
+		crypto_cipher_encrypt_one(op->fallback.cip, out, in);
 		return;
+	}
 
 	op->src = (void *) in;
 	op->dst = (void *) out;
@@ -152,8 +222,10 @@ geode_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
 
-	if ((out == NULL) || (in == NULL))
+	if (unlikely(op->keylen != 16)) {
+		crypto_cipher_decrypt_one(op->fallback.cip, out, in);
 		return;
+	}
 
 	op->src = (void *) in;
 	op->dst = (void *) out;
@@ -165,21 +237,76 @@ geode_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	geode_aes_crypt(op);
 }
 
+static int fallback_init(struct crypto_tfm *tfm)
+{
+	const char *name = tfm->__crt_alg->cra_name;
+	unsigned int type;
+	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
+
+	type = tfm->__crt_alg->cra_flags & CRYPTO_ALG_TYPE_MASK;
+
+	if (type == CRYPTO_ALG_TYPE_BLKCIPHER) {
+		op->fallback.blk = crypto_alloc_blkcipher(name, 0,
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
+
+	} else if (type == CRYPTO_ALG_TYPE_CIPHER) {
+		op->fallback.cip = crypto_alloc_cipher(name, 0,
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
+	} else {
+		printk(KERN_ERR "%s is neither a cipher nor a block cipher: %x\n",
+				name, type);
+		return -EINVAL;
+	}
+
+	/*
+	 * cipher / blkcipher, this is the same pointer for both. One check is
+	 * enough
+	 */
+	if (IS_ERR(op->fallback.blk)) {
+		printk(KERN_ERR "Error allocating fallback algo %s\n", name);
+		return PTR_ERR(op->fallback.blk);
+	}
+
+	return 0;
+}
+
+static void fallback_exit(struct crypto_tfm *tfm)
+{
+	unsigned int type;
+	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
+
+	type = tfm->__crt_alg->cra_flags & CRYPTO_ALG_TYPE_MASK;
+	if (type == CRYPTO_ALG_TYPE_BLKCIPHER) {
+		crypto_free_blkcipher(op->fallback.blk);
+		op->fallback.blk = NULL;
+		return;
+
+	} else if (type == CRYPTO_ALG_TYPE_CIPHER) {
+		crypto_free_cipher(op->fallback.cip);
+		op->fallback.cip = NULL;
+		return;
+	}
+
+	WARN_ON(1);
+}
 
 static struct crypto_alg geode_alg = {
 	.cra_name               =       "aes",
-	.cra_driver_name	=       "geode-aes-128",
+	.cra_driver_name	=       "geode-aes",
 	.cra_priority           =       300,
 	.cra_alignmask          =       15,
-	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
+	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER |
+					CRYPTO_ALG_NEED_FALLBACK,
+	.cra_init               =       fallback_init,
+	.cra_exit               =       fallback_exit,
 	.cra_blocksize		=	AES_MIN_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct geode_aes_op),
 	.cra_module		=	THIS_MODULE,
 	.cra_list		=	LIST_HEAD_INIT(geode_alg.cra_list),
 	.cra_u			=	{
 		.cipher = {
-			.cia_min_keysize	=  AES_KEY_LENGTH,
-			.cia_max_keysize	=  AES_KEY_LENGTH,
+			.cia_min_keysize	=  AES_MIN_KEY_SIZE,
+			.cia_max_keysize	=  AES_MAX_KEY_SIZE,
 			.cia_setkey		=  geode_setkey,
 			.cia_encrypt		=  geode_encrypt,
 			.cia_decrypt		=  geode_decrypt
@@ -196,6 +323,9 @@ geode_cbc_decrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	int err, ret;
 
+	if (unlikely(op->keylen != 16))
+		return fallback_blk_dec(desc, dst, src, nbytes);
+
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
 	memcpy(op->iv, walk.iv, AES_IV_LENGTH);
@@ -226,6 +356,9 @@ geode_cbc_encrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	int err, ret;
 
+	if (unlikely(op->keylen != 16))
+		return fallback_blk_enc(desc, dst, src, nbytes);
+
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
 	memcpy(op->iv, walk.iv, AES_IV_LENGTH);
@@ -248,9 +381,12 @@ geode_cbc_encrypt(struct blkcipher_desc *desc,
 
 static struct crypto_alg geode_cbc_alg = {
 	.cra_name		=	"cbc(aes)",
-	.cra_driver_name	=	"cbc-aes-geode-128",
-	.cra_priority		=	400,
-	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_driver_name	=	"cbc-aes-geode",
+	.cra_priority		=	300,
+	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER |
+					CRYPTO_ALG_NEED_FALLBACK,
+	.cra_init               =       fallback_init,
+	.cra_exit               =       fallback_exit,
 	.cra_blocksize		=	AES_MIN_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct geode_aes_op),
 	.cra_alignmask		=	15,
@@ -259,8 +395,8 @@ static struct crypto_alg geode_cbc_alg = {
 	.cra_list		=	LIST_HEAD_INIT(geode_cbc_alg.cra_list),
 	.cra_u			=	{
 		.blkcipher = {
-			.min_keysize		=	AES_KEY_LENGTH,
-			.max_keysize		=	AES_KEY_LENGTH,
+			.min_keysize		=	AES_MIN_KEY_SIZE,
+			.max_keysize		=	AES_MAX_KEY_SIZE,
 			.setkey			=	geode_setkey,
 			.encrypt		=	geode_cbc_encrypt,
 			.decrypt		=	geode_cbc_decrypt,
@@ -278,6 +414,9 @@ geode_ecb_decrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	int err, ret;
 
+	if (unlikely(op->keylen != 16))
+		return fallback_blk_dec(desc, dst, src, nbytes);
+
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
 
@@ -305,6 +444,9 @@ geode_ecb_encrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	int err, ret;
 
+	if (unlikely(op->keylen != 16))
+		return fallback_blk_enc(desc, dst, src, nbytes);
+
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
 
@@ -325,9 +467,12 @@ geode_ecb_encrypt(struct blkcipher_desc *desc,
 
 static struct crypto_alg geode_ecb_alg = {
 	.cra_name		=	"ecb(aes)",
-	.cra_driver_name	=	"ecb-aes-geode-128",
-	.cra_priority		=	400,
-	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_driver_name	=	"ecb-aes-geode",
+	.cra_priority		=	300,
+	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER |
+					CRYPTO_ALG_NEED_FALLBACK,
+	.cra_init               =       fallback_init,
+	.cra_exit               =       fallback_exit,
 	.cra_blocksize		=	AES_MIN_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct geode_aes_op),
 	.cra_alignmask		=	15,
@@ -336,8 +481,8 @@ static struct crypto_alg geode_ecb_alg = {
 	.cra_list		=	LIST_HEAD_INIT(geode_ecb_alg.cra_list),
 	.cra_u			=	{
 		.blkcipher = {
-			.min_keysize		=	AES_KEY_LENGTH,
-			.max_keysize		=	AES_KEY_LENGTH,
+			.min_keysize		=	AES_MIN_KEY_SIZE,
+			.max_keysize		=	AES_MAX_KEY_SIZE,
 			.setkey			=	geode_setkey,
 			.encrypt		=	geode_ecb_encrypt,
 			.decrypt		=	geode_ecb_decrypt,
@@ -368,7 +513,7 @@ geode_aes_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	if ((ret = pci_enable_device(dev)))
 		return ret;
 
-	if ((ret = pci_request_regions(dev, "geode-aes-128")))
+	if ((ret = pci_request_regions(dev, "geode-aes")))
 		goto eenable;
 
 	_iobase = pci_iomap(dev, 0, 0);
@@ -392,7 +537,8 @@ geode_aes_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	if ((ret = crypto_register_alg(&geode_cbc_alg)))
 		goto eecb;
 
-	printk(KERN_NOTICE "geode-aes: GEODE AES engine enabled.\n");
+	printk(KERN_NOTICE "geode-aes: GEODE AES engine enabled. "
+			"Only 128-bit keys are supported by the Hardware.\n");
 	return 0;
 
  eecb:
diff --git a/drivers/crypto/geode-aes.h b/drivers/crypto/geode-aes.h
index 2f1d559..14cc763 100644
--- a/drivers/crypto/geode-aes.h
+++ b/drivers/crypto/geode-aes.h
@@ -66,6 +66,12 @@ struct geode_aes_op {
 
 	u8 key[AES_KEY_LENGTH];
 	u8 iv[AES_IV_LENGTH];
+
+	union {
+		struct crypto_blkcipher *blk;
+		struct crypto_cipher *cip;
+	} fallback;
+	u32 keylen;
 };
 
 #endif
-- 
1.5.3.4
