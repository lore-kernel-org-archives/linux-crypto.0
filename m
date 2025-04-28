Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F369192B84
	for <linux-crypto@vger.kernel.org>; Mon, 28 Apr 2025 04:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745816187; cv=none; b=UTG6vhMrr34toB0U5805V7VCS5EsCJTrBm9GpqO2Vw60qekVzZViZtaght5PUl4qWTOPPkQKmkaK3UQwsqNgOgW7H8l1i5dA6kuEr/nI+6TpkKGMkRfdz2VE4jul+DFDcVqGmGy8XZoswsYzW7GOEfCiW+TpGOWRmL6OCGx0J94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745816187; c=relaxed/simple;
	bh=mpQhYhnY/3FMu1IP0byDJFsigEkYqSBRBUECJhejk+E=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=NdjGTjAf7Q+jBLUCFTFxeYWjFjQ6lyVDDeCLptDcZLqMjVrVWASWdCVmKLIIOs5TsQbCcW1QQQ3ML7bWQwVJyfGKN1NDVqwyZaz+VrujzldzJY0RGNvAU6iwZOIyzcV8eyFe6dnYFn797JEG+3Slt6EcVLmJq4+xYc3G7xK1Ae4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=lXoWdTx0; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="lXoWdTx0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0rog3zcGLNQ/vv+Rih0aLedD2DdiDVav3CaqUpzdBeM=; b=lXoWdTx0Dep2JqCA2xpY97H7Dx
	0vRVDVn3jYsCXMxrzQZTqatpwL+IylbSBFrR3hoxh6eaUyaUQvDftMzB4oN1C//tQ59o+IemdQDsr
	kvv16QR1tGHSaOqOViCqnObSjG/2qjJFQyrn5F3y/DhRPPD9zYKjw88kmLArIf4Uq/bqT55Pfhc5J
	urOsSdIFVo24eEkBbRTGCNfq9UhBxXRZWt9XoqzzrIoIyx64A33oFyeqOYlpnXQSbgBgqRK/Xs1sb
	ornqV5ony6Deczu7169yEjRkHA3kHy5sD1DvvcZ28iJezFcQkXYKpvTzLKXOyBIkkA3S5fGHqmnJA
	bCyme6Aw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u9GXV-001WGM-0b;
	Mon, 28 Apr 2025 12:56:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 28 Apr 2025 12:56:21 +0800
Date: Mon, 28 Apr 2025 12:56:21 +0800
Message-Id: <0babdb56d14256b44249dc2bf3190ec200d9d738.1745815528.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1745815528.git.herbert@gondor.apana.org.au>
References: <cover.1745815528.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v4 PATCH 08/11] crypto: chacha20poly1305 - Use lib/crypto poly1305
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Since the poly1305 algorithm is fixed, there is no point in going
through the Crypto API for it.  Use the lib/crypto poly1305 interface
instead.

For compatiblity keep the poly1305 parameter in the algorithm name.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/Kconfig            |   2 +-
 crypto/chacha20poly1305.c | 323 ++++++++------------------------------
 2 files changed, 67 insertions(+), 258 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 9878286d1d68..f87e2a26d2dd 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -784,8 +784,8 @@ config CRYPTO_AEGIS128_SIMD
 config CRYPTO_CHACHA20POLY1305
 	tristate "ChaCha20-Poly1305"
 	select CRYPTO_CHACHA20
-	select CRYPTO_POLY1305
 	select CRYPTO_AEAD
+	select CRYPTO_LIB_POLY1305
 	select CRYPTO_MANAGER
 	help
 	  ChaCha20 stream cipher and Poly1305 authenticator combined
diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index d740849f1c19..b29f66ba1e2f 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -12,36 +12,23 @@
 #include <crypto/chacha.h>
 #include <crypto/poly1305.h>
 #include <linux/err.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/string.h>
 
 struct chachapoly_instance_ctx {
 	struct crypto_skcipher_spawn chacha;
-	struct crypto_ahash_spawn poly;
 	unsigned int saltlen;
 };
 
 struct chachapoly_ctx {
 	struct crypto_skcipher *chacha;
-	struct crypto_ahash *poly;
 	/* key bytes we use for the ChaCha20 IV */
 	unsigned int saltlen;
 	u8 salt[] __counted_by(saltlen);
 };
 
