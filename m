From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH RESEND 2/4] arm64: dts: ls1012a: add caam-dma node
Date: Mon, 30 Oct 2017 15:46:52 +0200
Message-ID: <20171030134654.13729-3-horia.geanta@nxp.com>
References: <20171030134654.13729-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <dmaengine@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <devicetree@vger.kernel.org>
To: Vinod Koul <vinod.koul@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Douglass <dan.douglass@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Radu Alexe <radu.alexe@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam03on0069.outbound.protection.outlook.com ([104.47.42.69]:20560
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932151AbdJ3NrQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Oct 2017 09:47:16 -0400
In-Reply-To: <20171030134654.13729-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Radu Alexe <radu.alexe@nxp.com>

Signed-off-by: Radu Alexe <radu.alexe@nxp.com>
---
 arch/arm64/boot/dts/freescale/fsl-ls1012a.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1012a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1012a.dtsi
index df83915d6ea6..f92ecf381cb1 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1012a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1012a.dtsi
@@ -197,6 +197,12 @@
 				interrupts = <GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>;
 			};
 
+			caam-dma {
+				compatible = "fsl,sec-v5.4-dma",
+					     "fsl,sec-v5.0-dma",
+					     "fsl,sec-v4.0-dma";
+			};
+
 			rtic@60000 {
 				compatible = "fsl,sec-v5.4-rtic",
 					     "fsl,sec-v5.0-rtic",
-- 
2.14.2.606.g7451fcd
