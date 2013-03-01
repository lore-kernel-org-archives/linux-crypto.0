From: Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v3 1/2] i.MX27: Add clock support for SAHARA2.
Date: Fri,  1 Mar 2013 12:37:52 +0100
Message-ID: <1362137873-8827-2-git-send-email-javier.martin@vista-silicon.com>
References: <1362137873-8827-1-git-send-email-javier.martin@vista-silicon.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org, davem@davemloft.net,
	herbert@gondor.apana.org.au, kernel@pengutronix.de,
	gcembed@gmail.com, shawn.guo@linaro.org, arnd@arndb.de,
	swarren@nvidia.com, Javier Martin <javier.martin@vista-silicon.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37086 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab3CALiL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 1 Mar 2013 06:38:11 -0500
Received: by mail-wi0-f170.google.com with SMTP id hm11so10286480wib.5
        for <linux-crypto@vger.kernel.org>; Fri, 01 Mar 2013 03:38:09 -0800 (PST)
In-Reply-To: <1362137873-8827-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


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
