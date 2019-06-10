Return-Path: <SRS0=e/ms=UJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97873C28CC7
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Jun 2019 13:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 663D6212F5
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Jun 2019 13:31:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390375AbfFJNbP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Jun 2019 09:31:15 -0400
Received: from inva020.nxp.com ([92.121.34.13]:41926 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389414AbfFJNbM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Jun 2019 09:31:12 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 79B881A084A;
        Mon, 10 Jun 2019 15:31:09 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 6BF481A0848;
        Mon, 10 Jun 2019 15:31:09 +0200 (CEST)
Received: from fsr-ub1864-014.ea.freescale.net (fsr-ub1864-014.ea.freescale.net [10.171.95.219])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 20C6F205E4;
        Mon, 10 Jun 2019 15:31:09 +0200 (CEST)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        NXP Linux Team <linux-imx@nxp.com>
Subject: [PATCH 1/2] crypto: caam - use len instead of nents for bulding HW S/G table
Date:   Mon, 10 Jun 2019 16:30:58 +0300
Message-Id: <20190610133059.1059-2-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190610133059.1059-1-horia.geanta@nxp.com>
References: <20190610133059.1059-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently, conversion of SW S/G table into HW S/G layout relies on
nents returned by sg_nents_for_len(sg, len).
However this leaves the possibility of HW S/G referencing more data
then needed: since buffer length in HW S/G entries is filled using
sg_dma_len(sg), the last entry in HW S/G table might have a length
that is bigger than needed for the crypto request.

This way of S/G table conversion is fine, unless after converting a table
more entries have to be appended to the HW S/G table.
In this case, crypto engine would access data from the S/G entry having
the incorrect length, instead of advancing in the S/G table.
This situation doesn't exist, but the upcoming implementation of
IV update for skcipher algorithms needs to add a S/G entry after
req->dst S/G (corresponding to output IV).

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg.c     | 35 +++++++++---------
 drivers/crypto/caam/caamalg_qi.c  | 36 +++++++++----------
 drivers/crypto/caam/caamalg_qi2.c | 60 +++++++++++++++----------------
 drivers/crypto/caam/caamhash.c    | 15 ++++----
 drivers/crypto/caam/caampkc.c     |  4 +--
 drivers/crypto/caam/sg_sw_qm.h    | 18 ++++++----
 drivers/crypto/caam/sg_sw_qm2.h   | 18 ++++++----
 drivers/crypto/caam/sg_sw_sec4.h  | 18 ++++++----
 8 files changed, 105 insertions(+), 99 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 4b03c967009b..95ef70bffd12 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1284,37 +1284,36 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		       GFP_KERNEL : GFP_ATOMIC;
 	int src_nents, mapped_src_nents, dst_nents = 0, mapped_dst_nents = 0;
+	int src_len, dst_len = 0;
 	struct aead_edesc *edesc;
 	int sec4_sg_index, sec4_sg_len, sec4_sg_bytes;
 	unsigned int authsize = ctx->authsize;
 
 	if (unlikely(req->dst != req->src)) {
-		src_nents = sg_nents_for_len(req->src, req->assoclen +
-					     req->cryptlen);
+		src_len = req->assoclen + req->cryptlen;
+		dst_len = src_len + (encrypt ? authsize : (-authsize));
+
+		src_nents = sg_nents_for_len(req->src, src_len);
 		if (unlikely(src_nents < 0)) {
 			dev_err(jrdev, "Insufficient bytes (%d) in src S/G\n",
-				req->assoclen + req->cryptlen);
+				src_len);
 			return ERR_PTR(src_nents);
 		}
 
-		dst_nents = sg_nents_for_len(req->dst, req->assoclen +
-					     req->cryptlen +
-						(encrypt ? authsize :
-							   (-authsize)));
+		dst_nents = sg_nents_for_len(req->dst, dst_len);
 		if (unlikely(dst_nents < 0)) {
 			dev_err(jrdev, "Insufficient bytes (%d) in dst S/G\n",
-				req->assoclen + req->cryptlen +
-				(encrypt ? authsize : (-authsize)));
+				dst_len);
 			return ERR_PTR(dst_nents);
 		}
 	} else {
-		src_nents = sg_nents_for_len(req->src, req->assoclen +
-					     req->cryptlen +
-					     (encrypt ? authsize : 0));
+		src_len = req->assoclen + req->cryptlen +
+			  (encrypt ? authsize : 0);
+
+		src_nents = sg_nents_for_len(req->src, src_len);
 		if (unlikely(src_nents < 0)) {
 			dev_err(jrdev, "Insufficient bytes (%d) in src S/G\n",
-				req->assoclen + req->cryptlen +
-				(encrypt ? authsize : 0));
+				src_len);
 			return ERR_PTR(src_nents);
 		}
 	}
