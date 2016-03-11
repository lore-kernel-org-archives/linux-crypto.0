From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: [PATCH v2 1/3] Documentation: devicetree: add Freescale RNGC binding
Date: Fri, 11 Mar 2016 15:06:38 +0100
Message-ID: <1457705200-16951-1-git-send-email-s.trumtrar@pengutronix.de>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	kernel@pengutronix.de, Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Shawn Guo <shawnguo@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Matt Mackall <mpm@selenic.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:51214 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932241AbcCKOHM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Mar 2016 09:07:12 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add binding documentation for the Freescale RNGC found on
some i.MX2/3/5 SoCs.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
---
 Documentation/devicetree/bindings/rng/mxc_rngc.txt | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/mxc_rngc.txt

diff --git a/Documentation/devicetree/bindings/rng/mxc_rngc.txt b/Documentation/devicetree/bindings/rng/mxc_rngc.txt
new file mode 100644
index 000000000000..e147a6dde40a
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/mxc_rngc.txt
@@ -0,0 +1,16 @@
+Freescale RNGC (Random Number Generator Version C)
+
+Required properties:
+- compatible : Should be "fsl,imx25-rng"
+- reg : Offset and length of the register set of this block
+- interrupts : the interrupt number for the RNG block
+- clocks: should contain the RNG clk source
+
+Example:
+
+rng@53fb0000 {
+	compatible = "fsl,imx25-rng";
+	reg = <0x53fb0000 0x4000>;
+	interrupts = <22>;
+	clocks = <&trng_clk>;
+};
-- 
2.7.0
