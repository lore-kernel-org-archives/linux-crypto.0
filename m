From: Himanshu Jha <himanshujha199640@gmail.com>
Subject: [PATCH] crypto: Use zeroing memory allocator instead of allocator/memset
Date: Sun, 31 Dec 2017 17:54:23 +0530
Message-ID: <1514723063-5614-1-git-send-email-himanshujha199640@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Himanshu Jha <himanshujha199640@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:34413 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751067AbdLaMYk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 31 Dec 2017 07:24:40 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use dma_zalloc_coherent for allocating zeroed
memory and remove unnecessary memset function.

Done using Coccinelle.
Generated-by: scripts/coccinelle/api/alloc/kzalloc-simple.cocci
0-day tested with no failures.

Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 8 +++-----
 drivers/crypto/ixp4xx_crypto.c       | 7 +++----
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index c44954e..2cfc69d 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -275,14 +275,12 @@ static u32 crypto4xx_put_pd_to_pdr(struct crypto4xx_device *dev, u32 idx)
  */
 static u32 crypto4xx_build_gdr(struct crypto4xx_device *dev)
 {
-	dev->gdr = dma_alloc_coherent(dev->core_dev->device,
-				      sizeof(struct ce_gd) * PPC4XX_NUM_GD,
-				      &dev->gdr_pa, GFP_ATOMIC);
+	dev->gdr = dma_zalloc_coherent(dev->core_dev->device,
+				       sizeof(struct ce_gd) * PPC4XX_NUM_GD,
+				       &dev->gdr_pa, GFP_ATOMIC);
 	if (!dev->gdr)
 		return -ENOMEM;
 
-	memset(dev->gdr, 0, sizeof(struct ce_gd) * PPC4XX_NUM_GD);
-
 	return 0;
 }
 
diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 8705b28..717a266 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -260,12 +260,11 @@ static int setup_crypt_desc(void)
 {
 	struct device *dev = &pdev->dev;
 	BUILD_BUG_ON(sizeof(struct crypt_ctl) != 64);
-	crypt_virt = dma_alloc_coherent(dev,
-			NPE_QLEN * sizeof(struct crypt_ctl),
-			&crypt_phys, GFP_ATOMIC);
+	crypt_virt = dma_zalloc_coherent(dev,
+					 NPE_QLEN * sizeof(struct crypt_ctl),
+					 &crypt_phys, GFP_ATOMIC);
 	if (!crypt_virt)
 		return -ENOMEM;
-	memset(crypt_virt, 0, NPE_QLEN * sizeof(struct crypt_ctl));
 	return 0;
 }
 
-- 
2.7.4
