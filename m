From: jang@linux.vnet.ibm.com
Subject: [PATCH 2/8] s390: cleanup DES code
Date: Tue, 19 Apr 2011 21:29:15 +0200
Message-ID: <20110419193247.269992035@linux.vnet.ibm.com>
References: <20110419192913.888086020@linux.vnet.ibm.com>
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:37839 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab1DSTd7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Apr 2011 15:33:59 -0400
Received: from d06nrmr1707.portsmouth.uk.ibm.com (d06nrmr1707.portsmouth.uk.ibm.com [9.149.39.225])
	by mtagate1.uk.ibm.com (8.13.1/8.13.1) with ESMTP id p3JJXw5K018863
	for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2011 19:33:58 GMT
Received: from d06av05.portsmouth.uk.ibm.com (d06av05.portsmouth.uk.ibm.com [9.149.37.229])
	by d06nrmr1707.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p3JJYrO31593396
	for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2011 20:34:53 +0100
Received: from d06av05.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av05.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p3JJXvuG028551
	for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2011 13:33:57 -0600
Content-Disposition: inline; filename=crypto-des_cleanup.patch
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Jan Glauber <jang@linux.vnet.ibm.com>

Remove a stale file left over from 1efbd15c3bc2b79d33e033e898211109c32159fa
and and cleanup the DES code a bit to make it easier to add new code.

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
---
 arch/s390/crypto/des_check_key.c |  132 -------------------------
 arch/s390/crypto/des_s390.c      |  199 ++++++++++++++++++---------------------
 2 files changed, 96 insertions(+), 235 deletions(-)

