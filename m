From: Sebastian Siewior <sebastian@breakpoint.cc>
Subject: [PATCH] [crypto] blockmode, use cipher ret val
Date: Sat, 19 Jan 2008 01:02:15 +0100
Message-ID: <1200700935-3844-6-git-send-email-sebastian@breakpoint.cc>
References: <1200700935-3844-1-git-send-email-sebastian@breakpoint.cc>
Cc: linux-crypto@ml.breakpoint.cc,
	Sebastian Siewior <sebastian@breakpoint.cc>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:34803 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752172AbYASId4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Jan 2008 03:33:56 -0500
Received: id: bigeasy by Chamillionaire.breakpoint.cc with local
	(easymta 1.00 BETA 1)
	id 1JG99H-0002dQ-4G
	for linux-crypto@vger.kernel.org; Sat, 19 Jan 2008 09:33:55 +0100
In-Reply-To: <1200700935-3844-1-git-send-email-sebastian@breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 crypto/cbc.c |   22 +++++++++++++---------
 crypto/ecb.c |    7 ++++---
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/crypto/cbc.c b/crypto/cbc.c
index a525dcc..15c8095 100644
--- a/crypto/cbc.c
+++ b/crypto/cbc.c
@@ -50,17 +50,18 @@ static int crypto_cbc_encrypt_segment(struct blkcipher_desc *desc,
 	u8 *src = walk->src.virt.addr;
 	u8 *dst = walk->dst.virt.addr;
 	u8 *iv = walk->iv;
+	int ret;
 
 	do {
 		crypto_xor(iv, src, bsize);
-		fn(crypto_cipher_tfm(tfm), dst, iv);
+		ret = fn(crypto_cipher_tfm(tfm), dst, iv);
 		memcpy(iv, dst, bsize);
 
 		src += bsize;
 		dst += bsize;
-	} while ((nbytes -= bsize) >= bsize);
+	} while (!ret && (nbytes -= bsize) >= bsize);
 
-	return nbytes;
+	return nbytes ? nbytes : ret;
 }
 
 static int crypto_cbc_encrypt_inplace(struct blkcipher_desc *desc,
@@ -73,14 +74,15 @@ static int crypto_cbc_encrypt_inplace(struct blkcipher_desc *desc,
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
 	u8 *iv = walk->iv;
+	int ret;
 
 	do {
 		crypto_xor(src, iv, bsize);
-		fn(crypto_cipher_tfm(tfm), src, src);
+		ret = fn(crypto_cipher_tfm(tfm), src, src);
 		iv = src;
 
 		src += bsize;
-	} while ((nbytes -= bsize) >= bsize);
+	} while (!ret && (nbytes -= bsize) >= bsize);
 
 	memcpy(walk->iv, iv, bsize);
 
@@ -122,15 +124,16 @@ static int crypto_cbc_decrypt_segment(struct blkcipher_desc *desc,
 	u8 *src = walk->src.virt.addr;
 	u8 *dst = walk->dst.virt.addr;
 	u8 *iv = walk->iv;
+	int ret;
 
 	do {
-		fn(crypto_cipher_tfm(tfm), dst, src);
+		ret = fn(crypto_cipher_tfm(tfm), dst, src);
 		crypto_xor(dst, iv, bsize);
 		iv = src;
 
 		src += bsize;
 		dst += bsize;
-	} while ((nbytes -= bsize) >= bsize);
+	} while (!ret && (nbytes -= bsize) >= bsize);
 
 	memcpy(walk->iv, iv, bsize);
 
@@ -147,14 +150,15 @@ static int crypto_cbc_decrypt_inplace(struct blkcipher_desc *desc,
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
 	u8 last_iv[bsize];
+	int ret;
 
 	/* Start of the last block. */
 	src += nbytes - (nbytes & (bsize - 1)) - bsize;
 	memcpy(last_iv, src, bsize);
 
 	for (;;) {
-		fn(crypto_cipher_tfm(tfm), src, src);
-		if ((nbytes -= bsize) < bsize)
+		ret = fn(crypto_cipher_tfm(tfm), src, src);
+		if (ret || (nbytes -= bsize) < bsize)
 			break;
 		crypto_xor(src, src - bsize, bsize);
 		src -= bsize;
diff --git a/crypto/ecb.c b/crypto/ecb.c
index 1edb94f..04a5083 100644
--- a/crypto/ecb.c
+++ b/crypto/ecb.c
@@ -46,6 +46,7 @@ static int crypto_ecb_crypt(struct blkcipher_desc *desc,
 	int bsize = crypto_cipher_blocksize(tfm);
 	unsigned int nbytes;
 	int err;
+	int ret = 0;
 
 	err = blkcipher_walk_virt(desc, walk);
 
@@ -54,16 +55,16 @@ static int crypto_ecb_crypt(struct blkcipher_desc *desc,
 		u8 *wdst = walk->dst.virt.addr;
 
 		do {
-			fn(crypto_cipher_tfm(tfm), wdst, wsrc);
+			ret = fn(crypto_cipher_tfm(tfm), wdst, wsrc);
 	
 			wsrc += bsize;
 			wdst += bsize;
-		} while ((nbytes -= bsize) >= bsize);
+		} while ((nbytes -= bsize) >= bsize && !ret);
 
 		err = blkcipher_walk_done(desc, walk, nbytes);
 	}
 
-	return err;
+	return err ? err : ret;
 }
 
 static int crypto_ecb_encrypt(struct blkcipher_desc *desc,
-- 
1.5.3.6
