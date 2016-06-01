From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 21/28] ARM: AM43xx: hwmod: Add data for DES
Date: Wed, 1 Jun 2016 12:06:39 +0300
Message-ID: <1464772006-11254-2-git-send-email-t-kristo@ti.com>
References: <1464771389-10640-1-git-send-email-t-kristo@ti.com>
 <1464772006-11254-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>, <lokeshvutla@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<tony@atomide.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:43601 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757573AbcFAJHm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 1 Jun 2016 05:07:42 -0400
In-Reply-To: <1464772006-11254-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Lokesh Vutla <lokeshvutla@ti.com>

AM43xx SoC contains DES crypto hardware accelerator. Add hwmod data for
this IP so that it can be utilized by crypto frameworks.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_43xx_data.c | 33 ++++++++++++++++++++++++++++++
 arch/arm/mach-omap2/prcm43xx.h             |  1 +
 2 files changed, 34 insertions(+)

diff --git a/arch/arm/mach-omap2/omap_hwmod_43xx_data.c b/arch/arm/mach-omap2/omap_hwmod_43xx_data.c
index 97fd399..b54eeaa 100644
--- a/arch/arm/mach-omap2/omap_hwmod_43xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_43xx_data.c
@@ -463,6 +463,31 @@ static struct omap_hwmod am43xx_adc_tsc_hwmod = {
 	},
 };
 
+static struct omap_hwmod_class_sysconfig am43xx_des_sysc = {
+	.rev_offs	= 0x30,
+	.sysc_offs	= 0x34,
+	.syss_offs	= 0x38,
+	.sysc_flags	= SYSS_HAS_RESET_STATUS,
+};
+
+static struct omap_hwmod_class am43xx_des_hwmod_class = {
+	.name		= "des",
+	.sysc		= &am43xx_des_sysc,
+};
+
+static struct omap_hwmod am43xx_des_hwmod = {
+	.name		= "des",
+	.class		= &am43xx_des_hwmod_class,
+	.clkdm_name	= "l3_clkdm",
+	.main_clk	= "l3_gclk",
+	.prcm		= {
+		.omap4	= {
+			.clkctrl_offs	= AM43XX_CM_PER_DES_CLKCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
 /* dss */
 
 static struct omap_hwmod am43xx_dss_core_hwmod = {
@@ -912,6 +937,13 @@ static struct omap_hwmod_ocp_if am43xx_l4_ls__vpfe1 = {
 	.user           = OCP_USER_MPU | OCP_USER_SDMA,
 };
 
+static struct omap_hwmod_ocp_if am43xx_l3_main__des = {
+	.master		= &am33xx_l3_main_hwmod,
+	.slave		= &am43xx_des_hwmod,
+	.clk		= "l3_gclk",
+	.user		= OCP_USER_MPU,
+};
+
 static struct omap_hwmod_ocp_if *am43xx_hwmod_ocp_ifs[] __initdata = {
 	&am33xx_l4_wkup__synctimer,
 	&am43xx_l4_ls__timer8,
@@ -1004,6 +1036,7 @@ static struct omap_hwmod_ocp_if *am43xx_hwmod_ocp_ifs[] __initdata = {
 	&am33xx_cpgmac0__mdio,
 	&am33xx_l3_main__sha0,
 	&am33xx_l3_main__aes0,
+	&am43xx_l3_main__des,
 	&am43xx_l4_ls__ocp2scp0,
 	&am43xx_l4_ls__ocp2scp1,
 	&am43xx_l3_s__usbotgss0,
diff --git a/arch/arm/mach-omap2/prcm43xx.h b/arch/arm/mach-omap2/prcm43xx.h
index 7c34c44e..593482e 100644
--- a/arch/arm/mach-omap2/prcm43xx.h
+++ b/arch/arm/mach-omap2/prcm43xx.h
@@ -132,6 +132,7 @@
 #define AM43XX_CM_PER_OCMCRAM_CLKCTRL_OFFSET		0x0050
 #define AM43XX_CM_PER_SHA0_CLKCTRL_OFFSET		0x0058
 #define AM43XX_CM_PER_AES0_CLKCTRL_OFFSET		0x0028
+#define AM43XX_CM_PER_DES_CLKCTRL_OFFSET		0x0030
 #define AM43XX_CM_PER_TIMER8_CLKCTRL_OFFSET		0x0560
 #define AM43XX_CM_PER_TIMER9_CLKCTRL_OFFSET		0x0568
 #define AM43XX_CM_PER_TIMER10_CLKCTRL_OFFSET		0x0570
-- 
1.9.1
