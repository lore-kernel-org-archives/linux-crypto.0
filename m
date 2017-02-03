From: Rob Rice <rob.rice@broadcom.com>
Subject: [PATCH v4 1/3] crypto: brcm: DT documentation for Broadcom SPU hardware
Date: Fri,  3 Feb 2017 12:55:32 -0500
Message-ID: <1486144534-44887-2-git-send-email-rob.rice@broadcom.com>
References: <1486144534-44887-1-git-send-email-rob.rice@broadcom.com>
Cc: Rob Rice <rob.rice@broadcom.com>,
        Steve Lin <steven.lin1@broadcom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1486144534-44887-1-git-send-email-rob.rice@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Device tree documentation for Broadcom Secure Processing Unit
(SPU) crypto hardware.

Signed-off-by: Steve Lin <steven.lin1@broadcom.com>
Signed-off-by: Rob Rice <rob.rice@broadcom.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/crypto/brcm,spu-crypto.txt | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/brcm,spu-crypto.txt

diff --git a/Documentation/devicetree/bindings/crypto/brcm,spu-crypto.txt b/Documentation/devicetree/bindings/crypto/brcm,spu-crypto.txt
new file mode 100644
index 0000000..29b6007
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/brcm,spu-crypto.txt
@@ -0,0 +1,22 @@
+The Broadcom Secure Processing Unit (SPU) hardware supports symmetric
+cryptographic offload for Broadcom SoCs. A SoC may have multiple SPU hardware
+blocks.
+
+Required properties:
+- compatible: Should be one of the following:
+  brcm,spum-crypto - for devices with SPU-M hardware
+  brcm,spu2-crypto - for devices with SPU2 hardware
+  brcm,spu2-v2-crypto - for devices with enhanced SPU2 hardware features like SHA3
+  and Rabin Fingerprint support
+  brcm,spum-nsp-crypto - for the Northstar Plus variant of the SPU-M hardware
+
+- reg: Should contain SPU registers location and length.
+- mboxes: The mailbox channel to be used to communicate with the SPU.
+  Mailbox channels correspond to DMA rings on the device.
+
+Example:
+	crypto@612d0000 {
+		compatible = "brcm,spum-crypto";
+		reg = <0 0x612d0000 0 0x900>;
+		mboxes = <&pdc0 0>;
+	};
-- 
2.1.0
