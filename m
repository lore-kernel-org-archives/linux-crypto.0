Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE79222B8D2
	for <linux-crypto@vger.kernel.org>; Thu, 24 Apr 2025 10:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745491645; cv=none; b=OmI4QUcg2VuY90Q5d0LeeOtq4IJS63fy6wCxgz7PW/kcxKF1nHqpl7ngrYv+1fL+zsBVxups7zCTZxNoifr0CLnL/AH+yVKz4yyeLYU7JbGhSCtaLgOdaSdLZaKjyCmXJ4RyGbelNkajZQi6Wp5/w+vjoBb107FqmvKanNZkxHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745491645; c=relaxed/simple;
	bh=ZPRU/bf+Y/1RYqSK9nfntFac6s9MKT8XAH56hcCAyC8=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=a7CwHFVU78fWcFkGKIlFZVZPFTALEQVhWu/Gu5q5XvgT6YLa+i3jX8lzgcuSAi0Zp4t2l+5Dj56ruYN0dzI0CZuoiZuBCp75Uke263mvjzYyZroy0N1ExAUdfAoyn+WzZFKhtQDKCzovNdXWmJP+wtzUhfH/6yU1G+KPbWPFcs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=qOSkpjxe; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="qOSkpjxe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=dsGrc6QMhtIV/FQDpWveAi8sAfdbyGpS48t1gv7PLug=; b=qOSkpjxeP7hIR6JY7km9mUu9xn
	ymfpsePeN6l6VG5Ymw06RKuk8PtxF2ttleXFKa6YVfhMnHrPHYuHbjLhPB+gqXHZ0ytAapO6sRzpx
	L3jk30PyVM4LaI7p9zSDX6YXJDyowwrpI45IF4xWu+/Y+wJB/DtGkFrb/ZLdb7Jl+fohKr6YIUikT
	JF2sridhK4HrzvrodkQfwC9/oX9W96Ii8E20aGBswkEDn9QC/u9SbrCi8eTEKTz0/KvwE5zgWmDio
	6nb9CAzSSJVnyWM9nQL4xjs7HXT3tY+Z2u7xMqpjac7bgEs4fDupFmDShG9Ig/kcz3ikUVcLEgAQ5
	aq42Sdjw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u7u6x-000fN1-10;
	Thu, 24 Apr 2025 18:47:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 24 Apr 2025 18:47:19 +0800
Date: Thu, 24 Apr 2025 18:47:19 +0800
Message-Id: <c37c3665d28fd222d84248e0af570744213426a9.1745490652.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1745490652.git.herbert@gondor.apana.org.au>
References: <cover.1745490652.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 10/15] crypto: chacha20poly1305 - Use setkey on poly1305
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the new setkey interface for poly1305 instead of supplying
the key via the first two blocks.

In order to do this, clone the shash transform for each request.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/chacha20poly1305.c | 115 ++++++++++++++++++++++----------------
 1 file changed, 67 insertions(+), 48 deletions(-)

diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index d740849f1c19..cd8e3b5c55b5 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -51,6 +51,8 @@ struct chacha_req {
 struct chachapoly_req_ctx {
 	struct scatterlist src[2];
 	struct scatterlist dst[2];
+	/* Poly1305 transform with generated key */
+	struct crypto_ahash *poly;
 	/* the key we generate for Poly1305 using Chacha20 */
 	u8 key[POLY1305_KEY_SIZE];
 	/* calculated Poly1305 tag */
@@ -81,6 +83,26 @@ static inline void async_done_continue(struct aead_request *req, int err,
 		aead_request_complete(req, err);
 }
 
+static inline void poly_done_continue(struct aead_request *req, int err,
+				      int (*cont)(struct aead_request *))
+{
+	if (err && err != -EINPROGRESS && err != -EBUSY) {
+		struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
+
+		crypto_free_ahash(rctx->poly);
+	}
+	async_done_continue(req, err, cont);
+}
+
+static int poly_check_err(struct aead_request *req, int err)
+{
+	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
+
+	if (err && err != -EINPROGRESS && err != -EBUSY)
+		crypto_free_ahash(rctx->poly);
+	return err;
+}
+
 static void chacha_iv(u8 *iv, struct aead_request *req, u32 icb)
 {
 	struct chachapoly_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
@@ -155,6 +177,8 @@ static int poly_tail_continue(struct aead_request *req)
 {
 	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
 
+	crypto_free_ahash(rctx->poly);
+
 	if (rctx->cryptlen == req->cryptlen) /* encrypting */
 		return poly_copy_tag(req);
 
@@ -163,13 +187,11 @@ static int poly_tail_continue(struct aead_request *req)
 
 static void poly_tail_done(void *data, int err)
 {
-	async_done_continue(data, err, poly_tail_continue);
+	poly_done_continue(data, err, poly_tail_continue);
 }
 
 static int poly_tail(struct aead_request *req)
 {
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct chachapoly_ctx *ctx = crypto_aead_ctx(tfm);
 	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
 	struct poly_req *preq = &rctx->u.poly;
 	int err;
@@ -180,11 +202,12 @@ static int poly_tail(struct aead_request *req)
 
 	ahash_request_set_callback(&preq->req, rctx->flags,
 				   poly_tail_done, req);
-	ahash_request_set_tfm(&preq->req, ctx->poly);
+	ahash_request_set_tfm(&preq->req, rctx->poly);
 	ahash_request_set_crypt(&preq->req, preq->src,
 				rctx->tag, sizeof(preq->tail));
 
 	err = crypto_ahash_finup(&preq->req);
+	err = poly_check_err(req, err);
 	if (err)
 		return err;
 
@@ -193,12 +216,11 @@ static int poly_tail(struct aead_request *req)
 
 static void poly_cipherpad_done(void *data, int err)
 {
-	async_done_continue(data, err, poly_tail);
+	poly_done_continue(data, err, poly_tail);
 }
 
 static int poly_cipherpad(struct aead_request *req)
 {
-	struct chachapoly_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
 	struct poly_req *preq = &rctx->u.poly;
 	unsigned int padlen;
@@ -210,10 +232,11 @@ static int poly_cipherpad(struct aead_request *req)
 
 	ahash_request_set_callback(&preq->req, rctx->flags,
 				   poly_cipherpad_done, req);
-	ahash_request_set_tfm(&preq->req, ctx->poly);
+	ahash_request_set_tfm(&preq->req, rctx->poly);
 	ahash_request_set_crypt(&preq->req, preq->src, NULL, padlen);
 
 	err = crypto_ahash_update(&preq->req);
+	err = poly_check_err(req, err);
 	if (err)
 		return err;
 
@@ -222,12 +245,11 @@ static int poly_cipherpad(struct aead_request *req)
 
 static void poly_cipher_done(void *data, int err)
 {
-	async_done_continue(data, err, poly_cipherpad);
+	poly_done_continue(data, err, poly_cipherpad);
 }
 
 static int poly_cipher(struct aead_request *req)
 {
-	struct chachapoly_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
 	struct poly_req *preq = &rctx->u.poly;
 	struct scatterlist *crypt = req->src;
@@ -240,10 +262,11 @@ static int poly_cipher(struct aead_request *req)
 
 	ahash_request_set_callback(&preq->req, rctx->flags,
 				   poly_cipher_done, req);
-	ahash_request_set_tfm(&preq->req, ctx->poly);
+	ahash_request_set_tfm(&preq->req, rctx->poly);
 	ahash_request_set_crypt(&preq->req, crypt, NULL, rctx->cryptlen);
 
 	err = crypto_ahash_update(&preq->req);
+	err = poly_check_err(req, err);
 	if (err)
 		return err;
 
@@ -252,12 +275,11 @@ static int poly_cipher(struct aead_request *req)
 
 static void poly_adpad_done(void *data, int err)
 {
-	async_done_continue(data, err, poly_cipher);
+	poly_done_continue(data, err, poly_cipher);
 }
 
 static int poly_adpad(struct aead_request *req)
 {
-	struct chachapoly_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
 	struct poly_req *preq = &rctx->u.poly;
 	unsigned int padlen;
@@ -269,10 +291,11 @@ static int poly_adpad(struct aead_request *req)
 
 	ahash_request_set_callback(&preq->req, rctx->flags,
 				   poly_adpad_done, req);
-	ahash_request_set_tfm(&preq->req, ctx->poly);
+	ahash_request_set_tfm(&preq->req, rctx->poly);
 	ahash_request_set_crypt(&preq->req, preq->src, NULL, padlen);
 
 	err = crypto_ahash_update(&preq->req);
+	err = poly_check_err(req, err);
 	if (err)
 		return err;
 
@@ -281,80 +304,76 @@ static int poly_adpad(struct aead_request *req)
 
 static void poly_ad_done(void *data, int err)
 {
-	async_done_continue(data, err, poly_adpad);
+	poly_done_continue(data, err, poly_adpad);
 }
 
 static int poly_ad(struct aead_request *req)
 {
-	struct chachapoly_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
 	struct poly_req *preq = &rctx->u.poly;
 	int err;
 
 	ahash_request_set_callback(&preq->req, rctx->flags,
 				   poly_ad_done, req);
-	ahash_request_set_tfm(&preq->req, ctx->poly);
+	ahash_request_set_tfm(&preq->req, rctx->poly);
 	ahash_request_set_crypt(&preq->req, req->src, NULL, rctx->assoclen);
 
 	err = crypto_ahash_update(&preq->req);
+	err = poly_check_err(req, err);
 	if (err)
 		return err;
 
 	return poly_adpad(req);
 }
 
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
 static void poly_init_done(void *data, int err)
 {
-	async_done_continue(data, err, poly_setkey);
+	poly_done_continue(data, err, poly_ad);
 }
 
 static int poly_init(struct aead_request *req)
 {
-	struct chachapoly_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
 	struct poly_req *preq = &rctx->u.poly;
 	int err;
 
 	ahash_request_set_callback(&preq->req, rctx->flags,
 				   poly_init_done, req);
-	ahash_request_set_tfm(&preq->req, ctx->poly);
+	ahash_request_set_tfm(&preq->req, rctx->poly);
 
 	err = crypto_ahash_init(&preq->req);
+	err = poly_check_err(req, err);
 	if (err)
 		return err;
 
-	return poly_setkey(req);
+	return poly_ad(req);
+}
+
+static int poly_setkey(struct aead_request *req)
+{
+	struct chachapoly_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
+	struct crypto_ahash *poly;
+	int err;
+
+	poly = crypto_clone_ahash(ctx->poly);
+	if (IS_ERR(poly))
+		return PTR_ERR(poly);
+
+	err = crypto_ahash_setkey(poly, rctx->key, sizeof(rctx->key));
+	if (err) {
+		crypto_free_ahash(poly);
+		return err;
+	}
+
+	rctx->poly = poly;
+
+	return poly_init(req);
 }
 
 static void poly_genkey_done(void *data, int err)
 {
-	async_done_continue(data, err, poly_init);
+	async_done_continue(data, err, poly_setkey);
 }
 
 static int poly_genkey(struct aead_request *req)
@@ -388,7 +407,7 @@ static int poly_genkey(struct aead_request *req)
 	if (err)
 		return err;
 
-	return poly_init(req);
+	return poly_setkey(req);
 }
 
 static void chacha_encrypt_done(void *data, int err)
-- 
2.39.5

