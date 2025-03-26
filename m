Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B499A1B0439
	for <linux-crypto@vger.kernel.org>; Wed, 26 Mar 2025 10:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742983546; cv=none; b=X0X8YYQeqlPgMJwfHg629ZX69z2uirkAmmaioG4dho7A+hzflmAKby3pkOF1vsunUs/yRs8lU/WbAogxdBEUDQWADl7/HOBhEYfsmrYcsE3guXaWjHinKUoyeSinyX0BdPKE82eGto//qhTCUJLe+iGO7ZY/IznCT1ePNebUEMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742983546; c=relaxed/simple;
	bh=hYUuJe5mGdE8+AQVnuUhumQoqb0t8hLJV++qN9VrDgY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LxxxHYqFm2qQjm7h+b89wkNCQb9mAuZlgC2DQ59rB9tDPTZ7wuO6l5fa81p4iWjNlqdgcIYjwLtckYjIzNz38AwQlZwmFujxIbYcONTaXp5Y7leHUjqajTojKj46/qqoSkEkGuXFA8d16oe3ILh2pSmdVR6gShF67k15+YIJKO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=aXKR2RR1; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="aXKR2RR1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5Vkz/ySTjl6ViHHLOA6MIsaQxnusZcW+/bU67fCvxGo=; b=aXKR2RR1RWBdNY2xb83BBJ96m5
	8kZOAv7/hH8Or/9GuSR4nTC2XLFVvxk2JwMAdso9g8TYzJQnJWc61nkgbkHmni942o1Eiv/QClF2J
	JobrvafSlzu4d5ngO7MBcMYZW2ZPdF+QDdQwhbQabkhepm/hzk1yiXOMzWJAVpQkvGGoUVgBo36np
	VLT2L0OeZ9uF49ob9puCx296Yk1Zp8ofVCqqx6nCim5zRUed5WavzHebafOBOAfC0sDFVP1VdyHbE
	IH/HBTjGv1TbHr0nduVZlyQ5tnbuPu5cnX0MpS4DoqwAP8qddJaFj7MZV3PWNohcxYLonRiWPJvRd
	sa/TCSNQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1txNdi-00AFH8-1c;
	Wed, 26 Mar 2025 18:05:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 26 Mar 2025 18:05:38 +0800
Date: Wed, 26 Mar 2025 18:05:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Manorit Chawdhry <m-chawdhry@ti.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Megha Dey <megha.dey@linux.intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>, Udit Kumar <u-kumar1@ti.com>,
	Pratham T <t-pratham@ti.com>
Subject: [v2 PATCH] crypto: sa2ul - Use proper helpers to setup request
Message-ID: <Z-PRckWg9Yw1hOVj@gondor.apana.org.au>
References: <cover.1739674648.git.herbert@gondor.apana.org.au>
 <2620cdada3777a66d3600cd1887cd34245d1e26a.1739674648.git.herbert@gondor.apana.org.au>
 <20250326090035.izxxf3sboom7hvcv@uda0497581-HP>
 <Z-PGEtO8JmyC5xU_@gondor.apana.org.au>
 <20250326100027.trel4le7mpadtaft@uda0497581-HP>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250326100027.trel4le7mpadtaft@uda0497581-HP>

On Wed, Mar 26, 2025 at 03:30:27PM +0530, Manorit Chawdhry wrote:
>
> Thanks for the quick fix, though now I see error in import rather than
> init which was there previously.

Oops, I removed one line too many from the import function.  It
should set the tfm just like init:

---8<---
Rather than setting up a request by hand, use the correct API helpers
to setup the new request.  This is because the API helpers will setup
chaining.

Also change the fallback allocation to explicitly request for a
sync algorithm as this driver will crash if given an async one.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 091612b066f1..fdc0b2486069 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1415,22 +1415,13 @@ static int sa_sha_run(struct ahash_request *req)
 	    (auth_len >= SA_UNSAFE_DATA_SZ_MIN &&
 	     auth_len <= SA_UNSAFE_DATA_SZ_MAX)) {
 		struct ahash_request *subreq = &rctx->fallback_req;
-		int ret = 0;
+		int ret;
 
 		ahash_request_set_tfm(subreq, ctx->fallback.ahash);
-		subreq->base.flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP;
+		ahash_request_set_callback(subreq, req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP, NULL, NULL);
+		ahash_request_set_crypt(subreq, req->src, req->result, auth_len);
 
-		crypto_ahash_init(subreq);
-
-		subreq->nbytes = auth_len;
-		subreq->src = req->src;
-		subreq->result = req->result;
-
-		ret |= crypto_ahash_update(subreq);
-
-		subreq->nbytes = 0;
-
-		ret |= crypto_ahash_final(subreq);
+		ret = crypto_ahash_digest(subreq);
 
 		return ret;
 	}
