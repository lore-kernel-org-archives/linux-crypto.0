From: Martin Kaiser <martin@kaiser.cx>
Subject: [PATCH v6 1/3] Documentation: devicetree: add Freescale RNGC binding
Date: Sun, 23 Jul 2017 19:49:04 +0200
Message-ID: <1500832146-8660-1-git-send-email-martin@kaiser.cx>
References: <1457705200-16951-1-git-send-email-s.trumtrar@pengutronix.de>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de,
        Fabio Estevam <festevam@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Martin Kaiser <martin@kaiser.cx>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from botnar.kaiser.cx ([176.28.20.183]:52432 "EHLO botnar.kaiser.cx"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751410AbdGWRuf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 23 Jul 2017 13:50:35 -0400
In-Reply-To: <1457705200-16951-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Steffen Trumtrar <s.trumtrar@pengutronix.de>

Add binding documentation for the Freescale RNGC found on
some i.MX2/3 SoCs.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
---
Changes in v6:
  - be more precise about rngc and rngb
  - get rid of mxc, rename the file to imx-rngc.txt
  - reformat the compatible strings
  - use RNGC instead of RNG
  - clarify that clock is not optional (remove "should contain")

Changes in v5:
  none

Changes in v4:
  none

Changes in v3:
  - add compatible string for imx35
  - remove imx5 from the commit message,
    I couldn't find an i.MX SOC that has RNGC

Changes in v2:
  none

 Documentation/devicetree/bindings/rng/imx-rngc.txt | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/imx-rngc.txt

diff --git a/Documentation/devicetree/bindings/rng/imx-rngc.txt b/Documentation/devicetree/bindings/rng/imx-rngc.txt
new file mode 100644
index 0000000..93c7174
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/imx-rngc.txt
@@ -0,0 +1,21 @@
+Freescale RNGC (Random Number Generator Version C)
+
+The driver also supports version B, which is mostly compatible
+to version C.
+
+Required properties:
+- compatible : should be one of
+               "fsl,imx25-rngb"
+               "fsl,imx35-rngc"
+- reg : offset and length of the register set of this block
+- interrupts : the interrupt number for the RNGC block
+- clocks : the RNGC clk source
+
+Example:
+
+rng@53fb0000 {
+	compatible = "fsl,imx25-rngb";
+	reg = <0x53fb0000 0x4000>;
+	interrupts = <22>;
+	clocks = <&trng_clk>;
+};
-- 
2.1.4
