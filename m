Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28DC13E0232
	for <linux-crypto@vger.kernel.org>; Mon,  4 May 2026 15:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777909184; cv=none; b=OJ4eN97HYUnTgoGpBCxJ85lw4JxTEuYM7D/uEhGhz80Dt71FpZePee59AAx3mIJCtxCSoilTelFd4Nkb9GxxuYlay37qFqC0jA0pWwSuwauvPJBgSzhApxSK0XUY4HajQbHQaaBEQGMXbfB3CTLeyTkiNJ/2NMeL253UXgMWQHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777909184; c=relaxed/simple;
	bh=apFmhEO/cUDEV7PQ1yNLjuu39N3a7AyxGDS+MflG8mM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OhT+n7Umd3c5NRqDfOg9kkht2jyRpRfXZ8Q+x63bHQA6kSLctmzOI1+UiMsNV1J/7W4NCcqeqf5MsUXxKPFbvpR8x3H9OXRymljlc2fNogBuMK86hhik9UzrXMLAD2PnqAbq3mxFzKUh2vSCFZIT4GePVUfEWpP2nXF0F50qI9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=dODzHycf; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="dODzHycf"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 943A84E42BB3;
	Mon,  4 May 2026 15:39:38 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 682ED5FD5F;
	Mon,  4 May 2026 15:39:38 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id B439E11AD2BCF;
	Mon,  4 May 2026 17:39:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1777909177; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=vKri8qzuHSFOAgsOHzYu1EBqQXOaekQs4V9gLkHEBno=;
	b=dODzHycfiGtmC0XM7Tl8Nenwm6p+/cKgV0dZ9L9AaXUKkk/IySfERTgp3PtRnl2zOhVTxn
	U3Uqv06ofeXsVOfsPH2TCXOSbgMB05JNRad7/ZYgiKDpD+8m2Nk3Cw4U0kOuWZyjPiwiKo
	2lYR8uUzneVpALvefmt5N4GLY97yrOBULdPmTGvToWDFjUy9j4LVzQjrFkhRaiqibyRTLM
	1LlcXgqTSmosa6rP0o2NnDYmHEyoCC6QeHoIVXT8Np6Nk4LmhCw+8x+1YV9vWDZaUqECU+
	9GVldO6hSV7JMWB2T5c5YeoSlAbHPMJvBE/wNupWOW4bV0qv71EyDPbLX9mrrQ==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Mon, 04 May 2026 17:38:27 +0200
Subject: [PATCH 1/4] crypto: talitos - use hardware facilities for large
 ahash requests
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260504-bootlin_test-7-1-rc1_sec_bugfix-v1-1-c97c641976f5@bootlin.com>
References: <20260504-bootlin_test-7-1-rc1_sec_bugfix-v1-0-c97c641976f5@bootlin.com>
In-Reply-To: <20260504-bootlin_test-7-1-rc1_sec_bugfix-v1-0-c97c641976f5@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, 
 David Howells <dhowells@redhat.com>, 
 Kim Phillips <kim.phillips@freescale.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Paul Louvel <paul.louvel@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777909177; l=29493;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=apFmhEO/cUDEV7PQ1yNLjuu39N3a7AyxGDS+MflG8mM=;
 b=3tFMCx3O0aCtLL/m9pKH+WGU+T/jtTVNA9ezez6Ykn3wjNNHWyRX4aFhSihL4DjXNyiU9BsGt
 KzUHhB4MsMhC2/cNi9r7s6fQL1Ij3hK35H+qZKhbambV5DIZ5IO7UcB
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Commit 655ef638a2bc ("crypto: talitos - fix SEC1 32k ahash request
limitation") works around the SEC1 per-descriptor data limit by
scheduling remaining work on the system workqueue, incurring
scheduling latency and one interrupt per descriptor.

SEC2 hardware also suffers from the same per-descriptor limitation, but
instead of a limit of 32k, it has a limit of 64k - 1 bytes.

Replace the previous approach by implementing support for hardware
backed multi descriptors handling :

- SEC1: Use descriptor chaining.  Descriptors are linked via their
  Next Descriptor field; only the DONE bit on the last descriptor
  is set, so the engine raises a single interrupt per request.
  Only submit the first descriptor of the chain, the hardware will fetch
  the next one without host intervention.

- SEC2: Use the per-channel fetch FIFO (up to 24 entries).  Unlike the
  SEC1, each descriptor has its DONE bit set to preserve flush_channel()
  semantics, and each descriptor is submitted.

This removes the workqueue-based splitting entirely and mitigates the
(64k - 1) byte ahash request limit on SEC2.

Cc: stable@vger.kernel.org
Fixes: c662b043cdca ("crypto: af_alg/hash: Support MSG_SPLICE_PAGES")
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos.c | 558 +++++++++++++++++++++++++----------------------
 drivers/crypto/talitos.h |  14 ++
 2 files changed, 313 insertions(+), 259 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index bc61d0fe3514..458a6a56d65b 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -12,8 +12,8 @@
  * All rights reserved.
  */
 
-#include <linux/workqueue.h>
 #include <linux/kernel.h>
+#include <linux/list.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
 #include <linux/device.h>
@@ -255,6 +255,55 @@ static int init_device(struct device *dev)
 	return 0;
 }
 
