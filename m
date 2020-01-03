Return-Path: <SRS0=TjYB=2Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73289C3276E
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 01:03:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5214B222C3
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 01:03:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbgACBDu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jan 2020 20:03:50 -0500
Received: from inva021.nxp.com ([92.121.34.21]:48462 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726820AbgACBDT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jan 2020 20:03:19 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 55F39200EF3;
        Fri,  3 Jan 2020 02:03:16 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 47ED7200EDD;
        Fri,  3 Jan 2020 02:03:16 +0100 (CET)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id ED26D20567;
        Fri,  3 Jan 2020 02:03:15 +0100 (CET)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: [PATCH v2 10/10] crypto: caam - add crypto_engine support for HASH algorithms
Date:   Fri,  3 Jan 2020 03:02:53 +0200
Message-Id: <1578013373-1956-11-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1578013373-1956-1-git-send-email-iuliana.prodan@nxp.com>
References: <1578013373-1956-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add crypto_engine support for HASH algorithms, to make use of
the engine queue.
The requests, with backlog flag, will be listed into crypto-engine
queue and processed by CAAM when free.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 drivers/crypto/caam/caamhash.c | 175 ++++++++++++++++++++++++++++++-----------
 1 file changed, 127 insertions(+), 48 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index f179d39..93af298 100644
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
@@ -111,9 +113,12 @@ struct caam_hash_state {
 	int buflen;
 	int next_buflen;
 	u8 caam_ctx[MAX_CTX_LEN] ____cacheline_aligned;
-	int (*update)(struct ahash_request *req);
+	int (*update)(struct ahash_request *req) ____cacheline_aligned;
 	int (*final)(struct ahash_request *req);
 	int (*finup)(struct ahash_request *req);
+	struct ahash_edesc *edesc;
+	void (*ahash_op_done)(struct device *jrdev, u32 *desc, u32 err,
+			      void *context);
 };
 
 struct caam_export_state {
@@ -123,6 +128,9 @@ struct caam_export_state {
 	int (*update)(struct ahash_request *req);
 	int (*final)(struct ahash_request *req);
 	int (*finup)(struct ahash_request *req);
+	struct ahash_edesc *edesc;
+	void (*ahash_op_done)(struct device *jrdev, u32 *desc, u32 err,
+			      void *context);
 };
 
 static inline bool is_cmac_aes(u32 algtype)
@@ -588,6 +596,7 @@ static inline void ahash_done_cpy(struct device *jrdev, u32 *desc, u32 err,
 {
 	struct caam_ahash_request_entry *jrentry = context;
 	struct ahash_request *req = jrentry->base;
+	struct caam_drv_private_jr *jrp = dev_get_drvdata(jrdev);
 	struct ahash_edesc *edesc;
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
 	int digestsize = crypto_ahash_digestsize(ahash);
@@ -597,7 +606,8 @@ static inline void ahash_done_cpy(struct device *jrdev, u32 *desc, u32 err,
 
 	dev_dbg(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
 
-	edesc = container_of(desc, struct ahash_edesc, hw_desc[0]);
+	edesc = state->edesc;
+
 	if (err)
 		ecode = caam_jr_strstatus(jrdev, err);
 
@@ -609,7 +619,14 @@ static inline void ahash_done_cpy(struct device *jrdev, u32 *desc, u32 err,
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
@@ -629,6 +646,7 @@ static inline void ahash_done_switch(struct device *jrdev, u32 *desc, u32 err,
 {
 	struct caam_ahash_request_entry *jrentry = context;
 	struct ahash_request *req = jrentry->base;
+	struct caam_drv_private_jr *jrp = dev_get_drvdata(jrdev);
 	struct ahash_edesc *edesc;
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
@@ -638,7 +656,7 @@ static inline void ahash_done_switch(struct device *jrdev, u32 *desc, u32 err,
 
 	dev_dbg(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
 
-	edesc = container_of(desc, struct ahash_edesc, hw_desc[0]);
+	edesc = state->edesc;
 	if (err)
 		ecode = caam_jr_strstatus(jrdev, err);
 
@@ -662,7 +680,15 @@ static inline void ahash_done_switch(struct device *jrdev, u32 *desc, u32 err,
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
@@ -687,6 +713,7 @@ static struct ahash_edesc *ahash_edesc_alloc(struct ahash_request *req,
 {
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
+	struct caam_hash_state *state = ahash_request_ctx(req);
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		       GFP_KERNEL : GFP_ATOMIC;
 	struct ahash_edesc *edesc;
@@ -699,6 +726,7 @@ static struct ahash_edesc *ahash_edesc_alloc(struct ahash_request *req,
 	}
 
 	edesc->jrentry.base = req;
+	state->edesc = edesc;
 
 	init_job_desc_shared(edesc->hw_desc, sh_desc_dma, desc_len(sh_desc),
 			     HDR_SHARE_DEFER | HDR_REVERSE);
@@ -742,6 +770,56 @@ static int ahash_edesc_add_src(struct caam_hash_ctx *ctx,
 	return 0;
 }
 
+static int ahash_do_one_req(struct crypto_engine *engine, void *areq)
+{
+	struct ahash_request *req = ahash_request_cast(areq);
+	struct caam_hash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
+	struct caam_hash_state *state = ahash_request_ctx(req);
+	struct caam_ahash_request_entry *jrentry;
+	struct device *jrdev = ctx->jrdev;
+	u32 *desc = state->edesc->hw_desc;
+	int ret;
+
+	jrentry = &state->edesc->jrentry;
+	jrentry->bklog = true;
+
+	ret = caam_jr_enqueue(jrdev, desc, state->ahash_op_done,
+			      jrentry);
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
+static int ahash_enqueue_req(struct device *jrdev, u32 *desc,
+			     void (*cbk)(struct device *jrdev, u32 *desc,
+					 u32 err, void *context),
+			     struct ahash_request *req,
+			     struct ahash_edesc *edesc,
+			     int dst_len, enum dma_data_direction dir)
+{
+	struct caam_drv_private_jr *jrpriv = dev_get_drvdata(jrdev);
+	int ret;
+
+	if (req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)
+		return crypto_transfer_hash_request_to_engine(jrpriv->engine,
+							      req);
+	else
+		ret = caam_jr_enqueue(jrdev, desc, cbk, &edesc->jrentry);
+
+	if (ret != -EINPROGRESS) {
+		ahash_unmap_ctx(jrdev, edesc, req, dst_len, dir);
+		kfree(edesc);
+	}
+
+	return ret;
+}
+
 /* submit update job descriptor */
 static int ahash_update_ctx(struct ahash_request *req)
 {
@@ -849,10 +927,9 @@ static int ahash_update_ctx(struct ahash_request *req)
 				     DUMP_PREFIX_ADDRESS, 16, 4, desc,
 				     desc_bytes(desc), 1);
 
-		ret = caam_jr_enqueue(jrdev, desc, ahash_done_bi,
-				      &edesc->jrentry);
-		if (ret != -EINPROGRESS)
-			goto unmap_ctx;
+		state->ahash_op_done = ahash_done_bi;
+		ret = ahash_enqueue_req(jrdev, desc, ahash_done_bi, req, edesc,
+					ctx->ctx_len, DMA_BIDIRECTIONAL);
 	} else if (*next_buflen) {
 		scatterwalk_map_and_copy(buf + *buflen, req->src, 0,
 					 req->nbytes, 0);
@@ -923,10 +1000,10 @@ static int ahash_final_ctx(struct ahash_request *req)
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
 
-	ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, &edesc->jrentry);
-	if (ret == -EINPROGRESS)
-		return ret;
+	state->ahash_op_done = ahash_done_ctx_src;
 
+	return ahash_enqueue_req(jrdev, desc, ahash_done_ctx_src, req, edesc,
+				 digestsize, DMA_BIDIRECTIONAL);
  unmap_ctx:
 	ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_BIDIRECTIONAL);
 	kfree(edesc);
@@ -999,10 +1076,10 @@ static int ahash_finup_ctx(struct ahash_request *req)
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
 
-	ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, &edesc->jrentry);
-	if (ret == -EINPROGRESS)
-		return ret;
+	state->ahash_op_done = ahash_done_ctx_src;
 
+	return ahash_enqueue_req(jrdev, desc, ahash_done_ctx_src, req, edesc,
+				 digestsize, DMA_BIDIRECTIONAL);
  unmap_ctx:
 	ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_BIDIRECTIONAL);
 	kfree(edesc);
@@ -1071,13 +1148,10 @@ static int ahash_digest(struct ahash_request *req)
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
 
-	ret = caam_jr_enqueue(jrdev, desc, ahash_done, &edesc->jrentry);
-	if (ret != -EINPROGRESS) {
-		ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_FROM_DEVICE);
-		kfree(edesc);
-	}
+	state->ahash_op_done = ahash_done;
 
-	return ret;
+	return ahash_enqueue_req(jrdev, desc, ahash_done, req, edesc,
+			digestsize, DMA_FROM_DEVICE);
 }
 
 /* submit ahash final if it the first job descriptor */
@@ -1121,18 +1195,14 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
 
-	ret = caam_jr_enqueue(jrdev, desc, ahash_done, &edesc->jrentry);
-	if (ret != -EINPROGRESS) {
-		ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_FROM_DEVICE);
-		kfree(edesc);
-	}
+	state->ahash_op_done = ahash_done;
 
-	return ret;
+	return ahash_enqueue_req(jrdev, desc, ahash_done, req, edesc,
+			digestsize, DMA_FROM_DEVICE);
  unmap:
 	ahash_unmap(jrdev, edesc, req, digestsize);
 	kfree(edesc);
 	return -ENOMEM;
-
 }
 
 /* submit ahash update if it the first job descriptor after update */
@@ -1232,10 +1302,9 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 				     DUMP_PREFIX_ADDRESS, 16, 4, desc,
 				     desc_bytes(desc), 1);
 
-		ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_dst,
-				      &edesc->jrentry);
-		if (ret != -EINPROGRESS)
-			goto unmap_ctx;
+		state->ahash_op_done = ahash_done_ctx_dst;
+		ret = ahash_enqueue_req(jrdev, desc, ahash_done_ctx_dst, req,
+					edesc, ctx->ctx_len, DMA_TO_DEVICE);
 
 		state->update = ahash_update_ctx;
 		state->finup = ahash_finup_ctx;
@@ -1324,13 +1393,10 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
 
-	ret = caam_jr_enqueue(jrdev, desc, ahash_done, &edesc->jrentry);
-	if (ret != -EINPROGRESS) {
-		ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_FROM_DEVICE);
-		kfree(edesc);
-	}
+	state->ahash_op_done = ahash_done;
 
-	return ret;
+	return ahash_enqueue_req(jrdev, desc, ahash_done, req, edesc,
+				 digestsize, DMA_FROM_DEVICE);
  unmap:
 	ahash_unmap(jrdev, edesc, req, digestsize);
 	kfree(edesc);
@@ -1418,11 +1484,9 @@ static int ahash_update_first(struct ahash_request *req)
 				     DUMP_PREFIX_ADDRESS, 16, 4, desc,
 				     desc_bytes(desc), 1);
 
-		ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_dst,
-				      &edesc->jrentry);
-		if (ret != -EINPROGRESS)
-			goto unmap_ctx;
-
+		state->ahash_op_done = ahash_done_ctx_dst;
+		ret = ahash_enqueue_req(jrdev, desc, ahash_done_ctx_dst, req,
+					edesc, ctx->ctx_len, DMA_TO_DEVICE);
 		state->update = ahash_update_ctx;
 		state->finup = ahash_finup_ctx;
 		state->final = ahash_final_ctx;
@@ -1502,6 +1566,8 @@ static int ahash_export(struct ahash_request *req, void *out)
 	export->update = state->update;
 	export->final = state->final;
 	export->finup = state->finup;
+	export->edesc = state->edesc;
+	export->ahash_op_done = state->ahash_op_done;
 
 	return 0;
 }
@@ -1518,6 +1584,8 @@ static int ahash_import(struct ahash_request *req, const void *in)
 	state->update = export->update;
 	state->final = export->final;
 	state->finup = export->finup;
+	state->edesc = export->edesc;
+	state->ahash_op_done = export->ahash_op_done;
 
 	return 0;
 }