--- a/arch/s390/crypto/des_check_key.c
+++ /dev/null
@@ -1,132 +0,0 @@
-/*
- * Cryptographic API.
- *
- * Function for checking keys for the DES and Tripple DES Encryption
- * algorithms.
- *
- * Originally released as descore by Dana L. How <how@isl.stanford.edu>.
- * Modified by Raimar Falke <rf13@inf.tu-dresden.de> for the Linux-Kernel.
- * Derived from Cryptoapi and Nettle implementations, adapted for in-place
- * scatterlist interface.  Changed LGPL to GPL per section 3 of the LGPL.
- *
- * s390 Version:
- *   Copyright IBM Corp. 2003
- *   Author(s): Thomas Spatzier
- *		Jan Glauber (jan.glauber@de.ibm.com)
- *
- * Derived from "crypto/des.c"
- *   Copyright (c) 1992 Dana L. How.
- *   Copyright (c) Raimar Falke <rf13@inf.tu-dresden.de>
- *   Copyright (c) Gisle Sflensminde <gisle@ii.uib.no>
- *   Copyright (C) 2001 Niels Mvller.
- *   Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- */
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/errno.h>
-#include <linux/crypto.h>
-#include "crypto_des.h"
-
-#define ROR(d,c,o)	((d) = (d) >> (c) | (d) << (o))
-
-static const u8 parity[] = {
-	8,1,0,8,0,8,8,0,0,8,8,0,8,0,2,8,0,8,8,0,8,0,0,8,8,0,0,8,0,8,8,3,
-	0,8,8,0,8,0,0,8,8,0,0,8,0,8,8,0,8,0,0,8,0,8,8,0,0,8,8,0,8,0,0,8,
-	0,8,8,0,8,0,0,8,8,0,0,8,0,8,8,0,8,0,0,8,0,8,8,0,0,8,8,0,8,0,0,8,
-	8,0,0,8,0,8,8,0,0,8,8,0,8,0,0,8,0,8,8,0,8,0,0,8,8,0,0,8,0,8,8,0,
-	0,8,8,0,8,0,0,8,8,0,0,8,0,8,8,0,8,0,0,8,0,8,8,0,0,8,8,0,8,0,0,8,
-	8,0,0,8,0,8,8,0,0,8,8,0,8,0,0,8,0,8,8,0,8,0,0,8,8,0,0,8,0,8,8,0,
-	8,0,0,8,0,8,8,0,0,8,8,0,8,0,0,8,0,8,8,0,8,0,0,8,8,0,0,8,0,8,8,0,
-	4,8,8,0,8,0,0,8,8,0,0,8,0,8,8,0,8,5,0,8,0,8,8,0,0,8,8,0,8,0,6,8,
-};
-
-/*
- * RFC2451: Weak key checks SHOULD be performed.
- */
-int
-crypto_des_check_key(const u8 *key, unsigned int keylen, u32 *flags)
-{
-	u32 n, w;
-
-	n  = parity[key[0]]; n <<= 4;
-	n |= parity[key[1]]; n <<= 4;
-	n |= parity[key[2]]; n <<= 4;
-	n |= parity[key[3]]; n <<= 4;
-	n |= parity[key[4]]; n <<= 4;
-	n |= parity[key[5]]; n <<= 4;
-	n |= parity[key[6]]; n <<= 4;
-	n |= parity[key[7]];
-	w = 0x88888888L;
-
-	if ((*flags & CRYPTO_TFM_REQ_WEAK_KEY)
-	    && !((n - (w >> 3)) & w)) {  /* 1 in 10^10 keys passes this test */
-		if (n < 0x41415151) {
-			if (n < 0x31312121) {
-				if (n < 0x14141515) {
-					/* 01 01 01 01 01 01 01 01 */
-					if (n == 0x11111111) goto weak;
-					/* 01 1F 01 1F 01 0E 01 0E */
-					if (n == 0x13131212) goto weak;
-				} else {
-					/* 01 E0 01 E0 01 F1 01 F1 */
-					if (n == 0x14141515) goto weak;
-					/* 01 FE 01 FE 01 FE 01 FE */
-					if (n == 0x16161616) goto weak;
-				}
-			} else {
-				if (n < 0x34342525) {
-					/* 1F 01 1F 01 0E 01 0E 01 */
-					if (n == 0x31312121) goto weak;
-					/* 1F 1F 1F 1F 0E 0E 0E 0E (?) */
-					if (n == 0x33332222) goto weak;
-				} else {
-					/* 1F E0 1F E0 0E F1 0E F1 */
-					if (n == 0x34342525) goto weak;
-					/* 1F FE 1F FE 0E FE 0E FE */
-					if (n == 0x36362626) goto weak;
-				}
-			}
-		} else {
-			if (n < 0x61616161) {
-				if (n < 0x44445555) {
-					/* E0 01 E0 01 F1 01 F1 01 */
-					if (n == 0x41415151) goto weak;
-					/* E0 1F E0 1F F1 0E F1 0E */
-					if (n == 0x43435252) goto weak;
-				} else {
-					/* E0 E0 E0 E0 F1 F1 F1 F1 (?) */
-					if (n == 0x44445555) goto weak;
-					/* E0 FE E0 FE F1 FE F1 FE */
-					if (n == 0x46465656) goto weak;
-				}
-			} else {
-				if (n < 0x64646565) {
-					/* FE 01 FE 01 FE 01 FE 01 */
-					if (n == 0x61616161) goto weak;
-					/* FE 1F FE 1F FE 0E FE 0E */
-					if (n == 0x63636262) goto weak;
-				} else {
-					/* FE E0 FE E0 FE F1 FE F1 */
-					if (n == 0x64646565) goto weak;
-					/* FE FE FE FE FE FE FE FE */
-					if (n == 0x66666666) goto weak;
-				}
-			}
-		}
-	}
-	return 0;
-weak:
-	*flags |= CRYPTO_TFM_RES_WEAK_KEY;
-	return -EINVAL;
-}
-
-EXPORT_SYMBOL(crypto_des_check_key);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Key Check function for DES &  DES3 Cipher Algorithms");
--- a/arch/s390/crypto/des_s390.c
+++ b/arch/s390/crypto/des_s390.c
@@ -22,22 +22,17 @@
 
 #include "crypt_s390.h"
 
