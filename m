From: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: [PATCH] s390: add fallback for unsupported XTS-384 mode
Date: Thu, 21 Apr 2011 15:18:19 +0200
Message-ID: <1303391899.10786.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>,
	Gerald =?ISO-8859-1?Q?Sch=E4fer?= <geraldsc@de.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:34913 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab1DUNS0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Apr 2011 09:18:26 -0400
Received: from d06nrmr1707.portsmouth.uk.ibm.com (d06nrmr1707.portsmouth.uk.ibm.com [9.149.39.225])
	by mtagate2.uk.ibm.com (8.13.1/8.13.1) with ESMTP id p3LDIKkv017973
	for <linux-crypto@vger.kernel.org>; Thu, 21 Apr 2011 13:18:20 GMT
Received: from d06av09.portsmouth.uk.ibm.com (d06av09.portsmouth.uk.ibm.com [9.149.37.250])
	by d06nrmr1707.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p3LDJIRO1827000
	for <linux-crypto@vger.kernel.org>; Thu, 21 Apr 2011 14:19:18 +0100
Received: from d06av09.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av09.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p3LDIKfZ010415
	for <linux-crypto@vger.kernel.org>; Thu, 21 Apr 2011 07:18:20 -0600
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

this is the fallback code for XTS. It should fit on top of the s390 series.

thanks,
Jan
-----

From: Jan Glauber <jang@linux.vnet.ibm.com>

The z196 XTS acceleration only supports the two official XTS
modes (256 and 512 bit keys). Since the software XTS implementation
allows all three AES key lengths to be used with XTS add a
fallback to the s390 implementation for the 384 bit key case.

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
---
 arch/s390/crypto/aes_s390.c |   95 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/crypto/Kconfig      |    5 +-
 2 files changed, 96 insertions(+), 4 deletions(-)

