From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 04/12] crypto: caam - fix HW S/G in ablkcipher_giv_edesc_alloc()
Date: Fri, 10 Feb 2017 14:07:17 +0200
Message-ID: <1486728445-13047-5-git-send-email-horia.geanta@nxp.com>
References: <1486728445-13047-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Dan Douglass <dan.douglass@nxp.com>,
        Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
        "Cristian Stoica" <cristian.stoica@nxp.com>,
        <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-co1nam03on0079.outbound.protection.outlook.com ([104.47.40.79]:3104
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753358AbdBJMID (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Feb 2017 07:08:03 -0500
In-Reply-To: <1486728445-13047-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

HW S/G generation does not work properly when the following conditions
are met:
-src == dst
-src/dst is S/G
-IV is right before (contiguous with) the first src/dst S/G entry
since "iv_contig" is set to true (iv_contig is a misnomer here and
it actually refers to the whole output being contiguous)

Fix this by setting dst S/G nents equal to src S/G nents, instead of
leaving it set to init value (0).

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 662fe94cb2f8..05d4690351b9 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1798,7 +1798,7 @@ static struct ablkcipher_edesc *ablkcipher_giv_edesc_alloc(
 	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
 					  CRYPTO_TFM_REQ_MAY_SLEEP)) ?
 		       GFP_KERNEL : GFP_ATOMIC;
-	int src_nents, dst_nents = 0, sec4_sg_bytes;
+	int src_nents, dst_nents, sec4_sg_bytes;
 	struct ablkcipher_edesc *edesc;
 	dma_addr_t iv_dma = 0;
 	bool iv_contig = false;
@@ -1808,9 +1808,6 @@ static struct ablkcipher_edesc *ablkcipher_giv_edesc_alloc(
 
 	src_nents = sg_count(req->src, req->nbytes);
 
-	if (unlikely(req->dst != req->src))
-		dst_nents = sg_count(req->dst, req->nbytes);
-
 	if (likely(req->src == req->dst)) {
 		sgc = dma_map_sg(jrdev, req->src, src_nents ? : 1,
 				 DMA_BIDIRECTIONAL);
@@ -1818,6 +1815,8 @@ static struct ablkcipher_edesc *ablkcipher_giv_edesc_alloc(
 			dev_err(jrdev, "unable to map source\n");
 			return ERR_PTR(-ENOMEM);
 		}
+
+		dst_nents = src_nents;
 	} else {
 		sgc = dma_map_sg(jrdev, req->src, src_nents ? : 1,
 				 DMA_TO_DEVICE);
@@ -1826,6 +1825,7 @@ static struct ablkcipher_edesc *ablkcipher_giv_edesc_alloc(
 			return ERR_PTR(-ENOMEM);
 		}
 
+		dst_nents = sg_count(req->dst, req->nbytes);
 		sgc = dma_map_sg(jrdev, req->dst, dst_nents ? : 1,
 				 DMA_FROM_DEVICE);
 		if (unlikely(!sgc)) {
-- 
2.4.4
