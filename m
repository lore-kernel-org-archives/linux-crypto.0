Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28801E5B91
	for <linux-crypto@vger.kernel.org>; Tue, 13 May 2025 06:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747116250; cv=none; b=Hg/ElncZwCeomFjDHtEGRlTEwTvM3Xwi6UBrxpV7S4k9C5wStpUy8dfuNayMjt2WSDozlTGkAYfvoXWHMJtxwRKelERcHhHlL90+K45U20mbuQ72vPjm2Mc09ozAqpDv0IzMOX0M2pQswU8/gVja98yzkoDDkfo6PaOf1TzZ+No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747116250; c=relaxed/simple;
	bh=WAl8CiggWIKuSdQMVbhzvu+SNddj5EqkYjZOjUkysYI=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=VmA5Q364WTI0VL/6KZKTVFhp086tAaOpd/LhYCVtVYKVkMJT/kdhpHvK4NztKqgJGArdTWn3gFKapXyUj75M0byzjkX/LSXqO+jD9Jwm+ZyQ+xITDs7h4akuPp5TZTeusm83ec8pDs+JiBMfoUGp81jp6uREIZ3fZRTYSny89ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=UFbt0U8G; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="UFbt0U8G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ETeQzIWQ/HMg/qMx1tm+QJBqw/HHYrbauihlJ7GZAW4=; b=UFbt0U8GpFM/xVEg/Em5+3AdmZ
	2aWZ35yjJazzBUubAHESE1EmNDFpjRDQ0DvT8bPEb3iBXz/grVd6Qvh664f33rrSdJ0sEdlqqHZ/D
	0sqU6B94fM/f7tAz9J0j6l0t8PjshlqRxoyWOXm3G916jg06zwecNIiULWhYzdg2rspL/aEtHNI79
	djZDbSvd4DHWqh9UOA0gs8tEaD9bnwNtje65RKcuPdbCyJYHrQPxDsOE7YAHW9yk6GUMSAApv+h5l
	UqzRrWVSGN96M0Ks9tNXeuO61ZLBieqtRM0toeF1FExH9v6yF+9WV+Pa+Gdgs5UTEDu2myE3C0/AI
	SHy4NCGA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uEikG-005g65-0k;
	Tue, 13 May 2025 14:04:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 May 2025 14:04:04 +0800
Date: Tue, 13 May 2025 14:04:04 +0800
Message-Id: <e4a4fdb61f103c2ced989c7b75dfd4e60a0faeb2.1747116129.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1747116129.git.herbert@gondor.apana.org.au>
References: <cover.1747116129.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 08/11] crypto: aspeed/hash - Use API partial block handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Neal Liu <neal_liu@aspeedtech.com>, linux-aspeed@lists.ozlabs.org
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Also switch to the generic export format.

Remove final function that is no longer used by the Crypto API.
Move final padding into aspeed_ahash_dma_prepare_sg.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/aspeed/aspeed-hace-hash.c | 304 ++++++++---------------
 drivers/crypto/aspeed/aspeed-hace.h      |   6 +-
 2 files changed, 104 insertions(+), 206 deletions(-)

diff --git a/drivers/crypto/aspeed/aspeed-hace-hash.c b/drivers/crypto/aspeed/aspeed-hace-hash.c
index d31d7e1c9af2..d7c7f867d6e1 100644
--- a/drivers/crypto/aspeed/aspeed-hace-hash.c
+++ b/drivers/crypto/aspeed/aspeed-hace-hash.c
@@ -13,6 +13,7 @@
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
+#include <linux/scatterlist.h>
 #include <linux/string.h>
 
 #ifdef CONFIG_CRYPTO_DEV_ASPEED_DEBUG
@@ -58,6 +59,46 @@ static const __be64 sha512_iv[8] = {
 	cpu_to_be64(SHA512_H6), cpu_to_be64(SHA512_H7)
 };
 
