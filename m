From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [crypto] S390-AES add fallback driver.
Date: Fri, 30 Nov 2007 13:39:10 +0100
Message-ID: <20071130123910.GA1814@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Jan Glauber <jang@linux.vnet.ibm.com>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:57264 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755195AbXK3MjT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 Nov 2007 07:39:19 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Some CPUs support only 128 bit keys in HW. This patch adds SW fallback
support for the other keys which may be required. The generic algorithm
(and the block mode) must be availble in case of a fallback.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>

--- linux-2.6/arch/s390/crypto/aes_s390.c.fallback
+++ linux-2.6/arch/s390/crypto/aes_s390.c
@@ -6,6 +6,7 @@
  * s390 Version:
  *   Copyright IBM Corp. 2005,2007
  *   Author(s): Jan Glauber (jang@de.ibm.com)
+ *		Sebastian Siewior (sebastian@breakpoint.cc> SW-Fallback
  *
  * Derived from "crypto/aes_generic.c"
  *
@@ -17,6 +18,7 @@
  */
 
 #include <crypto/algapi.h>
+#include <linux/err.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include "crypt_s390.h"
@@ -39,45 +41,89 @@ struct s390_aes_ctx {
 	long enc;
 	long dec;
 	int key_len;
+	union {
+		struct crypto_blkcipher *blk;
+		struct crypto_cipher *cip;
+	} fallback;
 };
 
-static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
-		       unsigned int key_len)
+/*
+ * Check if the key_len is supported by the HW.
+ * Returns 0 if it is, a positive number if it is not and software fallback is
+ * required or a negative number in case the key size is not valid
+ */
+static int need_fallback(unsigned int key_len)
 {
-	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
-	u32 *flags = &tfm->crt_flags;
-
 	switch (key_len) {
 	case 16:
 		if (!(keylen_flag & AES_KEYLEN_128))
-			goto fail;
+			return 1;
 		break;
 	case 24:
 		if (!(keylen_flag & AES_KEYLEN_192))
-			goto fail;
-
+			return 1;
 		break;
 	case 32:
 		if (!(keylen_flag & AES_KEYLEN_256))
-			goto fail;
+			return 1;
 		break;
 	default:
-		goto fail;
+		return -1;
 		break;
 	}
+	return 0;
+}
+
+static int setkey_fallback_cip(struct crypto_tfm *tfm, const u8 *in_key,
+		unsigned int key_len)
+{
+	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
+	int ret;
+
+	sctx->fallback.blk->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
+	sctx->fallback.blk->base.crt_flags |= (tfm->crt_flags &
+			CRYPTO_TFM_REQ_MASK);
+
+	ret = crypto_cipher_setkey(sctx->fallback.cip, in_key, key_len);
+	if (ret) {
+		tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
+		tfm->crt_flags |= (sctx->fallback.blk->base.crt_flags &
+				CRYPTO_TFM_RES_MASK);
+	}
+	return ret;
+}
+
+static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
+		       unsigned int key_len)
+{
+	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
+	u32 *flags = &tfm->crt_flags;
+	int ret;
+
+	ret = need_fallback(key_len);
+	if (ret < 0) {
+		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+		return -EINVAL;
+	}
 
 	sctx->key_len = key_len;
-	memcpy(sctx->key, in_key, key_len);
-	return 0;
-fail:
-	*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
-	return -EINVAL;
+	if (!ret) {
+		memcpy(sctx->key, in_key, key_len);
+		return 0;
+	}
+
+	return setkey_fallback_cip(tfm, in_key, key_len);
 }
 
 static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	const struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
 
