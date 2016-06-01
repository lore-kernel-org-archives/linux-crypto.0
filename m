From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 16/28] ARM: DRA7: hwmod: Add data for DES IP
Date: Wed, 1 Jun 2016 12:04:42 +0300
Message-ID: <1464771882-11100-1-git-send-email-t-kristo@ti.com>
References: <1464771389-10640-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>, <lokeshvutla@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<tony@atomide.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:43469 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbcFAJFb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 1 Jun 2016 05:05:31 -0400
In-Reply-To: <1464771389-10640-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Joel Fernandes <joelf@ti.com>

DRA7 SoC contains DES crypto hardware accelerator. Add hwmod data for
this IP so that it can be utilized by crypto frameworks.

Signed-off-by: Joel Fernandes <joelf@ti.com>
Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c | 37 +++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
index d0e7e525..13e4ea2 100644
--- a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
@@ -2541,6 +2541,34 @@ static struct omap_hwmod dra7xx_uart10_hwmod = {
 	},
 };
 
+/* DES (the 'P' (public) device) */
+static struct omap_hwmod_class_sysconfig dra7xx_des_sysc = {
+	.rev_offs	= 0x0030,
+	.sysc_offs	= 0x0034,
+	.syss_offs	= 0x0038,
+	.sysc_flags	= SYSS_HAS_RESET_STATUS,
+};
+
+static struct omap_hwmod_class dra7xx_des_hwmod_class = {
+	.name	= "des",
+	.sysc	= &dra7xx_des_sysc,
+};
+
+/* DES */
+static struct omap_hwmod dra7xx_des_hwmod = {
+	.name		= "des",
+	.class		= &dra7xx_des_hwmod_class,
+	.clkdm_name	= "l4sec_clkdm",
+	.main_clk	= "l3_iclk_div",
+	.prcm = {
+		.omap4 = {
+			.clkctrl_offs = DRA7XX_CM_L4SEC_DES3DES_CLKCTRL_OFFSET,
+			.context_offs = DRA7XX_RM_L4SEC_DES3DES_CONTEXT_OFFSET,
+			.modulemode   = MODULEMODE_HWCTRL,
+		},
+	},
+};
+
 /*
  * 'usb_otg_ss' class
  *
@@ -3683,6 +3711,14 @@ static struct omap_hwmod_ocp_if dra7xx_l4_per2__uart7 = {
 	.user		= OCP_USER_MPU | OCP_USER_SDMA,
 };
 
+/* l4_per1 -> des */
+static struct omap_hwmod_ocp_if dra7xx_l4_per1__des = {
+	.master		= &dra7xx_l4_per1_hwmod,
+	.slave		= &dra7xx_des_hwmod,
+	.clk		= "l3_iclk_div",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
 /* l4_per2 -> uart8 */
 static struct omap_hwmod_ocp_if dra7xx_l4_per2__uart8 = {
 	.master		= &dra7xx_l4_per2_hwmod,
@@ -3916,6 +3952,7 @@ static struct omap_hwmod_ocp_if *dra7xx_hwmod_ocp_ifs[] __initdata = {
 	&dra7xx_l4_per2__uart8,
 	&dra7xx_l4_per2__uart9,
 	&dra7xx_l4_wkup__uart10,
+	&dra7xx_l4_per1__des,
 	&dra7xx_l4_per3__usb_otg_ss1,
 	&dra7xx_l4_per3__usb_otg_ss2,
 	&dra7xx_l4_per3__usb_otg_ss3,
-- 
1.9.1
