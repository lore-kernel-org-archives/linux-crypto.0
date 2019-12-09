Return-Path: <SRS0=S8oY=Z7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09B1DC43603
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Dec 2019 17:00:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C52F42077B
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Dec 2019 17:00:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbfLIRAJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Dec 2019 12:00:09 -0500
Received: from inva020.nxp.com ([92.121.34.13]:57174 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbfLIRAJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Dec 2019 12:00:09 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 280801A1A93;
        Mon,  9 Dec 2019 18:00:06 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 1B11C1A16F6;
        Mon,  9 Dec 2019 18:00:06 +0100 (CET)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id D1CAB20564;
        Mon,  9 Dec 2019 18:00:05 +0100 (CET)
From:   Andrei Botila <andrei.botila@nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] crypto: caam - remove double buffering for ahash
Date:   Mon,  9 Dec 2019 18:59:55 +0200
Message-Id: <1575910796-13897-1-git-send-email-andrei.botila@nxp.com>
X-Mailer: git-send-email 2.1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Previously double buffering was used for storing previous and next
"less-than-block-size" bytes. Double buffering can be removed by moving
the copy of next "less-than-block-size" bytes after current request is
executed by HW.

Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
---
 drivers/crypto/caam/caamhash.c | 158 ++++++++++++---------------------
 1 file changed, 58 insertions(+), 100 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 65399cb2a770..50a8852ad276 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -107,15 +107,13 @@ struct caam_hash_state {
 	dma_addr_t buf_dma;
 	dma_addr_t ctx_dma;
 	int ctx_dma_len;
-	u8 buf_0[CAAM_MAX_HASH_BLOCK_SIZE] ____cacheline_aligned;
-	int buflen_0;
-	u8 buf_1[CAAM_MAX_HASH_BLOCK_SIZE] ____cacheline_aligned;
-	int buflen_1;
+	u8 buf[CAAM_MAX_HASH_BLOCK_SIZE] ____cacheline_aligned;
+	int buflen;
+	int next_buflen;
 	u8 caam_ctx[MAX_CTX_LEN] ____cacheline_aligned;
 	int (*update)(struct ahash_request *req);
 	int (*final)(struct ahash_request *req);
 	int (*finup)(struct ahash_request *req);
-	int current_buf;
 };
 
 struct caam_export_state {
@@ -127,31 +125,6 @@ struct caam_export_state {
 	int (*finup)(struct ahash_request *req);
 };
 
-static inline void switch_buf(struct caam_hash_state *state)
-{
-	state->current_buf ^= 1;
-}
-
-static inline u8 *current_buf(struct caam_hash_state *state)
-{
-	return state->current_buf ? state->buf_1 : state->buf_0;
-}
-
-static inline u8 *alt_buf(struct caam_hash_state *state)
-{
-	return state->current_buf ? state->buf_0 : state->buf_1;
-}
-
-static inline int *current_buflen(struct caam_hash_state *state)
-{
-	return state->current_buf ? &state->buflen_1 : &state->buflen_0;
-}
-
-static inline int *alt_buflen(struct caam_hash_state *state)
-{
-	return state->current_buf ? &state->buflen_0 : &state->buflen_1;
-}
-
 static inline bool is_cmac_aes(u32 algtype)
 {
 	return (algtype & (OP_ALG_ALGSEL_MASK | OP_ALG_AAI_MASK)) ==
@@ -183,12 +156,12 @@ static inline int buf_map_to_sec4_sg(struct device *jrdev,
 				     struct sec4_sg_entry *sec4_sg,
 				     struct caam_hash_state *state)
 {
-	int buflen = *current_buflen(state);
+	int buflen = state->buflen;
 
 	if (!buflen)
 		return 0;
 
-	state->buf_dma = dma_map_single(jrdev, current_buf(state), buflen,
+	state->buf_dma = dma_map_single(jrdev, state->buf, buflen,
 					DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, state->buf_dma)) {
 		dev_err(jrdev, "unable to map buf\n");
@@ -578,7 +551,7 @@ static inline void ahash_unmap(struct device *dev,
 				 edesc->sec4_sg_bytes, DMA_TO_DEVICE);
 
 	if (state->buf_dma) {
-		dma_unmap_single(dev, state->buf_dma, *current_buflen(state),
+		dma_unmap_single(dev, state->buf_dma, state->buflen,
 				 DMA_TO_DEVICE);
 		state->buf_dma = 0;
 	}
@@ -643,9 +616,17 @@ static void ahash_done_bi(struct device *jrdev, u32 *desc, u32 err,
 		ecode = caam_jr_strstatus(jrdev, err);
 
 	ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len, DMA_BIDIRECTIONAL);
-	switch_buf(state);
 	kfree(edesc);
 
+	scatterwalk_map_and_copy(state->buf, req->src,
+				 req->nbytes - state->next_buflen,
+				 state->next_buflen, 0);
+	state->buflen = state->next_buflen;
+
+	print_hex_dump_debug("buf@" __stringify(__LINE__)": ",
+			     DUMP_PREFIX_ADDRESS, 16, 4, state->buf,
+			     state->buflen, 1);
+
 	print_hex_dump_debug("ctx@"__stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, state->caam_ctx,
 			     ctx->ctx_len, 1);
@@ -703,9 +684,17 @@ static void ahash_done_ctx_dst(struct device *jrdev, u32 *desc, u32 err,
 		ecode = caam_jr_strstatus(jrdev, err);
 
 	ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len, DMA_FROM_DEVICE);
-	switch_buf(state);
 	kfree(edesc);
 
+	scatterwalk_map_and_copy(state->buf, req->src,
+				 req->nbytes - state->next_buflen,
+				 state->next_buflen, 0);
+	state->buflen = state->next_buflen;
+
+	print_hex_dump_debug("buf@" __stringify(__LINE__)": ",
+			     DUMP_PREFIX_ADDRESS, 16, 4, state->buf,
+			     state->buflen, 1);
+
 	print_hex_dump_debug("ctx@"__stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, state->caam_ctx,
 			     ctx->ctx_len, 1);
@@ -786,18 +775,16 @@ static int ahash_update_ctx(struct ahash_request *req)
 	struct device *jrdev = ctx->jrdev;
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		       GFP_KERNEL : GFP_ATOMIC;
-	u8 *buf = current_buf(state);
-	int *buflen = current_buflen(state);
-	u8 *next_buf = alt_buf(state);
+	u8 *buf = state->buf;
+	int *buflen = &state->buflen;
+	int *next_buflen = &state->next_buflen;
 	int blocksize = crypto_ahash_blocksize(ahash);
-	int *next_buflen = alt_buflen(state), last_buflen;
 	int in_len = *buflen + req->nbytes, to_hash;
 	u32 *desc;
 	int src_nents, mapped_nents, sec4_sg_bytes, sec4_sg_src_index;
 	struct ahash_edesc *edesc;
 	int ret = 0;
 
-	last_buflen = *next_buflen;
 	*next_buflen = in_len & (blocksize - 1);
 	to_hash = in_len - *next_buflen;
 
@@ -868,10 +855,6 @@ static int ahash_update_ctx(struct ahash_request *req)
 			sg_to_sec4_set_last(edesc->sec4_sg + sec4_sg_src_index -
 					    1);
 
-		if (*next_buflen)
-			scatterwalk_map_and_copy(next_buf, req->src,
-						 to_hash - *buflen,
-						 *next_buflen, 0);
 		desc = edesc->hw_desc;
 
 		edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
@@ -901,14 +884,11 @@ static int ahash_update_ctx(struct ahash_request *req)
 		scatterwalk_map_and_copy(buf + *buflen, req->src, 0,
 					 req->nbytes, 0);
 		*buflen = *next_buflen;
-		*next_buflen = last_buflen;
-	}
 
-	print_hex_dump_debug("buf@"__stringify(__LINE__)": ",
-			     DUMP_PREFIX_ADDRESS, 16, 4, buf, *buflen, 1);
-	print_hex_dump_debug("next buf@"__stringify(__LINE__)": ",
-			     DUMP_PREFIX_ADDRESS, 16, 4, next_buf,
-			     *next_buflen, 1);
+		print_hex_dump_debug("buf@" __stringify(__LINE__)": ",
+				     DUMP_PREFIX_ADDRESS, 16, 4, buf,
+				     *buflen, 1);
+	}
 
 	return ret;
 unmap_ctx:
@@ -925,7 +905,7 @@ static int ahash_final_ctx(struct ahash_request *req)
 	struct device *jrdev = ctx->jrdev;
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		       GFP_KERNEL : GFP_ATOMIC;
-	int buflen = *current_buflen(state);
+	int buflen = state->buflen;
 	u32 *desc;
 	int sec4_sg_bytes;
 	int digestsize = crypto_ahash_digestsize(ahash);
@@ -991,7 +971,7 @@ static int ahash_finup_ctx(struct ahash_request *req)
 	struct device *jrdev = ctx->jrdev;
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		       GFP_KERNEL : GFP_ATOMIC;
-	int buflen = *current_buflen(state);
+	int buflen = state->buflen;
 	u32 *desc;
 	int sec4_sg_src_index;
 	int src_nents, mapped_nents;
@@ -1148,8 +1128,8 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 	struct device *jrdev = ctx->jrdev;
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		       GFP_KERNEL : GFP_ATOMIC;
-	u8 *buf = current_buf(state);
-	int buflen = *current_buflen(state);
+	u8 *buf = state->buf;
+	int buflen = state->buflen;
 	u32 *desc;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
@@ -1207,11 +1187,10 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 	struct device *jrdev = ctx->jrdev;
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		       GFP_KERNEL : GFP_ATOMIC;
-	u8 *buf = current_buf(state);
-	int *buflen = current_buflen(state);
+	u8 *buf = state->buf;
+	int *buflen = &state->buflen;
+	int *next_buflen = &state->next_buflen;
 	int blocksize = crypto_ahash_blocksize(ahash);
-	u8 *next_buf = alt_buf(state);
-	int *next_buflen = alt_buflen(state);
 	int in_len = *buflen + req->nbytes, to_hash;
 	int sec4_sg_bytes, src_nents, mapped_nents;
 	struct ahash_edesc *edesc;
@@ -1278,12 +1257,6 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 
 		sg_to_sec4_sg_last(req->src, src_len, edesc->sec4_sg + 1, 0);
 
-		if (*next_buflen) {
-			scatterwalk_map_and_copy(next_buf, req->src,
-						 to_hash - *buflen,
-						 *next_buflen, 0);
-		}
-
 		desc = edesc->hw_desc;
 
 		edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
@@ -1317,14 +1290,11 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 		scatterwalk_map_and_copy(buf + *buflen, req->src, 0,
 					 req->nbytes, 0);
 		*buflen = *next_buflen;
-		*next_buflen = 0;
-	}
 
-	print_hex_dump_debug("buf@"__stringify(__LINE__)": ",
-			     DUMP_PREFIX_ADDRESS, 16, 4, buf, *buflen, 1);
-	print_hex_dump_debug("next buf@"__stringify(__LINE__)": ",
-			     DUMP_PREFIX_ADDRESS, 16, 4, next_buf, *next_buflen,
-			     1);
+		print_hex_dump_debug("buf@" __stringify(__LINE__)": ",
+				     DUMP_PREFIX_ADDRESS, 16, 4, buf,
+				     *buflen, 1);
+	}
 
 	return ret;
  unmap_ctx:
@@ -1342,7 +1312,7 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 	struct device *jrdev = ctx->jrdev;
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		       GFP_KERNEL : GFP_ATOMIC;
-	int buflen = *current_buflen(state);
+	int buflen = state->buflen;
 	u32 *desc;
 	int sec4_sg_bytes, sec4_sg_src_index, src_nents, mapped_nents;
 	int digestsize = crypto_ahash_digestsize(ahash);
@@ -1428,8 +1398,9 @@ static int ahash_update_first(struct ahash_request *req)
 	struct device *jrdev = ctx->jrdev;
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		       GFP_KERNEL : GFP_ATOMIC;
-	u8 *next_buf = alt_buf(state);
-	int *next_buflen = alt_buflen(state);
+	u8 *buf = state->buf;
+	int *buflen = &state->buflen;
+	int *next_buflen = &state->next_buflen;
 	int to_hash;
 	int blocksize = crypto_ahash_blocksize(ahash);
 	u32 *desc;
@@ -1491,10 +1462,6 @@ static int ahash_update_first(struct ahash_request *req)
 		if (ret)
 			goto unmap_ctx;
 
-		if (*next_buflen)
-			scatterwalk_map_and_copy(next_buf, req->src, to_hash,
-						 *next_buflen, 0);
-
 		desc = edesc->hw_desc;
 
 		ret = map_seq_out_ptr_ctx(desc, jrdev, state, ctx->ctx_len);
@@ -1517,14 +1484,14 @@ static int ahash_update_first(struct ahash_request *req)
 		state->update = ahash_update_no_ctx;
 		state->finup = ahash_finup_no_ctx;
 		state->final = ahash_final_no_ctx;
-		scatterwalk_map_and_copy(next_buf, req->src, 0,
+		scatterwalk_map_and_copy(buf, req->src, 0,
 					 req->nbytes, 0);
-		switch_buf(state);
-	}
+		*buflen = *next_buflen;
 
-	print_hex_dump_debug("next buf@"__stringify(__LINE__)": ",
-			     DUMP_PREFIX_ADDRESS, 16, 4, next_buf, *next_buflen,
-			     1);
+		print_hex_dump_debug("buf@" __stringify(__LINE__)": ",
+				     DUMP_PREFIX_ADDRESS, 16, 4, buf,
+				     *buflen, 1);
+	}
 
 	return ret;
  unmap_ctx:
