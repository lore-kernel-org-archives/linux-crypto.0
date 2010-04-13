From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCHv3 1/2] crypto: updates omap sham device related platform code
Date: Tue, 13 Apr 2010 11:08:16 +0300
Message-ID: <40a3760f04f29351928679b1d3243b733dac8968.1271145726.git.dmitry.kasatkin@nokia.com>
References: <cover.1271145726.git.dmitry.kasatkin@nokia.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: tony@atomide.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:57921 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab0DMIJD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Apr 2010 04:09:03 -0400
In-Reply-To: <cover.1271145726.git.dmitry.kasatkin@nokia.com>
In-Reply-To: <cover.1271145726.git.dmitry.kasatkin@nokia.com>
References: <cover.1271145726.git.dmitry.kasatkin@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

- registration with multi OMAP kernels support
- clocks

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
---
 arch/arm/mach-omap2/clock2420_data.c       |    2 +-
 arch/arm/mach-omap2/clock2430_data.c       |    2 +-
 arch/arm/mach-omap2/clock3xxx_data.c       |    2 +-
 arch/arm/mach-omap2/devices.c              |   58 +++++++++++++++++++++++-----
 arch/arm/plat-omap/include/plat/omap34xx.h |    5 ++
 5 files changed, 56 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-omap2/clock2420_data.c b/arch/arm/mach-omap2/clock2420_data.c
