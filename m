From: Marek Vasut <marex@denx.de>
Subject: [PATCH] crypto: mxs-dcp: Optimize hashing
Date: Mon,  3 Mar 2014 13:40:30 +0100
Message-ID: <1393850430-5855-1-git-send-email-marex@denx.de>
Cc: linux-crypto@vger.kernel.org, Marek Vasut <marex@denx.de>,
	"David S. Miller" <davem@davemloft.net>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Shawn Guo <shawn.guo@linaro.org>,
	Tom Lendacky <thomas.lendacky@amd.com>
To: linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:43563 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbaCCMku (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Mar 2014 07:40:50 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Optimize the hashing operation in the MXS-DCP by doing two adjustments:
1) Given that the output buffer for the hash is now always correctly aligned,
   we can just use the buffer for the DCP DMA to store the resulting hash.
   We thus get rid of one copying of data. Moreover, we remove an entry from
   dcp_coherent_block{} and thus lower the memory footprint of the driver.
2) We map the output buffer for the hash for DMA only in case we will output
   the hash, not always, as it was now.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/mxs-dcp.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index c7400fe..7bbe0ab 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -50,7 +50,6 @@ struct dcp_coherent_block {
 	uint8_t			sha_in_buf[DCP_BUF_SZ];
 
 	uint8_t			aes_key[2 * AES_KEYSIZE_128];
-	uint8_t			sha_digest[SHA256_DIGEST_SIZE];
 
 	struct dcp_dma_desc	desc[DCP_MAX_CHANS];
 };
@@ -516,13 +515,11 @@ static int mxs_dcp_run_sha(struct ahash_request *req)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct dcp_async_ctx *actx = crypto_ahash_ctx(tfm);
 	struct dcp_sha_req_ctx *rctx = ahash_request_ctx(req);
+	struct hash_alg_common *halg = crypto_hash_alg_common(tfm);
 
 	struct dcp_dma_desc *desc = &sdcp->coh->desc[actx->chan];
-	dma_addr_t digest_phys = dma_map_single(sdcp->dev,
-						sdcp->coh->sha_digest,
-						SHA256_DIGEST_SIZE,
-						DMA_FROM_DEVICE);
 
+	dma_addr_t digest_phys = 0;
 	dma_addr_t buf_phys = dma_map_single(sdcp->dev, sdcp->coh->sha_in_buf,
 					     DCP_BUF_SZ, DMA_TO_DEVICE);
 
@@ -543,14 +540,18 @@ static int mxs_dcp_run_sha(struct ahash_request *req)
 
 	/* Set HASH_TERM bit for last transfer block. */
 	if (rctx->fini) {
+		digest_phys = dma_map_single(sdcp->dev, req->result,
+					     halg->digestsize, DMA_FROM_DEVICE);
 		desc->control0 |= MXS_DCP_CONTROL0_HASH_TERM;
 		desc->payload = digest_phys;
 	}
 
 	ret = mxs_dcp_start_dma(actx);
 
-	dma_unmap_single(sdcp->dev, digest_phys, SHA256_DIGEST_SIZE,
-			 DMA_FROM_DEVICE);
+	if (rctx->fini)
+		dma_unmap_single(sdcp->dev, digest_phys, halg->digestsize,
+				 DMA_FROM_DEVICE);
+
 	dma_unmap_single(sdcp->dev, buf_phys, DCP_BUF_SZ, DMA_TO_DEVICE);
 
 	return ret;
@@ -567,7 +568,6 @@ static int dcp_sha_req_to_buf(struct crypto_async_request *arq)
 	struct hash_alg_common *halg = crypto_hash_alg_common(tfm);
 	const int nents = sg_nents(req->src);
 
-	uint8_t *digest = sdcp->coh->sha_digest;
 	uint8_t *in_buf = sdcp->coh->sha_in_buf;
 
 	uint8_t *src_buf;
@@ -614,14 +614,20 @@ static int dcp_sha_req_to_buf(struct crypto_async_request *arq)
 		rctx->fini = 1;
 
 		/* Submit whatever is left. */
+		if (!req->result)
+			return -EINVAL;
+
 		ret = mxs_dcp_run_sha(req);
-		if (ret || !req->result)
+		if (ret)
 			return ret;
+
 		actx->fill = 0;
 
 		/* For some reason, the result is flipped. */
-		for (i = 0; i < halg->digestsize; i++)
-			req->result[i] = digest[halg->digestsize - i - 1];
+		for (i = 0; i < halg->digestsize / 2; i++) {
+			swap(req->result[i],
+			     req->result[halg->digestsize - i - 1]);
+		}
 	}
 
 	return 0;
-- 
1.8.5.2