@@ -1386,12 +1385,12 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 
 	sec4_sg_index = 0;
 	if (mapped_src_nents > 1) {
-		sg_to_sec4_sg_last(req->src, mapped_src_nents,
+		sg_to_sec4_sg_last(req->src, src_len,
 				   edesc->sec4_sg + sec4_sg_index, 0);
 		sec4_sg_index += mapped_src_nents;
 	}
 	if (mapped_dst_nents > 1) {
-		sg_to_sec4_sg_last(req->dst, mapped_dst_nents,
+		sg_to_sec4_sg_last(req->dst, dst_len,
 				   edesc->sec4_sg + sec4_sg_index, 0);
 	}
 
@@ -1756,11 +1755,11 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 		dma_to_sec4_sg_one(edesc->sec4_sg, iv_dma, ivsize, 0);
 	}
 	if (dst_sg_idx)
-		sg_to_sec4_sg_last(req->src, mapped_src_nents, edesc->sec4_sg +
+		sg_to_sec4_sg_last(req->src, req->cryptlen, edesc->sec4_sg +
 				   !!ivsize, 0);
 
 	if (mapped_dst_nents > 1) {
-		sg_to_sec4_sg_last(req->dst, mapped_dst_nents,
+		sg_to_sec4_sg_last(req->dst, req->cryptlen,
 				   edesc->sec4_sg + dst_sg_idx, 0);
 	}
 
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 490a2bbdbb93..cec54344787c 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -917,6 +917,7 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		       GFP_KERNEL : GFP_ATOMIC;
 	int src_nents, mapped_src_nents, dst_nents = 0, mapped_dst_nents = 0;
+	int src_len, dst_len = 0;
 	struct aead_edesc *edesc;
 	dma_addr_t qm_sg_dma, iv_dma = 0;
 	int ivsize = 0;
@@ -938,13 +939,13 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	}
 
 	if (likely(req->src == req->dst)) {
-		src_nents = sg_nents_for_len(req->src, req->assoclen +
-					     req->cryptlen +
-						(encrypt ? authsize : 0));
+		src_len = req->assoclen + req->cryptlen +
+			  (encrypt ? authsize : 0);
+
+		src_nents = sg_nents_for_len(req->src, src_len);
 		if (unlikely(src_nents < 0)) {
 			dev_err(qidev, "Insufficient bytes (%d) in src S/G\n",
-				req->assoclen + req->cryptlen +
-				(encrypt ? authsize : 0));
+				src_len);
 			qi_cache_free(edesc);
 			return ERR_PTR(src_nents);
 		}
@@ -957,23 +958,21 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 			return ERR_PTR(-ENOMEM);
 		}
 	} else {
-		src_nents = sg_nents_for_len(req->src, req->assoclen +
-					     req->cryptlen);
+		src_len = req->assoclen + req->cryptlen;
+		dst_len = src_len + (encrypt ? authsize : (-authsize));
+
+		src_nents = sg_nents_for_len(req->src, src_len);
 		if (unlikely(src_nents < 0)) {
 			dev_err(qidev, "Insufficient bytes (%d) in src S/G\n",
-				req->assoclen + req->cryptlen);
+				src_len);
 			qi_cache_free(edesc);
 			return ERR_PTR(src_nents);
 		}
 