@@ -1777,7 +1845,9 @@ static int caam_hash_cra_init(struct crypto_tfm *tfm)
 	}
 
 	dma_addr = dma_map_single_attrs(ctx->jrdev, ctx->sh_desc_update,
-					offsetof(struct caam_hash_ctx, key),
+					offsetof(struct caam_hash_ctx, key) -
+					offsetof(struct caam_hash_ctx,
+						 sh_desc_update),
 					ctx->dir, DMA_ATTR_SKIP_CPU_SYNC);
 	if (dma_mapping_error(ctx->jrdev, dma_addr)) {
 		dev_err(ctx->jrdev, "unable to map shared descriptors\n");
@@ -1795,11 +1865,19 @@ static int caam_hash_cra_init(struct crypto_tfm *tfm)
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
@@ -1816,7 +1894,8 @@ static void caam_hash_cra_exit(struct crypto_tfm *tfm)
 	struct caam_hash_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	dma_unmap_single_attrs(ctx->jrdev, ctx->sh_desc_update_dma,
-			       offsetof(struct caam_hash_ctx, key),
+			       offsetof(struct caam_hash_ctx, key) -
+			       offsetof(struct caam_hash_ctx, sh_desc_update),
 			       ctx->dir, DMA_ATTR_SKIP_CPU_SYNC);
 	if (ctx->key_dir != DMA_NONE)
 		dma_unmap_single_attrs(ctx->jrdev, ctx->adata.key_dma,
-- 
2.1.0

