Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA1E3E9287;
	Tue,  5 May 2026 17:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778003636; cv=none; b=BQsWY4igWSDPMTRVAOqL70HomzZpnjmhhsxZRcJ8xLWgKYPuClDeFMEIdIiOixQtk4sfpOO1GcGy3F/Jip1YAxpZQO+qlslFmVcwZZoFamxQnQ1CT0mEJDUUqp8wWJINZH0iiCdAvyi5fLpRdvrB4BOXNzlepTGgP//NOgDfKao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778003636; c=relaxed/simple;
	bh=pRAey5L1DSsy7bJsvUd8hCd84aPrBdRE8Fi+j+xSE/M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OAIQjiaIV8pcmLY/L4pNyWvkQ/vPAmeaR08KIYZnNJfr47+Usf1kbI78P3YalhZKOP1O9H1wduLvHY5d5zLUM0c3L07nUDOsKzuFNqaJAwuWfqs+gi0uKfi3ZY/9GoOV4hC5+STZzhxise4IpmzdsR72EuGo8Lh87DpqLaAi8LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=epT4wAtS; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="epT4wAtS"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 6216B4E42BD4;
	Tue,  5 May 2026 17:53:52 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 38E316053C;
	Tue,  5 May 2026 17:53:52 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 2B90C11AD0410;
	Tue,  5 May 2026 19:53:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1778003631; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=AT112QPh74pGH4i61eZtJRpEFTK6WFWEQ+WdSL4kD9Y=;
	b=epT4wAtSgoRbsxgpcRmXWC4G/EvRVva6/y2DCS1aHxpm4NIn0PeDh/lxb1mc7E2dlLf2OC
	aow9GNr2r6vZQXIDml6v6zE3cBSVmWWiW4QMKindUZkCW1qUwJV7NzNrps91tRVdqEvK9F
	FPdtoQIUsGn6jBxOrYe7wW9tVc8y7AbFSAUgZhyAsqZnsBQbgjx1oCmco5GRjJhwkXGvc2
	sL6qVm451d9w53ZXMHQDmulHzxjREWVBDOq4TTC9ayRRUecYYHn8LnEx9xGnl/Bqx0ZRPU
	BwcBBdbxNG2dBB8Id1T5qgromPzXscINyTV62aeF8O66l0pdkib/3O8ElJCG4w==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Tue, 05 May 2026 19:53:03 +0200
Subject: [PATCH v2 02/12] crypto: talitos - add chaining of arbitrary
 number of descriptor for the SEC1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-bootlin_test-7-1-rc1_sec_bugfix-v2-2-5818064bd190@bootlin.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778003630; l=12372;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=pRAey5L1DSsy7bJsvUd8hCd84aPrBdRE8Fi+j+xSE/M=;
 b=73T8LHzjRO5NmOsyJkXCFJTD2kQESvyABSWzMdZMW3WalXHqxcU5a5HbxPRGGaGKgqPS6YiuC
 dyMfSQkosXDDPUekpiq2sg0pKJZd1HiF9m0hVzKrWAnUuuM7GQYiLzJ
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

The SEC1 hardware can process a chain of descriptors without host
intervention. Only the hash implementation currently use this feature,
but with a chain of at most 2 descriptors added in commit 37b5e8897eb5
("crypto: talitos - chain in buffered data for ahash on SEC1").

Add supports for chaining an arbitrary number of descriptors in a chain.

Adapt the ahash implementation to make it compatible.

Cc: stable@vger.kernel.org
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos.c | 171 ++++++++++++++++++++++++++++++++++-------------
 drivers/crypto/talitos.h |   4 ++
 2 files changed, 127 insertions(+), 48 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 303640e64717..d68d307c54f7 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -14,6 +14,7 @@
 
 #include <linux/workqueue.h>
 #include <linux/kernel.h>
+#include <linux/list.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
 #include <linux/device.h>
