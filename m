From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: [PATCH v3 2/3] ARM: i.MX25: add scc module to dtsi
Date: Mon,  7 Mar 2016 13:00:04 +0100
Message-ID: <1457352005-17457-2-git-send-email-s.trumtrar@pengutronix.de>
References: <1457352005-17457-1-git-send-email-s.trumtrar@pengutronix.de>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	kernel@pengutronix.de, Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Shawn Guo <shawnguo@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:56467 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752169AbcCGMAu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Mar 2016 07:00:50 -0500
In-Reply-To: <1457352005-17457-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add the Security Controller (SCC) module to the dtsi.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
---
 arch/arm/boot/dts/imx25.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/imx25.dtsi b/arch/arm/boot/dts/imx25.dtsi
index cde329e9b9e3..73118aba4cc4 100644
--- a/arch/arm/boot/dts/imx25.dtsi
+++ b/arch/arm/boot/dts/imx25.dtsi
@@ -397,6 +397,15 @@
 				interrupts = <41>;
 			};
 
+			scc: crypto@53fac000 {
+				compatible = "fsl,imx25-scc";
+				reg = <0x53fac000 0x4000>;
+				clocks = <&clks 111>;
+				clock-names = "ipg";
+				interrupts = <49>, <50>;
+				interrupt-names = "scm", "smn";
+			};
+
 			esdhc1: esdhc@53fb4000 {
 				compatible = "fsl,imx25-esdhc";
 				reg = <0x53fb4000 0x4000>;
-- 
2.7.0
