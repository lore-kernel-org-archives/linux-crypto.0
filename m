From: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: [PATCH 1/2] des_s390: remove des3_ede128 mode
Date: Thu, 20 May 2010 13:19:11 +0200
Message-ID: <1274354351.15679.12.camel@hal>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.17.165]:57115 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab0ETLTP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 May 2010 07:19:15 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate5.de.ibm.com (8.13.1/8.13.1) with ESMTP id o4KBJEel017481
	for <linux-crypto@vger.kernel.org>; Thu, 20 May 2010 11:19:14 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o4KBJERt872564
	for <linux-crypto@vger.kernel.org>; Thu, 20 May 2010 13:19:14 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o4KBJEf2023927
	for <linux-crypto@vger.kernel.org>; Thu, 20 May 2010 13:19:14 +0200
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

des_s390 implements support for 3DES with a 128 bit key. This mode is probably
not used anywhere, less secure than 3DES with a 192 bit key and not
implemented in the generic des version. Removing this mode seems to be low risk
and will ease maintenance of the code.

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
---
 arch/s390/crypto/des_s390.c |  191 --------------------------------------------
 1 file changed, 1 insertion(+), 190 deletions(-)

--- a/arch/s390/crypto/des_s390.c
+++ b/arch/s390/crypto/des_s390.c
@@ -24,9 +24,6 @@
 #define DES_BLOCK_SIZE 8
 #define DES_KEY_SIZE 8
 
-#define DES3_128_KEY_SIZE	(2 * DES_KEY_SIZE)
-#define DES3_128_BLOCK_SIZE	DES_BLOCK_SIZE
-
 #define DES3_192_KEY_SIZE	(3 * DES_KEY_SIZE)
 #define DES3_192_BLOCK_SIZE	DES_BLOCK_SIZE
 
@@ -35,11 +32,6 @@ struct crypt_s390_des_ctx {
 	u8 key[DES_KEY_SIZE];
 };
 
