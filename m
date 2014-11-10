From: James Hartley <james.hartley@imgtec.com>
Subject: [PATCH 2/2] Documentation: crypto: Add DT binding info for the img hw hash accelerator
Date: Mon, 10 Nov 2014 12:10:55 +0000
Message-ID: <1415621455-10468-3-git-send-email-james.hartley@imgtec.com>
References: <1415621455-10468-1-git-send-email-james.hartley@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <devicetree@vger.kernel.org>, <pawel.moll@arm.com>,
	<mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
	<galak@codeaurora.org>, <abrestic@chromium.org>,
	<ezequiel.garcia@imgtec.com>,
	James Hartley <james.hartley@imgtec.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<grant.likely@linaro.org>, <robh+dt@kernel.org>,
	<akpm@linux-foundation.org>, <gregkh@linuxfoundation.org>,
	<joe@perches.com>, <mchehab@osg.samsung.com>, <crope@iki.fi>,
	<jg1.han@samsung.com>, <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:18079 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbaKJMLh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Nov 2014 07:11:37 -0500
In-Reply-To: <1415621455-10468-1-git-send-email-james.hartley@imgtec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: James Hartley <james.hartley@imgtec.com>
---
 .../devicetree/bindings/crypto/img-hash.txt        |   28 ++++++++++++++++++++
 1 file changed, 28 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/img-hash.txt

diff --git a/Documentation/devicetree/bindings/crypto/img-hash.txt b/Documentation/devicetree/bindings/crypto/img-hash.txt
new file mode 100644
index 0000000..94d789c
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/img-hash.txt
@@ -0,0 +1,28 @@
+* Imagination Technologies Ltd. Hash Accelerator
+
+The hash accelerator provides hardware hashing acceleration for
+SHA1, SHA224, SHA256 and MD5 hashes
+
+Required properties:
+
+- compatible : "img,img-hash-accelerator-rev1"
+- reg : Offset and length of the register set for the module, and the DMA port
+- interrupts : The designated IRQ line for the hashing module.
+- dmas : DMA specifier as per Documentation/devicetree/bindings/dma/dma.txt
+- dma-names : Should be "tx"
+- bus-addr : The bus address for the input data for hashing block
+- clocks : Clock specifier
+- clock-names : "hash_clk" Used to clock data through the accelerator
+
+Example:
+
+	hash: hash@18149600 {
+	compatible = "img,img-hash-accelerator-rev1";
+		reg = <0x18149600 0x100, 0x18101100 0x4>;
+		interrupts = <59 4 2>;
+		dmas = <&dma 8 0xffffffff>;
+		dma-names = "tx";
+		bus-addr = <0x18101100>;
+		clocks = <&hash_clk>;
+		clock-names = "hash_clk";
+	};
-- 
1.7.9.5
