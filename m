From: Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v2 1/3] i.MX27: Add clock support for SAHARA2.
Date: Wed, 27 Feb 2013 11:41:49 +0100
Message-ID: <1361961711-4603-2-git-send-email-javier.martin@vista-silicon.com>
References: <1361961711-4603-1-git-send-email-javier.martin@vista-silicon.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org, davem@davemloft.net,
	herbert@gondor.apana.org.au, kernel@pengutronix.de,
	gcembed@gmail.com, shawn.guo@linaro.org, arnd@arndb.de,
	swarren@nvidia.com, Javier Martin <javier.martin@vista-silicon.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1361961711-4603-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 arch/arm/mach-imx/clk-imx27.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-imx/clk-imx27.c b/arch/arm/mach-imx/clk-imx27.c
index 4c1d1e4..0b9664a 100644
--- a/arch/arm/mach-imx/clk-imx27.c
+++ b/arch/arm/mach-imx/clk-imx27.c
@@ -253,6 +253,8 @@ int __init mx27_clocks_init(unsigned long fref)
 	clk_register_clkdev(clk[nfc_baud_gate], NULL, "imx27-nand.0");
 	clk_register_clkdev(clk[vpu_baud_gate], "per", "coda-imx27.0");
 	clk_register_clkdev(clk[vpu_ahb_gate], "ahb", "coda-imx27.0");
+	clk_register_clkdev(clk[sahara_ahb_gate], "ahb", "sahara-imx27.0");
+	clk_register_clkdev(clk[sahara_ipg_gate], "ipg", "sahara-imx27.0");
 	clk_register_clkdev(clk[dma_ahb_gate], "ahb", "imx27-dma");
 	clk_register_clkdev(clk[dma_ipg_gate], "ipg", "imx27-dma");
 	clk_register_clkdev(clk[fec_ipg_gate], "ipg", "imx27-fec.0");
-- 
1.7.9.5

