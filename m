From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 3/4] crypto: caam: dma_map_sg can handle chained SG
Date: Wed, 23 Sep 2015 13:55:27 +0200
Message-ID: <1443009328-12478-4-git-send-email-clabbe.montjoie@gmail.com>
References: <1443009328-12478-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	catalin.vasile@freescale.com, clabbe.montjoie@gmail.com,
	cristian.stoica@freescale.com, fabio.estevam@freescale.com,
	horia.geanta@freescale.com, steve.cornelius@freescale.com,
	tudor.ambarus@freescale.com, vicki.milhoan@freescale.com,
	yanjiang.jin@windriver.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1443009328-12478-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The caam driver use two dma_map_sg path according to SG are chained
or not.
Since dma_map_sg can handle both case, clean the code with all
references to sg chained.

Thus removing dma_map_sg_chained, dma_unmap_sg_chained
and __sg_count functions.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/caam/caamalg.c    | 94 +++++++++++++++-------------------------
 drivers/crypto/caam/caamhash.c   | 55 ++++++++---------------
 drivers/crypto/caam/sg_sw_sec4.h | 72 +-----------------------------
 3 files changed, 53 insertions(+), 168 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index ba79d63..ad0d1ec 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1708,11 +1708,8 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 /*
  * aead_edesc - s/w-extended aead descriptor
  * @assoc_nents: number of segments in associated data (SPI+Seq) scatterlist
- * @assoc_chained: if source is chained
  * @src_nents: number of segments in input scatterlist
- * @src_chained: if source is chained
  * @dst_nents: number of segments in output scatterlist
- * @dst_chained: if destination is chained
  * @iv_dma: dma address of iv for checking continuity and link table
  * @desc: h/w descriptor (variable length; must not exceed MAX_CAAM_DESCSIZE)
  * @sec4_sg_bytes: length of dma mapped sec4_sg space
@@ -1721,11 +1718,8 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
  */
 struct aead_edesc {
 	int assoc_nents;
-	bool assoc_chained;
 	int src_nents;
-	bool src_chained;
 	int dst_nents;
-	bool dst_chained;
 	dma_addr_t iv_dma;
 	int sec4_sg_bytes;
 	dma_addr_t sec4_sg_dma;
@@ -1736,9 +1730,7 @@ struct aead_edesc {
 /*
  * ablkcipher_edesc - s/w-extended ablkcipher descriptor
  * @src_nents: number of segments in input scatterlist
- * @src_chained: if source is chained
  * @dst_nents: number of segments in output scatterlist
- * @dst_chained: if destination is chained
  * @iv_dma: dma address of iv for checking continuity and link table
  * @desc: h/w descriptor (variable length; must not exceed MAX_CAAM_DESCSIZE)
  * @sec4_sg_bytes: length of dma mapped sec4_sg space
@@ -1747,9 +1739,7 @@ struct aead_edesc {
  */
 struct ablkcipher_edesc {
 	int src_nents;
-	bool src_chained;
 	int dst_nents;
-	bool dst_chained;
 	dma_addr_t iv_dma;
 	int sec4_sg_bytes;
 	dma_addr_t sec4_sg_dma;
@@ -1759,18 +1749,15 @@ struct ablkcipher_edesc {
 
 static void caam_unmap(struct device *dev, struct scatterlist *src,
 		       struct scatterlist *dst, int src_nents,
-		       bool src_chained, int dst_nents, bool dst_chained,
+		       int dst_nents,
 		       dma_addr_t iv_dma, int ivsize, dma_addr_t sec4_sg_dma,
 		       int sec4_sg_bytes)
 {
 	if (dst != src) {
-		dma_unmap_sg_chained(dev, src, src_nents ? : 1, DMA_TO_DEVICE,
-				     src_chained);
-		dma_unmap_sg_chained(dev, dst, dst_nents ? : 1, DMA_FROM_DEVICE,
-				     dst_chained);
+		dma_unmap_sg(dev, src, src_nents ? : 1, DMA_TO_DEVICE);
+		dma_unmap_sg(dev, dst, dst_nents ? : 1, DMA_FROM_DEVICE);
 	} else {
-		dma_unmap_sg_chained(dev, src, src_nents ? : 1,
-				     DMA_BIDIRECTIONAL, src_chained);
+		dma_unmap_sg(dev, src, src_nents ? : 1, DMA_BIDIRECTIONAL);
 	}
 
 	if (iv_dma)
@@ -1785,8 +1772,7 @@ static void aead_unmap(struct device *dev,
 		       struct aead_request *req)
 {
 	caam_unmap(dev, req->src, req->dst,
-		   edesc->src_nents, edesc->src_chained, edesc->dst_nents,
-		   edesc->dst_chained, 0, 0,
+		   edesc->src_nents, edesc->dst_nents, 0, 0,
 		   edesc->sec4_sg_dma, edesc->sec4_sg_bytes);
 }
 
@@ -1798,8 +1784,8 @@ static void ablkcipher_unmap(struct device *dev,
 	int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
 
 	caam_unmap(dev, req->src, req->dst,
-		   edesc->src_nents, edesc->src_chained, edesc->dst_nents,
-		   edesc->dst_chained, edesc->iv_dma, ivsize,
+		   edesc->src_nents, edesc->dst_nents,
+		   edesc->iv_dma, ivsize,
 		   edesc->sec4_sg_dma, edesc->sec4_sg_bytes);
 }
 
@@ -2169,22 +2155,18 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	struct aead_edesc *edesc;
 	int sgc;
 	bool all_contig = true;
-	bool src_chained = false, dst_chained = false;
 	int sec4_sg_index, sec4_sg_len = 0, sec4_sg_bytes;
 	unsigned int authsize = ctx->authsize;
 
 	if (unlikely(req->dst != req->src)) {
-		src_nents = sg_count(req->src, req->assoclen + req->cryptlen,
-				     &src_chained);
+		src_nents = sg_count(req->src, req->assoclen + req->cryptlen);
 		dst_nents = sg_count(req->dst,
 				     req->assoclen + req->cryptlen +
-					(encrypt ? authsize : (-authsize)),
-				     &dst_chained);
+					(encrypt ? authsize : (-authsize)));
 	} else {
 		src_nents = sg_count(req->src,
 				     req->assoclen + req->cryptlen +
-					(encrypt ? authsize : 0),
-				     &src_chained);
+					(encrypt ? authsize : 0));
 	}
 
 	/* Check if data are contiguous. */
@@ -2207,37 +2189,35 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	}
 
 	if (likely(req->src == req->dst)) {
-		sgc = dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
-					 DMA_BIDIRECTIONAL, src_chained);
+		sgc = dma_map_sg(jrdev, req->src, src_nents ? : 1,
+				 DMA_BIDIRECTIONAL);
 		if (unlikely(!sgc)) {
 			dev_err(jrdev, "unable to map source\n");
 			kfree(edesc);
 			return ERR_PTR(-ENOMEM);
 		}
 	} else {
-		sgc = dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
-					 DMA_TO_DEVICE, src_chained);
+		sgc = dma_map_sg(jrdev, req->src, src_nents ? : 1,
+				 DMA_TO_DEVICE);
 		if (unlikely(!sgc)) {
 			dev_err(jrdev, "unable to map source\n");
 			kfree(edesc);
 			return ERR_PTR(-ENOMEM);
 		}
 
-		sgc = dma_map_sg_chained(jrdev, req->dst, dst_nents ? : 1,
-					 DMA_FROM_DEVICE, dst_chained);
+		sgc = dma_map_sg(jrdev, req->dst, dst_nents ? : 1,
+				 DMA_FROM_DEVICE);
 		if (unlikely(!sgc)) {
 			dev_err(jrdev, "unable to map destination\n");
-			dma_unmap_sg_chained(jrdev, req->src, src_nents ? : 1,
-					     DMA_TO_DEVICE, src_chained);
+			dma_unmap_sg(jrdev, req->src, src_nents ? : 1,
+				     DMA_TO_DEVICE);
 			kfree(edesc);
 			return ERR_PTR(-ENOMEM);
 		}
 	}
 
 	edesc->src_nents = src_nents;
