Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED74D7DA93
	for <linux-crypto@vger.kernel.org>; Tue, 13 May 2025 06:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747116258; cv=none; b=t4ZEcbrUPl9TnKzm3fQEYtqyLoDUCJGHY4ep3Jkph5vTByap1TZSXLaUYwDCih+35F6ymtZQB1wqTW98wCBPDEUhpEy9tj8fQmF90NtnBhhFepX0rT1r9cftWcBv8Wz5WdI5DXOdz9yC8ZSIdeB/bdeuQZrDjPkoJm0EPpVINAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747116258; c=relaxed/simple;
	bh=9oWaZmVabCipJMcQm5ydCts5uGroSdWWubBy1PNORFU=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=MF3nblCMmcbKhK5aB0DbwGienK5dppL791Mo1u6gNJ6L4BBoTEfaYEZZrgz+FZREhOBNXYItwL4XDbQoC9gMIQ5xjZaxSKbkt6IlAuW4X60xycUOMzik0qAcAmpluhbGU0kLGjksUGlfjimRB2QlFDEWwK1oxmtNIwWIRQt7FAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=e15yqGdM; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="e15yqGdM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=e0Ab6i77V9pvRivZks+l19R5uBrJGiwyJRdHY4M4Ra4=; b=e15yqGdM0HXuEMFohzZ9qaPUwJ
	SQ5UA2NhI4EtzRDpsDQrLxkeKb1fqxECmRHJU3+DivsqI5evv3u57XWJeyVVAcPtG4uW8YFk6McKZ
	NyIhTw2qMzJc2/JY5DgH+4/NgHQPDGrKY11R4//i5ibm6q8PjEzvPpvLesUYiV4vjI3T+ZvnxCGC/
	RX98qbdhChl+Pq1JLXe8xKibrMzHnZQqoEtqz61ZbQgADAmuMBSWAkveFkZKn4EXnsJOWsBFjUIvb
	5zyFxbNIh2RKzHrIf8UwLQ8Y5fnxCpKTCBMMAGb7+IbdzzYZ6iDt6n0qFr/bsOk2JQZNwqFhpU3zL
	bDxNCHnA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uEikN-005g7I-0J;
	Tue, 13 May 2025 14:04:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 May 2025 14:04:11 +0800
Date: Tue, 13 May 2025 14:04:11 +0800
Message-Id: <11bdba6fa8b5a76d1fb20ca1a7f004b68716431b.1747116129.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1747116129.git.herbert@gondor.apana.org.au>
References: <cover.1747116129.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 11/11] crypto: aspeed/hash - Fix potential overflow in
 dma_prepare_sg
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Neal Liu <neal_liu@aspeedtech.com>, linux-aspeed@lists.ozlabs.org
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The mapped SG lists are written to hash_engine->ahash_src_addr which
has the size ASPEED_HASH_SRC_DMA_BUF_LEN.  Since scatterlists are
not bound in size, make sure that size is not exceeded.

If the mapped SG list is larger than the buffer, simply iterate
over it as is done in the dma_prepare case.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/aspeed/aspeed-hace-hash.c | 84 ++++++++++++------------
 1 file changed, 43 insertions(+), 41 deletions(-)

diff --git a/drivers/crypto/aspeed/aspeed-hace-hash.c b/drivers/crypto/aspeed/aspeed-hace-hash.c
index fc2154947ec8..e54b7dd03be3 100644
--- a/drivers/crypto/aspeed/aspeed-hace-hash.c
+++ b/drivers/crypto/aspeed/aspeed-hace-hash.c
@@ -146,6 +146,15 @@ static int aspeed_ahash_fill_padding(struct aspeed_hace_dev *hace_dev,
 	return padlen + bitslen;
 }
 
