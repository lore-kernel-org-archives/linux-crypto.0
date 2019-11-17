Return-Path: <SRS0=TGTC=ZJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3801FC432C0
	for <linux-crypto@archiver.kernel.org>; Sun, 17 Nov 2019 22:31:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1193720740
	for <linux-crypto@archiver.kernel.org>; Sun, 17 Nov 2019 22:31:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfKQWbI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 17 Nov 2019 17:31:08 -0500
Received: from inva021.nxp.com ([92.121.34.21]:44644 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726325AbfKQWbG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 17 Nov 2019 17:31:06 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 3628C200166;
        Sun, 17 Nov 2019 23:31:04 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 261B92000AA;
        Sun, 17 Nov 2019 23:31:04 +0100 (CET)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id BC12E20395;
        Sun, 17 Nov 2019 23:31:03 +0100 (CET)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: [PATCH 04/12] crypto: caam - refactor ahash_edesc_alloc
Date:   Mon, 18 Nov 2019 00:30:37 +0200
Message-Id: <1574029845-22796-5-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
References: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Changed parameters for ahash_edesc_alloc function:
- remove flags since they can be computed in
ahash_edesc_alloc, the only place they are needed;
- use ahash_request instead of caam_hash_ctx, which
can be obtained from request.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 drivers/crypto/caam/caamhash.c | 62 +++++++++++++++---------------------------
 1 file changed, 22 insertions(+), 40 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 3d6e978..5f9f16c 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -685,11 +685,14 @@ static void ahash_done_ctx_dst(struct device *jrdev, u32 *desc, u32 err,
  * Allocate an enhanced descriptor, which contains the hardware descriptor
  * and space for hardware scatter table containing sg_num entries.
  */
-static struct ahash_edesc *ahash_edesc_alloc(struct caam_hash_ctx *ctx,
+static struct ahash_edesc *ahash_edesc_alloc(struct ahash_request *req,
 					     int sg_num, u32 *sh_desc,
-					     dma_addr_t sh_desc_dma,
-					     gfp_t flags)
+					     dma_addr_t sh_desc_dma)
 {
+	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
+	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
+	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+		       GFP_KERNEL : GFP_ATOMIC;
 	struct ahash_edesc *edesc;
 	unsigned int sg_size = sg_num * sizeof(struct sec4_sg_entry);
 
@@ -748,8 +751,6 @@ static int ahash_update_ctx(struct ahash_request *req)
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-		       GFP_KERNEL : GFP_ATOMIC;
 	u8 *buf = current_buf(state);
 	int *buflen = current_buflen(state);
 	u8 *next_buf = alt_buf(state);
@@ -805,8 +806,8 @@ static int ahash_update_ctx(struct ahash_request *req)
 		 * allocate space for base edesc and hw desc commands,
 		 * link tables
 		 */
-		edesc = ahash_edesc_alloc(ctx, pad_nents, ctx->sh_desc_update,
-					  ctx->sh_desc_update_dma, flags);
+		edesc = ahash_edesc_alloc(req, pad_nents, ctx->sh_desc_update,
+					  ctx->sh_desc_update_dma);
 		if (!edesc) {
 			dma_unmap_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
 			return -ENOMEM;
@@ -887,8 +888,6 @@ static int ahash_final_ctx(struct ahash_request *req)
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-		       GFP_KERNEL : GFP_ATOMIC;
 	int buflen = *current_buflen(state);
 	u32 *desc;
 	int sec4_sg_bytes;
@@ -900,8 +899,8 @@ static int ahash_final_ctx(struct ahash_request *req)
 			sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = ahash_edesc_alloc(ctx, 4, ctx->sh_desc_fin,
-				  ctx->sh_desc_fin_dma, flags);
+	edesc = ahash_edesc_alloc(req, 4, ctx->sh_desc_fin,
+				  ctx->sh_desc_fin_dma);
 	if (!edesc)
 		return -ENOMEM;
 
@@ -953,8 +952,6 @@ static int ahash_finup_ctx(struct ahash_request *req)
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-		       GFP_KERNEL : GFP_ATOMIC;
 	int buflen = *current_buflen(state);
 	u32 *desc;
 	int sec4_sg_src_index;
@@ -983,9 +980,8 @@ static int ahash_finup_ctx(struct ahash_request *req)
 	sec4_sg_src_index = 1 + (buflen ? 1 : 0);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = ahash_edesc_alloc(ctx, sec4_sg_src_index + mapped_nents,
-				  ctx->sh_desc_fin, ctx->sh_desc_fin_dma,
-				  flags);
+	edesc = ahash_edesc_alloc(req, sec4_sg_src_index + mapped_nents,
+				  ctx->sh_desc_fin, ctx->sh_desc_fin_dma);
 	if (!edesc) {
 		dma_unmap_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
 		return -ENOMEM;
@@ -1033,8 +1029,6 @@ static int ahash_digest(struct ahash_request *req)
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-		       GFP_KERNEL : GFP_ATOMIC;
 	u32 *desc;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	int src_nents, mapped_nents;
@@ -1061,9 +1055,8 @@ static int ahash_digest(struct ahash_request *req)
 	}
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = ahash_edesc_alloc(ctx, mapped_nents > 1 ? mapped_nents : 0,
-				  ctx->sh_desc_digest, ctx->sh_desc_digest_dma,
-				  flags);
+	edesc = ahash_edesc_alloc(req, mapped_nents > 1 ? mapped_nents : 0,
+				  ctx->sh_desc_digest, ctx->sh_desc_digest_dma);
 	if (!edesc) {
 		dma_unmap_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
 		return -ENOMEM;
@@ -1110,8 +1103,6 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-		       GFP_KERNEL : GFP_ATOMIC;
 	u8 *buf = current_buf(state);
 	int buflen = *current_buflen(state);
 	u32 *desc;
@@ -1120,8 +1111,8 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 	int ret;
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = ahash_edesc_alloc(ctx, 0, ctx->sh_desc_digest,
-				  ctx->sh_desc_digest_dma, flags);
+	edesc = ahash_edesc_alloc(req, 0, ctx->sh_desc_digest,
+				  ctx->sh_desc_digest_dma);
 	if (!edesc)
 		return -ENOMEM;
 
@@ -1169,8 +1160,6 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-		       GFP_KERNEL : GFP_ATOMIC;
 	u8 *buf = current_buf(state);
 	int *buflen = current_buflen(state);
 	int blocksize = crypto_ahash_blocksize(ahash);
@@ -1224,10 +1213,9 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 		 * allocate space for base edesc and hw desc commands,
 		 * link tables
 		 */
-		edesc = ahash_edesc_alloc(ctx, pad_nents,
+		edesc = ahash_edesc_alloc(req, pad_nents,
 					  ctx->sh_desc_update_first,
-					  ctx->sh_desc_update_first_dma,
-					  flags);
+					  ctx->sh_desc_update_first_dma);
 		if (!edesc) {
 			dma_unmap_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
 			return -ENOMEM;
@@ -1304,8 +1292,6 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-		       GFP_KERNEL : GFP_ATOMIC;
 	int buflen = *current_buflen(state);
 	u32 *desc;
 	int sec4_sg_bytes, sec4_sg_src_index, src_nents, mapped_nents;
@@ -1335,9 +1321,8 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 			 sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = ahash_edesc_alloc(ctx, sec4_sg_src_index + mapped_nents,
-				  ctx->sh_desc_digest, ctx->sh_desc_digest_dma,
-				  flags);
+	edesc = ahash_edesc_alloc(req, sec4_sg_src_index + mapped_nents,
+				  ctx->sh_desc_digest, ctx->sh_desc_digest_dma);
 	if (!edesc) {
 		dma_unmap_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
 		return -ENOMEM;
@@ -1390,8 +1375,6 @@ static int ahash_update_first(struct ahash_request *req)
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-		       GFP_KERNEL : GFP_ATOMIC;
 	u8 *next_buf = alt_buf(state);
 	int *next_buflen = alt_buflen(state);
 	int to_hash;
@@ -1438,11 +1421,10 @@ static int ahash_update_first(struct ahash_request *req)
 		 * allocate space for base edesc and hw desc commands,
 		 * link tables
 		 */
-		edesc = ahash_edesc_alloc(ctx, mapped_nents > 1 ?
+		edesc = ahash_edesc_alloc(req, mapped_nents > 1 ?
 					  mapped_nents : 0,
 					  ctx->sh_desc_update_first,
-					  ctx->sh_desc_update_first_dma,
-					  flags);
+					  ctx->sh_desc_update_first_dma);
 		if (!edesc) {
 			dma_unmap_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
 			return -ENOMEM;
-- 
2.1.0

