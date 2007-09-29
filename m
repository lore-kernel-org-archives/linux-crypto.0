From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [CRYPTO] blkcipher: Add IV generation
Date: Sat, 29 Sep 2007 21:34:50 +0800
Message-ID: <20070929133450.GB3619@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2495 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754829AbXI2Nex (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 29 Sep 2007 09:34:53 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1IbcT4-0001iG-Ru
	for <linux-crypto@vger.kernel.org>; Sat, 29 Sep 2007 23:34:50 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1IbcT4-0000zJ-00
	for <linux-crypto@vger.kernel.org>; Sat, 29 Sep 2007 21:34:50 +0800
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi:

I've just checked in these patches needed for CTR to function
correctly.

[CRYPTO] blkcipher: Add IV generation

Different cipher block modes may have different requirements for IV
generation.  Therefore it makes sense to move IV generation into the
crypto API instead of having the crypto users worry about it.

In particular, this would allow us to support CTR mode for IPsec as
the IV that's currently used isn't secure for it.

For CBC, I've decided to always generate a random IV rather than using
the last block of the previous encryption.  The reason is that for async
CBC we'd have to do this anyway.  If we did both depending on whether
the algorithm is sync or async then we'd be exposing information to the
outside world.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/arch/s390/crypto/Kconfig b/arch/s390/crypto/Kconfig
index d1defbb..c697525 100644
--- a/arch/s390/crypto/Kconfig
+++ b/arch/s390/crypto/Kconfig
@@ -22,6 +22,7 @@ config CRYPTO_DES_S390
 	depends on S390
 	select CRYPTO_ALGAPI
 	select CRYPTO_BLKCIPHER
+	select CRYPTO_CBC
 	help
 	  This us the s390 hardware accelerated implementation of the
 	  DES cipher algorithm (FIPS 46-2), and Triple DES EDE (FIPS 46-3).
@@ -31,6 +32,7 @@ config CRYPTO_AES_S390
 	depends on S390
 	select CRYPTO_ALGAPI
 	select CRYPTO_BLKCIPHER
+	select CRYPTO_CBC
 	help
 	  This is the s390 hardware accelerated implementation of the
 	  AES cipher algorithms (FIPS-197). AES uses the Rijndael
diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 3660ca6..195c118 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -17,6 +17,7 @@
  */
 
 #include <crypto/algapi.h>
+#include <crypto/cbc.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include "crypt_s390.h"
@@ -317,6 +318,7 @@ static struct crypto_alg cbc_aes_alg = {
 			.setkey			=	cbc_aes_set_key,
 			.encrypt		=	cbc_aes_encrypt,
 			.decrypt		=	cbc_aes_decrypt,
+			.geniv			=	crypto_cbc_geniv,
 		}
 	}
 };
diff --git a/arch/s390/crypto/des_s390.c b/arch/s390/crypto/des_s390.c
index ea22707..8b8856c 100644
--- a/arch/s390/crypto/des_s390.c
+++ b/arch/s390/crypto/des_s390.c
@@ -15,6 +15,7 @@
  */
 
 #include <crypto/algapi.h>
+#include <crypto/cbc.h>
 #include <linux/init.h>
 #include <linux/module.h>
 
@@ -226,6 +227,7 @@ static struct crypto_alg cbc_des_alg = {
 			.setkey			=	des_setkey,
 			.encrypt		=	cbc_des_encrypt,
 			.decrypt		=	cbc_des_decrypt,
+			.geniv			=	crypto_cbc_geniv,
 		}
 	}
 };
@@ -384,6 +386,7 @@ static struct crypto_alg cbc_des3_128_alg = {
 			.setkey			=	des3_128_setkey,
 			.encrypt		=	cbc_des3_128_encrypt,
 			.decrypt		=	cbc_des3_128_decrypt,
+			.geniv			=	crypto_cbc_geniv,
 		}
 	}
 };
@@ -546,6 +549,7 @@ static struct crypto_alg cbc_des3_192_alg = {
 			.setkey			=	des3_192_setkey,
 			.encrypt		=	cbc_des3_192_encrypt,
 			.decrypt		=	cbc_des3_192_decrypt,
+			.geniv			=	crypto_cbc_geniv,
 		}
 	}
 };
diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index 2731acb..4be3343 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -60,6 +60,10 @@ static int setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 	return cipher->setkey(tfm, key, keylen);
 }
 