+static void sec1_map_descriptor(struct device *dev,
+				struct talitos_request *request,
+				struct talitos_desc *desc)
+{
+	struct talitos_edesc *edesc =
+		container_of(desc, struct talitos_edesc, desc);
+	struct talitos_edesc *prev_edesc = NULL;
+	dma_addr_t dma_desc, prev_dma_desc;
+
+	/*
+	 * Since the first descriptor in the chain is the one passed to this function,
+	 * the prev ptr is guaranteed to be the descriptor list head.
+	 */
+
+	request->desc_chain = edesc->node.prev;
+
+	list_for_each_entry(edesc, request->desc_chain, node) {
+		edesc->desc.hdr1 = edesc->desc.hdr;
+
+		dma_desc = dma_map_single(dev, &edesc->desc.hdr1,
+					  TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
+
+		if (!prev_edesc) {
+			request->dma_desc = dma_desc;
+			goto next;
+		}
+
+		/* chain in any previous descriptors */
+
+		prev_edesc->desc.next_desc = cpu_to_be32(dma_desc);
+
+		dma_sync_single_for_device(dev, prev_dma_desc,
+					   TALITOS_DESC_SIZE, DMA_TO_DEVICE);
+
+next:
+		prev_edesc = edesc;
+		prev_dma_desc = dma_desc;
+	}
+}
+
+static void sec2_map_descriptor(struct device *dev,
+				struct talitos_request *request,
+				struct talitos_desc *desc)
+{
+	request->dma_desc =
+		dma_map_single(dev, desc, TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
+	request->desc_chain = NULL;
+}
+
 /**
  * talitos_submit - submits a descriptor to the device for processing
  * @dev:	the SEC device to be used
@@ -291,16 +340,10 @@ static int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
 	request = &priv->chan[ch].fifo[head];
 
 	/* map descriptor and save caller data */
-	if (is_sec1) {
-		desc->hdr1 = desc->hdr;
-		request->dma_desc = dma_map_single(dev, &desc->hdr1,
-						   TALITOS_DESC_SIZE,
-						   DMA_BIDIRECTIONAL);
-	} else {
-		request->dma_desc = dma_map_single(dev, desc,
-						   TALITOS_DESC_SIZE,
-						   DMA_BIDIRECTIONAL);
-	}
+	if (is_sec1)
+		sec1_map_descriptor(dev, request, desc);
+	else
+		sec2_map_descriptor(dev, request, desc);
 	request->callback = callback;
 	request->context = context;
 
@@ -326,15 +369,33 @@ static __be32 get_request_hdr(struct talitos_request *request, bool is_sec1)
 {
 	struct talitos_edesc *edesc;
 
-	if (!is_sec1)
+	if (is_sec1) {
+		edesc = list_last_entry(request->desc_chain,
+					struct talitos_edesc, node);
+		return edesc->desc.hdr1;
+	} else {
 		return request->desc->hdr;
+	}
+}
 
-	if (!request->desc->next_desc)
-		return request->desc->hdr1;
+static void dma_unmap_request(struct device *dev,
+			      struct talitos_request *request, bool is_sec1)
+{
+	struct talitos_edesc *edesc;
 
-	edesc = container_of(request->desc, struct talitos_edesc, desc);
+	dma_unmap_single(dev, request->dma_desc, TALITOS_DESC_SIZE,
+			 DMA_BIDIRECTIONAL);
 
-	return ((struct talitos_desc *)(edesc->buf + edesc->dma_len))->hdr1;
+	if (is_sec1) {
+		list_for_each_entry(edesc, request->desc_chain, node) {
+			if (!edesc->desc.next_desc)
+				break;
+
+			dma_unmap_single(dev,
+					 be32_to_cpu(edesc->desc.next_desc),
+					 TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
+		}
+	}
 }
 
 /*
@@ -358,6 +419,8 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 
 		/* descriptors with their done bits set don't get the error */
 		rmb();
+
+		dma_unmap_request(dev, request, is_sec1);
 		hdr = get_request_hdr(request, is_sec1);
 
 		if ((hdr & DESC_HDR_DONE) == DESC_HDR_DONE)
@@ -368,10 +431,6 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 			else
 				status = error;
 
-		dma_unmap_single(dev, request->dma_desc,
-				 TALITOS_DESC_SIZE,
-				 DMA_BIDIRECTIONAL);
-
 		/* copy entries so we can call callback outside lock */
 		saved_req.desc = request->desc;
 		saved_req.callback = request->callback;
@@ -459,14 +518,42 @@ DEF_TALITOS2_DONE(ch0, TALITOS2_ISR_CH_0_DONE)
 DEF_TALITOS2_DONE(ch0_2, TALITOS2_ISR_CH_0_2_DONE)
 DEF_TALITOS2_DONE(ch1_3, TALITOS2_ISR_CH_1_3_DONE)
 
+static __be32 sec1_current_desc_hdr(struct talitos_request *request,
+				    dma_addr_t cpdr)
+{
+	struct talitos_edesc *edesc;
+
+	/* if the descriptor is the first of the chain */
+	if (request->dma_desc == cpdr)
+		return request->desc->hdr1;
+
+	/* otherwise iterate through the chain */
+	list_for_each_entry(edesc, request->desc_chain, node)
+		if (edesc->desc.next_desc == cpu_to_be32(cpdr))
+			return list_next_entry(edesc, node)->desc.hdr1;
+
+	return 0;
+}
+
+static __be32 sec2_current_desc_hdr(struct talitos_request *request,
+				    dma_addr_t cpdr)
+{
+	if (request->dma_desc == cpdr)
+		return request->desc->hdr;
+
+	return 0;
+}
+
 /*
  * locate current (offending) descriptor
  */
 static __be32 current_desc_hdr(struct device *dev, int ch)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
+	bool is_sec1 = has_ftr_sec1(priv);
 	int tail, iter;
 	dma_addr_t cur_desc;
+	__be32 hdr = 0;
 
 	cur_desc = ((u64)in_be32(priv->chan[ch].reg + TALITOS_CDPR)) << 32;
 	cur_desc |= in_be32(priv->chan[ch].reg + TALITOS_CDPR_LO);
@@ -477,27 +564,25 @@ static __be32 current_desc_hdr(struct device *dev, int ch)
 	}
 
 	tail = priv->chan[ch].tail;
-
 	iter = tail;
-	while (priv->chan[ch].fifo[iter].dma_desc != cur_desc &&
-	       priv->chan[ch].fifo[iter].desc->next_desc != cpu_to_be32(cur_desc)) {
-		iter = (iter + 1) & (priv->fifo_len - 1);
-		if (iter == tail) {
-			dev_err(dev, "couldn't locate current descriptor\n");
-			return 0;
-		}
-	}
+	do {
+		if (is_sec1)
+			hdr = sec1_current_desc_hdr(&priv->chan[ch].fifo[iter],
+						    cur_desc);
+		else
+			hdr = sec2_current_desc_hdr(&priv->chan[ch].fifo[iter],
+						    cur_desc);
 
-	if (priv->chan[ch].fifo[iter].desc->next_desc == cpu_to_be32(cur_desc)) {
-		struct talitos_edesc *edesc;
+		if (hdr)
+			break;
 
-		edesc = container_of(priv->chan[ch].fifo[iter].desc,
-				     struct talitos_edesc, desc);
-		return ((struct talitos_desc *)
-			(edesc->buf + edesc->dma_len))->hdr;
-	}
+		iter = (iter + 1) & (priv->fifo_len - 1);
+	} while (iter != tail);
 
-	return priv->chan[ch].fifo[iter].desc->hdr;
+	if (!hdr)
+		dev_err(dev, "couldn't locate current descriptor\n");
+
+	return hdr;
 }
 
 /*
@@ -874,15 +959,9 @@ struct talitos_ahash_req_ctx {
 	unsigned int last_request;
 	unsigned int to_hash_later;
 	unsigned int nbuf;
+	struct list_head desc_list;
 	struct scatterlist bufsl[2];
 	struct scatterlist *psrc;
-
-	struct scatterlist request_bufsl[2];
-	struct ahash_request *areq;
-	struct scatterlist *request_sl;
-	unsigned int remaining_ahash_request_bytes;
-	unsigned int current_ahash_request_bytes;
-	struct work_struct sec1_ahash_process_remaining;
 };
 
 struct talitos_export_state {
@@ -1396,10 +1475,6 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 		dma_len = 0;
 	}
 	alloc_len += icv_stashing ? authsize : 0;
-
-	/* if its a ahash, add space for a second desc next to the first one */
-	if (is_sec1 && !dst)
-		alloc_len += sizeof(struct talitos_desc);
 	alloc_len += ivsize;
 
 	edesc = kmalloc(ALIGN(alloc_len, dma_get_cache_alignment()), flags);
@@ -1411,6 +1486,7 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 	}
 	memset(&edesc->desc, 0, sizeof(edesc->desc));
 
