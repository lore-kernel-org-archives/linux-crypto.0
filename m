Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0671A5BA2
	for <linux-crypto@vger.kernel.org>; Wed, 26 Mar 2025 09:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742980642; cv=none; b=gkFSz0Wgc0x/dU5uE/yB0iXu3wjTshRyr6OQlDMGPB3uKFfwPQpisNKl896wDwduAqdKXBDJG6AUraiSMR5irxqNIH5hpBv8B15haQ5MIbNMN1TgL1HR/eDOmGHslT2E+K+AIEeW5DbaRl/g9AMqYusHw74pyLWcKjSIRcBzPEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742980642; c=relaxed/simple;
	bh=2YiNDN2k4e28Wnew2YTaNir8Wum5rxTwpgelD7ATmFs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DuLtwXZaYAn3DaSMdGs7rAdsYrFCAXWQ3U+jaw/GiAuGH5EtWqanezLbPKJTyFvofhZwy2AfQzTkaUZsBVHw48LQUEI6Sxnx/cwNIA6t063vCvD7t/Hdnxok5imJ9lgNSHn7KMk4Ty3loQStJsji/tB7TfyjBS/0ZwWArEnTCWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=MoUddKtP; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="MoUddKtP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=o/VsaC/pS8kkDovMrg5xr0SCoMHiahOxD9pWS31qoJc=; b=MoUddKtPtNhMsW0sbsMni77kFo
	VwMmAWvinVb2y5KJM/NHNot079dDnIcbYBOHwaLL58JMVDneFZYcc8dxXxYGVJQT0W5cvsuuBs1os
	1MHVjR5V5Tqtuhu6ObAH0wP2ewz5jPKUQZR8fLih3YVvZz75fCYPEzS8YESvO352ShsJ2DbhdeWGB
	XU4X5esLIe278BXUdjSbfcNqT/OGC9GLJeOiLHxEKqiJB46ulAUe6kPOjmzJ2rC5e6J3G+oei93JM
	GVFcGvc4iBdIPpuqoX/XHw/E71o+ALKPAaG4pO4brpu3uoRKnImcZFT0aypnpPrj2lJPccHTZYHr1
	/kGECLlA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1txMsk-00AEjL-2L;
	Wed, 26 Mar 2025 17:17:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 26 Mar 2025 17:17:06 +0800
Date: Wed, 26 Mar 2025 17:17:06 +0800
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
Subject: [PATCH] crypto: sa2ul - Use proper helpers to setup request
Message-ID: <Z-PGEtO8JmyC5xU_@gondor.apana.org.au>
References: <cover.1739674648.git.herbert@gondor.apana.org.au>
 <2620cdada3777a66d3600cd1887cd34245d1e26a.1739674648.git.herbert@gondor.apana.org.au>
 <20250326090035.izxxf3sboom7hvcv@uda0497581-HP>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250326090035.izxxf3sboom7hvcv@uda0497581-HP>

On Wed, Mar 26, 2025 at 02:30:35PM +0530, Manorit Chawdhry wrote:
>
> The following patch seems to be breaking selftests in SA2UL driver.

Thanks for the report.

This patch should fix the problem:

---8<---
Rather than setting up a request by hand, use the correct API helpers
to setup the new request.  This is because the API helpers will setup
chaining.

Also change the fallback allocation to explicitly request for a
sync algorithm as this driver will crash if given an async one.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 091612b066f1..8fae14043262 100644
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
@@ -1601,12 +1574,8 @@ static int sa_sha_finup(struct ahash_request *req)
 static int sa_sha_import(struct ahash_request *req, const void *in)
 {
 	struct sa_sha_req_ctx *rctx = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct sa_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
 
-	ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback.ahash);
-	rctx->fallback_req.base.flags = req->base.flags &
-		CRYPTO_TFM_REQ_MAY_SLEEP;
+	ahash_request_set_callback(&rctx->fallback_req, req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP, NULL, NULL);
 
 	return crypto_ahash_import(&rctx->fallback_req, in);
 }
@@ -1614,12 +1583,9 @@ static int sa_sha_import(struct ahash_request *req, const void *in)
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
