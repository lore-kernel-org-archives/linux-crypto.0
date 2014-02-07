From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Subject: [PATCH 2/9 v6] crypto:s5p-sss: Add device tree support
Date: Fri, 07 Feb 2014 10:51:55 +0530
Message-ID: <1391750515-27270-1-git-send-email-ch.naveen@samsung.com>
References: <1389243541-13122-1-git-send-email-ch.naveen@samsung.com>
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
	herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
	cpgs@samsung.com, "David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-reply-to: <1389243541-13122-1-git-send-email-ch.naveen@samsung.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch adds device tree support to the s5p-sss.c crypto driver.

Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: David S. Miller <davem@davemloft.net>
CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
TO: <linux-crypto@vger.kernel.org>
CC: <linux-samsung-soc@vger.kernel.org>
---
Changes since v5:
Rewritten the interrupt definition in the documentation

 .../devicetree/bindings/crypto/samsung-sss.txt     |   26 ++++++++++++++++++++
 drivers/crypto/s5p-sss.c                           |    8 ++++++
 2 files changed, 34 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/samsung-sss.txt

diff --git a/Documentation/devicetree/bindings/crypto/samsung-sss.txt b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
new file mode 100644
index 0000000..3876f71
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
@@ -0,0 +1,26 @@
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
+  - "samsung,s5pv210-secss" for S5PV210 SoC.
+- reg : Offset and length of the register set for the module
+- interrupts : interrupt specifiers of SSS module interrupts, should contain
+		two entries:
+		- first : feed control interrupt,
+		- second : hash interrupt.
+
+- clocks : list of clock phandle and specifier pairs for all clocks  listed in
+		clock-names property.
+- clock-names : list of device clock input names; should contain one entry
+		"secss".
+
diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 93cddeb..73c8b38 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -22,6 +22,7 @@
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
 #include <linux/io.h>
+#include <linux/of.h>
 #include <linux/crypto.h>
 #include <linux/interrupt.h>
 
@@ -177,6 +178,12 @@ struct s5p_aes_dev {
 
 static struct s5p_aes_dev *s5p_dev;
 
+static const struct of_device_id s5p_sss_dt_match[] = {
+	{ .compatible = "samsung,s5pv210-secss" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, s5p_sss_dt_match);
+
 static void s5p_set_dma_indata(struct s5p_aes_dev *dev, struct scatterlist *sg)
 {
 	SSS_WRITE(dev, FCBRDMAS, sg_dma_address(sg));
@@ -677,6 +684,7 @@ static struct platform_driver s5p_aes_crypto = {
 	.driver	= {
 		.owner	= THIS_MODULE,
 		.name	= "s5p-secss",
+		.of_match_table = s5p_sss_dt_match,
 	},
 };
 
-- 
1.7.9.5