+static void nogeniv(struct crypto_ablkcipher *tfm, u8 *iv, u64 seq)
+{
+}
+
 static unsigned int crypto_ablkcipher_ctxsize(struct crypto_alg *alg, u32 type,
 					      u32 mask)
 {
@@ -78,8 +82,16 @@ static int crypto_init_ablkcipher_ops(struct crypto_tfm *tfm, u32 type,
 	crt->setkey = setkey;
 	crt->encrypt = alg->encrypt;
 	crt->decrypt = alg->decrypt;
+	crt->geniv = alg->geniv;
 	crt->ivsize = alg->ivsize;
 
+	if (!alg->geniv) {
+		if (alg->ivsize)
+			return -EINVAL;
+
+		crt->geniv = nogeniv;
+	}
+
 	return 0;
 }
 
diff --git a/crypto/aead.c b/crypto/aead.c
index 84a3501..1603791 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -67,9 +67,13 @@ static int crypto_init_aead_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 	if (max(alg->authsize, alg->ivsize) > PAGE_SIZE / 8)
 		return -EINVAL;
 
+	if (!alg->geniv)
+		return -EINVAL;
+
 	crt->setkey = setkey;
 	crt->encrypt = alg->encrypt;
 	crt->decrypt = alg->decrypt;
+	crt->geniv = alg->geniv;
 	crt->ivsize = alg->ivsize;
 	crt->authsize = alg->authsize;
 
diff --git a/crypto/authenc.c b/crypto/authenc.c
index 0b29a6a..f1802f1 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -221,6 +221,13 @@ static int crypto_authenc_decrypt(struct aead_request *req)
 	return crypto_ablkcipher_decrypt(abreq);
 }
 
+static void crypto_authenc_geniv(struct crypto_aead *tfm, u8 *iv, u64 seq)
+{
+	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(tfm);
+
+	crypto_ablkcipher_geniv(ctx->enc, iv, seq);
+}
+
 static int crypto_authenc_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_instance *inst = (void *)tfm->__crt_alg;
@@ -351,6 +358,7 @@ static struct crypto_instance *crypto_authenc_alloc(struct rtattr **tb)
 	inst->alg.cra_aead.setkey = crypto_authenc_setkey;
 	inst->alg.cra_aead.encrypt = crypto_authenc_encrypt;
 	inst->alg.cra_aead.decrypt = crypto_authenc_decrypt;
+	inst->alg.cra_aead.geniv = crypto_authenc_geniv;
 
 out:
 	crypto_mod_put(enc);
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 9c49770..1f8e9e5 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -410,6 +410,22 @@ static int async_decrypt(struct ablkcipher_request *req)
 	return alg->decrypt(&desc, req->dst, req->src, req->nbytes);
 }
 
+static void async_geniv(struct crypto_ablkcipher *ab, u8 *iv, u64 seq)
+{
+	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(ab);
+	struct blkcipher_alg *alg = &tfm->__crt_alg->cra_blkcipher;
+
+	return alg->geniv(__crypto_blkcipher_cast(tfm), iv, seq);
+}
+
+static void async_nogeniv(struct crypto_ablkcipher *tfm, u8 *iv, u64 seq)
+{
+}
+
+static void nogeniv(struct crypto_blkcipher *tfm, u8 *iv, u64 seq)
+{
+}
+
 static unsigned int crypto_blkcipher_ctxsize(struct crypto_alg *alg, u32 type,
 					     u32 mask)
 {
@@ -434,8 +450,16 @@ static int crypto_init_blkcipher_ops_async(struct crypto_tfm *tfm)
 	crt->setkey = async_setkey;
 	crt->encrypt = async_encrypt;
 	crt->decrypt = async_decrypt;
+	crt->geniv = async_geniv;
 	crt->ivsize = alg->ivsize;
 
+	if (!alg->geniv) {
+		if (alg->ivsize)
+			return -EINVAL;
+
+		crt->geniv = async_nogeniv;
+	}
+
 	return 0;
 }
 
@@ -449,6 +473,14 @@ static int crypto_init_blkcipher_ops_sync(struct crypto_tfm *tfm)
 	crt->setkey = setkey;
 	crt->encrypt = alg->encrypt;
 	crt->decrypt = alg->decrypt;
+	crt->geniv = alg->geniv;
+
+	if (!alg->geniv) {
+		if (alg->ivsize)
+			return -EINVAL;
+
+		crt->geniv = nogeniv;
+	}
 
 	addr = (unsigned long)crypto_tfm_ctx(tfm);
 	addr = ALIGN(addr, align);
diff --git a/crypto/cbc.c b/crypto/cbc.c
index 1f2649e..e8618e9 100644
--- a/crypto/cbc.c
+++ b/crypto/cbc.c
@@ -11,10 +11,12 @@
  */
 
 #include <crypto/algapi.h>
+#include <crypto/cbc.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/random.h>
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
 