-struct crypt_s390_des3_128_ctx {
-	u8 iv[DES_BLOCK_SIZE];
-	u8 key[DES3_128_KEY_SIZE];
-};
-
 struct crypt_s390_des3_192_ctx {
 	u8 iv[DES_BLOCK_SIZE];
 	u8 key[DES3_192_KEY_SIZE];
@@ -237,165 +229,6 @@ static struct crypto_alg cbc_des_alg = {
  *   complementation keys.  Any weakness is obviated by the use of
  *   multiple keys.
  *
- *   However, if the two  independent 64-bit keys are equal,
- *   then the DES3 operation is simply the same as DES.
- *   Implementers MUST reject keys that exhibit this property.
- *
- */
-static int des3_128_setkey(struct crypto_tfm *tfm, const u8 *key,
-			   unsigned int keylen)
-{
-	int i, ret;
-	struct crypt_s390_des3_128_ctx *dctx = crypto_tfm_ctx(tfm);
-	const u8 *temp_key = key;
-	u32 *flags = &tfm->crt_flags;
-
-	if (!(memcmp(key, &key[DES_KEY_SIZE], DES_KEY_SIZE)) &&
-	    (*flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
-		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		return -EINVAL;
-	}
-	for (i = 0; i < 2; i++, temp_key += DES_KEY_SIZE) {
-		ret = crypto_des_check_key(temp_key, DES_KEY_SIZE, flags);
-		if (ret < 0)
-			return ret;
-	}
-	memcpy(dctx->key, key, keylen);
-	return 0;
-}
-
-static void des3_128_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
-{
-	struct crypt_s390_des3_128_ctx *dctx = crypto_tfm_ctx(tfm);
-
-	crypt_s390_km(KM_TDEA_128_ENCRYPT, dctx->key, dst, (void*)src,
-		      DES3_128_BLOCK_SIZE);
-}
-
-static void des3_128_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
-{
-	struct crypt_s390_des3_128_ctx *dctx = crypto_tfm_ctx(tfm);
-
-	crypt_s390_km(KM_TDEA_128_DECRYPT, dctx->key, dst, (void*)src,
-		      DES3_128_BLOCK_SIZE);
-}
-
-static struct crypto_alg des3_128_alg = {
-	.cra_name		=	"des3_ede128",
-	.cra_driver_name	=	"des3_ede128-s390",
-	.cra_priority		=	CRYPT_S390_PRIORITY,
-	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
-	.cra_blocksize		=	DES3_128_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct crypt_s390_des3_128_ctx),
-	.cra_module		=	THIS_MODULE,
-	.cra_list		=	LIST_HEAD_INIT(des3_128_alg.cra_list),
-	.cra_u			=	{
-		.cipher = {
-			.cia_min_keysize	=	DES3_128_KEY_SIZE,
-			.cia_max_keysize	=	DES3_128_KEY_SIZE,
-			.cia_setkey		=	des3_128_setkey,
-			.cia_encrypt		=	des3_128_encrypt,
-			.cia_decrypt		=	des3_128_decrypt,
-		}
-	}
-};
-
-static int ecb_des3_128_encrypt(struct blkcipher_desc *desc,
-				struct scatterlist *dst,
-				struct scatterlist *src, unsigned int nbytes)
-{
-	struct crypt_s390_des3_128_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk walk;
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return ecb_desall_crypt(desc, KM_TDEA_128_ENCRYPT, sctx->key, &walk);
-}
-
-static int ecb_des3_128_decrypt(struct blkcipher_desc *desc,
-				struct scatterlist *dst,
-				struct scatterlist *src, unsigned int nbytes)
-{
-	struct crypt_s390_des3_128_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk walk;
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return ecb_desall_crypt(desc, KM_TDEA_128_DECRYPT, sctx->key, &walk);
-}
-
-static struct crypto_alg ecb_des3_128_alg = {
-	.cra_name		=	"ecb(des3_ede128)",
-	.cra_driver_name	=	"ecb-des3_ede128-s390",
-	.cra_priority		=	CRYPT_S390_COMPOSITE_PRIORITY,
-	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		=	DES3_128_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct crypt_s390_des3_128_ctx),
-	.cra_type		=	&crypto_blkcipher_type,
-	.cra_module		=	THIS_MODULE,
-	.cra_list		=	LIST_HEAD_INIT(
-						ecb_des3_128_alg.cra_list),
-	.cra_u			=	{
-		.blkcipher = {
-			.min_keysize		=	DES3_128_KEY_SIZE,
-			.max_keysize		=	DES3_128_KEY_SIZE,
-			.setkey			=	des3_128_setkey,
-			.encrypt		=	ecb_des3_128_encrypt,
-			.decrypt		=	ecb_des3_128_decrypt,
-		}
-	}
-};
-
-static int cbc_des3_128_encrypt(struct blkcipher_desc *desc,
-				struct scatterlist *dst,
-				struct scatterlist *src, unsigned int nbytes)
-{
-	struct crypt_s390_des3_128_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk walk;
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return cbc_desall_crypt(desc, KMC_TDEA_128_ENCRYPT, sctx->iv, &walk);
-}
-
-static int cbc_des3_128_decrypt(struct blkcipher_desc *desc,
-				struct scatterlist *dst,
-				struct scatterlist *src, unsigned int nbytes)
-{
-	struct crypt_s390_des3_128_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
-	struct blkcipher_walk walk;
-
-	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return cbc_desall_crypt(desc, KMC_TDEA_128_DECRYPT, sctx->iv, &walk);
-}
-
-static struct crypto_alg cbc_des3_128_alg = {
-	.cra_name		=	"cbc(des3_ede128)",
-	.cra_driver_name	=	"cbc-des3_ede128-s390",
-	.cra_priority		=	CRYPT_S390_COMPOSITE_PRIORITY,
-	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		=	DES3_128_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct crypt_s390_des3_128_ctx),
-	.cra_type		=	&crypto_blkcipher_type,
-	.cra_module		=	THIS_MODULE,
-	.cra_list		=	LIST_HEAD_INIT(
-						cbc_des3_128_alg.cra_list),
-	.cra_u			=	{
-		.blkcipher = {
-			.min_keysize		=	DES3_128_KEY_SIZE,
-			.max_keysize		=	DES3_128_KEY_SIZE,
-			.ivsize			=	DES3_128_BLOCK_SIZE,
-			.setkey			=	des3_128_setkey,
-			.encrypt		=	cbc_des3_128_encrypt,
-			.decrypt		=	cbc_des3_128_decrypt,
-		}
-	}
-};
-
-/*
- * RFC2451:
- *
- *   For DES-EDE3, there is no known need to reject weak or
- *   complementation keys.  Any weakness is obviated by the use of
- *   multiple keys.
- *
  *   However, if the first two or last two independent 64-bit keys are
  *   equal (k1 == k2 or k2 == k3), then the DES3 operation is simply the
  *   same as DES.  Implementers MUST reject keys that exhibit this
@@ -553,10 +386,9 @@ static struct crypto_alg cbc_des3_192_al
 
 static int des_s390_init(void)
 {
-	int ret = 0;
+	int ret;
 
 	if (!crypt_s390_func_available(KM_DEA_ENCRYPT) ||
-	    !crypt_s390_func_available(KM_TDEA_128_ENCRYPT) ||
 	    !crypt_s390_func_available(KM_TDEA_192_ENCRYPT))
 		return -EOPNOTSUPP;
 
@@ -569,17 +401,6 @@ static int des_s390_init(void)
 	ret = crypto_register_alg(&cbc_des_alg);
 	if (ret)
 		goto cbc_des_err;
-
-	ret = crypto_register_alg(&des3_128_alg);
-	if (ret)
-		goto des3_128_err;
-	ret = crypto_register_alg(&ecb_des3_128_alg);
-	if (ret)
-		goto ecb_des3_128_err;
-	ret = crypto_register_alg(&cbc_des3_128_alg);
-	if (ret)
-		goto cbc_des3_128_err;
-
 	ret = crypto_register_alg(&des3_192_alg);
 	if (ret)
 		goto des3_192_err;
@@ -589,7 +410,6 @@ static int des_s390_init(void)
 	ret = crypto_register_alg(&cbc_des3_192_alg);
 	if (ret)
 		goto cbc_des3_192_err;
-
 out:
 	return ret;
 
@@ -598,12 +418,6 @@ cbc_des3_192_err:
 ecb_des3_192_err:
 	crypto_unregister_alg(&des3_192_alg);
 des3_192_err:
-	crypto_unregister_alg(&cbc_des3_128_alg);
-cbc_des3_128_err:
-	crypto_unregister_alg(&ecb_des3_128_alg);
-ecb_des3_128_err:
-	crypto_unregister_alg(&des3_128_alg);
-des3_128_err:
 	crypto_unregister_alg(&cbc_des_alg);
 cbc_des_err:
 	crypto_unregister_alg(&ecb_des_alg);
@@ -618,9 +432,6 @@ static void __exit des_s390_fini(void)
 	crypto_unregister_alg(&cbc_des3_192_alg);
 	crypto_unregister_alg(&ecb_des3_192_alg);
 	crypto_unregister_alg(&des3_192_alg);
-	crypto_unregister_alg(&cbc_des3_128_alg);
-	crypto_unregister_alg(&ecb_des3_128_alg);
-	crypto_unregister_alg(&des3_128_alg);
 	crypto_unregister_alg(&cbc_des_alg);
 	crypto_unregister_alg(&ecb_des_alg);
 	crypto_unregister_alg(&des_alg);
