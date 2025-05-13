Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E531E5716
	for <linux-crypto@vger.kernel.org>; Tue, 13 May 2025 06:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747116254; cv=none; b=WqYR58WTPcVLsE/Xg9AVE5C0I32vKucSyj1EXdbPWJVzW7eKpmblj3bTjy2Cr/FTW48H76tmvKjN8i4hiRJImJMJwSeBqti5wm5G/GakLTBI2eaFCPZTUg9M18Nr3meUKxlmczm1mNGmWmjVzU4HlEj2DW4Q3dW9JrsNl7Urrrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747116254; c=relaxed/simple;
	bh=iHLk7g8HZqrsC3krvdOnPwzjfXrHSxOjJCcJ0gFnPtc=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=bD4ecUmovLsKo+kK2zGwMknOxej1MHLx60gY2rbJwYDEzum1ZwiNGt0hNZUTqS8ks7+39pwVsyOaxTSbBXfJcxchkuSFNzFWwgceSAAAIKX9d7jf4cGwIwYFIjmRCl10ab8ecpR2JtcmslSzsDBbHcFvC4TWn+x+HHAgFSTCYIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=hnWzLsd2; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="hnWzLsd2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=YtbPXCKTJTfVRBwW69ucyOwIwYNsPWN2tleTB/ubpxg=; b=hnWzLsd2L7ybq9pKNMi/l8hSdc
	le51/xbtX4+m/8YBjDabSfMTkL0/C7y3fN6xt5UN5bSgrb6SqWqpIfHSx+bOlNneBbPL+mFA7oT9H
	WUg2rCYkIhRMf76u4IRHizZExfqVC+0s1+Tlx5Y+nM+S5GT3eM2qhZ7yn5sAx/xzGk7G31I+NNJeE
	9xOE+qZVregnxepb6Q5McawKSxK9sfJqidy5lMy2T0y6thJqpM7UEOefv9f+yPYhX6KdBtId/xnhB
	47DnGNkgXSXP9b5wg6rAaJl8LP7LBRIVg2CCdrfOMPUXrbCYblY2wiQ5N7gCw382CpYdyFYPAlILn
	YwX6leKA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uEikK-005g6g-2d;
	Tue, 13 May 2025 14:04:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 May 2025 14:04:08 +0800
Date: Tue, 13 May 2025 14:04:08 +0800
Message-Id: <6f8527f3ece07d4fca7f49b84059462f20e583ec.1747116129.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1747116129.git.herbert@gondor.apana.org.au>
References: <cover.1747116129.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 10/11] crypto: aspeed/hash - Iterate on large hashes in
 dma_prepare
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Neal Liu <neal_liu@aspeedtech.com>, linux-aspeed@lists.ozlabs.org
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Rather than failing a hash larger than ASPEED_CRYPTO_SRC_DMA_BUF_LEN,
just hash them over and over again until it's done.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/aspeed/aspeed-hace-hash.c | 36 +++++++++++++++---------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/aspeed/aspeed-hace-hash.c b/drivers/crypto/aspeed/aspeed-hace-hash.c
index 3bfb7db96c40..fc2154947ec8 100644
--- a/drivers/crypto/aspeed/aspeed-hace-hash.c
+++ b/drivers/crypto/aspeed/aspeed-hace-hash.c
@@ -155,26 +155,30 @@ static int aspeed_ahash_dma_prepare(struct aspeed_hace_dev *hace_dev)
 	struct aspeed_engine_hash *hash_engine = &hace_dev->hash_engine;
 	struct ahash_request *req = hash_engine->req;
 	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
-	bool final = rctx->flags & SHA_FLAGS_FINUP;
 	unsigned int length, remain;
+	bool final = false;
 
-	length = rctx->total;
-	remain = final ? 0 : length % rctx->block_size;
+	length = rctx->total - rctx->offset;
+	remain = length - round_down(length, rctx->block_size);
 
 	AHASH_DBG(hace_dev, "length:0x%x, remain:0x%x\n", length, remain);
 
-	if ((final ? round_up(length, rctx->block_size) + rctx->block_size :
-		     length) > ASPEED_CRYPTO_SRC_DMA_BUF_LEN) {
-		dev_warn(hace_dev->dev, "Hash data length is too large\n");
-		return -EINVAL;
-	}
-
+	if (length > ASPEED_HASH_SRC_DMA_BUF_LEN)
+		length = ASPEED_HASH_SRC_DMA_BUF_LEN;
+	else if (rctx->flags & SHA_FLAGS_FINUP) {
+		if (round_up(length, rctx->block_size) + rctx->block_size >
+		    ASPEED_CRYPTO_SRC_DMA_BUF_LEN)
+			length = round_down(length - 1, rctx->block_size);
+		else
+			final = true;
+	} else
+		length -= remain;
 	scatterwalk_map_and_copy(hash_engine->ahash_src_addr, rctx->src_sg,
-				 rctx->offset, rctx->total - remain, 0);
-	rctx->offset += rctx->total - remain;
+				 rctx->offset, length, 0);
+	rctx->offset += length;
 
-	rctx->digcnt[0] += rctx->total - remain;
-	if (rctx->digcnt[0] < rctx->total - remain)
+	rctx->digcnt[0] += length;
+	if (rctx->digcnt[0] < length)
 		rctx->digcnt[1]++;
 
 	if (final)
@@ -189,7 +193,7 @@ static int aspeed_ahash_dma_prepare(struct aspeed_hace_dev *hace_dev)
 		return -ENOMEM;
 	}
 
-	hash_engine->src_length = length - remain;
+	hash_engine->src_length = length;
 	hash_engine->src_dma = hash_engine->ahash_src_dma_addr;
 	hash_engine->digest_dma = rctx->digest_dma_addr;
 
@@ -385,6 +389,10 @@ static int aspeed_ahash_update_resume(struct aspeed_hace_dev *hace_dev)
 	dma_unmap_single(hace_dev->dev, rctx->digest_dma_addr,
 			 SHA512_DIGEST_SIZE, DMA_BIDIRECTIONAL);
 
+	if (rctx->total - rctx->offset >= rctx->block_size ||
+	    (rctx->total != rctx->offset && rctx->flags & SHA_FLAGS_FINUP))
+		return aspeed_ahash_req_update(hace_dev);
+
 	return aspeed_ahash_complete(hace_dev);
 }
 
-- 
2.39.5

