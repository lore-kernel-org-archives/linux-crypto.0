From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 18/28] ARM: DRA7: hwmod: Add data for SHA IP
Date: Wed, 1 Jun 2016 12:06:34 +0300
Message-ID: <1464771994-11178-1-git-send-email-t-kristo@ti.com>
References: <1464771389-10640-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>, <lokeshvutla@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<tony@atomide.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([198.47.19.11]:50589 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489AbcFAJHX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 1 Jun 2016 05:07:23 -0400
In-Reply-To: <1464771389-10640-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Lokesh Vutla <lokeshvutla@ti.com>

DRA7 SoC contains SHA crypto hardware accelerator. Add hwmod data for
this IP so that it can be utilized by crypto frameworks.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c | 37 +++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
index ceb1b42..8932619 100644
--- a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
@@ -734,6 +734,34 @@ static struct omap_hwmod dra7xx_aes2_hwmod = {
 	},
 };
 
+/* sha0 HIB2 (the 'P' (public) device) */
+static struct omap_hwmod_class_sysconfig dra7xx_sha0_sysc = {
+	.rev_offs	= 0x100,
+	.sysc_offs	= 0x110,
+	.syss_offs	= 0x114,
+	.sysc_flags	= SYSS_HAS_RESET_STATUS,
+};
+
+static struct omap_hwmod_class dra7xx_sha0_hwmod_class = {
+	.name		= "sham",
+	.sysc		= &dra7xx_sha0_sysc,
+	.rev		= 2,
+};
+
+struct omap_hwmod dra7xx_sha0_hwmod = {
+	.name		= "sham",
+	.class		= &dra7xx_sha0_hwmod_class,
+	.clkdm_name	= "l4sec_clkdm",
+	.main_clk	= "l3_iclk_div",
+	.prcm		= {
+		.omap4 = {
+			.clkctrl_offs = DRA7XX_CM_L4SEC_SHA2MD51_CLKCTRL_OFFSET,
+			.context_offs = DRA7XX_RM_L4SEC_SHA2MD51_CONTEXT_OFFSET,
+			.modulemode   = MODULEMODE_HWCTRL,
+		},
+	},
+};
+
 /*
  * 'elm' class
  *
@@ -3048,6 +3076,14 @@ static struct omap_hwmod_ocp_if dra7xx_l3_main_1__aes2 = {
 	.user		= OCP_USER_MPU | OCP_USER_SDMA,
 };
 
+/* l3_main_1 -> sha0 */
+static struct omap_hwmod_ocp_if dra7xx_l3_main_1__sha0 = {
+	.master		= &dra7xx_l3_main_1_hwmod,
+	.slave		= &dra7xx_sha0_hwmod,
+	.clk		= "l3_iclk_div",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
 /* l4_per2 -> mcasp1 */
 static struct omap_hwmod_ocp_if dra7xx_l4_per2__mcasp1 = {
 	.master		= &dra7xx_l4_per2_hwmod,
@@ -3939,6 +3975,7 @@ static struct omap_hwmod_ocp_if *dra7xx_hwmod_ocp_ifs[] __initdata = {
 	&dra7xx_l3_main_1__hdmi,
 	&dra7xx_l3_main_1__aes1,
 	&dra7xx_l3_main_1__aes2,
+	&dra7xx_l3_main_1__sha0,
 	&dra7xx_l4_per1__elm,
 	&dra7xx_l4_wkup__gpio1,
 	&dra7xx_l4_per1__gpio2,
-- 
1.9.1
