Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EC21E7C19
	for <linux-crypto@vger.kernel.org>; Tue, 13 May 2025 06:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747116243; cv=none; b=X27hOeANjyCQStXpKaaoaNZBh2GRavdvwtV7kvhF0fjR3av0oSeP/Qn9JKy/Y9pODppSdnHu7Xap/C5C/ZdiiBEx3nsii3oWgkjFvJHh8RIITZnPufIG5IIv3aUZGMn4OIZX6Fcde1Ou5zVEJYRKCHBkVfKLW9Sm2G6S6ABnMvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747116243; c=relaxed/simple;
	bh=0ute+jeP6PdZaYXG2n0lv24wB9C8kBikSInytkJQm/I=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=tli4ELg1rcySuZfloAIMrEFM+ZbkUWJ2qWQIqJqR/OMH5Nwt7VYAsnWKYqciE1XHqi/Wa59NHNn4mB18WNZZe7+efxBvAGvxKdPJPx8dhtVI8J2hmnu+Ot49M9cBjVjltKSzFtxNlg9UM2z41hnCW7oP9S7OqAEeB65wIPdSx6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=O7iVStjT; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="O7iVStjT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=HMpZOccRKLHOxt1j9Wb25Ygiudgle05mCvS8XV7VkL4=; b=O7iVStjTolbqkytUZCqVPNDQ57
	hEds29Vg+JmHYMqpgENVxgbOZsjwvJNlO7RcnKPd9jDsdgLEE3ub0BhkPwG13DAKNcox3c0gIMtSu
	Zi6/0R5efmvXloB26C5QxGMw/BPk/EYlpSJWikTk7rEC6Sjf2j3fu3kl25j2KF9Cd46JN4v9wibnS
	tGsKaYoQ9imitw74a3l1GvlO2YHc2nzPfer8y4zl0Gr+64AuoZiWHR6ugQf6/4fEplGTGBKA0okw/
	6NLQt6hr6cYhDJ0W+oue5hakZ3jnYgzxdwz9Vfloj6+0Rg3t8H8XgEUwxto+kc6ICk8sL752Yvd3b
	IFLPmF8Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uEik9-005g55-0s;
	Tue, 13 May 2025 14:03:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 May 2025 14:03:57 +0800
Date: Tue, 13 May 2025 14:03:57 +0800
Message-Id: <889c7e7d5a3e16da52ac39ecafaab2a4a2cf22dc.1747116129.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1747116129.git.herbert@gondor.apana.org.au>
References: <cover.1747116129.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 05/11] crypto: aspeed/hash - Move sham_final call into
 sham_update
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Neal Liu <neal_liu@aspeedtech.com>, linux-aspeed@lists.ozlabs.org
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The only time when sham_final needs to be called in sham_finup
is when the finup request fits into the partial block.  Move this
special handling into sham_update.

The comment about releaseing resources is non-sense.  The Crypto
API does not mandate the use of final so the user could always go
away after an update and never come back.  Therefore the driver
must not hold any resources after an update call.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/aspeed/aspeed-hace-hash.c | 44 +++++++++---------------
 1 file changed, 17 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/aspeed/aspeed-hace-hash.c b/drivers/crypto/aspeed/aspeed-hace-hash.c
index 9f776ec8f5ec..40363159489e 100644
--- a/drivers/crypto/aspeed/aspeed-hace-hash.c
+++ b/drivers/crypto/aspeed/aspeed-hace-hash.c
@@ -508,6 +508,20 @@ static int aspeed_ahash_do_one(struct crypto_engine *engine, void *areq)
 	return aspeed_ahash_do_request(engine, areq);
 }
 
+static int aspeed_sham_final(struct ahash_request *req)
+{
+	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct aspeed_sham_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct aspeed_hace_dev *hace_dev = tctx->hace_dev;
+
+	AHASH_DBG(hace_dev, "req->nbytes:%d, rctx->total:%d\n",
+		  req->nbytes, rctx->total);
+	rctx->op = SHA_OP_FINAL;
+
+	return aspeed_hace_hash_handle_queue(hace_dev, req);
+}
+
 static int aspeed_sham_update(struct ahash_request *req)
 {
 	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
@@ -533,49 +547,25 @@ static int aspeed_sham_update(struct ahash_request *req)
 					 rctx->total, 0);
 		rctx->bufcnt += rctx->total;
 
-		return 0;
+		return rctx->flags & SHA_FLAGS_FINUP ?
+		       aspeed_sham_final(req) : 0;
 	}
 
 	return aspeed_hace_hash_handle_queue(hace_dev, req);
 }
 
-static int aspeed_sham_final(struct ahash_request *req)
-{
-	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct aspeed_sham_ctx *tctx = crypto_ahash_ctx(tfm);
-	struct aspeed_hace_dev *hace_dev = tctx->hace_dev;
-
-	AHASH_DBG(hace_dev, "req->nbytes:%d, rctx->total:%d\n",
-		  req->nbytes, rctx->total);
-	rctx->op = SHA_OP_FINAL;
-
-	return aspeed_hace_hash_handle_queue(hace_dev, req);
-}
-
 static int aspeed_sham_finup(struct ahash_request *req)
 {
 	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct aspeed_sham_ctx *tctx = crypto_ahash_ctx(tfm);
 	struct aspeed_hace_dev *hace_dev = tctx->hace_dev;
-	int rc1, rc2;
 
 	AHASH_DBG(hace_dev, "req->nbytes: %d\n", req->nbytes);
 
 	rctx->flags |= SHA_FLAGS_FINUP;
 
-	rc1 = aspeed_sham_update(req);
-	if (rc1 == -EINPROGRESS || rc1 == -EBUSY)
-		return rc1;
-
-	/*
-	 * final() has to be always called to cleanup resources
-	 * even if update() failed, except EINPROGRESS
-	 */
-	rc2 = aspeed_sham_final(req);
-
-	return rc1 ? : rc2;
+	return aspeed_sham_update(req);
 }
 
 static int aspeed_sham_init(struct ahash_request *req)
-- 
2.39.5

