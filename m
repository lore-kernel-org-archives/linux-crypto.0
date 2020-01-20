Return-Path: <SRS0=QLPS=3J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64EDDC2D0DB
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jan 2020 12:25:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B05F21569
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jan 2020 12:25:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgATMYQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Jan 2020 07:24:16 -0500
Received: from inva021.nxp.com ([92.121.34.21]:46842 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726796AbgATMYQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Jan 2020 07:24:16 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id DD799200574;
        Mon, 20 Jan 2020 13:24:14 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id CF32E200275;
        Mon, 20 Jan 2020 13:24:14 +0100 (CET)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 648AE20414;
        Mon, 20 Jan 2020 13:24:14 +0100 (CET)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: [PATCH v4 2/9] crypto: caam - refactor ahash_done callbacks
Date:   Mon, 20 Jan 2020 14:24:01 +0200
Message-Id: <1579523048-21078-3-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1579523048-21078-1-git-send-email-iuliana.prodan@nxp.com>
References: <1579523048-21078-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Create two common ahash_done_* functions with the dma
direction as parameter. Then, these 2 are called with
the proper direction for unmap.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Reviewed-by: Horia Geanta <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamhash.c | 88 +++++++++++-------------------------------
 1 file changed, 22 insertions(+), 66 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 8d91434..59881a8 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -565,8 +565,8 @@ static inline void ahash_unmap_ctx(struct device *dev,
 	ahash_unmap(dev, edesc, req, dst_len);
 }
 
-static void ahash_done(struct device *jrdev, u32 *desc, u32 err,
-		       void *context)
+static inline void ahash_done_cpy(struct device *jrdev, u32 *desc, u32 err,
+				  void *context, enum dma_data_direction dir)
 {
 	struct ahash_request *req = context;
 	struct ahash_edesc *edesc;
@@ -582,7 +582,7 @@ static void ahash_done(struct device *jrdev, u32 *desc, u32 err,
 	if (err)
 		ecode = caam_jr_strstatus(jrdev, err);
 
-	ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_FROM_DEVICE);
+	ahash_unmap_ctx(jrdev, edesc, req, digestsize, dir);
 	memcpy(req->result, state->caam_ctx, digestsize);
 	kfree(edesc);
 
@@ -593,76 +593,20 @@ static void ahash_done(struct device *jrdev, u32 *desc, u32 err,
 	req->base.complete(&req->base, ecode);
 }
 
-static void ahash_done_bi(struct device *jrdev, u32 *desc, u32 err,
-			    void *context)
+static void ahash_done(struct device *jrdev, u32 *desc, u32 err,
+		       void *context)
 {
-	struct ahash_request *req = context;
-	struct ahash_edesc *edesc;
-	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
-	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
-	struct caam_hash_state *state = ahash_request_ctx(req);
-	int digestsize = crypto_ahash_digestsize(ahash);
-	int ecode = 0;
-
-	dev_dbg(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
-
-	edesc = container_of(desc, struct ahash_edesc, hw_desc[0]);
-	if (err)
-		ecode = caam_jr_strstatus(jrdev, err);
-
-	ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len, DMA_BIDIRECTIONAL);
-	kfree(edesc);
-
-	scatterwalk_map_and_copy(state->buf, req->src,
-				 req->nbytes - state->next_buflen,
-				 state->next_buflen, 0);
-	state->buflen = state->next_buflen;
-
-	print_hex_dump_debug("buf@" __stringify(__LINE__)": ",
-			     DUMP_PREFIX_ADDRESS, 16, 4, state->buf,
-			     state->buflen, 1);
-
-	print_hex_dump_debug("ctx@"__stringify(__LINE__)": ",
-			     DUMP_PREFIX_ADDRESS, 16, 4, state->caam_ctx,
-			     ctx->ctx_len, 1);
-	if (req->result)
-		print_hex_dump_debug("result@"__stringify(__LINE__)": ",
-				     DUMP_PREFIX_ADDRESS, 16, 4, req->result,
-				     digestsize, 1);
-
-	req->base.complete(&req->base, ecode);
+	ahash_done_cpy(jrdev, desc, err, context, DMA_FROM_DEVICE);
 }
 
 static void ahash_done_ctx_src(struct device *jrdev, u32 *desc, u32 err,
 			       void *context)
 {
-	struct ahash_request *req = context;
-	struct ahash_edesc *edesc;
-	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
-	int digestsize = crypto_ahash_digestsize(ahash);
-	struct caam_hash_state *state = ahash_request_ctx(req);
-	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
-	int ecode = 0;
-
-	dev_dbg(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
-
-	edesc = container_of(desc, struct ahash_edesc, hw_desc[0]);
-	if (err)
-		ecode = caam_jr_strstatus(jrdev, err);
-
-	ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_BIDIRECTIONAL);
-	memcpy(req->result, state->caam_ctx, digestsize);
-	kfree(edesc);
-
-	print_hex_dump_debug("ctx@"__stringify(__LINE__)": ",
-			     DUMP_PREFIX_ADDRESS, 16, 4, state->caam_ctx,
-			     ctx->ctx_len, 1);
-
-	req->base.complete(&req->base, ecode);
+	ahash_done_cpy(jrdev, desc, err, context, DMA_BIDIRECTIONAL);
 }
 
-static void ahash_done_ctx_dst(struct device *jrdev, u32 *desc, u32 err,
-			       void *context)
+static inline void ahash_done_switch(struct device *jrdev, u32 *desc, u32 err,
+				     void *context, enum dma_data_direction dir)
 {
 	struct ahash_request *req = context;
 	struct ahash_edesc *edesc;
@@ -678,7 +622,7 @@ static void ahash_done_ctx_dst(struct device *jrdev, u32 *desc, u32 err,
 	if (err)
 		ecode = caam_jr_strstatus(jrdev, err);
 
-	ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len, DMA_FROM_DEVICE);
+	ahash_unmap_ctx(jrdev, edesc, req, ctx->ctx_len, dir);
 	kfree(edesc);
 
 	scatterwalk_map_and_copy(state->buf, req->src,
@@ -701,6 +645,18 @@ static void ahash_done_ctx_dst(struct device *jrdev, u32 *desc, u32 err,
 	req->base.complete(&req->base, ecode);
 }
 
+static void ahash_done_bi(struct device *jrdev, u32 *desc, u32 err,
+			  void *context)
+{
+	ahash_done_switch(jrdev, desc, err, context, DMA_BIDIRECTIONAL);
+}
+
+static void ahash_done_ctx_dst(struct device *jrdev, u32 *desc, u32 err,
+			       void *context)
+{
+	ahash_done_switch(jrdev, desc, err, context, DMA_FROM_DEVICE);
+}
+
 /*
  * Allocate an enhanced descriptor, which contains the hardware descriptor
  * and space for hardware scatter table containing sg_num entries.
-- 
2.1.0

