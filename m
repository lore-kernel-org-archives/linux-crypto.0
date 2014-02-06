From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 2/3] crypto: take interleave into account for CBC decryption
Date: Thu,  6 Feb 2014 13:25:03 +0100
Message-ID: <1391689504-28160-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1391689504-28160-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
	jussi.kivilinna@iki.fi, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:38212 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239AbaBFMZG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Feb 2014 07:25:06 -0500
Received: by mail-we0-f179.google.com with SMTP id q58so1224044wes.38
        for <linux-crypto@vger.kernel.org>; Thu, 06 Feb 2014 04:25:05 -0800 (PST)
In-Reply-To: <1391689504-28160-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As CBC decryption can be executed in parallel, take the cipher alg's
preferred interleave into account when decrypting data.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/cbc.c | 109 ++++++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 82 insertions(+), 27 deletions(-)

diff --git a/crypto/cbc.c b/crypto/cbc.c
index 61ac42e1e32b..1a9747fa2a14 100644
--- a/crypto/cbc.c
+++ b/crypto/cbc.c
@@ -113,24 +113,44 @@ static int crypto_cbc_encrypt(struct blkcipher_desc *desc,
 
 static int crypto_cbc_decrypt_segment(struct blkcipher_desc *desc,
 				      struct blkcipher_walk *walk,
-				      struct crypto_cipher *tfm)
+				      struct crypto_cipher *tfm,
+				      int bsize,
+				      int ilsize)
 {
-	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
-		crypto_cipher_alg(tfm)->cia_decrypt;
-	int bsize = crypto_cipher_blocksize(tfm);
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
 	u8 *dst = walk->dst.virt.addr;
 	u8 *iv = walk->iv;
 
-	do {
+	while (nbytes >= ilsize) {
+		void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
+			crypto_cipher_alg(tfm)->cia_dec_interleave;
+
+		fn(crypto_cipher_tfm(tfm), dst, src);
+		if (iv == walk->iv) {
+			crypto_xor(dst, iv, bsize);
+			crypto_xor(dst + bsize, src, ilsize - bsize);
+		} else {
+			crypto_xor(dst, src - bsize, ilsize);
+		}
+		iv = src + ilsize - bsize;
+
+		src += ilsize;
+		dst += ilsize;
+		nbytes -= ilsize;
+	}
+	while (nbytes >= bsize) {
+		void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
+			crypto_cipher_alg(tfm)->cia_decrypt;
+
 		fn(crypto_cipher_tfm(tfm), dst, src);
 		crypto_xor(dst, iv, bsize);
 		iv = src;
 
 		src += bsize;
 		dst += bsize;
-	} while ((nbytes -= bsize) >= bsize);
+		nbytes -= bsize;
+	}
 
 	memcpy(walk->iv, iv, bsize);
 
@@ -139,29 +159,53 @@ static int crypto_cbc_decrypt_segment(struct blkcipher_desc *desc,
 
 static int crypto_cbc_decrypt_inplace(struct blkcipher_desc *desc,
 				      struct blkcipher_walk *walk,
-				      struct crypto_cipher *tfm)
+				      struct crypto_cipher *tfm,
+				      int bsize,
+				      int ilsize)
 {
-	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
-		crypto_cipher_alg(tfm)->cia_decrypt;
-	int bsize = crypto_cipher_blocksize(tfm);
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
-	u8 last_iv[bsize];
 
-	/* Start of the last block. */
-	src += nbytes - (nbytes & (bsize - 1)) - bsize;
-	memcpy(last_iv, src, bsize);
-
-	for (;;) {
-		fn(crypto_cipher_tfm(tfm), src, src);
-		if ((nbytes -= bsize) < bsize)
-			break;
-		crypto_xor(src, src - bsize, bsize);
-		src -= bsize;
+	if (nbytes >= ilsize) {
+		void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
+			crypto_cipher_alg(tfm)->cia_dec_interleave;
+		u8 buf[2][ilsize];
+		u8 *iv = walk->iv;
+		int i;
+
+		for (i = 0; nbytes >= ilsize; nbytes -= ilsize, i = !i) {
+			memcpy(buf[i], src, ilsize);
+			fn(crypto_cipher_tfm(tfm), src, buf[i]);
+			if (iv + bsize == buf[i]) {
+				crypto_xor(src, iv, ilsize);
+			} else {
+				crypto_xor(src, iv, bsize);
+				crypto_xor(src + bsize, buf[i], ilsize - bsize);
+			}
+			iv = buf[i] + ilsize - bsize;
+			src += ilsize;
+		}
+		memcpy(walk->iv, iv, bsize);
+	}
+	if (nbytes >= bsize) {
+		void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
+			crypto_cipher_alg(tfm)->cia_decrypt;
+		u8 last_iv[bsize];
+
+		/* Start of the last block. */
+		src += nbytes - (nbytes & (bsize - 1)) - bsize;
+		memcpy(last_iv, src, bsize);
+
+		for (;;) {
+			fn(crypto_cipher_tfm(tfm), src, src);
+			if ((nbytes -= bsize) < bsize)
+				break;
+			crypto_xor(src, src - bsize, bsize);
+			src -= bsize;
+		}
+		crypto_xor(src, walk->iv, bsize);
+		memcpy(walk->iv, last_iv, bsize);
 	}
-
-	crypto_xor(src, walk->iv, bsize);
-	memcpy(walk->iv, last_iv, bsize);
 
 	return nbytes;
 }
@@ -174,16 +218,27 @@ static int crypto_cbc_decrypt(struct blkcipher_desc *desc,
 	struct crypto_blkcipher *tfm = desc->tfm;
 	struct crypto_cbc_ctx *ctx = crypto_blkcipher_ctx(tfm);
 	struct crypto_cipher *child = ctx->child;
+	unsigned int interleave = crypto_cipher_alg(child)->cia_interleave;
+	int bsize = crypto_cipher_blocksize(child);
+	int ilsize = INT_MAX;
 	int err;
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
-	err = blkcipher_walk_virt(desc, &walk);
+
+	if (interleave > 1) {
+		ilsize = interleave * bsize;
+		err = blkcipher_walk_virt_block(desc, &walk, ilsize);
+	} else {
+		err = blkcipher_walk_virt(desc, &walk);
+	}
 
 	while ((nbytes = walk.nbytes)) {
 		if (walk.src.virt.addr == walk.dst.virt.addr)
-			nbytes = crypto_cbc_decrypt_inplace(desc, &walk, child);
+			nbytes = crypto_cbc_decrypt_inplace(desc, &walk, child,
+							    bsize, ilsize);
 		else
-			nbytes = crypto_cbc_decrypt_segment(desc, &walk, child);
+			nbytes = crypto_cbc_decrypt_segment(desc, &walk, child,
+							    bsize, ilsize);
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
 
-- 
1.8.3.2
