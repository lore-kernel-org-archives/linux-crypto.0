Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DF74B8DC2
	for <linux-crypto@vger.kernel.org>; Tue,  5 May 2026 17:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778003646; cv=none; b=DxjgYXk5QaSU/mT/qBQmY+c/xpI5tPMDJJ5r16T7t6jStHQ06AOqef12LI5Ff5dsYAwLI3Phyhu+HXhPkSOHausMb+UMQTPnw9tMd44sfi/uOi3ELcCqZx57oB34ihNVxj/4HfzmEXRI0nRiPMuUR5X55U36vo+3Gq2196yu1iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778003646; c=relaxed/simple;
	bh=OMYxZs9XE8R8nLGQ/7IlFs0u83h+dEbGq7xq0kUbR1U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=B63h1RxvnP1UHOlKFKxezeW6/MfF+ScA/BxOh+xvsJpyCP/j18dmZHgQLc7d+7ljwstRkDPyKvXO+nhuXAG7UqHM69IYdrT6aRT7XFiV8rj2gzRkyAiFQ7NEV1HUHIRUXqyxBKiMcj6Qgq9/xA5GeqpnPjlfJNbCr1nbz+Aqq4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=j76ZclqC; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="j76ZclqC"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id D5BF34E42BD6;
	Tue,  5 May 2026 17:53:59 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id AC1CB6053C;
	Tue,  5 May 2026 17:53:59 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 8AF6811AD0412;
	Tue,  5 May 2026 19:53:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1778003638; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=Ym+CkLUj3hotoqhZyVQhRlReEdrG4pvxZ0e/b3zAjT4=;
	b=j76ZclqCHnWp5MqM2Qk/xiGEENlhLETTRDcQM286hmk6EneuyykdCsn0ecJ7bLmtz/+3NA
	5lCG0m2JvoA2ttRUaFlDvrfuPQ+0IihYkEgnA8ExhviOGxrCEcTXXKLbKzSv566czpHNtk
	93bomXQNZOckPH1f9/FqV9Af1UxcY9Zh7WoHo2DssYAZbKttLvPiod/p/kYqdHotZ+eRga
	C5iE96BOAhgTP/N233QndR7ihH0M8y5K+B/xVZxWcjdM9hS/jXf+PxrOTIIPm7YyFfbwjr
	UNB6aPu7vUfryzBAEN4Tw0X0ZQToXPH6c1Zsh1pNQB32PjYDxK7O4NsV5HTFiQ==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Tue, 05 May 2026 19:53:08 +0200
Subject: [PATCH v2 07/12] crypto: talitos/hash - use descriptor chaining
 for SEC1 instead of workqueue
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-bootlin_test-7-1-rc1_sec_bugfix-v2-7-5818064bd190@bootlin.com>
References: <20260505-bootlin_test-7-1-rc1_sec_bugfix-v2-0-5818064bd190@bootlin.com>
In-Reply-To: <20260505-bootlin_test-7-1-rc1_sec_bugfix-v2-0-5818064bd190@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, 
 David Howells <dhowells@redhat.com>, 
 Kim Phillips <kim.phillips@freescale.com>, 
 Christophe Leroy <chleroy@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Paul Louvel <paul.louvel@bootlin.com>, stable@vger.kernel.org
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778003630; l=13626;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=OMYxZs9XE8R8nLGQ/7IlFs0u83h+dEbGq7xq0kUbR1U=;
 b=+92BFWnEu90v3lJrA1TLFVuzhsMx+HRYTPhVMUuCnyS7wY0YlsgqWyuEpwnKCsS2P2Q35TxhJ
 EE8PMA4XCQpACRN2k+ql551nxUoRGWr7jQz6mKGMt+YRyWfe5bMTRvj
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
real 0m 0.37s
user 0m 0.00s
sys  0m 0.20s

Tested on a system with an MPC885 SoC featuring the SEC1 Lite.

The increase in sys time is due to the fact that commit 37b5e8897eb5
("crypto: talitos - chain in buffered data for ahash on SEC1") can no
longer be applied.