+static int aspeed_sham_init(struct ahash_request *req);
+static int aspeed_ahash_req_update(struct aspeed_hace_dev *hace_dev);
+
+static int aspeed_sham_export(struct ahash_request *req, void *out)
+{
+	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
+	union {
+		u8 *u8;
+		u64 *u64;
+	} p = { .u8 = out };
+
+	memcpy(out, rctx->digest, rctx->ivsize);
+	p.u8 += rctx->ivsize;
+	put_unaligned(rctx->digcnt[0], p.u64++);
+	if (rctx->ivsize == 64)
+		put_unaligned(rctx->digcnt[1], p.u64);
+	return 0;
+}
+
+static int aspeed_sham_import(struct ahash_request *req, const void *in)
+{
+	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
+	union {
+		const u8 *u8;
+		const u64 *u64;
+	} p = { .u8 = in };
+	int err;
+
+	err = aspeed_sham_init(req);
+	if (err)
+		return err;
+
+	memcpy(rctx->digest, in, rctx->ivsize);
+	p.u8 += rctx->ivsize;
+	rctx->digcnt[0] = get_unaligned(p.u64++);
+	if (rctx->ivsize == 64)
+		rctx->digcnt[1] = get_unaligned(p.u64);
+	return 0;
+}
+
 /* The purpose of this padding is to ensure that the padded message is a
  * multiple of 512 bits (SHA1/SHA224/SHA256) or 1024 bits (SHA384/SHA512).
  * The bit "1" is appended at the end of the message followed by
@@ -117,33 +158,29 @@ static int aspeed_ahash_dma_prepare(struct aspeed_hace_dev *hace_dev)
 	bool final = rctx->flags & SHA_FLAGS_FINUP;
 	unsigned int length, remain;
 
-	length = rctx->total + rctx->bufcnt;
+	length = rctx->total;
 	remain = final ? 0 : length % rctx->block_size;
 
 	AHASH_DBG(hace_dev, "length:0x%x, remain:0x%x\n", length, remain);
 
-	if (rctx->bufcnt)
-		memcpy(hash_engine->ahash_src_addr, rctx->buffer, rctx->bufcnt);
-
 	if ((final ? round_up(length, rctx->block_size) + rctx->block_size :
 		     length) > ASPEED_CRYPTO_SRC_DMA_BUF_LEN) {
 		dev_warn(hace_dev->dev, "Hash data length is too large\n");
 		return -EINVAL;
 	}
 
-	scatterwalk_map_and_copy(hash_engine->ahash_src_addr +
-				 rctx->bufcnt, rctx->src_sg,
+	scatterwalk_map_and_copy(hash_engine->ahash_src_addr, rctx->src_sg,
 				 rctx->offset, rctx->total - remain, 0);
 	rctx->offset += rctx->total - remain;
 
+	rctx->digcnt[0] += rctx->total - remain;
+	if (rctx->digcnt[0] < rctx->total - remain)
+		rctx->digcnt[1]++;
+
 	if (final)
 		length += aspeed_ahash_fill_padding(
 			hace_dev, rctx, hash_engine->ahash_src_addr + length);
-	else
-		scatterwalk_map_and_copy(rctx->buffer, rctx->src_sg,
-					 rctx->offset, remain, 0);
 
-	rctx->bufcnt = remain;
 	rctx->digest_dma_addr = dma_map_single(hace_dev->dev, rctx->digest,
 					       SHA512_DIGEST_SIZE,
 					       DMA_BIDIRECTIONAL);
@@ -168,16 +205,17 @@ static int aspeed_ahash_dma_prepare_sg(struct aspeed_hace_dev *hace_dev)
 	struct aspeed_engine_hash *hash_engine = &hace_dev->hash_engine;
 	struct ahash_request *req = hash_engine->req;
 	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
+	bool final = rctx->flags & SHA_FLAGS_FINUP;
 	struct aspeed_sg_list *src_list;
 	struct scatterlist *s;
 	int length, remain, sg_len, i;
 	int rc = 0;
 
-	remain = (rctx->total + rctx->bufcnt) % rctx->block_size;
-	length = rctx->total + rctx->bufcnt - remain;
+	remain = final ? 0 : rctx->total % rctx->block_size;
+	length = rctx->total - remain;
 
-	AHASH_DBG(hace_dev, "%s:0x%x, %s:%zu, %s:0x%x, %s:0x%x\n",
-		  "rctx total", rctx->total, "bufcnt", rctx->bufcnt,
+	AHASH_DBG(hace_dev, "%s:0x%x, %s:0x%x, %s:0x%x\n",
+		  "rctx total", rctx->total,
 		  "length", length, "remain", remain);
 
 	sg_len = dma_map_sg(hace_dev->dev, rctx->src_sg, rctx->src_nents,
@@ -198,13 +236,39 @@ static int aspeed_ahash_dma_prepare_sg(struct aspeed_hace_dev *hace_dev)
 		goto free_src_sg;
 	}
 
-	if (rctx->bufcnt != 0) {
-		u32 phy_addr;
-		u32 len;
+	for_each_sg(rctx->src_sg, s, sg_len, i) {
+		u32 phy_addr = sg_dma_address(s);
+		u32 len = sg_dma_len(s);
 
+		if (length > len)
+			length -= len;
+		else {
+			/* Last sg list */
+			len = length;
+			length = 0;
+		}
+
+		src_list[i].phy_addr = cpu_to_le32(phy_addr);
+		src_list[i].len = cpu_to_le32(len);
+	}
+
+	if (length != 0) {
+		rc = -EINVAL;
+		goto free_rctx_digest;
+	}
+
+	rctx->digcnt[0] += rctx->total - remain;
+	if (rctx->digcnt[0] < rctx->total - remain)
+		rctx->digcnt[1]++;
+
+	if (final) {
+		int len = aspeed_ahash_fill_padding(hace_dev, rctx,
+						    rctx->buffer);
+
+		rctx->total += len;
 		rctx->buffer_dma_addr = dma_map_single(hace_dev->dev,
 						       rctx->buffer,
-						       rctx->block_size * 2,
+						       sizeof(rctx->buffer),
 						       DMA_TO_DEVICE);
 		if (dma_mapping_error(hace_dev->dev, rctx->buffer_dma_addr)) {
 			dev_warn(hace_dev->dev, "dma_map() rctx buffer error\n");
@@ -212,54 +276,19 @@ static int aspeed_ahash_dma_prepare_sg(struct aspeed_hace_dev *hace_dev)
 			goto free_rctx_digest;
 		}
 
-		phy_addr = rctx->buffer_dma_addr;
-		len = rctx->bufcnt;
-		length -= len;
-
-		/* Last sg list */
-		if (length == 0)
-			len |= HASH_SG_LAST_LIST;
-
-		src_list[0].phy_addr = cpu_to_le32(phy_addr);
-		src_list[0].len = cpu_to_le32(len);
-		src_list++;
-	}
-
-	if (length != 0) {
-		for_each_sg(rctx->src_sg, s, sg_len, i) {
-			u32 phy_addr = sg_dma_address(s);
-			u32 len = sg_dma_len(s);
-
-			if (length > len)
-				length -= len;
-			else {
-				/* Last sg list */
-				len = length;
-				len |= HASH_SG_LAST_LIST;
-				length = 0;
-			}
-
-			src_list[i].phy_addr = cpu_to_le32(phy_addr);
-			src_list[i].len = cpu_to_le32(len);
-		}
-	}
-
-	if (length != 0) {
-		rc = -EINVAL;
-		goto free_rctx_buffer;
+		src_list[i].phy_addr = cpu_to_le32(rctx->buffer_dma_addr);
+		src_list[i].len = cpu_to_le32(len);
+		i++;
 	}
