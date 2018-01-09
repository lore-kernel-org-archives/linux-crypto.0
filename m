From: Anson Huang <Anson.Huang@nxp.com>
Subject: [PATCH V3 1/2] clk: imx: imx7d: add the snvs clock
Date: Tue, 9 Jan 2018 17:20:50 +0800
Message-ID: <1515489651-13488-1-git-send-email-Anson.Huang@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-clk@vger.kernel.org>
To: <horia.geanta@nxp.com>, <aymen.sghaier@nxp.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <shawnguo@kernel.org>, <kernel@pengutronix.de>,
        <fabio.estevam@nxp.com>, <linux@armlinux.org.uk>,
        <mturquette@baylibre.com>, <sboyd@codeaurora.org>,
        <adriana.reus@nxp.com>, <stefan@agner.ch>, <dongas86@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

According to the i.MX7D Reference Manual,
SNVS block has a clock gate, accessing SNVS block
would need this clock gate to be enabled, add it
into clock tree so that SNVS module driver can
operate this clock gate.

Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
---
 drivers/clk/imx/clk-imx7d.c             | 1 +
 include/dt-bindings/clock/imx7d-clock.h | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-imx7d.c b/drivers/clk/imx/clk-imx7d.c
index 80dc211..f34f1ec 100644
--- a/drivers/clk/imx/clk-imx7d.c
+++ b/drivers/clk/imx/clk-imx7d.c
@@ -795,6 +795,7 @@ static void __init imx7d_clocks_init(struct device_node *ccm_node)
 	clks[IMX7D_DRAM_PHYM_ALT_ROOT_CLK] = imx_clk_gate4("dram_phym_alt_root_clk", "dram_phym_alt_post_div", base + 0x4130, 0);
 	clks[IMX7D_DRAM_ALT_ROOT_CLK] = imx_clk_gate4("dram_alt_root_clk", "dram_alt_post_div", base + 0x4130, 0);
 	clks[IMX7D_OCOTP_CLK] = imx_clk_gate4("ocotp_clk", "ipg_root_clk", base + 0x4230, 0);
+	clks[IMX7D_SNVS_CLK] = imx_clk_gate4("snvs_clk", "ipg_root_clk", base + 0x4250, 0);
 	clks[IMX7D_USB_HSIC_ROOT_CLK] = imx_clk_gate4("usb_hsic_root_clk", "usb_hsic_post_div", base + 0x4420, 0);
 	clks[IMX7D_SDMA_CORE_CLK] = imx_clk_gate4("sdma_root_clk", "ahb_root_clk", base + 0x4480, 0);
 	clks[IMX7D_PCIE_CTRL_ROOT_CLK] = imx_clk_gate4("pcie_ctrl_root_clk", "pcie_ctrl_post_div", base + 0x4600, 0);
diff --git a/include/dt-bindings/clock/imx7d-clock.h b/include/dt-bindings/clock/imx7d-clock.h
index e2f99ae..dc51904 100644
--- a/include/dt-bindings/clock/imx7d-clock.h
+++ b/include/dt-bindings/clock/imx7d-clock.h
@@ -452,5 +452,6 @@
 #define IMX7D_OCOTP_CLK			439
 #define IMX7D_NAND_RAWNAND_CLK		440
 #define IMX7D_NAND_USDHC_BUS_RAWNAND_CLK 441
-#define IMX7D_CLK_END			442
+#define IMX7D_SNVS_CLK			442
+#define IMX7D_CLK_END			443
 #endif /* __DT_BINDINGS_CLOCK_IMX7D_H */
-- 
1.9.1
