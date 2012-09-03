From: Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH] Crypto: CESA: Add support for DT based instantiation.
Date: Mon,  3 Sep 2012 20:29:34 +0200
Message-ID: <1346696974-23443-1-git-send-email-andrew@lunn.ch>
Cc: linux-crypto@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
	linux ARM <linux-arm-kernel@lists.infradead.org>,
	sebastian.hesselbarth@googlemail.com, Andrew Lunn <andrew@lunn.ch>
To: devicetree-discuss@lists.ozlabs.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from londo.lunn.ch ([80.238.139.98]:33189 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435Ab2ICSaI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Sep 2012 14:30:08 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Based on work by Michael Waller and Jason Cooper.

Added support for getting the interrupt number and address of SRAM
from DT.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 .../devicetree/bindings/crypto/mv_cesa.txt         |   20 ++++++++++++++++++++
 arch/arm/boot/dts/kirkwood.dtsi                    |   12 +++++++++++-
 arch/arm/mach-kirkwood/board-dt.c                  |    2 +-
 drivers/crypto/mv_cesa.c                           |   17 +++++++++++++++--
 4 files changed, 47 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/mv_cesa.txt

diff --git a/Documentation/devicetree/bindings/crypto/mv_cesa.txt b/Documentation/devicetree/bindings/crypto/mv_cesa.txt
new file mode 100644
index 0000000..47229b1
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/mv_cesa.txt
@@ -0,0 +1,20 @@
+Marvell Cryptographic Engines And Security Accelerator
+
+Required properties:
+- compatible : should be "marvell,orion-crypto"
+- reg : base physical address of the engine and length of memory mapped
+        region, followed by base physical address of sram and its memory
+        length
+- reg-names : "regs" , "sram";
+- interrupts : interrupt number
+
+Examples:
+
+	crypto@30000 {
+		compatible = "marvell,orion-crypto";
+		reg = <0x30000 0x10000>,
+		      <0x4000000 0x800>;
+		reg-names = "regs" , "sram";
+		interrupts = <22>;
+		status = "okay";
+	};
diff --git a/arch/arm/boot/dts/kirkwood.dtsi b/arch/arm/boot/dts/kirkwood.dtsi
index b36bb85..fbaf728 100644
--- a/arch/arm/boot/dts/kirkwood.dtsi
+++ b/arch/arm/boot/dts/kirkwood.dtsi
@@ -14,7 +14,8 @@
 
 	ocp@f1000000 {
 		compatible = "simple-bus";
-		ranges = <0 0xf1000000 0x4000000>;
+		ranges = <0x00000000 0xf1000000 0x4000000
+		          0xf5000000 0xf5000000 0x0000400>;
 		#address-cells = <1>;
 		#size-cells = <1>;
 
@@ -113,5 +114,14 @@
 			clock-frequency = <100000>;
 			status = "disabled";
 		};
+
+		crypto@30000 {
+			compatible = "marvell,orion-crypto";
+			reg = <0x30000 0x10000>,
+			      <0xf5000000 0x800>;
+			reg-names = "regs", "sram";
+			interrupts = <22>;
+			status = "okay";
+		};
 	};
 };
diff --git a/arch/arm/mach-kirkwood/board-dt.c b/arch/arm/mach-kirkwood/board-dt.c
index 16b767e..007661c 100644
--- a/arch/arm/mach-kirkwood/board-dt.c
+++ b/arch/arm/mach-kirkwood/board-dt.c
@@ -34,6 +34,7 @@ struct of_dev_auxdata kirkwood_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("marvell,orion-sata", 0xf1080000, "sata_mv.0", NULL),
 	OF_DEV_AUXDATA("marvell,orion-nand", 0xf4000000, "orion_nand", NULL),
 	OF_DEV_AUXDATA("marvell,orion-ehci", 0xf1050000, "orion-ehci.0", NULL),
+	OF_DEV_AUXDATA("marvell,orion-crypto", 0xf1030000, "mv_crypto", NULL),
 	{},
 };
 
@@ -61,7 +62,6 @@ static void __init kirkwood_dt_init(void)
 	/* internal devices that every board has */
 	kirkwood_xor0_init();
 	kirkwood_xor1_init();
-	kirkwood_crypto_init();
 
 #ifdef CONFIG_KEXEC
 	kexec_reinit = kirkwood_enable_pcie;
diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 21c1a87..24ccae4 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -19,6 +19,9 @@
 #include <linux/clk.h>
 #include <crypto/internal/hash.h>
 #include <crypto/sha.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/of_irq.h>
 
 #include "mv_cesa.h"
 
@@ -1062,7 +1065,10 @@ static int mv_probe(struct platform_device *pdev)
 		goto err_unmap_reg;
 	}
 
-	irq = platform_get_irq(pdev, 0);
+	if (pdev->dev.of_node)
+		irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
+	else
+		irq = platform_get_irq(pdev, 0);
 	if (irq < 0 || irq == NO_IRQ) {
 		ret = irq;
 		goto err_unmap_sram;
@@ -1170,12 +1176,19 @@ static int mv_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id mv_cesa_of_match_table[] = {
+	{ .compatible = "marvell,orion-crypto", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, mv_cesa_of_match_table);
+
 static struct platform_driver marvell_crypto = {
 	.probe		= mv_probe,
-	.remove		= mv_remove,
+	.remove		= __devexit_p(mv_remove),
 	.driver		= {
 		.owner	= THIS_MODULE,
 		.name	= "mv_crypto",
+		.of_match_table = of_match_ptr(mv_cesa_of_match_table),
 	},
 };
 MODULE_ALIAS("platform:mv_crypto");
-- 
1.7.10.4
