From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH RESEND 4/4] ARM: at91/dt: add trng node
Date: Wed, 19 Nov 2014 17:07:58 +0100
Message-ID: <1416413278-10197-5-git-send-email-boris.brezillon@free-electrons.com>
References: <1416413278-10197-1-git-send-email-boris.brezillon@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Alexandre Belloni <alexandre.belloni@free-electrons.com>,
	Andrew Victor <linux@maxim.org.za>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	Boris Brezillon <boris.brezillon@free-electrons.com>
To: Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:39931 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932387AbaKSQIF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Nov 2014 11:08:05 -0500
In-Reply-To: <1416413278-10197-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add a DT node for the TRNG (True Random Number Generator) block.

Keep this block enabled as it does not depend on any external connection,
and thus should be available on all boards.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/at91sam9g45.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
index 932a669..790c890 100644
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -934,6 +934,13 @@
 				status = "disabled";
 			};
 
+			trng@fffcc000 {
+				compatible = "atmel,at91sam9g45-trng";
+				reg = <0xfffcc000 0x4000>;
+				interrupts = <6 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&trng_clk>;
+			};
+
 			i2c0: i2c@fff84000 {
 				compatible = "atmel,at91sam9g10-i2c";
 				reg = <0xfff84000 0x100>;
-- 
1.9.1
