From: Rob Rice <rob.rice@broadcom.com>
Subject: [PATCH 1/3] crypto: brcm: DT documentation for Broadcom SPU driver
Date: Wed, 30 Nov 2016 15:07:31 -0500
Message-ID: <1480536453-24781-2-git-send-email-rob.rice@broadcom.com>
References: <1480536453-24781-1-git-send-email-rob.rice@broadcom.com>
Cc: Steve Lin <steven.lin1@broadcom.com>,
        Rob Rice <rob.rice@broadcom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Jon Mason <jonmason@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1480536453-24781-1-git-send-email-rob.rice@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Device tree documentation for Broadcom Secure Processing Unit
(SPU) crypto driver.

Signed-off-by: Steve Lin <steven.lin1@broadcom.com>
Signed-off-by: Rob Rice <rob.rice@broadcom.com>
---
 .../devicetree/bindings/crypto/brcm,spu-crypto.txt | 25 ++++++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/brcm,spu-crypto.txt

diff --git a/Documentation/devicetree/bindings/crypto/brcm,spu-crypto.txt b/Documentation/devicetree/bindings/crypto/brcm,spu-crypto.txt
new file mode 100644
index 0000000..e5fe942
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/brcm,spu-crypto.txt
@@ -0,0 +1,25 @@
+The Broadcom Secure Processing Unit (SPU) driver supports symmetric
+cryptographic offload for Broadcom SoCs with SPU hardware. A SoC may have
+multiple SPU hardware blocks.
+
+Required properties:
+- compatible : Should be "brcm,spum-crypto" for devices with SPU-M hardware
+  (e.g., Northstar2) or "brcm,spum-nsp-crypto" for the Northstar Plus variant
+  of the SPU-M hardware.
+
+- reg: Should contain SPU registers location and length.
+- mboxes: A list of mailbox channels to be used by the kernel driver. Mailbox
+channels correspond to DMA rings on the device.
+
+Example:
+	spu-crypto@612d0000 {
+		compatible = "brcm,spum-crypto";
+		reg = <0 0x612d0000 0 0x900>,    /* SPU 0 control regs */
+			<0 0x612f0000 0 0x900>,  /* SPU 1 control regs */
+			<0 0x61310000 0 0x900>,  /* SPU 2 control regs */
+			<0 0x61330000 0 0x900>;  /* SPU 3 control regs */
+		mboxes = <&pdc0 0>,
+			<&pdc1 0>,
+			<&pdc2 0>,
+			<&pdc3 0>;
+	};
--
2.1.0
