Return-Path: <SRS0=TjYB=2Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05D50C3276E
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 01:04:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2B96217F4
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 01:04:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbgACBEP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jan 2020 20:04:15 -0500
Received: from inva020.nxp.com ([92.121.34.13]:47364 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbgACBDQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jan 2020 20:03:16 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 90D741A1B12;
        Fri,  3 Jan 2020 02:03:13 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 82FC01A1AF5;
        Fri,  3 Jan 2020 02:03:13 +0100 (CET)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 230A820567;
        Fri,  3 Jan 2020 02:03:13 +0100 (CET)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: [PATCH v2 03/10] crypto: caam - refactor ahash_edesc_alloc
Date:   Fri,  3 Jan 2020 03:02:46 +0200
Message-Id: <1578013373-1956-4-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1578013373-1956-1-git-send-email-iuliana.prodan@nxp.com>
References: <1578013373-1956-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Changed parameters for ahash_edesc_alloc function:
- remove flags since they can be computed in
ahash_edesc_alloc, the only place they are needed;
- use ahash_request instead of caam_hash_ctx, to be
able to compute gfp flags.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Reviewed-by: Horia Geanta <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamhash.c | 62 +++++++++++++++---------------------------
 1 file changed, 22 insertions(+), 40 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 84be6db..844e391 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -666,11 +666,14 @@ static void ahash_done_ctx_dst(struct device *jrdev, u32 *desc, u32 err,
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
 
@@ -729,8 +732,6 @@ static int ahash_update_ctx(struct ahash_request *req)
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-		       GFP_KERNEL : GFP_ATOMIC;
 	u8 *buf = state->buf;
 	int *buflen = &state->buflen;
 	int *next_buflen = &state->next_buflen;
@@ -784,8 +785,8 @@ static int ahash_update_ctx(struct ahash_request *req)
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
@@ -859,8 +860,6 @@ static int ahash_final_ctx(struct ahash_request *req)
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-		       GFP_KERNEL : GFP_ATOMIC;
 	int buflen = state->buflen;
 	u32 *desc;
 	int sec4_sg_bytes;
@@ -872,8 +871,8 @@ static int ahash_final_ctx(struct ahash_request *req)
 			sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = ahash_edesc_alloc(ctx, 4, ctx->sh_desc_fin,
-				  ctx->sh_desc_fin_dma, flags);
+	edesc = ahash_edesc_alloc(req, 4, ctx->sh_desc_fin,
+				  ctx->sh_desc_fin_dma);
 	if (!edesc)
 		return -ENOMEM;
 
@@ -925,8 +924,6 @@ static int ahash_finup_ctx(struct ahash_request *req)
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-		       GFP_KERNEL : GFP_ATOMIC;
 	int buflen = state->buflen;
 	u32 *desc;
 	int sec4_sg_src_index;
@@ -955,9 +952,8 @@ static int ahash_finup_ctx(struct ahash_request *req)
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
@@ -1005,8 +1001,6 @@ static int ahash_digest(struct ahash_request *req)
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-		       GFP_KERNEL : GFP_ATOMIC;
 	u32 *desc;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	int src_nents, mapped_nents;
@@ -1033,9 +1027,8 @@ static int ahash_digest(struct ahash_request *req)
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
@@ -1082,8 +1075,6 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-		       GFP_KERNEL : GFP_ATOMIC;
 	u8 *buf = state->buf;
 	int buflen = state->buflen;
 	u32 *desc;
@@ -1092,8 +1083,8 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 	int ret;
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = ahash_edesc_alloc(ctx, 0, ctx->sh_desc_digest,
-				  ctx->sh_desc_digest_dma, flags);
+	edesc = ahash_edesc_alloc(req, 0, ctx->sh_desc_digest,
+				  ctx->sh_desc_digest_dma);
 	if (!edesc)
 		return -ENOMEM;
 
@@ -1141,8 +1132,6 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-		       GFP_KERNEL : GFP_ATOMIC;
 	u8 *buf = state->buf;
 	int *buflen = &state->buflen;
 	int *next_buflen = &state->next_buflen;
@@ -1195,10 +1184,9 @@ static int ahash_update_no_ctx(struct ahash_request *req)
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
@@ -1266,8 +1254,6 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-		       GFP_KERNEL : GFP_ATOMIC;
 	int buflen = state->buflen;
 	u32 *desc;
 	int sec4_sg_bytes, sec4_sg_src_index, src_nents, mapped_nents;
@@ -1297,9 +1283,8 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
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
@@ -1352,8 +1337,6 @@ static int ahash_update_first(struct ahash_request *req)
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-		       GFP_KERNEL : GFP_ATOMIC;
 	u8 *buf = state->buf;
 	int *buflen = &state->buflen;
 	int *next_buflen = &state->next_buflen;
@@ -1401,11 +1384,10 @@ static int ahash_update_first(struct ahash_request *req)
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

