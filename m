From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH] crypto: caam - fix inconsistent assoc dma mapping direction
Date: Fri, 10 May 2013 15:08:39 +0300
Message-ID: <1368187719-6865-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	<stable@vger.kernel.org>,
	Kim Phillips <kim.phillips@freescale.com>,
	Vakul Garg <vakul@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

req->assoc is dma mapped BIDIRECTIONAL and unmapped TO_DEVICE.
Since it is read-only for the device, use TO_DEVICE both for mapping
and unmapping.

Cc: <stable@vger.kernel.org> # 3.9, 3.8
Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/caam/caamalg.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 42420fb..bf7da50 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1154,7 +1154,7 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 		dst_nents = sg_count(req->dst, req->cryptlen, &dst_chained);
 
 	sgc = dma_map_sg_chained(jrdev, req->assoc, assoc_nents ? : 1,
-				 DMA_BIDIRECTIONAL, assoc_chained);
+				 DMA_TO_DEVICE, assoc_chained);
 	if (likely(req->src == req->dst)) {
 		sgc = dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
 					 DMA_BIDIRECTIONAL, src_chained);
@@ -1336,7 +1336,7 @@ static struct aead_edesc *aead_giv_edesc_alloc(struct aead_givcrypt_request
 		dst_nents = sg_count(req->dst, req->cryptlen, &dst_chained);
 
 	sgc = dma_map_sg_chained(jrdev, req->assoc, assoc_nents ? : 1,
-				 DMA_BIDIRECTIONAL, assoc_chained);
+				 DMA_TO_DEVICE, assoc_chained);
 	if (likely(req->src == req->dst)) {
 		sgc = dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
 					 DMA_BIDIRECTIONAL, src_chained);
-- 
1.7.7.6