index d932b14..1820a55 100644
--- a/arch/arm/mach-omap2/clock2420_data.c
+++ b/arch/arm/mach-omap2/clock2420_data.c
@@ -1836,7 +1836,7 @@ static struct omap_clk omap2420_clks[] = {
 	CLK(NULL,	"vlynq_ick",	&vlynq_ick,	CK_242X),
 	CLK(NULL,	"vlynq_fck",	&vlynq_fck,	CK_242X),
 	CLK(NULL,	"des_ick",	&des_ick,	CK_242X),
-	CLK(NULL,	"sha_ick",	&sha_ick,	CK_242X),
+	CLK("omap-sham",	"ick",	&sha_ick,	CK_242X),
 	CLK("omap_rng",	"ick",		&rng_ick,	CK_242X),
 	CLK(NULL,	"aes_ick",	&aes_ick,	CK_242X),
 	CLK(NULL,	"pka_ick",	&pka_ick,	CK_242X),
diff --git a/arch/arm/mach-omap2/clock2430_data.c b/arch/arm/mach-omap2/clock2430_data.c
index 0438b6e..5884ac6 100644
--- a/arch/arm/mach-omap2/clock2430_data.c
+++ b/arch/arm/mach-omap2/clock2430_data.c
@@ -1924,7 +1924,7 @@ static struct omap_clk omap2430_clks[] = {
 	CLK(NULL,	"sdma_ick",	&sdma_ick,	CK_243X),
 	CLK(NULL,	"sdrc_ick",	&sdrc_ick,	CK_243X),
 	CLK(NULL,	"des_ick",	&des_ick,	CK_243X),
-	CLK(NULL,	"sha_ick",	&sha_ick,	CK_243X),
+	CLK("omap-sham",	"ick",	&sha_ick,	CK_243X),
 	CLK("omap_rng",	"ick",		&rng_ick,	CK_243X),
 	CLK(NULL,	"aes_ick",	&aes_ick,	CK_243X),
 	CLK(NULL,	"pka_ick",	&pka_ick,	CK_243X),
diff --git a/arch/arm/mach-omap2/clock3xxx_data.c b/arch/arm/mach-omap2/clock3xxx_data.c
index d5153b6..5a974dc 100644
--- a/arch/arm/mach-omap2/clock3xxx_data.c
+++ b/arch/arm/mach-omap2/clock3xxx_data.c
@@ -3360,7 +3360,7 @@ static struct omap_clk omap3xxx_clks[] = {
 	CLK("mmci-omap-hs.2",	"ick",	&mmchs3_ick,	CK_3430ES2 | CK_AM35XX),
 	CLK(NULL,	"icr_ick",	&icr_ick,	CK_343X),
 	CLK(NULL,	"aes2_ick",	&aes2_ick,	CK_343X),
-	CLK(NULL,	"sha12_ick",	&sha12_ick,	CK_343X),
+	CLK("omap-sham",	"ick",	&sha12_ick,	CK_343X),
 	CLK(NULL,	"des2_ick",	&des2_ick,	CK_343X),
 	CLK("mmci-omap-hs.1",	"ick",	&mmchs2_ick,	CK_3XXX),
 	CLK("mmci-omap-hs.0",	"ick",	&mmchs1_ick,	CK_3XXX),
diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 23e4d77..7e7acc1 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -26,6 +26,7 @@
 #include <plat/mux.h>
 #include <mach/gpio.h>
 #include <plat/mmc.h>
+#include <plat/dma.h>
 
 #include "mux.h"
 
@@ -453,8 +454,10 @@ static void omap_init_mcspi(void)
 static inline void omap_init_mcspi(void) {}
 #endif
 
-#ifdef CONFIG_OMAP_SHA1_MD5
-static struct resource sha1_md5_resources[] = {
+#if defined(CONFIG_CRYPTO_DEV_OMAP_SHAM) || defined(CONFIG_CRYPTO_DEV_OMAP_SHAM_MODULE)
+
+#ifdef CONFIG_ARCH_OMAP24XX
+static struct resource omap2_sham_resources[] = {
 	{
 		.start	= OMAP24XX_SEC_SHA1MD5_BASE,
 		.end	= OMAP24XX_SEC_SHA1MD5_BASE + 0x64,
@@ -465,20 +468,55 @@ static struct resource sha1_md5_resources[] = {
 		.flags	= IORESOURCE_IRQ,
 	}
 };
+static int omap2_sham_resources_sz = ARRAY_SIZE(omap2_sham_resources);
+#else
+#define omap2_sham_resources		NULL
+#define omap2_sham_resources_sz		0
+#endif
 
-static struct platform_device sha1_md5_device = {
-	.name		= "OMAP SHA1/MD5",
+#ifdef CONFIG_ARCH_OMAP34XX
+static struct resource omap3_sham_resources[] = {
+	{
+		.start	= OMAP34XX_SEC_SHA1MD5_BASE,
+		.end	= OMAP34XX_SEC_SHA1MD5_BASE + 0x64,
+		.flags	= IORESOURCE_MEM,
+	},
+	{
+		.start	= INT_34XX_SHA1MD52_IRQ,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= OMAP34XX_DMA_SHA1MD5_RX,
+		.flags	= IORESOURCE_DMA,
+	}
+};
+static int omap3_sham_resources_sz = ARRAY_SIZE(omap3_sham_resources);
+#else
+#define omap3_sham_resources		NULL
+#define omap3_sham_resources_sz		0
+#endif
+
+static struct platform_device sham_device = {
+	.name		= "omap-sham",
 	.id		= -1,
-	.num_resources	= ARRAY_SIZE(sha1_md5_resources),
-	.resource	= sha1_md5_resources,
 };
 
-static void omap_init_sha1_md5(void)
+static void omap_init_sham(void)
 {
-	platform_device_register(&sha1_md5_device);
+	if (cpu_is_omap24xx()) {
+		sham_device.resource = omap2_sham_resources;
+		sham_device.num_resources = omap2_sham_resources_sz;
+	} else if (cpu_is_omap34xx()) {
+		sham_device.resource = omap3_sham_resources;
+		sham_device.num_resources = omap3_sham_resources_sz;
+	} else {
+		pr_err("%s: platform not supported\n", __func__);
+		return;
+	}
+	platform_device_register(&sham_device);
 }
 #else
-static inline void omap_init_sha1_md5(void) { }
+static inline void omap_init_sham(void) { }
 #endif
 
 /*-------------------------------------------------------------------------*/
@@ -799,7 +837,7 @@ static int __init omap2_init_devices(void)
 	omap_init_mcspi();
 	omap_hdq_init();
 	omap_init_sti();
-	omap_init_sha1_md5();
+	omap_init_sham();
 
 	return 0;
 }
diff --git a/arch/arm/plat-omap/include/plat/omap34xx.h b/arch/arm/plat-omap/include/plat/omap34xx.h
index 2845fdc..98fc8b4 100644
--- a/arch/arm/plat-omap/include/plat/omap34xx.h
+++ b/arch/arm/plat-omap/include/plat/omap34xx.h
@@ -82,5 +82,10 @@
 
 #define OMAP34XX_MAILBOX_BASE		(L4_34XX_BASE + 0x94000)
 
+/* Security */
+#define OMAP34XX_SEC_BASE	(L4_34XX_BASE + 0xA0000)
+#define OMAP34XX_SEC_SHA1MD5_BASE	(OMAP34XX_SEC_BASE + 0x23000)
+#define OMAP34XX_SEC_AES_BASE	(OMAP34XX_SEC_BASE + 0x25000)
+
 #endif /* __ASM_ARCH_OMAP3_H */
 
-- 
1.6.3.3

