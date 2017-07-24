From: Lars Persson <lars.persson@axis.com>
Subject: [PATCH v2 1/4] dt-bindings: crypto: add ARTPEC crypto
Date: Mon, 24 Jul 2017 09:07:29 +0200
Message-ID: <b493a0eb939fe97f7e604c0c83916e0dac1d2bce.1500879613.git.larper@axis.com>
References: <cover.1500879613.git.larper@axis.com>
Cc: Lars Persson <larper@axis.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bastet.se.axis.com ([195.60.68.11]:48153 "EHLO
        bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752681AbdGXHHj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jul 2017 03:07:39 -0400
In-Reply-To: <cover.1500879613.git.larper@axis.com>
In-Reply-To: <cover.1500879613.git.larper@axis.com>
References: <cover.1500879613.git.larper@axis.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Document the device tree bindings for the ARTPEC crypto accelerator on
ARTPEC-6 and ARTPEC-7 SoCs.

Signed-off-by: Lars Persson <larper@axis.com>
---
 .../devicetree/bindings/crypto/artpec6-crypto.txt        | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/artpec6-crypto.txt

diff --git a/Documentation/devicetree/bindings/crypto/artpec6-crypto.txt b/Documentation/devicetree/bindings/crypto/artpec6-crypto.txt
new file mode 100644
index 000000000000..d9cca4875bd6
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/artpec6-crypto.txt
@@ -0,0 +1,16 @@
+Axis crypto engine with PDMA interface.
+
+Required properties:
+- compatible : Should be one of the following strings:
+	"axis,artpec6-crypto" for the version in the Axis ARTPEC-6 SoC
+	"axis,artpec7-crypto" for the version in the Axis ARTPEC-7 SoC.
+- reg: Base address and size for the PDMA register area.
+- interrupts: Interrupt handle for the PDMA interrupt line.
+
+Example:
+
+crypto@f4264000 {
+	compatible = "axis,artpec6-crypto";
+	reg = <0xf4264000 0x1000>;
+	interrupts = <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>;
+};
-- 
2.11.0
