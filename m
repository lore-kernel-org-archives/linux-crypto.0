Return-Path: <SRS0=TGTC=ZJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C69DC432C0
	for <linux-crypto@archiver.kernel.org>; Sun, 17 Nov 2019 22:31:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1402F20727
	for <linux-crypto@archiver.kernel.org>; Sun, 17 Nov 2019 22:31:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbfKQWbX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 17 Nov 2019 17:31:23 -0500
Received: from inva020.nxp.com ([92.121.34.13]:56950 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbfKQWbL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 17 Nov 2019 17:31:11 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id CA69B1A0014;
        Sun, 17 Nov 2019 23:31:07 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id BCA1D1A0D0A;
        Sun, 17 Nov 2019 23:31:07 +0100 (CET)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 5DBA720395;
        Sun, 17 Nov 2019 23:31:07 +0100 (CET)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: [PATCH 12/12] crypto: caam - add crypto_engine support for HASH algorithms
Date:   Mon, 18 Nov 2019 00:30:45 +0200
Message-Id: <1574029845-22796-13-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
References: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add crypto_engine support for HASH algorithms, to make use of
the engine queue.
The requests, with backlog flag, will be listed into crypto-engine
queue and processed by CAAM when free. In case the queue is empty,
the request is directly sent to CAAM.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 drivers/crypto/caam/caamhash.c | 155 +++++++++++++++++++++++++++++------------
 drivers/crypto/caam/jr.c       |   3 +
 2 files changed, 113 insertions(+), 45 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index d9de3dc..7f9ffde 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -65,6 +65,7 @@
 #include "sg_sw_sec4.h"
 #include "key_gen.h"
 #include "caamhash_desc.h"
+#include <crypto/engine.h>
 
 #define CAAM_CRA_PRIORITY		3000
 
@@ -86,6 +87,7 @@ static struct list_head hash_list;
 
 /* ahash per-session context */
 struct caam_hash_ctx {
+	struct crypto_engine_ctx enginectx;
 	u32 sh_desc_update[DESC_HASH_MAX_USED_LEN] ____cacheline_aligned;
 	u32 sh_desc_update_first[DESC_HASH_MAX_USED_LEN] ____cacheline_aligned;
 	u32 sh_desc_fin[DESC_HASH_MAX_USED_LEN] ____cacheline_aligned;
@@ -112,10 +114,13 @@ struct caam_hash_state {
 	u8 buf_1[CAAM_MAX_HASH_BLOCK_SIZE] ____cacheline_aligned;
 	int buflen_1;
 	u8 caam_ctx[MAX_CTX_LEN] ____cacheline_aligned;
-	int (*update)(struct ahash_request *req);
+	int (*update)(struct ahash_request *req) ____cacheline_aligned;
 	int (*final)(struct ahash_request *req);
 	int (*finup)(struct ahash_request *req);
 	int current_buf;
+	struct ahash_edesc *edesc;
+	void (*ahash_op_done)(struct device *jrdev, u32 *desc, u32 err,
+			      void *context);
 };
 
 struct caam_export_state {
@@ -125,6 +130,9 @@ struct caam_export_state {
 	int (*update)(struct ahash_request *req);
 	int (*final)(struct ahash_request *req);
 	int (*finup)(struct ahash_request *req);
+	struct ahash_edesc *edesc;
+	void (*ahash_op_done)(struct device *jrdev, u32 *desc, u32 err,
+			      void *context);
 };
 
 static inline void switch_buf(struct caam_hash_state *state)
@@ -604,6 +612,7 @@ static inline void ahash_done_cpy(struct device *jrdev, u32 *desc, u32 err,
 {
 	struct caam_jr_request_entry *jrentry = context;
 	struct ahash_request *req = ahash_request_cast(jrentry->base);
+	struct caam_drv_private_jr *jrp = dev_get_drvdata(jrdev);
 	struct ahash_edesc *edesc;
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
 	int digestsize = crypto_ahash_digestsize(ahash);
@@ -613,7 +622,8 @@ static inline void ahash_done_cpy(struct device *jrdev, u32 *desc, u32 err,
 
 	dev_dbg(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
 
-	edesc = container_of(desc, struct ahash_edesc, hw_desc[0]);
+	edesc = state->edesc;
+
 	if (err)
 		ecode = caam_jr_strstatus(jrdev, err);
 
@@ -625,7 +635,14 @@ static inline void ahash_done_cpy(struct device *jrdev, u32 *desc, u32 err,
 			     DUMP_PREFIX_ADDRESS, 16, 4, state->caam_ctx,
 			     ctx->ctx_len, 1);
 
-	req->base.complete(&req->base, ecode);
+	/*
+	 * If no backlog flag, the completion of the request is done
+	 * by CAAM, not crypto engine.
+	 */
+	if (!jrentry->bklog)
+		req->base.complete(&req->base, ecode);
+	else
+		crypto_finalize_hash_request(jrp->engine, req, ecode);
 }
 
 static void ahash_done(struct device *jrdev, u32 *desc, u32 err,
@@ -645,6 +662,7 @@ static inline void ahash_done_switch(struct device *jrdev, u32 *desc, u32 err,
 {
 	struct caam_jr_request_entry *jrentry = context;
 	struct ahash_request *req = ahash_request_cast(jrentry->base);
+	struct caam_drv_private_jr *jrp = dev_get_drvdata(jrdev);
 	struct ahash_edesc *edesc;
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
@@ -654,7 +672,7 @@ static inline void ahash_done_switch(struct device *jrdev, u32 *desc, u32 err,
 
 	dev_dbg(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
 
-	edesc = container_of(desc, struct ahash_edesc, hw_desc[0]);
+	edesc = state->edesc;
 	if (err)
 		ecode = caam_jr_strstatus(jrdev, err);
 
@@ -670,7 +688,15 @@ static inline void ahash_done_switch(struct device *jrdev, u32 *desc, u32 err,
 				     DUMP_PREFIX_ADDRESS, 16, 4, req->result,
 				     digestsize, 1);
 
-	req->base.complete(&req->base, ecode);
+	/*
+	 * If no backlog flag, the completion of the request is done
+	 * by CAAM, not crypto engine.
+	 */
+	if (!jrentry->bklog)
+		req->base.complete(&req->base, ecode);
+	else
+		crypto_finalize_hash_request(jrp->engine, req, ecode);
+
 }
 
 static void ahash_done_bi(struct device *jrdev, u32 *desc, u32 err,
@@ -695,6 +721,7 @@ static struct ahash_edesc *ahash_edesc_alloc(struct ahash_request *req,
 {
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
+	struct caam_hash_state *state = ahash_request_ctx(req);
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		       GFP_KERNEL : GFP_ATOMIC;
 	struct ahash_edesc *edesc;
@@ -707,6 +734,7 @@ static struct ahash_edesc *ahash_edesc_alloc(struct ahash_request *req,
 	}
 
 	edesc->jrentry.base = &req->base;
+	state->edesc = edesc;
 
 	init_job_desc_shared(edesc->hw_desc, sh_desc_dma, desc_len(sh_desc),
 			     HDR_SHARE_DEFER | HDR_REVERSE);
@@ -750,6 +778,32 @@ static int ahash_edesc_add_src(struct caam_hash_ctx *ctx,
 	return 0;
 }
 
+static int ahash_do_one_req(struct crypto_engine *engine, void *areq)
+{
+	struct ahash_request *req = ahash_request_cast(areq);
+	struct caam_hash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
+	struct caam_hash_state *state = ahash_request_ctx(req);
+	struct caam_jr_request_entry *jrentry;
+	struct device *jrdev = ctx->jrdev;
+	u32 *desc = state->edesc->hw_desc;
+	int ret;
+
+	jrentry = &state->edesc->jrentry;
+	jrentry->bklog = true;
+
+	ret = caam_jr_enqueue_no_bklog(jrdev, desc, state->ahash_op_done,
+				       jrentry);
+
+	if (ret != -EINPROGRESS) {
+		ahash_unmap(jrdev, state->edesc, req, 0);
+		kfree(state->edesc);
+	} else {
+		ret = 0;
+	}
+
+	return ret;
+}
+
 /* submit update job descriptor */
 static int ahash_update_ctx(struct ahash_request *req)
 {
@@ -766,7 +820,6 @@ static int ahash_update_ctx(struct ahash_request *req)
 	u32 *desc;
 	int src_nents, mapped_nents, sec4_sg_bytes, sec4_sg_src_index;
 	struct ahash_edesc *edesc;
-	struct caam_jr_request_entry *jrentry;
 	int ret = 0;
 
 	last_buflen = *next_buflen;
@@ -864,10 +917,11 @@ static int ahash_update_ctx(struct ahash_request *req)
 				     DUMP_PREFIX_ADDRESS, 16, 4, desc,
 				     desc_bytes(desc), 1);
 
-		jrentry = &edesc->jrentry;
+		state->ahash_op_done = ahash_done_bi;
 
-		ret = caam_jr_enqueue(jrdev, desc, ahash_done_bi, jrentry);
-		if (ret != -EINPROGRESS)
+		ret = caam_jr_enqueue(jrdev, desc, ahash_done_bi,
+				      &edesc->jrentry);
+		if ((ret != -EINPROGRESS) && (ret != -EBUSY))
 			goto unmap_ctx;
 	} else if (*next_buflen) {
 		scatterwalk_map_and_copy(buf + *buflen, req->src, 0,
@@ -900,7 +954,6 @@ static int ahash_final_ctx(struct ahash_request *req)
 	int sec4_sg_bytes;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
-	struct caam_jr_request_entry *jrentry;
 	int ret;
 
 	sec4_sg_bytes = pad_sg_nents(1 + (buflen ? 1 : 0)) *
@@ -943,10 +996,11 @@ static int ahash_final_ctx(struct ahash_request *req)
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
 
-	jrentry = &edesc->jrentry;
+	state->ahash_op_done = ahash_done_ctx_src;
+
+	ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, &edesc->jrentry);
 
-	ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, jrentry);
-	if (ret == -EINPROGRESS)
+	if ((ret == -EINPROGRESS) || (ret == -EBUSY))
 		return ret;
 
 unmap_ctx:
@@ -967,7 +1021,6 @@ static int ahash_finup_ctx(struct ahash_request *req)
 	int src_nents, mapped_nents;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
-	struct caam_jr_request_entry *jrentry;
 	int ret;
 
 	src_nents = sg_nents_for_len(req->src, req->nbytes);
@@ -1022,10 +1075,10 @@ static int ahash_finup_ctx(struct ahash_request *req)
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
 
-	jrentry = &edesc->jrentry;
+	state->ahash_op_done = ahash_done_ctx_src;
 
-	ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, jrentry);
-	if (ret == -EINPROGRESS)
+	ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, &edesc->jrentry);
+	if ((ret == -EINPROGRESS) || (ret == -EBUSY))
 		return ret;
 
 unmap_ctx:
@@ -1044,7 +1097,6 @@ static int ahash_digest(struct ahash_request *req)
 	int digestsize = crypto_ahash_digestsize(ahash);
 	int src_nents, mapped_nents;
 	struct ahash_edesc *edesc;
-	struct caam_jr_request_entry *jrentry;
 	int ret;
 
 	state->buf_dma = 0;
@@ -1097,10 +1149,10 @@ static int ahash_digest(struct ahash_request *req)
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
 
-	jrentry = &edesc->jrentry;
+	state->ahash_op_done = ahash_done;
 
-	ret = caam_jr_enqueue(jrdev, desc, ahash_done, jrentry);
-	if (ret != -EINPROGRESS) {
+	ret = caam_jr_enqueue(jrdev, desc, ahash_done, &edesc->jrentry);
+	if ((ret != -EINPROGRESS) && (ret != -EBUSY)) {
 		ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_FROM_DEVICE);
 		kfree(edesc);
 	}
@@ -1120,7 +1172,6 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 	u32 *desc;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
-	struct caam_jr_request_entry *jrentry;
 	int ret;
 
 	/* allocate space for base edesc and hw desc commands, link tables */
@@ -1150,20 +1201,19 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
 
-	jrentry = &edesc->jrentry;
+	state->ahash_op_done = ahash_done;
 
-	ret = caam_jr_enqueue(jrdev, desc, ahash_done, jrentry);
-	if (ret != -EINPROGRESS) {
+	ret = caam_jr_enqueue(jrdev, desc, ahash_done, &edesc->jrentry);
+	if ((ret != -EINPROGRESS) && (ret != -EBUSY)) {
 		ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_FROM_DEVICE);
 		kfree(edesc);
 	}
 
 	return ret;
- unmap:
+unmap:
 	ahash_unmap(jrdev, edesc, req, digestsize);
 	kfree(edesc);
 	return -ENOMEM;
-
 }
 
 /* submit ahash update if it the first job descriptor after update */
@@ -1181,7 +1231,6 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 	int in_len = *buflen + req->nbytes, to_hash;
 	int sec4_sg_bytes, src_nents, mapped_nents;
 	struct ahash_edesc *edesc;
-	struct caam_jr_request_entry *jrentry;
 	u32 *desc;
 	int ret = 0;
 
@@ -1271,10 +1320,11 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 				     DUMP_PREFIX_ADDRESS, 16, 4, desc,
 				     desc_bytes(desc), 1);
 
-		jrentry = &edesc->jrentry;
+		state->ahash_op_done = ahash_done_ctx_dst;
 
-		ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_dst, jrentry);
-		if (ret != -EINPROGRESS)
+		ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_dst,
+				      &edesc->jrentry);
+		if ((ret != -EINPROGRESS) && (ret != -EBUSY))
 			goto unmap_ctx;
 
 		state->update = ahash_update_ctx;
@@ -1294,7 +1344,7 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 			     1);
 
 	return ret;
- unmap_ctx:
+unmap_ctx:
 	ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len, DMA_TO_DEVICE);
 	kfree(edesc);
 	return ret;
@@ -1312,7 +1362,6 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 	int sec4_sg_bytes, sec4_sg_src_index, src_nents, mapped_nents;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
-	struct caam_jr_request_entry *jrentry;
 	int ret;
 
 	src_nents = sg_nents_for_len(req->src, req->nbytes);
@@ -1368,10 +1417,10 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
 
-	jrentry = &edesc->jrentry;
+	state->ahash_op_done = ahash_done;
 
-	ret = caam_jr_enqueue(jrdev, desc, ahash_done, jrentry);
-	if (ret != -EINPROGRESS) {
+	ret = caam_jr_enqueue(jrdev, desc, ahash_done, &edesc->jrentry);
+	if ((ret != -EINPROGRESS) && (ret != -EBUSY)) {
 		ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_FROM_DEVICE);
 		kfree(edesc);
 	}
@@ -1398,7 +1447,6 @@ static int ahash_update_first(struct ahash_request *req)
 	u32 *desc;
 	int src_nents, mapped_nents;
 	struct ahash_edesc *edesc;
-	struct caam_jr_request_entry *jrentry;
 	int ret = 0;
 
 	*next_buflen = req->nbytes & (blocksize - 1);
@@ -1468,10 +1516,11 @@ static int ahash_update_first(struct ahash_request *req)
 				     DUMP_PREFIX_ADDRESS, 16, 4, desc,
 				     desc_bytes(desc), 1);
 
-		jrentry = &edesc->jrentry;
+		state->ahash_op_done = ahash_done_ctx_dst;
 
-		ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_dst, jrentry);
-		if (ret != -EINPROGRESS)
+		ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_dst,
+				      &edesc->jrentry);
+		if ((ret != -EINPROGRESS) && (ret != -EBUSY))
 			goto unmap_ctx;
 
 		state->update = ahash_update_ctx;
@@ -1509,6 +1558,7 @@ static int ahash_init(struct ahash_request *req)
 	state->update = ahash_update_first;
 	state->finup = ahash_finup_first;
 	state->final = ahash_final_no_ctx;
+	state->ahash_op_done = ahash_done;
 
 	state->ctx_dma = 0;
 	state->ctx_dma_len = 0;
@@ -1562,6 +1612,8 @@ static int ahash_export(struct ahash_request *req, void *out)
 	export->update = state->update;
 	export->final = state->final;
 	export->finup = state->finup;
+	export->edesc = state->edesc;
+	export->ahash_op_done = state->ahash_op_done;
 
 	return 0;
 }
