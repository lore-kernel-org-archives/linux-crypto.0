Return-Path: <SRS0=98p2=P6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 927DFC282C3
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 14:47:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C59F21019
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 14:47:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728778AbfAVOr3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Jan 2019 09:47:29 -0500
Received: from inva021.nxp.com ([92.121.34.21]:52848 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728642AbfAVOr3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Jan 2019 09:47:29 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 3248E20019F;
        Tue, 22 Jan 2019 15:47:27 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 2484920009D;
        Tue, 22 Jan 2019 15:47:27 +0100 (CET)
Received: from enigma.ea.freescale.net (enigma.ea.freescale.net [10.171.81.110])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id CCF4520600;
        Tue, 22 Jan 2019 15:47:26 +0100 (CET)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org, linux-imx <linux-imx@nxp.com>
Subject: [PATCH] crypto: caam - handle zero-length AEAD output
Date:   Tue, 22 Jan 2019 16:47:01 +0200
Message-Id: <20190122144701.22967-1-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.16.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Recent AEAD changes in testmgr framework introduced by commit
a0d608ee5ebf ("crypto: testmgr - unify the AEAD encryption and decryption test vectors")
uncovered an error in the CAAM drivers, since they don't correctly
handle the case when AEAD output length is zero.

Add checks to avoid feeding zero-length req->dst to DMA API.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg.c     | 26 ++++++++++++++++++--------
 drivers/crypto/caam/caamalg_qi.c  | 23 +++++++++++++++--------
 drivers/crypto/caam/caamalg_qi2.c | 22 ++++++++++++++--------
 3 files changed, 47 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 80ae69f906fb..0a4469fcd192 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -846,7 +846,8 @@ static void caam_unmap(struct device *dev, struct scatterlist *src,
 	if (dst != src) {
 		if (src_nents)
 			dma_unmap_sg(dev, src, src_nents, DMA_TO_DEVICE);
-		dma_unmap_sg(dev, dst, dst_nents, DMA_FROM_DEVICE);
+		if (dst_nents)
+			dma_unmap_sg(dev, dst, dst_nents, DMA_FROM_DEVICE);
 	} else {
 		dma_unmap_sg(dev, src, src_nents, DMA_BIDIRECTIONAL);
 	}
@@ -1038,7 +1039,9 @@ static void init_aead_job(struct aead_request *req,
 	out_options = in_options;
 
 	if (unlikely(req->src != req->dst)) {
-		if (edesc->dst_nents == 1) {
+		if (!edesc->dst_nents) {
+			dst_dma = 0;
+		} else if (edesc->dst_nents == 1) {
 			dst_dma = sg_dma_address(req->dst);
 		} else {
 			dst_dma = edesc->sec4_sg_dma +
@@ -1289,12 +1292,19 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 			mapped_src_nents = 0;
 		}
 
-		mapped_dst_nents = dma_map_sg(jrdev, req->dst, dst_nents,
-					      DMA_FROM_DEVICE);
-		if (unlikely(!mapped_dst_nents)) {
-			dev_err(jrdev, "unable to map destination\n");
-			dma_unmap_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
-			return ERR_PTR(-ENOMEM);
+		/* Cover also the case of null (zero length) output data */
+		if (dst_nents) {
+			mapped_dst_nents = dma_map_sg(jrdev, req->dst,
+						      dst_nents,
+						      DMA_FROM_DEVICE);
+			if (unlikely(!mapped_dst_nents)) {
+				dev_err(jrdev, "unable to map destination\n");
+				dma_unmap_sg(jrdev, req->src, src_nents,
+					     DMA_TO_DEVICE);
+				return ERR_PTR(-ENOMEM);
+			}
+		} else {
+			mapped_dst_nents = 0;
 		}
 	}
 
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index c0d55310aade..7bce97884663 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -802,7 +802,8 @@ static void caam_unmap(struct device *dev, struct scatterlist *src,
 	if (dst != src) {
 		if (src_nents)
 			dma_unmap_sg(dev, src, src_nents, DMA_TO_DEVICE);
-		dma_unmap_sg(dev, dst, dst_nents, DMA_FROM_DEVICE);
+		if (dst_nents)
+			dma_unmap_sg(dev, dst, dst_nents, DMA_FROM_DEVICE);
 	} else {
 		dma_unmap_sg(dev, src, src_nents, DMA_BIDIRECTIONAL);
 	}
@@ -955,13 +956,19 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 			mapped_src_nents = 0;
 		}
 
-		mapped_dst_nents = dma_map_sg(qidev, req->dst, dst_nents,
-					      DMA_FROM_DEVICE);
-		if (unlikely(!mapped_dst_nents)) {
-			dev_err(qidev, "unable to map destination\n");
-			dma_unmap_sg(qidev, req->src, src_nents, DMA_TO_DEVICE);
-			qi_cache_free(edesc);
-			return ERR_PTR(-ENOMEM);
+		if (dst_nents) {
+			mapped_dst_nents = dma_map_sg(qidev, req->dst,
+						      dst_nents,
+						      DMA_FROM_DEVICE);
+			if (unlikely(!mapped_dst_nents)) {
+				dev_err(qidev, "unable to map destination\n");
+				dma_unmap_sg(qidev, req->src, src_nents,
+					     DMA_TO_DEVICE);
+				qi_cache_free(edesc);
+				return ERR_PTR(-ENOMEM);
+			}
+		} else {
+			mapped_dst_nents = 0;
 		}
 	}
 
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index cc59814afd29..4bea4f1beac9 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -144,7 +144,8 @@ static void caam_unmap(struct device *dev, struct scatterlist *src,
 	if (dst != src) {
 		if (src_nents)
 			dma_unmap_sg(dev, src, src_nents, DMA_TO_DEVICE);
-		dma_unmap_sg(dev, dst, dst_nents, DMA_FROM_DEVICE);
+		if (dst_nents)
+			dma_unmap_sg(dev, dst, dst_nents, DMA_FROM_DEVICE);
 	} else {
 		dma_unmap_sg(dev, src, src_nents, DMA_BIDIRECTIONAL);
 	}
@@ -385,13 +386,18 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 			mapped_src_nents = 0;
 		}
 
-		mapped_dst_nents = dma_map_sg(dev, req->dst, dst_nents,
-					      DMA_FROM_DEVICE);
-		if (unlikely(!mapped_dst_nents)) {
-			dev_err(dev, "unable to map destination\n");
-			dma_unmap_sg(dev, req->src, src_nents, DMA_TO_DEVICE);
-			qi_cache_free(edesc);
-			return ERR_PTR(-ENOMEM);
+		if (dst_nents) {
+			mapped_dst_nents = dma_map_sg(dev, req->dst, dst_nents,
+						      DMA_FROM_DEVICE);
+			if (unlikely(!mapped_dst_nents)) {
+				dev_err(dev, "unable to map destination\n");
+				dma_unmap_sg(dev, req->src, src_nents,
+					     DMA_TO_DEVICE);
+				qi_cache_free(edesc);
+				return ERR_PTR(-ENOMEM);
+			}
+		} else {
+			mapped_dst_nents = 0;
 		}
 	} else {
 		src_nents = sg_nents_for_len(req->src, req->assoclen +
-- 
2.16.2