-struct poly_req {
-	/* zero byte padding for AD/ciphertext, as needed */
-	u8 pad[POLY1305_BLOCK_SIZE];
-	/* tail data with AD/ciphertext lengths */
-	struct {
-		__le64 assoclen;
-		__le64 cryptlen;
-	} tail;
-	struct scatterlist src[1];
-	struct ahash_request req; /* must be last member */
-};
-
 struct chacha_req {
 	u8 iv[CHACHA_IV_SIZE];
 	struct scatterlist src[1];
@@ -62,7 +49,6 @@ struct chachapoly_req_ctx {
 	/* request flags, with MAY_SLEEP cleared if needed */
 	u32 flags;
 	union {
-		struct poly_req poly;
 		struct chacha_req chacha;
 	} u;
 };
@@ -105,16 +91,6 @@ static int poly_verify_tag(struct aead_request *req)
 	return 0;
 }
 
-static int poly_copy_tag(struct aead_request *req)
-{
-	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
-
-	scatterwalk_map_and_copy(rctx->tag, req->dst,
-				 req->assoclen + rctx->cryptlen,
-				 sizeof(rctx->tag), 1);
-	return 0;
-}
-
 static void chacha_decrypt_done(void *data, int err)
 {
 	async_done_continue(data, err, poly_verify_tag);
@@ -151,210 +127,76 @@ static int chacha_decrypt(struct aead_request *req)
 	return poly_verify_tag(req);
 }
 
-static int poly_tail_continue(struct aead_request *req)
+static int poly_hash(struct aead_request *req)
 {
 	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
+	const void *zp = page_address(ZERO_PAGE(0));
+	struct scatterlist *sg = req->src;
+	struct poly1305_desc_ctx desc;
+	struct scatter_walk walk;
+	struct {
+		union {
+			struct {
+				__le64 assoclen;
+				__le64 cryptlen;
+			};
+			u8 u8[16];
+		};
+	} tail;
+	unsigned int padlen;
+	unsigned int total;
+
+	if (sg != req->dst)
+		memcpy_sglist(req->dst, sg, req->assoclen);
 
 	if (rctx->cryptlen == req->cryptlen) /* encrypting */
-		return poly_copy_tag(req);
+		sg = req->dst;
 
-	return chacha_decrypt(req);
-}
+	poly1305_init(&desc, rctx->key);
+	scatterwalk_start(&walk, sg);
 
