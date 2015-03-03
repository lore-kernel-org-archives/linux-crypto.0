From: Martin Hicks <mort@bork.org>
Subject: [PATCH v2 4/5] crypto: talitos: Reorganize request submission data structures
Date: Tue,  3 Mar 2015 08:21:36 -0500
Message-ID: <1425388897-5434-5-git-send-email-mort@bork.org>
References: <1425388897-5434-1-git-send-email-mort@bork.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@freescale.com>,
	Martin Hicks <mort@bork.org>
To: Kim Phillips <kim.phillips@freescale.com>,
	Scott Wood <scottwood@freescale.com>,
	Kumar Gala <galak@kernel.crashing.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:38811 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061AbbCCNVy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Mar 2015 08:21:54 -0500
Received: by iecrd18 with SMTP id rd18so57741582iec.5
        for <linux-crypto@vger.kernel.org>; Tue, 03 Mar 2015 05:21:53 -0800 (PST)
In-Reply-To: <1425388897-5434-1-git-send-email-mort@bork.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is preparatory work for moving to using the crypto async queue
handling code.  A talitos_request structure is buried into each
talitos_edesc so that when talitos_submit() is called, everything required
to defer the submission to the hardware is contained within talitos_edesc.

Signed-off-by: Martin Hicks <mort@bork.org>
---
 drivers/crypto/talitos.c |   95 +++++++++++++++-------------------------------
 drivers/crypto/talitos.h |   41 +++++++++++++++++---
 2 files changed, 66 insertions(+), 70 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 7709805..b0c85ce 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -186,22 +186,16 @@ static int init_device(struct device *dev)
  * talitos_submit - submits a descriptor to the device for processing
  * @dev:	the SEC device to be used
  * @ch:		the SEC device channel to be used
- * @desc:	the descriptor to be processed by the device
- * @callback:	whom to call when processing is complete
- * @context:	a handle for use by caller (optional)
+ * @edesc:	the descriptor to be processed by the device
  *
  * desc must contain valid dma-mapped (bus physical) address pointers.
  * callback must check err and feedback in descriptor header
  * for device processing status.
  */
-int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
-		   void (*callback)(struct device *dev,
-				    struct talitos_desc *desc,
-				    void *context, int error),
-		   void *context)
+int talitos_submit(struct device *dev, int ch, struct talitos_edesc *edesc)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
-	struct talitos_request *request;
+	struct talitos_request *request = &edesc->req;
 	unsigned long flags;
 	int head;
 
@@ -214,19 +208,15 @@ int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
 	}
 
 	head = priv->chan[ch].head;