-	edesc->src_chained = src_chained;
 	edesc->dst_nents = dst_nents;
-	edesc->dst_chained = dst_chained;
 	edesc->sec4_sg = (void *)edesc + sizeof(struct aead_edesc) +
 			 desc_bytes;
 	*all_contig_ptr = all_contig;
@@ -2467,22 +2447,21 @@ static struct ablkcipher_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request
 	bool iv_contig = false;
 	int sgc;
 	int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
-	bool src_chained = false, dst_chained = false;
 	int sec4_sg_index;
 
-	src_nents = sg_count(req->src, req->nbytes, &src_chained);
+	src_nents = sg_count(req->src, req->nbytes);
 
 	if (req->dst != req->src)
-		dst_nents = sg_count(req->dst, req->nbytes, &dst_chained);
+		dst_nents = sg_count(req->dst, req->nbytes);
 
 	if (likely(req->src == req->dst)) {
-		sgc = dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
-					 DMA_BIDIRECTIONAL, src_chained);
+		sgc = dma_map_sg(jrdev, req->src, src_nents ? : 1,
+				 DMA_BIDIRECTIONAL);
 	} else {
-		sgc = dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
-					 DMA_TO_DEVICE, src_chained);
-		sgc = dma_map_sg_chained(jrdev, req->dst, dst_nents ? : 1,
-					 DMA_FROM_DEVICE, dst_chained);
+		sgc = dma_map_sg(jrdev, req->src, src_nents ? : 1,
+				 DMA_TO_DEVICE);
+		sgc = dma_map_sg(jrdev, req->dst, dst_nents ? : 1,
+				 DMA_FROM_DEVICE);
 	}
 
 	iv_dma = dma_map_single(jrdev, req->info, ivsize, DMA_TO_DEVICE);
