From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH 4/6] hwrng: OMAP: Add device tree support
Date: Mon, 5 Aug 2013 20:17:21 +0530
Message-ID: <1375714043-23407-5-git-send-email-lokeshvutla@ti.com>
References: <1375714043-23407-1-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>, <mpm@selenic.com>,
	<herbert@gondor.hengli.com.au>, <dsaxena@plexity.net>,
	<linux-crypto@vger.kernel.org>, Lokesh Vutla <lokeshvutla@ti.com>
To: <linux-omap@vger.kernel.org>
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <1375714043-23407-1-git-send-email-lokeshvutla@ti.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add Device Tree suport to the omap-rng driver.
Currently, only support for OMAP2 and OMAP3 is
being added but support for OMAP4 and OMAP5 will
be added in a subsequent patch.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
---
 drivers/char/hw_random/omap-rng.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index 5a2ab3b..3076c9d 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -24,6 +24,9 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/of_address.h>
 
 #include <asm/io.h>
 
@@ -104,6 +107,14 @@ static struct hwrng omap_rng_ops = {
 	.data_read	= omap_rng_data_read,
 };
 
+#if defined(CONFIG_OF)
+static const struct of_device_id omap_rng_of_match[] = {
+		{ .compatible = "ti,omap2-rng" },
+		{},
+};
+MODULE_DEVICE_TABLE(of, omap_rng_of_match);
+#endif
+
 static int omap_rng_probe(struct platform_device *pdev)
 {
 	struct omap_rng_private_data *priv;
@@ -197,6 +208,7 @@ static struct platform_driver omap_rng_driver = {
 		.name		= "omap_rng",
 		.owner		= THIS_MODULE,
 		.pm		= OMAP_RNG_PM,
+		.of_match_table = of_match_ptr(omap_rng_of_match),
 	},
 	.probe		= omap_rng_probe,
 	.remove		= __exit_p(omap_rng_remove),
-- 
1.7.9.5