+	src_list[i - 1].len |= cpu_to_le32(HASH_SG_LAST_LIST);
 
 	rctx->offset = rctx->total - remain;
-	hash_engine->src_length = rctx->total + rctx->bufcnt - remain;
+	hash_engine->src_length = rctx->total - remain;
 	hash_engine->src_dma = hash_engine->ahash_src_dma_addr;
 	hash_engine->digest_dma = rctx->digest_dma_addr;
 
 	return 0;
 
-free_rctx_buffer:
-	if (rctx->bufcnt != 0)
-		dma_unmap_single(hace_dev->dev, rctx->buffer_dma_addr,
-				 rctx->block_size * 2, DMA_TO_DEVICE);
 free_rctx_digest:
 	dma_unmap_single(hace_dev->dev, rctx->digest_dma_addr,
 			 SHA512_DIGEST_SIZE, DMA_BIDIRECTIONAL);
@@ -274,39 +303,21 @@ static int aspeed_ahash_complete(struct aspeed_hace_dev *hace_dev)
 {
 	struct aspeed_engine_hash *hash_engine = &hace_dev->hash_engine;
 	struct ahash_request *req = hash_engine->req;
+	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
 
 	AHASH_DBG(hace_dev, "\n");
 
 	hash_engine->flags &= ~CRYPTO_FLAGS_BUSY;
 
-	crypto_finalize_hash_request(hace_dev->crypt_engine_hash, req, 0);
+	if (rctx->flags & SHA_FLAGS_FINUP)
+		memcpy(req->result, rctx->digest, rctx->digsize);
+
+	crypto_finalize_hash_request(hace_dev->crypt_engine_hash, req,
+				     rctx->total - rctx->offset);
 
 	return 0;
 }
 