@@ -207,6 +209,12 @@ static int crypto_cbc_decrypt(struct blkcipher_desc *desc,
 	return err;
 }
 
+void crypto_cbc_geniv(struct crypto_blkcipher *tfm, u8 *iv, u64 seq)
+{
+	get_random_bytes(iv, crypto_blkcipher_ivsize(tfm));
+}
+EXPORT_SYMBOL_GPL(crypto_cbc_geniv);
+
 static void xor_byte(u8 *a, const u8 *b, unsigned int bs)
 {
 	do {
@@ -314,6 +322,7 @@ static struct crypto_instance *crypto_cbc_alloc(struct rtattr **tb)
 	inst->alg.cra_blkcipher.setkey = crypto_cbc_setkey;
 	inst->alg.cra_blkcipher.encrypt = crypto_cbc_encrypt;
 	inst->alg.cra_blkcipher.decrypt = crypto_cbc_decrypt;
+	inst->alg.cra_blkcipher.geniv = crypto_cbc_geniv;
 
 out_put_alg:
 	crypto_mod_put(alg);
diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 8bf2da8..a1f3e2e 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -148,6 +148,14 @@ static int cryptd_blkcipher_decrypt_enqueue(struct ablkcipher_request *req)
 	return cryptd_blkcipher_enqueue(req, cryptd_blkcipher_decrypt);
 }
 
+static void cryptd_blkcipher_geniv(struct crypto_ablkcipher *tfm, u8 *iv,
+				   u64 seq)
+{
+	struct cryptd_blkcipher_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+
+	crypto_blkcipher_geniv(ctx->child, iv, seq);
+}
+
 static int cryptd_blkcipher_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
@@ -251,6 +259,7 @@ static struct crypto_instance *cryptd_alloc_blkcipher(
 	inst->alg.cra_ablkcipher.setkey = cryptd_blkcipher_setkey;
 	inst->alg.cra_ablkcipher.encrypt = cryptd_blkcipher_encrypt_enqueue;
 	inst->alg.cra_ablkcipher.decrypt = cryptd_blkcipher_decrypt_enqueue;
+	inst->alg.cra_ablkcipher.geniv = cryptd_blkcipher_geniv;
 
 out_put_alg:
 	crypto_mod_put(alg);
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 5fd6688..02f688a 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -27,6 +27,7 @@ config CRYPTO_DEV_PADLOCK_AES
 	tristate "PadLock driver for AES algorithm"
 	depends on CRYPTO_DEV_PADLOCK
 	select CRYPTO_BLKCIPHER
+	select CRYPTO_CBC
 	help
 	  Use VIA PadLock for AES algorithm.
 
@@ -55,6 +56,7 @@ config CRYPTO_DEV_GEODE
 	depends on X86_32 && PCI
 	select CRYPTO_ALGAPI
 	select CRYPTO_BLKCIPHER
+	select CRYPTO_CBC
 	help
 	  Say 'Y' here to use the AMD Geode LX processor on-board AES
 	  engine for the CryptoAPI AES algorithm.
diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 6a86958..7c48c18 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -13,6 +13,7 @@
 #include <linux/crypto.h>
 #include <linux/spinlock.h>
 #include <crypto/algapi.h>
+#include <crypto/cbc.h>
 
 #include <asm/io.h>
 #include <asm/delay.h>
@@ -294,6 +295,7 @@ static struct crypto_alg geode_cbc_alg = {
 			.setkey			=	geode_setkey,
 			.encrypt		=	geode_cbc_encrypt,
 			.decrypt		=	geode_cbc_decrypt,
+			.geniv			=	crypto_cbc_geniv,
 			.ivsize			=	AES_IV_LENGTH,
 		}
 	}
diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index d4501dc..af41ec3 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -44,6 +44,7 @@
  */
 
 #include <crypto/algapi.h>
+#include <crypto/cbc.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/types.h>
@@ -604,6 +605,7 @@ static struct crypto_alg cbc_aes_alg = {
 			.setkey	   		= 	aes_set_key,
 			.encrypt		=	cbc_aes_encrypt,
 			.decrypt		=	cbc_aes_decrypt,
+			.geniv			=	crypto_cbc_geniv,
 		}
 	}
 };
