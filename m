Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FDF401A11;
	Thu,  7 May 2026 14:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778164942; cv=none; b=prLrrkwGkWIcKKltAjWHoxvxQHZM0NLV3ibSb8iECvy52IRDZC25jVCw8eN79eVeZV0wcicMLYJIGtlggaHNMjJBp4YSriN0ueSs9EaZDl1G1lCg/i8aupLWSrZdZbQmawErCUiOTY1jdSHuDSOb7hdeExRoFo25SsL9MQkkVN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778164942; c=relaxed/simple;
	bh=r4oWaVJibYZrPknMo62+zsusCSWvuFjUGR1UmIBGJb4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Pd54zvoyeklruhWmTFeFKWxbG+9v5HyBmKZlQXQfYyyerpA3RBGhbHX4VjVmHlUhzDFm/87clbfq8j9E6RVQnY1ZSZY7Mzbrz/A/QI+0BX29NYFJusk0Y3ocqHO19AYcwXQ8hT43bacf8t6Z1LzkTbwf2Po82pbVoE22sLWulGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=TnV8DNLY; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="TnV8DNLY"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id BFE361A3565;
	Thu,  7 May 2026 14:42:18 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 8EBBE605D0;
	Thu,  7 May 2026 14:42:18 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 8028C108194EA;
	Thu,  7 May 2026 16:42:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1778164937; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=20gk6DUhYfnL8EJ806yf8Wc4c5MD9o0qn/el8R1v5T4=;
	b=TnV8DNLYl5DUbYZEnUhEkvEgnX94W/chP7INkIjeazhNNHIqLYDOKOTkY+B/wTh6jQmnAu
	gVxK2Tpr5OhsWCIcCKGzim+gHs4sASpB9C5+PlcIrk0ig5HjvzP23y6E09nCFq2dj4hLkT
	5aIjVKwyPtV4xlixNnDLvkNxidkkl8kbmvKZbaRgtpTXz0W2Lo9+DLe2zQQjDy1DHu5/qP
	Y/DJmYvQa83B4nU7bIlDKjCQ8TsyCuDk6tQCBXTbF4lqxF2K3WPD0Rat34ocpuWo3c8pVa
	a/AJDBIwOX0FV2diLIO7g+PeALM7EExlW5BNYRcNP+KhW+qzds60lWsZThRYbA==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 07 May 2026 16:41:53 +0200
Subject: [PATCH v3 07/11] crypto: talitos/hash - use descriptor chaining
 for SEC1 instead of workqueue
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-bootlin_test-7-1-rc1_sec_bugfix-v3-7-c98d7589b942@bootlin.com>
References: <20260507-bootlin_test-7-1-rc1_sec_bugfix-v3-0-c98d7589b942@bootlin.com>
In-Reply-To: <20260507-bootlin_test-7-1-rc1_sec_bugfix-v3-0-c98d7589b942@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, 
 David Howells <dhowells@redhat.com>, 
 Kim Phillips <kim.phillips@freescale.com>, 
 Christophe Leroy <chleroy@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Paul Louvel <paul.louvel@bootlin.com>, stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778164923; l=13442;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=r4oWaVJibYZrPknMo62+zsusCSWvuFjUGR1UmIBGJb4=;
 b=HceUKOWD8aoSV/WnnHsJKC6PMN8vwre98552kr9MQ7pqHHJMUAoZQT3bPzsOT4UE9GFXAk25Z
 2K9/9LdscgLB+68orzxIKYr+oL1dGpVLKVff0fyEGAvhQByYYNDfo5l
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Rework the SEC1 ahash implementation to build a chain of hardware
descriptors, replacing the previous approach of submitting one
descriptor at a time via a workqueue, introduced by commit 655ef638a2bc
("crypto: talitos - fix SEC1 32k ahash request limitation").

Introduce ahash_process_req_prepare() which iterates over the request
data, allocating enough descriptors to cover the entire ahash request.
The new fields (bufsl, src, first, last) are added to talitos_edesc for
this purpose.

common_nonsnoop_hash() no longer calls talitos_submit(); it only
maps and sets up the descriptor.  Submission is now done by the caller
after the chain is built.

ahash_free_desc_list_from() takes over calling
common_nonsnoop_hash_unmap() for each descriptor during cleanup.

Compared to the workqueue based solution, request are slightly faster
since there is no more scheduling latency induced by the workqueue, and
only one interrupt is generated by the device at the end of a chain.