-		dst_nents = sg_nents_for_len(req->dst, req->assoclen +
-					     req->cryptlen +
-					     (encrypt ? authsize :
-							(-authsize)));
+		dst_nents = sg_nents_for_len(req->dst, dst_len);
 		if (unlikely(dst_nents < 0)) {
 			dev_err(qidev, "Insufficient bytes (%d) in dst S/G\n",
-				req->assoclen + req->cryptlen +
-				(encrypt ? authsize : (-authsize)));
+				dst_len);
 			qi_cache_free(edesc);
 			return ERR_PTR(dst_nents);
 		}
@@ -1082,12 +1081,11 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 		dma_to_qm_sg_one(sg_table + qm_sg_index, iv_dma, ivsize, 0);
 		qm_sg_index++;
 	}
-	sg_to_qm_sg_last(req->src, mapped_src_nents, sg_table + qm_sg_index, 0);
+	sg_to_qm_sg_last(req->src, src_len, sg_table + qm_sg_index, 0);
 	qm_sg_index += mapped_src_nents;
 
 	if (mapped_dst_nents > 1)
-		sg_to_qm_sg_last(req->dst, mapped_dst_nents, sg_table +
-				 qm_sg_index, 0);
+		sg_to_qm_sg_last(req->dst, dst_len, sg_table + qm_sg_index, 0);
 
 	qm_sg_dma = dma_map_single(qidev, sg_table, qm_sg_bytes, DMA_TO_DEVICE);
 	if (dma_mapping_error(qidev, qm_sg_dma)) {
@@ -1340,10 +1338,10 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 	edesc->drv_req.drv_ctx = drv_ctx;
 
 	dma_to_qm_sg_one(sg_table, iv_dma, ivsize, 0);
-	sg_to_qm_sg_last(req->src, mapped_src_nents, sg_table + 1, 0);
+	sg_to_qm_sg_last(req->src, req->cryptlen, sg_table + 1, 0);
 
 	if (mapped_dst_nents > 1)
-		sg_to_qm_sg_last(req->dst, mapped_dst_nents, sg_table +
+		sg_to_qm_sg_last(req->dst, req->cryptlen, sg_table +
 				 dst_sg_idx, 0);
 
 	edesc->qm_sg_dma = dma_map_single(qidev, sg_table, edesc->qm_sg_bytes,
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 2621d657048a..1652fa26cf96 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -371,6 +371,7 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		      GFP_KERNEL : GFP_ATOMIC;
 	int src_nents, mapped_src_nents, dst_nents = 0, mapped_dst_nents = 0;
+	int src_len, dst_len = 0;
 	struct aead_edesc *edesc;
 	dma_addr_t qm_sg_dma, iv_dma = 0;
 	int ivsize = 0;
@@ -387,23 +388,21 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	}
 
 	if (unlikely(req->dst != req->src)) {
-		src_nents = sg_nents_for_len(req->src, req->assoclen +
-					     req->cryptlen);
+		src_len = req->assoclen + req->cryptlen;
+		dst_len = src_len + (encrypt ? authsize : (-authsize));
+
+		src_nents = sg_nents_for_len(req->src, src_len);
 		if (unlikely(src_nents < 0)) {
 			dev_err(dev, "Insufficient bytes (%d) in src S/G\n",
-				req->assoclen + req->cryptlen);
+				src_len);
 			qi_cache_free(edesc);
 			return ERR_PTR(src_nents);
 		}
 
-		dst_nents = sg_nents_for_len(req->dst, req->assoclen +
-					     req->cryptlen +
-					     (encrypt ? authsize :
-							(-authsize)));
+		dst_nents = sg_nents_for_len(req->dst, dst_len);
 		if (unlikely(dst_nents < 0)) {
 			dev_err(dev, "Insufficient bytes (%d) in dst S/G\n",
-				req->assoclen + req->cryptlen +
-				(encrypt ? authsize : (-authsize)));
+				dst_len);
 			qi_cache_free(edesc);
 			return ERR_PTR(dst_nents);
 		}
@@ -434,13 +433,13 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 			mapped_dst_nents = 0;
 		}
 	} else {
-		src_nents = sg_nents_for_len(req->src, req->assoclen +
-					     req->cryptlen +
-						(encrypt ? authsize : 0));
+		src_len = req->assoclen + req->cryptlen +
+			  (encrypt ? authsize : 0);
+
+		src_nents = sg_nents_for_len(req->src, src_len);
 		if (unlikely(src_nents < 0)) {
 			dev_err(dev, "Insufficient bytes (%d) in src S/G\n",
-				req->assoclen + req->cryptlen +
-				(encrypt ? authsize : 0));
+				src_len);
 			qi_cache_free(edesc);
 			return ERR_PTR(src_nents);
 		}
