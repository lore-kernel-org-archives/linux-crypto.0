Return-Path: <SRS0=8/la=PM=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726041AbfADEUy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jan 2019 23:20:54 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: stable@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 02/16] crypto: cfb - remove bogus memcpy() with src == dest
Date: Thu,  3 Jan 2019 20:16:11 -0800
Message-Id: <20190104041625.3259-3-ebiggers@kernel.org>
In-Reply-To: <20190104041625.3259-1-ebiggers@kernel.org>
References: <20190104041625.3259-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

The memcpy() in crypto_cfb_decrypt_inplace() uses walk->iv as both the
source and destination, which has undefined behavior.  It is unneeded
because walk->iv is already used to hold the previous ciphertext block;
thus, walk->iv is already updated to its final value.  So, remove it.

Also, note that in-place decryption is the only case where the previous
ciphertext block is not directly available.  Therefore, as a related
cleanup I also updated crypto_cfb_encrypt_segment() to directly use the
previous ciphertext block rather than save it into walk->iv.  This makes
it consistent with in-place encryption and out-of-place decryption; now
only in-place decryption is different, because it has to be.

Fixes: a7d85e06ed80 ("crypto: cfb - add support for Cipher FeedBack mode")
Cc: <stable@vger.kernel.org> # v4.17+
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/cfb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/cfb.c b/crypto/cfb.c
index 183e8a9c33128..4abfe32ff8451 100644
--- a/crypto/cfb.c
+++ b/crypto/cfb.c
@@ -77,12 +77,14 @@ static int crypto_cfb_encrypt_segment(struct skcipher_walk *walk,
 	do {
 		crypto_cfb_encrypt_one(tfm, iv, dst);
 		crypto_xor(dst, src, bsize);
-		memcpy(iv, dst, bsize);
+		iv = dst;
 
 		src += bsize;
 		dst += bsize;
 	} while ((nbytes -= bsize) >= bsize);
 
+	memcpy(walk->iv, iv, bsize);
+
 	return nbytes;
 }
 
@@ -162,7 +164,7 @@ static int crypto_cfb_decrypt_inplace(struct skcipher_walk *walk,
 	const unsigned int bsize = crypto_cfb_bsize(tfm);
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
-	u8 *iv = walk->iv;
+	u8 * const iv = walk->iv;
 	u8 tmp[MAX_CIPHER_BLOCKSIZE];
 
 	do {
@@ -172,8 +174,6 @@ static int crypto_cfb_decrypt_inplace(struct skcipher_walk *walk,
 		src += bsize;
 	} while ((nbytes -= bsize) >= bsize);
 
-	memcpy(walk->iv, iv, bsize);
-
 	return nbytes;
 }
 
-- 
2.20.1
