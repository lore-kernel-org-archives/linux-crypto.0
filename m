From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/6] crypto: xcbc - Use crypto_xor
Date: Wed, 22 Jul 2009 14:40:04 +0800
Message-ID: <E1MTVUi-0007jZ-8s@gondolin.me.apana.org.au>
References: <20090722063844.GA28998@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:51381 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752734AbZGVGkF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jul 2009 02:40:05 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MTVUi-0005yl-KJ
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2009 16:40:04 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: xcbc - Use crypto_xor

This patch replaces the local xor function with the generic
crypto_xor function.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/xcbc.c |   22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/crypto/xcbc.c b/crypto/xcbc.c
index 3b991bf..9d502e6 100644
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -47,19 +47,10 @@ struct crypto_xcbc_ctx {
 	u8 *prev;
 	u8 *key;
 	u8 *consts;
-	void (*xor)(u8 *a, const u8 *b, unsigned int bs);
 	unsigned int keylen;
 	unsigned int len;
 };
 
-static void xor_128(u8 *a, const u8 *b, unsigned int bs)
-{
-	((u32 *)a)[0] ^= ((u32 *)b)[0];
-	((u32 *)a)[1] ^= ((u32 *)b)[1];
-	((u32 *)a)[2] ^= ((u32 *)b)[2];
-	((u32 *)a)[3] ^= ((u32 *)b)[3];
-}
-
 static int _crypto_xcbc_digest_setkey(struct crypto_shash *parent,
 				      struct crypto_xcbc_ctx *ctx)
 {
@@ -122,7 +113,7 @@ static int crypto_xcbc_digest_update(struct shash_desc *pdesc, const u8 *p,
 	len -= bs - ctx->len;
 	p += bs - ctx->len;
 
-	ctx->xor(ctx->prev, ctx->odds, bs);
+	crypto_xor(ctx->prev, ctx->odds, bs);
 	crypto_cipher_encrypt_one(tfm, ctx->prev, ctx->prev);
 
 	/* clearing the length */
@@ -130,7 +121,7 @@ static int crypto_xcbc_digest_update(struct shash_desc *pdesc, const u8 *p,
 
 	/* encrypting the rest of data */
 	while (len > bs) {
-		ctx->xor(ctx->prev, p, bs);
+		crypto_xor(ctx->prev, p, bs);
 		crypto_cipher_encrypt_one(tfm, ctx->prev, ctx->prev);
 		p += bs;
 		len -= bs;
@@ -162,8 +153,8 @@ static int crypto_xcbc_digest_final(struct shash_desc *pdesc, u8 *out)
 		crypto_cipher_encrypt_one(tfm, key2,
 					  (u8 *)(ctx->consts + bs));
 
-		ctx->xor(ctx->prev, ctx->odds, bs);
-		ctx->xor(ctx->prev, key2, bs);
+		crypto_xor(ctx->prev, ctx->odds, bs);
+		crypto_xor(ctx->prev, key2, bs);
 		_crypto_xcbc_digest_setkey(parent, ctx);
 
 		crypto_cipher_encrypt_one(tfm, out, ctx->prev);
@@ -184,8 +175,8 @@ static int crypto_xcbc_digest_final(struct shash_desc *pdesc, u8 *out)
 		crypto_cipher_encrypt_one(tfm, key3,
 					  (u8 *)(ctx->consts + bs * 2));
 
-		ctx->xor(ctx->prev, ctx->odds, bs);
-		ctx->xor(ctx->prev, key3, bs);
+		crypto_xor(ctx->prev, ctx->odds, bs);
+		crypto_xor(ctx->prev, key3, bs);
 
 		_crypto_xcbc_digest_setkey(parent, ctx);
 
@@ -209,7 +200,6 @@ static int xcbc_init_tfm(struct crypto_tfm *tfm)
 
 	switch(bs) {
 	case 16:
-		ctx->xor = xor_128;
 		break;
 	default:
 		return -EINVAL;