@@ -1502,8 +1493,7 @@ static int sa_sha_cra_init_alg(struct crypto_tfm *tfm, const char *alg_base)
 		return ret;
 
 	if (alg_base) {
-		ctx->shash = crypto_alloc_shash(alg_base, 0,
-						CRYPTO_ALG_NEED_FALLBACK);
+		ctx->shash = crypto_alloc_shash(alg_base, 0, 0);
 		if (IS_ERR(ctx->shash)) {
 			dev_err(sa_k3_dev, "base driver %s couldn't be loaded\n",
 				alg_base);
@@ -1511,8 +1501,7 @@ static int sa_sha_cra_init_alg(struct crypto_tfm *tfm, const char *alg_base)
 		}
 		/* for fallback */
 		ctx->fallback.ahash =
-			crypto_alloc_ahash(alg_base, 0,
-					   CRYPTO_ALG_NEED_FALLBACK);
+			crypto_alloc_ahash(alg_base, 0, CRYPTO_ALG_ASYNC);
 		if (IS_ERR(ctx->fallback.ahash)) {
 			dev_err(ctx->dev_data->dev,
 				"Could not load fallback driver\n");
@@ -1546,54 +1535,38 @@ static int sa_sha_init(struct ahash_request *req)
 		crypto_ahash_digestsize(tfm), rctx);
 
 	ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback.ahash);
-	rctx->fallback_req.base.flags =
-		req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP;
+	ahash_request_set_callback(&rctx->fallback_req, req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP, NULL, NULL);
+	ahash_request_set_crypt(&rctx->fallback_req, NULL, NULL, 0);
 
 	return crypto_ahash_init(&rctx->fallback_req);
 }
 
 static int sa_sha_update(struct ahash_request *req)
 {
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct sa_sha_req_ctx *rctx = ahash_request_ctx(req);
-	struct sa_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
 
-	ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback.ahash);
-	rctx->fallback_req.base.flags =
-		req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP;
-	rctx->fallback_req.nbytes = req->nbytes;
-	rctx->fallback_req.src = req->src;
+	ahash_request_set_callback(&rctx->fallback_req, req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP, NULL, NULL);
+	ahash_request_set_crypt(&rctx->fallback_req, req->src, NULL, req->nbytes);
 
 	return crypto_ahash_update(&rctx->fallback_req);
 }
 
 static int sa_sha_final(struct ahash_request *req)
 {
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct sa_sha_req_ctx *rctx = ahash_request_ctx(req);
-	struct sa_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
 
-	ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback.ahash);
-	rctx->fallback_req.base.flags =
-		req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP;
-	rctx->fallback_req.result = req->result;
+	ahash_request_set_callback(&rctx->fallback_req, req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP, NULL, NULL);
+	ahash_request_set_crypt(&rctx->fallback_req, NULL, req->result, 0);
 
 	return crypto_ahash_final(&rctx->fallback_req);
 }
 
 static int sa_sha_finup(struct ahash_request *req)
 {
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct sa_sha_req_ctx *rctx = ahash_request_ctx(req);
-	struct sa_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
 
-	ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback.ahash);
-	rctx->fallback_req.base.flags =
-		req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP;
-
-	rctx->fallback_req.nbytes = req->nbytes;
-	rctx->fallback_req.src = req->src;
-	rctx->fallback_req.result = req->result;
+	ahash_request_set_callback(&rctx->fallback_req, req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP, NULL, NULL);
+	ahash_request_set_crypt(&rctx->fallback_req, req->src, req->result, req->nbytes);
 
 	return crypto_ahash_finup(&rctx->fallback_req);
 }
@@ -1605,8 +1578,7 @@ static int sa_sha_import(struct ahash_request *req, const void *in)
 	struct sa_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
 
 	ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback.ahash);
-	rctx->fallback_req.base.flags = req->base.flags &
-		CRYPTO_TFM_REQ_MAY_SLEEP;
+	ahash_request_set_callback(&rctx->fallback_req, req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP, NULL, NULL);
 
 	return crypto_ahash_import(&rctx->fallback_req, in);
 }
@@ -1614,12 +1586,9 @@ static int sa_sha_import(struct ahash_request *req, const void *in)
 static int sa_sha_export(struct ahash_request *req, void *out)
 {
 	struct sa_sha_req_ctx *rctx = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct sa_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct ahash_request *subreq = &rctx->fallback_req;
 
-	ahash_request_set_tfm(subreq, ctx->fallback.ahash);
-	subreq->base.flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP;
+	ahash_request_set_callback(subreq, req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP, NULL, NULL);
 
 	return crypto_ahash_export(subreq, out);
 }
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
