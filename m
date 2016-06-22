From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCHv2 22/27] ARM: DRA7: hwmod: Add data for AES IP
Date: Wed, 22 Jun 2016 16:23:55 +0300
Message-ID: <1466601840-18486-23-git-send-email-t-kristo@ti.com>
References: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>
To: <linux-omap@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<tony@atomide.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <lokeshvutla@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([198.47.19.12]:57964 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbcFVNZ5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 09:25:57 -0400
In-Reply-To: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Joel Fernandes <joelf@ti.com>

DRA7 SoC contains AES crypto hardware accelerator. Add hwmod data for
this IP so that it can be utilized by crypto frameworks.

Signed-off-by: Joel Fernandes <joelf@ti.com>
Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
[t-kristo@ti.com: squash in support for both AES1 and AES2 cores]
Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c | 62 +++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
index 13e4ea2..ceb1b42 100644
--- a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
@@ -690,6 +690,50 @@ static struct omap_hwmod dra7xx_dss_hdmi_hwmod = {
 	.parent_hwmod	= &dra7xx_dss_hwmod,
 };
 
+/* AES (the 'P' (public) device) */
+static struct omap_hwmod_class_sysconfig dra7xx_aes_sysc = {
+	.rev_offs	= 0x0080,
+	.sysc_offs	= 0x0084,
+	.syss_offs	= 0x0088,
+	.sysc_flags	= SYSS_HAS_RESET_STATUS,
+};
+
+static struct omap_hwmod_class dra7xx_aes_hwmod_class = {
+	.name	= "aes",
+	.sysc	= &dra7xx_aes_sysc,
+	.rev	= 2,
+};
+
+/* AES1 */
+static struct omap_hwmod dra7xx_aes1_hwmod = {
+	.name		= "aes1",
+	.class		= &dra7xx_aes_hwmod_class,
+	.clkdm_name	= "l4sec_clkdm",
+	.main_clk	= "l3_iclk_div",
+	.prcm = {
+		.omap4 = {
+			.clkctrl_offs = DRA7XX_CM_L4SEC_AES1_CLKCTRL_OFFSET,
+			.context_offs = DRA7XX_RM_L4SEC_AES1_CONTEXT_OFFSET,
+			.modulemode   = MODULEMODE_HWCTRL,
+		},
+	},
+};
+
+/* AES2 */
+static struct omap_hwmod dra7xx_aes2_hwmod = {
+	.name		= "aes2",
+	.class		= &dra7xx_aes_hwmod_class,
+	.clkdm_name	= "l4sec_clkdm",
+	.main_clk	= "l3_iclk_div",
+	.prcm = {
+		.omap4 = {
+			.clkctrl_offs = DRA7XX_CM_L4SEC_AES2_CLKCTRL_OFFSET,
+			.context_offs = DRA7XX_RM_L4SEC_AES2_CONTEXT_OFFSET,
+			.modulemode   = MODULEMODE_HWCTRL,
+		},
+	},
+};
+
 /*
  * 'elm' class
  *
@@ -2988,6 +3032,22 @@ static struct omap_hwmod_ocp_if dra7xx_l3_main_1__hdmi = {
 	.user		= OCP_USER_MPU | OCP_USER_SDMA,
 };
 
+/* l3_main_1 -> aes1 */
+static struct omap_hwmod_ocp_if dra7xx_l3_main_1__aes1 = {
+	.master		= &dra7xx_l3_main_1_hwmod,
+	.slave		= &dra7xx_aes1_hwmod,
+	.clk		= "l3_iclk_div",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* l3_main_1 -> aes2 */
+static struct omap_hwmod_ocp_if dra7xx_l3_main_1__aes2 = {
+	.master		= &dra7xx_l3_main_1_hwmod,
+	.slave		= &dra7xx_aes2_hwmod,
+	.clk		= "l3_iclk_div",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
 /* l4_per2 -> mcasp1 */
 static struct omap_hwmod_ocp_if dra7xx_l4_per2__mcasp1 = {
 	.master		= &dra7xx_l4_per2_hwmod,
@@ -3877,6 +3937,8 @@ static struct omap_hwmod_ocp_if *dra7xx_hwmod_ocp_ifs[] __initdata = {
 	&dra7xx_l3_main_1__dss,
 	&dra7xx_l3_main_1__dispc,
 	&dra7xx_l3_main_1__hdmi,
+	&dra7xx_l3_main_1__aes1,
+	&dra7xx_l3_main_1__aes2,
 	&dra7xx_l4_per1__elm,
 	&dra7xx_l4_wkup__gpio1,
 	&dra7xx_l4_per1__gpio2,
-- 
1.9.1
