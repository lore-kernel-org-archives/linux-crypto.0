From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH] crypto: caam/qi - use correct print specifier for size_t
Date: Tue, 28 Nov 2017 18:48:08 +0200
Message-ID: <20171128164808.19363-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam03on0072.outbound.protection.outlook.com ([104.47.42.72]:48597
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753001AbdK1QsT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Nov 2017 11:48:19 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix below warnings on ARMv7 by using %zu for printing size_t values:

drivers/crypto/caam/caamalg_qi.c: In function aead_edesc_alloc:
drivers/crypto/caam/caamalg_qi.c:417:17: warning: format %lu expects argument of type long unsigned int, but argument 4 has type unsigned int [-Wformat=]
   sizeof(struct qm_sg_entry))
                 ^
drivers/crypto/caam/caamalg_qi.c:672:16: note: in expansion of macro CAAM_QI_MAX_AEAD_SG
    qm_sg_ents, CAAM_QI_MAX_AEAD_SG);
                ^
drivers/crypto/caam/caamalg_qi.c: In function ablkcipher_edesc_alloc:
drivers/crypto/caam/caamalg_qi.c:440:17: warning: format %lu expects argument of type long unsigned int, but argument 4 has type unsigned int [-Wformat=]
   sizeof(struct qm_sg_entry))
                 ^
drivers/crypto/caam/caamalg_qi.c:909:16: note: in expansion of macro CAAM_QI_MAX_ABLKCIPHER_SG
    qm_sg_ents, CAAM_QI_MAX_ABLKCIPHER_SG);
                ^
drivers/crypto/caam/caamalg_qi.c: In function ablkcipher_giv_edesc_alloc:
drivers/crypto/caam/caamalg_qi.c:440:17: warning: format %lu expects argument of type long unsigned int, but argument 4 has type unsigned int [-Wformat=]
   sizeof(struct qm_sg_entry))
                 ^
drivers/crypto/caam/caamalg_qi.c:1062:16: note: in expansion of macro CAAM_QI_MAX_ABLKCIPHER_SG
    qm_sg_ents, CAAM_QI_MAX_ABLKCIPHER_SG);
                ^

Fixes: eb9ba37dc15a ("crypto: caam/qi - handle large number of S/Gs case")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg_qi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index f9f08fce4356..ad14b69a052e 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -668,7 +668,7 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	qm_sg_ents = 1 + !!ivsize + mapped_src_nents +
 		     (mapped_dst_nents > 1 ? mapped_dst_nents : 0);
 	if (unlikely(qm_sg_ents > CAAM_QI_MAX_AEAD_SG)) {
-		dev_err(qidev, "Insufficient S/G entries: %d > %lu\n",
+		dev_err(qidev, "Insufficient S/G entries: %d > %zu\n",
 			qm_sg_ents, CAAM_QI_MAX_AEAD_SG);
 		caam_unmap(qidev, req->src, req->dst, src_nents, dst_nents,
 			   iv_dma, ivsize, op_type, 0, 0);
@@ -905,7 +905,7 @@ static struct ablkcipher_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request
 
 	qm_sg_ents += mapped_dst_nents > 1 ? mapped_dst_nents : 0;
 	if (unlikely(qm_sg_ents > CAAM_QI_MAX_ABLKCIPHER_SG)) {
-		dev_err(qidev, "Insufficient S/G entries: %d > %lu\n",
+		dev_err(qidev, "Insufficient S/G entries: %d > %zu\n",
 			qm_sg_ents, CAAM_QI_MAX_ABLKCIPHER_SG);
 		caam_unmap(qidev, req->src, req->dst, src_nents, dst_nents,
 			   iv_dma, ivsize, op_type, 0, 0);
@@ -1058,7 +1058,7 @@ static struct ablkcipher_edesc *ablkcipher_giv_edesc_alloc(
 	}
 
 	if (unlikely(qm_sg_ents > CAAM_QI_MAX_ABLKCIPHER_SG)) {
-		dev_err(qidev, "Insufficient S/G entries: %d > %lu\n",
+		dev_err(qidev, "Insufficient S/G entries: %d > %zu\n",
 			qm_sg_ents, CAAM_QI_MAX_ABLKCIPHER_SG);
 		caam_unmap(qidev, req->src, req->dst, src_nents, dst_nents,
 			   iv_dma, ivsize, GIVENCRYPT, 0, 0);
-- 
2.12.0.264.gd6db3f216544
