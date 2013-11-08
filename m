From: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH RESEND 1/7] ARM: at91/dt/trivial: use macro for AES irq type
Date: Fri, 8 Nov 2013 16:08:10 +0100
Message-ID: <65912068430b5832aeb586f9ea588d1861b43ad0.1383922546.git.nicolas.ferre@atmel.com>
References: <cover.1383922546.git.nicolas.ferre@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-kernel@vger.kernel.org>, <eric@eukrea.com>,
	Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>,
	<herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1383922546.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/sama5d3.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index b7f4961..fca56c7 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -359,7 +359,7 @@
 			aes@f8038000 {
 				compatible = "atmel,sam9g46-aes";
 				reg = <0xf8038000 0x100>;
-				interrupts = <43 4 0>;
+				interrupts = <43 IRQ_TYPE_LEVEL_HIGH 0>;
 			};
 
 			tdes@f803c000 {
-- 
1.8.2.2
