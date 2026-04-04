Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506AF392C5B
	for <linux-crypto@vger.kernel.org>; Sat,  4 Apr 2026 10:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775297454; cv=none; b=OjjpbO5rVJecbHKVjxik4kHY+9qrzg/VfF0g3fd6FxUBHEDEE+4rYmQWmNL851uy+oiDDkYsGradz/V5d1OImft9T8FeI5wka4s1i9PwozDl50FZ7faG8QOiLRgXlFMXKtTUCkFfAxf3Hp/7nN+85+tgCx1ps1Ie90WvBUEqa2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775297454; c=relaxed/simple;
	bh=uWh+9ayBRJokeXrXH9XxcK+oDOr46iGJE5o+6LZYrwM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=de4ManKcQOhHFaJ6PdZbGFamH58e4f6Hqwo74VnM6V+bjwWNZIQuyO7EsPtNUnQMUMtGCoekxfynUHLEcIuOth2srAeeZPQQ+LC/Fz9JTlzjMtXRvb1kncMsOb7NojEBzhhE1fJiDNwCsHqxjLhlcVJUQgx1j+TMU83Xcdoarfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=N7V48TNx; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="N7V48TNx"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775297441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+82Zj9GWYtDo3vXEQgNQClC/0d4btLSpo8442zu5bL0=;
	b=N7V48TNxr0zVT84wR72RWwFlz6SJrD744srcf39MFixBpoV/dLva08wRTPskSnEuty70NV
	ZL9idfBdizVKFHo7JHAwL6t2XiGl3AWFWt7iO8q840C61Ug5B0Hah+Re2Orz2c1ovCwKca
	3x9F1TooXVjsgt7fIfx0yUvdn1LcrVw=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: omap - convert reqctx buffer to fixed-size array
Date: Sat,  4 Apr 2026 12:10:17 +0200
Message-ID: <20260404101017.936076-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3803; i=thorsten.blum@linux.dev; h=from:subject; bh=uWh+9ayBRJokeXrXH9XxcK+oDOr46iGJE5o+6LZYrwM=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJkXHncWL3yw9qfJh6O2jss5+bcpF/8oesNzcUrOoaYL0 kYV6le1OkpZGMS4GGTFFFkezPoxw7e0pnKTScROmDmsTCBDGLg4BWAiOZ8Z/ld6Xln7LHW9yfL7 j2Sm/OOxdk1xDJeLZ2rJKLhu9VVz2TyGf6bq01e9kNK59ca10e+mbwJf8nyOPc4fA7wVLA6oNz1 bxwMA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The flexible array member 'buffer' in 'omap_sham_reqctx' is always
allocated with BUFLEN bytes. Replace the flexible array with a
fixed-size array and remove the now-redundant 'buflen' field.

Since 'struct omap_sham_reqctx' now includes the buffer, simplify
'reqsize' and 'statesize' and use an offsetof-based memcpy() in
omap_sham_export() and omap_sham_import().

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/omap-sham.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 6a3c7f9277cf..b8c416c5ee70 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -147,7 +147,6 @@ struct omap_sham_reqctx {
 	u8			digest[SHA512_DIGEST_SIZE] OMAP_ALIGNED;
 	size_t			digcnt;
 	size_t			bufcnt;
-	size_t			buflen;
 
 	/* walk state */
 	struct scatterlist	*sg;
@@ -156,7 +155,7 @@ struct omap_sham_reqctx {
 	int			sg_len;
 	unsigned int		total;	/* total request */
 
-	u8			buffer[] OMAP_ALIGNED;
+	u8			buffer[BUFLEN] OMAP_ALIGNED;
 };
 
 struct omap_sham_hmac_ctx {
@@ -891,7 +890,7 @@ static int omap_sham_prepare_request(struct crypto_engine *engine, void *areq)
 	if (hash_later < 0)
 		hash_later = 0;
 
-	if (hash_later && hash_later <= rctx->buflen) {
+	if (hash_later && hash_later <= sizeof(rctx->buffer)) {
 		scatterwalk_map_and_copy(rctx->buffer,
 					 req->src,
 					 req->nbytes - hash_later,
@@ -902,7 +901,7 @@ static int omap_sham_prepare_request(struct crypto_engine *engine, void *areq)
 		rctx->bufcnt = 0;
 	}
 
-	if (hash_later > rctx->buflen)
+	if (hash_later > sizeof(rctx->buffer))
 		set_bit(FLAGS_HUGE, &rctx->dd->flags);
 
 	rctx->total = min(nbytes, rctx->total);
@@ -987,7 +986,6 @@ static int omap_sham_init(struct ahash_request *req)
 	ctx->digcnt = 0;
 	ctx->total = 0;
 	ctx->offset = 0;
-	ctx->buflen = BUFLEN;
 
 	if (tctx->flags & BIT(FLAGS_HMAC)) {
 		if (!test_bit(FLAGS_AUTO_XOR, &dd->flags)) {
@@ -1200,7 +1198,7 @@ static int omap_sham_update(struct ahash_request *req)
 	if (!req->nbytes)
 		return 0;
 
-	if (ctx->bufcnt + req->nbytes <= ctx->buflen) {
+	if (ctx->bufcnt + req->nbytes <= sizeof(ctx->buffer)) {
 		scatterwalk_map_and_copy(ctx->buffer + ctx->bufcnt, req->src,
 					 0, req->nbytes, 0);
 		ctx->bufcnt += req->nbytes;
@@ -1333,7 +1331,7 @@ static int omap_sham_cra_init_alg(struct crypto_tfm *tfm, const char *alg_base)
 	}
 
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
-				 sizeof(struct omap_sham_reqctx) + BUFLEN);
+				 sizeof(struct omap_sham_reqctx));
 
 	if (alg_base) {
 		struct omap_sham_hmac_ctx *bctx = tctx->base;
@@ -1404,7 +1402,8 @@ static int omap_sham_export(struct ahash_request *req, void *out)
 {
 	struct omap_sham_reqctx *rctx = ahash_request_ctx(req);
 
-	memcpy(out, rctx, sizeof(*rctx) + rctx->bufcnt);
+	memcpy(out, rctx, offsetof(struct omap_sham_reqctx, buffer) +
+			  rctx->bufcnt);
 
 	return 0;
 }
@@ -1414,7 +1413,8 @@ static int omap_sham_import(struct ahash_request *req, const void *in)
 	struct omap_sham_reqctx *rctx = ahash_request_ctx(req);
 	const struct omap_sham_reqctx *ctx_in = in;
 
-	memcpy(rctx, in, sizeof(*rctx) + ctx_in->bufcnt);
+	memcpy(rctx, in, offsetof(struct omap_sham_reqctx, buffer) +
+			 ctx_in->bufcnt);
 
 	return 0;
 }
@@ -2146,8 +2146,7 @@ static int omap_sham_probe(struct platform_device *pdev)
 			alg = &ealg->base;
 			alg->export = omap_sham_export;
 			alg->import = omap_sham_import;
-			alg->halg.statesize = sizeof(struct omap_sham_reqctx) +
-					      BUFLEN;
+			alg->halg.statesize = sizeof(struct omap_sham_reqctx);
 			err = crypto_engine_register_ahash(ealg);
 			if (err)
 				goto err_algs;
