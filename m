From: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH RESEND v2 3/4] hwrng: atmel: Add TRNG DT binding doc
Date: Thu, 20 Nov 2014 10:43:24 +0100
Message-ID: <893e967b65478a2ea0e6269e24bc7a104f2e0c07.1416475860.git.nicolas.ferre@atmel.com>
References: <cover.1416475860.git.nicolas.ferre@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-kernel@vger.kernel.org>, <mpm@selenic.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Alexandre Belloni <alexandre.belloni@free-electrons.com>,
	Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
	<robh+dt@kernel.org>, <mark.rutland@arm.com>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<peter@korsgaard.com>
To: <linux-arm-kernel@lists.infradead.org>,
	<herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1416475860.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Boris Brezillon <boris.brezillon@free-electrons.com>

Document DT bindings of Atmel's TRNG (True Random Number Generator) IP.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Acked-by: Peter Korsgaard <peter@korsgaard.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 Documentation/devicetree/bindings/hwrng/atmel-trng.txt | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/hwrng/atmel-trng.txt

diff --git a/Documentation/devicetree/bindings/hwrng/atmel-trng.txt b/Documentation/devicetree/bindings/hwrng/atmel-trng.txt
new file mode 100644
index 000000000000..4ac5aaa2d024
--- /dev/null
+++ b/Documentation/devicetree/bindings/hwrng/atmel-trng.txt
@@ -0,0 +1,16 @@
+Atmel TRNG (True Random Number Generator) block
+
+Required properties:
+- compatible : Should be "atmel,at91sam9g45-trng"
+- reg : Offset and length of the register set of this block
+- interrupts : the interrupt number for the TRNG block
+- clocks: should contain the TRNG clk source
+
+Example:
+
+trng@fffcc000 {
+	compatible = "atmel,at91sam9g45-trng";
+	reg = <0xfffcc000 0x4000>;
+	interrupts = <6 IRQ_TYPE_LEVEL_HIGH 0>;
+	clocks = <&trng_clk>;
+};
-- 
2.1.3
