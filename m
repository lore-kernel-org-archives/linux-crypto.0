From: James Hartley <james.hartley@imgtec.com>
Subject: [PATCH V5 2/2] Documentation: crypto: Add DT binding info for the img hw hash accelerator
Date: Thu, 12 Mar 2015 23:17:27 +0000
Message-ID: <1426202247-6221-3-git-send-email-james.hartley@imgtec.com>
References: <1426202247-6221-1-git-send-email-james.hartley@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <devicetree@vger.kernel.org>, <ezequiel.garcia@imgtec.com>,
	<linux-crypto@vger.kernel.org>, <james.hartley@imgtec.com>
To: <herbert@gondor.apana.org.au>, <abrestic@chromium.org>,
	<smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:20302 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbbCLXRh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Mar 2015 19:17:37 -0400
In-Reply-To: <1426202247-6221-1-git-send-email-james.hartley@imgtec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This adds the binding documentation for the Imagination Technologies hash
accelerator that provides hardware acceleration for SHA1/SHA224/SHA256/MD5
hashes.  This hardware will be present in the upcoming pistachio SoC.

Signed-off-by: James Hartley <james.hartley@imgtec.com>
Reviewed-by: Andrew Bresticker <abrestic@chromium.org>
---
 .../devicetree/bindings/crypto/img-hash.txt        |   27 ++++++++++++++++++++
 1 file changed, 27 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/img-hash.txt

diff --git a/Documentation/devicetree/bindings/crypto/img-hash.txt b/Documentation/devicetree/bindings/crypto/img-hash.txt
new file mode 100644
index 0000000..91a3d75
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/img-hash.txt
@@ -0,0 +1,27 @@
+Imagination Technologies hardware hash accelerator
+
+The hash accelerator provides hardware hashing acceleration for
+SHA1, SHA224, SHA256 and MD5 hashes
+
+Required properties:
+
+- compatible : "img,hash-accelerator"
+- reg : Offset and length of the register set for the module, and the DMA port
+- interrupts : The designated IRQ line for the hashing module.
+- dmas : DMA specifier as per Documentation/devicetree/bindings/dma/dma.txt
+- dma-names : Should be "tx"
+- clocks : Clock specifiers
+- clock-names : "sys" Used to clock the hash block registers
+		"hash" Used to clock data through the accelerator
+
+Example:
+
+	hash: hash@18149600 {
+	compatible = "img,hash-accelerator";
+		reg = <0x18149600 0x100>, <0x18101100 0x4>;
+		interrupts = <GIC_SHARED 59 IRQ_TYPE_LEVEL_HIGH>;
+		dmas = <&dma 8 0xffffffff 0>;
+		dma-names = "tx";
+		clocks = <&cr_periph SYS_CLK_HASH>, <&clk_periph PERIPH_CLK_ROM>;
+		clock-names = "sys", "hash";
+	};
-- 
1.7.9.5
