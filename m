From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 2/6] clk: imx: vf610: Add CRC clock
Date: Thu, 30 Aug 2018 19:15:35 +0200
Message-ID: <20180830171539.20008-3-krzk@kernel.org>
References: <20180830171539.20008-1-krzk@kernel.org>
To: Krzysztof Kozlowski <krzk@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Stefan Agner <stefan@agner.ch>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180830171539.20008-1-krzk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add the clock for CRC block allowing it to be enabled by HW CRC driver.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/clk/imx/clk-vf610.c             | 1 +
 include/dt-bindings/clock/vf610-clock.h | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-vf610.c b/drivers/clk/imx/clk-vf610.c
index 6dae54325a91..78f2602c81ad 100644
--- a/drivers/clk/imx/clk-vf610.c
+++ b/drivers/clk/imx/clk-vf610.c
@@ -332,6 +332,7 @@ static void __init vf610_clocks_init(struct device_node *ccm_node)
 	clk[VF610_CLK_DSPI2] = imx_clk_gate2("dspi2", "ipg_bus", CCM_CCGR6, CCM_CCGRx_CGn(12));
 	clk[VF610_CLK_DSPI3] = imx_clk_gate2("dspi3", "ipg_bus", CCM_CCGR6, CCM_CCGRx_CGn(13));
 
+	clk[VF610_CLK_CRC] = imx_clk_gate2("crc", "ipg_bus", CCM_CCGR1, CCM_CCGRx_CGn(3));
 	clk[VF610_CLK_WDT] = imx_clk_gate2("wdt", "ipg_bus", CCM_CCGR1, CCM_CCGRx_CGn(14));
 
 	clk[VF610_CLK_ESDHC0_SEL] = imx_clk_mux("esdhc0_sel", CCM_CSCMR1, 16, 2, esdhc_sels, 4);
diff --git a/include/dt-bindings/clock/vf610-clock.h b/include/dt-bindings/clock/vf610-clock.h
index 45997750c8a0..03f0731c5a69 100644
--- a/include/dt-bindings/clock/vf610-clock.h
+++ b/include/dt-bindings/clock/vf610-clock.h
@@ -199,6 +199,7 @@
 #define VF610_CLK_WKPU			186
 #define VF610_CLK_TCON0			187
 #define VF610_CLK_TCON1			188
-#define VF610_CLK_END			189
+#define VF610_CLK_CRC			189
+#define VF610_CLK_END			190
 
 #endif /* __DT_BINDINGS_CLOCK_VF610_H */
-- 
2.14.1
