From: "Mark A. Greer" <mgreer@animalcreek.com>
Subject: [PATCH 2/7] ARM: OMAP3xxx: hwmod: Convert AES crypto device data to hwmod
Date: Mon, 19 Nov 2012 12:03:47 -0700
Message-ID: <1353351832-6685-3-git-send-email-mgreer@animalcreek.com>
References: <1353351832-6685-1-git-send-email-mgreer@animalcreek.com>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, dmitry.kasatkin@intel.com,
	rmk+kernel@arm.linux.org.uk, paul@pwsan.com,
	khilman@deeprootsystems.com,
	"Mark A. Greer" <mgreer@animalcreek.com>
To: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail20.dotsterhost.com ([66.11.232.73]:35846 "EHLO
	mail20.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280Ab2KSTD6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Nov 2012 14:03:58 -0500
In-Reply-To: <1353351832-6685-1-git-send-email-mgreer@animalcreek.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: "Mark A. Greer" <mgreer@animalcreek.com>

Convert the device data for the OMAP3 AES crypto IP
from explicit platform_data to hwmod.

CC: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
---
 arch/arm/mach-omap2/clock3xxx_data.c       |  1 +
 arch/arm/mach-omap2/devices.c              | 42 +-------------------
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c | 62 ++++++++++++++++++++++++++++++
 3 files changed, 65 insertions(+), 40 deletions(-)

diff --git a/arch/arm/mach-omap2/clock3xxx_data.c b/arch/arm/mach-omap2/clock3xxx_data.c
index 6f14d9b..ceb4153 100644
--- a/arch/arm/mach-omap2/clock3xxx_data.c
+++ b/arch/arm/mach-omap2/clock3xxx_data.c
@@ -3341,6 +3341,7 @@ static struct omap_clk omap3xxx_clks[] = {
 	CLK(NULL,	"mmchs3_ick",	&mmchs3_ick,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
 	CLK(NULL,	"icr_ick",	&icr_ick,	CK_34XX | CK_36XX),
 	CLK("omap-aes",	"ick",	&aes2_ick,	CK_34XX | CK_36XX),
+	CLK(NULL,	"aes2_ick",	&aes2_ick,	CK_34XX | CK_36XX),
 	CLK("omap-sham",	"ick",	&sha12_ick,	CK_34XX | CK_36XX),
 	CLK(NULL,	"sha12_ick",	&sha12_ick,	CK_34XX | CK_36XX),
 	CLK(NULL,	"des2_ick",	&des2_ick,	CK_34XX | CK_36XX),
diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 58831e5..6a9152a 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -468,38 +468,9 @@ static void __init omap_init_sham(void)
 	WARN(IS_ERR(pdev), "Can't build omap_device for omap-sham\n");
 }
 
-#if defined(CONFIG_CRYPTO_DEV_OMAP_AES) || defined(CONFIG_CRYPTO_DEV_OMAP_AES_MODULE)
-
-#ifdef CONFIG_ARCH_OMAP3
-static struct resource omap3_aes_resources[] = {
-	{
-		.start	= OMAP34XX_SEC_AES_BASE,
-		.end	= OMAP34XX_SEC_AES_BASE + 0x4C,
-		.flags	= IORESOURCE_MEM,
-	},
-	{
-		.start	= OMAP34XX_DMA_AES2_TX,
-		.flags	= IORESOURCE_DMA,
-	},
-	{
-		.start	= OMAP34XX_DMA_AES2_RX,
-		.flags	= IORESOURCE_DMA,
-	}
-};
-static int omap3_aes_resources_sz = ARRAY_SIZE(omap3_aes_resources);
-#else
-#define omap3_aes_resources		NULL
-#define omap3_aes_resources_sz		0
-#endif
-
-static struct platform_device aes_device = {
-	.name		= "omap-aes",
-	.id		= -1,
-};
-
-static void omap_init_aes(void)
+static void __init omap_init_aes(void)
 {
-	if (cpu_is_omap24xx()) {
+	if (cpu_is_omap24xx() || cpu_is_omap34xx()) {
 		struct omap_hwmod *oh;
 		struct platform_device *pdev;
 
@@ -510,20 +481,11 @@ static void omap_init_aes(void)
 		pdev = omap_device_build("omap-aes", -1, oh, NULL, 0, NULL,
 					 0, 0);
 		WARN(IS_ERR(pdev), "Can't build omap_device for omap-aes\n");
-	} else if (cpu_is_omap34xx()) {
-		aes_device.resource = omap3_aes_resources;
-		aes_device.num_resources = omap3_aes_resources_sz;
-		platform_device_register(&aes_device);
 	} else {
 		pr_err("%s: platform not supported\n", __func__);
-		return;
 	}
 }
 
-#else
-static inline void omap_init_aes(void) { }
-#endif
-
 /*-------------------------------------------------------------------------*/
 
 #if defined(CONFIG_VIDEO_OMAP2_VOUT) || \
diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
index a65972b..3b82304 100644
--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -3608,6 +3608,67 @@ static struct omap_hwmod_ocp_if omap3xxx_l4_core__sham = {
 	.user		= OCP_USER_MPU | OCP_USER_SDMA,
 };
 
+/* l4_core -> AES */
+static struct omap_hwmod_sysc_fields omap3xxx_aes_sysc_fields = {
+	.sidle_shift	= 6,
+	.srst_shift	= 1,
+	.autoidle_shift	= 0,
+};
+
+static struct omap_hwmod_class_sysconfig omap3_aes_sysc = {
+	.rev_offs	= 0x44,
+	.sysc_offs	= 0x48,
+	.syss_offs	= 0x4c,
+	.sysc_flags	= (SYSC_HAS_SIDLEMODE | SYSC_HAS_SOFTRESET |
+			   SYSC_HAS_AUTOIDLE | SYSS_HAS_RESET_STATUS),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
+	.sysc_fields	= &omap3xxx_aes_sysc_fields,
+};
+
+static struct omap_hwmod_class omap3xxx_aes_class = {
+	.name	= "aes",
+	.sysc	= &omap3_aes_sysc,
+};
+
+struct omap_hwmod_dma_info omap3_aes_sdma_reqs[] = {
+	{ .name = "tx", .dma_req = OMAP34XX_DMA_AES2_TX, },
+	{ .name = "rx", .dma_req = OMAP34XX_DMA_AES2_RX, },
+	{ .dma_req = -1 }
+};
+
+struct omap_hwmod omap3xxx_aes_hwmod = {
+	.name		= "aes",
+	.sdma_reqs	= omap3_aes_sdma_reqs,
+	.main_clk	= "aes2_ick",
+	.prcm		= {
+		.omap2 = {
+			.module_offs = CORE_MOD,
+			.prcm_reg_id = 1,
+			.module_bit = OMAP3430_EN_AES2_SHIFT,
+			.idlest_reg_id = 1,
+			.idlest_idle_bit = OMAP3430_ST_AES2_SHIFT,
+		},
+	},
+	.class		= &omap3xxx_aes_class,
+};
+
+static struct omap_hwmod_addr_space omap3xxx_aes_addrs[] = {
+	{
+		.pa_start	= 0x480c5000,
+		.pa_end		= 0x480c5000 + 0x50 - 1,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if omap3xxx_l4_core__aes = {
+	.master		= &omap3xxx_l4_core_hwmod,
+	.slave		= &omap3xxx_aes_hwmod,
+	.clk		= "aes2_ick",
+	.addr		= omap3xxx_aes_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
 static struct omap_hwmod_ocp_if *omap3xxx_hwmod_ocp_ifs[] __initdata = {
 	&omap3xxx_l3_main__l4_core,
 	&omap3xxx_l3_main__l4_per,
@@ -3662,6 +3723,7 @@ static struct omap_hwmod_ocp_if *omap3xxx_hwmod_ocp_ifs[] __initdata = {
 static struct omap_hwmod_ocp_if *omap3xxx_gp_hwmod_ocp_ifs[] __initdata = {
 	&omap3xxx_l4_sec__timer12,
 	&omap3xxx_l4_core__sham,
+	&omap3xxx_l4_core__aes,
 	NULL
 };
 
-- 
1.7.12