@@ -536,12 +535,11 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 		dma_to_qm_sg_one(sg_table + qm_sg_index, iv_dma, ivsize, 0);
 		qm_sg_index++;
 	}
-	sg_to_qm_sg_last(req->src, mapped_src_nents, sg_table + qm_sg_index, 0);
+	sg_to_qm_sg_last(req->src, src_len, sg_table + qm_sg_index, 0);
 	qm_sg_index += mapped_src_nents;
 
 	if (mapped_dst_nents > 1)
-		sg_to_qm_sg_last(req->dst, mapped_dst_nents, sg_table +
-				 qm_sg_index, 0);
+		sg_to_qm_sg_last(req->dst, dst_len, sg_table + qm_sg_index, 0);
 
 	qm_sg_dma = dma_map_single(dev, sg_table, qm_sg_bytes, DMA_TO_DEVICE);
 	if (dma_mapping_error(dev, qm_sg_dma)) {
@@ -1159,10 +1157,10 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req)
 	edesc->qm_sg_bytes = qm_sg_bytes;
 
 	dma_to_qm_sg_one(sg_table, iv_dma, ivsize, 0);
-	sg_to_qm_sg_last(req->src, mapped_src_nents, sg_table + 1, 0);
+	sg_to_qm_sg_last(req->src, req->cryptlen, sg_table + 1, 0);
 
 	if (mapped_dst_nents > 1)
