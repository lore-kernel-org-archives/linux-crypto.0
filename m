From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/2] crypto: s5p-sss - Remove useless hash interrupt handler
Date: Tue, 19 Apr 2016 15:44:12 +0200
Message-ID: <1461073452-10426-2-git-send-email-k.kozlowski@samsung.com>
References: <1461073452-10426-1-git-send-email-k.kozlowski@samsung.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Vladimir Zapolskiy <vz@mleia.com>, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1461073452-10426-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Beside regular feed control interrupt, the driver requires also hash
interrupt for older SoCs (samsung,s5pv210-secss). However after
requesting it, the interrupt handler isn't doing anything with it, not
even clearing the hash interrupt bit.

Driver does not provide hash functions so it is safe to remove the hash
interrupt related code and to not require the interrupt in Device Tree.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 .../devicetree/bindings/crypto/samsung-sss.txt     |  6 ++--
 drivers/crypto/s5p-sss.c                           | 34 ++++------------------
 2 files changed, 8 insertions(+), 32 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/samsung-sss.txt b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
index a6dafa83c6df..7a5ca56683cc 100644
--- a/Documentation/devicetree/bindings/crypto/samsung-sss.txt
+++ b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
@@ -23,10 +23,8 @@ Required properties:
   - "samsung,exynos4210-secss" for Exynos4210, Exynos4212, Exynos4412, Exynos5250,
 		Exynos5260 and Exynos5420 SoCs.
 - reg : Offset and length of the register set for the module
-- interrupts : interrupt specifiers of SSS module interrupts, should contain
-		following entries:
-		- first : feed control interrupt (required for all variants),
-		- second : hash interrupt (required only for samsung,s5pv210-secss).
+- interrupts : interrupt specifiers of SSS module interrupts (one feed
+		control interrupt).
 
 - clocks : list of clock phandle and specifier pairs for all clocks  listed in
 		clock-names property.
diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index b0484d4d68d9..71ca6a5d636d 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -149,7 +149,6 @@
 
 /**
  * struct samsung_aes_variant - platform specific SSS driver data
- * @has_hash_irq: true if SSS module uses hash interrupt, false otherwise
  * @aes_offset: AES register offset from SSS module's base.
  *
  * Specifies platform specific configuration of SSS module.
@@ -157,7 +156,6 @@
  * expansion of its usage.
  */
 struct samsung_aes_variant {
-	bool			    has_hash_irq;
 	unsigned int		    aes_offset;
 };
 
@@ -178,7 +176,6 @@ struct s5p_aes_dev {
 	struct clk                 *clk;
 	void __iomem               *ioaddr;
 	void __iomem               *aes_ioaddr;
-	int                         irq_hash;
 	int                         irq_fc;
 
 	struct ablkcipher_request  *req;
@@ -201,12 +198,10 @@ struct s5p_aes_dev {
 static struct s5p_aes_dev *s5p_dev;
 
 static const struct samsung_aes_variant s5p_aes_data = {
-	.has_hash_irq	= true,
 	.aes_offset	= 0x4000,
 };
 
 static const struct samsung_aes_variant exynos_aes_data = {
-	.has_hash_irq	= false,
 	.aes_offset	= 0x200,
 };
 
@@ -421,15 +416,13 @@ static irqreturn_t s5p_aes_interrupt(int irq, void *dev_id)
 
 	spin_lock_irqsave(&dev->lock, flags);
 
-	if (irq == dev->irq_fc) {
-		status = SSS_READ(dev, FCINTSTAT);
-		if (status & SSS_FCINTSTAT_BRDMAINT)
-			s5p_aes_rx(dev);
-		if (status & SSS_FCINTSTAT_BTDMAINT)
-			s5p_aes_tx(dev);
+	status = SSS_READ(dev, FCINTSTAT);
+	if (status & SSS_FCINTSTAT_BRDMAINT)
+		s5p_aes_rx(dev);
+	if (status & SSS_FCINTSTAT_BTDMAINT)
+		s5p_aes_tx(dev);
 
-		SSS_WRITE(dev, FCINTPEND, status);
-	}
+	SSS_WRITE(dev, FCINTPEND, status);
 
 	spin_unlock_irqrestore(&dev->lock, flags);
 
@@ -795,21 +788,6 @@ static int s5p_aes_probe(struct platform_device *pdev)
 		goto err_irq;
 	}
 
-	if (variant->has_hash_irq) {
-		pdata->irq_hash = platform_get_irq(pdev, 1);
-		if (pdata->irq_hash < 0) {
-			err = pdata->irq_hash;
-			dev_warn(dev, "hash interrupt is not available.\n");
-			goto err_irq;
-		}
-		err = devm_request_irq(dev, pdata->irq_hash, s5p_aes_interrupt,
-				       IRQF_SHARED, pdev->name, pdev);
-		if (err < 0) {
-			dev_warn(dev, "hash interrupt is not available.\n");
-			goto err_irq;
-		}
-	}
-
 	pdata->busy = false;
 	pdata->variant = variant;
 	pdata->dev = dev;
-- 
1.9.1