-/*
- * Copy digest to the corresponding request result.
- * This function will be called at final() stage.
- */
-static int aspeed_ahash_transfer(struct aspeed_hace_dev *hace_dev)
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
-	dma_unmap_single(hace_dev->dev, rctx->buffer_dma_addr,
-			 rctx->block_size * 2, DMA_TO_DEVICE);
-
-	memcpy(req->result, rctx->digest, rctx->digsize);
-
-	return aspeed_ahash_complete(hace_dev);
-}
-
 /*
  * Trigger hardware engines to do the math.
  */
@@ -340,51 +351,6 @@ static int aspeed_hace_ahash_trigger(struct aspeed_hace_dev *hace_dev,
 	return -EINPROGRESS;
 }
 
-static int aspeed_ahash_req_final(struct aspeed_hace_dev *hace_dev)
-{
-	struct aspeed_engine_hash *hash_engine = &hace_dev->hash_engine;
-	struct ahash_request *req = hash_engine->req;
-	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
-	int rc = 0;
-
-	AHASH_DBG(hace_dev, "\n");
-
-	rctx->bufcnt += aspeed_ahash_fill_padding(hace_dev, rctx,
-						  rctx->buffer + rctx->bufcnt);
-
-	rctx->digest_dma_addr = dma_map_single(hace_dev->dev,
-					       rctx->digest,
-					       SHA512_DIGEST_SIZE,
-					       DMA_BIDIRECTIONAL);
-	if (dma_mapping_error(hace_dev->dev, rctx->digest_dma_addr)) {
-		dev_warn(hace_dev->dev, "dma_map() rctx digest error\n");
-		rc = -ENOMEM;
-		goto end;
-	}
-
-	rctx->buffer_dma_addr = dma_map_single(hace_dev->dev,
-					       rctx->buffer,
-					       rctx->block_size * 2,
-					       DMA_TO_DEVICE);
-	if (dma_mapping_error(hace_dev->dev, rctx->buffer_dma_addr)) {
-		dev_warn(hace_dev->dev, "dma_map() rctx buffer error\n");
-		rc = -ENOMEM;
-		goto free_rctx_digest;
-	}
-
-	hash_engine->src_dma = rctx->buffer_dma_addr;
-	hash_engine->src_length = rctx->bufcnt;
-	hash_engine->digest_dma = rctx->digest_dma_addr;
-
-	return aspeed_hace_ahash_trigger(hace_dev, aspeed_ahash_transfer);
-
-free_rctx_digest:
-	dma_unmap_single(hace_dev->dev, rctx->digest_dma_addr,
-			 SHA512_DIGEST_SIZE, DMA_BIDIRECTIONAL);
-end:
-	return rc;
-}
-
 static int aspeed_ahash_update_resume_sg(struct aspeed_hace_dev *hace_dev)
 {
 	struct aspeed_engine_hash *hash_engine = &hace_dev->hash_engine;
@@ -396,23 +362,15 @@ static int aspeed_ahash_update_resume_sg(struct aspeed_hace_dev *hace_dev)
 	dma_unmap_sg(hace_dev->dev, rctx->src_sg, rctx->src_nents,
 		     DMA_TO_DEVICE);
 
-	if (rctx->bufcnt != 0)
+	if (rctx->flags & SHA_FLAGS_FINUP)
 		dma_unmap_single(hace_dev->dev, rctx->buffer_dma_addr,
-				 rctx->block_size * 2,
-				 DMA_TO_DEVICE);
+				 sizeof(rctx->buffer), DMA_TO_DEVICE);
 
 	dma_unmap_single(hace_dev->dev, rctx->digest_dma_addr,
 			 SHA512_DIGEST_SIZE, DMA_BIDIRECTIONAL);
 
