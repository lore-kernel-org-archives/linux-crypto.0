From: Naveen Krishna Ch <ch.naveen@samsung.com>
Subject: [PATCH 2/5] crypto:s5p-sss: Add device tree and Exynos5 support
Date: Tue, 07 Jan 2014 17:21:46 +0530
Message-ID: <1389095509-14357-3-git-send-email-ch.naveen@samsung.com>
References: <1389095509-14357-1-git-send-email-ch.naveen@samsung.com>
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
	herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
	cpgs@samsung.com, "David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-reply-to: <1389095509-14357-1-git-send-email-ch.naveen@samsung.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch adds device tree support along with a new
compatible string to support Exynos5 SoCs (SSS_VER_5).

Also, Documentation under devicetree/bindings added.

Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: David S. Miller <davem@davemloft.net>
CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
TO: <linux-crypto@vger.kernel.org>
CC: <linux-samsung-soc@vger.kernel.org>
---
 .../devicetree/bindings/crypto/samsung-sss.txt     |   24 ++++++++++++
 drivers/crypto/s5p-sss.c                           |   40 ++++++++++++++++++++
 2 files changed, 64 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/samsung-sss.txt

diff --git a/Documentation/devicetree/bindings/crypto/samsung-sss.txt b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
new file mode 100644
index 0000000..8871a29
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
@@ -0,0 +1,24 @@
+Samsung SoC SSS crypto Module
+
+Required properties:
+
+- compatible : Should contain entries for this and backward compatible
+  SSS versions:
+  - "samsung,exynos-secss" for S5PV210.
+  - "samsung,s5p-secss" for Exynos5 series SoCs.
+  TBD: SSS module on Exynos5 SoCs supports other algorithms,
+  support for the is yet to be added in the driver.
+- reg : Offset and length of the register set for the module
+- interrupts : the interrupt-specifier for the SSS module.
+- clocks : the required gating clock for the SSS module.
+- clock-names : the gating clock name requested in the SSS driver.
+
+Example:
+	/* SSS_VER_5 */
+	sss: sss {
+		compatible = "samsung,exynos-secss";
+		reg = <0x10830000 0x10000>;
+		interrupts = <0 112 0>;
+		clocks = <&clock 471>;
+		clock-names = "secss";
+	};
diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index dda4551..dcb9fc1 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -22,6 +22,7 @@
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
 #include <linux/io.h>
+#include <linux/of.h>
 #include <linux/crypto.h>
 #include <linux/interrupt.h>
 
@@ -173,10 +174,45 @@ struct s5p_aes_dev {
 	struct crypto_queue         queue;
 	bool                        busy;
 	spinlock_t                  lock;
+
+	/* To support SSS versions across Samsung SoCs */
+	unsigned int		    version;
 };
 
 static struct s5p_aes_dev *s5p_dev;
 
+enum sss_version {
+	SSS_VER_4,	/* SSS found on S5PV210 */
+	SSS_VER_5,	/* SSS found on Exynos5 Series SoCs */
+};
+
+static struct platform_device_id s5p_sss_ids[] = {
+	{
+		.name		= "s5p-secss",
+		.driver_data	= SSS_VER_4,
+	}, { },
+};
+MODULE_DEVICE_TABLE(platform, s5p_sss_ids);
+
+static struct of_device_id s5p_sss_dt_match[] = {
+	{ .compatible = "samsung,s5p-secss", .data = (void *)SSS_VER_4 },
+	{ .compatible = "samsung,exynos-secss", .data = (void *)SSS_VER_5 },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, s5p_sss_dt_match);
+
+static inline unsigned int find_s5p_sss_version(struct platform_device *pdev)
+{
+#ifdef CONFIG_OF
+	if (pdev->dev.of_node) {
+		const struct of_device_id *match;
+		match = of_match_node(s5p_sss_dt_match, pdev->dev.of_node);
+		return (unsigned int)match->data;
+	}
+#endif
+	return platform_get_device_id(pdev)->driver_data;
+}
+
 static void s5p_set_dma_indata(struct s5p_aes_dev *dev, struct scatterlist *sg)
 {
 	SSS_WRITE(dev, FCBRDMAS, sg_dma_address(sg));
@@ -580,6 +616,8 @@ static int s5p_aes_probe(struct platform_device *pdev)
 				     resource_size(res), pdev->name))
 		return -EBUSY;
 
+	pdata->version = find_s5p_sss_version(pdev);
+
 	pdata->clk = devm_clk_get(dev, "secss");
 	if (IS_ERR(pdata->clk)) {
 		dev_err(dev, "failed to find secss clock source\n");
@@ -674,9 +712,11 @@ static int s5p_aes_remove(struct platform_device *pdev)
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
