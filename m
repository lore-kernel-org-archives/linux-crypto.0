Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914E626E718
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 04:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779164553; cv=none; b=JriH97We2KX2545nWP10pPADQ3pWKIvWATjpDoN8P7WBCXgbeddewm5DCzlmj6NhR74bPxlUR9UHXRR7dor9V8xlXwP/BXZRuaaCZRcSID2gKmBzrud4lERWJEtOSIjQyHEJW76Kmr0oquPC4ASY8FzwIyzAx3MxGnJoRYQlSsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779164553; c=relaxed/simple;
	bh=jf/CIwSHS/VbOBHj0dUfSnL3NSH2a1wavlZ/MxhDvDY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=p3rAXlshzgAm//q5X9LOPyZNzbEuABQSAIoiBTFq3QhYM9FSmhgbbcOBfjkTkpKjRUPOuP1PxM30sWOw4Pbf9OdsVdUazEhZQ0SWnev91C5DYXuys3w/pwrRL0B+k9M8WGUUrF8cIZulH6qb5FdkKCt11WkCLMd3Dc39VV9ep4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=KbC8kikj; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="KbC8kikj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	Cc:To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=qZjQBOVg0by004ZvzWqcIHOkV8nyS9YnwoytIw31BgI=; b=KbC8k
	ikj2FsQsWx8N7kniTQQkHjivx84EZThnxv3yxTuKb0QqYMqIjAquL8abp8F0H2+fPFUSFeGGEHn8z
	E2dAGdLjk4Y0Xn5p8IWQBx+MQ4toZdSti8DbAhrGCoKoKPFSZ7t6/HjKK3G4ZU5bAvqld1CeFOXJB
	/WwEwX2uLkPAgGscUAhcX+WhAfr/HN5dASvMvn4O4cgwwiUcnfl7PyQq/Eh+9lqkh9b2ZEG5xfXqr
	f8Fin4sU2Lvru9ntGHGW2xQDYs4svCEXG0J4eWq1vuS0Ty6QISPDLb85SpxejI0Zkw+cNNsYYEZbO
	2rBUb4/apTb5dZm1LBBFWdYeGMghA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wPByE-00FMST-38;
	Tue, 19 May 2026 12:22:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 19 May 2026 12:22:18 +0800
Date: Tue, 19 May 2026 12:22:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Akhil R <akhilrajeev@nvidia.com>
Cc: Patrick Talbert <ptalbert@redhat.com>,
	Vladislav Dronov <vdronov@redhat.com>
Subject: [PATCH] crypto: tegra - Fix dma_free_coherent size error
Message-ID: <agvleqNqloWB6tpf@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

When freeing a coherent DMA buffer, the size must match the value
that was used during the allocation.

Unfortunately the size field in the tegra driver gets overwritten
by this point so it no longer matches and creates a warning.

Fix this by saving a copy of the size on the stack.

Note that the ccm function actually mixes up the inbuf and outbuf
sizes, but it doesn't matter because the two sizes are actually
equal.

Fixes: 1cb328da4e8f ("crypto: tegra - Do not use fixed size buffers")
Reporeted-by: Patrick Talbert <ptalbert@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index 30c78afe3dea..5086e7f140c3 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -1201,6 +1201,7 @@ static int tegra_ccm_do_one_req(struct crypto_engine *engine, void *areq)
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct tegra_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct tegra_se *se = ctx->se;
+	unsigned int bufsize;
 	int ret;
 
 	ret = tegra_ccm_crypt_init(req, se, rctx);
@@ -1210,14 +1211,15 @@ static int tegra_ccm_do_one_req(struct crypto_engine *engine, void *areq)
 	rctx->key_id = ctx->key_id;
 
 	/* Allocate buffers required */