-	scatterwalk_map_and_copy(rctx->buffer, rctx->src_sg, rctx->offset,
-				 rctx->total - rctx->offset, 0);
-
-	rctx->bufcnt = rctx->total - rctx->offset;
 	rctx->cmd &= ~HASH_CMD_HASH_SRC_SG_CTRL;
 
-	if (rctx->flags & SHA_FLAGS_FINUP)
-		return aspeed_ahash_req_final(hace_dev);
-
 	return aspeed_ahash_complete(hace_dev);
 }
 
@@ -427,9 +385,6 @@ static int aspeed_ahash_update_resume(struct aspeed_hace_dev *hace_dev)
 	dma_unmap_single(hace_dev->dev, rctx->digest_dma_addr,
 			 SHA512_DIGEST_SIZE, DMA_BIDIRECTIONAL);
 
-	if (rctx->flags & SHA_FLAGS_FINUP)
-		memcpy(req->result, rctx->digest, rctx->digsize);
-
 	return aspeed_ahash_complete(hace_dev);
 }
 
@@ -468,21 +423,16 @@ static int aspeed_hace_hash_handle_queue(struct aspeed_hace_dev *hace_dev,
 static int aspeed_ahash_do_request(struct crypto_engine *engine, void *areq)
 {
 	struct ahash_request *req = ahash_request_cast(areq);
-	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct aspeed_sham_ctx *tctx = crypto_ahash_ctx(tfm);
 	struct aspeed_hace_dev *hace_dev = tctx->hace_dev;
 	struct aspeed_engine_hash *hash_engine;
-	int ret = 0;
+	int ret;
 
 	hash_engine = &hace_dev->hash_engine;
 	hash_engine->flags |= CRYPTO_FLAGS_BUSY;
 
-	if (rctx->op == SHA_OP_UPDATE)
-		ret = aspeed_ahash_req_update(hace_dev);
-	else if (rctx->op == SHA_OP_FINAL)
-		ret = aspeed_ahash_req_final(hace_dev);
-
+	ret = aspeed_ahash_req_update(hace_dev);
 	if (ret != -EINPROGRESS)
 		return ret;
 
@@ -513,20 +463,6 @@ static int aspeed_ahash_do_one(struct crypto_engine *engine, void *areq)
 	return aspeed_ahash_do_request(engine, areq);
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
 static int aspeed_sham_update(struct ahash_request *req)
 {
 	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
@@ -539,22 +475,7 @@ static int aspeed_sham_update(struct ahash_request *req)
 	rctx->total = req->nbytes;
 	rctx->src_sg = req->src;
 	rctx->offset = 0;
-	rctx->src_nents = sg_nents(req->src);
-	rctx->op = SHA_OP_UPDATE;
-
-	rctx->digcnt[0] += rctx->total;
-	if (rctx->digcnt[0] < rctx->total)
-		rctx->digcnt[1]++;
-
-	if (rctx->bufcnt + rctx->total < rctx->block_size) {
-		scatterwalk_map_and_copy(rctx->buffer + rctx->bufcnt,
-					 rctx->src_sg, rctx->offset,
-					 rctx->total, 0);
-		rctx->bufcnt += rctx->total;
-
-		return rctx->flags & SHA_FLAGS_FINUP ?
-		       aspeed_sham_final(req) : 0;
-	}
+	rctx->src_nents = sg_nents_for_len(req->src, req->nbytes);
 
 	return aspeed_hace_hash_handle_queue(hace_dev, req);
 }
@@ -636,7 +557,6 @@ static int aspeed_sham_init(struct ahash_request *req)
 		return -EINVAL;
 	}
 
-	rctx->bufcnt = 0;
 	rctx->total = 0;
 	rctx->digcnt[0] = 0;
 	rctx->digcnt[1] = 0;
@@ -661,30 +581,11 @@ static int aspeed_sham_cra_init(struct crypto_ahash *tfm)
 	return 0;
 }
 
