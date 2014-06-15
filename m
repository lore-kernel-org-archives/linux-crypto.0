From: Joe Perches <joe@perches.com>
Subject: [PATCH -next 05/26] crypto: Use dma_zalloc_coherent
Date: Sun, 15 Jun 2014 13:37:34 -0700
Message-ID: <7fe501fdc5705074b8d881a31a099f9f9275cc04.1402863905.git.joe@perches.com>
References: <cover.1402863904.git.joe@perches.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1402863904.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 8 +++-----
 drivers/crypto/ixp4xx_crypto.c       | 8 ++++----
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 37f9cc9..d3da537 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -304,14 +304,12 @@ static struct ce_pd *crypto4xx_get_pdp(struct crypto4xx_device *dev,
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
index f757a0f..0a32d7c 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -251,12 +251,12 @@ static int setup_crypt_desc(void)
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
+
 	return 0;
 }
 
-- 
1.8.1.2.459.gbcd45b4.dirty
