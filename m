From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/5] [CRYPTO] cbc: Use crypto_xor
Date: Thu, 22 Nov 2007 16:37:46 +0800
Message-ID: <E1Iv7ZC-0001wJ-00@gondolin.me.apana.org.au>
References: <20071122083656.GB7368@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4621 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751073AbXKVIsG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 03:48:06 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1Iv7j7-0008A8-N9
	for <linux-crypto@vger.kernel.org>; Thu, 22 Nov 2007 19:48:02 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] cbc: Use crypto_xor

This patch replaces the custom xor in CBC with the generic crypto_xor.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/cbc.c |   93 ++++++++++-------------------------------------------------
 1 files changed, 16 insertions(+), 77 deletions(-)

diff --git a/crypto/cbc.c b/crypto/cbc.c
index 1f2649e..b013d6f 100644
--- a/crypto/cbc.c
+++ b/crypto/cbc.c
@@ -20,7 +20,6 @@
 
 struct crypto_cbc_ctx {
 	struct crypto_cipher *child;
-	void (*xor)(u8 *dst, const u8 *src, unsigned int bs);
 };
 
 static int crypto_cbc_setkey(struct crypto_tfm *parent, const u8 *key,
@@ -41,9 +40,7 @@ static int crypto_cbc_setkey(struct crypto_tfm *parent, const u8 *key,
 
 static int crypto_cbc_encrypt_segment(struct blkcipher_desc *desc,
 				      struct blkcipher_walk *walk,
-				      struct crypto_cipher *tfm,
-				      void (*xor)(u8 *, const u8 *,
-						  unsigned int))
+				      struct crypto_cipher *tfm)
 {
 	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
 		crypto_cipher_alg(tfm)->cia_encrypt;
@@ -54,7 +51,7 @@ static int crypto_cbc_encrypt_segment(struct blkcipher_desc *desc,
 	u8 *iv = walk->iv;
 
 	do {
-		xor(iv, src, bsize);
+		crypto_xor(iv, src, bsize);
 		fn(crypto_cipher_tfm(tfm), dst, iv);
 		memcpy(iv, dst, bsize);
 
@@ -67,9 +64,7 @@ static int crypto_cbc_encrypt_segment(struct blkcipher_desc *desc,
 
 static int crypto_cbc_encrypt_inplace(struct blkcipher_desc *desc,
 				      struct blkcipher_walk *walk,
-				      struct crypto_cipher *tfm,
-				      void (*xor)(u8 *, const u8 *,
-						  unsigned int))
+				      struct crypto_cipher *tfm)
 {
 	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
 		crypto_cipher_alg(tfm)->cia_encrypt;
@@ -79,7 +74,7 @@ static int crypto_cbc_encrypt_inplace(struct blkcipher_desc *desc,
 	u8 *iv = walk->iv;
 
 	do {
-		xor(src, iv, bsize);
+		crypto_xor(src, iv, bsize);
 		fn(crypto_cipher_tfm(tfm), src, src);
 		iv = src;
 
@@ -99,7 +94,6 @@ static int crypto_cbc_encrypt(struct blkcipher_desc *desc,
 	struct crypto_blkcipher *tfm = desc->tfm;
 	struct crypto_cbc_ctx *ctx = crypto_blkcipher_ctx(tfm);
 	struct crypto_cipher *child = ctx->child;
-	void (*xor)(u8 *, const u8 *, unsigned int bs) = ctx->xor;
 	int err;
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
@@ -107,11 +101,9 @@ static int crypto_cbc_encrypt(struct blkcipher_desc *desc,
 
 	while ((nbytes = walk.nbytes)) {
 		if (walk.src.virt.addr == walk.dst.virt.addr)
-			nbytes = crypto_cbc_encrypt_inplace(desc, &walk, child,
-							    xor);
+			nbytes = crypto_cbc_encrypt_inplace(desc, &walk, child);
 		else
-			nbytes = crypto_cbc_encrypt_segment(desc, &walk, child,
-							    xor);
+			nbytes = crypto_cbc_encrypt_segment(desc, &walk, child);
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
 
@@ -120,9 +112,7 @@ static int crypto_cbc_encrypt(struct blkcipher_desc *desc,
 
 static int crypto_cbc_decrypt_segment(struct blkcipher_desc *desc,
 				      struct blkcipher_walk *walk,
-				      struct crypto_cipher *tfm,
-				      void (*xor)(u8 *, const u8 *,
-						  unsigned int))
+				      struct crypto_cipher *tfm)
 {
 	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
 		crypto_cipher_alg(tfm)->cia_decrypt;
@@ -134,7 +124,7 @@ static int crypto_cbc_decrypt_segment(struct blkcipher_desc *desc,
 
 	do {
 		fn(crypto_cipher_tfm(tfm), dst, src);
-		xor(dst, iv, bsize);
+		crypto_xor(dst, iv, bsize);
 		iv = src;
 
 		src += bsize;
@@ -148,9 +138,7 @@ static int crypto_cbc_decrypt_segment(struct blkcipher_desc *desc,
 
 static int crypto_cbc_decrypt_inplace(struct blkcipher_desc *desc,
 				      struct blkcipher_walk *walk,
-				      struct crypto_cipher *tfm,
-				      void (*xor)(u8 *, const u8 *,
-						  unsigned int))
+				      struct crypto_cipher *tfm)
 {
 	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
 		crypto_cipher_alg(tfm)->cia_decrypt;
@@ -171,11 +159,11 @@ static int crypto_cbc_decrypt_inplace(struct blkcipher_desc *desc,
 		fn(crypto_cipher_tfm(tfm), src, src);
 		if ((nbytes -= bsize) < bsize)
 			break;
-		xor(src, src - bsize, bsize);
+		crypto_xor(src, src - bsize, bsize);
 		src -= bsize;
 	}
 
-	xor(src, first_iv, bsize);
+	crypto_xor(src, first_iv, bsize);
 
 	return nbytes;
 }
@@ -188,7 +176,6 @@ static int crypto_cbc_decrypt(struct blkcipher_desc *desc,
 	struct crypto_blkcipher *tfm = desc->tfm;
 	struct crypto_cbc_ctx *ctx = crypto_blkcipher_ctx(tfm);
 	struct crypto_cipher *child = ctx->child;
-	void (*xor)(u8 *, const u8 *, unsigned int bs) = ctx->xor;
 	int err;
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
@@ -196,48 +183,15 @@ static int crypto_cbc_decrypt(struct blkcipher_desc *desc,
 
 	while ((nbytes = walk.nbytes)) {
 		if (walk.src.virt.addr == walk.dst.virt.addr)
-			nbytes = crypto_cbc_decrypt_inplace(desc, &walk, child,
-							    xor);
+			nbytes = crypto_cbc_decrypt_inplace(desc, &walk, child);
 		else
-			nbytes = crypto_cbc_decrypt_segment(desc, &walk, child,
-							    xor);
+			nbytes = crypto_cbc_decrypt_segment(desc, &walk, child);
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
 
 	return err;
 }
 
-static void xor_byte(u8 *a, const u8 *b, unsigned int bs)
-{
-	do {
-		*a++ ^= *b++;
-	} while (--bs);
-}
-
-static void xor_quad(u8 *dst, const u8 *src, unsigned int bs)
-{
-	u32 *a = (u32 *)dst;
-	u32 *b = (u32 *)src;
-
-	do {
-		*a++ ^= *b++;
-	} while ((bs -= 4));
-}
-
-static void xor_64(u8 *a, const u8 *b, unsigned int bs)
-{
-	((u32 *)a)[0] ^= ((u32 *)b)[0];
-	((u32 *)a)[1] ^= ((u32 *)b)[1];
-}
-
-static void xor_128(u8 *a, const u8 *b, unsigned int bs)
-{
-	((u32 *)a)[0] ^= ((u32 *)b)[0];
-	((u32 *)a)[1] ^= ((u32 *)b)[1];
-	((u32 *)a)[2] ^= ((u32 *)b)[2];
-	((u32 *)a)[3] ^= ((u32 *)b)[3];
-}
-
 static int crypto_cbc_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_instance *inst = (void *)tfm->__crt_alg;
@@ -245,22 +199,6 @@ static int crypto_cbc_init_tfm(struct crypto_tfm *tfm)
 	struct crypto_cbc_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct crypto_cipher *cipher;
 
-	switch (crypto_tfm_alg_blocksize(tfm)) {
-	case 8:
-		ctx->xor = xor_64;
-		break;
-
-	case 16:
-		ctx->xor = xor_128;
-		break;
-
-	default:
-		if (crypto_tfm_alg_blocksize(tfm) % 4)
-			ctx->xor = xor_byte;
-		else
-			ctx->xor = xor_quad;
-	}
-
 	cipher = crypto_spawn_cipher(spawn);
 	if (IS_ERR(cipher))
 		return PTR_ERR(cipher);
@@ -300,8 +238,9 @@ static struct crypto_instance *crypto_cbc_alloc(struct rtattr **tb)
 	inst->alg.cra_alignmask = alg->cra_alignmask;
 	inst->alg.cra_type = &crypto_blkcipher_type;
 
-	if (!(alg->cra_blocksize % 4))
-		inst->alg.cra_alignmask |= 3;
+	/* We access the data as u32s when xoring. */
+	inst->alg.cra_alignmask |= __alignof__(u32) - 1;
+
 	inst->alg.cra_blkcipher.ivsize = alg->cra_blocksize;
 	inst->alg.cra_blkcipher.min_keysize = alg->cra_cipher.cia_min_keysize;
 	inst->alg.cra_blkcipher.max_keysize = alg->cra_cipher.cia_max_keysize;
