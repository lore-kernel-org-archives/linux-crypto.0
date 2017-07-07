From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 06/13] crypto: caam/qi - fix AD length endianness in S/G entry
Date: Fri, 7 Jul 2017 16:05:16 +0300
Message-ID: <20170707130523.32427-7-horia.geanta@nxp.com>
References: <20170707130523.32427-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        Dan Douglass <dan.douglass@nxp.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-cys01nam02on0079.outbound.protection.outlook.com ([104.47.37.79]:40304
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751850AbdGGNF5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Jul 2017 09:05:57 -0400
In-Reply-To: <20170707130523.32427-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Associated data (AD) length is read by CAAM from an S/G entry
that is initially filled by the GPP.
Accordingly, AD length has to be stored in CAAM endianness.

Fixes: b189817cf789 ("crypto: caam/qi - add ablkcipher and authenc algorithms")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg_qi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 4ec8823ccc1a..e84c1949d9a4 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -399,6 +399,7 @@ static int xts_ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
  * @iv_dma: dma address of iv for checking continuity and link table
  * @qm_sg_bytes: length of dma mapped h/w link table
  * @qm_sg_dma: bus physical mapped address of h/w link table
+ * @assoclen: associated data length, in CAAM endianness
  * @assoclen_dma: bus physical mapped address of req->assoclen
  * @drv_req: driver-specific request structure
  * @sgt: the h/w link table
@@ -409,6 +410,7 @@ struct aead_edesc {
 	dma_addr_t iv_dma;
 	int qm_sg_bytes;
 	dma_addr_t qm_sg_dma;
+	unsigned int assoclen;
 	dma_addr_t assoclen_dma;
 	struct caam_drv_req drv_req;
 #define CAAM_QI_MAX_AEAD_SG						\
@@ -684,7 +686,8 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	edesc->drv_req.cbk = aead_done;
 	edesc->drv_req.drv_ctx = drv_ctx;
 
-	edesc->assoclen_dma = dma_map_single(qidev, &req->assoclen, 4,
+	edesc->assoclen = cpu_to_caam32(req->assoclen);
+	edesc->assoclen_dma = dma_map_single(qidev, &edesc->assoclen, 4,
 					     DMA_TO_DEVICE);
 	if (dma_mapping_error(qidev, edesc->assoclen_dma)) {
 		dev_err(qidev, "unable to map assoclen\n");
-- 
2.12.0.264.gd6db3f216544