diff --git a/include/crypto/cbc.h b/include/crypto/cbc.h
new file mode 100644
index 0000000..6fec310
--- /dev/null
+++ b/include/crypto/cbc.h
@@ -0,0 +1,22 @@
+/*
+ * CBC: Cipher Block Chaining mode
+ *
+ * Copyright (c) 2007 Herbert Xu <herbert@gondor.apana.org.au>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option) 
+ * any later version.
+ *
+ */
+
+#ifndef _CRYPTO_CBC_H
+#define _CRYPTO_CBC_H
+
+#include <linux/types.h>
+
+struct crypto_blkcipher;
+
+void crypto_cbc_geniv(struct crypto_blkcipher *tfm, u8 *iv, u64 seq);
+
+#endif	/* _CRYPTO_CBC_H */
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index fc32694..8f9dd29 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -176,6 +176,7 @@ struct ablkcipher_alg {
 	              unsigned int keylen);
 	int (*encrypt)(struct ablkcipher_request *req);
 	int (*decrypt)(struct ablkcipher_request *req);
+	void (*geniv)(struct crypto_ablkcipher *tfm, u8 *iv, u64 seq);
 
 	unsigned int min_keysize;
 	unsigned int max_keysize;
@@ -187,6 +188,7 @@ struct aead_alg {
 	              unsigned int keylen);
 	int (*encrypt)(struct aead_request *req);
 	int (*decrypt)(struct aead_request *req);
+	void (*geniv)(struct crypto_aead *tfm, u8 *iv, u64 seq);
 
 	unsigned int ivsize;
 	unsigned int authsize;
@@ -201,6 +203,7 @@ struct blkcipher_alg {
 	int (*decrypt)(struct blkcipher_desc *desc,
 		       struct scatterlist *dst, struct scatterlist *src,
 		       unsigned int nbytes);
+	void (*geniv)(struct crypto_blkcipher *tfm, u8 *iv, u64 seq);
 
 	unsigned int min_keysize;
 	unsigned int max_keysize;
@@ -317,6 +320,7 @@ struct ablkcipher_tfm {
 	              unsigned int keylen);
 	int (*encrypt)(struct ablkcipher_request *req);
 	int (*decrypt)(struct ablkcipher_request *req);
+	void (*geniv)(struct crypto_ablkcipher *tfm, u8 *iv, u64 seq);
 	unsigned int ivsize;
 	unsigned int reqsize;
 };
@@ -326,6 +330,7 @@ struct aead_tfm {
 	              unsigned int keylen);
 	int (*encrypt)(struct aead_request *req);
 	int (*decrypt)(struct aead_request *req);
+	void (*geniv)(struct crypto_aead *tfm, u8 *iv, u64 seq);
 	unsigned int ivsize;
 	unsigned int authsize;
 	unsigned int reqsize;
@@ -339,6 +344,7 @@ struct blkcipher_tfm {
 		       struct scatterlist *src, unsigned int nbytes);
 	int (*decrypt)(struct blkcipher_desc *desc, struct scatterlist *dst,
 		       struct scatterlist *src, unsigned int nbytes);
+	void (*geniv)(struct crypto_blkcipher *tfm, u8 *iv, u64 seq);
 };
 
 struct cipher_tfm {
@@ -624,6 +630,13 @@ static inline int crypto_ablkcipher_decrypt(struct ablkcipher_request *req)
 	return crt->decrypt(req);
 }
 
+static inline void crypto_ablkcipher_geniv(struct crypto_ablkcipher *tfm,
+					   u8 *iv, u64 seq)
+{
+	struct ablkcipher_tfm *crt = crypto_ablkcipher_crt(tfm);
+	crt->geniv(tfm, iv, seq);
+}
+
 static inline unsigned int crypto_ablkcipher_reqsize(
 	struct crypto_ablkcipher *tfm)
 {
@@ -767,6 +780,12 @@ static inline int crypto_aead_decrypt(struct aead_request *req)
 	return crypto_aead_crt(crypto_aead_reqtfm(req))->decrypt(req);
 }
 
+static inline void crypto_aead_geniv(struct crypto_aead *tfm, u8 *iv, u64 seq)
+{
+	struct aead_tfm *crt = crypto_aead_crt(tfm);
+	crt->geniv(tfm, iv, seq);
+}
+
 static inline unsigned int crypto_aead_reqsize(struct crypto_aead *tfm)
 {
 	return crypto_aead_crt(tfm)->reqsize;
@@ -960,6 +979,13 @@ static inline int crypto_blkcipher_decrypt_iv(struct blkcipher_desc *desc,
 	return crypto_blkcipher_crt(desc->tfm)->decrypt(desc, dst, src, nbytes);
 }
 
+static inline void crypto_blkcipher_geniv(struct crypto_blkcipher *tfm,
+					  u8 *iv, u64 seq)
+{
+	struct blkcipher_tfm *crt = crypto_blkcipher_crt(tfm);
+	crt->geniv(tfm, iv, seq);
+}
+
 static inline void crypto_blkcipher_set_iv(struct crypto_blkcipher *tfm,
 					   const u8 *src, unsigned int len)
 {