-#define DES3_192_KEY_SIZE	(3 * DES_KEY_SIZE)
+#define DES3_KEY_SIZE	(3 * DES_KEY_SIZE)
 
-struct crypt_s390_des_ctx {
+struct s390_des_ctx {
 	u8 iv[DES_BLOCK_SIZE];
-	u8 key[DES_KEY_SIZE];
-};
-
-struct crypt_s390_des3_192_ctx {
-	u8 iv[DES_BLOCK_SIZE];
-	u8 key[DES3_192_KEY_SIZE];
+	u8 key[DES3_KEY_SIZE];
 };
 
 static int des_setkey(struct crypto_tfm *tfm, const u8 *key,
-		      unsigned int keylen)
+		      unsigned int key_len)
 {
-	struct crypt_s390_des_ctx *dctx = crypto_tfm_ctx(tfm);
+	struct s390_des_ctx *ctx = crypto_tfm_ctx(tfm);
 	u32 *flags = &tfm->crt_flags;
 	u32 tmp[DES_EXPKEY_WORDS];
 
@@ -47,22 +42,22 @@ static int des_setkey(struct crypto_tfm
 		return -EINVAL;
 	}
 
-	memcpy(dctx->key, key, keylen);
+	memcpy(ctx->key, key, key_len);
 	return 0;
 }
 
 static void des_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
-	struct crypt_s390_des_ctx *dctx = crypto_tfm_ctx(tfm);
+	struct s390_des_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	crypt_s390_km(KM_DEA_ENCRYPT, dctx->key, out, in, DES_BLOCK_SIZE);
+	crypt_s390_km(KM_DEA_ENCRYPT, ctx->key, out, in, DES_BLOCK_SIZE);
 }
 
 static void des_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