@@ -2511,9 +2490,7 @@ static struct ablkcipher_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request
 	}
 
 	edesc->src_nents = src_nents;
-	edesc->src_chained = src_chained;
 	edesc->dst_nents = dst_nents;
-	edesc->dst_chained = dst_chained;
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
 	edesc->sec4_sg = (void *)edesc + sizeof(struct ablkcipher_edesc) +
 			 desc_bytes;
@@ -2646,22 +2623,21 @@ static struct ablkcipher_edesc *ablkcipher_giv_edesc_alloc(
 	bool iv_contig = false;
 	int sgc;
 	int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
-	bool src_chained = false, dst_chained = false;
 	int sec4_sg_index;
 
-	src_nents = sg_count(req->src, req->nbytes, &src_chained);
+	src_nents = sg_count(req->src, req->nbytes);
 
 	if (unlikely(req->dst != req->src))
-		dst_nents = sg_count(req->dst, req->nbytes, &dst_chained);
+		dst_nents = sg_count(req->dst, req->nbytes);
 
 	if (likely(req->src == req->dst)) {
-		sgc = dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
-					 DMA_BIDIRECTIONAL, src_chained);
+		sgc = dma_map_sg(jrdev, req->src, src_nents ? : 1,
+				 DMA_BIDIRECTIONAL);
 	} else {
-		sgc = dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
-					 DMA_TO_DEVICE, src_chained);
-		sgc = dma_map_sg_chained(jrdev, req->dst, dst_nents ? : 1,
-					 DMA_FROM_DEVICE, dst_chained);
+		sgc = dma_map_sg(jrdev, req->src, src_nents ? : 1,
+				 DMA_TO_DEVICE);
+		sgc = dma_map_sg(jrdev, req->dst, dst_nents ? : 1,
+				 DMA_FROM_DEVICE);
 	}
 
 	/*
@@ -2690,9 +2666,7 @@ static struct ablkcipher_edesc *ablkcipher_giv_edesc_alloc(
 	}
 
 	edesc->src_nents = src_nents;
-	edesc->src_chained = src_chained;
 	edesc->dst_nents = dst_nents;
-	edesc->dst_chained = dst_chained;
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
 	edesc->sec4_sg = (void *)edesc + sizeof(struct ablkcipher_edesc) +
 			 desc_bytes;
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 94433b9..9609f66 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -181,10 +181,9 @@ static inline dma_addr_t buf_map_to_sec4_sg(struct device *jrdev,
 /* Map req->src and put it in link table */
 static inline void src_map_to_sec4_sg(struct device *jrdev,
 				      struct scatterlist *src, int src_nents,
-				      struct sec4_sg_entry *sec4_sg,
-				      bool chained)
+				      struct sec4_sg_entry *sec4_sg)
 {
-	dma_map_sg_chained(jrdev, src, src_nents, DMA_TO_DEVICE, chained);
+	dma_map_sg(jrdev, src, src_nents, DMA_TO_DEVICE);
 	sg_to_sec4_sg_last(src, src_nents, sec4_sg, 0);
 }
 
