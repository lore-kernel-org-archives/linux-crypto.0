Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0EE1E8333
	for <linux-crypto@vger.kernel.org>; Tue, 13 May 2025 06:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747116245; cv=none; b=tKxVRoLoIZqyp8YAy6tm5YmWu8lmYBZMIVxBOFuRruD08nVYj4845hHNmGgU3GYRCCTq/mJYb02fxTWVcRx6DpJzw6JaMYhONZARgByrOp+K7xOGAgTIR23qggWSu0OPJnfwTUOhik8ZFvV5YAwratJoDMx4D3xSPU90LL+5weg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747116245; c=relaxed/simple;
	bh=0qFK3kRKOB5cerPHWmHKHvEOuGUWIZ/DEEiNBKlKim8=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=dr8/8QYi7bBWDSM/7Y9w3Qiwo9nnqwtET3zs9/KW1UyYFhKpOsU6UG0G8+uD0JNvG/SzhjSuKX3Oy07egMTCyEf7Zv9LHj7sy8qKos5sFvWzndKV/dm4bP81V5H73+OSJvxRS5AcfbCTYAFvnyah/FX+/koVT9cBCd2nHCgj/Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=CJjtnEHD; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="CJjtnEHD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=CD9BMpmVjGPJ6XdNaixWC02LuRV2gzAIiirjItpgEnU=; b=CJjtnEHD8etfMeS4pTaJXvRevV
	Ml9CemH3NE8Fbdt6XOlj4Q8gCFgT83qx6br72UAfaLyIpPCcO9rq6u1uKVJccNmDQVjB9DaGO9ASs
	zAss1yO4g3vCyo/H2f24ReZ5Dye5gu4hnKWSc01mZSAN8ouuxhEpJItIkVNUY0pomPPj61WdgtIcs
	m2U0/rlkMYrnZ7JRw25XaV1yWpN4ZW0pJIOptPoEQnOrihgUc35Ox78wBZHsgfRX4PPgHQns9B9wt
	QJ+jGWTrBO9udv5Ekp6iUbnRJrO1E29MWiRPXPq1kEfa8A1n+5NvknOXAsPN9zmkwjXL2ISSqC/py
	FgjptRfw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uEikB-005g5I-1s;
	Tue, 13 May 2025 14:04:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 May 2025 14:03:59 +0800
Date: Tue, 13 May 2025 14:03:59 +0800
Message-Id: <e5f9015032207aea18724b3be618118ed6bceb95.1747116129.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1747116129.git.herbert@gondor.apana.org.au>
References: <cover.1747116129.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 06/11] crypto: aspeed/hash - Move final padding into
 dma_prepare
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Neal Liu <neal_liu@aspeedtech.com>, linux-aspeed@lists.ozlabs.org
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Rather than processing a final as two separate updates, combine
them into one for the linear dma_prepare case.

This means that the total hash size is slightly reduced, but that
will be fixed up later by repeating the hash if necessary.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/aspeed/aspeed-hace-hash.c | 29 ++++++++++++++----------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/aspeed/aspeed-hace-hash.c b/drivers/crypto/aspeed/aspeed-hace-hash.c
index 40363159489e..ceea2e2f5658 100644
--- a/drivers/crypto/aspeed/aspeed-hace-hash.c
+++ b/drivers/crypto/aspeed/aspeed-hace-hash.c
@@ -114,29 +114,34 @@ static int aspeed_ahash_dma_prepare(struct aspeed_hace_dev *hace_dev)
 	struct aspeed_engine_hash *hash_engine = &hace_dev->hash_engine;
 	struct ahash_request *req = hash_engine->req;
 	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
-	int length, remain;
+	bool final = rctx->flags & SHA_FLAGS_FINUP;
+	unsigned int length, remain;
 
 	length = rctx->total + rctx->bufcnt;
-	remain = length % rctx->block_size;
+	remain = final ? 0 : length % rctx->block_size;
 
 	AHASH_DBG(hace_dev, "length:0x%x, remain:0x%x\n", length, remain);
 
 	if (rctx->bufcnt)
 		memcpy(hash_engine->ahash_src_addr, rctx->buffer, rctx->bufcnt);
 
-	if (rctx->total + rctx->bufcnt < ASPEED_CRYPTO_SRC_DMA_BUF_LEN) {
-		scatterwalk_map_and_copy(hash_engine->ahash_src_addr +
-					 rctx->bufcnt, rctx->src_sg,
-					 rctx->offset, rctx->total - remain, 0);
-		rctx->offset += rctx->total - remain;
-
-	} else {
+	if ((final ? round_up(length, rctx->block_size) + rctx->block_size :
+		     length) > ASPEED_CRYPTO_SRC_DMA_BUF_LEN) {
 		dev_warn(hace_dev->dev, "Hash data length is too large\n");
 		return -EINVAL;
 	}
 
-	scatterwalk_map_and_copy(rctx->buffer, rctx->src_sg,
-				 rctx->offset, remain, 0);
+	scatterwalk_map_and_copy(hash_engine->ahash_src_addr +
+				 rctx->bufcnt, rctx->src_sg,
+				 rctx->offset, rctx->total - remain, 0);
+	rctx->offset += rctx->total - remain;
+
+	if (final)
+		length += aspeed_ahash_fill_padding(
+			hace_dev, rctx, hash_engine->ahash_src_addr + length);
+	else
+		scatterwalk_map_and_copy(rctx->buffer, rctx->src_sg,
+					 rctx->offset, remain, 0);
 
 	rctx->bufcnt = remain;
 	rctx->digest_dma_addr = dma_map_single(hace_dev->dev, rctx->digest,
@@ -423,7 +428,7 @@ static int aspeed_ahash_update_resume(struct aspeed_hace_dev *hace_dev)
 			 SHA512_DIGEST_SIZE, DMA_BIDIRECTIONAL);
 
 	if (rctx->flags & SHA_FLAGS_FINUP)
-		return aspeed_ahash_req_final(hace_dev);
+		memcpy(req->result, rctx->digest, rctx->digsize);
 
 	return aspeed_ahash_complete(hace_dev);
 }
-- 
2.39.5

