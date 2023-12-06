Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A6521A0A
	for <linux-crypto@vger.kernel.org>; Tue, 13 Feb 2024 09:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707815809; cv=none; b=olmMl3MzXNvCO9bB63HfEdWFSlARwHaF3aeGUSh/MDz1tfdbRK5nrkc+v4qXlPsiTQvu1UycJfdCA2RVHSF0qnlwqj4f2PDAH4VTJS0R2wxJfyhiNKu2sFumH9nmwaJtaZNfMGjsJSEkSYqMPG3B1sI8V0FZbfc0jU2vwnF9/pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707815809; c=relaxed/simple;
	bh=hbUfuR0+S/W53X2uSG8DQEshHvtPzgNdw+LXavD+eUQ=;
	h=Message-Id:In-Reply-To:References:From:Date:Subject:To; b=pAxnl3SkwBQzHkI48fbVoToCOypbC86x/CK8rlt/Ma/7ZOw2wUOF4LpaaPrbdm/j/oux8c1KbToBpXtOEqzl/8TiejwvB1GdJwWr/MBiA17gf8fiTQg9/7xvh9cXzHziE5Bi/1yWpKCADLKFUI6J2vTsC0mg3Oljmemqd6CTSyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rZouA-00D1qt-RY; Tue, 13 Feb 2024 17:16:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 Feb 2024 17:16:56 +0800
Message-Id: <1585df67b3f356eba2c23ac9f36c7181432d191e.1707815065.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1707815065.git.herbert@gondor.apana.org.au>
References: <cover.1707815065.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Wed, 6 Dec 2023 13:49:32 +0800
Subject: [PATCH 09/15] crypto: chacha-generic - Convert from skcipher to
 lskcipher
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Replace skcipher implementation with lskcipher.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/chacha_generic.c          | 161 ++++++++++++++++---------------
 include/crypto/internal/chacha.h |  22 ++++-
 2 files changed, 100 insertions(+), 83 deletions(-)

diff --git a/crypto/chacha_generic.c b/crypto/chacha_generic.c
index 8beea79ab117..6500fa570ddc 100644
--- a/crypto/chacha_generic.c
+++ b/crypto/chacha_generic.c
@@ -7,122 +7,127 @@
  */
 
 #include <asm/unaligned.h>
-#include <crypto/algapi.h>
 #include <crypto/internal/chacha.h>
-#include <crypto/internal/skcipher.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/string.h>
 
-static int chacha_stream_xor(struct skcipher_request *req,
-			     const struct chacha_ctx *ctx, const u8 *iv)
+static int chacha_stream_xor(const struct chacha_ctx *ctx, const u8 *src,
+			     u8 *dst, unsigned nbytes, u8 *siv, u32 flags)
 {
-	struct skcipher_walk walk;
-	u32 state[16];
-	int err;
+	u32 *state = (u32 *)(siv + CHACHA_IV_SIZE);
+	unsigned len = nbytes;
 
-	err = skcipher_walk_virt(&walk, req, false);
+	if (!(flags & CRYPTO_LSKCIPHER_FLAG_CONT))
+		chacha_init_generic(state, ctx->key, siv);
 
-	chacha_init_generic(state, ctx->key, iv);
+	if (!(flags & CRYPTO_LSKCIPHER_FLAG_FINAL))
+		len = round_down(len, CHACHA_BLOCK_SIZE);
 
-	while (walk.nbytes > 0) {
-		unsigned int nbytes = walk.nbytes;
+	chacha_crypt_generic(state, dst, src, len, ctx->nrounds);
 
-		if (nbytes < walk.total)
-			nbytes = round_down(nbytes, CHACHA_BLOCK_SIZE);
-
-		chacha_crypt_generic(state, walk.dst.virt.addr,
-				     walk.src.virt.addr, nbytes, ctx->nrounds);
-		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
-	}
-
-	return err;
+	return nbytes - len;
 }
 
-static int crypto_chacha_crypt(struct skcipher_request *req)
+static int crypto_chacha_crypt(struct crypto_lskcipher *tfm, const u8 *src,
+			       u8 *dst, unsigned nbytes, u8 *siv, u32 flags)
 {
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
+	const struct chacha_ctx *ctx = crypto_lskcipher_ctx(tfm);
 
-	return chacha_stream_xor(req, ctx, req->iv);
+	return chacha_stream_xor(ctx, src, dst, nbytes, siv, flags);
 }
 