-static int aspeed_sham_export(struct ahash_request *req, void *out)
-{
-	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
-
-	memcpy(out, rctx, sizeof(*rctx));
-
-	return 0;
-}
-
-static int aspeed_sham_import(struct ahash_request *req, const void *in)
-{
-	struct aspeed_sham_reqctx *rctx = ahash_request_ctx(req);
-
-	memcpy(rctx, in, sizeof(*rctx));
-
-	return 0;
-}
-
 static struct aspeed_hace_alg aspeed_ahash_algs[] = {
 	{
 		.alg.ahash.base = {
 			.init	= aspeed_sham_init,
 			.update	= aspeed_sham_update,
-			.final	= aspeed_sham_final,
 			.finup	= aspeed_sham_finup,
 			.digest	= aspeed_sham_digest,
 			.export	= aspeed_sham_export,
@@ -699,6 +600,7 @@ static struct aspeed_hace_alg aspeed_ahash_algs[] = {
 					.cra_priority		= 300,
 					.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
 								  CRYPTO_ALG_ASYNC |
+								  CRYPTO_AHASH_ALG_BLOCK_ONLY |
 								  CRYPTO_ALG_KERN_DRIVER_ONLY,
 					.cra_blocksize		= SHA1_BLOCK_SIZE,
 					.cra_ctxsize		= sizeof(struct aspeed_sham_ctx),
@@ -716,7 +618,6 @@ static struct aspeed_hace_alg aspeed_ahash_algs[] = {
 		.alg.ahash.base = {
 			.init	= aspeed_sham_init,
 			.update	= aspeed_sham_update,
-			.final	= aspeed_sham_final,
 			.finup	= aspeed_sham_finup,
 			.digest	= aspeed_sham_digest,
 			.export	= aspeed_sham_export,
@@ -731,6 +632,7 @@ static struct aspeed_hace_alg aspeed_ahash_algs[] = {
 					.cra_priority		= 300,
 					.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
 								  CRYPTO_ALG_ASYNC |
+								  CRYPTO_AHASH_ALG_BLOCK_ONLY |
 								  CRYPTO_ALG_KERN_DRIVER_ONLY,
 					.cra_blocksize		= SHA256_BLOCK_SIZE,
 					.cra_ctxsize		= sizeof(struct aspeed_sham_ctx),
@@ -748,7 +650,6 @@ static struct aspeed_hace_alg aspeed_ahash_algs[] = {
 		.alg.ahash.base = {
 			.init	= aspeed_sham_init,
 			.update	= aspeed_sham_update,
-			.final	= aspeed_sham_final,
 			.finup	= aspeed_sham_finup,
 			.digest	= aspeed_sham_digest,
 			.export	= aspeed_sham_export,
@@ -763,6 +664,7 @@ static struct aspeed_hace_alg aspeed_ahash_algs[] = {
 					.cra_priority		= 300,
 					.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
 								  CRYPTO_ALG_ASYNC |
+								  CRYPTO_AHASH_ALG_BLOCK_ONLY |
 								  CRYPTO_ALG_KERN_DRIVER_ONLY,
 					.cra_blocksize		= SHA224_BLOCK_SIZE,
 					.cra_ctxsize		= sizeof(struct aspeed_sham_ctx),
@@ -783,7 +685,6 @@ static struct aspeed_hace_alg aspeed_ahash_algs_g6[] = {
 		.alg.ahash.base = {
 			.init	= aspeed_sham_init,
 			.update	= aspeed_sham_update,
-			.final	= aspeed_sham_final,
 			.finup	= aspeed_sham_finup,
 			.digest	= aspeed_sham_digest,
 			.export	= aspeed_sham_export,
@@ -798,6 +699,7 @@ static struct aspeed_hace_alg aspeed_ahash_algs_g6[] = {
 					.cra_priority		= 300,
 					.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
 								  CRYPTO_ALG_ASYNC |
+								  CRYPTO_AHASH_ALG_BLOCK_ONLY |
 								  CRYPTO_ALG_KERN_DRIVER_ONLY,
 					.cra_blocksize		= SHA384_BLOCK_SIZE,
 					.cra_ctxsize		= sizeof(struct aspeed_sham_ctx),
@@ -815,7 +717,6 @@ static struct aspeed_hace_alg aspeed_ahash_algs_g6[] = {
 		.alg.ahash.base = {
 			.init	= aspeed_sham_init,
 			.update	= aspeed_sham_update,
-			.final	= aspeed_sham_final,
 			.finup	= aspeed_sham_finup,
 			.digest	= aspeed_sham_digest,
 			.export	= aspeed_sham_export,
@@ -830,6 +731,7 @@ static struct aspeed_hace_alg aspeed_ahash_algs_g6[] = {
 					.cra_priority		= 300,
 					.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
 								  CRYPTO_ALG_ASYNC |
+								  CRYPTO_AHASH_ALG_BLOCK_ONLY |
 								  CRYPTO_ALG_KERN_DRIVER_ONLY,
 					.cra_blocksize		= SHA512_BLOCK_SIZE,
 					.cra_ctxsize		= sizeof(struct aspeed_sham_ctx),
diff --git a/drivers/crypto/aspeed/aspeed-hace.h b/drivers/crypto/aspeed/aspeed-hace.h
index ad39954251dd..b1d07730d543 100644
--- a/drivers/crypto/aspeed/aspeed-hace.h
+++ b/drivers/crypto/aspeed/aspeed-hace.h
@@ -172,7 +172,6 @@ struct aspeed_sham_reqctx {
 	u64			digcnt[2];
 
 	unsigned long		flags;		/* final update flag should no use*/
-	unsigned long		op;		/* final or update */
 	u32			cmd;		/* trigger cmd */
 
 	/* walk state */
@@ -185,14 +184,11 @@ struct aspeed_sham_reqctx {
 	size_t			block_size;
 	size_t			ivsize;
 
-	/* remain data buffer */
 	dma_addr_t		buffer_dma_addr;
-	size_t			bufcnt;		/* buffer counter */
-
 	dma_addr_t		digest_dma_addr;
 
 	/* This is DMA too but read-only for hardware. */
-	u8			buffer[SHA512_BLOCK_SIZE * 2];
+	u8			buffer[SHA512_BLOCK_SIZE + 16];
 };
 
 struct aspeed_engine_crypto {
-- 
2.39.5