@@ -585,7 +584,6 @@ badkey:
  * ahash_edesc - s/w-extended ahash descriptor
  * @dst_dma: physical mapped address of req->result
  * @sec4_sg_dma: physical mapped address of h/w link table
- * @chained: if source is chained
  * @src_nents: number of segments in input scatterlist
  * @sec4_sg_bytes: length of dma mapped sec4_sg space
  * @sec4_sg: pointer to h/w link table
@@ -594,7 +592,6 @@ badkey:
 struct ahash_edesc {
 	dma_addr_t dst_dma;
 	dma_addr_t sec4_sg_dma;
-	bool chained;
 	int src_nents;
 	int sec4_sg_bytes;
 	struct sec4_sg_entry *sec4_sg;
@@ -606,8 +603,7 @@ static inline void ahash_unmap(struct device *dev,
 			struct ahash_request *req, int dst_len)
 {
 	if (edesc->src_nents)
-		dma_unmap_sg_chained(dev, req->src, edesc->src_nents,
-				     DMA_TO_DEVICE, edesc->chained);
+		dma_unmap_sg(dev, req->src, edesc->src_nents, DMA_TO_DEVICE);
 	if (edesc->dst_dma)
 		dma_unmap_single(dev, edesc->dst_dma, dst_len, DMA_FROM_DEVICE);
 
@@ -788,7 +784,6 @@ static int ahash_update_ctx(struct ahash_request *req)
 	dma_addr_t ptr = ctx->sh_desc_update_dma;
 	int src_nents, sec4_sg_bytes, sec4_sg_src_index;
 	struct ahash_edesc *edesc;
-	bool chained = false;
 	int ret = 0;
 	int sh_len;
 
@@ -797,8 +792,8 @@ static int ahash_update_ctx(struct ahash_request *req)
 	to_hash = in_len - *next_buflen;
 
 	if (to_hash) {
-		src_nents = __sg_count(req->src, req->nbytes - (*next_buflen),
-				       &chained);
+		src_nents = sg_nents_for_len(req->src,
+					     req->nbytes - (*next_buflen));
 		sec4_sg_src_index = 1 + (*buflen ? 1 : 0);
 		sec4_sg_bytes = (sec4_sg_src_index + src_nents) *
 				 sizeof(struct sec4_sg_entry);
@@ -816,7 +811,6 @@ static int ahash_update_ctx(struct ahash_request *req)
 		}
 
 		edesc->src_nents = src_nents;
-		edesc->chained = chained;
 		edesc->sec4_sg_bytes = sec4_sg_bytes;
 		edesc->sec4_sg = (void *)edesc + sizeof(struct ahash_edesc) +
 				 DESC_JOB_IO_LEN;
@@ -833,8 +827,7 @@ static int ahash_update_ctx(struct ahash_request *req)
 
 		if (src_nents) {
 			src_map_to_sec4_sg(jrdev, req->src, src_nents,
-					   edesc->sec4_sg + sec4_sg_src_index,
-					   chained);
+					   edesc->sec4_sg + sec4_sg_src_index);
 			if (*next_buflen)
 				scatterwalk_map_and_copy(next_buf, req->src,
 							 to_hash - *buflen,
@@ -996,11 +989,10 @@ static int ahash_finup_ctx(struct ahash_request *req)
 	int src_nents;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
-	bool chained = false;
 	int ret = 0;
 	int sh_len;
 
-	src_nents = __sg_count(req->src, req->nbytes, &chained);
+	src_nents = sg_nents_for_len(req->src, req->nbytes);
 	sec4_sg_src_index = 1 + (buflen ? 1 : 0);
 	sec4_sg_bytes = (sec4_sg_src_index + src_nents) *
 			 sizeof(struct sec4_sg_entry);
@@ -1018,7 +1010,6 @@ static int ahash_finup_ctx(struct ahash_request *req)
 	init_job_desc_shared(desc, ptr, sh_len, HDR_SHARE_DEFER | HDR_REVERSE);
 
 	edesc->src_nents = src_nents;
-	edesc->chained = chained;
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
 	edesc->sec4_sg = (void *)edesc + sizeof(struct ahash_edesc) +
 			 DESC_JOB_IO_LEN;
@@ -1033,7 +1024,7 @@ static int ahash_finup_ctx(struct ahash_request *req)
 						last_buflen);
 
 	src_map_to_sec4_sg(jrdev, req->src, src_nents, edesc->sec4_sg +
-			   sec4_sg_src_index, chained);
+			   sec4_sg_src_index);
 
 	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
 					    sec4_sg_bytes, DMA_TO_DEVICE);