@@ -273,7 +274,10 @@ static int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
 					   void *context, int error),
 			  void *context)
 {
+	struct talitos_edesc *edesc = container_of(desc, struct talitos_edesc, desc);
 	struct talitos_private *priv = dev_get_drvdata(dev);
+	dma_addr_t dma_desc, prev_dma_desc;
+	struct talitos_edesc *prev_edesc = NULL;
 	struct talitos_request *request;
 	unsigned long flags;
 	int head;
@@ -292,14 +296,37 @@ static int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
 
 	/* map descriptor and save caller data */
 	if (is_sec1) {
-		desc->hdr1 = desc->hdr;
-		request->dma_desc = dma_map_single(dev, &desc->hdr1,
+		request->desc_chain = edesc->node.prev;
+
+		list_for_each_entry(edesc, request->desc_chain, node) {
+			edesc->desc.hdr1 = edesc->desc.hdr;
+
+			dma_desc = dma_map_single(dev, &edesc->desc.hdr1,
+						  TALITOS_DESC_SIZE,
+						  DMA_BIDIRECTIONAL);
+
+			if (!prev_edesc) {
+				request->dma_desc = dma_desc;
+				goto next;
+			}
+
+			/* Chain in any previous descriptors. */
+
+			prev_edesc->desc.next_desc = cpu_to_be32(dma_desc);
+
+			dma_sync_single_for_device(dev, prev_dma_desc,
 						   TALITOS_DESC_SIZE,
-						   DMA_BIDIRECTIONAL);
+						   DMA_TO_DEVICE);
+
+next:
+			prev_edesc = edesc;
+			prev_dma_desc = dma_desc;
+		}
 	} else {
 		request->dma_desc = dma_map_single(dev, desc,
 						   TALITOS_DESC_SIZE,
 						   DMA_BIDIRECTIONAL);
+		request->desc_chain = NULL;
 	}
 	request->callback = callback;
 	request->context = context;
@@ -324,7 +351,8 @@ static int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
 
 static __be32 get_request_hdr(struct device *dev, struct talitos_request *request, bool is_sec1)
 {
-	struct talitos_edesc *edesc;
+	struct talitos_edesc *prev_last, *last;
+	struct talitos_desc *desc;
 	dma_addr_t dma_desc;
 
 	if (!is_sec1) {
@@ -334,17 +362,22 @@ static __be32 get_request_hdr(struct device *dev, struct talitos_request *reques
 		return request->desc->hdr;
 	}
 
-	if (!request->desc->next_desc)
+	if (list_is_singular(request->desc_chain)) {
+		desc = request->desc;
 		dma_desc = request->dma_desc;
-	else
-		dma_desc = be32_to_cpu(request->desc->next_desc);
+	} else {
+		last = list_last_entry(request->desc_chain,
+				       struct talitos_edesc, node);
+		prev_last = list_prev_entry(last, node);
+
+		desc = &last->desc;
+		dma_desc = be32_to_cpu(prev_last->desc.next_desc);
+	}
 
 	dma_sync_single_for_cpu(dev, dma_desc, TALITOS_DESC_SIZE,
 				DMA_BIDIRECTIONAL);
 
-	edesc = container_of(request->desc, struct talitos_edesc, desc);
-
-	return ((struct talitos_desc *)(edesc->buf + edesc->dma_len))->hdr1;
+	return desc->hdr1;
 }
 
 /*
@@ -354,6 +387,7 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	struct talitos_request *request, saved_req;
+	struct talitos_edesc *edesc;
 	unsigned long flags;
 	int tail, status;
 	bool is_sec1 = has_ftr_sec1(priv);
@@ -378,9 +412,23 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 			else
 				status = error;
 
-		dma_unmap_single(dev, request->dma_desc,
-				 TALITOS_DESC_SIZE,
-				 DMA_BIDIRECTIONAL);
+		if (is_sec1) {
+			dma_unmap_single(dev, request->dma_desc,
+					 TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
+
+			list_for_each_entry(edesc, request->desc_chain, node) {
+				if (!edesc->desc.next_desc)
+					break;
+
+				dma_unmap_single(
+					dev, be32_to_cpu(edesc->desc.next_desc),
+					TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
+			}
+		} else {
+			dma_unmap_single(dev, request->dma_desc,
+					TALITOS_DESC_SIZE,
+					DMA_BIDIRECTIONAL);
+		}
 
 		/* copy entries so we can call callback outside lock */
 		saved_req.desc = request->desc;
@@ -475,8 +523,12 @@ DEF_TALITOS2_DONE(ch1_3, TALITOS2_ISR_CH_1_3_DONE)
 static __be32 current_desc_hdr(struct device *dev, int ch)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
+	bool is_sec1 = has_ftr_sec1(priv);
+	struct talitos_request *request;
+	struct talitos_edesc *edesc;
 	int tail, iter;
 	dma_addr_t cur_desc;
+	__be32 hdr = 0;
 
 	cur_desc = ((u64)in_be32(priv->chan[ch].reg + TALITOS_CDPR)) << 32;
 	cur_desc |= in_be32(priv->chan[ch].reg + TALITOS_CDPR_LO);
@@ -487,27 +539,31 @@ static __be32 current_desc_hdr(struct device *dev, int ch)
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
+	do {
+		request = &priv->chan[ch].fifo[iter];
+
+		if (request->dma_desc == cur_desc) {
+			hdr = request->desc->hdr;
+		} else if (is_sec1) {
+			list_for_each_entry(edesc, request->desc_chain, node) {
+				if (edesc->desc.next_desc ==
+				    cpu_to_be32(cur_desc))
+					hdr = list_next_entry(edesc, node)
+						      ->desc.hdr;
+			}
 		}
-	}
 
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
+
+	if (!hdr)
+		dev_err(dev, "couldn't locate current descriptor\n");
 
-	return priv->chan[ch].fifo[iter].desc->hdr;
+	return hdr;
 }
 
 /*
@@ -886,6 +942,7 @@ struct talitos_ahash_req_ctx {
 	unsigned int nbuf;
 	struct scatterlist bufsl[2];
 	struct scatterlist *psrc;
+	struct list_head desc_list;
 
 	struct scatterlist request_bufsl[2];
 	struct ahash_request *areq;
@@ -1406,10 +1463,6 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 		dma_len = 0;
 	}
 	alloc_len += icv_stashing ? authsize : 0;
-
-	/* if its a ahash, add space for a second desc next to the first one */
-	if (is_sec1 && !dst)
-		alloc_len += sizeof(struct talitos_desc);
 	alloc_len += ivsize;
 
 	edesc = kmalloc(ALIGN(alloc_len, dma_get_cache_alignment()), flags);
@@ -1421,6 +1474,9 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 	}
 	memset(&edesc->desc, 0, sizeof(edesc->desc));
 
