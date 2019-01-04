Return-Path: <SRS0=8/la=PM=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727701AbfADEUz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jan 2019 23:20:55 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: stable@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [PATCH 04/16] crypto: pcbc - remove bogus memcpy()s with src == dest
Date: Thu,  3 Jan 2019 20:16:13 -0800
Message-Id: <20190104041625.3259-5-ebiggers@kernel.org>
In-Reply-To: <20190104041625.3259-1-ebiggers@kernel.org>
References: <20190104041625.3259-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

The memcpy()s in the PCBC implementation use walk->iv as both the source
and destination, which has undefined behavior.  These memcpy()'s are
actually unneeded, because walk->iv is already used to hold the previous
plaintext block XOR'd with the previous ciphertext block.  Thus,
walk->iv is already updated to its final value.

So remove the broken and unnecessary memcpy()s.

Fixes: 91652be5d1b9 ("[CRYPTO] pcbc: Add Propagated CBC template")
Cc: <stable@vger.kernel.org> # v2.6.21+
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/pcbc.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/crypto/pcbc.c b/crypto/pcbc.c
index 8aa10144407c0..1b182dfedc948 100644
--- a/crypto/pcbc.c
+++ b/crypto/pcbc.c
@@ -51,7 +51,7 @@ static int crypto_pcbc_encrypt_segment(struct skcipher_request *req,
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
 	u8 *dst = walk->dst.virt.addr;
-	u8 *iv = walk->iv;
+	u8 * const iv = walk->iv;
 
 	do {
 		crypto_xor(iv, src, bsize);
@@ -72,7 +72,7 @@ static int crypto_pcbc_encrypt_inplace(struct skcipher_request *req,
 	int bsize = crypto_cipher_blocksize(tfm);
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
-	u8 *iv = walk->iv;
+	u8 * const iv = walk->iv;
 	u8 tmpbuf[MAX_CIPHER_BLOCKSIZE];
 
 	do {
@@ -84,8 +84,6 @@ static int crypto_pcbc_encrypt_inplace(struct skcipher_request *req,
 		src += bsize;
 	} while ((nbytes -= bsize) >= bsize);
 
-	memcpy(walk->iv, iv, bsize);
-
 	return nbytes;
 }
 
@@ -121,7 +119,7 @@ static int crypto_pcbc_decrypt_segment(struct skcipher_request *req,
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
 	u8 *dst = walk->dst.virt.addr;
-	u8 *iv = walk->iv;
+	u8 * const iv = walk->iv;
 
 	do {
 		crypto_cipher_decrypt_one(tfm, dst, src);
@@ -132,8 +130,6 @@ static int crypto_pcbc_decrypt_segment(struct skcipher_request *req,
 		dst += bsize;
 	} while ((nbytes -= bsize) >= bsize);
 
-	memcpy(walk->iv, iv, bsize);
-
 	return nbytes;
 }
 
@@ -144,7 +140,7 @@ static int crypto_pcbc_decrypt_inplace(struct skcipher_request *req,
 	int bsize = crypto_cipher_blocksize(tfm);
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
-	u8 *iv = walk->iv;
+	u8 * const iv = walk->iv;
 	u8 tmpbuf[MAX_CIPHER_BLOCKSIZE] __aligned(__alignof__(u32));
 
 	do {
@@ -156,8 +152,6 @@ static int crypto_pcbc_decrypt_inplace(struct skcipher_request *req,
 		src += bsize;
 	} while ((nbytes -= bsize) >= bsize);
 
-	memcpy(walk->iv, iv, bsize);
-
 	return nbytes;
 }
 
-- 
2.20.1
