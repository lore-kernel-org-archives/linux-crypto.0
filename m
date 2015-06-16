From: Martin Willi <martin@strongswan.org>
Subject: [PATCH] crypto: poly1305 - Pass key as first two message blocks to each desc_ctx
Date: Tue, 16 Jun 2015 11:34:16 +0200
Message-ID: <1434447256-6780-1-git-send-email-martin@strongswan.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from revosec.ch ([5.148.177.19]:42223 "EHLO revosec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934202AbbFPJet (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Jun 2015 05:34:49 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The Poly1305 authenticator requires a unique key for each generated tag. This
implies that we can't set the key per tfm, as multiple users set individual
keys. Instead we pass a desc specific key as the first two blocks of the
message to authenticate in update().

Signed-off-by: Martin Willi <martin@strongswan.org>
---
 crypto/chacha20poly1305.c | 54 +++++++++++++++-----------
 crypto/poly1305_generic.c | 97 ++++++++++++++++++++++++++++------------------
 crypto/testmgr.h          | 99 +++++++++++++++++++++--------------------------
 3 files changed, 134 insertions(+), 116 deletions(-)

diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index 05fbc59..7b46ed7 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -54,14 +54,14 @@ struct poly_req {
 };
 
 struct chacha_req {
-	/* the key we generate for Poly1305 using Chacha20 */
-	u8 key[POLY1305_KEY_SIZE];
 	u8 iv[CHACHA20_IV_SIZE];
 	struct scatterlist src[1];
 	struct ablkcipher_request req; /* must be last member */
 };
 
 struct chachapoly_req_ctx {
+	/* the key we generate for Poly1305 using Chacha20 */
+	u8 key[POLY1305_KEY_SIZE];
 	/* calculated Poly1305 tag */
 	u8 tag[POLY1305_DIGEST_SIZE];
 	/* length of data to en/decrypt, without ICV */
@@ -294,53 +294,59 @@ static int poly_ad(struct aead_request *req)
 	return poly_adpad(req);
 }
 
-static void poly_init_done(struct crypto_async_request *areq, int err)
+static void poly_setkey_done(struct crypto_async_request *areq, int err)
 {
 	async_done_continue(areq->data, err, poly_ad);
 }
 
-static int poly_init(struct aead_request *req)
+static int poly_setkey(struct aead_request *req)
 {
 	struct chachapoly_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
 	struct poly_req *preq = &rctx->u.poly;
 	int err;
 
+	sg_init_table(preq->src, 1);
+	sg_set_buf(preq->src, rctx->key, sizeof(rctx->key));
+
 	ahash_request_set_callback(&preq->req, aead_request_flags(req),
-				   poly_init_done, req);
+				   poly_setkey_done, req);
 	ahash_request_set_tfm(&preq->req, ctx->poly);
+	ahash_request_set_crypt(&preq->req, preq->src, NULL, sizeof(rctx->key));
 
-	err = crypto_ahash_init(&preq->req);
+	err = crypto_ahash_update(&preq->req);
 	if (err)
 		return err;
 
 	return poly_ad(req);
 }
 
-static int poly_genkey_continue(struct aead_request *req)
+static void poly_init_done(struct crypto_async_request *areq, int err)
 {
-	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct chachapoly_ctx *ctx = crypto_aead_ctx(aead);
+	async_done_continue(areq->data, err, poly_setkey);
+}
+
+static int poly_init(struct aead_request *req)
+{
+	struct chachapoly_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
-	struct chacha_req *creq = &rctx->u.chacha;
+	struct poly_req *preq = &rctx->u.poly;
 	int err;
 
-	crypto_ahash_clear_flags(ctx->poly, CRYPTO_TFM_REQ_MASK);
-	crypto_ahash_set_flags(ctx->poly, crypto_aead_get_flags(aead) &
-			       CRYPTO_TFM_REQ_MASK);
+	ahash_request_set_callback(&preq->req, aead_request_flags(req),
+				   poly_init_done, req);
+	ahash_request_set_tfm(&preq->req, ctx->poly);
 
-	err = crypto_ahash_setkey(ctx->poly, creq->key, sizeof(creq->key));
-	crypto_aead_set_flags(aead, crypto_ahash_get_flags(ctx->poly) &
-			      CRYPTO_TFM_RES_MASK);
+	err = crypto_ahash_init(&preq->req);
 	if (err)
 		return err;
 
-	return poly_init(req);
+	return poly_setkey(req);
 }
 
 static void poly_genkey_done(struct crypto_async_request *areq, int err)
 {
-	async_done_continue(areq->data, err, poly_genkey_continue);
+	async_done_continue(areq->data, err, poly_init);
 }
 
 static int poly_genkey(struct aead_request *req)
