From: Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/2] crypto: mediatek - remove redundant clock setting
Date: Fri, 26 May 2017 17:43:08 +0800
Message-ID: <1495791789-19230-1-git-send-email-ryder.lee@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>,
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
 linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

This patch removes redundant clock setting for 'clk_ethif', which is
the parent for 'clk_cryp'. Hence, we just need to handle its child.

Signed-off-by: Ryder Lee <ryder.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
---
 drivers/crypto/mediatek/mtk-platform.c | 10 +---------
 drivers/crypto/mediatek/mtk-platform.h |  2 --
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/crypto/mediatek/mtk-platform.c b/drivers/crypto/mediatek/mtk-platform.c
index b6ecc28..9b4437c 100644
--- a/drivers/crypto/mediatek/mtk-platform.c
+++ b/drivers/crypto/mediatek/mtk-platform.c
@@ -504,19 +504,14 @@ static int mtk_crypto_probe(struct platform_device *pdev)
 		}
 	}
 
-	cryp->clk_ethif = devm_clk_get(&pdev->dev, "ethif");
 	cryp->clk_cryp = devm_clk_get(&pdev->dev, "cryp");
-	if (IS_ERR(cryp->clk_ethif) || IS_ERR(cryp->clk_cryp))
+	if (IS_ERR(cryp->clk_cryp))
 		return -EPROBE_DEFER;
 
 	cryp->dev = &pdev->dev;
 	pm_runtime_enable(cryp->dev);
 	pm_runtime_get_sync(cryp->dev);
 
-	err = clk_prepare_enable(cryp->clk_ethif);
-	if (err)
-		goto err_clk_ethif;
-
 	err = clk_prepare_enable(cryp->clk_cryp);
 	if (err)
 		goto err_clk_cryp;
@@ -559,8 +554,6 @@ static int mtk_crypto_probe(struct platform_device *pdev)
 err_resource:
 	clk_disable_unprepare(cryp->clk_cryp);
 err_clk_cryp:
-	clk_disable_unprepare(cryp->clk_ethif);
-err_clk_ethif:
 	pm_runtime_put_sync(cryp->dev);
 	pm_runtime_disable(cryp->dev);
 
@@ -576,7 +569,6 @@ static int mtk_crypto_remove(struct platform_device *pdev)
 	mtk_desc_dma_free(cryp);
 
 	clk_disable_unprepare(cryp->clk_cryp);
-	clk_disable_unprepare(cryp->clk_ethif);
 
 	pm_runtime_put_sync(cryp->dev);
 	pm_runtime_disable(cryp->dev);
diff --git a/drivers/crypto/mediatek/mtk-platform.h b/drivers/crypto/mediatek/mtk-platform.h
index 303c152..f0831f1 100644
--- a/drivers/crypto/mediatek/mtk-platform.h
+++ b/drivers/crypto/mediatek/mtk-platform.h
@@ -200,7 +200,6 @@ struct mtk_sha_rec {
  * struct mtk_cryp - Cryptographic device
  * @base:	pointer to mapped register I/O base
  * @dev:	pointer to device
- * @clk_ethif:	pointer to ethif clock
  * @clk_cryp:	pointer to crypto clock
  * @irq:	global system and rings IRQ
  * @ring:	pointer to descriptor rings
@@ -215,7 +214,6 @@ struct mtk_sha_rec {
 struct mtk_cryp {
 	void __iomem *base;
 	struct device *dev;
-	struct clk *clk_ethif;
 	struct clk *clk_cryp;
 	int irq[MTK_IRQ_NUM];
 
-- 
1.9.1