Cc: stable@vger.kernel.org
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos.c | 168 ++++++++++++++++++++++++++++++-----------------
 drivers/crypto/talitos.h |  10 +++
 2 files changed, 118 insertions(+), 60 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 1f47424b93c7..450f81fc0137 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1803,12 +1803,13 @@ static void common_nonsnoop_hash_unmap(struct device *dev,
 
 	unmap_single_talitos_ptr(dev, &desc->ptr[5], DMA_FROM_DEVICE);
 
-	if (req_ctx->last_desc)
+	if (edesc->last && req_ctx->last_request)
 		memcpy(areq->result, req_ctx->hw_context,
 		       crypto_ahash_digestsize(tfm));
 
-	if (req_ctx->psrc)
-		talitos_sg_unmap(dev, edesc, req_ctx->psrc, NULL, 0, 0);
+	if (edesc->src)
+		talitos_sg_unmap(dev, edesc, edesc->src, NULL, 0, 0);
+
 
 	/* When using hashctx-in, must unmap it. */
 	if (from_talitos_ptr_len(&desc->ptr[1], is_sec1))
@@ -1823,11 +1824,13 @@ static void common_nonsnoop_hash_unmap(struct device *dev,
 static void ahash_free_desc_list_from(struct ahash_request *areq,
 				      struct talitos_edesc *edesc)
 {
+	struct talitos_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 	struct talitos_edesc *tmp;
 
 	list_for_each_entry_safe_from(edesc, tmp, &req_ctx->desc_list, node) {
 		list_del(&edesc->node);
+		common_nonsnoop_hash_unmap(ctx->dev, edesc, areq);
 		kfree(edesc);
 	}
 }
@@ -1837,8 +1840,6 @@ static void ahash_done(struct device *dev,
 		       int err)
 {
 	struct ahash_request *areq = context;
-	struct talitos_edesc *edesc =
-		 container_of(desc, struct talitos_edesc, desc);
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 
 	if (!req_ctx->last_desc && req_ctx->to_hash_later) {
@@ -1846,16 +1847,14 @@ static void ahash_done(struct device *dev,
 		req_ctx->buf_idx = (req_ctx->buf_idx + 1) & 1;
 		req_ctx->nbuf = req_ctx->to_hash_later;
 	}
-	common_nonsnoop_hash_unmap(dev, edesc, areq);
 
 	ahash_free_desc_list_from(areq,
 				  list_first_entry(&req_ctx->desc_list,
 						   struct talitos_edesc, node));
 
-	if (err) {
-		ahash_request_complete(areq, err);
-		return;
-	}
+	ahash_request_complete(areq, err);
+
+	return;
 
 	req_ctx->remaining_ahash_request_bytes -=
 		req_ctx->current_ahash_request_bytes;
@@ -1889,18 +1888,15 @@ static void talitos_handle_buggy_hash(struct talitos_ctx *ctx,
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
@@ -1909,7 +1905,7 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	/* first DWORD empty */
 
 	/* hash context in */
-	if (!req_ctx->first_desc || req_ctx->swinit) {
+	if (!edesc->first || !req_ctx->first_desc || req_ctx->swinit) {
 		map_single_talitos_ptr_nosync(dev, &desc->ptr[1],
 					      req_ctx->hw_context_size,
 					      req_ctx->hw_context,
@@ -1926,22 +1922,22 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 
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
@@ -1959,26 +1955,91 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	if (sync_needed)
 		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
 					   edesc->dma_len, DMA_BIDIRECTIONAL);
-
-	ret = talitos_submit(dev, ctx->ch, desc, callback, areq);
-	if (ret != -EINPROGRESS) {
-		common_nonsnoop_hash_unmap(dev, edesc, areq);
-		kfree(edesc);
-	}
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
 
+static int ahash_process_req_prepare(struct ahash_request *areq,
+				     unsigned int nbytes,
+				     unsigned int blocksize, bool is_sec1)
+{
+	struct talitos_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+	size_t desc_max = is_sec1 ? TALITOS1_MAX_DATA_LEN : SIZE_MAX;
+	struct talitos_edesc *edesc;
+	struct scatterlist tmp[2];
+	size_t to_hash_this_desc;
+	struct scatterlist *src;
+	size_t offset = 0;
+
+	INIT_LIST_HEAD(&req_ctx->desc_list);
+	do {
+		src = scatterwalk_ffwd(tmp, req_ctx->psrc, offset);
+
+		to_hash_this_desc =
+			min(nbytes, ALIGN_DOWN(desc_max, blocksize));
+
+		/* Allocate extended descriptor */
+		edesc = ahash_edesc_alloc(areq, src, to_hash_this_desc);
+		if (IS_ERR(edesc)) {
+			if (!list_empty(&req_ctx->desc_list)) {
+				edesc = list_first_entry(&req_ctx->desc_list,
+							 struct talitos_edesc,
+							 node);
+				ahash_free_desc_list_from(areq, edesc);
+			}
+
+			return PTR_ERR(edesc);
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
+		list_add_tail(&edesc->node, &req_ctx->desc_list);
+
+		common_nonsnoop_hash(edesc, areq, to_hash_this_desc);
+
+		offset += to_hash_this_desc;
+		nbytes -= to_hash_this_desc;
+	} while (nbytes);
+
+	return 0;
+}
+
 static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
@@ -1987,14 +2048,16 @@ static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes
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
@@ -2011,7 +2074,7 @@ static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes
 	nbytes_to_hash = nbytes + req_ctx->nbuf;
 	to_hash_later = nbytes_to_hash & (blocksize - 1);
 
-	if (req_ctx->last_desc)
+	if (req_ctx->last_request)
 		to_hash_later = 0;
 	else if (to_hash_later)
 		/* There is a partial block. Hash the full block(s) now */
@@ -2046,33 +2109,19 @@ static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes
 	}
 	req_ctx->to_hash_later = to_hash_later;
 
-	/* Allocate extended descriptor */
-	edesc = ahash_edesc_alloc(req_ctx->areq, nbytes_to_hash);
-	if (IS_ERR(edesc))
-		return PTR_ERR(edesc);
-
-	INIT_LIST_HEAD(&req_ctx->desc_list);
-	list_add_tail(&edesc->node, &req_ctx->desc_list);
-
-	edesc->desc.hdr = ctx->desc_hdr_template;
-
-	/* On last one, request SEC to pad; otherwise continue */
-	if (req_ctx->last_desc)
-		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_PAD;
-	else
-		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_CONT;
+	ret = ahash_process_req_prepare(areq, nbytes_to_hash, blocksize,
+					is_sec1);
+	if (ret)
+		return ret;
 
-	/* request SEC to INIT hash. */
-	if (req_ctx->first_desc && !req_ctx->swinit)
-		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_INIT;
+	edesc = list_first_entry(&req_ctx->desc_list, struct talitos_edesc,
+				 node);
 
-	/* When the tfm context has a keylen, it's an HMAC.
-	 * A first or last (ie. not middle) descriptor must request HMAC.
-	 */
-	if (ctx->keylen && (req_ctx->first_desc || req_ctx->last_desc))
-		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_HMAC;
+	ret = talitos_submit(dev, ctx->ch, &edesc->desc, ahash_done, areq);
+	if (ret != -EINPROGRESS)
+		ahash_free_desc_list_from(areq, edesc);
 
-	return common_nonsnoop_hash(edesc, req_ctx->areq, nbytes_to_hash, ahash_done);
+	return ret;
 }
 
 static void sec1_ahash_process_remaining(struct work_struct *work)
@@ -2124,8 +2173,7 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 
 	req_ctx->current_ahash_request_bytes = nbytes;
 
-	return ahash_process_req_one(req_ctx->areq,
-				     req_ctx->current_ahash_request_bytes);
+	return ahash_process_req_one(req_ctx->areq, areq->nbytes);
 }
 
 static int ahash_init(struct ahash_request *areq)
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index ac75c2ddecb9..efba34458b12 100644
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
2.53.0

