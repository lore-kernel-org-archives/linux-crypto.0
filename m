Return-Path: <SRS0=5M5o=S3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A187C4321B
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Apr 2019 16:25:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA1F42077C
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Apr 2019 16:25:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbfDYQZU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Apr 2019 12:25:20 -0400
Received: from inva021.nxp.com ([92.121.34.21]:35716 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbfDYQZU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Apr 2019 12:25:20 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id C808F2003F2;
        Thu, 25 Apr 2019 18:25:16 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id B86FB20000F;
        Thu, 25 Apr 2019 18:25:16 +0200 (CEST)
Received: from fsr-ub1864-014.ea.freescale.net (fsr-ub1864-014.ea.freescale.net [10.171.95.219])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 48B532061F;
        Thu, 25 Apr 2019 18:25:16 +0200 (CEST)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Marcin Niestroj <m.niestroj@grinn-global.com>,
        linux-crypto@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>
Subject: [PATCH 2/7] crypto: caam - fix S/G table passing page boundary
Date:   Thu, 25 Apr 2019 19:24:56 +0300
Message-Id: <20190425162501.4565-3-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190425162501.4565-1-horia.geanta@nxp.com>
References: <20190425162501.4565-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

According to CAAM RM:
-crypto engine reads 4 S/G entries (64 bytes) at a time,
even if the S/G table has fewer entries
-it's the responsibility of the user / programmer to make sure
this HW behaviour has no side effect

The drivers do not take care of this currently, leading to IOMMU faults
when the S/G table ends close to a page boundary - since only one page
is DMA mapped, while CAAM's DMA engine accesses two pages.

Fix this by rounding up the number of allocated S/G table entries
to a multiple of 4.
Note that in case of two *contiguous* S/G tables, only the last table
might needs extra entries.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg.c     | 30 ++++++++++++++-
 drivers/crypto/caam/caamalg_qi.c  | 40 ++++++++++++++++++--
 drivers/crypto/caam/caamalg_qi2.c | 63 ++++++++++++++++++++++++-------
 drivers/crypto/caam/caamhash.c    | 33 ++++++++--------
 drivers/crypto/caam/caampkc.c     |  7 +++-
 drivers/crypto/caam/desc_constr.h | 11 ++++++
 6 files changed, 147 insertions(+), 37 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index e8f8be396796..ecb33644a085 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1380,8 +1380,16 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 		}
 	}
 
+	/*
+	 * HW reads 4 S/G entries at a time; make sure the reads don't go beyond
+	 * the end of the table by allocating more S/G entries.
+	 */
 	sec4_sg_len = mapped_src_nents > 1 ? mapped_src_nents : 0;
-	sec4_sg_len += mapped_dst_nents > 1 ? mapped_dst_nents : 0;
+	if (mapped_dst_nents > 1)
+		sec4_sg_len += pad_sg_nents(mapped_dst_nents);
+	else
+		sec4_sg_len = pad_sg_nents(sec4_sg_len);
+
 	sec4_sg_bytes = sec4_sg_len * sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
@@ -1719,7 +1727,25 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 	else
 		sec4_sg_ents = mapped_src_nents + !!ivsize;
 	dst_sg_idx = sec4_sg_ents;
-	sec4_sg_ents += mapped_dst_nents > 1 ? mapped_dst_nents : 0;
+
+	/*
+	 * HW reads 4 S/G entries at a time; make sure the reads don't go beyond
+	 * the end of the table by allocating more S/G entries. Logic:
+	 * if (src != dst && output S/G)
+	 *      pad output S/G, if needed
+	 * else if (src == dst && S/G)
+	 *      overlapping S/Gs; pad one of them
+	 * else if (input S/G) ...
+	 *      pad input S/G, if needed
+	 */
+	if (mapped_dst_nents > 1)
+		sec4_sg_ents += pad_sg_nents(mapped_dst_nents);
+	else if ((req->src == req->dst) && (mapped_src_nents > 1))
+		sec4_sg_ents = max(pad_sg_nents(sec4_sg_ents),
+				   !!ivsize + pad_sg_nents(mapped_src_nents));
+	else
+		sec4_sg_ents = pad_sg_nents(sec4_sg_ents);
+
 	sec4_sg_bytes = sec4_sg_ents * sizeof(struct sec4_sg_entry);
 
 	/*
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 992c498879a4..a1ed6a721834 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -4,7 +4,7 @@
  * Based on caamalg.c
  *
  * Copyright 2013-2016 Freescale Semiconductor, Inc.
- * Copyright 2016-2018 NXP
+ * Copyright 2016-2019 NXP
  */
 
 #include "compat.h"