-static int crypto_xchacha_crypt(struct skcipher_request *req)
+static int crypto_xchacha_crypt(struct crypto_lskcipher *tfm, const u8 *src,
+				u8 *dst, unsigned nbytes, u8 *siv, u32 flags)
 {
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct chacha_ctx *ctx = crypto_lskcipher_ctx(tfm);
 	struct chacha_ctx subctx;
-	u32 state[16];
-	u8 real_iv[16];
+	u8 *real_iv;
+	u32 *state;
 
-	/* Compute the subkey given the original key and first 128 nonce bits */
-	chacha_init_generic(state, ctx->key, req->iv);
-	hchacha_block_generic(state, subctx.key, ctx->nrounds);
+	real_iv = siv + XCHACHA_IV_SIZE;
+	state = (u32 *)(real_iv + CHACHA_IV_SIZE);
 	subctx.nrounds = ctx->nrounds;
 
-	/* Build the real IV */
-	memcpy(&real_iv[0], req->iv + 24, 8); /* stream position */
-	memcpy(&real_iv[8], req->iv + 16, 8); /* remaining 64 nonce bits */
+	if (flags & CRYPTO_LSKCIPHER_FLAG_CONT)
+		goto out;
 
+	/* Compute the subkey given the original key and first 128 nonce bits */
+	chacha_init_generic(state, ctx->key, siv);
+	hchacha_block_generic(state, subctx.key, ctx->nrounds);
+
+	/* Build the real IV */
+	memcpy(&real_iv[0], siv + 24, 8); /* stream position */
+	memcpy(&real_iv[8], siv + 16, 8); /* remaining 64 nonce bits */
+
+out:
 	/* Generate the stream and XOR it with the data */
-	return chacha_stream_xor(req, &subctx, real_iv);
+	return chacha_stream_xor(&subctx, src, dst, nbytes, real_iv, flags);
 }
 