-	rctx->inbuf.size = rctx->assoclen + rctx->authsize + rctx->cryptlen + 100;
-	rctx->inbuf.buf = dma_alloc_coherent(ctx->se->dev, rctx->inbuf.size,
+	bufsize = rctx->assoclen + rctx->authsize + rctx->cryptlen + 100;
+	rctx->inbuf.size = bufsize;
+	rctx->inbuf.buf = dma_alloc_coherent(ctx->se->dev, bufsize,
 					     &rctx->inbuf.addr, GFP_KERNEL);
 	if (!rctx->inbuf.buf)
 		goto out_finalize;
 
-	rctx->outbuf.size = rctx->assoclen + rctx->authsize + rctx->cryptlen + 100;
-	rctx->outbuf.buf = dma_alloc_coherent(ctx->se->dev, rctx->outbuf.size,
+	rctx->outbuf.size = bufsize;
+	rctx->outbuf.buf = dma_alloc_coherent(ctx->se->dev, bufsize,
 					      &rctx->outbuf.addr, GFP_KERNEL);
 	if (!rctx->outbuf.buf) {
 		ret = -ENOMEM;
@@ -1254,11 +1256,11 @@ static int tegra_ccm_do_one_req(struct crypto_engine *engine, void *areq)
 	}
 
 out:
-	dma_free_coherent(ctx->se->dev, rctx->inbuf.size,
+	dma_free_coherent(ctx->se->dev, bufsize,
 			  rctx->outbuf.buf, rctx->outbuf.addr);
 
 out_free_inbuf:
-	dma_free_coherent(ctx->se->dev, rctx->outbuf.size,
+	dma_free_coherent(ctx->se->dev, bufsize,
 			  rctx->inbuf.buf, rctx->inbuf.addr);
 
 	if (tegra_key_is_reserved(rctx->key_id))
@@ -1278,6 +1280,7 @@ static int tegra_gcm_do_one_req(struct crypto_engine *engine, void *areq)
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct tegra_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct tegra_aead_reqctx *rctx = aead_request_ctx(req);
+	unsigned int bufsize;
 	int ret;
 
 	rctx->src_sg = req->src;
@@ -1296,16 +1299,17 @@ static int tegra_gcm_do_one_req(struct crypto_engine *engine, void *areq)
 	rctx->key_id = ctx->key_id;
 
 	/* Allocate buffers required */
-	rctx->inbuf.size = rctx->assoclen + rctx->authsize + rctx->cryptlen;
-	rctx->inbuf.buf = dma_alloc_coherent(ctx->se->dev, rctx->inbuf.size,
+	bufsize = rctx->assoclen + rctx->authsize + rctx->cryptlen;
+	rctx->inbuf.size = bufsize;
+	rctx->inbuf.buf = dma_alloc_coherent(ctx->se->dev, bufsize,
 					     &rctx->inbuf.addr, GFP_KERNEL);
 	if (!rctx->inbuf.buf) {
 		ret = -ENOMEM;
 		goto out_finalize;
 	}
 
-	rctx->outbuf.size = rctx->assoclen + rctx->authsize + rctx->cryptlen;
-	rctx->outbuf.buf = dma_alloc_coherent(ctx->se->dev, rctx->outbuf.size,
+	rctx->outbuf.size = bufsize;
+	rctx->outbuf.buf = dma_alloc_coherent(ctx->se->dev, bufsize,
 					      &rctx->outbuf.addr, GFP_KERNEL);
 	if (!rctx->outbuf.buf) {
 		ret = -ENOMEM;
@@ -1342,11 +1346,11 @@ static int tegra_gcm_do_one_req(struct crypto_engine *engine, void *areq)
 		ret = tegra_gcm_do_verify(ctx->se, rctx);
 
 out:
-	dma_free_coherent(ctx->se->dev, rctx->outbuf.size,
+	dma_free_coherent(ctx->se->dev, bufsize,
 			  rctx->outbuf.buf, rctx->outbuf.addr);
 
 out_free_inbuf:
-	dma_free_coherent(ctx->se->dev, rctx->inbuf.size,
+	dma_free_coherent(ctx->se->dev, bufsize,
 			  rctx->inbuf.buf, rctx->inbuf.addr);
 
 	if (tegra_key_is_reserved(rctx->key_id))
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
