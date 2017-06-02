From: David Gstir <david@sigma-star.at>
Subject: [RFC PATCH 2/2] crypto: caam - fix k*alloc if called from own cipher callback
Date: Fri,  2 Jun 2017 14:24:46 +0200
Message-ID: <20170602122446.2427-3-david@sigma-star.at>
References: <20170602122446.2427-1-david@sigma-star.at>
Cc: richard@sigma-star.at, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Gstir <david@sigma-star.at>
To: horia.geanta@nxp.com, dan.douglass@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.sigma-star.at ([95.130.255.111]:45998 "EHLO
        mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751157AbdFBMZE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Jun 2017 08:25:04 -0400
In-Reply-To: <20170602122446.2427-1-david@sigma-star.at>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

There are cases (e.g. the cts mode) where a cipher can be called again
from its own callback. In our case this callback is executed from within
a tasklet in the jobring, we must not sleep when allocating memory.

This patch detects such cases by using in_interrupt() to properly set the
k*alloc flags. In most cases we will still use GFP_KERNEL if the flags
CRYPTO_TFM_REQ_MAY_SLEEP or CRYPTO_TFM_REQ_MAY_BACKLOG are set for the
cipher request.

Signed-off-by: David Gstir <david@sigma-star.at>
---
 drivers/crypto/caam/caamalg.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index d13c1aee4427..4c4a5d1ad875 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1209,13 +1209,18 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
-		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
+	gfp_t flags;
 	int src_nents, mapped_src_nents, dst_nents = 0, mapped_dst_nents = 0;
 	struct aead_edesc *edesc;
 	int sec4_sg_index, sec4_sg_len, sec4_sg_bytes;
 	unsigned int authsize = ctx->authsize;
 
+	if (!in_interrupt() && req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
+						  CRYPTO_TFM_REQ_MAY_SLEEP))
+		flags = GFP_KERNEL;
+	else
+		flags = GFP_ATOMIC;
+
 	if (unlikely(req->dst != req->src)) {
 		src_nents = sg_nents_for_len(req->src, req->assoclen +
 					     req->cryptlen);
@@ -1497,9 +1502,7 @@ static struct ablkcipher_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request
 	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
 	struct caam_ctx *ctx = crypto_ablkcipher_ctx(ablkcipher);
 	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
-					  CRYPTO_TFM_REQ_MAY_SLEEP)) ?
-		       GFP_KERNEL : GFP_ATOMIC;
+	gfp_t flags;
 	int src_nents, mapped_src_nents, dst_nents = 0, mapped_dst_nents = 0;
 	struct ablkcipher_edesc *edesc;
 	dma_addr_t iv_dma = 0;
@@ -1507,6 +1510,12 @@ static struct ablkcipher_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request
 	int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
 	int dst_sg_idx, sec4_sg_ents, sec4_sg_bytes;
 
+	if (!in_interrupt() && req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
+						  CRYPTO_TFM_REQ_MAY_SLEEP))
+		flags = GFP_KERNEL;
+	else
+		flags = GFP_ATOMIC;
+
 	src_nents = sg_nents_for_len(req->src, req->nbytes);
 	if (unlikely(src_nents < 0)) {
 		dev_err(jrdev, "Insufficient bytes (%d) in src S/G\n",
@@ -1703,9 +1712,7 @@ static struct ablkcipher_edesc *ablkcipher_giv_edesc_alloc(
 	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
 	struct caam_ctx *ctx = crypto_ablkcipher_ctx(ablkcipher);
 	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
-					  CRYPTO_TFM_REQ_MAY_SLEEP)) ?
-		       GFP_KERNEL : GFP_ATOMIC;
+	gfp_t flags;
 	int src_nents, mapped_src_nents, dst_nents, mapped_dst_nents;
 	struct ablkcipher_edesc *edesc;
 	dma_addr_t iv_dma = 0;
@@ -1713,6 +1720,12 @@ static struct ablkcipher_edesc *ablkcipher_giv_edesc_alloc(
 	int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
 	int dst_sg_idx, sec4_sg_ents, sec4_sg_bytes;
 
+	if (!in_interrupt() && req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
+						  CRYPTO_TFM_REQ_MAY_SLEEP))
+		flags = GFP_KERNEL;
+	else
+		flags = GFP_ATOMIC;
+
 	src_nents = sg_nents_for_len(req->src, req->nbytes);
 	if (unlikely(src_nents < 0)) {
 		dev_err(jrdev, "Insufficient bytes (%d) in src S/G\n",
-- 
2.12.0
