From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [Patch] [CRYPTO] add alignment for setkey() (rev 3)
Date: Sat, 19 May 2007 11:45:18 +0200
Message-ID: <20070519094518.GB26696@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:47913 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754746AbXESJpW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 May 2007 05:45:22 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

setkey() in {cipher,blkcipher,ablkcipher,hash}.c does not respect the
requested alignment by the algorithm. This patch fixes it. The extra
memory is allocated by kmalloc() with GFP_ATOMIC flag.

Signed-off-by: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Index: crypto-2.6/crypto/cipher.c
===================================================================
--- crypto-2.6.orig/crypto/cipher.c
+++ crypto-2.6/crypto/cipher.c
@@ -20,16 +20,43 @@
 #include <linux/string.h>
 #include "internal.h"
 
+static int setkey_unaligned(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen)
+{
+	struct cipher_alg *cia = &tfm->__crt_alg->cra_cipher;
+	unsigned long alignmask = crypto_tfm_alg_alignmask(tfm);
+	int ret;
+	u8 *buffer, *alignbuffer;
+	unsigned long absize;
+
+	absize = keylen + alignmask;
+	buffer = kmalloc(absize, GFP_ATOMIC);
+	if (!buffer)
+		return -ENOMEM;
+
+	alignbuffer = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
+	memcpy(alignbuffer, key, keylen);
+	ret = cia->cia_setkey(tfm, alignbuffer, keylen);
+	memset(alignbuffer, 0, absize);
+	kfree(buffer);
+	return ret;
+
+}
+
 static int setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen)
 {
 	struct cipher_alg *cia = &tfm->__crt_alg->cra_cipher;
-	
+	unsigned long alignmask = crypto_tfm_alg_alignmask(tfm);
+
 	tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
 	if (keylen < cia->cia_min_keysize || keylen > cia->cia_max_keysize) {
 		tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
 		return -EINVAL;
-	} else
-		return cia->cia_setkey(tfm, key, keylen);
+	}
+
+	if ((unsigned long)key & alignmask)
+		return setkey_unaligned(tfm, key, keylen);
+
+	return cia->cia_setkey(tfm, key, keylen);
 }
 
 static void cipher_crypt_unaligned(void (*fn)(struct crypto_tfm *, u8 *,
Index: crypto-2.6/crypto/ablkcipher.c
===================================================================
--- crypto-2.6.orig/crypto/ablkcipher.c
+++ crypto-2.6/crypto/ablkcipher.c
@@ -19,16 +19,41 @@
 #include <linux/module.h>
 #include <linux/seq_file.h>
 
+static int setkey_unaligned(struct crypto_ablkcipher *tfm, const u8 *key, unsigned int keylen)
+{
+	struct ablkcipher_alg *cipher = crypto_ablkcipher_alg(tfm);
+	unsigned long alignmask = crypto_ablkcipher_alignmask(tfm);
+	int ret;
+	u8 *buffer, *alignbuffer;
+	unsigned long absize;
+
+	absize = keylen + alignmask;
+	buffer = kmalloc(absize, GFP_ATOMIC);
+	if (!buffer)
+		return -ENOMEM;
+
+	alignbuffer = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
+	memcpy(alignbuffer, key, keylen);
+	ret = cipher->setkey(tfm, alignbuffer, keylen);
+	memset(alignbuffer, 0, absize);
+	kfree(buffer);
+	return ret;
+}
+
 static int setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 		  unsigned int keylen)
 {
 	struct ablkcipher_alg *cipher = crypto_ablkcipher_alg(tfm);
+	unsigned long alignmask = crypto_ablkcipher_alignmask(tfm);
 
 	if (keylen < cipher->min_keysize || keylen > cipher->max_keysize) {
 		crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 
+	if ((unsigned long)key & alignmask)
+		return setkey_unaligned(tfm, key, keylen);
+
 	return cipher->setkey(tfm, key, keylen);
 }
 
Index: crypto-2.6/crypto/blkcipher.c
===================================================================
--- crypto-2.6.orig/crypto/blkcipher.c
+++ crypto-2.6/crypto/blkcipher.c
@@ -336,16 +336,41 @@ static int blkcipher_walk_first(struct b
 	return blkcipher_walk_next(desc, walk);
 }
 
+static int setkey_unaligned(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen)
+{
+	struct blkcipher_alg *cipher = &tfm->__crt_alg->cra_blkcipher;
+	unsigned long alignmask = crypto_tfm_alg_alignmask(tfm);
+	int ret;
+	u8 *buffer, *alignbuffer;
+	unsigned long absize;
+
+	absize = keylen + alignmask;
+	buffer = kmalloc(absize, GFP_ATOMIC);
+	if (!buffer)
+		return -ENOMEM;
+
+	alignbuffer = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
+	memcpy(alignbuffer, key, keylen);
+	ret = cipher->setkey(tfm, alignbuffer, keylen);
+	memset(alignbuffer, 0, absize);
+	kfree(buffer);
+	return ret;
+}
+
 static int setkey(struct crypto_tfm *tfm, const u8 *key,
 		  unsigned int keylen)
 {
 	struct blkcipher_alg *cipher = &tfm->__crt_alg->cra_blkcipher;
+	unsigned long alignmask = crypto_tfm_alg_alignmask(tfm);
 
 	if (keylen < cipher->min_keysize || keylen > cipher->max_keysize) {
 		tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
 		return -EINVAL;
 	}
 
+	if ((unsigned long)key & alignmask)
+		return setkey_unaligned(tfm, key, keylen);
+
 	return cipher->setkey(tfm, key, keylen);
 }
 
Index: crypto-2.6/crypto/hash.c
===================================================================
--- crypto-2.6.orig/crypto/hash.c
+++ crypto-2.6/crypto/hash.c
@@ -22,6 +22,42 @@ static unsigned int crypto_hash_ctxsize(
 	return alg->cra_ctxsize;
 }
 
+static int hash_setkey_unaligned(struct crypto_hash *crt, const u8 *key,
+		                 unsigned int keylen)
+{
+	struct crypto_tfm *tfm = crypto_hash_tfm(crt);
+	struct hash_alg *alg = &tfm->__crt_alg->cra_hash;
+	unsigned long alignmask = crypto_hash_alignmask(crt);
+	int ret;
+	u8 *buffer, *alignbuffer;
+	unsigned long absize;
+
+	absize = keylen + alignmask;
+	buffer = kmalloc(absize, GFP_ATOMIC);
+	if (!buffer)
+		return -ENOMEM;
+
+	alignbuffer = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
+	memcpy(alignbuffer, key, keylen);
+	ret = alg->setkey(crt, alignbuffer, keylen);
+	memset(alignbuffer, 0, absize);
+	kfree(buffer);
+	return ret;
+}
+
+static int hash_setkey(struct crypto_hash *crt, const u8 *key,
+		unsigned int keylen)
+{
+	struct crypto_tfm *tfm = crypto_hash_tfm(crt);
+	struct hash_alg *alg = &tfm->__crt_alg->cra_hash;
+	unsigned long alignmask = crypto_hash_alignmask(crt);
+
+	if ((unsigned long)key & alignmask)
+		return hash_setkey_unaligned(crt, key, keylen);
+
+	return alg->setkey(crt, key, keylen);
+}
+
 static int crypto_init_hash_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 {
 	struct hash_tfm *crt = &tfm->crt_hash;
@@ -34,7 +70,7 @@ static int crypto_init_hash_ops(struct c
 	crt->update = alg->update;
 	crt->final = alg->final;
 	crt->digest = alg->digest;
-	crt->setkey = alg->setkey;
+	crt->setkey = hash_setkey;
 	crt->digestsize = alg->digestsize;
 
 	return 0;
