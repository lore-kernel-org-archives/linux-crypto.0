Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95984277CB8;
	Wed, 18 Jun 2025 07:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750230633; cv=none; b=BturE8LcjhsV/mzFSsXnOu+NLPj8cnJvnLqTpU53Q6hYuwdouA+TdcfAitx/+xHpa/dm4GD6nv2YpXRtTQJoRLyEU/1ebsPhUvm0jj2R7zZkMK4TAw8Fz/yzgMoJsJUD/frPch/hp24L/c7CUVJD43dxDsQ3W5cqgbZ0AIVgHmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750230633; c=relaxed/simple;
	bh=ANvu12EvFtmEnjpuP3VL21CcCVpIVeRWCWjj9HNx9s0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=ROEFS3HL3woxAYDm0x107HcD+GxYgsTVSlT2RP8c4ffVd9ghHzIjd9ie07puY5A6PwA0T3UHQj9Koe7V7GkpRg2Df6AxJZNuWoTugvdhv3muHqIZrYsws1C8DC+NszskcQ2ZhiMBYm5NQ7bsbLPFmQWDOd0k6+qovKKigWrnG0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=XzF1QH1D; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=otj6zJr2; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="XzF1QH1D";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="otj6zJr2"
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1750230629;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7/viS9M9FbjKOUWKj49svVFPb7uPQHj37/2s1X25PEE=;
	b=XzF1QH1DIKeCCwvLuWQ3jXFKzJPp2CPFKm1Ma3NUW3aUSmA1HtS2j4VPOEOIy2znKi1QAz
	JNRg/spKxuIKeLUP7hN6YDgf6eaUFNIUppxGLD7OXl/tHUjH+Sbj7OU/99hQYl8T1efNHZ
	ptc8RydULWr5cBuIzBeA5qssMJGrQ1t9Ory/JZcMi5s2Gut34v2i8OxS/S3d9czxqcqeEA
	VSwOP81mmf/CYOtP+h6K500FX3wiCAhfiX2keffIaTcvcO7XVjFizLqDUP46NkZncUG0OH
	8uM1wh7uu/BlJ1NfJdFAE4ff55NYrsfjrZHZqb6wg5zm0tyHGk6J3Sh21ODmPQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1750230629;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7/viS9M9FbjKOUWKj49svVFPb7uPQHj37/2s1X25PEE=;
	b=otj6zJr2b/z7tlyPfwqito+FUzL3YWCH/ASeZVGtdL5TYIYhVnbk2CCUbcQIJxyynJisz5
	jGhjV5ftlAIcW1CQ==
Date: Wed, 18 Jun 2025 09:10:18 +0200
Subject: [PATCH] crypto: ccree - Don't use %pK through printk
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250618-restricted-pointers-crypto-v1-1-e354644aa381@linutronix.de>
X-B4-Tracking: v=1; b=H4sIAFlmUmgC/x3MwQqDMAwA0F+RnA20tQPxV8YOLo1bLm1JijjEf
 1/x+C7vBGMVNliGE5R3MSm5w48D0HfNH0ZJ3RBceLjoIipbU6HGCWuR3FgNSX+1FQw+TulN25z
 IQw+q8ibHnT9f1/UHp1XdPWwAAAA=
X-Change-ID: 20250404-restricted-pointers-crypto-2143dbcf8dc1
To: Gilad Ben-Yossef <gilad@benyossef.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1750230629; l=18785;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=ANvu12EvFtmEnjpuP3VL21CcCVpIVeRWCWjj9HNx9s0=;
 b=NYsr5Fo8OpEuP4ZEQL2OVZP2/slc7uNBlbw/bq5Yb8bYw6AXqySLXY6LLQoTQSTVI8NKGvCN+
 IWgp3MttMIAD9JuZOZ9g+d2f7i4WDueEZxrhDgPzURSW28X34UDKlFs
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=

In the past %pK was preferable to %p as it would not leak raw pointer
values into the kernel log.
Since commit ad67b74d2469 ("printk: hash addresses printed with %p")
the regular %p has been improved to avoid this issue.
Furthermore, restricted pointers ("%pK") were never meant to be used
through printk(). They can still unintentionally leak raw pointers or
acquire sleeping locks in atomic contexts.