-static void poly_tail_done(void *data, int err)
-{
-	async_done_continue(data, err, poly_tail_continue);
-}
+	total = rctx->assoclen;
+	while (total) {
+		unsigned int n = scatterwalk_next(&walk, total);
 
-static int poly_tail(struct aead_request *req)
-{
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct chachapoly_ctx *ctx = crypto_aead_ctx(tfm);
-	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
-	struct poly_req *preq = &rctx->u.poly;
-	int err;
-
-	preq->tail.assoclen = cpu_to_le64(rctx->assoclen);
-	preq->tail.cryptlen = cpu_to_le64(rctx->cryptlen);
-	sg_init_one(preq->src, &preq->tail, sizeof(preq->tail));
-
-	ahash_request_set_callback(&preq->req, rctx->flags,
-				   poly_tail_done, req);
-	ahash_request_set_tfm(&preq->req, ctx->poly);
-	ahash_request_set_crypt(&preq->req, preq->src,
-				rctx->tag, sizeof(preq->tail));
-
-	err = crypto_ahash_finup(&preq->req);
-	if (err)
-		return err;
-
-	return poly_tail_continue(req);
-}
-
-static void poly_cipherpad_done(void *data, int err)
-{
-	async_done_continue(data, err, poly_tail);
-}
-
-static int poly_cipherpad(struct aead_request *req)
-{
-	struct chachapoly_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
-	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
-	struct poly_req *preq = &rctx->u.poly;
-	unsigned int padlen;
-	int err;
-
-	padlen = -rctx->cryptlen % POLY1305_BLOCK_SIZE;
-	memset(preq->pad, 0, sizeof(preq->pad));
-	sg_init_one(preq->src, preq->pad, padlen);
-
-	ahash_request_set_callback(&preq->req, rctx->flags,
-				   poly_cipherpad_done, req);
-	ahash_request_set_tfm(&preq->req, ctx->poly);
-	ahash_request_set_crypt(&preq->req, preq->src, NULL, padlen);
-
-	err = crypto_ahash_update(&preq->req);
-	if (err)
-		return err;
-
-	return poly_tail(req);
-}
-
-static void poly_cipher_done(void *data, int err)
-{
-	async_done_continue(data, err, poly_cipherpad);
-}
-
-static int poly_cipher(struct aead_request *req)
-{
-	struct chachapoly_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
-	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
-	struct poly_req *preq = &rctx->u.poly;
-	struct scatterlist *crypt = req->src;
-	int err;
-
-	if (rctx->cryptlen == req->cryptlen) /* encrypting */
-		crypt = req->dst;
-
-	crypt = scatterwalk_ffwd(rctx->src, crypt, req->assoclen);
-
-	ahash_request_set_callback(&preq->req, rctx->flags,
-				   poly_cipher_done, req);
-	ahash_request_set_tfm(&preq->req, ctx->poly);
-	ahash_request_set_crypt(&preq->req, crypt, NULL, rctx->cryptlen);
-
-	err = crypto_ahash_update(&preq->req);
-	if (err)
-		return err;
-
-	return poly_cipherpad(req);
-}
-
-static void poly_adpad_done(void *data, int err)
-{
-	async_done_continue(data, err, poly_cipher);
-}
-
-static int poly_adpad(struct aead_request *req)
-{
-	struct chachapoly_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
-	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
-	struct poly_req *preq = &rctx->u.poly;
-	unsigned int padlen;
-	int err;
+		poly1305_update(&desc, walk.addr, n);
+		scatterwalk_done_src(&walk, n);
+		total -= n;
+	}
 
 	padlen = -rctx->assoclen % POLY1305_BLOCK_SIZE;
-	memset(preq->pad, 0, sizeof(preq->pad));
-	sg_init_one(preq->src, preq->pad, padlen);
+	poly1305_update(&desc, zp, padlen);
 
-	ahash_request_set_callback(&preq->req, rctx->flags,
-				   poly_adpad_done, req);
-	ahash_request_set_tfm(&preq->req, ctx->poly);
-	ahash_request_set_crypt(&preq->req, preq->src, NULL, padlen);
+	scatterwalk_skip(&walk, req->assoclen - rctx->assoclen);
 
-	err = crypto_ahash_update(&preq->req);
-	if (err)
-		return err;
+	total = rctx->cryptlen;
+	while (total) {
+		unsigned int n = scatterwalk_next(&walk, total);
 
-	return poly_cipher(req);
-}
+		poly1305_update(&desc, walk.addr, n);
+		scatterwalk_done_src(&walk, n);
+		total -= n;
+	}
 
-static void poly_ad_done(void *data, int err)
-{
-	async_done_continue(data, err, poly_adpad);
-}
+	padlen = -rctx->cryptlen % POLY1305_BLOCK_SIZE;
+	poly1305_update(&desc, zp, padlen);
 
