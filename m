From: James Hartley <james.hartley@imgtec.com>
Subject: [PATCH V3 2/2] Documentation: crypto: Add DT binding info for the img hw hash accelerator
Date: Fri, 6 Mar 2015 02:58:27 +0000
Message-ID: <1425610707-9869-3-git-send-email-james.hartley@imgtec.com>
References: <1425610707-9869-1-git-send-email-james.hartley@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <james.hartley@imgtec.com>
To: <herbert@gondor.apana.org.au>, <robh+dt@kernel.org>,
	<pawel.moll@arm.com>, <mark.rutland@arm.com>,
	<galak@codeaurora.org>, <andrew.bresticker@chromium.org>,
	<ezequiel.garcia@imgtec.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:24084 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbbCFC7E (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Mar 2015 21:59:04 -0500
In-Reply-To: <1425610707-9869-1-git-send-email-james.hartley@imgtec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This adds the binding documentation for the Imagination Technologies
hash accelerator that provides hardware acceleration for
SHA1/SHA224/SHA256/MD5 hashes.  This hardware will be present in
the upcoming pistachio SoC.

Signed-off-by: James Hartley <james.hartley@imgtec.com>
---
 .../devicetree/bindings/crypto/img-hash.txt        |   27 ++++++++++++++++++++
 1 file changed, 27 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/img-hash.txt

diff --git a/Documentation/devicetree/bindings/crypto/img-hash.txt b/Documentation/devicetree/bindings/crypto/img-hash.txt
new file mode 100644
index 0000000..7adc519
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
+- clock-names : "hash_clk" Used to clock data through the accelerator
+		"hash_reg_clk" Used to clock the hash block registers
+
+Example:
+
+	hash: hash@18149600 {
+	compatible = "img,hash-accelerator";
+		reg = <0x18149600 0x100, 0x18101100 0x4>;
+		interrupts = <GIC_SHARED 59 IRQ_TYPE_LEVEL_HIGH>;
+		dmas = <&dma 8 0xffffffff>;
+		dma-names = "tx";
+		clocks = <&cr_periph SYS_CLK_HASH>, <&clk_periph PERIPH_CLK_ROM>;
+		clock-names = "hash_clk, hash_reg_clk";
+	};
-- 
1.7.9.5