Commit 655ef638a2bc ("crypto: talitos - fix SEC1 32k ahash request
limitation") :

$ /usr/libexec/libkcapi/sha256sum ./test_5M.bin
013c5609d63c...  ./test_5M.bin
real 0m 0.41s
user 0m 0.01s
sys  0m 0.07s

Now :

$ /usr/libexec/libkcapi/sha256sum ./test_5M.bin
013c5609d63c...  ./test_5M.bin
real 0m 0.33s
user 0m 0.01s
sys  0m 0.20s

Tested on a system with an MPC885 SoC featuring the SEC1 Lite.

The increase in sys time is due to the fact that commit 37b5e8897eb5
("crypto: talitos - chain in buffered data for ahash on SEC1") can no
longer be applied.

Cc: stable@vger.kernel.org
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos.c | 168 +++++++++++++++++++++++++++++------------------
 drivers/crypto/talitos.h |  10 +++
 2 files changed, 115 insertions(+), 63 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 0184982cb39b..883115d66fc4 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1791,12 +1791,12 @@ static void common_nonsnoop_hash_unmap(struct device *dev,
 
 	unmap_single_talitos_ptr(dev, &desc->ptr[5], DMA_FROM_DEVICE);
 
-	if (req_ctx->last_desc)
+	if (edesc->last && req_ctx->last_request)
 		memcpy(areq->result, req_ctx->hw_context,
 		       crypto_ahash_digestsize(tfm));
 
-	if (req_ctx->psrc)
-		talitos_sg_unmap(dev, edesc, req_ctx->psrc, NULL, 0, 0);
+	if (edesc->src)
+		talitos_sg_unmap(dev, edesc, edesc->src, NULL, 0, 0);
 
 	/* When using hashctx-in, must unmap it. */
 	if (from_talitos_ptr_len(&desc->ptr[1], is_sec1))
@@ -1808,12 +1808,14 @@ static void common_nonsnoop_hash_unmap(struct device *dev,
 				 DMA_BIDIRECTIONAL);
 }
 
-static void free_edesc_list_from(struct talitos_edesc *edesc)
+static void free_edesc_list_from(struct ahash_request *areq, struct talitos_edesc *edesc)
 {
+	struct talitos_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
 	struct talitos_edesc *next;
 
 	while (edesc) {
 		next = edesc->next_desc;
+		common_nonsnoop_hash_unmap(ctx->dev, edesc, areq);
 		kfree(edesc);
 		edesc = next;
 	}
@@ -1828,19 +1830,18 @@ static void ahash_done(struct device *dev,
 		 container_of(desc, struct talitos_edesc, desc);
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 
+
 	if (!req_ctx->last_desc && req_ctx->to_hash_later) {
 		/* Position any partial block for next update/final/finup */
 		req_ctx->buf_idx = (req_ctx->buf_idx + 1) & 1;
 		req_ctx->nbuf = req_ctx->to_hash_later;
 	}
-	common_nonsnoop_hash_unmap(dev, edesc, areq);
 
-	free_edesc_list_from(edesc);
+	free_edesc_list_from(areq, edesc);
 
-	if (err) {
-		ahash_request_complete(areq, err);
-		return;
-	}
+	ahash_request_complete(areq, err);
+
+	return;
 
 	req_ctx->remaining_ahash_request_bytes -=
 		req_ctx->current_ahash_request_bytes;
@@ -1874,18 +1875,15 @@ static void talitos_handle_buggy_hash(struct talitos_ctx *ctx,
 			       (char *)padded_hash, DMA_TO_DEVICE);
 }
 
-static int common_nonsnoop_hash(struct talitos_edesc *edesc,
-				struct ahash_request *areq, unsigned int length,
-				void (*callback) (struct device *dev,
-						  struct talitos_desc *desc,
-						  void *context, int error))
+static void common_nonsnoop_hash(struct talitos_edesc *edesc,
+				 struct ahash_request *areq,
+				 unsigned int length)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 	struct device *dev = ctx->dev;
 	struct talitos_desc *desc = &edesc->desc;
-	int ret;
 	bool sync_needed = false;
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
@@ -1894,7 +1892,7 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	/* first DWORD empty */
 
 	/* hash context in */
-	if (!req_ctx->first_desc || req_ctx->swinit) {
+	if (!edesc->first || !req_ctx->first_desc || req_ctx->swinit) {
 		map_single_talitos_ptr_nosync(dev, &desc->ptr[1],
 					      req_ctx->hw_context_size,
 					      req_ctx->hw_context,
@@ -1911,22 +1909,22 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 
 	sg_count = edesc->src_nents ?: 1;
 	if (is_sec1 && sg_count > 1)
-		sg_copy_to_buffer(req_ctx->psrc, sg_count, edesc->buf, length);
+		sg_copy_to_buffer(edesc->src, sg_count, edesc->buf, length);
 	else if (length)
-		sg_count = dma_map_sg(dev, req_ctx->psrc, sg_count,
-				      DMA_TO_DEVICE);
+		sg_count = dma_map_sg(dev, edesc->src, sg_count, DMA_TO_DEVICE);
+
 	/*
 	 * data in
 	 */
-	sg_count = talitos_sg_map(dev, req_ctx->psrc, length, edesc,
-					&desc->ptr[3], sg_count, 0, 0);
+	sg_count = talitos_sg_map(dev, edesc->src, length, edesc, &desc->ptr[3],
+				  sg_count, 0, 0);
 	if (sg_count > 1)
 		sync_needed = true;
 
 	/* fifth DWORD empty */
 
 	/* hash/HMAC out -or- hash context out */
-	if (req_ctx->last_desc)
+	if (edesc->last && req_ctx->last_request)
 		map_single_talitos_ptr(dev, &desc->ptr[5],
 				       crypto_ahash_digestsize(tfm),
 				       req_ctx->hw_context, DMA_FROM_DEVICE);
@@ -1944,30 +1942,89 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	if (sync_needed)
 		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
 					   edesc->dma_len, DMA_BIDIRECTIONAL);
-
-	ret = talitos_submit(dev, ctx->ch, desc, callback,
-			     areq);
-	if (ret != -EINPROGRESS)
-		goto err;
-
-	return -EINPROGRESS;
-err:
-	common_nonsnoop_hash_unmap(dev, edesc, areq);
-	kfree(edesc);
-	return ret;
 }
 
 static struct talitos_edesc *ahash_edesc_alloc(struct ahash_request *areq,
+					       struct scatterlist *src,
 					       unsigned int nbytes)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 
-	return talitos_edesc_alloc(ctx->dev, req_ctx->psrc, NULL, NULL, 0,
+	return talitos_edesc_alloc(ctx->dev, src, NULL, NULL, 0,
 				   nbytes, 0, 0, 0, areq->base.flags, false);
 }
 
+static struct talitos_edesc *
+ahash_process_req_prepare(struct ahash_request *areq, unsigned int nbytes,
+			  unsigned int blocksize, bool is_sec1)
+{
+	struct talitos_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+	struct talitos_edesc *first = NULL, *prev_edesc = NULL, *edesc;
+	size_t desc_max = is_sec1 ? TALITOS1_MAX_DATA_LEN : SIZE_MAX;
+	struct scatterlist tmp[2];
+	size_t to_hash_this_desc;
+	struct scatterlist *src;
+	size_t offset = 0;
+
+	do {
+		src = scatterwalk_ffwd(tmp, req_ctx->psrc, offset);
+
+		to_hash_this_desc =
+			min(nbytes, ALIGN_DOWN(desc_max, blocksize));
+
+		/* Allocate extended descriptor */
+		edesc = ahash_edesc_alloc(areq, src, to_hash_this_desc);
+		if (IS_ERR(edesc)) {
+			if (first)
+				free_edesc_list_from(areq, first);
+			return edesc;
+		}
+
+		edesc->src =
+			scatterwalk_ffwd(edesc->bufsl, req_ctx->psrc, offset);
+		edesc->desc.hdr = ctx->desc_hdr_template;
+		edesc->first = offset == 0;
+		edesc->last = nbytes - to_hash_this_desc == 0;
+
+		/* On last one, request SEC to pad; otherwise continue */
+		if (req_ctx->last_request && edesc->last)
+			edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_PAD;
+		else
+			edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_CONT;
+
+		/* request SEC to INIT hash. */
+		if (req_ctx->first_desc && edesc->first && !req_ctx->swinit)
+			edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_INIT;
+
+		/*
+		 * When the tfm context has a keylen, it's an HMAC.
+		 * A first or last (ie. not middle) descriptor must request HMAC.
+		 */
+		if (ctx->keylen && ((req_ctx->first_desc && edesc->first) ||
+				    (req_ctx->last_request && edesc->last)))
+			edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_HMAC;
+
+		/* clear the DN bit  */
+		if (is_sec1 && !edesc->last)
+			edesc->desc.hdr &= ~DESC_HDR_DONE_NOTIFY;
+
+		common_nonsnoop_hash(edesc, areq, to_hash_this_desc);
+
+		offset += to_hash_this_desc;
+		nbytes -= to_hash_this_desc;
+
+		if (!prev_edesc)
+			first = edesc;
+		else
+			prev_edesc->next_desc = edesc;
+		prev_edesc = edesc;
+	} while (nbytes);
+
+	return first;
+}
+
 static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
@@ -1976,14 +2033,16 @@ static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes
 	struct talitos_edesc *edesc;
 	unsigned int blocksize =
 			crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
+	bool is_sec1 = has_ftr_sec1(dev_get_drvdata(ctx->dev));
 	unsigned int nbytes_to_hash;
 	unsigned int to_hash_later;
 	unsigned int nsg;
 	int nents;
 	struct device *dev = ctx->dev;
 	u8 *ctx_buf = req_ctx->buf[req_ctx->buf_idx];
+	int ret;
 
-	if (!req_ctx->last_desc && (nbytes + req_ctx->nbuf <= blocksize)) {
+	if (!req_ctx->last_request && (nbytes + req_ctx->nbuf <= blocksize)) {
 		/* Buffer up to one whole block */
 		nents = sg_nents_for_len(req_ctx->request_sl, nbytes);
 		if (nents < 0) {
@@ -2000,7 +2059,7 @@ static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes
 	nbytes_to_hash = nbytes + req_ctx->nbuf;
 	to_hash_later = nbytes_to_hash & (blocksize - 1);
 
-	if (req_ctx->last_desc)
+	if (req_ctx->last_request)
 		to_hash_later = 0;
 	else if (to_hash_later)
 		/* There is a partial block. Hash the full block(s) now */
@@ -2035,30 +2094,16 @@ static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes
 	}
 	req_ctx->to_hash_later = to_hash_later;
 
-	/* Allocate extended descriptor */
-	edesc = ahash_edesc_alloc(req_ctx->areq, nbytes_to_hash);
+	edesc = ahash_process_req_prepare(areq, nbytes_to_hash, blocksize,
+					  is_sec1);
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
-	edesc->desc.hdr = ctx->desc_hdr_template;
-
-	/* On last one, request SEC to pad; otherwise continue */
-	if (req_ctx->last_desc)
-		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_PAD;
-	else
-		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_CONT;
-
-	/* request SEC to INIT hash. */
-	if (req_ctx->first_desc && !req_ctx->swinit)
-		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_INIT;
-
-	/* When the tfm context has a keylen, it's an HMAC.
-	 * A first or last (ie. not middle) descriptor must request HMAC.
-	 */
-	if (ctx->keylen && (req_ctx->first_desc || req_ctx->last_desc))
-		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_HMAC;
+	ret = talitos_submit(dev, ctx->ch, &edesc->desc, ahash_done, areq);
+	if (ret != -EINPROGRESS)
+		free_edesc_list_from(areq, edesc);
 
-	return common_nonsnoop_hash(edesc, req_ctx->areq, nbytes_to_hash, ahash_done);
+	return ret;
 }
 
 static void sec1_ahash_process_remaining(struct work_struct *work)
@@ -2102,16 +2147,13 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 	req_ctx->remaining_ahash_request_bytes = nbytes;
 
 	if (is_sec1) {
-		if (nbytes > TALITOS1_MAX_DATA_LEN)
-			nbytes = TALITOS1_MAX_DATA_LEN;
-		else if (req_ctx->last_request)
+		if (req_ctx->last_request)
 			req_ctx->last_desc = 1;
 	}
 
 	req_ctx->current_ahash_request_bytes = nbytes;
 
-	return ahash_process_req_one(req_ctx->areq,
-				     req_ctx->current_ahash_request_bytes);
+	return ahash_process_req_one(req_ctx->areq, nbytes);
 }
 
 static int ahash_init(struct ahash_request *areq)
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 596f96bba3ef..11f0eb6a41db 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -44,6 +44,11 @@ struct talitos_desc {
 
 /*
  * talitos_edesc - s/w-extended descriptor
+ * @bufsl: scatterlist buffer
+ * @src: pointer to input scatterlist
+ * @first: first descriptor of a chain
+ * @last: last descriptor of a chain
+ *
  * @src_nents: number of segments in input scatterlist
  * @dst_nents: number of segments in output scatterlist
  * @iv_dma: dma address of iv for checking continuity and link table
@@ -59,6 +64,11 @@ struct talitos_desc {
  * of link_tbl data
  */
 struct talitos_edesc {
+	struct scatterlist bufsl[2];
+	struct scatterlist *src;
+	int first;
+	int last;
+
 	int src_nents;
 	int dst_nents;
 	dma_addr_t iv_dma;

-- 
2.54.0

