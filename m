From: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: [PATCH 2/2] des_s390: use generic weak key check
Date: Thu, 20 May 2010 13:19:18 +0200
Message-ID: <1274354358.15679.13.camel@hal>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.17.165]:57216 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab0ETLTX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 May 2010 07:19:23 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate5.de.ibm.com (8.13.1/8.13.1) with ESMTP id o4KBJMrR017620
	for <linux-crypto@vger.kernel.org>; Thu, 20 May 2010 11:19:22 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o4KBJMI2897110
	for <linux-crypto@vger.kernel.org>; Thu, 20 May 2010 13:19:22 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o4KBJLjf024056
	for <linux-crypto@vger.kernel.org>; Thu, 20 May 2010 13:19:21 +0200
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Get rid of the des_s390 specific key check module and use the generic DES
weak key check instead. Also use the generic DES header and remove the
weak key check in 3DES mode, as RFC2451 mentions that the DES weak keys
are not relevant for 3DES.

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
---
 arch/s390/crypto/Makefile        |    2 
 arch/s390/crypto/crypto_des.h    |   18 -----
 arch/s390/crypto/des_check_key.c |  132 ---------------------------------------
 arch/s390/crypto/des_s390.c      |   47 +++++--------
 4 files changed, 21 insertions(+), 178 deletions(-)

--- a/arch/s390/crypto/Makefile
+++ b/arch/s390/crypto/Makefile
@@ -5,6 +5,6 @@
 obj-$(CONFIG_CRYPTO_SHA1_S390) += sha1_s390.o sha_common.o
 obj-$(CONFIG_CRYPTO_SHA256_S390) += sha256_s390.o sha_common.o
 obj-$(CONFIG_CRYPTO_SHA512_S390) += sha512_s390.o sha_common.o
-obj-$(CONFIG_CRYPTO_DES_S390) += des_s390.o des_check_key.o
+obj-$(CONFIG_CRYPTO_DES_S390) += des_s390.o
 obj-$(CONFIG_CRYPTO_AES_S390) += aes_s390.o
 obj-$(CONFIG_S390_PRNG) += prng.o
--- a/arch/s390/crypto/crypto_des.h
+++ /dev/null
@@ -1,18 +0,0 @@
-/*
- * Cryptographic API.
- *
- * Function for checking keys for the DES and Tripple DES Encryption
- * algorithms.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- */
-#ifndef __CRYPTO_DES_H__
-#define __CRYPTO_DES_H__
-
-extern int crypto_des_check_key(const u8*, unsigned int, u32*);
-
-#endif //__CRYPTO_DES_H__
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
@@ -14,18 +14,15 @@
  *
  */
 
-#include <crypto/algapi.h>
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/crypto.h>
+#include <crypto/algapi.h>
+#include <crypto/des.h>
 
 #include "crypt_s390.h"
-#include "crypto_des.h"
-
-#define DES_BLOCK_SIZE 8
-#define DES_KEY_SIZE 8
 
 #define DES3_192_KEY_SIZE	(3 * DES_KEY_SIZE)