-static int poly_ad(struct aead_request *req)
-{
-	struct chachapoly_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
-	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
-	struct poly_req *preq = &rctx->u.poly;
-	int err;
+	tail.assoclen = cpu_to_le64(rctx->assoclen);
+	tail.cryptlen = cpu_to_le64(rctx->cryptlen);
+	poly1305_update(&desc, tail.u8, sizeof(tail));
+	memzero_explicit(&tail, sizeof(tail));
+	poly1305_final(&desc, rctx->tag);
 
-	ahash_request_set_callback(&preq->req, rctx->flags,
-				   poly_ad_done, req);
-	ahash_request_set_tfm(&preq->req, ctx->poly);
-	ahash_request_set_crypt(&preq->req, req->src, NULL, rctx->assoclen);
+	if (rctx->cryptlen != req->cryptlen)
+		return chacha_decrypt(req);
 
-	err = crypto_ahash_update(&preq->req);
-	if (err)
-		return err;
-
-	return poly_adpad(req);
-}
-
-static void poly_setkey_done(void *data, int err)
-{
-	async_done_continue(data, err, poly_ad);
-}
-
-static int poly_setkey(struct aead_request *req)
-{
-	struct chachapoly_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
-	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
-	struct poly_req *preq = &rctx->u.poly;
-	int err;
-
-	sg_init_one(preq->src, rctx->key, sizeof(rctx->key));
-
-	ahash_request_set_callback(&preq->req, rctx->flags,
-				   poly_setkey_done, req);
-	ahash_request_set_tfm(&preq->req, ctx->poly);
-	ahash_request_set_crypt(&preq->req, preq->src, NULL, sizeof(rctx->key));
-
-	err = crypto_ahash_update(&preq->req);
-	if (err)
-		return err;
-
-	return poly_ad(req);
-}
-
-static void poly_init_done(void *data, int err)
-{
-	async_done_continue(data, err, poly_setkey);
-}
-
-static int poly_init(struct aead_request *req)
-{
-	struct chachapoly_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
-	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
-	struct poly_req *preq = &rctx->u.poly;
-	int err;
-
-	ahash_request_set_callback(&preq->req, rctx->flags,
-				   poly_init_done, req);
-	ahash_request_set_tfm(&preq->req, ctx->poly);
-
-	err = crypto_ahash_init(&preq->req);
-	if (err)
-		return err;
-
-	return poly_setkey(req);
+	memcpy_to_scatterwalk(&walk, rctx->tag, sizeof(rctx->tag));
+	return 0;
 }
 
 static void poly_genkey_done(void *data, int err)
 {
-	async_done_continue(data, err, poly_init);
+	async_done_continue(data, err, poly_hash);
 }
 
 static int poly_genkey(struct aead_request *req)
@@ -388,7 +230,7 @@ static int poly_genkey(struct aead_request *req)
 	if (err)
 		return err;
 
-	return poly_init(req);
+	return poly_hash(req);
 }
 
 static void chacha_encrypt_done(void *data, int err)
@@ -437,14 +279,7 @@ static int chachapoly_encrypt(struct aead_request *req)
 	/* encrypt call chain:
 	 * - chacha_encrypt/done()
 	 * - poly_genkey/done()
-	 * - poly_init/done()
-	 * - poly_setkey/done()
-	 * - poly_ad/done()
-	 * - poly_adpad/done()
-	 * - poly_cipher/done()
-	 * - poly_cipherpad/done()
-	 * - poly_tail/done/continue()
-	 * - poly_copy_tag()
+	 * - poly_hash()
 	 */
 	return chacha_encrypt(req);
 }
@@ -458,13 +293,7 @@ static int chachapoly_decrypt(struct aead_request *req)
 
 	/* decrypt call chain:
 	 * - poly_genkey/done()
-	 * - poly_init/done()
-	 * - poly_setkey/done()
-	 * - poly_ad/done()
-	 * - poly_adpad/done()
-	 * - poly_cipher/done()
-	 * - poly_cipherpad/done()
-	 * - poly_tail/done/continue()
+	 * - poly_hash()
 	 * - chacha_decrypt/done()
 	 * - poly_verify_tag()
 	 */
@@ -503,21 +332,13 @@ static int chachapoly_init(struct crypto_aead *tfm)
 	struct chachapoly_instance_ctx *ictx = aead_instance_ctx(inst);
 	struct chachapoly_ctx *ctx = crypto_aead_ctx(tfm);
 	struct crypto_skcipher *chacha;
-	struct crypto_ahash *poly;
 	unsigned long align;
 