@@ -1018,9 +1018,24 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	/*
 	 * Create S/G table: req->assoclen, [IV,] req->src [, req->dst].
 	 * Input is not contiguous.
+	 * HW reads 4 S/G entries at a time; make sure the reads don't go beyond
+	 * the end of the table by allocating more S/G entries. Logic:
+	 * if (src != dst && output S/G)
+	 *      pad output S/G, if needed
+	 * else if (src == dst && S/G)
+	 *      overlapping S/Gs; pad one of them
+	 * else if (input S/G) ...
+	 *      pad input S/G, if needed
 	 */
-	qm_sg_ents = 1 + !!ivsize + mapped_src_nents +
-		     (mapped_dst_nents > 1 ? mapped_dst_nents : 0);
+	qm_sg_ents = 1 + !!ivsize + mapped_src_nents;
+	if (mapped_dst_nents > 1)
+		qm_sg_ents += pad_sg_nents(mapped_dst_nents);
+	else if ((req->src == req->dst) && (mapped_src_nents > 1))
+		qm_sg_ents = max(pad_sg_nents(qm_sg_ents),
+				 1 + !!ivsize + pad_sg_nents(mapped_src_nents));
+	else
+		qm_sg_ents = pad_sg_nents(qm_sg_ents);
+
 	sg_table = &edesc->sgt[0];
 	qm_sg_bytes = qm_sg_ents * sizeof(*sg_table);
 	if (unlikely(offsetof(struct aead_edesc, sgt) + qm_sg_bytes + ivsize >
@@ -1275,7 +1290,24 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 	qm_sg_ents = 1 + mapped_src_nents;
 	dst_sg_idx = qm_sg_ents;
 
-	qm_sg_ents += mapped_dst_nents > 1 ? mapped_dst_nents : 0;
+	/*
+	 * HW reads 4 S/G entries at a time; make sure the reads don't go beyond
+	 * the end of the table by allocating more S/G entries. Logic:
+	 * if (src != dst && output S/G)
+	 *      pad output S/G, if needed
+	 * else if (src == dst && S/G)
+	 *      overlapping S/Gs; pad one of them
+	 * else if (input S/G) ...
+	 *      pad input S/G, if needed
+	 */
+	if (mapped_dst_nents > 1)
+		qm_sg_ents += pad_sg_nents(mapped_dst_nents);
+	else if ((req->src == req->dst) && (mapped_src_nents > 1))
+		qm_sg_ents = max(pad_sg_nents(qm_sg_ents),
+				 1 + pad_sg_nents(mapped_src_nents));
+	else
+		qm_sg_ents = pad_sg_nents(qm_sg_ents);
+
 	qm_sg_bytes = qm_sg_ents * sizeof(struct qm_sg_entry);
 	if (unlikely(offsetof(struct skcipher_edesc, sgt) + qm_sg_bytes +
 		     ivsize > CAAM_QI_MEMCACHE_SIZE)) {
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 627cf0fd37f1..148ad92c16a5 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
 /*
  * Copyright 2015-2016 Freescale Semiconductor Inc.
- * Copyright 2017-2018 NXP
+ * Copyright 2017-2019 NXP
  */
 
 #include "compat.h"
@@ -459,9 +459,25 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	/*
 	 * Create S/G table: req->assoclen, [IV,] req->src [, req->dst].
 	 * Input is not contiguous.
+	 * HW reads 4 S/G entries at a time; make sure the reads don't go beyond
+	 * the end of the table by allocating more S/G entries. Logic:
+	 * if (src != dst && output S/G)
+	 *      pad output S/G, if needed
+	 * else if (src == dst && S/G)
+	 *      overlapping S/Gs; pad one of them
+	 * else if (input S/G) ...
+	 *      pad input S/G, if needed
 	 */
-	qm_sg_nents = 1 + !!ivsize + mapped_src_nents +
-		      (mapped_dst_nents > 1 ? mapped_dst_nents : 0);
+	qm_sg_nents = 1 + !!ivsize + mapped_src_nents;
+	if (mapped_dst_nents > 1)
+		qm_sg_nents += pad_sg_nents(mapped_dst_nents);
+	else if ((req->src == req->dst) && (mapped_src_nents > 1))
+		qm_sg_nents = max(pad_sg_nents(qm_sg_nents),
+				  1 + !!ivsize +
+				  pad_sg_nents(mapped_src_nents));
+	else
+		qm_sg_nents = pad_sg_nents(qm_sg_nents);
+
 	sg_table = &edesc->sgt[0];
 	qm_sg_bytes = qm_sg_nents * sizeof(*sg_table);
 	if (unlikely(offsetof(struct aead_edesc, sgt) + qm_sg_bytes + ivsize >
@@ -1085,7 +1101,24 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req)
 	qm_sg_ents = 1 + mapped_src_nents;
 	dst_sg_idx = qm_sg_ents;
 
-	qm_sg_ents += mapped_dst_nents > 1 ? mapped_dst_nents : 0;
+	/*
+	 * HW reads 4 S/G entries at a time; make sure the reads don't go beyond
+	 * the end of the table by allocating more S/G entries. Logic:
+	 * if (src != dst && output S/G)
+	 *      pad output S/G, if needed
+	 * else if (src == dst && S/G)
+	 *      overlapping S/Gs; pad one of them
+	 * else if (input S/G) ...
+	 *      pad input S/G, if needed
+	 */
+	if (mapped_dst_nents > 1)
+		qm_sg_ents += pad_sg_nents(mapped_dst_nents);
+	else if ((req->src == req->dst) && (mapped_src_nents > 1))
+		qm_sg_ents = max(pad_sg_nents(qm_sg_ents),
+				 1 + pad_sg_nents(mapped_src_nents));
+	else
+		qm_sg_ents = pad_sg_nents(qm_sg_ents);
+
 	qm_sg_bytes = qm_sg_ents * sizeof(struct dpaa2_sg_entry);
 	if (unlikely(offsetof(struct skcipher_edesc, sgt) + qm_sg_bytes +
 		     ivsize > CAAM_QI_MEMCACHE_SIZE)) {
@@ -3412,7 +3445,7 @@ static int ahash_update_ctx(struct ahash_request *req)
 
 		edesc->src_nents = src_nents;
 		qm_sg_src_index = 1 + (*buflen ? 1 : 0);
-		qm_sg_bytes = (qm_sg_src_index + mapped_nents) *
+		qm_sg_bytes = pad_sg_nents(qm_sg_src_index + mapped_nents) *
 			      sizeof(*sg_table);
 		sg_table = &edesc->sgt[0];
 
@@ -3497,7 +3530,7 @@ static int ahash_final_ctx(struct ahash_request *req)
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		      GFP_KERNEL : GFP_ATOMIC;
 	int buflen = *current_buflen(state);
-	int qm_sg_bytes, qm_sg_src_index;
+	int qm_sg_bytes;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
 	struct dpaa2_sg_entry *sg_table;
@@ -3508,8 +3541,7 @@ static int ahash_final_ctx(struct ahash_request *req)
 	if (!edesc)
 		return -ENOMEM;
 
-	qm_sg_src_index = 1 + (buflen ? 1 : 0);
-	qm_sg_bytes = qm_sg_src_index * sizeof(*sg_table);
+	qm_sg_bytes = pad_sg_nents(1 + (buflen ? 1 : 0)) * sizeof(*sg_table);
 	sg_table = &edesc->sgt[0];
 
 	ret = ctx_map_to_qm_sg(ctx->dev, state, ctx->ctx_len, sg_table,
@@ -3521,7 +3553,7 @@ static int ahash_final_ctx(struct ahash_request *req)
 	if (ret)
 		goto unmap_ctx;
 
-	dpaa2_sg_set_final(sg_table + qm_sg_src_index - 1, true);
+	dpaa2_sg_set_final(sg_table + (buflen ? 1 : 0), true);
 
 	edesc->qm_sg_dma = dma_map_single(ctx->dev, sg_table, qm_sg_bytes,
 					  DMA_TO_DEVICE);
@@ -3602,7 +3634,8 @@ static int ahash_finup_ctx(struct ahash_request *req)
 
 	edesc->src_nents = src_nents;
 	qm_sg_src_index = 1 + (buflen ? 1 : 0);
-	qm_sg_bytes = (qm_sg_src_index + mapped_nents) * sizeof(*sg_table);
+	qm_sg_bytes = pad_sg_nents(qm_sg_src_index + mapped_nents) *
+		      sizeof(*sg_table);
 	sg_table = &edesc->sgt[0];
 
 	ret = ctx_map_to_qm_sg(ctx->dev, state, ctx->ctx_len, sg_table,
@@ -3699,7 +3732,7 @@ static int ahash_digest(struct ahash_request *req)
 		int qm_sg_bytes;
 		struct dpaa2_sg_entry *sg_table = &edesc->sgt[0];
 
-		qm_sg_bytes = mapped_nents * sizeof(*sg_table);
+		qm_sg_bytes = pad_sg_nents(mapped_nents) * sizeof(*sg_table);
 		sg_to_qm_sg_last(req->src, mapped_nents, sg_table, 0);
 		edesc->qm_sg_dma = dma_map_single(ctx->dev, sg_table,
 						  qm_sg_bytes, DMA_TO_DEVICE);
@@ -3871,7 +3904,8 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 		}
 
 		edesc->src_nents = src_nents;
-		qm_sg_bytes = (1 + mapped_nents) * sizeof(*sg_table);
+		qm_sg_bytes = pad_sg_nents(1 + mapped_nents) *
+			      sizeof(*sg_table);
 		sg_table = &edesc->sgt[0];
 
 		ret = buf_map_to_qm_sg(ctx->dev, sg_table, state);
@@ -3990,7 +4024,7 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 	}
 
 	edesc->src_nents = src_nents;
-	qm_sg_bytes = (2 + mapped_nents) * sizeof(*sg_table);
+	qm_sg_bytes = pad_sg_nents(2 + mapped_nents) * sizeof(*sg_table);
 	sg_table = &edesc->sgt[0];
 
 	ret = buf_map_to_qm_sg(ctx->dev, sg_table, state);
@@ -4105,7 +4139,8 @@ static int ahash_update_first(struct ahash_request *req)
 			int qm_sg_bytes;
 
 			sg_to_qm_sg_last(req->src, mapped_nents, sg_table, 0);
-			qm_sg_bytes = mapped_nents * sizeof(*sg_table);
+			qm_sg_bytes = pad_sg_nents(mapped_nents) *
+				      sizeof(*sg_table);
 			edesc->qm_sg_dma = dma_map_single(ctx->dev, sg_table,
 							  qm_sg_bytes,
 							  DMA_TO_DEVICE);
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index b1eadc6652b5..200e533794c8 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -759,7 +759,8 @@ static int ahash_edesc_add_src(struct caam_hash_ctx *ctx,
 
 	if (nents > 1 || first_sg) {
 		struct sec4_sg_entry *sg = edesc->sec4_sg;
-		unsigned int sgsize = sizeof(*sg) * (first_sg + nents);
+		unsigned int sgsize = sizeof(*sg) *
+				      pad_sg_nents(first_sg + nents);
 
 		sg_to_sec4_sg_last(req->src, nents, sg + first_sg, 0);
 
@@ -819,6 +820,8 @@ static int ahash_update_ctx(struct ahash_request *req)
 	}
 
 	if (to_hash) {
+		int pad_nents;
+
 		src_nents = sg_nents_for_len(req->src,
 					     req->nbytes - (*next_buflen));
 		if (src_nents < 0) {
@@ -838,15 +841,14 @@ static int ahash_update_ctx(struct ahash_request *req)
 		}
 
 		sec4_sg_src_index = 1 + (*buflen ? 1 : 0);
-		sec4_sg_bytes = (sec4_sg_src_index + mapped_nents) *
-				 sizeof(struct sec4_sg_entry);
+		pad_nents = pad_sg_nents(sec4_sg_src_index + mapped_nents);
+		sec4_sg_bytes = pad_nents * sizeof(struct sec4_sg_entry);
 
 		/*
 		 * allocate space for base edesc and hw desc commands,
 		 * link tables
 		 */
-		edesc = ahash_edesc_alloc(ctx, sec4_sg_src_index + mapped_nents,
-					  ctx->sh_desc_update,
+		edesc = ahash_edesc_alloc(ctx, pad_nents, ctx->sh_desc_update,
 					  ctx->sh_desc_update_dma, flags);
 		if (!edesc) {
 			dma_unmap_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
@@ -936,18 +938,17 @@ static int ahash_final_ctx(struct ahash_request *req)
 		       GFP_KERNEL : GFP_ATOMIC;
 	int buflen = *current_buflen(state);
 	u32 *desc;
-	int sec4_sg_bytes, sec4_sg_src_index;
+	int sec4_sg_bytes;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
 	int ret;
 
-	sec4_sg_src_index = 1 + (buflen ? 1 : 0);
-	sec4_sg_bytes = sec4_sg_src_index * sizeof(struct sec4_sg_entry);
+	sec4_sg_bytes = pad_sg_nents(1 + (buflen ? 1 : 0)) *
+			sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = ahash_edesc_alloc(ctx, sec4_sg_src_index,
-				  ctx->sh_desc_fin, ctx->sh_desc_fin_dma,
-				  flags);
+	edesc = ahash_edesc_alloc(ctx, 4, ctx->sh_desc_fin,
+				  ctx->sh_desc_fin_dma, flags);
 	if (!edesc)
 		return -ENOMEM;
 
@@ -964,7 +965,7 @@ static int ahash_final_ctx(struct ahash_request *req)
 	if (ret)
 		goto unmap_ctx;
 
-	sg_to_sec4_set_last(edesc->sec4_sg + sec4_sg_src_index - 1);
+	sg_to_sec4_set_last(edesc->sec4_sg + (buflen ? 1 : 0));
 
 	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
 					    sec4_sg_bytes, DMA_TO_DEVICE);
@@ -1247,6 +1248,8 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 	}
 
 	if (to_hash) {
+		int pad_nents;
+
 		src_nents = sg_nents_for_len(req->src,
 					     req->nbytes - *next_buflen);
 		if (src_nents < 0) {
@@ -1265,14 +1268,14 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 			mapped_nents = 0;
 		}
 
-		sec4_sg_bytes = (1 + mapped_nents) *
-				sizeof(struct sec4_sg_entry);
+		pad_nents = pad_sg_nents(1 + mapped_nents);
+		sec4_sg_bytes = pad_nents * sizeof(struct sec4_sg_entry);
 
 		/*
 		 * allocate space for base edesc and hw desc commands,
 		 * link tables
 		 */
-		edesc = ahash_edesc_alloc(ctx, 1 + mapped_nents,
+		edesc = ahash_edesc_alloc(ctx, pad_nents,
 					  ctx->sh_desc_update_first,
 					  ctx->sh_desc_update_first_dma,
 					  flags);
diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index fe24485274e1..d97ffb03afc0 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -3,7 +3,7 @@
  * caam - Freescale FSL CAAM support for Public Key Cryptography
  *
  * Copyright 2016 Freescale Semiconductor, Inc.
- * Copyright 2018 NXP
+ * Copyright 2018-2019 NXP
  *
  * There is no Shared Descriptor for PKC so that the Job Descriptor must carry
  * all the desired key parameters, input and output pointers.
@@ -239,8 +239,11 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
 
 	if (src_nents > 1)
 		sec4_sg_len = src_nents;
+
 	if (dst_nents > 1)
-		sec4_sg_len += dst_nents;
+		sec4_sg_len += pad_sg_nents(dst_nents);
+	else
+		sec4_sg_len = pad_sg_nents(sec4_sg_len);
 
 	sec4_sg_bytes = sec4_sg_len * sizeof(struct sec4_sg_entry);
 
diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/desc_constr.h
index 2980b8ef1fb1..5988a26a2441 100644
--- a/drivers/crypto/caam/desc_constr.h
+++ b/drivers/crypto/caam/desc_constr.h
@@ -3,6 +3,7 @@
  * caam descriptor construction helper functions
  *
  * Copyright 2008-2012 Freescale Semiconductor, Inc.
+ * Copyright 2019 NXP
  */
 
 #ifndef DESC_CONSTR_H
@@ -37,6 +38,16 @@
 
 extern bool caam_little_end;
 
+/*
+ * HW fetches 4 S/G table entries at a time, irrespective of how many entries
+ * are in the table. It's SW's responsibility to make sure these accesses
+ * do not have side effects.
+ */
+static inline int pad_sg_nents(int sg_nents)
+{
+	return ALIGN(sg_nents, 4);
+}
+
 static inline int desc_len(u32 * const desc)
 {
 	return caam32_to_cpu(*desc) & HDR_DESCLEN_MASK;
-- 
2.17.1

