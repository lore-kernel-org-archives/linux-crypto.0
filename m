From: "Christoph G. Baumann" <cb@sgoc.de>
Subject: [PATCH 2/2] crypto: added support for fsl-dcp on iMX23,28,50
Date: Mon, 29 Apr 2013 21:58:36 +0200
Message-ID: <1367265516-7814-3-git-send-email-cb@sgoc.de>
References: <1367265516-7814-1-git-send-email-cb@sgoc.de>
Cc: "Christoph G. Baumann" <cb@sgoc.de>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:51523 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758976Ab3D2T6j (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 29 Apr 2013 15:58:39 -0400
In-Reply-To: <1367265516-7814-1-git-send-email-cb@sgoc.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: "Christoph G. Baumann" <cb@sgoc.de>

This patch contains modified files.

Signed-off-by: "Christoph G. Baumann" <cb@sgoc.de>
---
 arch/arm/boot/dts/imx28.dtsi |    2 +-
 drivers/staging/Kconfig      |    2 ++
 drivers/staging/Makefile     |    1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx28.dtsi b/arch/arm/boot/dts/imx28.dtsi
index 7ba4966..2bec573 100644
--- a/arch/arm/boot/dts/imx28.dtsi
+++ b/arch/arm/boot/dts/imx28.dtsi
@@ -664,9 +664,9 @@
 			};
 
 			dcp@80028000 {
+                                compatible = "fsl,fsl-dcp";
 				reg = <0x80028000 0x2000>;
 				interrupts = <52 53 54>;
-				status = "disabled";
 			};
 
 			pxp@8002a000 {
diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 093f10c..b3cf08b 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -140,4 +140,6 @@ source "drivers/staging/zcache/Kconfig"
 
 source "drivers/staging/goldfish/Kconfig"
 
+source "drivers/staging/crypto/Kconfig"
+
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index fa41b04..6875e3e 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -62,3 +62,4 @@ obj-$(CONFIG_SB105X)		+= sb105x/
 obj-$(CONFIG_FIREWIRE_SERIAL)	+= fwserial/
 obj-$(CONFIG_ZCACHE)		+= zcache/
 obj-$(CONFIG_GOLDFISH)		+= goldfish/
+obj-$(CONFIG_CRYPTO_HW)		+= crypto/
-- 
1.7.9.5