@@ -351,8 +357,8 @@ static int poly_genkey(struct aead_request *req)
 	int err;
 
 	sg_init_table(creq->src, 1);
-	memset(creq->key, 0, sizeof(creq->key));
-	sg_set_buf(creq->src, creq->key, sizeof(creq->key));
+	memset(rctx->key, 0, sizeof(rctx->key));
+	sg_set_buf(creq->src, rctx->key, sizeof(rctx->key));
 
 	chacha_iv(creq->iv, req, 0);
 
@@ -366,7 +372,7 @@ static int poly_genkey(struct aead_request *req)
 	if (err)
 		return err;
 
-	return poly_genkey_continue(req);
+	return poly_init(req);
 }
 
 static void chacha_encrypt_done(struct crypto_async_request *areq, int err)
@@ -403,8 +409,9 @@ static int chachapoly_encrypt(struct aead_request *req)
 
 	/* encrypt call chain:
 	 * - chacha_encrypt/done()
-	 * - poly_genkey/done/continue()
+	 * - poly_genkey/done()
 	 * - poly_init/done()
+	 * - poly_setkey/done()
 	 * - poly_ad/done()
 	 * - poly_adpad/done()
 	 * - poly_cipher/done()
@@ -424,8 +431,9 @@ static int chachapoly_decrypt(struct aead_request *req)
 	rctx->cryptlen = req->cryptlen - POLY1305_DIGEST_SIZE;
 
 	/* decrypt call chain:
-	 * - poly_genkey/done/continue()
+	 * - poly_genkey/done()
 	 * - poly_init/done()
+	 * - poly_setkey/done()
 	 * - poly_ad/done()
 	 * - poly_adpad/done()
 	 * - poly_cipher/done()
diff --git a/crypto/poly1305_generic.c b/crypto/poly1305_generic.c
index 9c1159b..387b5c8 100644
--- a/crypto/poly1305_generic.c
+++ b/crypto/poly1305_generic.c
@@ -21,20 +21,21 @@
 #define POLY1305_KEY_SIZE	32
 #define POLY1305_DIGEST_SIZE	16
 
-struct poly1305_ctx {
+struct poly1305_desc_ctx {
 	/* key */
 	u32 r[5];
 	/* finalize key */
 	u32 s[4];
-};
-
-struct poly1305_desc_ctx {
 	/* accumulator */
 	u32 h[5];
 	/* partial buffer */
 	u8 buf[POLY1305_BLOCK_SIZE];
 	/* bytes used in partial buffer */
 	unsigned int buflen;
+	/* r key has been set */
+	bool rset;
+	/* s key has been set */
+	bool sset;
 };
 
 static inline u64 mlt(u64 a, u64 b)
@@ -63,6 +64,8 @@ static int poly1305_init(struct shash_desc *desc)
 
 	memset(dctx->h, 0, sizeof(dctx->h));
 	dctx->buflen = 0;
+	dctx->rset = false;
+	dctx->sset = false;
 
 	return 0;
 }