-static struct skcipher_alg algs[] = {
+static struct lskcipher_alg algs[] = {
 	{
-		.base.cra_name		= "chacha20",
-		.base.cra_driver_name	= "chacha20-generic",
-		.base.cra_priority	= 100,
-		.base.cra_blocksize	= 1,
-		.base.cra_ctxsize	= sizeof(struct chacha_ctx),
-		.base.cra_module	= THIS_MODULE,
+		.co.base.cra_name		= "chacha20",
+		.co.base.cra_driver_name	= "chacha20-generic",
+		.co.base.cra_priority		= 100,
+		.co.base.cra_blocksize		= 1,
+		.co.base.cra_ctxsize		= sizeof(struct chacha_ctx),
+		.co.base.cra_alignmask		= __alignof__(u32) - 1,
+		.co.base.cra_module		= THIS_MODULE,
 
-		.min_keysize		= CHACHA_KEY_SIZE,
-		.max_keysize		= CHACHA_KEY_SIZE,
-		.ivsize			= CHACHA_IV_SIZE,
-		.chunksize		= CHACHA_BLOCK_SIZE,
-		.setkey			= chacha20_setkey,
-		.encrypt		= crypto_chacha_crypt,
-		.decrypt		= crypto_chacha_crypt,
+		.co.min_keysize			= CHACHA_KEY_SIZE,
+		.co.max_keysize			= CHACHA_KEY_SIZE,
+		.co.ivsize			= CHACHA_IV_SIZE,
+		.co.chunksize			= CHACHA_BLOCK_SIZE,
+		.co.statesize			= 64,
+		.setkey				= chacha20_lskcipher_setkey,
+		.encrypt			= crypto_chacha_crypt,
+		.decrypt			= crypto_chacha_crypt,
 	}, {
-		.base.cra_name		= "xchacha20",
-		.base.cra_driver_name	= "xchacha20-generic",
-		.base.cra_priority	= 100,
-		.base.cra_blocksize	= 1,
-		.base.cra_ctxsize	= sizeof(struct chacha_ctx),
-		.base.cra_module	= THIS_MODULE,
+		.co.base.cra_name		= "xchacha20",
+		.co.base.cra_driver_name	= "xchacha20-generic",
+		.co.base.cra_priority		= 100,
+		.co.base.cra_blocksize		= 1,
+		.co.base.cra_ctxsize		= sizeof(struct chacha_ctx),
+		.co.base.cra_alignmask		= __alignof__(u32) - 1,
+		.co.base.cra_module		= THIS_MODULE,
 
-		.min_keysize		= CHACHA_KEY_SIZE,
-		.max_keysize		= CHACHA_KEY_SIZE,
-		.ivsize			= XCHACHA_IV_SIZE,
-		.chunksize		= CHACHA_BLOCK_SIZE,
-		.setkey			= chacha20_setkey,
-		.encrypt		= crypto_xchacha_crypt,
-		.decrypt		= crypto_xchacha_crypt,
+		.co.min_keysize			= CHACHA_KEY_SIZE,
+		.co.max_keysize			= CHACHA_KEY_SIZE,
+		.co.ivsize			= XCHACHA_IV_SIZE,
+		.co.chunksize			= CHACHA_BLOCK_SIZE,
+		.co.statesize			= 80,
+		.setkey				= chacha20_lskcipher_setkey,
+		.encrypt			= crypto_xchacha_crypt,
+		.decrypt			= crypto_xchacha_crypt,
 	}, {
-		.base.cra_name		= "xchacha12",
-		.base.cra_driver_name	= "xchacha12-generic",
-		.base.cra_priority	= 100,
-		.base.cra_blocksize	= 1,
-		.base.cra_ctxsize	= sizeof(struct chacha_ctx),
-		.base.cra_module	= THIS_MODULE,
+		.co.base.cra_name		= "xchacha12",
+		.co.base.cra_driver_name	= "xchacha12-generic",
+		.co.base.cra_priority		= 100,
+		.co.base.cra_blocksize		= 1,
+		.co.base.cra_ctxsize		= sizeof(struct chacha_ctx),
+		.co.base.cra_alignmask		= __alignof__(u32) - 1,
+		.co.base.cra_module		= THIS_MODULE,
 
-		.min_keysize		= CHACHA_KEY_SIZE,
-		.max_keysize		= CHACHA_KEY_SIZE,
-		.ivsize			= XCHACHA_IV_SIZE,
-		.chunksize		= CHACHA_BLOCK_SIZE,
-		.setkey			= chacha12_setkey,
-		.encrypt		= crypto_xchacha_crypt,
-		.decrypt		= crypto_xchacha_crypt,
+		.co.min_keysize			= CHACHA_KEY_SIZE,
+		.co.max_keysize			= CHACHA_KEY_SIZE,
+		.co.ivsize			= XCHACHA_IV_SIZE,
+		.co.chunksize			= CHACHA_BLOCK_SIZE,
+		.co.statesize			= 80,
+		.setkey				= chacha12_lskcipher_setkey,
+		.encrypt			= crypto_xchacha_crypt,
+		.decrypt			= crypto_xchacha_crypt,
 	}
 };
 
 static int __init chacha_generic_mod_init(void)
 {
-	return crypto_register_skciphers(algs, ARRAY_SIZE(algs));
+	return crypto_register_lskciphers(algs, ARRAY_SIZE(algs));
 }
 
 static void __exit chacha_generic_mod_fini(void)
 {
-	crypto_unregister_skciphers(algs, ARRAY_SIZE(algs));
+	crypto_unregister_lskciphers(algs, ARRAY_SIZE(algs));
 }
 
 subsys_initcall(chacha_generic_mod_init);
diff --git a/include/crypto/internal/chacha.h b/include/crypto/internal/chacha.h
index b085dc1ac151..568c7c7f042f 100644
--- a/include/crypto/internal/chacha.h
+++ b/include/crypto/internal/chacha.h
@@ -5,17 +5,15 @@
 
 #include <crypto/chacha.h>
 #include <crypto/internal/skcipher.h>
-#include <linux/crypto.h>
 
 struct chacha_ctx {
 	u32 key[8];
 	int nrounds;
 };
 
-static inline int chacha_setkey(struct crypto_skcipher *tfm, const u8 *key,
+static inline int chacha_setkey(struct chacha_ctx *ctx, const u8 *key,
 				unsigned int keysize, int nrounds)
 {
-	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
 	int i;
 
 	if (keysize != CHACHA_KEY_SIZE)
@@ -31,13 +29,27 @@ static inline int chacha_setkey(struct crypto_skcipher *tfm, const u8 *key,
 static inline int chacha20_setkey(struct crypto_skcipher *tfm, const u8 *key,
 				  unsigned int keysize)
 {
-	return chacha_setkey(tfm, key, keysize, 20);
+	return chacha_setkey(crypto_skcipher_ctx(tfm), key, keysize, 20);
+}
+
+static inline int chacha20_lskcipher_setkey(struct crypto_lskcipher *tfm,
+					    const u8 *key,
+					    unsigned int keysize)
+{
+	return chacha_setkey(crypto_lskcipher_ctx(tfm), key, keysize, 20);
 }
 
 static inline int chacha12_setkey(struct crypto_skcipher *tfm, const u8 *key,
 				  unsigned int keysize)
 {
-	return chacha_setkey(tfm, key, keysize, 12);
+	return chacha_setkey(crypto_skcipher_ctx(tfm), key, keysize, 12);
+}
+
+static inline int chacha12_lskcipher_setkey(struct crypto_lskcipher *tfm,
+					    const u8 *key,
+					    unsigned int keysize)
+{
+	return chacha_setkey(crypto_lskcipher_ctx(tfm), key, keysize, 12);
 }
 
 #endif /* _CRYPTO_CHACHA_H */
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

