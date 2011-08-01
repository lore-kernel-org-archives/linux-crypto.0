From: Jamie Iles <jamie@jamieiles.com>
Subject: [PATCH 3/3] crypto: picoxcell - support for device tree matching
Date: Mon,  1 Aug 2011 17:25:19 +0100
Message-ID: <1312215919-24419-3-git-send-email-jamie@jamieiles.com>
References: <1312215919-24419-1-git-send-email-jamie@jamieiles.com>
Cc: Jamie Iles <jamie@jamieiles.com>,
	devicetree-discuss@lists.ozlabs.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60119 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab1HAQZ3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Aug 2011 12:25:29 -0400
Received: by mail-wy0-f174.google.com with SMTP id 8so1713415wyg.19
        for <linux-crypto@vger.kernel.org>; Mon, 01 Aug 2011 09:25:28 -0700 (PDT)
In-Reply-To: <1312215919-24419-1-git-send-email-jamie@jamieiles.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Allow the crypto engines to be matched from device tree bindings.

Cc: devicetree-discuss@lists.ozlabs.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 .../devicetree/bindings/crypto/picochip-spacc.txt  |   23 ++++++++++++
 drivers/crypto/picoxcell_crypto.c                  |   36 ++++++++++++++++---
 2 files changed, 53 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/picochip-spacc.txt

diff --git a/Documentation/devicetree/bindings/crypto/picochip-spacc.txt b/Documentation/devicetree/bindings/crypto/picochip-spacc.txt
new file mode 100644
index 0000000..d8609ec
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/picochip-spacc.txt
@@ -0,0 +1,23 @@
+Picochip picoXcell SPAcc (Security Protocol Accelerator) bindings
+
+Picochip picoXcell devices contain crypto offload engines that may be used for
+IPSEC and femtocell layer 2 ciphering.
+
+Required properties:
+  - compatible : "picochip,spacc-ipsec" for the IPSEC offload engine
+    "picochip,spacc-l2" for the femtocell layer 2 ciphering engine.
+  - reg : Offset and length of the register set for this device
+  - interrupt-parent : The interrupt controller that controls the SPAcc
+    interrupt.
+  - interrupts : The interrupt line from the SPAcc.
+  - ref-clock : The input clock that drives the SPAcc.
+
+Example SPAcc node:
+
+spacc@10000 {
+	compatible = "picochip,spacc-ipsec";
+	reg = <0x100000 0x10000>;
+	interrupt-parent = <&vic0>;
+	interrupts = <24>;
+	ref-clock = <&ipsec_clk>, "ref";
+};
diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index d119e0e..017340c 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -34,6 +34,7 @@
 #include <linux/io.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
 #include <linux/rtnetlink.h>
@@ -1657,27 +1658,49 @@ static struct spacc_alg l2_engine_algs[] = {
 	},
 };
 
+#ifdef CONFIG_OF
+static const struct of_device_id spacc_of_id_table[] = {
+	{ .compatible = "picochip,spacc-ipsec" },
+	{ .compatible = "picochip,spacc-l2" },
+	{}
+};
+#else /* CONFIG_OF */
+#define spacc_of_id_table NULL
+#endif /* CONFIG_OF */
+
+static bool spacc_is_compatible(struct platform_device *pdev,
+				const char *spacc_type)
+{
+	const struct platform_device_id *platid = platform_get_device_id(pdev);
+
+	if (platid && !strcmp(platid->name, spacc_type))
+		return true;
+
+#ifdef CONFIG_OF
+	if (of_device_is_compatible(pdev->dev.of_node, spacc_type))
+		return true;
+#endif /* CONFIG_OF */
+
+	return false;
+}
+
 static int __devinit spacc_probe(struct platform_device *pdev)
 {
 	int i, err, ret = -EINVAL;
 	struct resource *mem, *irq;
-	const struct platform_device_id *platid = platform_get_device_id(pdev);
 	struct spacc_engine *engine = devm_kzalloc(&pdev->dev, sizeof(*engine),
 						   GFP_KERNEL);
 	if (!engine)
 		return -ENOMEM;
 
-	if (!platid)
-		return -EINVAL;
-
-	if (!strcmp(platid->name, "picoxcell-ipsec")) {
+	if (spacc_is_compatible(pdev, "picochip,spacc-ipsec")) {
 		engine->max_ctxs	= SPACC_CRYPTO_IPSEC_MAX_CTXS;
 		engine->cipher_pg_sz	= SPACC_CRYPTO_IPSEC_CIPHER_PG_SZ;
 		engine->hash_pg_sz	= SPACC_CRYPTO_IPSEC_HASH_PG_SZ;
 		engine->fifo_sz		= SPACC_CRYPTO_IPSEC_FIFO_SZ;
 		engine->algs		= ipsec_engine_algs;
 		engine->num_algs	= ARRAY_SIZE(ipsec_engine_algs);
-	} else if (!strcmp(platid->name, "picoxcell-l2")) {
+	} else if (spacc_is_compatible(pdev, "picochip,spacc-l2")) {
 		engine->max_ctxs	= SPACC_CRYPTO_L2_MAX_CTXS;
 		engine->cipher_pg_sz	= SPACC_CRYPTO_L2_CIPHER_PG_SZ;
 		engine->hash_pg_sz	= SPACC_CRYPTO_L2_HASH_PG_SZ;
@@ -1826,6 +1849,7 @@ static struct platform_driver spacc_driver = {
 #ifdef CONFIG_PM
 		.pm	= &spacc_pm_ops,
 #endif /* CONFIG_PM */
+		.of_match_table	= spacc_of_id_table,
 	},
 	.id_table	= spacc_id_table,
 };
-- 
1.7.4.1
