From: Victoria Milhoan <vicki.milhoan@freescale.com>
Subject: [PATCH RFC 01/11] crypto: caam - Add cache coherency support
Date: Mon, 15 Jun 2015 16:52:49 -0700
Message-ID: <1434412379-11623-2-git-send-email-vicki.milhoan@freescale.com>
References: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>, <horia.geanta@freescale.com>,
	<ruchika.gupta@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0131.outbound.protection.outlook.com ([65.55.169.131]:22255
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750911AbbFPAIh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 20:08:37 -0400
In-Reply-To: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Freescale i.MX6 ARM platforms do not support hardware cache coherency.  This
patch adds cache coherency support to the CAAM driver.

Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
---
 drivers/crypto/caam/caamhash.c   | 28 +++++++++++++++++----------
 drivers/crypto/caam/caamrng.c    | 10 +++++++++-
 drivers/crypto/caam/jr.c         | 42 +++++++++++++++++++++++++++++++++++++++-
 drivers/crypto/caam/key_gen.c    |  4 +++-
 drivers/crypto/caam/sg_sw_sec4.h |  1 +
 5 files changed, 72 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index ba0532e..1662c65 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -500,6 +500,7 @@ static int hash_digest_key(struct caam_hash_ctx *ctx, const u8 *key_in,
 #endif
 	}
 	dma_unmap_single(jrdev, src_dma, *keylen, DMA_TO_DEVICE);
+	dma_sync_single_for_cpu(jrdev, dst_dma, digestsize, DMA_FROM_DEVICE);
 	dma_unmap_single(jrdev, dst_dma, digestsize, DMA_FROM_DEVICE);
 
 	*keylen = digestsize;
@@ -608,8 +609,11 @@ static inline void ahash_unmap(struct device *dev,
 	if (edesc->src_nents)
 		dma_unmap_sg_chained(dev, req->src, edesc->src_nents,
 				     DMA_TO_DEVICE, edesc->chained);
-	if (edesc->dst_dma)
+	if (edesc->dst_dma) {
+		dma_sync_single_for_cpu(dev, edesc->dst_dma, dst_len,
+					DMA_FROM_DEVICE);
 		dma_unmap_single(dev, edesc->dst_dma, dst_len, DMA_FROM_DEVICE);
+	}
 
 	if (edesc->sec4_sg_bytes)
 		dma_unmap_single(dev, edesc->sec4_sg_dma,
@@ -624,8 +628,12 @@ static inline void ahash_unmap_ctx(struct device *dev,
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 
-	if (state->ctx_dma)
+	if (state->ctx_dma) {
+		if ((flag == DMA_FROM_DEVICE) || (flag == DMA_BIDIRECTIONAL))
+			dma_sync_single_for_cpu(dev, state->ctx_dma,
+						ctx->ctx_len, flag);
 		dma_unmap_single(dev, state->ctx_dma, ctx->ctx_len, flag);
+	}
 	ahash_unmap(dev, edesc, req, dst_len);
 }
 
@@ -807,7 +815,7 @@ static int ahash_update_ctx(struct ahash_request *req)
 		 * allocate space for base edesc and hw desc commands,
 		 * link tables
 		 */
-		edesc = kmalloc(sizeof(struct ahash_edesc) + DESC_JOB_IO_LEN +
+		edesc = kzalloc(sizeof(struct ahash_edesc) + DESC_JOB_IO_LEN +
 				sec4_sg_bytes, GFP_DMA | flags);
 		if (!edesc) {
 			dev_err(jrdev,
@@ -918,7 +926,7 @@ static int ahash_final_ctx(struct ahash_request *req)
 	sec4_sg_bytes = (1 + (buflen ? 1 : 0)) * sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kmalloc(sizeof(struct ahash_edesc) + DESC_JOB_IO_LEN +
+	edesc = kzalloc(sizeof(struct ahash_edesc) + DESC_JOB_IO_LEN +
 			sec4_sg_bytes, GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
@@ -1005,7 +1013,7 @@ static int ahash_finup_ctx(struct ahash_request *req)
 			 sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kmalloc(sizeof(struct ahash_edesc) + DESC_JOB_IO_LEN +
+	edesc = kzalloc(sizeof(struct ahash_edesc) + DESC_JOB_IO_LEN +
 			sec4_sg_bytes, GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
@@ -1091,7 +1099,7 @@ static int ahash_digest(struct ahash_request *req)
 	sec4_sg_bytes = src_nents * sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kmalloc(sizeof(struct ahash_edesc) + sec4_sg_bytes +
+	edesc = kzalloc(sizeof(struct ahash_edesc) + sec4_sg_bytes +
 			DESC_JOB_IO_LEN, GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
@@ -1165,7 +1173,7 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 	int sh_len;
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kmalloc(sizeof(struct ahash_edesc) + DESC_JOB_IO_LEN,
+	edesc = kzalloc(sizeof(struct ahash_edesc) + DESC_JOB_IO_LEN,
 			GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
@@ -1245,7 +1253,7 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 		 * allocate space for base edesc and hw desc commands,
 		 * link tables
 		 */
-		edesc = kmalloc(sizeof(struct ahash_edesc) + DESC_JOB_IO_LEN +
+		edesc = kzalloc(sizeof(struct ahash_edesc) + DESC_JOB_IO_LEN +
 				sec4_sg_bytes, GFP_DMA | flags);
 		if (!edesc) {
 			dev_err(jrdev,
@@ -1352,7 +1360,7 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 			 sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kmalloc(sizeof(struct ahash_edesc) + DESC_JOB_IO_LEN +
+	edesc = kzalloc(sizeof(struct ahash_edesc) + DESC_JOB_IO_LEN +
 			sec4_sg_bytes, GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
@@ -1447,7 +1455,7 @@ static int ahash_update_first(struct ahash_request *req)
 		 * allocate space for base edesc and hw desc commands,
 		 * link tables
 		 */
-		edesc = kmalloc(sizeof(struct ahash_edesc) + DESC_JOB_IO_LEN +
+		edesc = kzalloc(sizeof(struct ahash_edesc) + DESC_JOB_IO_LEN +
 				sec4_sg_bytes, GFP_DMA | flags);
 		if (!edesc) {
 			dev_err(jrdev,
diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index 26a544b..a8c4af9 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -80,9 +80,12 @@ static struct caam_rng_ctx *rng_ctx;
 
 static inline void rng_unmap_buf(struct device *jrdev, struct buf_data *bd)
 {
-	if (bd->addr)
+	if (bd->addr) {
+		dma_sync_single_for_cpu(jrdev, bd->addr, RN_BUF_SIZE,
+					DMA_FROM_DEVICE);
 		dma_unmap_single(jrdev, bd->addr, RN_BUF_SIZE,
 				 DMA_FROM_DEVICE);
+	}
 }
 
 static inline void rng_unmap_ctx(struct caam_rng_ctx *ctx)
@@ -108,6 +111,10 @@ static void rng_done(struct device *jrdev, u32 *desc, u32 err, void *context)
 
 	atomic_set(&bd->empty, BUF_NOT_EMPTY);
 	complete(&bd->filled);
+
+	/* Buffer refilled, invalidate cache */
+	dma_sync_single_for_cpu(jrdev, bd->addr, RN_BUF_SIZE, DMA_FROM_DEVICE);
+
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "rng refreshed buf@: ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, bd->buf, RN_BUF_SIZE, 1);
@@ -211,6 +218,7 @@ static inline int rng_create_sh_desc(struct caam_rng_ctx *ctx)
 	print_hex_dump(KERN_ERR, "rng shdesc@: ", DUMP_PREFIX_ADDRESS, 16, 4,
 		       desc, desc_bytes(desc), 1);
 #endif
+
 	return 0;
 }
 
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index b8b5d47..a693bf7 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -168,6 +168,9 @@ static void caam_jr_dequeue(unsigned long devarg)
 	void (*usercall)(struct device *dev, u32 *desc, u32 status, void *arg);
 	u32 *userdesc, userstatus;
 	void *userarg;
+	dma_addr_t outbusaddr;
+
+	outbusaddr = rd_reg64(&jrp->rregs->outring_base);
 
 	while (rd_reg32(&jrp->rregs->outring_used)) {
 
@@ -177,10 +180,19 @@ static void caam_jr_dequeue(unsigned long devarg)
 
 		sw_idx = tail = jrp->tail;
 		hw_idx = jrp->out_ring_read_index;
+		dma_sync_single_for_cpu(dev, outbusaddr,
+					sizeof(struct jr_outentry) * JOBR_DEPTH,
+					DMA_FROM_DEVICE);
 
 		for (i = 0; CIRC_CNT(head, tail + i, JOBR_DEPTH) >= 1; i++) {
 			sw_idx = (tail + i) & (JOBR_DEPTH - 1);
 
+			/*
+			 * Ensure that tail is read before using it as part of
+			 * the index into the software ring.
+			 */
+			smp_read_barrier_depends();
+
 			if (jrp->outring[hw_idx].desc ==
 			    jrp->entinfo[sw_idx].desc_addr_dma)
 				break; /* found */
@@ -202,6 +214,13 @@ static void caam_jr_dequeue(unsigned long devarg)
 		userdesc = jrp->entinfo[sw_idx].desc_addr_virt;
 		userstatus = jrp->outring[hw_idx].jrstatus;
 
+		/*
+		 * Make sure all information from the job has been obtained
+		 * before telling CAAM that the job has been removed from the
+		 * output ring.
+		 */
+		smp_mb();
+
 		/* set done */
 		wr_reg32(&jrp->rregs->outring_rmvd, 1);
 
@@ -216,6 +235,12 @@ static void caam_jr_dequeue(unsigned long devarg)
 		if (sw_idx == tail) {
 			do {
 				tail = (tail + 1) & (JOBR_DEPTH - 1);
+
+				/*
+				 * Ensure that tail is read before using it to
+				 * update the software ring's tail index
+				 */
+				smp_read_barrier_depends();
 			} while (CIRC_CNT(head, tail, JOBR_DEPTH) >= 1 &&
 				 jrp->entinfo[tail].desc_addr_dma == 0);
 
@@ -321,7 +346,7 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
 	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
 	struct caam_jrentry_info *head_entry;
 	int head, tail, desc_size;
-	dma_addr_t desc_dma;
+	dma_addr_t desc_dma, inpbusaddr;
 
 	desc_size = (*desc & HDR_JD_LENGTH_MASK) * sizeof(u32);
 	desc_dma = dma_map_single(dev, desc, desc_size, DMA_TO_DEVICE);
@@ -330,6 +355,11 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
 		return -EIO;
 	}
 
+	inpbusaddr = rd_reg64(&jrp->rregs->inpring_base);
+	dma_sync_single_for_device(dev, inpbusaddr,
+					sizeof(dma_addr_t) * JOBR_DEPTH,
+					DMA_TO_DEVICE);
+
 	spin_lock_bh(&jrp->inplock);
 
 	head = jrp->head;
@@ -351,12 +381,22 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
 
 	jrp->inpring[jrp->inp_ring_write_index] = desc_dma;
 
+	dma_sync_single_for_device(dev, inpbusaddr,
+					sizeof(dma_addr_t) * JOBR_DEPTH,
+					DMA_TO_DEVICE);
+
 	smp_wmb();
 
 	jrp->inp_ring_write_index = (jrp->inp_ring_write_index + 1) &
 				    (JOBR_DEPTH - 1);
 	jrp->head = (head + 1) & (JOBR_DEPTH - 1);
 
+	/*
+	 * Ensure that all job information has been written before
+	 * notifying CAAM that a new job was added to the input ring.
+	 */
+	wmb();
+
 	wr_reg32(&jrp->rregs->inpring_jobadd, 1);
 
 	spin_unlock_bh(&jrp->inplock);
diff --git a/drivers/crypto/caam/key_gen.c b/drivers/crypto/caam/key_gen.c
index e1eaf4f..6481f71 100644
--- a/drivers/crypto/caam/key_gen.c
+++ b/drivers/crypto/caam/key_gen.c
@@ -71,6 +71,7 @@ int gen_split_key(struct device *jrdev, u8 *key_out, int split_key_len,
 	}
 
 	init_job_desc(desc, 0);
+
 	append_key(desc, dma_addr_in, keylen, CLASS_2 | KEY_DEST_CLASS_REG);
 
 	/* Sets MDHA up into an HMAC-INIT */
@@ -111,7 +112,8 @@ int gen_split_key(struct device *jrdev, u8 *key_out, int split_key_len,
 			       split_key_pad_len, 1);
 #endif
 	}
-
+	dma_sync_single_for_cpu(jrdev, dma_addr_out, split_key_pad_len,
+				DMA_FROM_DEVICE);
 	dma_unmap_single(jrdev, dma_addr_out, split_key_pad_len,
 			 DMA_FROM_DEVICE);
 out_unmap_in:
diff --git a/drivers/crypto/caam/sg_sw_sec4.h b/drivers/crypto/caam/sg_sw_sec4.h
index 3b91821..6365585 100644
--- a/drivers/crypto/caam/sg_sw_sec4.h
+++ b/drivers/crypto/caam/sg_sw_sec4.h
@@ -98,6 +98,7 @@ static int dma_map_sg_chained(struct device *dev, struct scatterlist *sg,
 	} else {
 		dma_map_sg(dev, sg, nents, dir);
 	}
+
 	return nents;
 }
 
-- 
2.1.4
