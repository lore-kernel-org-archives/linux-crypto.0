From: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH v3 3/3] ARM: dts: exynos: Add nodes for True Random Number
 Generator
Date: Mon, 04 Dec 2017 13:53:51 +0100
Message-ID: <20171204125351.26805-4-l.stelmach@samsung.com>
References: <20171204125351.26805-1-l.stelmach@samsung.com>
        <CGME20171204125416eucas1p141878ea587d807a2559c90f590eab7fb@eucas1p1.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: "Andrew F . Davis" <afd@ti.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>, devicetree@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20171204125351.26805-1-l.stelmach@samsung.com>
In-reply-to: <20171204120429.22892-1-l.stelmach@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

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
index 33f929c1dda9..e0c91ff4442c 100644
--- a/arch/arm/boot/dts/exynos5.dtsi
+++ b/arch/arm/boot/dts/exynos5.dtsi
@@ -215,5 +215,10 @@
 		      compatible = "samsung,exynos5250-prng";
 		      reg = <0x10830400 0x200>;
 		};
+
+		trng: rng@10830600 {
+		      compatible = "samsung,exynos5250-trng";
+		      reg = <0x10830600 0x100>;
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 51aa83ba8c87..38627e8164a0 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -1086,4 +1086,9 @@
 	clock-names = "secss";
 };
 
+&trng {
+	clocks = <&clock CLK_SSS>;
+	clock-names = "secss";
+};
+
 #include "exynos5250-pinctrl.dtsi"
diff --git a/arch/arm/boot/dts/exynos5410.dtsi b/arch/arm/boot/dts/exynos5410.dtsi
index 1604cb1b837d..aa8b14eda662 100644
--- a/arch/arm/boot/dts/exynos5410.dtsi
+++ b/arch/arm/boot/dts/exynos5410.dtsi
@@ -384,6 +384,11 @@
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
index 31c77ea9123d..6c8cec9d564a 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -1459,6 +1459,11 @@
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
