From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH 1/2] crypto: caam: remove dead code
Date: Wed, 21 Jan 2015 11:53:30 +0200
Message-ID: <1421834011-29565-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <horia.geanta@freescale.com>, <tudor.ambarus@freescale.com>,
	<alexandru.porosanu@freescale.com>,
	Cristian Stoica <cristian.stoica@freescale.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0146.outbound.protection.outlook.com ([157.56.110.146]:10944
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750938AbbAUJxz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Jan 2015 04:53:55 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

- assoc_nents and src_nents are never zero when all_contig is false
- iv_contig is zero on the else branch

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
Reviewed-by: Richard Schmitt <richard.schmitt@freescale.com>
---
 drivers/crypto/caam/caamalg.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 3187400..29071a1 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -2532,7 +2532,7 @@ static void init_ablkcipher_job(u32 *sh_desc, dma_addr_t ptr,
 		in_options = 0;
 	} else {
 		src_dma = edesc->sec4_sg_dma;
-		sec4_sg_index += (iv_contig ? 0 : 1) + edesc->src_nents;
+		sec4_sg_index += edesc->src_nents + 1;
 		in_options = LDST_SGF;
 	}
 	append_seq_in_ptr(desc, src_dma, req->nbytes + ivsize, in_options);
@@ -2714,10 +2714,10 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	if (!all_contig) {
 		if (!is_gcm) {
 			sg_to_sec4_sg(req->assoc,
-				      (assoc_nents ? : 1),
+				      assoc_nents,
 				      edesc->sec4_sg +
 				      sec4_sg_index, 0);
-			sec4_sg_index += assoc_nents ? : 1;
+			sec4_sg_index += assoc_nents;
 		}
 
 		dma_to_sec4_sg_one(edesc->sec4_sg + sec4_sg_index,
@@ -2726,17 +2726,17 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 
 		if (is_gcm) {
 			sg_to_sec4_sg(req->assoc,
-				      (assoc_nents ? : 1),
+				      assoc_nents,
 				      edesc->sec4_sg +
 				      sec4_sg_index, 0);
-			sec4_sg_index += assoc_nents ? : 1;
+			sec4_sg_index += assoc_nents;
 		}
 
 		sg_to_sec4_sg_last(req->src,
-				   (src_nents ? : 1),
+				   src_nents,
 				   edesc->sec4_sg +
 				   sec4_sg_index, 0);
-		sec4_sg_index += src_nents ? : 1;
+		sec4_sg_index += src_nents;
 	}
 	if (dst_nents) {
 		sg_to_sec4_sg_last(req->dst, dst_nents,
-- 
2.2.0
