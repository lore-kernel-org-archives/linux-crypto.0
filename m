From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 14/14] crypto: caam - merge identical ahash_final/finup shared desc
Date: Wed, 9 Nov 2016 10:46:24 +0200
Message-ID: <1478681184-9442-15-git-send-email-horia.geanta@nxp.com>
References: <1478681184-9442-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn3nam01on0084.outbound.protection.outlook.com ([104.47.33.84]:64495
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752558AbcKIJWE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Nov 2016 04:22:04 -0500
In-Reply-To: <1478681184-9442-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Shared descriptors used by ahash_final() and ahash_finup()
are identical, thus get rid of one of them (sh_desc_finup).

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamhash.c | 26 +-------------------------
 1 file changed, 1 insertion(+), 25 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index d5a06c6923c0..86f360853502 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -103,12 +103,10 @@ struct caam_hash_ctx {
 	u32 sh_desc_update_first[DESC_HASH_MAX_USED_LEN] ____cacheline_aligned;
 	u32 sh_desc_fin[DESC_HASH_MAX_USED_LEN] ____cacheline_aligned;
 	u32 sh_desc_digest[DESC_HASH_MAX_USED_LEN] ____cacheline_aligned;
-	u32 sh_desc_finup[DESC_HASH_MAX_USED_LEN] ____cacheline_aligned;
 	dma_addr_t sh_desc_update_dma ____cacheline_aligned;
 	dma_addr_t sh_desc_update_first_dma;
 	dma_addr_t sh_desc_fin_dma;
 	dma_addr_t sh_desc_digest_dma;
-	dma_addr_t sh_desc_finup_dma;
 	struct device *jrdev;
 	u32 alg_type;
 	u32 alg_op;
@@ -380,24 +378,6 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
 		       desc_bytes(desc), 1);
 #endif
 
-	/* ahash_finup shared descriptor */
-	desc = ctx->sh_desc_finup;
-
-	ahash_ctx_data_to_out(desc, have_key | ctx->alg_type,
-			      OP_ALG_AS_FINALIZE, digestsize, ctx);
-
-	ctx->sh_desc_finup_dma = dma_map_single(jrdev, desc, desc_bytes(desc),
-						DMA_TO_DEVICE);
-	if (dma_mapping_error(jrdev, ctx->sh_desc_finup_dma)) {
-		dev_err(jrdev, "unable to map shared descriptor\n");
-		return -ENOMEM;
-	}
-#ifdef DEBUG
-	print_hex_dump(KERN_ERR, "ahash finup shdesc@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, desc,
-		       desc_bytes(desc), 1);
-#endif
-
 	/* ahash_digest shared descriptor */
 	desc = ctx->sh_desc_digest;
 
@@ -1071,7 +1051,7 @@ static int ahash_finup_ctx(struct ahash_request *req)
 
 	/* allocate space for base edesc and hw desc commands, link tables */
 	edesc = ahash_edesc_alloc(ctx, sec4_sg_src_index + mapped_nents,
-				  ctx->sh_desc_finup, ctx->sh_desc_finup_dma,
+				  ctx->sh_desc_fin, ctx->sh_desc_fin_dma,
 				  flags);
 	if (!edesc) {
 		dma_unmap_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
@@ -1886,10 +1866,6 @@ static void caam_hash_cra_exit(struct crypto_tfm *tfm)
 		dma_unmap_single(ctx->jrdev, ctx->sh_desc_digest_dma,
 				 desc_bytes(ctx->sh_desc_digest),
 				 DMA_TO_DEVICE);
-	if (ctx->sh_desc_finup_dma &&
-	    !dma_mapping_error(ctx->jrdev, ctx->sh_desc_finup_dma))
-		dma_unmap_single(ctx->jrdev, ctx->sh_desc_finup_dma,
-				 desc_bytes(ctx->sh_desc_finup), DMA_TO_DEVICE);
 
 	caam_jr_free(ctx->jrdev);
 }
-- 
2.4.4
