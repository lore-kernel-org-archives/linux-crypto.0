Return-Path: <SRS0=65YJ=CK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDDD3C433E6
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Sep 2020 06:31:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD81920FC3
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Sep 2020 06:31:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgIAGbY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Sep 2020 02:31:24 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:38384 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726050AbgIAGbY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Sep 2020 02:31:24 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kCzpB-0003uh-Ej; Tue, 01 Sep 2020 16:31:22 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 01 Sep 2020 16:31:21 +1000
Date:   Tue, 1 Sep 2020 16:31:21 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH 2/2] crypto: cbc - Remove cbc.h
Message-ID: <20200901063121.GA1573@gondor.apana.org.au>
References: <20200901062804.GA1533@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901062804.GA1533@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Now that crypto/cbc.h is only used by the generic cbc template,
we can merge it back into the CBC code.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/cbc.c b/crypto/cbc.c
index e6f6273a7d39..0d9509dff891 100644
--- a/crypto/cbc.c
+++ b/crypto/cbc.c
@@ -6,7 +6,6 @@
  */
 
 #include <crypto/algapi.h>
-#include <crypto/cbc.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -14,34 +13,157 @@
 #include <linux/log2.h>
 #include <linux/module.h>
 
-static inline void crypto_cbc_encrypt_one(struct crypto_skcipher *tfm,
-					  const u8 *src, u8 *dst)
+static int crypto_cbc_encrypt_segment(struct skcipher_walk *walk,
+				      struct crypto_skcipher *skcipher)
 {
-	crypto_cipher_encrypt_one(skcipher_cipher_simple(tfm), dst, src);
+	unsigned int bsize = crypto_skcipher_blocksize(skcipher);
+	void (*fn)(struct crypto_tfm *, u8 *, const u8 *);
+	unsigned int nbytes = walk->nbytes;
+	u8 *src = walk->src.virt.addr;
+	u8 *dst = walk->dst.virt.addr;
+	struct crypto_cipher *cipher;
+	struct crypto_tfm *tfm;
+	u8 *iv = walk->iv;
+
+	cipher = skcipher_cipher_simple(skcipher);
+	tfm = crypto_cipher_tfm(cipher);
+	fn = crypto_cipher_alg(cipher)->cia_encrypt;
+
+	do {
+		crypto_xor(iv, src, bsize);
+		fn(tfm, dst, iv);
+		memcpy(iv, dst, bsize);
+
+		src += bsize;
+		dst += bsize;
+	} while ((nbytes -= bsize) >= bsize);
+
+	return nbytes;
+}
+
+static int crypto_cbc_encrypt_inplace(struct skcipher_walk *walk,
+				      struct crypto_skcipher *skcipher)
+{
+	unsigned int bsize = crypto_skcipher_blocksize(skcipher);
+	void (*fn)(struct crypto_tfm *, u8 *, const u8 *);
+	unsigned int nbytes = walk->nbytes;
+	u8 *src = walk->src.virt.addr;
+	struct crypto_cipher *cipher;
+	struct crypto_tfm *tfm;
+	u8 *iv = walk->iv;
+
+	cipher = skcipher_cipher_simple(skcipher);
+	tfm = crypto_cipher_tfm(cipher);
+	fn = crypto_cipher_alg(cipher)->cia_encrypt;
+
+	do {
+		crypto_xor(src, iv, bsize);
+		fn(tfm, src, src);
+		iv = src;
+
+		src += bsize;
+	} while ((nbytes -= bsize) >= bsize);
+
+	memcpy(walk->iv, iv, bsize);
+
+	return nbytes;
 }
 
 static int crypto_cbc_encrypt(struct skcipher_request *req)
 {
-	return crypto_cbc_encrypt_walk(req, crypto_cbc_encrypt_one);
+	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
+	struct skcipher_walk walk;
+	int err;
+
+	err = skcipher_walk_virt(&walk, req, false);
+
+	while (walk.nbytes) {
+		if (walk.src.virt.addr == walk.dst.virt.addr)
+			err = crypto_cbc_encrypt_inplace(&walk, skcipher);
+		else
+			err = crypto_cbc_encrypt_segment(&walk, skcipher);
+		err = skcipher_walk_done(&walk, err);
+	}
+
+	return err;
+}
+
+static int crypto_cbc_decrypt_segment(struct skcipher_walk *walk,
+				      struct crypto_skcipher *skcipher)
+{
+	unsigned int bsize = crypto_skcipher_blocksize(skcipher);
+	void (*fn)(struct crypto_tfm *, u8 *, const u8 *);
+	unsigned int nbytes = walk->nbytes;
+	u8 *src = walk->src.virt.addr;
+	u8 *dst = walk->dst.virt.addr;
+	struct crypto_cipher *cipher;
+	struct crypto_tfm *tfm;
+	u8 *iv = walk->iv;
+
+	cipher = skcipher_cipher_simple(skcipher);
+	tfm = crypto_cipher_tfm(cipher);
+	fn = crypto_cipher_alg(cipher)->cia_decrypt;
+
+	do {
+		fn(tfm, dst, src);
+		crypto_xor(dst, iv, bsize);
+		iv = src;
+
+		src += bsize;
+		dst += bsize;
+	} while ((nbytes -= bsize) >= bsize);
+
+	memcpy(walk->iv, iv, bsize);
+
+	return nbytes;
 }
 
