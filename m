From: Lars Persson <lars.persson@axis.com>
Subject: [PATCH v4 1/4] dt-bindings: crypto: add ARTPEC crypto
Date: Thu, 10 Aug 2017 14:53:51 +0200
Message-ID: <e5a9a6e0277ae2b49042d1acdbf36648446c1d3e.1502368677.git.larper@axis.com>
References: <cover.1502368677.git.larper@axis.com>
Cc: Lars Persson <larper@axis.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bastet.se.axis.com ([195.60.68.11]:33088 "EHLO
        bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751550AbdHJMx6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Aug 2017 08:53:58 -0400
In-Reply-To: <cover.1502368677.git.larper@axis.com>
In-Reply-To: <cover.1502368677.git.larper@axis.com>
References: <cover.1502368677.git.larper@axis.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Document the device tree bindings for the ARTPEC crypto accelerator on
ARTPEC-6 and ARTPEC-7 SoCs.

Acked-by: Rob Herring <robh@kernel.org>
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