--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -61,6 +61,7 @@ struct s390_xts_ctx {
 	long enc;
 	long dec;
 	int key_len;
+	struct crypto_blkcipher *fallback;
 };
 
 /*
@@ -522,6 +523,59 @@ static struct crypto_alg cbc_aes_alg = {
 	}
 };
 
+static int xts_fallback_setkey(struct crypto_tfm *tfm, const u8 *key,
+				   unsigned int len)
+{
+	struct s390_xts_ctx *xts_ctx = crypto_tfm_ctx(tfm);
+	unsigned int ret;
+
+	xts_ctx->fallback->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
+	xts_ctx->fallback->base.crt_flags |= (tfm->crt_flags &
+			CRYPTO_TFM_REQ_MASK);
+
+	ret = crypto_blkcipher_setkey(xts_ctx->fallback, key, len);
+	if (ret) {
+		tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
+		tfm->crt_flags |= (xts_ctx->fallback->base.crt_flags &
+				CRYPTO_TFM_RES_MASK);
+	}
+	return ret;
+}
+
+static int xts_fallback_decrypt(struct blkcipher_desc *desc,
+		struct scatterlist *dst, struct scatterlist *src,
+		unsigned int nbytes)
+{
+	struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct crypto_blkcipher *tfm;
+	unsigned int ret;
+
+	tfm = desc->tfm;
+	desc->tfm = xts_ctx->fallback;
+
+	ret = crypto_blkcipher_decrypt_iv(desc, dst, src, nbytes);
+
+	desc->tfm = tfm;
+	return ret;
+}
+
+static int xts_fallback_encrypt(struct blkcipher_desc *desc,
+		struct scatterlist *dst, struct scatterlist *src,
+		unsigned int nbytes)
+{
+	struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct crypto_blkcipher *tfm;
+	unsigned int ret;
+
+	tfm = desc->tfm;
+	desc->tfm = xts_ctx->fallback;
+
+	ret = crypto_blkcipher_encrypt_iv(desc, dst, src, nbytes);
+
+	desc->tfm = tfm;
+	return ret;
+}
+
 static int xts_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 			   unsigned int key_len)
 {
@@ -535,6 +589,11 @@ static int xts_aes_set_key(struct crypto
 		memcpy(xts_ctx->key + 16, in_key, 16);
 		memcpy(xts_ctx->pcc.key + 16, in_key + 16, 16);
 		break;
+	case 48:
+		xts_ctx->enc = 0;
+		xts_ctx->dec = 0;
+		xts_fallback_setkey(tfm, in_key, key_len);
+		break;
 	case 64:
 		xts_ctx->enc = KM_XTS_256_ENCRYPT;
 		xts_ctx->dec = KM_XTS_256_DECRYPT;
@@ -596,6 +655,9 @@ static int xts_aes_encrypt(struct blkcip
 	struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
 
+	if (unlikely(xts_ctx->key_len == 48))
+		return xts_fallback_encrypt(desc, dst, src, nbytes);
+
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	return xts_aes_crypt(desc, xts_ctx->enc, xts_ctx, &walk);
 }
@@ -607,20 +669,50 @@ static int xts_aes_decrypt(struct blkcip
 	struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
 
+	if (unlikely(xts_ctx->key_len == 48))
+		return xts_fallback_decrypt(desc, dst, src, nbytes);
+
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	return xts_aes_crypt(desc, xts_ctx->dec, xts_ctx, &walk);
 }
 
+static int xts_fallback_init(struct crypto_tfm *tfm)
+{
+	const char *name = tfm->__crt_alg->cra_name;
+	struct s390_xts_ctx *xts_ctx = crypto_tfm_ctx(tfm);
+
+	xts_ctx->fallback = crypto_alloc_blkcipher(name, 0,
+			CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
+
+	if (IS_ERR(xts_ctx->fallback)) {
+		pr_err("Allocating XTS fallback algorithm %s failed\n",
+		       name);
+		return PTR_ERR(xts_ctx->fallback);
+	}
+	return 0;
+}
+
+static void xts_fallback_exit(struct crypto_tfm *tfm)
+{
+	struct s390_xts_ctx *xts_ctx = crypto_tfm_ctx(tfm);
+
+	crypto_free_blkcipher(xts_ctx->fallback);
+	xts_ctx->fallback = NULL;
+}
+
 static struct crypto_alg xts_aes_alg = {
 	.cra_name		=	"xts(aes)",
 	.cra_driver_name	=	"xts-aes-s390",
 	.cra_priority		=	CRYPT_S390_COMPOSITE_PRIORITY,
-	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER |
+					CRYPTO_ALG_NEED_FALLBACK,
 	.cra_blocksize		=	AES_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct s390_xts_ctx),
 	.cra_type		=	&crypto_blkcipher_type,
 	.cra_module		=	THIS_MODULE,
 	.cra_list		=	LIST_HEAD_INIT(xts_aes_alg.cra_list),
+	.cra_init		=	xts_fallback_init,
+	.cra_exit		=	xts_fallback_exit,
 	.cra_u			=	{
 		.blkcipher = {
 			.min_keysize		=	2 * AES_MIN_KEY_SIZE,
@@ -784,7 +876,6 @@ static int __init aes_s390_init(void)
 	if (ret)
 		goto cbc_aes_err;
 
-	/* check for one key size is enough */
 	if (crypt_s390_func_available(KM_XTS_128_ENCRYPT,
 			CRYPT_S390_MSA | CRYPT_S390_MSA4) &&
 	    crypt_s390_func_available(KM_XTS_256_ENCRYPT,
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -138,8 +138,9 @@ config CRYPTO_AES_S390
 	  for 128 bit keys.
 	  As of z10 the ECB and CBC modes are hardware accelerated
 	  for all AES key sizes.
-	  As of z196 the XTS and CTR modes are hardware accelerated.
-
+	  As of z196 the CTR mode is hardware accelerated for all AES
+	  key sizes and XTS mode is hardware accelerated for 256 and
+	  512 bit keys.
 
 config S390_PRNG
 	tristate "Pseudo random number generator device driver"
