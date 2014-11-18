From: James Hartley <james.hartley@imgtec.com>
Subject: [PATCH V2 2/2] Documentation: crypto: Add DT binding info for the img hw hash accelerator
Date: Tue, 18 Nov 2014 20:48:47 +0000
Message-ID: <1416343727-2178-3-git-send-email-james.hartley@imgtec.com>
References: <1416343727-2178-1-git-send-email-james.hartley@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<grant.likely@linaro.org>, <robh+dt@kernel.org>,
	<gregkh@linuxfoundation.org>, <linux-crypto@vger.kernel.org>,
	<devicetree@vger.kernel.org>, <pawel.moll@arm.com>,
	<mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
	<galak@codeaurora.org>, <Ezequiel.Garcia@imgtec.com>,
	<abrestic@chromium.org>, <james.hartley@imgtec.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:23998 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152AbaKRUs5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 Nov 2014 15:48:57 -0500
In-Reply-To: <1416343727-2178-1-git-send-email-james.hartley@imgtec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This adds the binding documenation for the Imagination Technologies
hash accelerator that provides hardware acceleration for
SHA1/SHA224/SHA256/MD5 hashes.  This hardware will be present in
the upcoming pistachio SoC.

Signed-off-by: James Hartley <james.hartley@imgtec.com>
---
 .../devicetree/bindings/crypto/img-hash.txt        |   26 ++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/img-hash.txt

diff --git a/Documentation/devicetree/bindings/crypto/img-hash.txt b/Documentation/devicetree/bindings/crypto/img-hash.txt
new file mode 100644
index 0000000..72764a8
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/img-hash.txt
@@ -0,0 +1,26 @@
+* Imagination Technologies Ltd. Hash Accelerator
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
+- clocks : Clock specifier
+- clock-names : "hash_clk" Used to clock data through the accelerator
+
+Example:
+
+	hash: hash@18149600 {
+	compatible = "img,hash-accelerator";
+		reg = <0x18149600 0x100, 0x18101100 0x4>;
+		interrupts = <59 4 2>;
+		dmas = <&dma 8 0xffffffff>;
+		dma-names = "tx";
+		clocks = <&hash_clk>;
+		clock-names = "hash_clk";
+	};
-- 
1.7.9.5
