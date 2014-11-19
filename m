From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [PATCH RESEND 3/4] hwrng: atmel: Add TRNG DT binding doc
Date: Wed, 19 Nov 2014 17:07:57 +0100
Message-ID: <1416413278-10197-4-git-send-email-boris.brezillon@free-electrons.com>
References: <1416413278-10197-1-git-send-email-boris.brezillon@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre-AIFe0yeh4nAAvxtiuMwx3w@public.gmane.org>,
	Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>,
	Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Andrew Victor <linux-PelNFVqkFnVyf+4FbqDuWQ@public.gmane.org>,
	Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>,
	Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
	Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>,
	Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
To: Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1416413278-10197-1-git-send-email-boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Document DT bindings of Atmel's TRNG (True Random Number Generator) IP.

Signed-off-by: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Acked-by: Nicolas Ferre <nicolas.ferre-AIFe0yeh4nAAvxtiuMwx3w@public.gmane.org>
---
 Documentation/devicetree/bindings/hwrng/atmel-trng.txt | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/hwrng/atmel-trng.txt

diff --git a/Documentation/devicetree/bindings/hwrng/atmel-trng.txt b/Documentation/devicetree/bindings/hwrng/atmel-trng.txt
new file mode 100644
index 0000000..4ac5aaa
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
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
