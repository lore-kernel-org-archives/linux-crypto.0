From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/5] [CRYPTO] pcbc: Use crypto_xor
Date: Thu, 22 Nov 2007 16:37:48 +0800
Message-ID: <E1Iv7ZE-0001wX-00@gondolin.me.apana.org.au>
References: <20071122083656.GB7368@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4615 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751162AbXKVIsE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 03:48:04 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1Iv7j6-0008A8-7Q
	for <linux-crypto@vger.kernel.org>; Thu, 22 Nov 2007 19:48:00 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] pcbc: Use crypto_xor

This patch replaces the custom xor in CBC with the generic crypto_xor.

It changes the operations for in-place encryption slightly to avoid
calling crypto_xor with tmpbuf since it is not necessarily aligned.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/pcbc.c |  105 +++++++++++++---------------------------------------------
 1 files changed, 24 insertions(+), 81 deletions(-)

diff --git a/crypto/pcbc.c b/crypto/pcbc.c
index c3ed8a1..fe70477 100644
--- a/crypto/pcbc.c
+++ b/crypto/pcbc.c
@@ -24,7 +24,6 @@
 
 struct crypto_pcbc_ctx {
 	struct crypto_cipher *child;
-	void (*xor)(u8 *dst, const u8 *src, unsigned int bs);
 };
 
 static int crypto_pcbc_setkey(struct crypto_tfm *parent, const u8 *key,
@@ -45,9 +44,7 @@ static int crypto_pcbc_setkey(struct crypto_tfm *parent, const u8 *key,
 
 static int crypto_pcbc_encrypt_segment(struct blkcipher_desc *desc,
 				       struct blkcipher_walk *walk,
-				       struct crypto_cipher *tfm,
-				       void (*xor)(u8 *, const u8 *,
-						   unsigned int))
+				       struct crypto_cipher *tfm)
 {
 	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
 		crypto_cipher_alg(tfm)->cia_encrypt;
@@ -58,10 +55,10 @@ static int crypto_pcbc_encrypt_segment(struct blkcipher_desc *desc,
 	u8 *iv = walk->iv;
 
 	do {
-		xor(iv, src, bsize);
+		crypto_xor(iv, src, bsize);
 		fn(crypto_cipher_tfm(tfm), dst, iv);
 		memcpy(iv, dst, bsize);
-		xor(iv, src, bsize);
+		crypto_xor(iv, src, bsize);
 
 		src += bsize;
 		dst += bsize;
@@ -72,9 +69,7 @@ static int crypto_pcbc_encrypt_segment(struct blkcipher_desc *desc,
 
 static int crypto_pcbc_encrypt_inplace(struct blkcipher_desc *desc,
 				       struct blkcipher_walk *walk,
-				       struct crypto_cipher *tfm,
-				       void (*xor)(u8 *, const u8 *,
-						   unsigned int))
+				       struct crypto_cipher *tfm)
 {
 	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
 		crypto_cipher_alg(tfm)->cia_encrypt;
@@ -86,10 +81,10 @@ static int crypto_pcbc_encrypt_inplace(struct blkcipher_desc *desc,
 
 	do {
 		memcpy(tmpbuf, src, bsize);
-		xor(iv, tmpbuf, bsize);
+		crypto_xor(iv, src, bsize);
 		fn(crypto_cipher_tfm(tfm), src, iv);
-		memcpy(iv, src, bsize);
-		xor(iv, tmpbuf, bsize);
+		memcpy(iv, tmpbuf, bsize);
+		crypto_xor(iv, src, bsize);
 
 		src += bsize;
 	} while ((nbytes -= bsize) >= bsize);
@@ -107,7 +102,6 @@ static int crypto_pcbc_encrypt(struct blkcipher_desc *desc,
 	struct crypto_blkcipher *tfm = desc->tfm;
 	struct crypto_pcbc_ctx *ctx = crypto_blkcipher_ctx(tfm);
 	struct crypto_cipher *child = ctx->child;
-	void (*xor)(u8 *, const u8 *, unsigned int bs) = ctx->xor;
 	int err;
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
@@ -115,11 +109,11 @@ static int crypto_pcbc_encrypt(struct blkcipher_desc *desc,
 
 	while ((nbytes = walk.nbytes)) {
 		if (walk.src.virt.addr == walk.dst.virt.addr)
-			nbytes = crypto_pcbc_encrypt_inplace(desc, &walk, child,
-							     xor);
+			nbytes = crypto_pcbc_encrypt_inplace(desc, &walk,
+							     child);
 		else
-			nbytes = crypto_pcbc_encrypt_segment(desc, &walk, child,
-							     xor);
+			nbytes = crypto_pcbc_encrypt_segment(desc, &walk,
+							     child);
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
 
@@ -128,9 +122,7 @@ static int crypto_pcbc_encrypt(struct blkcipher_desc *desc,
 
 static int crypto_pcbc_decrypt_segment(struct blkcipher_desc *desc,
 				       struct blkcipher_walk *walk,
-				       struct crypto_cipher *tfm,
-				       void (*xor)(u8 *, const u8 *,
-						   unsigned int))
+				       struct crypto_cipher *tfm)
 {
 	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
 		crypto_cipher_alg(tfm)->cia_decrypt;
@@ -142,9 +134,9 @@ static int crypto_pcbc_decrypt_segment(struct blkcipher_desc *desc,
 
 	do {
 		fn(crypto_cipher_tfm(tfm), dst, src);
-		xor(dst, iv, bsize);
+		crypto_xor(dst, iv, bsize);
 		memcpy(iv, src, bsize);
-		xor(iv, dst, bsize);
+		crypto_xor(iv, dst, bsize);
 
 		src += bsize;
 		dst += bsize;
@@ -157,9 +149,7 @@ static int crypto_pcbc_decrypt_segment(struct blkcipher_desc *desc,
 
 static int crypto_pcbc_decrypt_inplace(struct blkcipher_desc *desc,
 				       struct blkcipher_walk *walk,
-				       struct crypto_cipher *tfm,
-				       void (*xor)(u8 *, const u8 *,
-						   unsigned int))
+				       struct crypto_cipher *tfm)
 {
 	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
 		crypto_cipher_alg(tfm)->cia_decrypt;
@@ -172,9 +162,9 @@ static int crypto_pcbc_decrypt_inplace(struct blkcipher_desc *desc,
 	do {
 		memcpy(tmpbuf, src, bsize);
 		fn(crypto_cipher_tfm(tfm), src, src);
-		xor(src, iv, bsize);
+		crypto_xor(src, iv, bsize);
 		memcpy(iv, tmpbuf, bsize);
-		xor(iv, src, bsize);
+		crypto_xor(iv, src, bsize);
 
 		src += bsize;
 	} while ((nbytes -= bsize) >= bsize);
@@ -192,7 +182,6 @@ static int crypto_pcbc_decrypt(struct blkcipher_desc *desc,
 	struct crypto_blkcipher *tfm = desc->tfm;
 	struct crypto_pcbc_ctx *ctx = crypto_blkcipher_ctx(tfm);
 	struct crypto_cipher *child = ctx->child;
-	void (*xor)(u8 *, const u8 *, unsigned int bs) = ctx->xor;
 	int err;
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
@@ -200,48 +189,17 @@ static int crypto_pcbc_decrypt(struct blkcipher_desc *desc,
 
 	while ((nbytes = walk.nbytes)) {
 		if (walk.src.virt.addr == walk.dst.virt.addr)
-			nbytes = crypto_pcbc_decrypt_inplace(desc, &walk, child,
-							     xor);
+			nbytes = crypto_pcbc_decrypt_inplace(desc, &walk,
+							     child);
 		else
-			nbytes = crypto_pcbc_decrypt_segment(desc, &walk, child,
-							     xor);
+			nbytes = crypto_pcbc_decrypt_segment(desc, &walk,
+							     child);
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
 static int crypto_pcbc_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_instance *inst = (void *)tfm->__crt_alg;
@@ -249,22 +207,6 @@ static int crypto_pcbc_init_tfm(struct crypto_tfm *tfm)
 	struct crypto_pcbc_ctx *ctx = crypto_tfm_ctx(tfm);
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
@@ -304,8 +246,9 @@ static struct crypto_instance *crypto_pcbc_alloc(struct rtattr **tb)
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