-	poly = crypto_spawn_ahash(&ictx->poly);
-	if (IS_ERR(poly))
-		return PTR_ERR(poly);
-
 	chacha = crypto_spawn_skcipher(&ictx->chacha);
-	if (IS_ERR(chacha)) {
-		crypto_free_ahash(poly);
+	if (IS_ERR(chacha))
 		return PTR_ERR(chacha);
-	}
 
 	ctx->chacha = chacha;
-	ctx->poly = poly;
 	ctx->saltlen = ictx->saltlen;
 
 	align = crypto_aead_alignmask(tfm);
@@ -525,12 +346,9 @@ static int chachapoly_init(struct crypto_aead *tfm)
 	crypto_aead_set_reqsize(
 		tfm,
 		align + offsetof(struct chachapoly_req_ctx, u) +
-		max(offsetof(struct chacha_req, req) +
-		    sizeof(struct skcipher_request) +
-		    crypto_skcipher_reqsize(chacha),
-		    offsetof(struct poly_req, req) +
-		    sizeof(struct ahash_request) +
-		    crypto_ahash_reqsize(poly)));
+		offsetof(struct chacha_req, req) +
+		sizeof(struct skcipher_request) +
+		crypto_skcipher_reqsize(chacha));
 
 	return 0;
 }
@@ -539,7 +357,6 @@ static void chachapoly_exit(struct crypto_aead *tfm)
 {
 	struct chachapoly_ctx *ctx = crypto_aead_ctx(tfm);
 
-	crypto_free_ahash(ctx->poly);
 	crypto_free_skcipher(ctx->chacha);
 }
 
@@ -548,7 +365,6 @@ static void chachapoly_free(struct aead_instance *inst)
 	struct chachapoly_instance_ctx *ctx = aead_instance_ctx(inst);
 
 	crypto_drop_skcipher(&ctx->chacha);
-	crypto_drop_ahash(&ctx->poly);
 	kfree(inst);
 }
 
@@ -559,7 +375,6 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 	struct aead_instance *inst;
 	struct chachapoly_instance_ctx *ctx;
 	struct skcipher_alg_common *chacha;
-	struct hash_alg_common *poly;
 	int err;
 
 	if (ivsize > CHACHAPOLY_IV_SIZE)
@@ -581,14 +396,9 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 		goto err_free_inst;
 	chacha = crypto_spawn_skcipher_alg_common(&ctx->chacha);
 
-	err = crypto_grab_ahash(&ctx->poly, aead_crypto_instance(inst),
-				crypto_attr_alg_name(tb[2]), 0, mask);
-	if (err)
-		goto err_free_inst;
-	poly = crypto_spawn_ahash_alg(&ctx->poly);
-
 	err = -EINVAL;
-	if (poly->digestsize != POLY1305_DIGEST_SIZE)
+	if (strcmp(crypto_attr_alg_name(tb[2]), "poly1305") &&
+	    strcmp(crypto_attr_alg_name(tb[2]), "poly1305-generic"))
 		goto err_free_inst;
 	/* Need 16-byte IV size, including Initial Block Counter value */
 	if (chacha->ivsize != CHACHA_IV_SIZE)
@@ -599,16 +409,15 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
-		     "%s(%s,%s)", name, chacha->base.cra_name,
-		     poly->base.cra_name) >= CRYPTO_MAX_ALG_NAME)
+		     "%s(%s,poly1305)", name,
+		     chacha->base.cra_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
-		     "%s(%s,%s)", name, chacha->base.cra_driver_name,
-		     poly->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
+		     "%s(%s,poly1305-generic)", name,
+		     chacha->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_priority = (chacha->base.cra_priority +
-				       poly->base.cra_priority) / 2;
+	inst->alg.base.cra_priority = chacha->base.cra_priority;
 	inst->alg.base.cra_blocksize = 1;
 	inst->alg.base.cra_alignmask = chacha->base.cra_alignmask;
 	inst->alg.base.cra_ctxsize = sizeof(struct chachapoly_ctx) +
-- 
2.39.5