-	struct crypt_s390_des_ctx *dctx = crypto_tfm_ctx(tfm);
+	struct s390_des_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	crypt_s390_km(KM_DEA_DECRYPT, dctx->key, out, in, DES_BLOCK_SIZE);
+	crypt_s390_km(KM_DEA_DECRYPT, ctx->key, out, in, DES_BLOCK_SIZE);
 }
 
 static struct crypto_alg des_alg = {
@@ -71,7 +66,7 @@ static struct crypto_alg des_alg = {
 	.cra_priority		=	CRYPT_S390_PRIORITY,
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	DES_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct crypt_s390_des_ctx),
+	.cra_ctxsize		=	sizeof(struct s390_des_ctx),
 	.cra_module		=	THIS_MODULE,
 	.cra_list		=	LIST_HEAD_INIT(des_alg.cra_list),
 	.cra_u			=	{
@@ -86,7 +81,7 @@ static struct crypto_alg des_alg = {
 };
 
 static int ecb_desall_crypt(struct blkcipher_desc *desc, long func,
-			    void *param, struct blkcipher_walk *walk)
+			    u8 *key, struct blkcipher_walk *walk)
 {
 	int ret = blkcipher_walk_virt(desc, walk);
 	unsigned int nbytes;
@@ -97,7 +92,7 @@ static int ecb_desall_crypt(struct blkci
 		u8 *out = walk->dst.virt.addr;
 		u8 *in = walk->src.virt.addr;
 
-		ret = crypt_s390_km(func, param, out, in, n);
+		ret = crypt_s390_km(func, key, out, in, n);
 		BUG_ON((ret < 0) || (ret != n));
 
 		nbytes &= DES_BLOCK_SIZE - 1;
@@ -108,7 +103,7 @@ static int ecb_desall_crypt(struct blkci
 }
 
 static int cbc_desall_crypt(struct blkcipher_desc *desc, long func,
-			    void *param, struct blkcipher_walk *walk)
+			    u8 *iv, struct blkcipher_walk *walk)
 {
 	int ret = blkcipher_walk_virt(desc, walk);
 	unsigned int nbytes = walk->nbytes;
@@ -116,20 +111,20 @@ static int cbc_desall_crypt(struct blkci
 	if (!nbytes)
 		goto out;
 
-	memcpy(param, walk->iv, DES_BLOCK_SIZE);
+	memcpy(iv, walk->iv, DES_BLOCK_SIZE);
 	do {
 		/* only use complete blocks */
 		unsigned int n = nbytes & ~(DES_BLOCK_SIZE - 1);
 		u8 *out = walk->dst.virt.addr;
 		u8 *in = walk->src.virt.addr;
 
-		ret = crypt_s390_kmc(func, param, out, in, n);
+		ret = crypt_s390_kmc(func, iv, out, in, n);
 		BUG_ON((ret < 0) || (ret != n));
 
 		nbytes &= DES_BLOCK_SIZE - 1;
 		ret = blkcipher_walk_done(desc, walk, nbytes);
 	} while ((nbytes = walk->nbytes));
-	memcpy(walk->iv, param, DES_BLOCK_SIZE);
+	memcpy(walk->iv, iv, DES_BLOCK_SIZE);
 
 out:
 	return ret;
@@ -139,22 +134,22 @@ static int ecb_des_encrypt(struct blkcip
 			   struct scatterlist *dst, struct scatterlist *src,
 			   unsigned int nbytes)
 {
-	struct crypt_s390_des_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
+	struct s390_des_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return ecb_desall_crypt(desc, KM_DEA_ENCRYPT, sctx->key, &walk);
+	return ecb_desall_crypt(desc, KM_DEA_ENCRYPT, ctx->key, &walk);
 }
 
 static int ecb_des_decrypt(struct blkcipher_desc *desc,
 			   struct scatterlist *dst, struct scatterlist *src,
 			   unsigned int nbytes)
 {
-	struct crypt_s390_des_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
+	struct s390_des_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return ecb_desall_crypt(desc, KM_DEA_DECRYPT, sctx->key, &walk);
+	return ecb_desall_crypt(desc, KM_DEA_DECRYPT, ctx->key, &walk);
 }
 
 static struct crypto_alg ecb_des_alg = {
@@ -163,7 +158,7 @@ static struct crypto_alg ecb_des_alg = {
 	.cra_priority		=	CRYPT_S390_COMPOSITE_PRIORITY,
 	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
 	.cra_blocksize		=	DES_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct crypt_s390_des_ctx),
+	.cra_ctxsize		=	sizeof(struct s390_des_ctx),
 	.cra_type		=	&crypto_blkcipher_type,
 	.cra_module		=	THIS_MODULE,
 	.cra_list		=	LIST_HEAD_INIT(ecb_des_alg.cra_list),
@@ -182,22 +177,22 @@ static int cbc_des_encrypt(struct blkcip
 			   struct scatterlist *dst, struct scatterlist *src,
 			   unsigned int nbytes)
 {
-	struct crypt_s390_des_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
+	struct s390_des_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return cbc_desall_crypt(desc, KMC_DEA_ENCRYPT, sctx->iv, &walk);
+	return cbc_desall_crypt(desc, KMC_DEA_ENCRYPT, ctx->iv, &walk);
 }
 
 static int cbc_des_decrypt(struct blkcipher_desc *desc,
 			   struct scatterlist *dst, struct scatterlist *src,
 			   unsigned int nbytes)
 {
-	struct crypt_s390_des_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
+	struct s390_des_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return cbc_desall_crypt(desc, KMC_DEA_DECRYPT, sctx->iv, &walk);
+	return cbc_desall_crypt(desc, KMC_DEA_DECRYPT, ctx->iv, &walk);
 }
 
 static struct crypto_alg cbc_des_alg = {
@@ -206,7 +201,7 @@ static struct crypto_alg cbc_des_alg = {
 	.cra_priority		=	CRYPT_S390_COMPOSITE_PRIORITY,
 	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
 	.cra_blocksize		=	DES_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct crypt_s390_des_ctx),
+	.cra_ctxsize		=	sizeof(struct s390_des_ctx),
 	.cra_type		=	&crypto_blkcipher_type,
 	.cra_module		=	THIS_MODULE,
 	.cra_list		=	LIST_HEAD_INIT(cbc_des_alg.cra_list),
@@ -235,10 +230,10 @@ static struct crypto_alg cbc_des_alg = {
  *   property.
  *
  */
-static int des3_192_setkey(struct crypto_tfm *tfm, const u8 *key,
-			   unsigned int keylen)
+static int des3_setkey(struct crypto_tfm *tfm, const u8 *key,
+		       unsigned int key_len)
 {
-	struct crypt_s390_des3_192_ctx *dctx = crypto_tfm_ctx(tfm);
+	struct s390_des_ctx *ctx = crypto_tfm_ctx(tfm);
 	u32 *flags = &tfm->crt_flags;
 
 	if (!(memcmp(key, &key[DES_KEY_SIZE], DES_KEY_SIZE) &&
@@ -248,136 +243,134 @@ static int des3_192_setkey(struct crypto
 		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
 		return -EINVAL;
 	}
-	memcpy(dctx->key, key, keylen);
+	memcpy(ctx->key, key, key_len);
 	return 0;
 }
 
-static void des3_192_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static void des3_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
-	struct crypt_s390_des3_192_ctx *dctx = crypto_tfm_ctx(tfm);
+	struct s390_des_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	crypt_s390_km(KM_TDEA_192_ENCRYPT, dctx->key, dst, (void*)src,
-		      DES_BLOCK_SIZE);
+	crypt_s390_km(KM_TDEA_192_ENCRYPT, ctx->key, dst, src, DES_BLOCK_SIZE);
 }
 
-static void des3_192_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static void des3_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
-	struct crypt_s390_des3_192_ctx *dctx = crypto_tfm_ctx(tfm);
+	struct s390_des_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	crypt_s390_km(KM_TDEA_192_DECRYPT, dctx->key, dst, (void*)src,
-		      DES_BLOCK_SIZE);
+	crypt_s390_km(KM_TDEA_192_DECRYPT, ctx->key, dst, src, DES_BLOCK_SIZE);
 }
 
-static struct crypto_alg des3_192_alg = {
+static struct crypto_alg des3_alg = {
 	.cra_name		=	"des3_ede",
 	.cra_driver_name	=	"des3_ede-s390",
 	.cra_priority		=	CRYPT_S390_PRIORITY,
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	DES_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct crypt_s390_des3_192_ctx),
+	.cra_ctxsize		=	sizeof(struct s390_des_ctx),
 	.cra_module		=	THIS_MODULE,
-	.cra_list		=	LIST_HEAD_INIT(des3_192_alg.cra_list),
+	.cra_list		=	LIST_HEAD_INIT(des3_alg.cra_list),
 	.cra_u			=	{
 		.cipher = {
-			.cia_min_keysize	=	DES3_192_KEY_SIZE,
-			.cia_max_keysize	=	DES3_192_KEY_SIZE,
-			.cia_setkey		=	des3_192_setkey,
-			.cia_encrypt		=	des3_192_encrypt,
-			.cia_decrypt		=	des3_192_decrypt,
+			.cia_min_keysize	=	DES3_KEY_SIZE,
+			.cia_max_keysize	=	DES3_KEY_SIZE,
+			.cia_setkey		=	des3_setkey,
+			.cia_encrypt		=	des3_encrypt,
+			.cia_decrypt		=	des3_decrypt,
 		}
 	}
 };
 
-static int ecb_des3_192_encrypt(struct blkcipher_desc *desc,
-				struct scatterlist *dst,
-				struct scatterlist *src, unsigned int nbytes)
+static int ecb_des3_encrypt(struct blkcipher_desc *desc,
+			    struct scatterlist *dst, struct scatterlist *src,
+			    unsigned int nbytes)
 {
-	struct crypt_s390_des3_192_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
+	struct s390_des_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return ecb_desall_crypt(desc, KM_TDEA_192_ENCRYPT, sctx->key, &walk);
+	return ecb_desall_crypt(desc, KM_TDEA_192_ENCRYPT, ctx->key, &walk);
 }
 
-static int ecb_des3_192_decrypt(struct blkcipher_desc *desc,
-				struct scatterlist *dst,
-				struct scatterlist *src, unsigned int nbytes)
+static int ecb_des3_decrypt(struct blkcipher_desc *desc,
+			    struct scatterlist *dst, struct scatterlist *src,
+			    unsigned int nbytes)
 {
-	struct crypt_s390_des3_192_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
+	struct s390_des_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return ecb_desall_crypt(desc, KM_TDEA_192_DECRYPT, sctx->key, &walk);
+	return ecb_desall_crypt(desc, KM_TDEA_192_DECRYPT, ctx->key, &walk);
 }
 
-static struct crypto_alg ecb_des3_192_alg = {
+static struct crypto_alg ecb_des3_alg = {
 	.cra_name		=	"ecb(des3_ede)",
 	.cra_driver_name	=	"ecb-des3_ede-s390",
 	.cra_priority		=	CRYPT_S390_COMPOSITE_PRIORITY,
 	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
 	.cra_blocksize		=	DES_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct crypt_s390_des3_192_ctx),
+	.cra_ctxsize		=	sizeof(struct s390_des_ctx),
 	.cra_type		=	&crypto_blkcipher_type,
 	.cra_module		=	THIS_MODULE,
 	.cra_list		=	LIST_HEAD_INIT(
-						ecb_des3_192_alg.cra_list),
+						ecb_des3_alg.cra_list),
 	.cra_u			=	{
 		.blkcipher = {
-			.min_keysize		=	DES3_192_KEY_SIZE,
-			.max_keysize		=	DES3_192_KEY_SIZE,
-			.setkey			=	des3_192_setkey,
-			.encrypt		=	ecb_des3_192_encrypt,
-			.decrypt		=	ecb_des3_192_decrypt,
+			.min_keysize		=	DES3_KEY_SIZE,
+			.max_keysize		=	DES3_KEY_SIZE,
+			.setkey			=	des3_setkey,
+			.encrypt		=	ecb_des3_encrypt,
+			.decrypt		=	ecb_des3_decrypt,
 		}
 	}
 };
 
-static int cbc_des3_192_encrypt(struct blkcipher_desc *desc,
-				struct scatterlist *dst,
-				struct scatterlist *src, unsigned int nbytes)
+static int cbc_des3_encrypt(struct blkcipher_desc *desc,
+			    struct scatterlist *dst, struct scatterlist *src,
+			    unsigned int nbytes)
 {
-	struct crypt_s390_des3_192_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
+	struct s390_des_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return cbc_desall_crypt(desc, KMC_TDEA_192_ENCRYPT, sctx->iv, &walk);
+	return cbc_desall_crypt(desc, KMC_TDEA_192_ENCRYPT, ctx->iv, &walk);
 }
 
-static int cbc_des3_192_decrypt(struct blkcipher_desc *desc,
-				struct scatterlist *dst,
-				struct scatterlist *src, unsigned int nbytes)
+static int cbc_des3_decrypt(struct blkcipher_desc *desc,
+			    struct scatterlist *dst, struct scatterlist *src,
+			    unsigned int nbytes)
 {
-	struct crypt_s390_des3_192_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
+	struct s390_des_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return cbc_desall_crypt(desc, KMC_TDEA_192_DECRYPT, sctx->iv, &walk);
+	return cbc_desall_crypt(desc, KMC_TDEA_192_DECRYPT, ctx->iv, &walk);
 }
 
-static struct crypto_alg cbc_des3_192_alg = {
+static struct crypto_alg cbc_des3_alg = {
 	.cra_name		=	"cbc(des3_ede)",
 	.cra_driver_name	=	"cbc-des3_ede-s390",
 	.cra_priority		=	CRYPT_S390_COMPOSITE_PRIORITY,
 	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
 	.cra_blocksize		=	DES_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct crypt_s390_des3_192_ctx),
+	.cra_ctxsize		=	sizeof(struct s390_des_ctx),
 	.cra_type		=	&crypto_blkcipher_type,
 	.cra_module		=	THIS_MODULE,
 	.cra_list		=	LIST_HEAD_INIT(
-						cbc_des3_192_alg.cra_list),
+						cbc_des3_alg.cra_list),
 	.cra_u			=	{
 		.blkcipher = {
-			.min_keysize		=	DES3_192_KEY_SIZE,
-			.max_keysize		=	DES3_192_KEY_SIZE,
+			.min_keysize		=	DES3_KEY_SIZE,
+			.max_keysize		=	DES3_KEY_SIZE,
 			.ivsize			=	DES_BLOCK_SIZE,
-			.setkey			=	des3_192_setkey,
-			.encrypt		=	cbc_des3_192_encrypt,
-			.decrypt		=	cbc_des3_192_decrypt,
+			.setkey			=	des3_setkey,
+			.encrypt		=	cbc_des3_encrypt,
+			.decrypt		=	cbc_des3_decrypt,
 		}
 	}
 };
 
-static int des_s390_init(void)
+static int __init des_s390_init(void)
 {
 	int ret;
 
@@ -394,23 +387,23 @@ static int des_s390_init(void)
 	ret = crypto_register_alg(&cbc_des_alg);
 	if (ret)
 		goto cbc_des_err;
-	ret = crypto_register_alg(&des3_192_alg);
+	ret = crypto_register_alg(&des3_alg);
 	if (ret)
-		goto des3_192_err;
-	ret = crypto_register_alg(&ecb_des3_192_alg);
+		goto des3_err;
+	ret = crypto_register_alg(&ecb_des3_alg);
 	if (ret)
-		goto ecb_des3_192_err;
-	ret = crypto_register_alg(&cbc_des3_192_alg);
+		goto ecb_des3_err;
+	ret = crypto_register_alg(&cbc_des3_alg);
 	if (ret)
-		goto cbc_des3_192_err;
+		goto cbc_des3_err;
 out:
 	return ret;
 
-cbc_des3_192_err:
-	crypto_unregister_alg(&ecb_des3_192_alg);
-ecb_des3_192_err:
-	crypto_unregister_alg(&des3_192_alg);
-des3_192_err:
+cbc_des3_err:
+	crypto_unregister_alg(&ecb_des3_alg);
+ecb_des3_err:
+	crypto_unregister_alg(&des3_alg);
+des3_err:
 	crypto_unregister_alg(&cbc_des_alg);
 cbc_des_err:
 	crypto_unregister_alg(&ecb_des_alg);
@@ -422,9 +415,9 @@ des_err:
 
 static void __exit des_s390_exit(void)
 {
-	crypto_unregister_alg(&cbc_des3_192_alg);
-	crypto_unregister_alg(&ecb_des3_192_alg);
-	crypto_unregister_alg(&des3_192_alg);
+	crypto_unregister_alg(&cbc_des3_alg);
+	crypto_unregister_alg(&ecb_des3_alg);
+	crypto_unregister_alg(&des3_alg);
 	crypto_unregister_alg(&cbc_des_alg);
 	crypto_unregister_alg(&ecb_des_alg);
 	crypto_unregister_alg(&des_alg);

-- 