@@ -1081,14 +1072,12 @@ static int ahash_digest(struct ahash_request *req)
 	int src_nents, sec4_sg_bytes;
 	dma_addr_t src_dma;
 	struct ahash_edesc *edesc;
-	bool chained = false;
 	int ret = 0;
 	u32 options;
 	int sh_len;
 
-	src_nents = sg_count(req->src, req->nbytes, &chained);
-	dma_map_sg_chained(jrdev, req->src, src_nents ? : 1, DMA_TO_DEVICE,
-			   chained);
+	src_nents = sg_count(req->src, req->nbytes);
+	dma_map_sg(jrdev, req->src, src_nents ? : 1, DMA_TO_DEVICE);
 	sec4_sg_bytes = src_nents * sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
@@ -1102,7 +1091,6 @@ static int ahash_digest(struct ahash_request *req)
 			  DESC_JOB_IO_LEN;
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
 	edesc->src_nents = src_nents;
-	edesc->chained = chained;
 
 	sh_len = desc_len(sh_desc);
 	desc = edesc->hw_desc;
@@ -1228,7 +1216,6 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 	struct ahash_edesc *edesc;
 	u32 *desc, *sh_desc = ctx->sh_desc_update_first;
 	dma_addr_t ptr = ctx->sh_desc_update_first_dma;
-	bool chained = false;
 	int ret = 0;
 	int sh_len;
 
@@ -1236,8 +1223,8 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 	to_hash = in_len - *next_buflen;
 
 	if (to_hash) {
-		src_nents = __sg_count(req->src, req->nbytes - (*next_buflen),
-				       &chained);
+		src_nents = sg_nents_for_len(req->src,
+					     req->nbytes - (*next_buflen));
 		sec4_sg_bytes = (1 + src_nents) *
 				sizeof(struct sec4_sg_entry);
 
@@ -1254,7 +1241,6 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 		}
 
 		edesc->src_nents = src_nents;
-		edesc->chained = chained;
 		edesc->sec4_sg_bytes = sec4_sg_bytes;
 		edesc->sec4_sg = (void *)edesc + sizeof(struct ahash_edesc) +
 				 DESC_JOB_IO_LEN;
@@ -1263,7 +1249,7 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 		state->buf_dma = buf_map_to_sec4_sg(jrdev, edesc->sec4_sg,
 						    buf, *buflen);
 		src_map_to_sec4_sg(jrdev, req->src, src_nents,
-				   edesc->sec4_sg + 1, chained);
+				   edesc->sec4_sg + 1);
 		if (*next_buflen) {
 			scatterwalk_map_and_copy(next_buf, req->src,
 						 to_hash - *buflen,
@@ -1343,11 +1329,10 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 	int sec4_sg_bytes, sec4_sg_src_index, src_nents;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
-	bool chained = false;
 	int sh_len;
 	int ret = 0;
 
-	src_nents = __sg_count(req->src, req->nbytes, &chained);
+	src_nents = sg_nents_for_len(req->src, req->nbytes);
 	sec4_sg_src_index = 2;
 	sec4_sg_bytes = (sec4_sg_src_index + src_nents) *
 			 sizeof(struct sec4_sg_entry);
@@ -1365,7 +1350,6 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 	init_job_desc_shared(desc, ptr, sh_len, HDR_SHARE_DEFER | HDR_REVERSE);
 
 	edesc->src_nents = src_nents;
-	edesc->chained = chained;
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
 	edesc->sec4_sg = (void *)edesc + sizeof(struct ahash_edesc) +
 			 DESC_JOB_IO_LEN;
@@ -1374,8 +1358,7 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 						state->buf_dma, buflen,
 						last_buflen);
 
-	src_map_to_sec4_sg(jrdev, req->src, src_nents, edesc->sec4_sg + 1,
-			   chained);
+	src_map_to_sec4_sg(jrdev, req->src, src_nents, edesc->sec4_sg + 1);
 
 	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
 					    sec4_sg_bytes, DMA_TO_DEVICE);