@@ -1578,6 +1630,8 @@ static int ahash_import(struct ahash_request *req, const void *in)
 	state->update = export->update;
 	state->final = export->final;
 	state->finup = export->finup;
+	state->edesc = export->edesc;
+	state->ahash_op_done = export->ahash_op_done;
 
 	return 0;
 }
@@ -1837,7 +1891,9 @@ static int caam_hash_cra_init(struct crypto_tfm *tfm)
 	}
 
 	dma_addr = dma_map_single_attrs(ctx->jrdev, ctx->sh_desc_update,
-					offsetof(struct caam_hash_ctx, key),
+					offsetof(struct caam_hash_ctx, key) -
+					offsetof(struct caam_hash_ctx,
+						 sh_desc_update),
 					ctx->dir, DMA_ATTR_SKIP_CPU_SYNC);
 	if (dma_mapping_error(ctx->jrdev, dma_addr)) {
 		dev_err(ctx->jrdev, "unable to map shared descriptors\n");
@@ -1855,11 +1911,19 @@ static int caam_hash_cra_init(struct crypto_tfm *tfm)
 	ctx->sh_desc_update_dma = dma_addr;
 	ctx->sh_desc_update_first_dma = dma_addr +
 					offsetof(struct caam_hash_ctx,
-						 sh_desc_update_first);
+						 sh_desc_update_first) -
+					offsetof(struct caam_hash_ctx,
+						 sh_desc_update);
 	ctx->sh_desc_fin_dma = dma_addr + offsetof(struct caam_hash_ctx,
-						   sh_desc_fin);
+						   sh_desc_fin) -
+					  offsetof(struct caam_hash_ctx,
+						   sh_desc_update);
 	ctx->sh_desc_digest_dma = dma_addr + offsetof(struct caam_hash_ctx,
-						      sh_desc_digest);
+						      sh_desc_digest) -
+					     offsetof(struct caam_hash_ctx,
+						      sh_desc_update);
+
+	ctx->enginectx.op.do_one_request = ahash_do_one_req;
 
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
 				 sizeof(struct caam_hash_state));
@@ -1876,7 +1940,8 @@ static void caam_hash_cra_exit(struct crypto_tfm *tfm)
 	struct caam_hash_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	dma_unmap_single_attrs(ctx->jrdev, ctx->sh_desc_update_dma,
-			       offsetof(struct caam_hash_ctx, key),
+			       offsetof(struct caam_hash_ctx, key) -
+			       offsetof(struct caam_hash_ctx, sh_desc_update),
 			       ctx->dir, DMA_ATTR_SKIP_CPU_SYNC);
 	if (ctx->key_dir != DMA_NONE)
 		dma_unmap_single_attrs(ctx->jrdev, ctx->adata.key_dma,
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 579b1ba..5f7b797 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -440,6 +440,9 @@ static int transfer_request_to_engine(struct crypto_engine *engine,
 	case CRYPTO_ALG_TYPE_AKCIPHER:
 		return crypto_transfer_akcipher_request_to_engine(engine,
 								  akcipher_request_cast(req));
+	case CRYPTO_ALG_TYPE_AHASH:
+		return crypto_transfer_hash_request_to_engine(engine,
+							      ahash_request_cast(req));
 	default:
 		return -EINVAL;
 	}
-- 
2.1.0

