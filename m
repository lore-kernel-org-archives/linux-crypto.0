Return-Path: <SRS0=ccn8=ZY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66B78C432C3
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Dec 2019 21:42:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27EA6206F0
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Dec 2019 21:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575322975;
	bh=cYrKbSdOfbaxlnBpsAOduyszybhpUcszGoXsXA6TVMg=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=PKT41dA/n6NQ6JE6OqTses0dBbM/MoKmqBRvbJc4VqKO+PMPM7g06uVV/BdFsM10K
	 8F8VFTyDofNdE77WbDXVrmMvOAHXnJCgEXsLtpY+wiy1AgxPMDC9l/UuCwiUzoaIyC
	 Y2WI3ZbS/tn2pC045Cfc4Sp5Ewdn57kG4Jro23hQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725834AbfLBVmy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Dec 2019 16:42:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:38650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbfLBVmy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Dec 2019 16:42:54 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D47C32071E
        for <linux-crypto@vger.kernel.org>; Mon,  2 Dec 2019 21:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575322972;
        bh=cYrKbSdOfbaxlnBpsAOduyszybhpUcszGoXsXA6TVMg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=WP+I1A/Egl2dfy6nBCvFf2AefS8HwHb71WOqIvrgH2F4SSIVmz6dsTII2DumgbTlX
         a7tSMs1L2STcTJpLLgY0w6i8GHdMPaULKej2LMNjspA5UfqKnoyabUVcJsy/8QwI0s
         UDJ4nhB2KO2MKqeE8Y2G/T2RckpbVaRRP2T+fr6M=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 2/2] crypto: cipher - remove crt_u.cipher (struct cipher_tfm)
Date:   Mon,  2 Dec 2019 13:42:30 -0800
Message-Id: <20191202214230.164997-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
In-Reply-To: <20191202214230.164997-1-ebiggers@kernel.org>
References: <20191202214230.164997-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Of the three fields in crt_u.cipher (struct cipher_tfm), ->cit_setkey()
is pointless because it always points to setkey() in crypto/cipher.c.

->cit_decrypt_one() and ->cit_encrypt_one() are slightly less pointless,
since if the algorithm doesn't have an alignmask, they are set directly
to ->cia_encrypt() and ->cia_decrypt().  However, this "optimization"
isn't worthwhile because:

- The "cipher" algorithm type is the only algorithm still using crt_u,
  so it's bloating every struct crypto_tfm for every algorithm type.

- If the algorithm has an alignmask, this "optimization" actually makes
  things slower, as it causes 2 indirect calls per block rather than 1.

- It adds extra code complexity.

- Some templates already call ->cia_encrypt()/->cia_decrypt() directly
  instead of going through ->cit_encrypt_one()/->cit_decrypt_one().

- The "cipher" algorithm type never gives optimal performance anyway.
  For that, a higher-level type such as skcipher needs to be used.

Therefore, just remove the extra indirection, and make
crypto_cipher_setkey(), crypto_cipher_encrypt_one(), and
crypto_cipher_decrypt_one() be direct calls into crypto/cipher.c.

Also remove the unused function crypto_cipher_cast().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/api.c           | 15 +------
 crypto/cipher.c        | 92 +++++++++++++++++-------------------------
 crypto/internal.h      |  2 -
 include/linux/crypto.h | 48 +++-------------------
 4 files changed, 43 insertions(+), 114 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index d1ff266a92ff7d..72b6527d7e890c 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -295,20 +295,7 @@ static int crypto_init_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 
 	if (type_obj)
 		return type_obj->init(tfm, type, mask);
-
-	switch (crypto_tfm_alg_type(tfm)) {
-	case CRYPTO_ALG_TYPE_CIPHER:
-		return crypto_init_cipher_ops(tfm);
-
-	case CRYPTO_ALG_TYPE_COMPRESS:
-		return 0;
-
-	default:
-		break;
-	}
-
-	BUG();
-	return -EINVAL;
+	return 0;
 }
 
 static void crypto_exit_ops(struct crypto_tfm *tfm)
