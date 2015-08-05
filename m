From: Victoria Milhoan <vicki.milhoan@freescale.com>
Subject: [PATCH v2 09/14] ARM: clk-imx6q: Add CAAM clock support
Date: Wed, 5 Aug 2015 11:28:43 -0700
Message-ID: <1438799328-10757-10-git-send-email-vicki.milhoan@freescale.com>
References: <1438228709-27650-1-git-send-email-vicki.milhoan@freescale.com>
 <1438799328-10757-1-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>, <horia.geanta@freescale.com>,
	<ruchika.gupta@freescale.com>, <shawnguo@kernel.org>,
	<kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
	<robh+dt@kernel.org>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0135.outbound.protection.outlook.com ([65.55.169.135]:10221
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752570AbbHES2z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Aug 2015 14:28:55 -0400
In-Reply-To: <1438799328-10757-1-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add CAAM clock support to the i.MX6 clocking infrastructure.

Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
---
 drivers/clk/imx/clk-imx6q.c               | 3 +++
 include/dt-bindings/clock/imx6qdl-clock.h | 5 ++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-imx6q.c b/drivers/clk/imx/clk-imx6q.c
index d046f8e..15e8557 100644
--- a/drivers/clk/imx/clk-imx6q.c
+++ b/drivers/clk/imx/clk-imx6q.c
@@ -381,6 +381,9 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
 	clk[IMX6QDL_CLK_ASRC]         = imx_clk_gate2_shared("asrc",         "asrc_podf",   base + 0x68, 6, &share_count_asrc);
 	clk[IMX6QDL_CLK_ASRC_IPG]     = imx_clk_gate2_shared("asrc_ipg",     "ahb",         base + 0x68, 6, &share_count_asrc);
 	clk[IMX6QDL_CLK_ASRC_MEM]     = imx_clk_gate2_shared("asrc_mem",     "ahb",         base + 0x68, 6, &share_count_asrc);
+	clk[IMX6QDL_CLK_CAAM_MEM]     = imx_clk_gate2("caam_mem",      "ahb",               base + 0x68, 8);
+	clk[IMX6QDL_CLK_CAAM_ACLK]    = imx_clk_gate2("caam_aclk",     "ahb",               base + 0x68, 10);
+	clk[IMX6QDL_CLK_CAAM_IPG]     = imx_clk_gate2("caam_ipg",      "ipg",               base + 0x68, 12);
 	clk[IMX6QDL_CLK_CAN1_IPG]     = imx_clk_gate2("can1_ipg",      "ipg",               base + 0x68, 14);
 	clk[IMX6QDL_CLK_CAN1_SERIAL]  = imx_clk_gate2("can1_serial",   "can_root",          base + 0x68, 16);
 	clk[IMX6QDL_CLK_CAN2_IPG]     = imx_clk_gate2("can2_ipg",      "ipg",               base + 0x68, 18);
diff --git a/include/dt-bindings/clock/imx6qdl-clock.h b/include/dt-bindings/clock/imx6qdl-clock.h
index 8780868..8de173f 100644
--- a/include/dt-bindings/clock/imx6qdl-clock.h
+++ b/include/dt-bindings/clock/imx6qdl-clock.h
@@ -251,6 +251,9 @@
 #define IMX6QDL_CLK_VIDEO_27M			238
 #define IMX6QDL_CLK_MIPI_CORE_CFG		239
 #define IMX6QDL_CLK_MIPI_IPG			240
-#define IMX6QDL_CLK_END				241
+#define IMX6QDL_CLK_CAAM_MEM			241
+#define IMX6QDL_CLK_CAAM_ACLK			242
+#define IMX6QDL_CLK_CAAM_IPG			243
+#define IMX6QDL_CLK_END				244
 
 #endif /* __DT_BINDINGS_CLOCK_IMX6QDL_H */
-- 
2.1.4
