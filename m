From: Lars Persson <lars.persson-VrBV9hrLPhE@public.gmane.org>
Subject: [PATCH 1/4] dt-bindings: crypto: add ARTPEC crypto
Date: Thu, 20 Jul 2017 15:44:29 +0200
Message-ID: <b493a0eb939fe97f7e604c0c83916e0dac1d2bce.1500557664.git.larper@axis.com>
References: <cover.1500557664.git.larper@axis.com>
Cc: Lars Persson <larper-VrBV9hrLPhE@public.gmane.org>
To: herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
        robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1500557664.git.larper-VrBV9hrLPhE@public.gmane.org>
In-Reply-To: <cover.1500557664.git.larper-VrBV9hrLPhE@public.gmane.org>
References: <cover.1500557664.git.larper-VrBV9hrLPhE@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Document the device tree bindings for the ARTPEC crypto accelerator on
ARTPEC-6 and ARTPEC-7 SoCs.

Signed-off-by: Lars Persson <larper-VrBV9hrLPhE@public.gmane.org>
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

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
