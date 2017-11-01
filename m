From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 2/2] crypto: caam - remove unused param of ctx_map_to_sec4_sg()
Date: Wed, 1 Nov 2017 09:13:11 +0200
Message-ID: <20171101071311.4328-2-horia.geanta@nxp.com>
References: <20171101071311.4328-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Dan Douglass <dan.douglass@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-co1nam03on0082.outbound.protection.outlook.com ([104.47.40.82]:35232
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750925AbdKAHNi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Nov 2017 03:13:38 -0400
In-Reply-To: <20171101071311.4328-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

ctx_map_to_sec4_sg() function, added in
commit 045e36780f115 ("crypto: caam - ahash hmac support")
has never used the "desc" parameter, so let's drop it.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamhash.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 27fe1a07050c..400e788b4f1c 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -211,7 +211,7 @@ static inline int buf_map_to_sec4_sg(struct device *jrdev,
 }
 
 /* Map state->caam_ctx, and add it to link table */
-static inline int ctx_map_to_sec4_sg(u32 *desc, struct device *jrdev,
+static inline int ctx_map_to_sec4_sg(struct device *jrdev,
 				     struct caam_hash_state *state, int ctx_len,
 				     struct sec4_sg_entry *sec4_sg, u32 flag)
 {
@@ -722,7 +722,7 @@ static int ahash_update_ctx(struct ahash_request *req)
 		edesc->src_nents = src_nents;
 		edesc->sec4_sg_bytes = sec4_sg_bytes;
 
-		ret = ctx_map_to_sec4_sg(desc, jrdev, state, ctx->ctx_len,
+		ret = ctx_map_to_sec4_sg(jrdev, state, ctx->ctx_len,
 					 edesc->sec4_sg, DMA_BIDIRECTIONAL);
 		if (ret)
 			goto unmap_ctx;
@@ -821,7 +821,7 @@ static int ahash_final_ctx(struct ahash_request *req)
 
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
 
-	ret = ctx_map_to_sec4_sg(desc, jrdev, state, ctx->ctx_len,
+	ret = ctx_map_to_sec4_sg(jrdev, state, ctx->ctx_len,
 				 edesc->sec4_sg, DMA_TO_DEVICE);
 	if (ret)
 		goto unmap_ctx;
@@ -915,7 +915,7 @@ static int ahash_finup_ctx(struct ahash_request *req)
 
 	edesc->src_nents = src_nents;
 
-	ret = ctx_map_to_sec4_sg(desc, jrdev, state, ctx->ctx_len,
+	ret = ctx_map_to_sec4_sg(jrdev, state, ctx->ctx_len,
 				 edesc->sec4_sg, DMA_TO_DEVICE);
 	if (ret)
 		goto unmap_ctx;
-- 
2.12.0.264.gd6db3f216544
