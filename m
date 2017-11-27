From: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH v2 3/3] ARM: dts: exynos: Add nodes for True Random Number
 Generator
Date: Mon, 27 Nov 2017 10:58:04 +0100
Message-ID: <20171127095804.7128-4-l.stelmach@samsung.com>
References: <20171127095804.7128-1-l.stelmach@samsung.com>
        <CGME20171127095810eucas1p2f580db5216f419551e4b530adcf9a41f@eucas1p2.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: "Andrew F. Davis" <afd@ti.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55887 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751596AbdK0J6O (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Nov 2017 04:58:14 -0500
In-reply-to: <20171127095804.7128-1-l.stelmach@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add nodes for the True Random Number Generator found in Samsung Exynos
5250+ SoCs.

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
---
 arch/arm/boot/dts/exynos5.dtsi    | 5 +++++
 arch/arm/boot/dts/exynos5250.dtsi | 5 +++++
 arch/arm/boot/dts/exynos5410.dtsi | 5 +++++
 arch/arm/boot/dts/exynos5420.dtsi | 5 +++++
 4 files changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5.dtsi b/arch/arm/boot/dts/exynos5.dtsi
index 7da4a4285b24..6a298b536e1c 100644
--- a/arch/arm/boot/dts/exynos5.dtsi
+++ b/arch/arm/boot/dts/exynos5.dtsi
@@ -210,5 +210,10 @@
 			reg = <0x10830000 0x300>;
 			interrupts = <GIC_SPI 112 IRQ_TYPE_LEVEL_HIGH>;
 		};
+
+		trng: trng@10830600 {
+		      compatible = "samsung,exynos5250-trng";
+		      reg = <0x10830600 0x100>;
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 8032d7e567fc..332fe04b772b 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -1081,4 +1081,9 @@
 	clock-names = "secss";
 };
 
+&trng {
+	clocks = <&clock CLK_SSS>;
+	clock-names = "secss";
+};
+
 #include "exynos5250-pinctrl.dtsi"
diff --git a/arch/arm/boot/dts/exynos5410.dtsi b/arch/arm/boot/dts/exynos5410.dtsi
index 7eab4bc07cec..f3991206a562 100644
--- a/arch/arm/boot/dts/exynos5410.dtsi
+++ b/arch/arm/boot/dts/exynos5410.dtsi
@@ -379,6 +379,11 @@
 		  3 0 0x07000000 0x20000>;
 };
 
+&trng {
+	clocks = <&clock CLK_SSS>;
+	clock-names = "secss";
+};
+
 &usbdrd3_0 {
 	clocks = <&clock CLK_USBD300>;
 	clock-names = "usbdrd30";
diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index 02d2f898efa6..2f4e5542f354 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -1454,6 +1454,11 @@
 	clock-names = "secss";
 };
 
+&trng {
+	clocks = <&clock CLK_SSS>;
+	clock-names = "secss";
+};
+
 &usbdrd3_0 {
 	clocks = <&clock CLK_USBD300>;
 	clock-names = "usbdrd30";
-- 
2.11.0