+	if (unlikely(need_fallback(sctx->key_len))) {
+		crypto_cipher_encrypt_one(sctx->fallback.cip, out, in);
+		return;
+	}
+
 	switch (sctx->key_len) {
 	case 16:
 		crypt_s390_km(KM_AES_128_ENCRYPT, &sctx->key, out, in,
@@ -98,6 +144,11 @@ static void aes_decrypt(struct crypto_tf
 {
 	const struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
 
+	if (unlikely(need_fallback(sctx->key_len))) {
+		crypto_cipher_decrypt_one(sctx->fallback.cip, out, in);
+		return;
+	}
+
 	switch (sctx->key_len) {
 	case 16:
 		crypt_s390_km(KM_AES_128_DECRYPT, &sctx->key, out, in,
@@ -114,6 +165,29 @@ static void aes_decrypt(struct crypto_tf
 	}
 }
 
+static int fallback_init_cip(struct crypto_tfm *tfm)
+{
+	const char *name = tfm->__crt_alg->cra_name;
+	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
+
+	sctx->fallback.cip = crypto_alloc_cipher(name, 0,
+			CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
+
+	if (IS_ERR(sctx->fallback.cip)) {
+		printk(KERN_ERR "Error allocating fallback algo %s\n", name);
+		return PTR_ERR(sctx->fallback.blk);
+	}
+
+	return 0;
+}
+
+static void fallback_exit_cip(struct crypto_tfm *tfm)
+{
+	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
+
+	crypto_free_cipher(sctx->fallback.cip);
+	sctx->fallback.cip = NULL;
+}
 
 static struct crypto_alg aes_alg = {
 	.cra_name		=	"aes",
@@ -125,6 +199,8 @@ static struct crypto_alg aes_alg = {
 	.cra_ctxsize		=	sizeof(struct s390_aes_ctx),
 	.cra_module		=	THIS_MODULE,
 	.cra_list		=	LIST_HEAD_INIT(aes_alg.cra_list),
+	.cra_init               =       fallback_init_cip,
+	.cra_exit               =       fallback_exit_cip,
 	.cra_u			=	{
 		.cipher = {
 			.cia_min_keysize	=	AES_MIN_KEY_SIZE,
@@ -136,10 +212,76 @@ static struct crypto_alg aes_alg = {
 	}
 };
 
+static int setkey_fallback_blk(struct crypto_tfm *tfm, const u8 *key,
+		unsigned int len)
+{
+	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
+	unsigned int ret;
+
+	sctx->fallback.blk->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
+	sctx->fallback.blk->base.crt_flags |= (tfm->crt_flags &
+			CRYPTO_TFM_REQ_MASK);
+
+	ret = crypto_blkcipher_setkey(sctx->fallback.blk, key, len);
+	if (ret) {
+		tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
+		tfm->crt_flags |= (sctx->fallback.blk->base.crt_flags &
+				CRYPTO_TFM_RES_MASK);
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
+	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
+
+	memcpy(crypto_blkcipher_crt(sctx->fallback.blk)->iv, desc->info,
+		AES_BLOCK_SIZE);
+
+	tfm = desc->tfm;
+	desc->tfm = sctx->fallback.blk;
+
+	ret = crypto_blkcipher_decrypt(desc, dst, src, nbytes);
+
+	desc->tfm = tfm;
+	return ret;
+}
+
+static int fallback_blk_enc(struct blkcipher_desc *desc,
+		struct scatterlist *dst, struct scatterlist *src,
+		unsigned int nbytes)
+{
+	unsigned int ret;
+	struct crypto_blkcipher *tfm;
+	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
+
+	memcpy(crypto_blkcipher_crt(sctx->fallback.blk)->iv, desc->info,
+		AES_BLOCK_SIZE);
+
+	tfm = desc->tfm;
+	desc->tfm = sctx->fallback.blk;
+
+	ret = crypto_blkcipher_encrypt(desc, dst, src, nbytes);
+
+	desc->tfm = tfm;
+	return ret;
+}
+
 static int ecb_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 			   unsigned int key_len)
 {
 	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
+	int ret;
+
+	ret = need_fallback(key_len);
+	if (ret > 0) {
+		sctx->key_len = key_len;
+		return setkey_fallback_blk(tfm, in_key, key_len);
+	}
 
 	switch (key_len) {
 	case 16:
@@ -188,6 +330,9 @@ static int ecb_aes_encrypt(struct blkcip
 	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
 
+	if (unlikely(need_fallback(sctx->key_len)))
+		return fallback_blk_enc(desc, dst, src, nbytes);
+
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	return ecb_aes_crypt(desc, sctx->enc, sctx->key, &walk);
 }
@@ -199,10 +344,37 @@ static int ecb_aes_decrypt(struct blkcip
 	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
 
+	if (unlikely(need_fallback(sctx->key_len)))
+		return fallback_blk_dec(desc, dst, src, nbytes);
+
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	return ecb_aes_crypt(desc, sctx->dec, sctx->key, &walk);
 }
 
+static int fallback_init_blk(struct crypto_tfm *tfm)
+{
+	const char *name = tfm->__crt_alg->cra_name;
+	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
+
+	sctx->fallback.blk = crypto_alloc_blkcipher(name, 0,
+			CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
+
+	if (IS_ERR(sctx->fallback.blk)) {
+		printk(KERN_ERR "Error allocating fallback algo %s\n", name);
+		return PTR_ERR(sctx->fallback.blk);
+	}
+
+	return 0;
+}
+
+static void fallback_exit_blk(struct crypto_tfm *tfm)
+{
+	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
+
+	crypto_free_blkcipher(sctx->fallback.blk);
+	sctx->fallback.blk = NULL;
+}
+
 static struct crypto_alg ecb_aes_alg = {
 	.cra_name		=	"ecb(aes)",
 	.cra_driver_name	=	"ecb-aes-s390",
@@ -214,6 +386,8 @@ static struct crypto_alg ecb_aes_alg = {
 	.cra_type		=	&crypto_blkcipher_type,
 	.cra_module		=	THIS_MODULE,
 	.cra_list		=	LIST_HEAD_INIT(ecb_aes_alg.cra_list),
+	.cra_init		=	fallback_init_blk,
+	.cra_exit		=	fallback_exit_blk,
 	.cra_u			=	{
 		.blkcipher = {
 			.min_keysize		=	AES_MIN_KEY_SIZE,
@@ -229,6 +403,13 @@ static int cbc_aes_set_key(struct crypto
 			   unsigned int key_len)
 {
 	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
+	int ret;
+
+	ret = need_fallback(key_len);
+	if (ret > 0) {
+		sctx->key_len = key_len;
+		return setkey_fallback_blk(tfm, in_key, key_len);
+	}
 
 	switch (key_len) {
 	case 16:
@@ -283,6 +464,9 @@ static int cbc_aes_encrypt(struct blkcip
 	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
 
+	if (unlikely(need_fallback(sctx->key_len)))
+		return fallback_blk_enc(desc, dst, src, nbytes);
+
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	return cbc_aes_crypt(desc, sctx->enc, sctx->iv, &walk);
 }
@@ -294,6 +478,9 @@ static int cbc_aes_decrypt(struct blkcip
 	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
 
+	if (unlikely(need_fallback(sctx->key_len)))
+		return fallback_blk_dec(desc, dst, src, nbytes);
+
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	return cbc_aes_crypt(desc, sctx->dec, sctx->iv, &walk);
 }
@@ -309,6 +496,8 @@ static struct crypto_alg cbc_aes_alg = {
 	.cra_type		=	&crypto_blkcipher_type,
 	.cra_module		=	THIS_MODULE,
 	.cra_list		=	LIST_HEAD_INIT(cbc_aes_alg.cra_list),
+	.cra_init		=	fallback_init_blk,
+	.cra_exit		=	fallback_exit_blk,
 	.cra_u			=	{
 		.blkcipher = {
 			.min_keysize		=	AES_MIN_KEY_SIZE,
@@ -336,14 +525,10 @@ static int __init aes_init(void)
 		return -EOPNOTSUPP;
 
 	/* z9 109 and z9 BC/EC only support 128 bit key length */
-	if (keylen_flag == AES_KEYLEN_128) {
-		aes_alg.cra_u.cipher.cia_max_keysize = AES_MIN_KEY_SIZE;
-		ecb_aes_alg.cra_u.blkcipher.max_keysize = AES_MIN_KEY_SIZE;
-		cbc_aes_alg.cra_u.blkcipher.max_keysize = AES_MIN_KEY_SIZE;
+	if (keylen_flag == AES_KEYLEN_128)
 		printk(KERN_INFO
 		       "aes_s390: hardware acceleration only available for"
 		       "128 bit keys\n");
-	}
 
 	ret = crypto_register_alg(&aes_alg);
 	if (ret)
@@ -382,4 +567,3 @@ MODULE_ALIAS("aes");
 
 MODULE_DESCRIPTION("Rijndael (AES) Cipher Algorithm");
 MODULE_LICENSE("GPL");
-