@@ -1429,7 +1412,6 @@ static int ahash_update_first(struct ahash_request *req)
 	dma_addr_t src_dma;
 	u32 options;
 	struct ahash_edesc *edesc;
-	bool chained = false;
 	int ret = 0;
 	int sh_len;
 
@@ -1438,10 +1420,8 @@ static int ahash_update_first(struct ahash_request *req)
 	to_hash = req->nbytes - *next_buflen;
 
 	if (to_hash) {
-		src_nents = sg_count(req->src, req->nbytes - (*next_buflen),
-				     &chained);
-		dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
-				   DMA_TO_DEVICE, chained);
+		src_nents = sg_count(req->src, req->nbytes - (*next_buflen));
+		dma_map_sg(jrdev, req->src, src_nents ? : 1, DMA_TO_DEVICE);
 		sec4_sg_bytes = src_nents * sizeof(struct sec4_sg_entry);
 
 		/*
@@ -1457,7 +1437,6 @@ static int ahash_update_first(struct ahash_request *req)
 		}
 
 		edesc->src_nents = src_nents;
-		edesc->chained = chained;
 		edesc->sec4_sg_bytes = sec4_sg_bytes;
 		edesc->sec4_sg = (void *)edesc + sizeof(struct ahash_edesc) +
 				 DESC_JOB_IO_LEN;
diff --git a/drivers/crypto/caam/sg_sw_sec4.h b/drivers/crypto/caam/sg_sw_sec4.h
index 18cd6d1..12ec661 100644
--- a/drivers/crypto/caam/sg_sw_sec4.h
+++ b/drivers/crypto/caam/sg_sw_sec4.h
@@ -69,81 +69,13 @@ static inline struct sec4_sg_entry *sg_to_sec4_sg_len(
 	return sec4_sg_ptr - 1;
 }
 
-/* count number of elements in scatterlist */
-static inline int __sg_count(struct scatterlist *sg_list, int nbytes,
-			     bool *chained)
-{
-	struct scatterlist *sg = sg_list;
-	int sg_nents = 0;
-
-	while (nbytes > 0) {
-		sg_nents++;
-		nbytes -= sg->length;
-		if (!sg_is_last(sg) && (sg + 1)->length == 0)
-			*chained = true;
-		sg = sg_next(sg);
-	}
-
-	return sg_nents;
-}
-
 /* derive number of elements in scatterlist, but return 0 for 1 */
-static inline int sg_count(struct scatterlist *sg_list, int nbytes,
-			     bool *chained)
+static inline int sg_count(struct scatterlist *sg_list, int nbytes)
 {
-	int sg_nents = __sg_count(sg_list, nbytes, chained);
+	int sg_nents = sg_nents_for_len(sg_list, nbytes);
 
 	if (likely(sg_nents == 1))
 		return 0;
 
 	return sg_nents;
 }
-
-static inline void dma_unmap_sg_chained(
-	struct device *dev, struct scatterlist *sg, unsigned int nents,
-	enum dma_data_direction dir, bool chained)
-{
-	if (unlikely(chained)) {
-		int i;
-		struct scatterlist *tsg = sg;
-
-		/*
-		 * Use a local copy of the sg pointer to avoid moving the
-		 * head of the list pointed to by sg as we walk the list.
-		 */
-		for (i = 0; i < nents; i++) {
-			dma_unmap_sg(dev, tsg, 1, dir);
-			tsg = sg_next(tsg);
-		}
-	} else if (nents) {
-		dma_unmap_sg(dev, sg, nents, dir);
-	}
-}
-
-static inline int dma_map_sg_chained(
-	struct device *dev, struct scatterlist *sg, unsigned int nents,
-	enum dma_data_direction dir, bool chained)
-{
-	if (unlikely(chained)) {
-		int i;
-		struct scatterlist *tsg = sg;
-
-		/*
-		 * Use a local copy of the sg pointer to avoid moving the
-		 * head of the list pointed to by sg as we walk the list.
-		 */
-		for (i = 0; i < nents; i++) {
-			if (!dma_map_sg(dev, tsg, 1, dir)) {
-				dma_unmap_sg_chained(dev, sg, i, dir,
-						     chained);
-				nents = 0;
-				break;
-			}
-
-			tsg = sg_next(tsg);
-		}
-	} else
-		nents = dma_map_sg(dev, sg, nents, dir);
-
-	return nents;
-}
-- 
2.4.9