-static inline void crypto_cbc_decrypt_one(struct crypto_skcipher *tfm,
-					  const u8 *src, u8 *dst)
+static int crypto_cbc_decrypt_inplace(struct skcipher_walk *walk,
+				      struct crypto_skcipher *skcipher)
 {
-	crypto_cipher_decrypt_one(skcipher_cipher_simple(tfm), dst, src);
+	unsigned int bsize = crypto_skcipher_blocksize(skcipher);
+	void (*fn)(struct crypto_tfm *, u8 *, const u8 *);
+	unsigned int nbytes = walk->nbytes;
+	u8 *src = walk->src.virt.addr;
+	u8 last_iv[MAX_CIPHER_BLOCKSIZE];
+	struct crypto_cipher *cipher;
+	struct crypto_tfm *tfm;
+
+	cipher = skcipher_cipher_simple(skcipher);
+	tfm = crypto_cipher_tfm(cipher);
+	fn = crypto_cipher_alg(cipher)->cia_decrypt;
+
+	/* Start of the last block. */
+	src += nbytes - (nbytes & (bsize - 1)) - bsize;
+	memcpy(last_iv, src, bsize);
+
+	for (;;) {
+		fn(tfm, src, src);
+		if ((nbytes -= bsize) < bsize)
+			break;
+		crypto_xor(src, src - bsize, bsize);
+		src -= bsize;
+	}
+
+	crypto_xor(src, walk->iv, bsize);
+	memcpy(walk->iv, last_iv, bsize);
+
+	return nbytes;
 }
 
 static int crypto_cbc_decrypt(struct skcipher_request *req)
 {
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
 	struct skcipher_walk walk;
 	int err;
 
 	err = skcipher_walk_virt(&walk, req, false);
 
 	while (walk.nbytes) {
-		err = crypto_cbc_decrypt_blocks(&walk, tfm,
-						crypto_cbc_decrypt_one);
+		if (walk.src.virt.addr == walk.dst.virt.addr)
+			err = crypto_cbc_decrypt_inplace(&walk, skcipher);
+		else
+			err = crypto_cbc_decrypt_segment(&walk, skcipher);
 		err = skcipher_walk_done(&walk, err);
 	}
 
diff --git a/include/crypto/cbc.h b/include/crypto/cbc.h
deleted file mode 100644
index 2b6422db42e2..000000000000
--- a/include/crypto/cbc.h
+++ /dev/null
@@ -1,141 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-/*
- * CBC: Cipher Block Chaining mode
- *
- * Copyright (c) 2016 Herbert Xu <herbert@gondor.apana.org.au>
- */
-
-#ifndef _CRYPTO_CBC_H
-#define _CRYPTO_CBC_H
-
-#include <crypto/internal/skcipher.h>
-#include <linux/string.h>
-#include <linux/types.h>
-
-static inline int crypto_cbc_encrypt_segment(
-	struct skcipher_walk *walk, struct crypto_skcipher *tfm,
-	void (*fn)(struct crypto_skcipher *, const u8 *, u8 *))
-{
-	unsigned int bsize = crypto_skcipher_blocksize(tfm);
-	unsigned int nbytes = walk->nbytes;
-	u8 *src = walk->src.virt.addr;
-	u8 *dst = walk->dst.virt.addr;
-	u8 *iv = walk->iv;
-
-	do {
-		crypto_xor(iv, src, bsize);
-		fn(tfm, iv, dst);
-		memcpy(iv, dst, bsize);
-
-		src += bsize;
-		dst += bsize;
-	} while ((nbytes -= bsize) >= bsize);
-
-	return nbytes;
-}
-
-static inline int crypto_cbc_encrypt_inplace(
-	struct skcipher_walk *walk, struct crypto_skcipher *tfm,
-	void (*fn)(struct crypto_skcipher *, const u8 *, u8 *))
-{
-	unsigned int bsize = crypto_skcipher_blocksize(tfm);
-	unsigned int nbytes = walk->nbytes;
-	u8 *src = walk->src.virt.addr;
-	u8 *iv = walk->iv;
-
-	do {
-		crypto_xor(src, iv, bsize);
-		fn(tfm, src, src);
-		iv = src;
-
-		src += bsize;
-	} while ((nbytes -= bsize) >= bsize);
-
-	memcpy(walk->iv, iv, bsize);
-
-	return nbytes;
-}
-
-static inline int crypto_cbc_encrypt_walk(struct skcipher_request *req,
-					  void (*fn)(struct crypto_skcipher *,
-						     const u8 *, u8 *))
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct skcipher_walk walk;
-	int err;
-
-	err = skcipher_walk_virt(&walk, req, false);
-
-	while (walk.nbytes) {
-		if (walk.src.virt.addr == walk.dst.virt.addr)
-			err = crypto_cbc_encrypt_inplace(&walk, tfm, fn);
-		else
-			err = crypto_cbc_encrypt_segment(&walk, tfm, fn);
-		err = skcipher_walk_done(&walk, err);
-	}
-
-	return err;
-}
-
-static inline int crypto_cbc_decrypt_segment(
-	struct skcipher_walk *walk, struct crypto_skcipher *tfm,
-	void (*fn)(struct crypto_skcipher *, const u8 *, u8 *))
-{
-	unsigned int bsize = crypto_skcipher_blocksize(tfm);
-	unsigned int nbytes = walk->nbytes;
-	u8 *src = walk->src.virt.addr;
-	u8 *dst = walk->dst.virt.addr;
-	u8 *iv = walk->iv;
-
-	do {
-		fn(tfm, src, dst);
-		crypto_xor(dst, iv, bsize);
-		iv = src;
-
-		src += bsize;
-		dst += bsize;
-	} while ((nbytes -= bsize) >= bsize);
-
-	memcpy(walk->iv, iv, bsize);
-
-	return nbytes;
-}
-
-static inline int crypto_cbc_decrypt_inplace(
-	struct skcipher_walk *walk, struct crypto_skcipher *tfm,
-	void (*fn)(struct crypto_skcipher *, const u8 *, u8 *))
-{
-	unsigned int bsize = crypto_skcipher_blocksize(tfm);
-	unsigned int nbytes = walk->nbytes;
-	u8 *src = walk->src.virt.addr;
-	u8 last_iv[MAX_CIPHER_BLOCKSIZE];
-
-	/* Start of the last block. */
-	src += nbytes - (nbytes & (bsize - 1)) - bsize;
-	memcpy(last_iv, src, bsize);
-
-	for (;;) {
-		fn(tfm, src, src);
-		if ((nbytes -= bsize) < bsize)
-			break;
-		crypto_xor(src, src - bsize, bsize);
-		src -= bsize;
-	}
-
-	crypto_xor(src, walk->iv, bsize);
-	memcpy(walk->iv, last_iv, bsize);
-
-	return nbytes;
-}
-
-static inline int crypto_cbc_decrypt_blocks(
-	struct skcipher_walk *walk, struct crypto_skcipher *tfm,
-	void (*fn)(struct crypto_skcipher *, const u8 *, u8 *))
-{
-	if (walk->src.virt.addr == walk->dst.virt.addr)
-		return crypto_cbc_decrypt_inplace(walk, tfm, fn);
-	else
-		return crypto_cbc_decrypt_segment(walk, tfm, fn);
-}
-
-#endif	/* _CRYPTO_CBC_H */
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