diff --git a/crypto/cipher.c b/crypto/cipher.c
index 108427026e7c7a..aadd51cb7250c1 100644
--- a/crypto/cipher.c
+++ b/crypto/cipher.c
@@ -2,7 +2,7 @@
 /*
  * Cryptographic API.
  *
- * Cipher operations.
+ * Single-block cipher operations.
  *
  * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
  * Copyright (c) 2005 Herbert Xu <herbert@gondor.apana.org.au>
@@ -16,11 +16,11 @@
 #include <linux/string.h>
 #include "internal.h"
 
-static int setkey_unaligned(struct crypto_tfm *tfm, const u8 *key,
+static int setkey_unaligned(struct crypto_cipher *tfm, const u8 *key,
 			    unsigned int keylen)
 {
-	struct cipher_alg *cia = &tfm->__crt_alg->cra_cipher;
-	unsigned long alignmask = crypto_tfm_alg_alignmask(tfm);
+	struct cipher_alg *cia = crypto_cipher_alg(tfm);
+	unsigned long alignmask = crypto_cipher_alignmask(tfm);
 	int ret;
 	u8 *buffer, *alignbuffer;
 	unsigned long absize;
@@ -32,83 +32,63 @@ static int setkey_unaligned(struct crypto_tfm *tfm, const u8 *key,
 
 	alignbuffer = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
 	memcpy(alignbuffer, key, keylen);
-	ret = cia->cia_setkey(tfm, alignbuffer, keylen);
+	ret = cia->cia_setkey(crypto_cipher_tfm(tfm), alignbuffer, keylen);
 	memset(alignbuffer, 0, keylen);
 	kfree(buffer);
 	return ret;
 
 }
 
-static int setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen)
+int crypto_cipher_setkey(struct crypto_cipher *tfm,
+			 const u8 *key, unsigned int keylen)
 {
-	struct cipher_alg *cia = &tfm->__crt_alg->cra_cipher;
-	unsigned long alignmask = crypto_tfm_alg_alignmask(tfm);
+	struct cipher_alg *cia = crypto_cipher_alg(tfm);
+	unsigned long alignmask = crypto_cipher_alignmask(tfm);
 
-	tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
+	crypto_cipher_clear_flags(tfm, CRYPTO_TFM_RES_MASK);
 	if (keylen < cia->cia_min_keysize || keylen > cia->cia_max_keysize) {
-		tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+		crypto_cipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 
 	if ((unsigned long)key & alignmask)
 		return setkey_unaligned(tfm, key, keylen);
 
-	return cia->cia_setkey(tfm, key, keylen);
+	return cia->cia_setkey(crypto_cipher_tfm(tfm), key, keylen);
 }
+EXPORT_SYMBOL_GPL(crypto_cipher_setkey);
 
-static void cipher_crypt_unaligned(void (*fn)(struct crypto_tfm *, u8 *,
-					      const u8 *),
-				   struct crypto_tfm *tfm,
-				   u8 *dst, const u8 *src)
+static inline void cipher_crypt_one(struct crypto_cipher *tfm,
+				    u8 *dst, const u8 *src, bool enc)
 {
-	unsigned long alignmask = crypto_tfm_alg_alignmask(tfm);
-	unsigned int size = crypto_tfm_alg_blocksize(tfm);
-	u8 buffer[MAX_CIPHER_BLOCKSIZE + MAX_CIPHER_ALIGNMASK];
-	u8 *tmp = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
-
-	memcpy(tmp, src, size);
-	fn(tfm, tmp, tmp);
-	memcpy(dst, tmp, size);
-}
-
-static void cipher_encrypt_unaligned(struct crypto_tfm *tfm,
-				     u8 *dst, const u8 *src)
-{
-	unsigned long alignmask = crypto_tfm_alg_alignmask(tfm);
-	struct cipher_alg *cipher = &tfm->__crt_alg->cra_cipher;
+	unsigned long alignmask = crypto_cipher_alignmask(tfm);
+	struct cipher_alg *cia = crypto_cipher_alg(tfm);
+	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
+		enc ? cia->cia_encrypt : cia->cia_decrypt;
 
 	if (unlikely(((unsigned long)dst | (unsigned long)src) & alignmask)) {
-		cipher_crypt_unaligned(cipher->cia_encrypt, tfm, dst, src);
-		return;
+		unsigned int bs = crypto_cipher_blocksize(tfm);
+		u8 buffer[MAX_CIPHER_BLOCKSIZE + MAX_CIPHER_ALIGNMASK];
+		u8 *tmp = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
+
+		memcpy(tmp, src, bs);
+		fn(crypto_cipher_tfm(tfm), tmp, tmp);
+		memcpy(dst, tmp, bs);
+	} else {
+		fn(crypto_cipher_tfm(tfm), dst, src);
 	}
-
-	cipher->cia_encrypt(tfm, dst, src);
 }
 
-static void cipher_decrypt_unaligned(struct crypto_tfm *tfm,
-				     u8 *dst, const u8 *src)
+void crypto_cipher_encrypt_one(struct crypto_cipher *tfm,
+			       u8 *dst, const u8 *src)
 {
-	unsigned long alignmask = crypto_tfm_alg_alignmask(tfm);
-	struct cipher_alg *cipher = &tfm->__crt_alg->cra_cipher;
-
-	if (unlikely(((unsigned long)dst | (unsigned long)src) & alignmask)) {
-		cipher_crypt_unaligned(cipher->cia_decrypt, tfm, dst, src);
-		return;
-	}
-
-	cipher->cia_decrypt(tfm, dst, src);
+	cipher_crypt_one(tfm, dst, src, true);
 }
+EXPORT_SYMBOL_GPL(crypto_cipher_encrypt_one);
 
-int crypto_init_cipher_ops(struct crypto_tfm *tfm)
+void crypto_cipher_decrypt_one(struct crypto_cipher *tfm,
+			       u8 *dst, const u8 *src)
 {
-	struct cipher_tfm *ops = &tfm->crt_cipher;
-	struct cipher_alg *cipher = &tfm->__crt_alg->cra_cipher;
-
-	ops->cit_setkey = setkey;
-	ops->cit_encrypt_one = crypto_tfm_alg_alignmask(tfm) ?
-		cipher_encrypt_unaligned : cipher->cia_encrypt;
-	ops->cit_decrypt_one = crypto_tfm_alg_alignmask(tfm) ?
-		cipher_decrypt_unaligned : cipher->cia_decrypt;
-
-	return 0;
+	cipher_crypt_one(tfm, dst, src, false);
 }
+EXPORT_SYMBOL_GPL(crypto_cipher_decrypt_one);
diff --git a/crypto/internal.h b/crypto/internal.h
index a58a2af4b66963..ff06a3bd1ca10c 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -58,8 +58,6 @@ static inline unsigned int crypto_compress_ctxsize(struct crypto_alg *alg)
 struct crypto_alg *crypto_mod_get(struct crypto_alg *alg);
 struct crypto_alg *crypto_alg_mod_lookup(const char *name, u32 type, u32 mask);
 
-int crypto_init_cipher_ops(struct crypto_tfm *tfm);
-
 struct crypto_larval *crypto_larval_alloc(const char *name, u32 type, u32 mask);
 void crypto_larval_kill(struct crypto_alg *alg);
 void crypto_alg_tested(const char *name, int err);
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 8f708564b98b11..c23f1eed797029 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -599,23 +599,10 @@ int crypto_has_alg(const char *name, u32 type, u32 mask);
  * crypto_free_*(), as well as the various helpers below.
  */
 
