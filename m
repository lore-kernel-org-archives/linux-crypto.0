From: Eric Biggers <ebiggers3@gmail.com>
Subject: [RFC PATCH 4/9] crypto: poly1305 - remove ->setkey() method
Date: Wed,  3 Jan 2018 11:16:25 -0800
Message-ID: <20180103191630.79917-5-ebiggers3@gmail.com>
References: <20180103191630.79917-1-ebiggers3@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:36155 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750989AbeACTS3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jan 2018 14:18:29 -0500
Received: by mail-io0-f194.google.com with SMTP id i143so3166336ioa.3
        for <linux-crypto@vger.kernel.org>; Wed, 03 Jan 2018 11:18:28 -0800 (PST)
In-Reply-To: <20180103191630.79917-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Since Poly1305 requires a nonce per invocation, the Linux kernel
implementations of Poly1305 don't use the crypto API's keying mechanism
and instead expect the key and nonce as the first 32 bytes of the data.
But ->setkey() is still defined as a stub returning an error code.  This
prevents Poly1305 from being used through AF_ALG and will also break it
completely once we start enforcing that all crypto API users (not just
AF_ALG) call ->setkey() if present.

Fix it by removing crypto_poly1305_setkey(), leaving ->setkey as NULL.

Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/poly1305_glue.c |  1 -
 crypto/poly1305_generic.c       | 17 +++++------------
 include/crypto/poly1305.h       |  2 --
 3 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
index e32142bc071d..28c372003e44 100644
--- a/arch/x86/crypto/poly1305_glue.c
+++ b/arch/x86/crypto/poly1305_glue.c
@@ -164,7 +164,6 @@ static struct shash_alg alg = {
 	.init		= poly1305_simd_init,
 	.update		= poly1305_simd_update,
 	.final		= crypto_poly1305_final,
-	.setkey		= crypto_poly1305_setkey,
 	.descsize	= sizeof(struct poly1305_simd_desc_ctx),
 	.base		= {
 		.cra_name		= "poly1305",
diff --git a/crypto/poly1305_generic.c b/crypto/poly1305_generic.c
index b1c2d57dc734..ba39eb308c79 100644
--- a/crypto/poly1305_generic.c
+++ b/crypto/poly1305_generic.c
@@ -47,17 +47,6 @@ int crypto_poly1305_init(struct shash_desc *desc)
 }
 EXPORT_SYMBOL_GPL(crypto_poly1305_init);
 
-int crypto_poly1305_setkey(struct crypto_shash *tfm,
-			   const u8 *key, unsigned int keylen)
-{
-	/* Poly1305 requires a unique key for each tag, which implies that
-	 * we can't set it on the tfm that gets accessed by multiple users
-	 * simultaneously. Instead we expect the key as the first 32 bytes in
-	 * the update() call. */
-	return -ENOTSUPP;
-}
-EXPORT_SYMBOL_GPL(crypto_poly1305_setkey);
-
 static void poly1305_setrkey(struct poly1305_desc_ctx *dctx, const u8 *key)
 {
 	/* r &= 0xffffffc0ffffffc0ffffffc0fffffff */
@@ -76,6 +65,11 @@ static void poly1305_setskey(struct poly1305_desc_ctx *dctx, const u8 *key)
 	dctx->s[3] = get_unaligned_le32(key + 12);
 }
 
+/*
+ * Poly1305 requires a unique key for each tag, which implies that we can't set
+ * it on the tfm that gets accessed by multiple users simultaneously. Instead we
+ * expect the key as the first 32 bytes in the update() call.
+ */
 unsigned int crypto_poly1305_setdesckey(struct poly1305_desc_ctx *dctx,
 					const u8 *src, unsigned int srclen)
 {
@@ -281,7 +275,6 @@ static struct shash_alg poly1305_alg = {
 	.init		= crypto_poly1305_init,
 	.update		= crypto_poly1305_update,
 	.final		= crypto_poly1305_final,
-	.setkey		= crypto_poly1305_setkey,
 	.descsize	= sizeof(struct poly1305_desc_ctx),
 	.base		= {
 		.cra_name		= "poly1305",
diff --git a/include/crypto/poly1305.h b/include/crypto/poly1305.h
index c65567d01e8e..f718a19da82f 100644
--- a/include/crypto/poly1305.h
+++ b/include/crypto/poly1305.h
@@ -31,8 +31,6 @@ struct poly1305_desc_ctx {
 };
 
 int crypto_poly1305_init(struct shash_desc *desc);
-int crypto_poly1305_setkey(struct crypto_shash *tfm,
-			   const u8 *key, unsigned int keylen);
 unsigned int crypto_poly1305_setdesckey(struct poly1305_desc_ctx *dctx,
 					const u8 *src, unsigned int srclen);
 int crypto_poly1305_update(struct shash_desc *desc,
-- 
2.15.1.620.gb9897f4670-goog
