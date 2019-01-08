Return-Path: <SRS0=aDvo=PQ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:41849 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727435AbfAHG4t (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Jan 2019 01:56:49 -0500
Message-Id: <5ed91db5e2976a4c260465c3d027acc9affd2d2b.1545445924.git.christophe.leroy@c-s.fr>
From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v4 1/2] crypto: talitos - reorder code in
 talitos_edesc_alloc()
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Horia Geanta <horia.geanta@nxp.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
Date: Tue,  8 Jan 2019 06:56:46 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch moves the mapping of IV after the kmalloc(). This
avoids having to unmap in case kmalloc() fails.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 new in v4

 drivers/crypto/talitos.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 45e20707cef8..54d80e7edb86 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1361,23 +1361,18 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
 	int max_len = is_sec1 ? TALITOS1_MAX_DATA_LEN : TALITOS2_MAX_DATA_LEN;
-	void *err;
 
 	if (cryptlen + authsize > max_len) {
 		dev_err(dev, "length exceeds h/w max limit\n");
 		return ERR_PTR(-EINVAL);
 	}
 
-	if (ivsize)
-		iv_dma = dma_map_single(dev, iv, ivsize, DMA_TO_DEVICE);
-
 	if (!dst || dst == src) {
 		src_len = assoclen + cryptlen + authsize;
 		src_nents = sg_nents_for_len(src, src_len);
 		if (src_nents < 0) {
 			dev_err(dev, "Invalid number of src SG.\n");
-			err = ERR_PTR(-EINVAL);
-			goto error_sg;
+			return ERR_PTR(-EINVAL);
 		}
 		src_nents = (src_nents == 1) ? 0 : src_nents;
 		dst_nents = dst ? src_nents : 0;
@@ -1387,16 +1382,14 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 		src_nents = sg_nents_for_len(src, src_len);
 		if (src_nents < 0) {
 			dev_err(dev, "Invalid number of src SG.\n");
-			err = ERR_PTR(-EINVAL);
-			goto error_sg;
+			return ERR_PTR(-EINVAL);
 		}
 		src_nents = (src_nents == 1) ? 0 : src_nents;
 		dst_len = assoclen + cryptlen + (encrypt ? authsize : 0);
 		dst_nents = sg_nents_for_len(dst, dst_len);
 		if (dst_nents < 0) {
 			dev_err(dev, "Invalid number of dst SG.\n");
-			err = ERR_PTR(-EINVAL);
-			goto error_sg;
+			return ERR_PTR(-EINVAL);
 		}
 		dst_nents = (dst_nents == 1) ? 0 : dst_nents;
 	}
@@ -1425,10 +1418,10 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 		alloc_len += sizeof(struct talitos_desc);
 
 	edesc = kmalloc(alloc_len, GFP_DMA | flags);
-	if (!edesc) {
-		err = ERR_PTR(-ENOMEM);
-		goto error_sg;
-	}
+	if (!edesc)
+		return ERR_PTR(-ENOMEM);
+	if (ivsize)
+		iv_dma = dma_map_single(dev, iv, ivsize, DMA_TO_DEVICE);
 	memset(&edesc->desc, 0, sizeof(edesc->desc));
 
 	edesc->src_nents = src_nents;
@@ -1445,10 +1438,6 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 						     DMA_BIDIRECTIONAL);
 	}
 	return edesc;
-error_sg:
-	if (iv_dma)
-		dma_unmap_single(dev, iv_dma, ivsize, DMA_TO_DEVICE);
-	return err;
 }
 
 static struct talitos_edesc *aead_edesc_alloc(struct aead_request *areq, u8 *iv,
-- 
2.13.3
