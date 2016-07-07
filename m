From: Salvatore Benedetto <salvatore.benedetto@intel.com>
Subject: [PATCH] crypto: qat - Stop dropping leading zeros from RSA output
Date: Thu,  7 Jul 2016 15:52:17 +0100
Message-ID: <1467903137-2110-1-git-send-email-salvatore.benedetto@intel.com>
Cc: salvatore.benedetto@intel.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:20469 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbcGGOwX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 7 Jul 2016 10:52:23 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

There is not need to drop leading zeros from the RSA output
operations results.

Signed-off-by: Salvatore Benedetto <salvatore.benedetto@intel.com>
---
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 3d56fb8..0d35dca 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -571,32 +571,12 @@ static void qat_rsa_cb(struct icp_qat_fw_pke_resp *resp)
 
 	areq->dst_len = req->ctx.rsa->key_sz;
 	if (req->dst_align) {
-		char *ptr = req->dst_align;
-
-		while (!(*ptr) && areq->dst_len) {
-			areq->dst_len--;
-			ptr++;
-		}
-
-		if (areq->dst_len != req->ctx.rsa->key_sz)
-			memmove(req->dst_align, ptr, areq->dst_len);
-
 		scatterwalk_map_and_copy(req->dst_align, areq->dst, 0,
 					 areq->dst_len, 1);
 
 		dma_free_coherent(dev, req->ctx.rsa->key_sz, req->dst_align,
 				  req->out.rsa.enc.c);
 	} else {
-		char *ptr = sg_virt(areq->dst);
-
-		while (!(*ptr) && areq->dst_len) {
-			areq->dst_len--;
-			ptr++;
-		}
-
-		if (sg_virt(areq->dst) != ptr && areq->dst_len)
-			memmove(sg_virt(areq->dst), ptr, areq->dst_len);
-
 		dma_unmap_single(dev, req->out.rsa.enc.c, req->ctx.rsa->key_sz,
 				 DMA_FROM_DEVICE);
 	}
-- 
2.7.4