+	INIT_LIST_HEAD(&edesc->node);
 	edesc->src_nents = src_nents;
 	edesc->dst_nents = dst_nents;
 	edesc->iv_dma = iv_dma;
@@ -1715,73 +1791,106 @@ static void common_nonsnoop_hash_unmap(struct device *dev,
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
 	struct talitos_desc *desc = &edesc->desc;
-	struct talitos_desc *desc2 = (struct talitos_desc *)
-				     (edesc->buf + edesc->dma_len);
 
 	unmap_single_talitos_ptr(dev, &desc->ptr[5], DMA_FROM_DEVICE);
-	if (desc->next_desc &&
-	    desc->ptr[5].ptr != desc2->ptr[5].ptr)
-		unmap_single_talitos_ptr(dev, &desc2->ptr[5], DMA_FROM_DEVICE);
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
 		unmap_single_talitos_ptr(dev, &desc->ptr[1],
 					 DMA_TO_DEVICE);
-	else if (desc->next_desc)
-		unmap_single_talitos_ptr(dev, &desc2->ptr[1],
-					 DMA_TO_DEVICE);
-
-	if (is_sec1 && req_ctx->nbuf)
-		unmap_single_talitos_ptr(dev, &desc->ptr[3],
-					 DMA_TO_DEVICE);
 
 	if (edesc->dma_len)
 		dma_unmap_single(dev, edesc->dma_link_tbl, edesc->dma_len,
 				 DMA_BIDIRECTIONAL);
+}
+
+static void ahash_free_desc_list_from(struct ahash_request *areq,
+				      struct talitos_edesc *edesc)
+{
+	struct talitos_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+	struct talitos_edesc *tmp;
 
-	if (desc->next_desc)
-		dma_unmap_single(dev, be32_to_cpu(desc->next_desc),
-				 TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
+	list_for_each_entry_safe_from(edesc, tmp, &req_ctx->desc_list, node) {
+		list_del(&edesc->node);
+		common_nonsnoop_hash_unmap(ctx->dev, edesc, areq);
+		kfree(edesc);
+	}
 }
 
-static void ahash_done(struct device *dev,
-		       struct talitos_desc *desc, void *context,
-		       int err)
+static void sec1_ahash_done(struct device *dev, struct talitos_desc *desc,
+			    void *context, int err)
 {
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(context);
 	struct ahash_request *areq = context;
-	struct talitos_edesc *edesc =
-		 container_of(desc, struct talitos_edesc, desc);
-	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 
-	if (!req_ctx->last_desc && req_ctx->to_hash_later) {
+	req_ctx->first_desc = 0;
+
+	ahash_free_desc_list_from(areq,
+				  list_first_entry(&req_ctx->desc_list,
+						   struct talitos_edesc, node));
+
+	if (!req_ctx->last_request && req_ctx->to_hash_later) {
 		/* Position any partial block for next update/final/finup */
 		req_ctx->buf_idx = (req_ctx->buf_idx + 1) & 1;
 		req_ctx->nbuf = req_ctx->to_hash_later;
 	}
-	common_nonsnoop_hash_unmap(dev, edesc, areq);
 
+	ahash_request_complete(areq, err);
+}
+
+static void sec2_ahash_done(struct device *dev, struct talitos_desc *desc,
+			    void *context, int err)
+{
+	struct ahash_request *areq = context;
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct talitos_edesc *edesc, *next;
+	bool is_last;
+
+	req_ctx->first_desc = 0;
+
+	edesc = container_of(desc, struct talitos_edesc, desc);
+	is_last = edesc->last;
+	if (!is_last)
+		next = list_next_entry(edesc, node);
+
+	list_del(&edesc->node);
+	common_nonsnoop_hash_unmap(ctx->dev, edesc, areq);
 	kfree(edesc);
 
-	if (err) {
-		ahash_request_complete(areq, err);
-		return;
-	}
+	if (err)
+		goto err_out;
 
-	req_ctx->remaining_ahash_request_bytes -=
-		req_ctx->current_ahash_request_bytes;
+	if (!is_last) {
+		err = talitos_submit(dev, ctx->ch, &next->desc, sec2_ahash_done,
+				     areq);
+		if (err != -EINPROGRESS)
+			goto err_out;
 
-	if (!req_ctx->remaining_ahash_request_bytes) {
-		ahash_request_complete(areq, 0);
 		return;
 	}
 
-	schedule_work(&req_ctx->sec1_ahash_process_remaining);
+	if (!req_ctx->last_request && req_ctx->to_hash_later) {
+		/* Position any partial block for next update/final/finup */
+		req_ctx->buf_idx = (req_ctx->buf_idx + 1) & 1;
+		req_ctx->nbuf = req_ctx->to_hash_later;
+	}
+
+	ahash_request_complete(areq, 0);
+
+	return;
+err_out:
+	if (!is_last)
+		ahash_free_desc_list_from(areq, next);
+	ahash_request_complete(areq, err);
 }
 
 /*
@@ -1805,18 +1914,14 @@ static void talitos_handle_buggy_hash(struct talitos_ctx *ctx,
 			       (char *)padded_hash, DMA_TO_DEVICE);
 }
 
-static int common_nonsnoop_hash(struct talitos_edesc *edesc,
-				struct ahash_request *areq, unsigned int length,
-				void (*callback) (struct device *dev,
-						  struct talitos_desc *desc,
-						  void *context, int error))
+static void common_nonsnoop_hash(struct talitos_edesc *edesc,
+				struct ahash_request *areq, unsigned int length)
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
@@ -1825,48 +1930,35 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	/* first DWORD empty */
 
 	/* hash context in */
-	if (!req_ctx->first_desc || req_ctx->swinit) {
+	if (!edesc->first || !req_ctx->first_desc || req_ctx->swinit) {
 		map_single_talitos_ptr_nosync(dev, &desc->ptr[1],
 					      req_ctx->hw_context_size,
 					      req_ctx->hw_context,
 					      DMA_TO_DEVICE);
 		req_ctx->swinit = 0;
 	}
-	/* Indicate next op is not the first. */
-	req_ctx->first_desc = 0;
 
 	/* HMAC key */
 	if (ctx->keylen)
 		to_talitos_ptr(&desc->ptr[2], ctx->dma_key, ctx->keylen,
 			       is_sec1);
 
-	if (is_sec1 && req_ctx->nbuf)
-		length -= req_ctx->nbuf;
-
 	sg_count = edesc->src_nents ?: 1;
 	if (is_sec1 && sg_count > 1)
-		sg_copy_to_buffer(req_ctx->psrc, sg_count, edesc->buf, length);
+		sg_copy_to_buffer(edesc->src, sg_count, edesc->buf, length);
 	else if (length)
-		sg_count = dma_map_sg(dev, req_ctx->psrc, sg_count,
+		sg_count = dma_map_sg(dev, edesc->src, sg_count,
 				      DMA_TO_DEVICE);
-	/*
-	 * data in
-	 */
-	if (is_sec1 && req_ctx->nbuf) {
-		map_single_talitos_ptr(dev, &desc->ptr[3], req_ctx->nbuf,
-				       req_ctx->buf[req_ctx->buf_idx],
-				       DMA_TO_DEVICE);
-	} else {
-		sg_count = talitos_sg_map(dev, req_ctx->psrc, length, edesc,
-					  &desc->ptr[3], sg_count, 0, 0);
-		if (sg_count > 1)
-			sync_needed = true;
-	}
+
+	sg_count = talitos_sg_map(dev, edesc->src, length, edesc,
+					&desc->ptr[3], sg_count, 0, 0);
+	if (sg_count > 1)
+		sync_needed = true;
 
 	/* fifth DWORD empty */
 
 	/* hash/HMAC out -or- hash context out */
-	if (req_ctx->last_desc)
+	if (edesc->last && req_ctx->last_request)
 		map_single_talitos_ptr(dev, &desc->ptr[5],
 				       crypto_ahash_digestsize(tfm),
 				       req_ctx->hw_context, DMA_FROM_DEVICE);
@@ -1881,70 +1973,93 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	if (is_sec1 && from_talitos_ptr_len(&desc->ptr[3], true) == 0)
 		talitos_handle_buggy_hash(ctx, edesc, &desc->ptr[3]);
 
-	if (is_sec1 && req_ctx->nbuf && length) {
-		struct talitos_desc *desc2 = (struct talitos_desc *)
-					     (edesc->buf + edesc->dma_len);
-		dma_addr_t next_desc;
-
-		memset(desc2, 0, sizeof(*desc2));
-		desc2->hdr = desc->hdr;
-		desc2->hdr &= ~DESC_HDR_MODE0_MDEU_INIT;
-		desc2->hdr1 = desc2->hdr;
-		desc->hdr &= ~DESC_HDR_MODE0_MDEU_PAD;
-		desc->hdr |= DESC_HDR_MODE0_MDEU_CONT;
-		desc->hdr &= ~DESC_HDR_DONE_NOTIFY;
-
-		if (desc->ptr[1].ptr)
-			copy_talitos_ptr(&desc2->ptr[1], &desc->ptr[1],
-					 is_sec1);
-		else
-			map_single_talitos_ptr_nosync(dev, &desc2->ptr[1],
-						      req_ctx->hw_context_size,
-						      req_ctx->hw_context,
-						      DMA_TO_DEVICE);
-		copy_talitos_ptr(&desc2->ptr[2], &desc->ptr[2], is_sec1);
-		sg_count = talitos_sg_map(dev, req_ctx->psrc, length, edesc,
-					  &desc2->ptr[3], sg_count, 0, 0);
-		if (sg_count > 1)
-			sync_needed = true;
-		copy_talitos_ptr(&desc2->ptr[5], &desc->ptr[5], is_sec1);
-		if (req_ctx->last_desc)
-			map_single_talitos_ptr_nosync(dev, &desc->ptr[5],
-						      req_ctx->hw_context_size,
-						      req_ctx->hw_context,
-						      DMA_FROM_DEVICE);
-
-		next_desc = dma_map_single(dev, &desc2->hdr1, TALITOS_DESC_SIZE,
-					   DMA_BIDIRECTIONAL);
-		desc->next_desc = cpu_to_be32(next_desc);
-	}
-
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
+
+	return talitos_edesc_alloc(ctx->dev, src, NULL, NULL, 0,
+				   nbytes, 0, 0, 0, areq->base.flags, false);
+}
+
+static int ahash_process_req_prepare(struct ahash_request *areq,
+				     unsigned int nbytes,
+				     unsigned int blocksize, bool is_sec1)
+{
+	struct talitos_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
-	struct talitos_private *priv = dev_get_drvdata(ctx->dev);
-	bool is_sec1 = has_ftr_sec1(priv);
+	size_t desc_max = is_sec1 ? TALITOS1_MAX_DATA_LEN :
+				    TALITOS2_MAX_DATA_LEN;
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
 
-	if (is_sec1)
-		nbytes -= req_ctx->nbuf;
+			return PTR_ERR(edesc);
+		}
 
-	return talitos_edesc_alloc(ctx->dev, req_ctx->psrc, NULL, NULL, 0,
-				   nbytes, 0, 0, 0, areq->base.flags, false);
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
 }
 
 static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes)
@@ -1963,15 +2078,16 @@ static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
 	u8 *ctx_buf = req_ctx->buf[req_ctx->buf_idx];
+	int ret;
 
-	if (!req_ctx->last_desc && (nbytes + req_ctx->nbuf <= blocksize)) {
+	if (!req_ctx->last_request && (nbytes + req_ctx->nbuf <= blocksize)) {
 		/* Buffer up to one whole block */
-		nents = sg_nents_for_len(req_ctx->request_sl, nbytes);
+		nents = sg_nents_for_len(areq->src, nbytes);
 		if (nents < 0) {
 			dev_err(dev, "Invalid number of src SG.\n");
 			return nents;
 		}
-		sg_copy_to_buffer(req_ctx->request_sl, nents,
+		sg_copy_to_buffer(areq->src, nents,
 				  ctx_buf + req_ctx->nbuf, nbytes);
 		req_ctx->nbuf += nbytes;
 		return 0;
@@ -1981,7 +2097,7 @@ static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes
 	nbytes_to_hash = nbytes + req_ctx->nbuf;
 	to_hash_later = nbytes_to_hash & (blocksize - 1);
 
-	if (req_ctx->last_desc)
+	if (req_ctx->last_request)
 		to_hash_later = 0;
 	else if (to_hash_later)
 		/* There is a partial block. Hash the full block(s) now */
@@ -1993,123 +2109,48 @@ static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes
 	}
 
 	/* Chain in any previously buffered data */
-	if (!is_sec1 && req_ctx->nbuf) {
+	if (req_ctx->nbuf) {
 		nsg = (req_ctx->nbuf < nbytes_to_hash) ? 2 : 1;
 		sg_init_table(req_ctx->bufsl, nsg);
 		sg_set_buf(req_ctx->bufsl, ctx_buf, req_ctx->nbuf);
 		if (nsg > 1)
-			sg_chain(req_ctx->bufsl, 2, req_ctx->request_sl);
+			sg_chain(req_ctx->bufsl, 2, areq->src);
 		req_ctx->psrc = req_ctx->bufsl;
-	} else if (is_sec1 && req_ctx->nbuf && req_ctx->nbuf < blocksize) {
-		int offset;
-
-		if (nbytes_to_hash > blocksize)
-			offset = blocksize - req_ctx->nbuf;
-		else
-			offset = nbytes_to_hash - req_ctx->nbuf;
-		nents = sg_nents_for_len(req_ctx->request_sl, offset);
-		if (nents < 0) {
-			dev_err(dev, "Invalid number of src SG.\n");
-			return nents;
-		}
-		sg_copy_to_buffer(req_ctx->request_sl, nents,
-				  ctx_buf + req_ctx->nbuf, offset);
-		req_ctx->nbuf += offset;
-		req_ctx->psrc = scatterwalk_ffwd(req_ctx->bufsl, req_ctx->request_sl,
-						 offset);
 	} else
-		req_ctx->psrc = req_ctx->request_sl;
+		req_ctx->psrc = areq->src;
 
 	if (to_hash_later) {
-		nents = sg_nents_for_len(req_ctx->request_sl, nbytes);
+		nents = sg_nents_for_len(areq->src, nbytes);
 		if (nents < 0) {
 			dev_err(dev, "Invalid number of src SG.\n");
 			return nents;
 		}
-		sg_pcopy_to_buffer(req_ctx->request_sl, nents,
+		sg_pcopy_to_buffer(areq->src, nents,
 				   req_ctx->buf[(req_ctx->buf_idx + 1) & 1],
 				      to_hash_later,
 				      nbytes - to_hash_later);
 	}
 	req_ctx->to_hash_later = to_hash_later;
 
-	/* Allocate extended descriptor */
-	edesc = ahash_edesc_alloc(req_ctx->areq, nbytes_to_hash);
-	if (IS_ERR(edesc))
-		return PTR_ERR(edesc);
-
-	edesc->desc.hdr = ctx->desc_hdr_template;
+	ret = ahash_process_req_prepare(areq, nbytes_to_hash, blocksize,
+					is_sec1);
+	if (ret)
+		return ret;
 
-	/* On last one, request SEC to pad; otherwise continue */
-	if (req_ctx->last_desc)
-		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_PAD;
-	else
-		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_CONT;
-
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
+	ret = talitos_submit(dev, ctx->ch, &edesc->desc,
+			     is_sec1 ? sec1_ahash_done : sec2_ahash_done, areq);
+	if (ret != -EINPROGRESS)
+		ahash_free_desc_list_from(areq, edesc);
 
-	return common_nonsnoop_hash(edesc, req_ctx->areq, nbytes_to_hash, ahash_done);
-}
-
-static void sec1_ahash_process_remaining(struct work_struct *work)
-{
-	struct talitos_ahash_req_ctx *req_ctx =
-		container_of(work, struct talitos_ahash_req_ctx,
-			     sec1_ahash_process_remaining);
-	int err = 0;
-
-	req_ctx->request_sl = scatterwalk_ffwd(req_ctx->request_bufsl,
-					       req_ctx->request_sl, TALITOS1_MAX_DATA_LEN);
-
-	if (req_ctx->remaining_ahash_request_bytes > TALITOS1_MAX_DATA_LEN)
-		req_ctx->current_ahash_request_bytes = TALITOS1_MAX_DATA_LEN;
-	else {
-		req_ctx->current_ahash_request_bytes =
-			req_ctx->remaining_ahash_request_bytes;
-
-		if (req_ctx->last_request)
-			req_ctx->last_desc = 1;
-	}
-
-	err = ahash_process_req_one(req_ctx->areq,
-				    req_ctx->current_ahash_request_bytes);
-
-	if (err != -EINPROGRESS)
-		ahash_request_complete(req_ctx->areq, err);
+	return ret;
 }
 
 static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 {
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
-	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct device *dev = ctx->dev;
-	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
-
-	req_ctx->areq = areq;
-	req_ctx->request_sl = areq->src;
-	req_ctx->remaining_ahash_request_bytes = nbytes;
-
-	if (is_sec1) {
-		if (nbytes > TALITOS1_MAX_DATA_LEN)
-			nbytes = TALITOS1_MAX_DATA_LEN;
-		else if (req_ctx->last_request)
-			req_ctx->last_desc = 1;
-	}
-
-	req_ctx->current_ahash_request_bytes = nbytes;
-
-	return ahash_process_req_one(req_ctx->areq,
-				     req_ctx->current_ahash_request_bytes);
+	return ahash_process_req_one(areq, nbytes);
 }
 
 static int ahash_init(struct ahash_request *areq)
@@ -2132,7 +2173,6 @@ static int ahash_init(struct ahash_request *areq)
 	req_ctx->hw_context_size = size;
 	req_ctx->last_request = 0;
 	req_ctx->last_desc = 0;
-	INIT_WORK(&req_ctx->sec1_ahash_process_remaining, sec1_ahash_process_remaining);
 
 	dma = dma_map_single(dev, req_ctx->hw_context, req_ctx->hw_context_size,
 			     DMA_TO_DEVICE);
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 1a93ee355929..f6dbcf00e675 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -44,6 +44,12 @@ struct talitos_desc {
 
 /*
  * talitos_edesc - s/w-extended descriptor
+ * @bufsl: scatterlist buffer
+ * @src: pointer to input scatterlist
+ * @node: list node for descriptor chaining
+ * @first: first descriptor of a chain
+ * @last: last descriptor of a chain
+ *
  * @src_nents: number of segments in input scatterlist
  * @dst_nents: number of segments in output scatterlist
  * @iv_dma: dma address of iv for checking continuity and link table
@@ -58,6 +64,12 @@ struct talitos_desc {
  * of link_tbl data
  */
 struct talitos_edesc {
+	struct scatterlist bufsl[2];
+	struct scatterlist *src;
+	struct list_head node;
+	int first;
+	int last;
+
 	int src_nents;
 	int dst_nents;
 	dma_addr_t iv_dma;
@@ -72,12 +84,14 @@ struct talitos_edesc {
 
 /**
  * talitos_request - descriptor submission request
+ * @desc_chain: descriptor chain (SEC1)
  * @desc: descriptor pointer (kernel virtual)
  * @dma_desc: descriptor's physical bus address
  * @callback: whom to call when descriptor processing is done
  * @context: caller context (optional)
  */
 struct talitos_request {
+	struct list_head *desc_chain;
 	struct talitos_desc *desc;
 	dma_addr_t dma_desc;
 	void (*callback) (struct device *dev, struct talitos_desc *desc,

-- 
2.53.0