+static void aspeed_ahash_update_counter(struct aspeed_sham_reqctx *rctx,
+					unsigned int len)
+{
+	rctx->offset += len;
+	rctx->digcnt[0] += len;
+	if (rctx->digcnt[0] < len)
+		rctx->digcnt[1]++;
+}
+
 /*
  * Prepare DMA buffer before hardware engine
  * processing.
@@ -175,12 +184,7 @@ static int aspeed_ahash_dma_prepare(struct aspeed_hace_dev *hace_dev)
 		length -= remain;
 	scatterwalk_map_and_copy(hash_engine->ahash_src_addr, rctx->src_sg,
 				 rctx->offset, length, 0);
-	rctx->offset += length;
-
-	rctx->digcnt[0] += length;
-	if (rctx->digcnt[0] < length)
-		rctx->digcnt[1]++;
-
+	aspeed_ahash_update_counter(rctx, length);
 	if (final)
 		length += aspeed_ahash_fill_padding(
 			hace_dev, rctx, hash_engine->ahash_src_addr + length);
@@ -210,13 +214,16 @@ static int aspeed_ahash_dma_prepare_sg(struct aspeed_hace_dev *hace_dev)
 	struct ahash_request *req = hash_engine->req;
 	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
 	bool final = rctx->flags & SHA_FLAGS_FINUP;
+	int remain, sg_len, i, max_sg_nents;
+	unsigned int length, offset, total;
 	struct aspeed_sg_list *src_list;
 	struct scatterlist *s;
-	int length, remain, sg_len, i;
 	int rc = 0;
 
-	remain = final ? 0 : rctx->total % rctx->block_size;
-	length = rctx->total - remain;
+	offset = rctx->offset;
+	length = rctx->total - offset;
+	remain = final ? 0 : length - round_down(length, rctx->block_size);
+	length -= remain;
 
 	AHASH_DBG(hace_dev, "%s:0x%x, %s:0x%x, %s:0x%x\n",
 		  "rctx total", rctx->total,
@@ -230,6 +237,8 @@ static int aspeed_ahash_dma_prepare_sg(struct aspeed_hace_dev *hace_dev)
 		goto end;
 	}
 
+	max_sg_nents = ASPEED_HASH_SRC_DMA_BUF_LEN / sizeof(*src_list) - final;
+	sg_len = min(sg_len, max_sg_nents);
 	src_list = (struct aspeed_sg_list *)hash_engine->ahash_src_addr;
 	rctx->digest_dma_addr = dma_map_single(hace_dev->dev, rctx->digest,
 					       SHA512_DIGEST_SIZE,
@@ -240,10 +249,20 @@ static int aspeed_ahash_dma_prepare_sg(struct aspeed_hace_dev *hace_dev)
 		goto free_src_sg;
 	}
 
+	total = 0;
 	for_each_sg(rctx->src_sg, s, sg_len, i) {
 		u32 phy_addr = sg_dma_address(s);
 		u32 len = sg_dma_len(s);
 
+		if (len <= offset) {
+			offset -= len;
+			continue;
+		}
+
+		len -= offset;
+		phy_addr += offset;
+		offset = 0;
+
 		if (length > len)
 			length -= len;
 		else {
@@ -252,24 +271,22 @@ static int aspeed_ahash_dma_prepare_sg(struct aspeed_hace_dev *hace_dev)
 			length = 0;
 		}
 
+		total += len;
 		src_list[i].phy_addr = cpu_to_le32(phy_addr);
 		src_list[i].len = cpu_to_le32(len);
 	}
 
 	if (length != 0) {
-		rc = -EINVAL;
-		goto free_rctx_digest;
+		total = round_down(total, rctx->block_size);
+		final = false;
 	}
 
-	rctx->digcnt[0] += rctx->total - remain;
-	if (rctx->digcnt[0] < rctx->total - remain)
-		rctx->digcnt[1]++;
-
+	aspeed_ahash_update_counter(rctx, total);
 	if (final) {
 		int len = aspeed_ahash_fill_padding(hace_dev, rctx,
 						    rctx->buffer);
 
-		rctx->total += len;
+		total += len;
 		rctx->buffer_dma_addr = dma_map_single(hace_dev->dev,
 						       rctx->buffer,
 						       sizeof(rctx->buffer),
@@ -286,8 +303,7 @@ static int aspeed_ahash_dma_prepare_sg(struct aspeed_hace_dev *hace_dev)
 	}
 	src_list[i - 1].len |= cpu_to_le32(HASH_SG_LAST_LIST);
 
-	rctx->offset = rctx->total - remain;
-	hash_engine->src_length = rctx->total - remain;
+	hash_engine->src_length = total;
 	hash_engine->src_dma = hash_engine->ahash_src_dma_addr;
 	hash_engine->digest_dma = rctx->digest_dma_addr;
 
@@ -311,6 +327,13 @@ static int aspeed_ahash_complete(struct aspeed_hace_dev *hace_dev)
 
 	AHASH_DBG(hace_dev, "\n");
 
+	dma_unmap_single(hace_dev->dev, rctx->digest_dma_addr,
+			 SHA512_DIGEST_SIZE, DMA_BIDIRECTIONAL);
+
+	if (rctx->total - rctx->offset >= rctx->block_size ||
+	    (rctx->total != rctx->offset && rctx->flags & SHA_FLAGS_FINUP))
+		return aspeed_ahash_req_update(hace_dev);
+
 	hash_engine->flags &= ~CRYPTO_FLAGS_BUSY;
 
 	if (rctx->flags & SHA_FLAGS_FINUP)
@@ -366,36 +389,15 @@ static int aspeed_ahash_update_resume_sg(struct aspeed_hace_dev *hace_dev)
 	dma_unmap_sg(hace_dev->dev, rctx->src_sg, rctx->src_nents,
 		     DMA_TO_DEVICE);
 
-	if (rctx->flags & SHA_FLAGS_FINUP)
+	if (rctx->flags & SHA_FLAGS_FINUP && rctx->total == rctx->offset)
 		dma_unmap_single(hace_dev->dev, rctx->buffer_dma_addr,
 				 sizeof(rctx->buffer), DMA_TO_DEVICE);
 
-	dma_unmap_single(hace_dev->dev, rctx->digest_dma_addr,
-			 SHA512_DIGEST_SIZE, DMA_BIDIRECTIONAL);
-
 	rctx->cmd &= ~HASH_CMD_HASH_SRC_SG_CTRL;
 
 	return aspeed_ahash_complete(hace_dev);
 }
 
-static int aspeed_ahash_update_resume(struct aspeed_hace_dev *hace_dev)
-{
-	struct aspeed_engine_hash *hash_engine = &hace_dev->hash_engine;
-	struct ahash_request *req = hash_engine->req;
-	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
-
-	AHASH_DBG(hace_dev, "\n");
-
-	dma_unmap_single(hace_dev->dev, rctx->digest_dma_addr,
-			 SHA512_DIGEST_SIZE, DMA_BIDIRECTIONAL);
-
-	if (rctx->total - rctx->offset >= rctx->block_size ||
-	    (rctx->total != rctx->offset && rctx->flags & SHA_FLAGS_FINUP))
-		return aspeed_ahash_req_update(hace_dev);
-
-	return aspeed_ahash_complete(hace_dev);
-}
-
 static int aspeed_ahash_req_update(struct aspeed_hace_dev *hace_dev)
 {
 	struct aspeed_engine_hash *hash_engine = &hace_dev->hash_engine;
@@ -411,7 +413,7 @@ static int aspeed_ahash_req_update(struct aspeed_hace_dev *hace_dev)
 		resume = aspeed_ahash_update_resume_sg;
 
 	} else {
-		resume = aspeed_ahash_update_resume;
+		resume = aspeed_ahash_complete;
 	}
 
 	ret = hash_engine->dma_prepare(hace_dev);
-- 
2.39.5

