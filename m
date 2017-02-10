From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 05/12] crypto: caam - check sg_count() return value
Date: Fri, 10 Feb 2017 14:07:18 +0200
Message-ID: <1486728445-13047-6-git-send-email-horia.geanta@nxp.com>
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
Received: from mail-sn1nam01on0057.outbound.protection.outlook.com ([104.47.32.57]:32433
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752339AbdBJMH7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Feb 2017 07:07:59 -0500
In-Reply-To: <1486728445-13047-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

sg_count() internally calls sg_nents_for_len(), which could fail
in case the required number of bytes is larger than the total
bytes in the S/G.

Thus, add checks to validate the input.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg.c | 44 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 05d4690351b9..ed8a04412767 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1335,13 +1335,31 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 
 	if (unlikely(req->dst != req->src)) {
 		src_nents = sg_count(req->src, req->assoclen + req->cryptlen);
+		if (unlikely(src_nents < 0)) {
+			dev_err(jrdev, "Insufficient bytes (%d) in src S/G\n",
+				req->assoclen + req->cryptlen);
+			return ERR_PTR(src_nents);
+		}
+
 		dst_nents = sg_count(req->dst,
 				     req->assoclen + req->cryptlen +
 					(encrypt ? authsize : (-authsize)));
+		if (unlikely(dst_nents < 0)) {
+			dev_err(jrdev, "Insufficient bytes (%d) in dst S/G\n",
+				req->assoclen + req->cryptlen +
+				(encrypt ? authsize : (-authsize)));
+			return ERR_PTR(dst_nents);
+		}
 	} else {
 		src_nents = sg_count(req->src,
 				     req->assoclen + req->cryptlen +
 					(encrypt ? authsize : 0));
+		if (unlikely(src_nents < 0)) {
+			dev_err(jrdev, "Insufficient bytes (%d) in src S/G\n",
+				req->assoclen + req->cryptlen +
+				(encrypt ? authsize : 0));
+			return ERR_PTR(src_nents);
+		}
 	}
 
 	/* Check if data are contiguous. */
@@ -1609,9 +1627,20 @@ static struct ablkcipher_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request
 	int sec4_sg_index;
 
 	src_nents = sg_count(req->src, req->nbytes);
+	if (unlikely(src_nents < 0)) {
+		dev_err(jrdev, "Insufficient bytes (%d) in src S/G\n",
+			req->nbytes);
+		return ERR_PTR(src_nents);
+	}
 
-	if (req->dst != req->src)
+	if (req->dst != req->src) {
 		dst_nents = sg_count(req->dst, req->nbytes);
+		if (unlikely(dst_nents < 0)) {
+			dev_err(jrdev, "Insufficient bytes (%d) in dst S/G\n",
+				req->nbytes);
+			return ERR_PTR(dst_nents);
+		}
+	}
 
 	if (likely(req->src == req->dst)) {
 		sgc = dma_map_sg(jrdev, req->src, src_nents ? : 1,
@@ -1807,6 +1836,11 @@ static struct ablkcipher_edesc *ablkcipher_giv_edesc_alloc(
 	int sec4_sg_index;
 
 	src_nents = sg_count(req->src, req->nbytes);
+	if (unlikely(src_nents < 0)) {
+		dev_err(jrdev, "Insufficient bytes (%d) in src S/G\n",
+			req->nbytes);
+		return ERR_PTR(src_nents);
+	}
 
 	if (likely(req->src == req->dst)) {
 		sgc = dma_map_sg(jrdev, req->src, src_nents ? : 1,
@@ -1826,6 +1860,12 @@ static struct ablkcipher_edesc *ablkcipher_giv_edesc_alloc(
 		}
 
 		dst_nents = sg_count(req->dst, req->nbytes);
+		if (unlikely(dst_nents < 0)) {
+			dev_err(jrdev, "Insufficient bytes (%d) in dst S/G\n",
+				req->nbytes);
+			return ERR_PTR(dst_nents);
+		}
+
 		sgc = dma_map_sg(jrdev, req->dst, dst_nents ? : 1,
 				 DMA_FROM_DEVICE);
 		if (unlikely(!sgc)) {
@@ -1914,7 +1954,7 @@ static int ablkcipher_givencrypt(struct skcipher_givcrypt_request *creq)
 	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
 	struct caam_ctx *ctx = crypto_ablkcipher_ctx(ablkcipher);
 	struct device *jrdev = ctx->jrdev;
-	bool iv_contig;
+	bool iv_contig = false;
 	u32 *desc;
 	int ret = 0;
 
-- 
2.4.4