-#define DES3_192_BLOCK_SIZE	DES_BLOCK_SIZE
 
 struct crypt_s390_des_ctx {
 	u8 iv[DES_BLOCK_SIZE];
@@ -42,13 +39,16 @@ static int des_setkey(struct crypto_tfm 
 {
 	struct crypt_s390_des_ctx *dctx = crypto_tfm_ctx(tfm);
 	u32 *flags = &tfm->crt_flags;
-	int ret;
+	u32 tmp[DES_EXPKEY_WORDS];
 
-	/* test if key is valid (not a weak key) */
-	ret = crypto_des_check_key(key, keylen, flags);
-	if (ret == 0)
-		memcpy(dctx->key, key, keylen);
-	return ret;
+	/* check for weak keys */
+	if (!des_ekey(tmp, key) && (*flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
+		return -EINVAL;
+	}
+
+	memcpy(dctx->key, key, keylen);
+	return 0;
 }
 
 static void des_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
@@ -238,9 +238,7 @@ static struct crypto_alg cbc_des_alg = {
 static int des3_192_setkey(struct crypto_tfm *tfm, const u8 *key,
 			   unsigned int keylen)
 {
-	int i, ret;
 	struct crypt_s390_des3_192_ctx *dctx = crypto_tfm_ctx(tfm);
-	const u8 *temp_key = key;
 	u32 *flags = &tfm->crt_flags;
 
 	if (!(memcmp(key, &key[DES_KEY_SIZE], DES_KEY_SIZE) &&
@@ -250,11 +248,6 @@ static int des3_192_setkey(struct crypto
 		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
 		return -EINVAL;
 	}
-	for (i = 0; i < 3; i++, temp_key += DES_KEY_SIZE) {
-		ret = crypto_des_check_key(temp_key, DES_KEY_SIZE, flags);
-		if (ret < 0)
-			return ret;
-	}
 	memcpy(dctx->key, key, keylen);
 	return 0;
 }
@@ -264,7 +257,7 @@ static void des3_192_encrypt(struct cryp
 	struct crypt_s390_des3_192_ctx *dctx = crypto_tfm_ctx(tfm);
 
 	crypt_s390_km(KM_TDEA_192_ENCRYPT, dctx->key, dst, (void*)src,
-		      DES3_192_BLOCK_SIZE);
+		      DES_BLOCK_SIZE);
 }
 
 static void des3_192_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
@@ -272,7 +265,7 @@ static void des3_192_decrypt(struct cryp
 	struct crypt_s390_des3_192_ctx *dctx = crypto_tfm_ctx(tfm);
 
 	crypt_s390_km(KM_TDEA_192_DECRYPT, dctx->key, dst, (void*)src,
-		      DES3_192_BLOCK_SIZE);
+		      DES_BLOCK_SIZE);
 }
 
 static struct crypto_alg des3_192_alg = {
@@ -280,7 +273,7 @@ static struct crypto_alg des3_192_alg = 
 	.cra_driver_name	=	"des3_ede-s390",
 	.cra_priority		=	CRYPT_S390_PRIORITY,
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
-	.cra_blocksize		=	DES3_192_BLOCK_SIZE,
+	.cra_blocksize		=	DES_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct crypt_s390_des3_192_ctx),
 	.cra_module		=	THIS_MODULE,
 	.cra_list		=	LIST_HEAD_INIT(des3_192_alg.cra_list),
@@ -322,7 +315,7 @@ static struct crypto_alg ecb_des3_192_al
 	.cra_driver_name	=	"ecb-des3_ede-s390",
 	.cra_priority		=	CRYPT_S390_COMPOSITE_PRIORITY,
 	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		=	DES3_192_BLOCK_SIZE,
+	.cra_blocksize		=	DES_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct crypt_s390_des3_192_ctx),
 	.cra_type		=	&crypto_blkcipher_type,
 	.cra_module		=	THIS_MODULE,
@@ -366,7 +359,7 @@ static struct crypto_alg cbc_des3_192_al
 	.cra_driver_name	=	"cbc-des3_ede-s390",
 	.cra_priority		=	CRYPT_S390_COMPOSITE_PRIORITY,
 	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize		=	DES3_192_BLOCK_SIZE,
+	.cra_blocksize		=	DES_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct crypt_s390_des3_192_ctx),
 	.cra_type		=	&crypto_blkcipher_type,
 	.cra_module		=	THIS_MODULE,
@@ -376,7 +369,7 @@ static struct crypto_alg cbc_des3_192_al
 		.blkcipher = {
 			.min_keysize		=	DES3_192_KEY_SIZE,
 			.max_keysize		=	DES3_192_KEY_SIZE,
-			.ivsize			=	DES3_192_BLOCK_SIZE,
+			.ivsize			=	DES_BLOCK_SIZE,
 			.setkey			=	des3_192_setkey,
 			.encrypt		=	cbc_des3_192_encrypt,
 			.decrypt		=	cbc_des3_192_decrypt,
@@ -427,7 +420,7 @@ des_err:
 	goto out;
 }
 
-static void __exit des_s390_fini(void)
+static void __exit des_s390_exit(void)
 {
 	crypto_unregister_alg(&cbc_des3_192_alg);
 	crypto_unregister_alg(&ecb_des3_192_alg);
@@ -438,7 +431,7 @@ static void __exit des_s390_fini(void)
 }
 
 module_init(des_s390_init);
-module_exit(des_s390_fini);
+module_exit(des_s390_exit);
 
 MODULE_ALIAS("des");
 MODULE_ALIAS("des3_ede");