-		sg_to_qm_sg_last(req->dst, mapped_dst_nents, sg_table +
+		sg_to_qm_sg_last(req->dst, req->cryptlen, sg_table +
 				 dst_sg_idx, 0);
 
 	edesc->qm_sg_dma = dma_map_single(dev, sg_table, edesc->qm_sg_bytes,
@@ -3422,9 +3420,9 @@ static int ahash_update_ctx(struct ahash_request *req)
 
 	if (to_hash) {
 		struct dpaa2_sg_entry *sg_table;
+		int src_len = req->nbytes - *next_buflen;
 
-		src_nents = sg_nents_for_len(req->src,
-					     req->nbytes - (*next_buflen));
+		src_nents = sg_nents_for_len(req->src, src_len);
 		if (src_nents < 0) {
 			dev_err(ctx->dev, "Invalid number of src SG.\n");
 			return src_nents;
@@ -3465,7 +3463,7 @@ static int ahash_update_ctx(struct ahash_request *req)
 			goto unmap_ctx;
 
 		if (mapped_nents) {
-			sg_to_qm_sg_last(req->src, mapped_nents,
+			sg_to_qm_sg_last(req->src, src_len,
 					 sg_table + qm_sg_src_index, 0);
 			if (*next_buflen)
 				scatterwalk_map_and_copy(next_buf, req->src,
@@ -3653,7 +3651,7 @@ static int ahash_finup_ctx(struct ahash_request *req)
 	if (ret)
 		goto unmap_ctx;
 
-	sg_to_qm_sg_last(req->src, mapped_nents, sg_table + qm_sg_src_index, 0);
+	sg_to_qm_sg_last(req->src, req->nbytes, sg_table + qm_sg_src_index, 0);
 
 	edesc->qm_sg_dma = dma_map_single(ctx->dev, sg_table, qm_sg_bytes,
 					  DMA_TO_DEVICE);
@@ -3739,7 +3737,7 @@ static int ahash_digest(struct ahash_request *req)
 		struct dpaa2_sg_entry *sg_table = &edesc->sgt[0];
 
 		qm_sg_bytes = pad_sg_nents(mapped_nents) * sizeof(*sg_table);
-		sg_to_qm_sg_last(req->src, mapped_nents, sg_table, 0);
+		sg_to_qm_sg_last(req->src, req->nbytes, sg_table, 0);
 		edesc->qm_sg_dma = dma_map_single(ctx->dev, sg_table,
 						  qm_sg_bytes, DMA_TO_DEVICE);
 		if (dma_mapping_error(ctx->dev, edesc->qm_sg_dma)) {
@@ -3882,9 +3880,9 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 
 	if (to_hash) {
 		struct dpaa2_sg_entry *sg_table;
+		int src_len = req->nbytes - *next_buflen;
 
-		src_nents = sg_nents_for_len(req->src,
-					     req->nbytes - *next_buflen);
+		src_nents = sg_nents_for_len(req->src, src_len);
 		if (src_nents < 0) {
 			dev_err(ctx->dev, "Invalid number of src SG.\n");
 			return src_nents;
@@ -3918,7 +3916,7 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 		if (ret)
 			goto unmap_ctx;
 
-		sg_to_qm_sg_last(req->src, mapped_nents, sg_table + 1, 0);
+		sg_to_qm_sg_last(req->src, src_len, sg_table + 1, 0);
 
 		if (*next_buflen)
 			scatterwalk_map_and_copy(next_buf, req->src,
@@ -4037,7 +4035,7 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 	if (ret)
 		goto unmap;
 
-	sg_to_qm_sg_last(req->src, mapped_nents, sg_table + 1, 0);
+	sg_to_qm_sg_last(req->src, req->nbytes, sg_table + 1, 0);
 
 	edesc->qm_sg_dma = dma_map_single(ctx->dev, sg_table, qm_sg_bytes,
 					  DMA_TO_DEVICE);
@@ -4107,9 +4105,9 @@ static int ahash_update_first(struct ahash_request *req)
 
 	if (to_hash) {
 		struct dpaa2_sg_entry *sg_table;
+		int src_len = req->nbytes - *next_buflen;
 
-		src_nents = sg_nents_for_len(req->src,
-					     req->nbytes - (*next_buflen));
+		src_nents = sg_nents_for_len(req->src, src_len);
 		if (src_nents < 0) {
 			dev_err(ctx->dev, "Invalid number of src SG.\n");
 			return src_nents;
@@ -4144,7 +4142,7 @@ static int ahash_update_first(struct ahash_request *req)
 		if (mapped_nents > 1) {
 			int qm_sg_bytes;
 
-			sg_to_qm_sg_last(req->src, mapped_nents, sg_table, 0);
+			sg_to_qm_sg_last(req->src, src_len, sg_table, 0);
 			qm_sg_bytes = pad_sg_nents(mapped_nents) *
 				      sizeof(*sg_table);
 			edesc->qm_sg_dma = dma_map_single(ctx->dev, sg_table,
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index a87526f62737..e4ac5d591ad6 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -729,7 +729,7 @@ static int ahash_edesc_add_src(struct caam_hash_ctx *ctx,
 		unsigned int sgsize = sizeof(*sg) *
 				      pad_sg_nents(first_sg + nents);
 
-		sg_to_sec4_sg_last(req->src, nents, sg + first_sg, 0);
+		sg_to_sec4_sg_last(req->src, to_hash, sg + first_sg, 0);
 
 		src_dma = dma_map_single(ctx->jrdev, sg, sgsize, DMA_TO_DEVICE);
 		if (dma_mapping_error(ctx->jrdev, src_dma)) {
@@ -788,9 +788,9 @@ static int ahash_update_ctx(struct ahash_request *req)
 
 	if (to_hash) {
 		int pad_nents;
+		int src_len = req->nbytes - *next_buflen;
 
-		src_nents = sg_nents_for_len(req->src,
-					     req->nbytes - (*next_buflen));
+		src_nents = sg_nents_for_len(req->src, src_len);
 		if (src_nents < 0) {
 			dev_err(jrdev, "Invalid number of src SG.\n");
 			return src_nents;
@@ -835,7 +835,7 @@ static int ahash_update_ctx(struct ahash_request *req)
 			goto unmap_ctx;
 
 		if (mapped_nents)
-			sg_to_sec4_sg_last(req->src, mapped_nents,
+			sg_to_sec4_sg_last(req->src, src_len,
 					   edesc->sec4_sg + sec4_sg_src_index,
 					   0);
 		else
@@ -1208,9 +1208,9 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 
 	if (to_hash) {
 		int pad_nents;
+		int src_len = req->nbytes - *next_buflen;
 
-		src_nents = sg_nents_for_len(req->src,
-					     req->nbytes - *next_buflen);
+		src_nents = sg_nents_for_len(req->src, src_len);
 		if (src_nents < 0) {
 			dev_err(jrdev, "Invalid number of src SG.\n");
 			return src_nents;
@@ -1250,8 +1250,7 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 		if (ret)
 			goto unmap_ctx;
 
-		sg_to_sec4_sg_last(req->src, mapped_nents,
-				   edesc->sec4_sg + 1, 0);
+		sg_to_sec4_sg_last(req->src, src_len, edesc->sec4_sg + 1, 0);
 
 		if (*next_buflen) {
 			scatterwalk_map_and_copy(next_buf, req->src,
diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index 19b02c1973fc..80574106af29 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -306,11 +306,11 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
 				   0);
 
 	if (sec4_sg_index)
-		sg_to_sec4_sg_last(req_ctx->fixup_src, src_nents,
+		sg_to_sec4_sg_last(req_ctx->fixup_src, req_ctx->fixup_src_len,
 				   edesc->sec4_sg + !!diff_size, 0);
 
 	if (dst_nents > 1)
-		sg_to_sec4_sg_last(req->dst, dst_nents,
+		sg_to_sec4_sg_last(req->dst, req->dst_len,
 				   edesc->sec4_sg + sec4_sg_index, 0);
 
 	/* Save nents for later use in Job Descriptor */
diff --git a/drivers/crypto/caam/sg_sw_qm.h b/drivers/crypto/caam/sg_sw_qm.h
index b3e1aaaeffea..d56cc7efbc13 100644
--- a/drivers/crypto/caam/sg_sw_qm.h
+++ b/drivers/crypto/caam/sg_sw_qm.h
@@ -54,15 +54,19 @@ static inline void dma_to_qm_sg_one_last_ext(struct qm_sg_entry *qm_sg_ptr,
  * but does not have final bit; instead, returns last entry
  */
 static inline struct qm_sg_entry *
-sg_to_qm_sg(struct scatterlist *sg, int sg_count,
+sg_to_qm_sg(struct scatterlist *sg, int len,
 	    struct qm_sg_entry *qm_sg_ptr, u16 offset)
 {
-	while (sg_count && sg) {
-		dma_to_qm_sg_one(qm_sg_ptr, sg_dma_address(sg),
-				 sg_dma_len(sg), offset);
+	int ent_len;
+
+	while (len) {
+		ent_len = min_t(int, sg_dma_len(sg), len);
+
+		dma_to_qm_sg_one(qm_sg_ptr, sg_dma_address(sg), ent_len,
+				 offset);
 		qm_sg_ptr++;
 		sg = sg_next(sg);
-		sg_count--;
+		len -= ent_len;
 	}
 	return qm_sg_ptr - 1;
 }
@@ -71,10 +75,10 @@ sg_to_qm_sg(struct scatterlist *sg, int sg_count,
  * convert scatterlist to h/w link table format
  * scatterlist must have been previously dma mapped
  */
-static inline void sg_to_qm_sg_last(struct scatterlist *sg, int sg_count,
+static inline void sg_to_qm_sg_last(struct scatterlist *sg, int len,
 				    struct qm_sg_entry *qm_sg_ptr, u16 offset)
 {
-	qm_sg_ptr = sg_to_qm_sg(sg, sg_count, qm_sg_ptr, offset);
+	qm_sg_ptr = sg_to_qm_sg(sg, len, qm_sg_ptr, offset);
 	qm_sg_entry_set_f(qm_sg_ptr, qm_sg_entry_get_len(qm_sg_ptr));
 }
 
diff --git a/drivers/crypto/caam/sg_sw_qm2.h b/drivers/crypto/caam/sg_sw_qm2.h
index c9378402a5f8..b8b737d2b0ea 100644
--- a/drivers/crypto/caam/sg_sw_qm2.h
+++ b/drivers/crypto/caam/sg_sw_qm2.h
@@ -25,15 +25,19 @@ static inline void dma_to_qm_sg_one(struct dpaa2_sg_entry *qm_sg_ptr,
  * but does not have final bit; instead, returns last entry
  */
 static inline struct dpaa2_sg_entry *
-sg_to_qm_sg(struct scatterlist *sg, int sg_count,
+sg_to_qm_sg(struct scatterlist *sg, int len,
 	    struct dpaa2_sg_entry *qm_sg_ptr, u16 offset)
 {
-	while (sg_count && sg) {
-		dma_to_qm_sg_one(qm_sg_ptr, sg_dma_address(sg),
-				 sg_dma_len(sg), offset);
+	int ent_len;
+
+	while (len) {
+		ent_len = min_t(int, sg_dma_len(sg), len);
+
+		dma_to_qm_sg_one(qm_sg_ptr, sg_dma_address(sg), ent_len,
+				 offset);
 		qm_sg_ptr++;
 		sg = sg_next(sg);
-		sg_count--;
+		len -= ent_len;
 	}
 	return qm_sg_ptr - 1;
 }
@@ -42,11 +46,11 @@ sg_to_qm_sg(struct scatterlist *sg, int sg_count,
  * convert scatterlist to h/w link table format
  * scatterlist must have been previously dma mapped
  */
-static inline void sg_to_qm_sg_last(struct scatterlist *sg, int sg_count,
+static inline void sg_to_qm_sg_last(struct scatterlist *sg, int len,
 				    struct dpaa2_sg_entry *qm_sg_ptr,
 				    u16 offset)
 {
-	qm_sg_ptr = sg_to_qm_sg(sg, sg_count, qm_sg_ptr, offset);
+	qm_sg_ptr = sg_to_qm_sg(sg, len, qm_sg_ptr, offset);
 	dpaa2_sg_set_final(qm_sg_ptr, true);
 }
 
diff --git a/drivers/crypto/caam/sg_sw_sec4.h b/drivers/crypto/caam/sg_sw_sec4.h
index 8f9555d01011..07e1ee99273b 100644
--- a/drivers/crypto/caam/sg_sw_sec4.h
+++ b/drivers/crypto/caam/sg_sw_sec4.h
@@ -45,15 +45,19 @@ static inline void dma_to_sec4_sg_one(struct sec4_sg_entry *sec4_sg_ptr,
  * but does not have final bit; instead, returns last entry
  */
 static inline struct sec4_sg_entry *
-sg_to_sec4_sg(struct scatterlist *sg, int sg_count,
+sg_to_sec4_sg(struct scatterlist *sg, int len,
 	      struct sec4_sg_entry *sec4_sg_ptr, u16 offset)
 {
-	while (sg_count) {
-		dma_to_sec4_sg_one(sec4_sg_ptr, sg_dma_address(sg),
-				   sg_dma_len(sg), offset);
+	int ent_len;
+
+	while (len) {
+		ent_len = min_t(int, sg_dma_len(sg), len);
+
+		dma_to_sec4_sg_one(sec4_sg_ptr, sg_dma_address(sg), ent_len,
+				   offset);
 		sec4_sg_ptr++;
 		sg = sg_next(sg);
-		sg_count--;
+		len -= ent_len;
 	}
 	return sec4_sg_ptr - 1;
 }
@@ -70,11 +74,11 @@ static inline void sg_to_sec4_set_last(struct sec4_sg_entry *sec4_sg_ptr)
  * convert scatterlist to h/w link table format
  * scatterlist must have been previously dma mapped
  */
-static inline void sg_to_sec4_sg_last(struct scatterlist *sg, int sg_count,
+static inline void sg_to_sec4_sg_last(struct scatterlist *sg, int len,
 				      struct sec4_sg_entry *sec4_sg_ptr,
 				      u16 offset)
 {
-	sec4_sg_ptr = sg_to_sec4_sg(sg, sg_count, sec4_sg_ptr, offset);
+	sec4_sg_ptr = sg_to_sec4_sg(sg, len, sec4_sg_ptr, offset);
 	sg_to_sec4_set_last(sec4_sg_ptr);
 }
 
-- 
2.17.1