-	request = &priv->chan[ch].fifo[head];
-
-	/* map descriptor and save caller data */
-	request->dma_desc = dma_map_single(dev, desc, sizeof(*desc),
+	request->dma_desc = dma_map_single(dev, request->desc,
+					   sizeof(*request->desc),
 					   DMA_BIDIRECTIONAL);
-	request->callback = callback;
-	request->context = context;
 
 	/* increment fifo head */
 	priv->chan[ch].head = (priv->chan[ch].head + 1) & (priv->fifo_len - 1);
 
 	smp_wmb();
-	request->desc = desc;
+	priv->chan[ch].fifo[head] = request;
 
 	/* GO! */
 	wmb();
@@ -247,15 +237,16 @@ EXPORT_SYMBOL(talitos_submit);
 static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
-	struct talitos_request *request, saved_req;
+	struct talitos_request *request;
 	unsigned long flags;
 	int tail, status;
 
 	spin_lock_irqsave(&priv->chan[ch].tail_lock, flags);
 
 	tail = priv->chan[ch].tail;
-	while (priv->chan[ch].fifo[tail].desc) {
-		request = &priv->chan[ch].fifo[tail];
+	while (priv->chan[ch].fifo[tail]) {
+		request = priv->chan[ch].fifo[tail];
+		status = 0;
 
 		/* descriptors with their done bits set don't get the error */
 		rmb();
@@ -271,14 +262,9 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 				 sizeof(struct talitos_desc),
 				 DMA_BIDIRECTIONAL);
 
-		/* copy entries so we can call callback outside lock */
-		saved_req.desc = request->desc;
-		saved_req.callback = request->callback;
-		saved_req.context = request->context;
-
 		/* release request entry in fifo */
 		smp_wmb();
-		request->desc = NULL;
+		priv->chan[ch].fifo[tail] = NULL;
 
 		/* increment fifo tail */
 		priv->chan[ch].tail = (tail + 1) & (priv->fifo_len - 1);
@@ -287,8 +273,8 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 
 		atomic_dec(&priv->chan[ch].submit_count);
 
-		saved_req.callback(dev, saved_req.desc, saved_req.context,
-				   status);
+		request->callback(dev, request->desc, request->context, status);
+
 		/* channel may resume processing in single desc error case */
 		if (error && !reset_ch && status == error)
 			return;
@@ -352,7 +338,8 @@ static u32 current_desc_hdr(struct device *dev, int ch)
 	tail = priv->chan[ch].tail;
 
 	iter = tail;
-	while (priv->chan[ch].fifo[iter].dma_desc != cur_desc) {
+	while (priv->chan[ch].fifo[iter] &&
+	       priv->chan[ch].fifo[iter]->dma_desc != cur_desc) {
 		iter = (iter + 1) & (priv->fifo_len - 1);
 		if (iter == tail) {
 			dev_err(dev, "couldn't locate current descriptor\n");
@@ -360,7 +347,8 @@ static u32 current_desc_hdr(struct device *dev, int ch)
 		}
 	}
 
-	return priv->chan[ch].fifo[iter].desc->hdr;
+	return priv->chan[ch].fifo[iter] ?
+		priv->chan[ch].fifo[iter]->desc->hdr : 0;
 }
 
 /*
@@ -702,37 +690,6 @@ badkey:
 	return -EINVAL;
 }
 
-/*
- * talitos_edesc - s/w-extended descriptor
- * @assoc_nents: number of segments in associated data scatterlist
- * @src_nents: number of segments in input scatterlist
- * @dst_nents: number of segments in output scatterlist
- * @assoc_chained: whether assoc is chained or not
- * @src_chained: whether src is chained or not
- * @dst_chained: whether dst is chained or not
- * @iv_dma: dma address of iv for checking continuity and link table
- * @dma_len: length of dma mapped link_tbl space
- * @dma_link_tbl: bus physical address of link_tbl
- * @desc: h/w descriptor
- * @link_tbl: input and output h/w link tables (if {src,dst}_nents > 1)
- *
- * if decrypting (with authcheck), or either one of src_nents or dst_nents
- * is greater than 1, an integrity check value is concatenated to the end
- * of link_tbl data
- */
-struct talitos_edesc {
-	int assoc_nents;
-	int src_nents;
-	int dst_nents;
-	bool assoc_chained;
-	bool src_chained;
-	bool dst_chained;
-	dma_addr_t iv_dma;
-	int dma_len;
-	dma_addr_t dma_link_tbl;
-	struct talitos_desc desc;
-	struct talitos_ptr link_tbl[0];
-};
 
 static int talitos_map_sg(struct device *dev, struct scatterlist *sg,
 			  unsigned int nents, enum dma_data_direction dir,
@@ -1078,7 +1035,10 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	map_single_talitos_ptr(dev, &desc->ptr[6], ivsize, ctx->iv, 0,
 			       DMA_FROM_DEVICE);
 
-	ret = talitos_submit(dev, ctx->ch, desc, callback, areq);
+	edesc->req.callback = callback;
+	edesc->req.context = areq;
+
+	ret = talitos_submit(dev, ctx->ch, edesc);
 	if (ret != -EINPROGRESS) {
 		ipsec_esp_unmap(dev, edesc, areq);
 		kfree(edesc);
@@ -1209,6 +1169,7 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 		edesc->dma_link_tbl = dma_map_single(dev, &edesc->link_tbl[0],
 						     edesc->dma_len,
 						     DMA_BIDIRECTIONAL);
+	edesc->req.desc = &edesc->desc;
 
 	return edesc;
 }
@@ -1449,7 +1410,10 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 	to_talitos_ptr(&desc->ptr[6], 0);
 	desc->ptr[6].j_extent = 0;
 
-	ret = talitos_submit(dev, ctx->ch, desc, callback, areq);
+	edesc->req.callback = callback;
+	edesc->req.context = areq;
+
+	ret = talitos_submit(dev, ctx->ch, edesc);
 	if (ret != -EINPROGRESS) {
 		common_nonsnoop_unmap(dev, edesc, areq);
 		kfree(edesc);
@@ -1629,7 +1593,10 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	/* last DWORD empty */
 	desc->ptr[6] = zero_entry;
 
-	ret = talitos_submit(dev, ctx->ch, desc, callback, areq);
+	edesc->req.callback = callback;
+	edesc->req.context = areq;
+
+	ret = talitos_submit(dev, ctx->ch, edesc);
 	if (ret != -EINPROGRESS) {
 		common_nonsnoop_hash_unmap(dev, edesc, areq);
 		kfree(edesc);
@@ -2714,7 +2681,7 @@ static int talitos_probe(struct platform_device *ofdev)
 		spin_lock_init(&priv->chan[i].head_lock);
 		spin_lock_init(&priv->chan[i].tail_lock);
 
-		priv->chan[i].fifo = kzalloc(sizeof(struct talitos_request) *
+		priv->chan[i].fifo = kzalloc(sizeof(struct talitos_request *) *
 					     priv->fifo_len, GFP_KERNEL);
 		if (!priv->chan[i].fifo) {
 			dev_err(dev, "failed to allocate request fifo %d\n", i);
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 61a1405..914eb15 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -77,7 +77,7 @@ struct talitos_channel {
 	void __iomem *reg;
 
 	/* request fifo */
-	struct talitos_request *fifo;
+	struct talitos_request **fifo;
 
 	/* number of requests pending in channel h/w fifo */
 	atomic_t submit_count ____cacheline_aligned;
@@ -133,11 +133,40 @@ struct talitos_private {
 	struct hwrng rng;
 };
 
-extern int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
-			  void (*callback)(struct device *dev,
-					   struct talitos_desc *desc,
-					   void *context, int error),
-			  void *context);
+/*
+ * talitos_edesc - s/w-extended descriptor
+ * @assoc_nents: number of segments in associated data scatterlist
+ * @src_nents: number of segments in input scatterlist
+ * @dst_nents: number of segments in output scatterlist
+ * @assoc_chained: whether assoc is chained or not
+ * @src_chained: whether src is chained or not
+ * @dst_chained: whether dst is chained or not
+ * @iv_dma: dma address of iv for checking continuity and link table
+ * @dma_len: length of dma mapped link_tbl space
+ * @dma_link_tbl: bus physical address of link_tbl
+ * @desc: h/w descriptor
+ * @link_tbl: input and output h/w link tables (if {src,dst}_nents > 1)
+ *
+ * if decrypting (with authcheck), or either one of src_nents or dst_nents
+ * is greater than 1, an integrity check value is concatenated to the end
+ * of link_tbl data
+ */
+struct talitos_edesc {
+	struct talitos_request req;
+	int assoc_nents;
+	int src_nents;
+	int dst_nents;
+	bool assoc_chained;
+	bool src_chained;
+	bool dst_chained;
+	dma_addr_t iv_dma;
+	int dma_len;
+	dma_addr_t dma_link_tbl;
+	struct talitos_desc desc;
+	struct talitos_ptr link_tbl[0];
+};
+
+int talitos_submit(struct device *dev, int ch, struct talitos_edesc *edesc);
 
 /* .features flag */
 #define TALITOS_FTR_SRC_LINK_TBL_LEN_INCLUDES_EXTENT 0x00000001
-- 
1.7.10.4
