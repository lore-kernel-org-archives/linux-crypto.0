From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 1/7] Documentation/bindings: Document the SafeXel cryptographic engine driver
Date: Wed, 29 Mar 2017 14:44:26 +0200
Message-ID: <20170329124432.27457-2-antoine.tenart@free-electrons.com>
References: <20170329124432.27457-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        thomas.petazzoni@free-electrons.com,
        boris.brezillon@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        jason@lakedaemon.net, andrew@lunn.ch,
        gregory.clement@free-electrons.com, sebastian.hesselbarth@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:36253 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932111AbdC2Mon (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Mar 2017 08:44:43 -0400
In-Reply-To: <20170329124432.27457-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The Inside Secure Safexcel cryptographic engine is found on some Marvell
SoCs (7k/8k). Document the bindings used by its driver.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 .../bindings/crypto/inside-secure-safexcel.txt     | 27 ++++++++++++++++++++++
 1 file changed, 27 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt

diff --git a/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt b/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt
new file mode 100644
index 000000000000..ff56b9384fcc
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt
@@ -0,0 +1,27 @@
+Inside Secure SafeXcel cryptographic engine
+
+Required properties:
+- compatible: Should be "inside-secure,safexcel-eip197".
+- reg: Base physical address of the engine and length of memory mapped region.
+- interrupts: Interrupt numbers for the rings and engine.
+- interrupt-names: Should be "ring0", "ring1", "ring2", "ring3", "eip", "mem".
+
+Optional properties:
+- clocks: Reference to the crypto engine clock.
+
+Example:
+
+	crypto: crypto@800000 {
+		compatible = "inside-secure,safexcel-eip197";
+		reg = <0x800000 0x200000>;
+		interrupts = <GIC_SPI 34 (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_LEVEL_HIGH)>,
+			     <GIC_SPI 54 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 56 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 57 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 58 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "mem", "ring0", "ring1", "ring2", "ring3",
+				  "eip";
+		clocks = <&cpm_syscon0 1 26>;
+		status = "disabled";
+	};
-- 
2.11.0
