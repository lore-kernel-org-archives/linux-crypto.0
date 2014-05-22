From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 2/3] ARM: sun7i: dt: Add Security System to A20 SoC DTS
Date: Thu, 22 May 2014 17:09:55 +0200
Message-ID: <1400771396-9686-3-git-send-email-clabbe.montjoie@gmail.com>
References: <1400771396-9686-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	LABBE Corentin <clabbe.montjoie@gmail.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	rdunlap@infradead.org, maxime.ripard@free-electrons.com,
	linux@arm.linux.org.uk, herbert@gondor.apana.org.au,
	davem@davemloft.net, grant.likely@linaro.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1400771396-9686-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 arch/arm/boot/dts/sun7i-a20.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index f4b00a5..ea56552 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -523,6 +523,14 @@
 			status = "disabled";
 		};
 
+		crypto: crypto-engine@01c15000 {
+			compatible = "allwinner,sun7i-a20-crypto";
+			reg = <0x01c15000 0x1000>;
+			interrupts = <0 86 4>;
+			clocks = <&ahb_gates 5>, <&ss_clk>;
+			clock-names = "ahb", "mod";
+		};
+
 		spi2: spi@01c17000 {
 			compatible = "allwinner,sun4i-a10-spi";
 			reg = <0x01c17000 0x1000>;
-- 
1.8.5.5