Switch to the regular pointer formatting which is safer and
easier to reason about.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 drivers/crypto/ccree/cc_buffer_mgr.c | 54 ++++++++++++++++++------------------
 drivers/crypto/ccree/cc_cipher.c     |  4 +--
 drivers/crypto/ccree/cc_hash.c       | 30 ++++++++++----------
 3 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index bcca55bff910ef04832969d79efc49952d04d8c6..3963bb91321fc130a0912670376720a575a0c070 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -224,7 +224,7 @@ static int cc_generate_mlli(struct device *dev, struct buffer_array *sg_data,
 	/* Set MLLI size for the bypass operation */
 	mlli_params->mlli_len = (total_nents * LLI_ENTRY_BYTE_SIZE);
 
-	dev_dbg(dev, "MLLI params: virt_addr=%pK dma_addr=%pad mlli_len=0x%X\n",
+	dev_dbg(dev, "MLLI params: virt_addr=%p dma_addr=%pad mlli_len=0x%X\n",
 		mlli_params->mlli_virt_addr, &mlli_params->mlli_dma_addr,
 		mlli_params->mlli_len);
 
@@ -239,7 +239,7 @@ static void cc_add_sg_entry(struct device *dev, struct buffer_array *sgl_data,
 {
 	unsigned int index = sgl_data->num_of_buffers;
 
-	dev_dbg(dev, "index=%u nents=%u sgl=%pK data_len=0x%08X is_last=%d\n",
+	dev_dbg(dev, "index=%u nents=%u sgl=%p data_len=0x%08X is_last=%d\n",
 		index, nents, sgl, data_len, is_last_table);
 	sgl_data->nents[index] = nents;
 	sgl_data->entry[index].sgl = sgl;
@@ -298,7 +298,7 @@ cc_set_aead_conf_buf(struct device *dev, struct aead_req_ctx *areq_ctx,
 		dev_err(dev, "dma_map_sg() config buffer failed\n");
 		return -ENOMEM;
 	}
-	dev_dbg(dev, "Mapped curr_buff: dma_address=%pad page=%p addr=%pK offset=%u length=%u\n",
+	dev_dbg(dev, "Mapped curr_buff: dma_address=%pad page=%p addr=%p offset=%u length=%u\n",
 		&sg_dma_address(&areq_ctx->ccm_adata_sg),
 		sg_page(&areq_ctx->ccm_adata_sg),
 		sg_virt(&areq_ctx->ccm_adata_sg),
@@ -323,7 +323,7 @@ static int cc_set_hash_buf(struct device *dev, struct ahash_req_ctx *areq_ctx,
 		dev_err(dev, "dma_map_sg() src buffer failed\n");
 		return -ENOMEM;
 	}
-	dev_dbg(dev, "Mapped curr_buff: dma_address=%pad page=%p addr=%pK offset=%u length=%u\n",
+	dev_dbg(dev, "Mapped curr_buff: dma_address=%pad page=%p addr=%p offset=%u length=%u\n",
 		&sg_dma_address(areq_ctx->buff_sg), sg_page(areq_ctx->buff_sg),
 		sg_virt(areq_ctx->buff_sg), areq_ctx->buff_sg->offset,
 		areq_ctx->buff_sg->length);
@@ -359,11 +359,11 @@ void cc_unmap_cipher_request(struct device *dev, void *ctx,
 	if (src != dst) {
 		dma_unmap_sg(dev, src, req_ctx->in_nents, DMA_TO_DEVICE);
 		dma_unmap_sg(dev, dst, req_ctx->out_nents, DMA_FROM_DEVICE);
-		dev_dbg(dev, "Unmapped req->dst=%pK\n", sg_virt(dst));
-		dev_dbg(dev, "Unmapped req->src=%pK\n", sg_virt(src));
+		dev_dbg(dev, "Unmapped req->dst=%p\n", sg_virt(dst));
+		dev_dbg(dev, "Unmapped req->src=%p\n", sg_virt(src));
 	} else {
 		dma_unmap_sg(dev, src, req_ctx->in_nents, DMA_BIDIRECTIONAL);
-		dev_dbg(dev, "Unmapped req->src=%pK\n", sg_virt(src));
+		dev_dbg(dev, "Unmapped req->src=%p\n", sg_virt(src));
 	}
 }
 
@@ -391,11 +391,11 @@ int cc_map_cipher_request(struct cc_drvdata *drvdata, void *ctx,
 		req_ctx->gen_ctx.iv_dma_addr =
 			dma_map_single(dev, info, ivsize, DMA_BIDIRECTIONAL);
 		if (dma_mapping_error(dev, req_ctx->gen_ctx.iv_dma_addr)) {
-			dev_err(dev, "Mapping iv %u B at va=%pK for DMA failed\n",
+			dev_err(dev, "Mapping iv %u B at va=%p for DMA failed\n",
 				ivsize, info);
 			return -ENOMEM;
 		}
-		dev_dbg(dev, "Mapped iv %u B at va=%pK to dma=%pad\n",
+		dev_dbg(dev, "Mapped iv %u B at va=%p to dma=%pad\n",
 			ivsize, info, &req_ctx->gen_ctx.iv_dma_addr);
 	} else {
 		req_ctx->gen_ctx.iv_dma_addr = 0;
@@ -506,7 +506,7 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
 	if ((areq_ctx->assoc_buff_type == CC_DMA_BUF_MLLI ||
 	     areq_ctx->data_buff_type == CC_DMA_BUF_MLLI) &&
 	    (areq_ctx->mlli_params.mlli_virt_addr)) {
-		dev_dbg(dev, "free MLLI buffer: dma=%pad virt=%pK\n",
+		dev_dbg(dev, "free MLLI buffer: dma=%pad virt=%p\n",
 			&areq_ctx->mlli_params.mlli_dma_addr,
 			areq_ctx->mlli_params.mlli_virt_addr);
 		dma_pool_free(areq_ctx->mlli_params.curr_pool,
@@ -514,13 +514,13 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
 			      areq_ctx->mlli_params.mlli_dma_addr);
 	}
 
-	dev_dbg(dev, "Unmapping src sgl: req->src=%pK areq_ctx->src.nents=%u areq_ctx->assoc.nents=%u assoclen:%u cryptlen=%u\n",
+	dev_dbg(dev, "Unmapping src sgl: req->src=%p areq_ctx->src.nents=%u areq_ctx->assoc.nents=%u assoclen:%u cryptlen=%u\n",
 		sg_virt(req->src), areq_ctx->src.nents, areq_ctx->assoc.nents,
 		areq_ctx->assoclen, req->cryptlen);
 
 	dma_unmap_sg(dev, req->src, areq_ctx->src.mapped_nents, src_direction);
 	if (req->src != req->dst) {
-		dev_dbg(dev, "Unmapping dst sgl: req->dst=%pK\n",
+		dev_dbg(dev, "Unmapping dst sgl: req->dst=%p\n",
 			sg_virt(req->dst));
 		dma_unmap_sg(dev, req->dst, areq_ctx->dst.mapped_nents, DMA_FROM_DEVICE);
 	}
@@ -566,7 +566,7 @@ static int cc_aead_chain_iv(struct cc_drvdata *drvdata,
 		dma_map_single(dev, areq_ctx->gen_ctx.iv, hw_iv_size,
 			       DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dev, areq_ctx->gen_ctx.iv_dma_addr)) {
-		dev_err(dev, "Mapping iv %u B at va=%pK for DMA failed\n",
+		dev_err(dev, "Mapping iv %u B at va=%p for DMA failed\n",
 			hw_iv_size, req->iv);
 		kfree_sensitive(areq_ctx->gen_ctx.iv);
 		areq_ctx->gen_ctx.iv = NULL;
@@ -574,7 +574,7 @@ static int cc_aead_chain_iv(struct cc_drvdata *drvdata,
 		goto chain_iv_exit;
 	}
 
-	dev_dbg(dev, "Mapped iv %u B at va=%pK to dma=%pad\n",
+	dev_dbg(dev, "Mapped iv %u B at va=%p to dma=%pad\n",
 		hw_iv_size, req->iv, &areq_ctx->gen_ctx.iv_dma_addr);
 
 chain_iv_exit:
@@ -977,7 +977,7 @@ int cc_map_aead_request(struct cc_drvdata *drvdata, struct aead_request *req)
 	dma_addr = dma_map_single(dev, areq_ctx->mac_buf, MAX_MAC_SIZE,
 				  DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dev, dma_addr)) {
-		dev_err(dev, "Mapping mac_buf %u B at va=%pK for DMA failed\n",
+		dev_err(dev, "Mapping mac_buf %u B at va=%p for DMA failed\n",
 			MAX_MAC_SIZE, areq_ctx->mac_buf);
 		rc = -ENOMEM;
 		goto aead_map_failure;
@@ -991,7 +991,7 @@ int cc_map_aead_request(struct cc_drvdata *drvdata, struct aead_request *req)
 					  DMA_TO_DEVICE);
 
 		if (dma_mapping_error(dev, dma_addr)) {
-			dev_err(dev, "Mapping mac_buf %u B at va=%pK for DMA failed\n",
+			dev_err(dev, "Mapping mac_buf %u B at va=%p for DMA failed\n",
 				AES_BLOCK_SIZE, addr);
 			areq_ctx->ccm_iv0_dma_addr = 0;
 			rc = -ENOMEM;
@@ -1009,7 +1009,7 @@ int cc_map_aead_request(struct cc_drvdata *drvdata, struct aead_request *req)
 		dma_addr = dma_map_single(dev, areq_ctx->hkey, AES_BLOCK_SIZE,
 					  DMA_BIDIRECTIONAL);
 		if (dma_mapping_error(dev, dma_addr)) {
-			dev_err(dev, "Mapping hkey %u B at va=%pK for DMA failed\n",
+			dev_err(dev, "Mapping hkey %u B at va=%p for DMA failed\n",
 				AES_BLOCK_SIZE, areq_ctx->hkey);
 			rc = -ENOMEM;
 			goto aead_map_failure;
@@ -1019,7 +1019,7 @@ int cc_map_aead_request(struct cc_drvdata *drvdata, struct aead_request *req)
 		dma_addr = dma_map_single(dev, &areq_ctx->gcm_len_block,
 					  AES_BLOCK_SIZE, DMA_TO_DEVICE);
 		if (dma_mapping_error(dev, dma_addr)) {
-			dev_err(dev, "Mapping gcm_len_block %u B at va=%pK for DMA failed\n",
+			dev_err(dev, "Mapping gcm_len_block %u B at va=%p for DMA failed\n",
 				AES_BLOCK_SIZE, &areq_ctx->gcm_len_block);
 			rc = -ENOMEM;
 			goto aead_map_failure;
@@ -1030,7 +1030,7 @@ int cc_map_aead_request(struct cc_drvdata *drvdata, struct aead_request *req)
 					  AES_BLOCK_SIZE, DMA_TO_DEVICE);
 
 		if (dma_mapping_error(dev, dma_addr)) {
-			dev_err(dev, "Mapping gcm_iv_inc1 %u B at va=%pK for DMA failed\n",
+			dev_err(dev, "Mapping gcm_iv_inc1 %u B at va=%p for DMA failed\n",
 				AES_BLOCK_SIZE, (areq_ctx->gcm_iv_inc1));
 			areq_ctx->gcm_iv_inc1_dma_addr = 0;
 			rc = -ENOMEM;
@@ -1042,7 +1042,7 @@ int cc_map_aead_request(struct cc_drvdata *drvdata, struct aead_request *req)
 					  AES_BLOCK_SIZE, DMA_TO_DEVICE);
 
 		if (dma_mapping_error(dev, dma_addr)) {
-			dev_err(dev, "Mapping gcm_iv_inc2 %u B at va=%pK for DMA failed\n",
+			dev_err(dev, "Mapping gcm_iv_inc2 %u B at va=%p for DMA failed\n",
 				AES_BLOCK_SIZE, (areq_ctx->gcm_iv_inc2));
 			areq_ctx->gcm_iv_inc2_dma_addr = 0;
 			rc = -ENOMEM;
@@ -1152,7 +1152,7 @@ int cc_map_hash_request_final(struct cc_drvdata *drvdata, void *ctx,
 	u32 dummy = 0;
 	u32 mapped_nents = 0;
 
-	dev_dbg(dev, "final params : curr_buff=%pK curr_buff_cnt=0x%X nbytes = 0x%X src=%pK curr_index=%u\n",
+	dev_dbg(dev, "final params : curr_buff=%p curr_buff_cnt=0x%X nbytes = 0x%X src=%p curr_index=%u\n",
 		curr_buff, *curr_buff_cnt, nbytes, src, areq_ctx->buff_index);
 	/* Init the type of the dma buffer */
 	areq_ctx->data_dma_buf_type = CC_DMA_BUF_NULL;
@@ -1236,7 +1236,7 @@ int cc_map_hash_request_update(struct cc_drvdata *drvdata, void *ctx,
 	u32 dummy = 0;
 	u32 mapped_nents = 0;
 
-	dev_dbg(dev, " update params : curr_buff=%pK curr_buff_cnt=0x%X nbytes=0x%X src=%pK curr_index=%u\n",
+	dev_dbg(dev, " update params : curr_buff=%p curr_buff_cnt=0x%X nbytes=0x%X src=%p curr_index=%u\n",
 		curr_buff, *curr_buff_cnt, nbytes, src, areq_ctx->buff_index);
 	/* Init the type of the dma buffer */
 	areq_ctx->data_dma_buf_type = CC_DMA_BUF_NULL;
@@ -1246,7 +1246,7 @@ int cc_map_hash_request_update(struct cc_drvdata *drvdata, void *ctx,
 	areq_ctx->in_nents = 0;
 
 	if (total_in_len < block_size) {
-		dev_dbg(dev, " less than one block: curr_buff=%pK *curr_buff_cnt=0x%X copy_to=%pK\n",
+		dev_dbg(dev, " less than one block: curr_buff=%p *curr_buff_cnt=0x%X copy_to=%p\n",
 			curr_buff, *curr_buff_cnt, &curr_buff[*curr_buff_cnt]);
 		areq_ctx->in_nents = sg_nents_for_len(src, nbytes);
 		sg_copy_to_buffer(src, areq_ctx->in_nents,
@@ -1265,7 +1265,7 @@ int cc_map_hash_request_update(struct cc_drvdata *drvdata, void *ctx,
 
 	/* Copy the new residue to next buffer */
 	if (*next_buff_cnt) {
-		dev_dbg(dev, " handle residue: next buff %pK skip data %u residue %u\n",
+		dev_dbg(dev, " handle residue: next buff %p skip data %u residue %u\n",
 			next_buff, (update_data_len - *curr_buff_cnt),
 			*next_buff_cnt);
 		cc_copy_sg_portion(dev, next_buff, src,
@@ -1338,7 +1338,7 @@ void cc_unmap_hash_request(struct device *dev, void *ctx,
 	 *allocated and should be released
 	 */
 	if (areq_ctx->mlli_params.curr_pool) {
-		dev_dbg(dev, "free MLLI buffer: dma=%pad virt=%pK\n",
+		dev_dbg(dev, "free MLLI buffer: dma=%pad virt=%p\n",
 			&areq_ctx->mlli_params.mlli_dma_addr,
 			areq_ctx->mlli_params.mlli_virt_addr);
 		dma_pool_free(areq_ctx->mlli_params.curr_pool,
@@ -1347,14 +1347,14 @@ void cc_unmap_hash_request(struct device *dev, void *ctx,
 	}
 
 	if (src && areq_ctx->in_nents) {
-		dev_dbg(dev, "Unmapped sg src: virt=%pK dma=%pad len=0x%X\n",
+		dev_dbg(dev, "Unmapped sg src: virt=%p dma=%pad len=0x%X\n",
 			sg_virt(src), &sg_dma_address(src), sg_dma_len(src));
 		dma_unmap_sg(dev, src,
 			     areq_ctx->in_nents, DMA_TO_DEVICE);
 	}
 
 	if (*prev_len) {
-		dev_dbg(dev, "Unmapped buffer: areq_ctx->buff_sg=%pK dma=%pad len 0x%X\n",
+		dev_dbg(dev, "Unmapped buffer: areq_ctx->buff_sg=%p dma=%pad len 0x%X\n",
 			sg_virt(areq_ctx->buff_sg),
 			&sg_dma_address(areq_ctx->buff_sg),
 			sg_dma_len(areq_ctx->buff_sg));
diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index d39c067672fd61cf1703a321c91376ce75e45388..e2cbfdf7a0e46ee0fb261f890b5780f3dbeddee2 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -211,11 +211,11 @@ static int cc_cipher_init(struct crypto_tfm *tfm)
 						  max_key_buf_size,
 						  DMA_TO_DEVICE);
 	if (dma_mapping_error(dev, ctx_p->user.key_dma_addr)) {
-		dev_err(dev, "Mapping Key %u B at va=%pK for DMA failed\n",
+		dev_err(dev, "Mapping Key %u B at va=%p for DMA failed\n",
 			max_key_buf_size, ctx_p->user.key);
 		goto free_key;
 	}
-	dev_dbg(dev, "Mapped key %u B at va=%pK to dma=%pad\n",
+	dev_dbg(dev, "Mapped key %u B at va=%p to dma=%pad\n",
 		max_key_buf_size, ctx_p->user.key, &ctx_p->user.key_dma_addr);
 
 	return 0;
diff --git a/drivers/crypto/ccree/cc_hash.c b/drivers/crypto/ccree/cc_hash.c
index d0612bec4d58d78e28efb9826382091fa62dd1de..c6d085c8ff797e3f9cc62324be741c1a61f71e12 100644
--- a/drivers/crypto/ccree/cc_hash.c
+++ b/drivers/crypto/ccree/cc_hash.c
@@ -125,7 +125,7 @@ static int cc_map_result(struct device *dev, struct ahash_req_ctx *state,
 			digestsize);
 		return -ENOMEM;
 	}
-	dev_dbg(dev, "Mapped digest result buffer %u B at va=%pK to dma=%pad\n",
+	dev_dbg(dev, "Mapped digest result buffer %u B at va=%p to dma=%pad\n",
 		digestsize, state->digest_result_buff,
 		&state->digest_result_dma_addr);
 
@@ -184,11 +184,11 @@ static int cc_map_req(struct device *dev, struct ahash_req_ctx *state,
 		dma_map_single(dev, state->digest_buff,
 			       ctx->inter_digestsize, DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dev, state->digest_buff_dma_addr)) {
-		dev_err(dev, "Mapping digest len %d B at va=%pK for DMA failed\n",
+		dev_err(dev, "Mapping digest len %d B at va=%p for DMA failed\n",
 			ctx->inter_digestsize, state->digest_buff);
 		return -EINVAL;
 	}
-	dev_dbg(dev, "Mapped digest %d B at va=%pK to dma=%pad\n",
+	dev_dbg(dev, "Mapped digest %d B at va=%p to dma=%pad\n",
 		ctx->inter_digestsize, state->digest_buff,
 		&state->digest_buff_dma_addr);
 
@@ -197,11 +197,11 @@ static int cc_map_req(struct device *dev, struct ahash_req_ctx *state,
 			dma_map_single(dev, state->digest_bytes_len,
 				       HASH_MAX_LEN_SIZE, DMA_BIDIRECTIONAL);
 		if (dma_mapping_error(dev, state->digest_bytes_len_dma_addr)) {
-			dev_err(dev, "Mapping digest len %u B at va=%pK for DMA failed\n",
+			dev_err(dev, "Mapping digest len %u B at va=%p for DMA failed\n",
 				HASH_MAX_LEN_SIZE, state->digest_bytes_len);
 			goto unmap_digest_buf;
 		}
-		dev_dbg(dev, "Mapped digest len %u B at va=%pK to dma=%pad\n",
+		dev_dbg(dev, "Mapped digest len %u B at va=%p to dma=%pad\n",
 			HASH_MAX_LEN_SIZE, state->digest_bytes_len,
 			&state->digest_bytes_len_dma_addr);
 	}
@@ -212,12 +212,12 @@ static int cc_map_req(struct device *dev, struct ahash_req_ctx *state,
 				       ctx->inter_digestsize,
 				       DMA_BIDIRECTIONAL);
 		if (dma_mapping_error(dev, state->opad_digest_dma_addr)) {
-			dev_err(dev, "Mapping opad digest %d B at va=%pK for DMA failed\n",
+			dev_err(dev, "Mapping opad digest %d B at va=%p for DMA failed\n",
 				ctx->inter_digestsize,
 				state->opad_digest_buff);
 			goto unmap_digest_len;
 		}
-		dev_dbg(dev, "Mapped opad digest %d B at va=%pK to dma=%pad\n",
+		dev_dbg(dev, "Mapped opad digest %d B at va=%p to dma=%pad\n",
 			ctx->inter_digestsize, state->opad_digest_buff,
 			&state->opad_digest_dma_addr);
 	}
@@ -272,7 +272,7 @@ static void cc_unmap_result(struct device *dev, struct ahash_req_ctx *state,
 	if (state->digest_result_dma_addr) {
 		dma_unmap_single(dev, state->digest_result_dma_addr, digestsize,
 				 DMA_BIDIRECTIONAL);
-		dev_dbg(dev, "unmpa digest result buffer va (%pK) pa (%pad) len %u\n",
+		dev_dbg(dev, "unmpa digest result buffer va (%p) pa (%pad) len %u\n",
 			state->digest_result_buff,
 			&state->digest_result_dma_addr, digestsize);
 		memcpy(result, state->digest_result_buff, digestsize);
@@ -287,7 +287,7 @@ static void cc_update_complete(struct device *dev, void *cc_req, int err)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct cc_hash_ctx *ctx = crypto_ahash_ctx_dma(tfm);
 
-	dev_dbg(dev, "req=%pK\n", req);
+	dev_dbg(dev, "req=%p\n", req);
 
 	if (err != -EINPROGRESS) {
 		/* Not a BACKLOG notification */
@@ -306,7 +306,7 @@ static void cc_digest_complete(struct device *dev, void *cc_req, int err)
 	struct cc_hash_ctx *ctx = crypto_ahash_ctx_dma(tfm);
 	u32 digestsize = crypto_ahash_digestsize(tfm);
 
-	dev_dbg(dev, "req=%pK\n", req);
+	dev_dbg(dev, "req=%p\n", req);
 
 	if (err != -EINPROGRESS) {
 		/* Not a BACKLOG notification */
@@ -326,7 +326,7 @@ static void cc_hash_complete(struct device *dev, void *cc_req, int err)
 	struct cc_hash_ctx *ctx = crypto_ahash_ctx_dma(tfm);
 	u32 digestsize = crypto_ahash_digestsize(tfm);
 
-	dev_dbg(dev, "req=%pK\n", req);
+	dev_dbg(dev, "req=%p\n", req);
 
 	if (err != -EINPROGRESS) {
 		/* Not a BACKLOG notification */
@@ -1077,11 +1077,11 @@ static int cc_alloc_ctx(struct cc_hash_ctx *ctx)
 		dma_map_single(dev, ctx->digest_buff, sizeof(ctx->digest_buff),
 			       DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dev, ctx->digest_buff_dma_addr)) {
-		dev_err(dev, "Mapping digest len %zu B at va=%pK for DMA failed\n",
+		dev_err(dev, "Mapping digest len %zu B at va=%p for DMA failed\n",
 			sizeof(ctx->digest_buff), ctx->digest_buff);
 		goto fail;
 	}
-	dev_dbg(dev, "Mapped digest %zu B at va=%pK to dma=%pad\n",
+	dev_dbg(dev, "Mapped digest %zu B at va=%p to dma=%pad\n",
 		sizeof(ctx->digest_buff), ctx->digest_buff,
 		&ctx->digest_buff_dma_addr);
 
@@ -1090,12 +1090,12 @@ static int cc_alloc_ctx(struct cc_hash_ctx *ctx)
 			       sizeof(ctx->opad_tmp_keys_buff),
 			       DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(dev, ctx->opad_tmp_keys_dma_addr)) {
-		dev_err(dev, "Mapping opad digest %zu B at va=%pK for DMA failed\n",
+		dev_err(dev, "Mapping opad digest %zu B at va=%p for DMA failed\n",
 			sizeof(ctx->opad_tmp_keys_buff),
 			ctx->opad_tmp_keys_buff);
 		goto fail;
 	}
-	dev_dbg(dev, "Mapped opad_tmp_keys %zu B at va=%pK to dma=%pad\n",
+	dev_dbg(dev, "Mapped opad_tmp_keys %zu B at va=%p to dma=%pad\n",
 		sizeof(ctx->opad_tmp_keys_buff), ctx->opad_tmp_keys_buff,
 		&ctx->opad_tmp_keys_dma_addr);
 

---
base-commit: 52da431bf03b5506203bca27fe14a97895c80faf
change-id: 20250404-restricted-pointers-crypto-2143dbcf8dc1

Best regards,
-- 
Thomas Weißschuh <thomas.weissschuh@linutronix.de>

