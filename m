From: Lars Persson <lars.persson@axis.com>
Subject: [PATCH v3 1/4] dt-bindings: crypto: add ARTPEC crypto
Date: Fri,  4 Aug 2017 09:18:45 +0200
Message-ID: <b493a0eb939fe97f7e604c0c83916e0dac1d2bce.1501830919.git.larper@axis.com>
References: <cover.1501830919.git.larper@axis.com>
Cc: Lars Persson <larper@axis.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1501830919.git.larper@axis.com>
In-Reply-To: <cover.1501830919.git.larper@axis.com>
References: <cover.1501830919.git.larper@axis.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

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
