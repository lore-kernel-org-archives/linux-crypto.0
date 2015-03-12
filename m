From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5/6] hwrng: iproc-rng200 - do not use static structure
Date: Thu, 12 Mar 2015 14:00:06 -0700
Message-ID: <1426194007-22182-6-git-send-email-dmitry.torokhov@gmail.com>
References: <1426194007-22182-1-git-send-email-dmitry.torokhov@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:40473 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162AbbCLVAb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Mar 2015 17:00:31 -0400
In-Reply-To: <1426194007-22182-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Instead of using static hwrng structure that is reused between
binds/unbinds of the device let's embed it into driver's private
structure that we allocate. This way we are guaranteed not to stumble
onto something left from previous bind attempt.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/char/hw_random/iproc-rng200.c | 44 +++++++++++++++++------------------
 1 file changed, 21 insertions(+), 23 deletions(-)

diff --git a/drivers/char/hw_random/iproc-rng200.c b/drivers/char/hw_random/iproc-rng200.c
index 276cb8a..2dbaf5c 100644
--- a/drivers/char/hw_random/iproc-rng200.c
+++ b/drivers/char/hw_random/iproc-rng200.c
@@ -48,9 +48,12 @@
 #define RNG_FIFO_COUNT_RNG_FIFO_COUNT_MASK		0x000000FF
 
 struct iproc_rng200_dev {
-	void __iomem			*base;
+	struct hwrng rng;
+	void __iomem *base;
 };
 
+#define to_rng_priv(rng)	container_of(rng, struct iproc_rng200_dev, rng)
+
 static void iproc_rng200_restart(void __iomem *rng_base)
 {
 	uint32_t val;
@@ -89,11 +92,11 @@ static void iproc_rng200_restart(void __iomem *rng_base)
 }
 
 static int iproc_rng200_read(struct hwrng *rng, void *buf, size_t max,
-			       bool wait)
+			     bool wait)
 {
-	uint32_t status;
+	struct iproc_rng200_dev *priv = to_rng_priv(rng);
 	uint32_t num_remaining = max;
-	struct iproc_rng200_dev *priv = (struct iproc_rng200_dev *)rng->priv;
+	uint32_t status;
 
 	#define MAX_RESETS_PER_READ	1
 	uint32_t num_resets = 0;
@@ -151,10 +154,8 @@ static int iproc_rng200_read(struct hwrng *rng, void *buf, size_t max,
 
 static int iproc_rng200_init(struct hwrng *rng)
 {
+	struct iproc_rng200_dev *priv = to_rng_priv(rng);
 	uint32_t val;
-	struct iproc_rng200_dev *priv;
-
-	priv = (struct iproc_rng200_dev *)rng->priv;
 
 	/* Setup RNG. */
 	val = ioread32(priv->base + RNG_CTRL_OFFSET);
@@ -167,10 +168,8 @@ static int iproc_rng200_init(struct hwrng *rng)
 
 static void iproc_rng200_cleanup(struct hwrng *rng)
 {
+	struct iproc_rng200_dev *priv = to_rng_priv(rng);
 	uint32_t val;
-	struct iproc_rng200_dev *priv;
-
-	priv = (struct iproc_rng200_dev *)rng->priv;
 
 	/* Disable RNG hardware */
 	val = ioread32(priv->base + RNG_CTRL_OFFSET);
@@ -179,13 +178,6 @@ static void iproc_rng200_cleanup(struct hwrng *rng)
 	iowrite32(val, priv->base + RNG_CTRL_OFFSET);
 }
 
-static struct hwrng iproc_rng200_ops = {
-	.name		= "iproc-rng200",
-	.read		= iproc_rng200_read,
-	.init		= iproc_rng200_init,
-	.cleanup	= iproc_rng200_cleanup,
-};
-
 static int iproc_rng200_probe(struct platform_device *pdev)
 {
 	struct iproc_rng200_dev *priv;
@@ -193,13 +185,10 @@ static int iproc_rng200_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	int ret;
 
-	priv = devm_kzalloc(dev, sizeof(struct iproc_rng200_dev), GFP_KERNEL);
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
-	iproc_rng200_ops.priv = (unsigned long)priv;
-	platform_set_drvdata(pdev, priv);
-
 	/* Map peripheral */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
@@ -213,13 +202,20 @@ static int iproc_rng200_probe(struct platform_device *pdev)
 		return PTR_ERR(priv->base);
 	}
 
+	priv->rng.name = "iproc-rng200",
+	priv->rng.read = iproc_rng200_read,
+	priv->rng.init = iproc_rng200_init,
+	priv->rng.cleanup = iproc_rng200_cleanup,
+
 	/* Register driver */
-	ret = hwrng_register(&iproc_rng200_ops);
+	ret = hwrng_register(&priv->rng);
 	if (ret) {
 		dev_err(dev, "hwrng registration failed\n");
 		return ret;
 	}
 
+	platform_set_drvdata(pdev, priv);
+
 	dev_info(dev, "hwrng registered\n");
 
 	return 0;
@@ -227,8 +223,10 @@ static int iproc_rng200_probe(struct platform_device *pdev)
 
 static int iproc_rng200_remove(struct platform_device *pdev)
 {
+	struct iproc_rng200_dev *priv = platform_get_drvdata(pdev);
+
 	/* Unregister driver */
-	hwrng_unregister(&iproc_rng200_ops);
+	hwrng_unregister(&priv->rng);
 
 	return 0;
 }
-- 
2.2.0.rc0.207.ga3a616c