@@ -70,42 +73,60 @@ static int poly1305_init(struct shash_desc *desc)
 static int poly1305_setkey(struct crypto_shash *tfm,
 			   const u8 *key, unsigned int keylen)
 {
-	struct poly1305_ctx *ctx = crypto_shash_ctx(tfm);
-
-	if (keylen != POLY1305_KEY_SIZE) {
-		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
+	/* Poly1305 requires a unique key for each tag, which implies that
+	 * we can't set it on the tfm that gets accessed by multiple users
+	 * simultaneously. Instead we expect the key as the first 32 bytes in
+	 * the update() call. */
+	return -ENOTSUPP;
+}
 
+static void poly1305_setrkey(struct poly1305_desc_ctx *dctx, const u8 *key)
+{
 	/* r &= 0xffffffc0ffffffc0ffffffc0fffffff */
-	ctx->r[0] = (le32_to_cpuvp(key +  0) >> 0) & 0x3ffffff;
-	ctx->r[1] = (le32_to_cpuvp(key +  3) >> 2) & 0x3ffff03;
-	ctx->r[2] = (le32_to_cpuvp(key +  6) >> 4) & 0x3ffc0ff;
-	ctx->r[3] = (le32_to_cpuvp(key +  9) >> 6) & 0x3f03fff;
-	ctx->r[4] = (le32_to_cpuvp(key + 12) >> 8) & 0x00fffff;
-
-	ctx->s[0] = le32_to_cpuvp(key + 16);
-	ctx->s[1] = le32_to_cpuvp(key + 20);
-	ctx->s[2] = le32_to_cpuvp(key + 24);
-	ctx->s[3] = le32_to_cpuvp(key + 28);
+	dctx->r[0] = (le32_to_cpuvp(key +  0) >> 0) & 0x3ffffff;
+	dctx->r[1] = (le32_to_cpuvp(key +  3) >> 2) & 0x3ffff03;
+	dctx->r[2] = (le32_to_cpuvp(key +  6) >> 4) & 0x3ffc0ff;
+	dctx->r[3] = (le32_to_cpuvp(key +  9) >> 6) & 0x3f03fff;
+	dctx->r[4] = (le32_to_cpuvp(key + 12) >> 8) & 0x00fffff;
+}
 
-	return 0;
+static void poly1305_setskey(struct poly1305_desc_ctx *dctx, const u8 *key)
+{
+	dctx->s[0] = le32_to_cpuvp(key +  0);
+	dctx->s[1] = le32_to_cpuvp(key +  4);
+	dctx->s[2] = le32_to_cpuvp(key +  8);
+	dctx->s[3] = le32_to_cpuvp(key + 12);
 }
 
 static unsigned int poly1305_blocks(struct poly1305_desc_ctx *dctx,
-				    struct poly1305_ctx *ctx, const u8 *src,
-				    unsigned int srclen, u32 hibit)
+				    const u8 *src, unsigned int srclen,
+				    u32 hibit)
 {
 	u32 r0, r1, r2, r3, r4;
 	u32 s1, s2, s3, s4;
 	u32 h0, h1, h2, h3, h4;
 	u64 d0, d1, d2, d3, d4;
 
-	r0 = ctx->r[0];
-	r1 = ctx->r[1];
-	r2 = ctx->r[2];
-	r3 = ctx->r[3];
-	r4 = ctx->r[4];
+	if (unlikely(!dctx->sset)) {
+		if (!dctx->rset && srclen >= POLY1305_BLOCK_SIZE) {
+			poly1305_setrkey(dctx, src);
+			src += POLY1305_BLOCK_SIZE;
+			srclen -= POLY1305_BLOCK_SIZE;
+			dctx->rset = true;
+		}
+		if (srclen >= POLY1305_BLOCK_SIZE) {
+			poly1305_setskey(dctx, src);
+			src += POLY1305_BLOCK_SIZE;
+			srclen -= POLY1305_BLOCK_SIZE;
+			dctx->sset = true;
+		}
+	}
+
+	r0 = dctx->r[0];
+	r1 = dctx->r[1];
+	r2 = dctx->r[2];
+	r3 = dctx->r[3];
+	r4 = dctx->r[4];
 
 	s1 = r1 * 5;
 	s2 = r2 * 5;
@@ -164,7 +185,6 @@ static int poly1305_update(struct shash_desc *desc,
 			   const u8 *src, unsigned int srclen)
 {
 	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
-	struct poly1305_ctx *ctx = crypto_shash_ctx(desc->tfm);
 	unsigned int bytes;
 
 	if (unlikely(dctx->buflen)) {
@@ -175,14 +195,14 @@ static int poly1305_update(struct shash_desc *desc,
 		dctx->buflen += bytes;
 
 		if (dctx->buflen == POLY1305_BLOCK_SIZE) {
-			poly1305_blocks(dctx, ctx, dctx->buf,
+			poly1305_blocks(dctx, dctx->buf,
 					POLY1305_BLOCK_SIZE, 1 << 24);
 			dctx->buflen = 0;
 		}
 	}
 
 	if (likely(srclen >= POLY1305_BLOCK_SIZE)) {
-		bytes = poly1305_blocks(dctx, ctx, src, srclen, 1 << 24);
+		bytes = poly1305_blocks(dctx, src, srclen, 1 << 24);
 		src += srclen - bytes;
 		srclen = bytes;
 	}
@@ -198,18 +218,20 @@ static int poly1305_update(struct shash_desc *desc,
 static int poly1305_final(struct shash_desc *desc, u8 *dst)
 {
 	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
-	struct poly1305_ctx *ctx = crypto_shash_ctx(desc->tfm);
 	__le32 *mac = (__le32 *)dst;
 	u32 h0, h1, h2, h3, h4;
 	u32 g0, g1, g2, g3, g4;
 	u32 mask;
 	u64 f = 0;
 
+	if (unlikely(!dctx->sset))
+		return -ENOKEY;
+
 	if (unlikely(dctx->buflen)) {
 		dctx->buf[dctx->buflen++] = 1;
 		memset(dctx->buf + dctx->buflen, 0,
 		       POLY1305_BLOCK_SIZE - dctx->buflen);
-		poly1305_blocks(dctx, ctx, dctx->buf, POLY1305_BLOCK_SIZE, 0);
+		poly1305_blocks(dctx, dctx->buf, POLY1305_BLOCK_SIZE, 0);
 	}
 
 	/* fully carry h */
@@ -253,10 +275,10 @@ static int poly1305_final(struct shash_desc *desc, u8 *dst)
 	h3 = (h3 >> 18) | (h4 <<  8);
 
 	/* mac = (h + s) % (2^128) */
-	f = (f >> 32) + h0 + ctx->s[0]; mac[0] = cpu_to_le32(f);
-	f = (f >> 32) + h1 + ctx->s[1]; mac[1] = cpu_to_le32(f);
-	f = (f >> 32) + h2 + ctx->s[2]; mac[2] = cpu_to_le32(f);
-	f = (f >> 32) + h3 + ctx->s[3]; mac[3] = cpu_to_le32(f);
+	f = (f >> 32) + h0 + dctx->s[0]; mac[0] = cpu_to_le32(f);
+	f = (f >> 32) + h1 + dctx->s[1]; mac[1] = cpu_to_le32(f);
+	f = (f >> 32) + h2 + dctx->s[2]; mac[2] = cpu_to_le32(f);
+	f = (f >> 32) + h3 + dctx->s[3]; mac[3] = cpu_to_le32(f);
 
 	return 0;
 }
@@ -275,7 +297,6 @@ static struct shash_alg poly1305_alg = {
 		.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
 		.cra_alignmask		= sizeof(u32) - 1,
 		.cra_blocksize		= POLY1305_BLOCK_SIZE,
-		.cra_ctxsize		= sizeof(struct poly1305_ctx),
 		.cra_module		= THIS_MODULE,
 	},
 };
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 4c2b3e5..5611bc3 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -3051,12 +3051,11 @@ static struct hash_testvec hmac_sha512_tv_template[] = {
 
 static struct hash_testvec poly1305_tv_template[] = {
 	{ /* Test Vector #1 */
-		.key		= "\x00\x00\x00\x00\x00\x00\x00\x00"
+		.plaintext	= "\x00\x00\x00\x00\x00\x00\x00\x00"
+				  "\x00\x00\x00\x00\x00\x00\x00\x00"
+				  "\x00\x00\x00\x00\x00\x00\x00\x00"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00"
-				  "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.ksize		= 32,
-		.plaintext	= "\x00\x00\x00\x00\x00\x00\x00\x00"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00"
@@ -3064,16 +3063,15 @@ static struct hash_testvec poly1305_tv_template[] = {
 				  "\x00\x00\x00\x00\x00\x00\x00\x00"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.psize		= 64,
+		.psize		= 96,
 		.digest		= "\x00\x00\x00\x00\x00\x00\x00\x00"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00",
 	}, { /* Test Vector #2 */
-		.key		= "\x00\x00\x00\x00\x00\x00\x00\x00"
+		.plaintext	= "\x00\x00\x00\x00\x00\x00\x00\x00"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00"
 				  "\x36\xe5\xf6\xb5\xc5\xe0\x60\x70"
-				  "\xf0\xef\xca\x96\x22\x7a\x86\x3e",
-		.ksize		= 32,
-		.plaintext	= "\x41\x6e\x79\x20\x73\x75\x62\x6d"
+				  "\xf0\xef\xca\x96\x22\x7a\x86\x3e"
+				  "\x41\x6e\x79\x20\x73\x75\x62\x6d"
 				  "\x69\x73\x73\x69\x6f\x6e\x20\x74"
 				  "\x6f\x20\x74\x68\x65\x20\x49\x45"
 				  "\x54\x46\x20\x69\x6e\x74\x65\x6e"
@@ -3120,16 +3118,15 @@ static struct hash_testvec poly1305_tv_template[] = {
 				  "\x20\x77\x68\x69\x63\x68\x20\x61"
 				  "\x72\x65\x20\x61\x64\x64\x72\x65"
 				  "\x73\x73\x65\x64\x20\x74\x6f",
-		.psize		= 375,
+		.psize		= 407,
 		.digest		= "\x36\xe5\xf6\xb5\xc5\xe0\x60\x70"
 				  "\xf0\xef\xca\x96\x22\x7a\x86\x3e",
 	}, { /* Test Vector #3 */
-		.key		= "\x36\xe5\xf6\xb5\xc5\xe0\x60\x70"
+		.plaintext	= "\x36\xe5\xf6\xb5\xc5\xe0\x60\x70"
 				  "\xf0\xef\xca\x96\x22\x7a\x86\x3e"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00"
-				  "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.ksize		= 32,
-		.plaintext	= "\x41\x6e\x79\x20\x73\x75\x62\x6d"
+				  "\x00\x00\x00\x00\x00\x00\x00\x00"
+				  "\x41\x6e\x79\x20\x73\x75\x62\x6d"
 				  "\x69\x73\x73\x69\x6f\x6e\x20\x74"
 				  "\x6f\x20\x74\x68\x65\x20\x49\x45"
 				  "\x54\x46\x20\x69\x6e\x74\x65\x6e"
@@ -3176,16 +3173,15 @@ static struct hash_testvec poly1305_tv_template[] = {
 				  "\x20\x77\x68\x69\x63\x68\x20\x61"
 				  "\x72\x65\x20\x61\x64\x64\x72\x65"
 				  "\x73\x73\x65\x64\x20\x74\x6f",
-		.psize		= 375,
+		.psize		= 407,
 		.digest		= "\xf3\x47\x7e\x7c\xd9\x54\x17\xaf"
 				  "\x89\xa6\xb8\x79\x4c\x31\x0c\xf0",
 	}, { /* Test Vector #4 */
-		.key		= "\x1c\x92\x40\xa5\xeb\x55\xd3\x8a"
+		.plaintext	= "\x1c\x92\x40\xa5\xeb\x55\xd3\x8a"
 				  "\xf3\x33\x88\x86\x04\xf6\xb5\xf0"
 				  "\x47\x39\x17\xc1\x40\x2b\x80\x09"
-				  "\x9d\xca\x5c\xbc\x20\x70\x75\xc0",
-		.ksize		= 32,
-		.plaintext	= "\x27\x54\x77\x61\x73\x20\x62\x72"
+				  "\x9d\xca\x5c\xbc\x20\x70\x75\xc0"
+				  "\x27\x54\x77\x61\x73\x20\x62\x72"
 				  "\x69\x6c\x6c\x69\x67\x2c\x20\x61"
 				  "\x6e\x64\x20\x74\x68\x65\x20\x73"
 				  "\x6c\x69\x74\x68\x79\x20\x74\x6f"
@@ -3201,79 +3197,73 @@ static struct hash_testvec poly1305_tv_template[] = {
 				  "\x68\x65\x20\x6d\x6f\x6d\x65\x20"
 				  "\x72\x61\x74\x68\x73\x20\x6f\x75"
 				  "\x74\x67\x72\x61\x62\x65\x2e",
-		.psize		= 127,
+		.psize		= 159,
 		.digest		= "\x45\x41\x66\x9a\x7e\xaa\xee\x61"
 				  "\xe7\x08\xdc\x7c\xbc\xc5\xeb\x62",
 	}, { /* Test Vector #5 */
-		.key		= "\x02\x00\x00\x00\x00\x00\x00\x00"
+		.plaintext	= "\x02\x00\x00\x00\x00\x00\x00\x00"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00"
-				  "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.ksize		= 32,
-		.plaintext	= "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\x00\x00\x00\x00\x00\x00\x00\x00"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
 				  "\xff\xff\xff\xff\xff\xff\xff\xff",
-		.psize		= 16,
+		.psize		= 48,
 		.digest		= "\x03\x00\x00\x00\x00\x00\x00\x00"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00",
 	}, { /* Test Vector #6 */
-		.key		= "\x02\x00\x00\x00\x00\x00\x00\x00"
+		.plaintext	= "\x02\x00\x00\x00\x00\x00\x00\x00"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00"
 				  "\xff\xff\xff\xff\xff\xff\xff\xff"
-				  "\xff\xff\xff\xff\xff\xff\xff\xff",
-		.ksize		= 32,
-		.plaintext	= "\x02\x00\x00\x00\x00\x00\x00\x00"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\x02\x00\x00\x00\x00\x00\x00\x00"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.psize		= 16,
+		.psize		= 48,
 		.digest		= "\x03\x00\x00\x00\x00\x00\x00\x00"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00",
 	}, { /* Test Vector #7 */
-		.key		= "\x01\x00\x00\x00\x00\x00\x00\x00"
+		.plaintext	= "\x01\x00\x00\x00\x00\x00\x00\x00"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00"
-				  "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.ksize		= 32,
-		.plaintext	= "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\x00\x00\x00\x00\x00\x00\x00\x00"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
 				  "\xff\xff\xff\xff\xff\xff\xff\xff"
 				  "\xf0\xff\xff\xff\xff\xff\xff\xff"
 				  "\xff\xff\xff\xff\xff\xff\xff\xff"
 				  "\x11\x00\x00\x00\x00\x00\x00\x00"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.psize		= 48,
+		.psize		= 80,
 		.digest		= "\x05\x00\x00\x00\x00\x00\x00\x00"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00",
 	}, { /* Test Vector #8 */
-		.key		= "\x01\x00\x00\x00\x00\x00\x00\x00"
+		.plaintext	= "\x01\x00\x00\x00\x00\x00\x00\x00"
+				  "\x00\x00\x00\x00\x00\x00\x00\x00"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00"
-				  "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.ksize		= 32,
-		.plaintext	= "\xff\xff\xff\xff\xff\xff\xff\xff"
+				  "\xff\xff\xff\xff\xff\xff\xff\xff"
 				  "\xff\xff\xff\xff\xff\xff\xff\xff"
 				  "\xfb\xfe\xfe\xfe\xfe\xfe\xfe\xfe"
 				  "\xfe\xfe\xfe\xfe\xfe\xfe\xfe\xfe"
 				  "\x01\x01\x01\x01\x01\x01\x01\x01"
 				  "\x01\x01\x01\x01\x01\x01\x01\x01",
-		.psize		= 48,
+		.psize		= 80,
 		.digest		= "\x00\x00\x00\x00\x00\x00\x00\x00"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00",
 	}, { /* Test Vector #9 */
-		.key		= "\x02\x00\x00\x00\x00\x00\x00\x00"
+		.plaintext	= "\x02\x00\x00\x00\x00\x00\x00\x00"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00"
-				  "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.ksize		= 32,
-		.plaintext	= "\xfd\xff\xff\xff\xff\xff\xff\xff"
+				  "\x00\x00\x00\x00\x00\x00\x00\x00"
+				  "\xfd\xff\xff\xff\xff\xff\xff\xff"
 				  "\xff\xff\xff\xff\xff\xff\xff\xff",
-		.psize		= 16,
+		.psize		= 48,
 		.digest		= "\xfa\xff\xff\xff\xff\xff\xff\xff"
 				  "\xff\xff\xff\xff\xff\xff\xff\xff",
 	}, { /* Test Vector #10 */
-		.key		= "\x01\x00\x00\x00\x00\x00\x00\x00"
+		.plaintext	= "\x01\x00\x00\x00\x00\x00\x00\x00"
 				  "\x04\x00\x00\x00\x00\x00\x00\x00"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00"
-				  "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.ksize		= 32,
-		.plaintext	= "\xe3\x35\x94\xd7\x50\x5e\x43\xb9"
+				  "\x00\x00\x00\x00\x00\x00\x00\x00"
+				  "\xe3\x35\x94\xd7\x50\x5e\x43\xb9"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00"
 				  "\x33\x94\xd7\x50\x5e\x43\x79\xcd"
 				  "\x01\x00\x00\x00\x00\x00\x00\x00"
@@ -3281,22 +3271,21 @@ static struct hash_testvec poly1305_tv_template[] = {
 				  "\x00\x00\x00\x00\x00\x00\x00\x00"
 				  "\x01\x00\x00\x00\x00\x00\x00\x00"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.psize		= 64,
+		.psize		= 96,
 		.digest		= "\x14\x00\x00\x00\x00\x00\x00\x00"
 				  "\x55\x00\x00\x00\x00\x00\x00\x00",
 	}, { /* Test Vector #11 */
-		.key		= "\x01\x00\x00\x00\x00\x00\x00\x00"
+		.plaintext	= "\x01\x00\x00\x00\x00\x00\x00\x00"
 				  "\x04\x00\x00\x00\x00\x00\x00\x00"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00"
-				  "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.ksize		= 32,
-		.plaintext	= "\xe3\x35\x94\xd7\x50\x5e\x43\xb9"
+				  "\x00\x00\x00\x00\x00\x00\x00\x00"
+				  "\xe3\x35\x94\xd7\x50\x5e\x43\xb9"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00"
 				  "\x33\x94\xd7\x50\x5e\x43\x79\xcd"
 				  "\x01\x00\x00\x00\x00\x00\x00\x00"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.psize		= 48,
+		.psize		= 80,
 		.digest		= "\x13\x00\x00\x00\x00\x00\x00\x00"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00",
 	},
-- 
1.9.1