-struct cipher_tfm {
-	int (*cit_setkey)(struct crypto_tfm *tfm,
-	                  const u8 *key, unsigned int keylen);
-	void (*cit_encrypt_one)(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
-	void (*cit_decrypt_one)(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
-};
-
-#define crt_cipher	crt_u.cipher
-
 struct crypto_tfm {
 
 	u32 crt_flags;
 	
-	union {
-		struct cipher_tfm cipher;
-	} crt_u;
-
 	void (*exit)(struct crypto_tfm *tfm);
 	
 	struct crypto_alg *__crt_alg;
@@ -752,12 +739,6 @@ static inline struct crypto_cipher *__crypto_cipher_cast(struct crypto_tfm *tfm)
 	return (struct crypto_cipher *)tfm;
 }
 
-static inline struct crypto_cipher *crypto_cipher_cast(struct crypto_tfm *tfm)
-{
-	BUG_ON(crypto_tfm_alg_type(tfm) != CRYPTO_ALG_TYPE_CIPHER);
-	return __crypto_cipher_cast(tfm);
-}
-
 /**
  * crypto_alloc_cipher() - allocate single block cipher handle
  * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
@@ -815,11 +796,6 @@ static inline int crypto_has_cipher(const char *alg_name, u32 type, u32 mask)
 	return crypto_has_alg(alg_name, type, mask);
 }
 
-static inline struct cipher_tfm *crypto_cipher_crt(struct crypto_cipher *tfm)
-{
-	return &crypto_cipher_tfm(tfm)->crt_cipher;
-}
-
 /**
  * crypto_cipher_blocksize() - obtain block size for cipher
  * @tfm: cipher handle
@@ -873,12 +849,8 @@ static inline void crypto_cipher_clear_flags(struct crypto_cipher *tfm,
  *
  * Return: 0 if the setting of the key was successful; < 0 if an error occurred
  */
-static inline int crypto_cipher_setkey(struct crypto_cipher *tfm,
-                                       const u8 *key, unsigned int keylen)
-{
-	return crypto_cipher_crt(tfm)->cit_setkey(crypto_cipher_tfm(tfm),
-						  key, keylen);
-}
+int crypto_cipher_setkey(struct crypto_cipher *tfm,
+			 const u8 *key, unsigned int keylen);
 
 /**
  * crypto_cipher_encrypt_one() - encrypt one block of plaintext
@@ -889,12 +861,8 @@ static inline int crypto_cipher_setkey(struct crypto_cipher *tfm,
  * Invoke the encryption operation of one block. The caller must ensure that
  * the plaintext and ciphertext buffers are at least one block in size.
  */
-static inline void crypto_cipher_encrypt_one(struct crypto_cipher *tfm,
-					     u8 *dst, const u8 *src)
-{
-	crypto_cipher_crt(tfm)->cit_encrypt_one(crypto_cipher_tfm(tfm),
-						dst, src);
-}
+void crypto_cipher_encrypt_one(struct crypto_cipher *tfm,
+			       u8 *dst, const u8 *src);
 
 /**
  * crypto_cipher_decrypt_one() - decrypt one block of ciphertext
@@ -905,12 +873,8 @@ static inline void crypto_cipher_encrypt_one(struct crypto_cipher *tfm,
  * Invoke the decryption operation of one block. The caller must ensure that
  * the plaintext and ciphertext buffers are at least one block in size.
  */
-static inline void crypto_cipher_decrypt_one(struct crypto_cipher *tfm,
-					     u8 *dst, const u8 *src)
-{
-	crypto_cipher_crt(tfm)->cit_decrypt_one(crypto_cipher_tfm(tfm),
-						dst, src);
-}
+void crypto_cipher_decrypt_one(struct crypto_cipher *tfm,
+			       u8 *dst, const u8 *src);
 
 static inline struct crypto_comp *__crypto_comp_cast(struct crypto_tfm *tfm)
 {
-- 
2.24.0.393.g34dc348eaf-goog

