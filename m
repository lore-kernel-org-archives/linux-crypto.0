From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/6] [CRYPTO] xcbc: Use new cipher interface
Date: Wed, 24 Jan 2007 21:29:20 +1100
Message-ID: <E1H9fNY-0005nE-00@gondolin.me.apana.org.au>
References: <20070124102736.GA21977@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2906 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751034AbXAXK3Y (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Jan 2007 05:29:24 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1H9fNZ-0005wz-8Q
	for <linux-crypto@vger.kernel.org>; Wed, 24 Jan 2007 21:29:21 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1H9fNY-0005nE-00
	for <linux-crypto@vger.kernel.org>; Wed, 24 Jan 2007 21:29:20 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] xcbc: Use new cipher interface

This patch changes xcbc to use the new cipher encryt_one interface.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/xcbc.c |   30 ++++++++++++++++--------------
 1 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/crypto/xcbc.c b/crypto/xcbc.c
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -48,7 +48,7 @@ static u_int32_t ks[12] = {0x01010101, 0
  * +------------------------
  */
 struct crypto_xcbc_ctx {
-	struct crypto_tfm *child;
+	struct crypto_cipher *child;
 	u8 *odds;
 	u8 *prev;
 	u8 *key;
@@ -76,8 +76,7 @@ static int _crypto_xcbc_digest_setkey(st
 	if ((err = crypto_cipher_setkey(ctx->child, ctx->key, ctx->keylen)))
 	    return err;
 
-	ctx->child->__crt_alg->cra_cipher.cia_encrypt(ctx->child, key1,
-			ctx->consts);
+	crypto_cipher_encrypt_one(ctx->child, key1, ctx->consts);
 
 	return crypto_cipher_setkey(ctx->child, key1, bs);
 }
@@ -87,7 +86,7 @@ static int crypto_xcbc_digest_setkey(str
 {
 	struct crypto_xcbc_ctx *ctx = crypto_hash_ctx_aligned(parent);
 
-	if (keylen != crypto_tfm_alg_blocksize(ctx->child))
+	if (keylen != crypto_cipher_blocksize(ctx->child))
 		return -EINVAL;
 
 	ctx->keylen = keylen;
@@ -115,7 +114,7 @@ static int crypto_xcbc_digest_update2(st
 {
 	struct crypto_hash *parent = pdesc->tfm;
 	struct crypto_xcbc_ctx *ctx = crypto_hash_ctx_aligned(parent);
-	struct crypto_tfm *tfm = ctx->child;
+	struct crypto_cipher *tfm = ctx->child;
 	int bs = crypto_hash_blocksize(parent);
 	unsigned int i = 0;
 
@@ -143,7 +142,7 @@ static int crypto_xcbc_digest_update2(st
 					offset += len;
 
 				crypto_kunmap(p, 0);
-				crypto_yield(tfm->crt_flags);
+				crypto_yield(pdesc->flags);
 				continue;
 			}
 
@@ -153,7 +152,7 @@ static int crypto_xcbc_digest_update2(st
 			p += bs - ctx->len;
 
 			ctx->xor(ctx->prev, ctx->odds, bs);
-			tfm->__crt_alg->cra_cipher.cia_encrypt(tfm, ctx->prev, ctx->prev);
+			crypto_cipher_encrypt_one(tfm, ctx->prev, ctx->prev);
 
 			/* clearing the length */
 			ctx->len = 0;
@@ -161,7 +160,8 @@ static int crypto_xcbc_digest_update2(st
 			/* encrypting the rest of data */
 			while (len > bs) {
 				ctx->xor(ctx->prev, p, bs);
-				tfm->__crt_alg->cra_cipher.cia_encrypt(tfm, ctx->prev, ctx->prev);
+				crypto_cipher_encrypt_one(tfm, ctx->prev,
+							  ctx->prev);
 				p += bs;
 				len -= bs;
 			}
@@ -172,7 +172,7 @@ static int crypto_xcbc_digest_update2(st
 				ctx->len = len;
 			}
 			crypto_kunmap(p, 0);
-			crypto_yield(tfm->crt_flags);
+			crypto_yield(pdesc->flags);
 			slen -= min(slen, ((unsigned int)(PAGE_SIZE)) - offset);
 			offset = 0;
 			pg++;
@@ -197,7 +197,7 @@ static int crypto_xcbc_digest_final(stru
 {
 	struct crypto_hash *parent = pdesc->tfm;
 	struct crypto_xcbc_ctx *ctx = crypto_hash_ctx_aligned(parent);
-	struct crypto_tfm *tfm = ctx->child;
+	struct crypto_cipher *tfm = ctx->child;
 	int bs = crypto_hash_blocksize(parent);
 	int err = 0;
 
@@ -207,13 +207,14 @@ static int crypto_xcbc_digest_final(stru
 		if ((err = crypto_cipher_setkey(tfm, ctx->key, ctx->keylen)) != 0)
 			return err;
 
-		tfm->__crt_alg->cra_cipher.cia_encrypt(tfm, key2, (const u8*)(ctx->consts+bs));
+		crypto_cipher_encrypt_one(tfm, key2,
+					  (u8 *)(ctx->consts + bs));
 
 		ctx->xor(ctx->prev, ctx->odds, bs);
 		ctx->xor(ctx->prev, key2, bs);
 		_crypto_xcbc_digest_setkey(parent, ctx);
 
-		tfm->__crt_alg->cra_cipher.cia_encrypt(tfm, out, ctx->prev);
+		crypto_cipher_encrypt_one(tfm, out, ctx->prev);
 	} else {
 		u8 key3[bs];
 		unsigned int rlen;
@@ -228,14 +229,15 @@ static int crypto_xcbc_digest_final(stru
 		if ((err = crypto_cipher_setkey(tfm, ctx->key, ctx->keylen)) != 0)
 			return err;
 
-		tfm->__crt_alg->cra_cipher.cia_encrypt(tfm, key3, (const u8*)(ctx->consts+bs*2));
+		crypto_cipher_encrypt_one(tfm, key3,
+					  (u8 *)(ctx->consts + bs * 2));
 
 		ctx->xor(ctx->prev, ctx->odds, bs);
 		ctx->xor(ctx->prev, key3, bs);
 
 		_crypto_xcbc_digest_setkey(parent, ctx);
 
-		tfm->__crt_alg->cra_cipher.cia_encrypt(tfm, out, ctx->prev);
+		crypto_cipher_encrypt_one(tfm, out, ctx->prev);
 	}
 
 	return 0;
