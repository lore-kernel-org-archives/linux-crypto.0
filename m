From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Subject: [PATCH 2/6 v2] crypto:s5p-sss: Add device tree support
Date: Thu, 09 Jan 2014 10:29:01 +0530
Message-ID: <1389243541-13122-1-git-send-email-ch.naveen@samsung.com>
References: <1389095509-14357-3-git-send-email-ch.naveen@samsung.com>
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
	herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
	cpgs@samsung.com, tomasz.figa@gmail.com,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-reply-to: <1389095509-14357-3-git-send-email-ch.naveen@samsung.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch adds device tree support to the s5p-sss.c crypto driver.
Implements a varient struct to address the changes in SSS hardware
on various SoCs from Samsung.

Also, Documentation under devicetree/bindings added.

Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: David S. Miller <davem@davemloft.net>
CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
TO: <linux-crypto@vger.kernel.org>
CC: <linux-samsung-soc@vger.kernel.org>
---
Changes since v1:
1. Added description of the SSS module in Documentation
2. Corrected the interrupts description
3. Added varient struct instead of the version variable

 .../devicetree/bindings/crypto/samsung-sss.txt     |   20 +++++
 drivers/crypto/s5p-sss.c                           |   81 ++++++++++++++++++--
 2 files changed, 95 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/samsung-sss.txt

diff --git a/Documentation/devicetree/bindings/crypto/samsung-sss.txt b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
new file mode 100644
index 0000000..0e45b0d
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
@@ -0,0 +1,20 @@
+Samsung SoC SSS (Security SubSystem) module
+
+The SSS module in S5PV210 SoC supports the following:
+-- Feeder (FeedCtrl)
+-- Advanced Encryption Standard (AES)
+-- Data Encryption Standard (DES)/3DES
+-- Public Key Accelerator (PKA)
+-- SHA-1/SHA-256/MD5/HMAC (SHA-1/SHA-256/MD5)/PRNG
+-- PRNG: Pseudo Random Number Generator
+
+Required properties:
+
+- compatible : Should contain entries for this and backward compatible
+  SSS versions:
+  - "samsung,s5p-secss" for S5PV210 SoC.
+- reg : Offset and length of the register set for the module
+- interrupts : the interrupt-specifier for the SSS module.
+		Two interrupts "feed control and hash" in case of S5PV210
+- clocks : the required gating clock for the SSS module.
+- clock-names : the gating clock name to be requested in the SSS driver.
diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 93cddeb..78e0c37 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -22,6 +22,7 @@
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
 #include <linux/io.h>
+#include <linux/of.h>
 #include <linux/crypto.h>
 #include <linux/interrupt.h>
 
@@ -145,6 +146,20 @@
 #define AES_KEY_LEN         16
 #define CRYPTO_QUEUE_LEN    1
 
+/**
+ * struct samsung_aes_varient - platform specific SSS driver data
+ * @has_hash_irq: true if SSS module uses hash interrupt, false otherwise
+ * @aes_offset: AES register offset from SSS module's base.
+ *
+ * Specifies platform specific configuration of SSS module.
+ * Note: A structure for driver specific platform data is used for future
+ * expansion of its usage.
+ */
+struct samsung_aes_varient {
+	bool			    has_hash_irq;
+	unsigned int		    aes_offset;
+};
+
 struct s5p_aes_reqctx {
 	unsigned long mode;
 };
@@ -173,10 +188,56 @@ struct s5p_aes_dev {
 	struct crypto_queue         queue;
 	bool                        busy;
 	spinlock_t                  lock;
+
+	struct samsung_aes_varient *varient;
 };
 
 static struct s5p_aes_dev *s5p_dev;
 
+static struct samsung_aes_varient s5p_aes_data = {
+	.has_hash_irq	= true,
+	.aes_offset	= 0x4000,
+};
+
+static const struct platform_device_id s5p_sss_ids[] = {
+	{
+		.name		= "s5p-secss",
+		.driver_data	= (kernel_ulong_t)&s5p_aes_data,
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, s5p_sss_ids);
+
+#ifdef CONFIG_OF
+static const struct of_device_id s5p_sss_dt_match[] = {
+	{
+		.compatible = "samsung,s5p-secss",
+		.data = (void *)&s5p_aes_data,
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, s5p_sss_dt_match);
+#else
+static struct of_device_id s5p_sss_dt_match[] =  {
+	{ },
+};
+#endif
+
+static inline struct samsung_aes_varient *find_s5p_sss_version
+				   (struct platform_device *pdev)
+{
+	if (IS_ENABLED(CONFIG_OF)) {
+		if (pdev->dev.of_node) {
+			const struct of_device_id *match;
+			match = of_match_node(s5p_sss_dt_match,
+						pdev->dev.of_node);
+		return (struct samsung_aes_varient *)match->data;
+		}
+	}
+	return (struct samsung_aes_varient *)
+			platform_get_device_id(pdev)->driver_data;
+}
+
 static void s5p_set_dma_indata(struct s5p_aes_dev *dev, struct scatterlist *sg)
 {
 	SSS_WRITE(dev, FCBRDMAS, sg_dma_address(sg));
@@ -564,6 +625,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	struct s5p_aes_dev *pdata;
 	struct device      *dev = &pdev->dev;
 	struct resource    *res;
+	struct samsung_aes_varient *varient;
 
 	if (s5p_dev)
 		return -EEXIST;
@@ -580,6 +642,8 @@ static int s5p_aes_probe(struct platform_device *pdev)
 				     resource_size(res), pdev->name))
 		return -EBUSY;
 
+	varient = find_s5p_sss_version(pdev);
+
 	pdata->clk = devm_clk_get(dev, "secss");
 	if (IS_ERR(pdata->clk)) {
 		dev_err(dev, "failed to find secss clock source\n");
@@ -606,18 +670,21 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	}
 
 	pdata->irq_hash = platform_get_irq(pdev, 1);
-	if (pdata->irq_hash < 0) {
+	if (varient->has_hash_irq && pdata->irq_hash < 0) {
 		err = pdata->irq_hash;
 		dev_warn(dev, "hash interrupt is not available.\n");
 		goto err_irq;
 	}
-	err = devm_request_irq(dev, pdata->irq_hash, s5p_aes_interrupt,
-			       IRQF_SHARED, pdev->name, pdev);
-	if (err < 0) {
-		dev_warn(dev, "hash interrupt is not available.\n");
-		goto err_irq;
+	if (varient->has_hash_irq) {
+		err = devm_request_irq(dev, pdata->irq_hash, s5p_aes_interrupt,
+				       IRQF_SHARED, pdev->name, pdev);
+		if (err < 0) {
+			dev_warn(dev, "hash interrupt is not available.\n");
+			goto err_irq;
+		}
 	}
 
+	pdata->varient = varient;
 	pdata->dev = dev;
 	platform_set_drvdata(pdev, pdata);
 	s5p_dev = pdata;
@@ -674,9 +741,11 @@ static int s5p_aes_remove(struct platform_device *pdev)
 static struct platform_driver s5p_aes_crypto = {
 	.probe	= s5p_aes_probe,
 	.remove	= s5p_aes_remove,
+	.id_table	= s5p_sss_ids,
 	.driver	= {
 		.owner	= THIS_MODULE,
 		.name	= "s5p-secss",
+		.of_match_table = s5p_sss_dt_match,
 	},
 };
 
-- 
1.7.9.5