@@ -1548,10 +1515,9 @@ static int ahash_init(struct ahash_request *req)
 
 	state->ctx_dma = 0;
 	state->ctx_dma_len = 0;
-	state->current_buf = 0;
 	state->buf_dma = 0;
-	state->buflen_0 = 0;
-	state->buflen_1 = 0;
+	state->buflen = 0;
+	state->next_buflen = 0;
 
 	return 0;
 }
@@ -1581,16 +1547,8 @@ static int ahash_export(struct ahash_request *req, void *out)
 {
 	struct caam_hash_state *state = ahash_request_ctx(req);
 	struct caam_export_state *export = out;
-	int len;
-	u8 *buf;
-
-	if (state->current_buf) {
-		buf = state->buf_1;
-		len = state->buflen_1;
-	} else {
-		buf = state->buf_0;
-		len = state->buflen_0;
-	}
+	u8 *buf = state->buf;
+	int len = state->buflen;
 
 	memcpy(export->buf, buf, len);
 	memcpy(export->caam_ctx, state->caam_ctx, sizeof(export->caam_ctx));
@@ -1608,9 +1566,9 @@ static int ahash_import(struct ahash_request *req, const void *in)
 	const struct caam_export_state *export = in;
 
 	memset(state, 0, sizeof(*state));
-	memcpy(state->buf_0, export->buf, export->buflen);
+	memcpy(state->buf, export->buf, export->buflen);
 	memcpy(state->caam_ctx, export->caam_ctx, sizeof(state->caam_ctx));
-	state->buflen_0 = export->buflen;
+	state->buflen = export->buflen;
 	state->update = export->update;
 	state->final = export->final;
 	state->finup = export->finup;
-- 
2.17.1

