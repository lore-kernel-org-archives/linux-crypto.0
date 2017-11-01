From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 1/2] crypto: caam - remove unneeded edesc zeroization
Date: Wed, 1 Nov 2017 09:13:10 +0200
Message-ID: <20171101071311.4328-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Dan Douglass <dan.douglass@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0052.outbound.protection.outlook.com ([104.47.34.52]:45184
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750716AbdKAHNa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Nov 2017 03:13:30 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Extended descriptor allocation has been changed by
commit dde20ae9d6383 ("crypto: caam - Change kmalloc to kzalloc to avoid residual data")
to provide zeroized memory, meaning we no longer have to sanitize
its members - edesc->src_nents and edesc->dst_dma.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamhash.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index f1bf563cb85b..27fe1a07050c 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -820,7 +820,6 @@ static int ahash_final_ctx(struct ahash_request *req)
 	desc = edesc->hw_desc;
 
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
-	edesc->src_nents = 0;
 
 	ret = ctx_map_to_sec4_sg(desc, jrdev, state, ctx->ctx_len,
 				 edesc->sec4_sg, DMA_TO_DEVICE);
@@ -1072,7 +1071,6 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 		dev_err(jrdev, "unable to map dst\n");
 		goto unmap;
 	}
-	edesc->src_nents = 0;
 
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "jobdesc@"__stringify(__LINE__)": ",
@@ -1154,7 +1152,6 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 
 		edesc->src_nents = src_nents;
 		edesc->sec4_sg_bytes = sec4_sg_bytes;
-		edesc->dst_dma = 0;
 
 		ret = buf_map_to_sec4_sg(jrdev, edesc->sec4_sg, state);
 		if (ret)
@@ -1366,7 +1363,6 @@ static int ahash_update_first(struct ahash_request *req)
 		}
 
 		edesc->src_nents = src_nents;
-		edesc->dst_dma = 0;
 
 		ret = ahash_edesc_add_src(ctx, edesc, req, mapped_nents, 0, 0,
 					  to_hash);
-- 
2.12.0.264.gd6db3f216544
