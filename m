From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 19/28] ARM: DRA7: hwmod: Add data for RNG IP
Date: Wed, 1 Jun 2016 12:06:40 +0300
Message-ID: <1464772000-11216-1-git-send-email-t-kristo@ti.com>
References: <1464771389-10640-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>, <lokeshvutla@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<tony@atomide.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:43590 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757587AbcFAJH0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 1 Jun 2016 05:07:26 -0400
In-Reply-To: <1464771389-10640-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Joel Fernandes <joelf@ti.com>

DRA7 SoC contains hardware random number generator. Add hwmod data for
this IP so that it can be utilized.

Signed-off-by: Joel Fernandes <joelf@ti.com>
Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
[t-kristo@ti.com: squashed the RNG hwmod IP flag fixes from Lokesh,
                  squashed the HS chip fix from Daniel Allred]
Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c | 36 +++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
index 8932619..0508067 100644
--- a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
@@ -2641,6 +2641,34 @@ static struct omap_hwmod dra7xx_des_hwmod = {
 	},
 };
 
+/* rng */
+static struct omap_hwmod_class_sysconfig dra7xx_rng_sysc = {
+	.rev_offs       = 0x1fe0,
+	.sysc_offs      = 0x1fe4,
+	.sysc_flags     = SYSC_HAS_AUTOIDLE | SYSC_HAS_SIDLEMODE,
+	.idlemodes      = SIDLE_FORCE | SIDLE_NO,
+	.sysc_fields    = &omap_hwmod_sysc_type1,
+};
+
+static struct omap_hwmod_class dra7xx_rng_hwmod_class = {
+	.name           = "rng",
+	.sysc           = &dra7xx_rng_sysc,
+};
+
+static struct omap_hwmod dra7xx_rng_hwmod = {
+	.name           = "rng",
+	.class          = &dra7xx_rng_hwmod_class,
+	.flags		= HWMOD_SWSUP_SIDLE,
+	.clkdm_name     = "l4sec_clkdm",
+	.prcm = {
+		.omap4 = {
+			.clkctrl_offs = DRA7XX_CM_L4SEC_RNG_CLKCTRL_OFFSET,
+			.context_offs = DRA7XX_RM_L4SEC_RNG_CONTEXT_OFFSET,
+			.modulemode   = MODULEMODE_HWCTRL,
+		},
+	},
+};
+
 /*
  * 'usb_otg_ss' class
  *
@@ -3839,6 +3867,13 @@ static struct omap_hwmod_ocp_if dra7xx_l4_wkup__uart10 = {
 	.user		= OCP_USER_MPU | OCP_USER_SDMA,
 };
 
+/* l4_per1 -> rng */
+static struct omap_hwmod_ocp_if dra7xx_l4_per1__rng = {
+	.master         = &dra7xx_l4_per1_hwmod,
+	.slave          = &dra7xx_rng_hwmod,
+	.user           = OCP_USER_MPU,
+};
+
 /* l4_per3 -> usb_otg_ss1 */
 static struct omap_hwmod_ocp_if dra7xx_l4_per3__usb_otg_ss1 = {
 	.master		= &dra7xx_l4_per3_hwmod,
@@ -4069,6 +4104,7 @@ static struct omap_hwmod_ocp_if *dra7xx_hwmod_ocp_ifs[] __initdata = {
 /* GP-only hwmod links */
 static struct omap_hwmod_ocp_if *dra7xx_gp_hwmod_ocp_ifs[] __initdata = {
 	&dra7xx_l4_wkup__timer12,
+	&dra7xx_l4_per1__rng,
 	NULL,
 };
 
-- 
1.9.1
