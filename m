From: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Subject: [PATCHi v2] dt-bindings: add device tree binding for Arm TrustZone CryptoCell crypto engine
Date: Thu, 16 Nov 2017 06:15:28 +0000
Message-ID: <1510812929-3937-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang-5wv7dgnIgG8@public.gmane.org>, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

The Arm TrustZone CryptoCell is a hardware security engine. This patch
adds DT bindings for its Rich Execution Environment crypto engine.

A driver supporting this device is already present in the staging tree.

Signed-off-by: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Acked-by: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---

Changes from v1:
- Change node name to reflect type of device in example as pointed out by
  Rob Herring.

 .../devicetree/bindings/crypto/arm-cryptocell.txt  | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/arm-cryptocell.txt

diff --git a/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt b/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
new file mode 100644
index 0000000..cec8d5d
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
@@ -0,0 +1,22 @@
+Arm TrustZone CryptoCell cryptographic engine
+
+Required properties:
+- compatible: Should be "arm,cryptocell-712-ree".
+- reg: Base physical address of the engine and length of memory mapped region.
+- interrupts: Interrupt number for the device.
+
+Optional properties:
+- interrupt-parent: The phandle for the interrupt controller that services
+  interrupts for this device.
+- clocks: Reference to the crypto engine clock.
+- dma-coherent: Present if dma operations are coherent.
+
+Examples:
+
+       arm_cc712: crypto@80000000 {
+               compatible = "arm,cryptocell-712-ree";
+               interrupt-parent = <&intc>;
+               interrupts = < 0 30 4 >;
+               reg = < 0x80000000 0x10000 >;
+
+       };
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