+	if (is_sec1)
+		INIT_LIST_HEAD(&edesc->node);
+
 	edesc->src_nents = src_nents;
 	edesc->dst_nents = dst_nents;
 	edesc->iv_dma = iv_dma;
@@ -1725,8 +1781,10 @@ static void common_nonsnoop_hash_unmap(struct device *dev,
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
 	struct talitos_desc *desc = &edesc->desc;
-	struct talitos_desc *desc2 = (struct talitos_desc *)
-				     (edesc->buf + edesc->dma_len);
+	struct talitos_desc *desc2;
+
+	if (desc->next_desc)
+		desc2 = &list_next_entry(edesc, node)->desc;
 
 	unmap_single_talitos_ptr(dev, &desc->ptr[5], DMA_FROM_DEVICE);
 	if (desc->next_desc &&
@@ -1754,10 +1812,18 @@ static void common_nonsnoop_hash_unmap(struct device *dev,
 	if (edesc->dma_len)
 		dma_unmap_single(dev, edesc->dma_link_tbl, edesc->dma_len,
 				 DMA_BIDIRECTIONAL);
+}
 
-	if (desc->next_desc)
-		dma_unmap_single(dev, be32_to_cpu(desc->next_desc),
-				 TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
+static void ahash_free_desc_list_from(struct ahash_request *areq,
+				      struct talitos_edesc *edesc)
+{
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+	struct talitos_edesc *tmp;
+
+	list_for_each_entry_safe_from(edesc, tmp, &req_ctx->desc_list, node) {
+		list_del(&edesc->node);
+		kfree(edesc);
+	}
 }
 
 static void ahash_done(struct device *dev,
@@ -1776,7 +1842,9 @@ static void ahash_done(struct device *dev,
 	}
 	common_nonsnoop_hash_unmap(dev, edesc, areq);
 
-	kfree(edesc);
+	ahash_free_desc_list_from(areq,
+				  list_first_entry(&req_ctx->desc_list,
+						   struct talitos_edesc, node));
 
 	if (err) {
 		ahash_request_complete(areq, err);
@@ -1892,14 +1960,22 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 		talitos_handle_buggy_hash(ctx, edesc, &desc->ptr[3]);
 
 	if (is_sec1 && req_ctx->nbuf && length) {
-		struct talitos_desc *desc2 = (struct talitos_desc *)
-					     (edesc->buf + edesc->dma_len);
-		dma_addr_t next_desc;
+		struct talitos_edesc *edesc2;
+		struct talitos_desc *desc2;
+
+		edesc2 = kzalloc(sizeof(*edesc2),
+				 areq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
+					 GFP_KERNEL :
+					 GFP_ATOMIC);
+		if (!edesc2)
+			return -ENOMEM;
+
+		list_add_tail(&edesc2->node, &req_ctx->desc_list);
+
+		desc2 = &edesc2->desc;
 
-		memset(desc2, 0, sizeof(*desc2));
 		desc2->hdr = desc->hdr;
 		desc2->hdr &= ~DESC_HDR_MODE0_MDEU_INIT;
-		desc2->hdr1 = desc2->hdr;
 		desc->hdr &= ~DESC_HDR_MODE0_MDEU_PAD;
 		desc->hdr |= DESC_HDR_MODE0_MDEU_CONT;
 		desc->hdr &= ~DESC_HDR_DONE_NOTIFY;
@@ -1923,10 +1999,6 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 						      req_ctx->hw_context_size,
 						      req_ctx->hw_context,
 						      DMA_FROM_DEVICE);
-
-		next_desc = dma_map_single(dev, &desc2->hdr1, TALITOS_DESC_SIZE,
-					   DMA_BIDIRECTIONAL);
-		desc->next_desc = cpu_to_be32(next_desc);
 	}
 
 	if (sync_needed)
@@ -2048,6 +2120,9 @@ static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
+	INIT_LIST_HEAD(&req_ctx->desc_list);
+	list_add_tail(&edesc->node, &req_ctx->desc_list);
+
 	edesc->desc.hdr = ctx->desc_hdr_template;
 
 	/* On last one, request SEC to pad; otherwise continue */
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 1a93ee355929..ac75c2ddecb9 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -49,6 +49,7 @@ struct talitos_desc {
  * @iv_dma: dma address of iv for checking continuity and link table
  * @dma_len: length of dma mapped link_tbl space
  * @dma_link_tbl: bus physical address of link_tbl/buf
+ * @node: node for descriptor chain (SEC1)
  * @desc: h/w descriptor
  * @link_tbl: input and output h/w link tables (if {src,dst}_nents > 1) (SEC2)
  * @buf: input and output buffeur (if {src,dst}_nents > 1) (SEC1)
@@ -63,6 +64,7 @@ struct talitos_edesc {
 	dma_addr_t iv_dma;
 	int dma_len;
 	dma_addr_t dma_link_tbl;
+	struct list_head node;
 	struct talitos_desc desc;
 	union {
 		DECLARE_FLEX_ARRAY(struct talitos_ptr, link_tbl);
@@ -72,12 +74,14 @@ struct talitos_edesc {
 
 /**
  * talitos_request - descriptor submission request
+ * @desc_chain: descriptor chain list (SEC1)
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

