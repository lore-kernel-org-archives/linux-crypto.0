From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: [PATCH v5 1/3] Documentation: devicetree: add Freescale SCC bindings
Date: Tue, 12 Apr 2016 11:04:24 +0200
Message-ID: <1460451866-12821-1-git-send-email-s.trumtrar@pengutronix.de>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	kernel@pengutronix.de, Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Shawn Guo <shawnguo@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:47648 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755763AbcDLJEx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Apr 2016 05:04:53 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add documentation for the Freescale Security Controller (SCC)
found on i.MX25 SoCs.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Acked-by: Rob Herring <robh@kernel.org>
---

Changes in v2:

  - add clocks to required properties
  - add Acked-by

 .../devicetree/bindings/crypto/fsl-imx-scc.txt      | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/fsl-imx-scc.txt

diff --git a/Documentation/devicetree/bindings/crypto/fsl-imx-scc.txt b/Documentation/devicetree/bindings/crypto/fsl-imx-scc.txt
new file mode 100644
index 000000000000..7aad448e8a36
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/fsl-imx-scc.txt
@@ -0,0 +1,21 @@
+Freescale Security Controller (SCC)
+
+Required properties:
+- compatible : Should be "fsl,imx25-scc".
+- reg : Should contain register location and length.
+- interrupts : Should contain interrupt numbers for SCM IRQ and SMN IRQ.
+- interrupt-names : Should specify the names "scm" and "smn" for the
+		    SCM IRQ and SMN IRQ.
+- clocks: Should contain the clock driving the SCC core.
+- clock-names: Should be set to "ipg".
+
+Example:
+
+	scc: crypto@53fac000 {
+		compatible = "fsl,imx25-scc";
+		reg = <0x53fac000 0x4000>;
+		clocks = <&clks 111>;
+		clock-names = "ipg";
+		interrupts = <49>, <50>;
+		interrupt-names = "scm", "smn";
+	};
-- 
2.7.0
