From: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4] ARM: dts: exynos: Add nodes for True Random Number
 Generator
Date: Tue, 12 Dec 2017 13:09:02 +0100
Message-ID: <20171212120902.16561-1-l.stelmach@samsung.com>
References: <20171204125351.26805-4-l.stelmach@samsung.com>
        <CGME20171212120906eucas1p23883590efde24a67800473b0d34871e5@eucas1p2.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>,
        Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
To: "Andrew F . Davis" <afd-l0cyMroinI0@public.gmane.org>,
        PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Kukjin Kim <kgene-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20171204125351.26805-4-l.stelmach-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Add nodes for the True Random Number Generator found in Samsung Exynos
5250+ SoCs.

Signed-off-by: Łukasz Stelmach <l.stelmach-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
Changes since v3:

- Rebased accroding to Krzysztof Kozłowski's request

 arch/arm/boot/dts/exynos5.dtsi    | 5 +++++
 arch/arm/boot/dts/exynos5250.dtsi | 5 +++++
 arch/arm/boot/dts/exynos5410.dtsi | 5 +++++
 arch/arm/boot/dts/exynos5420.dtsi | 5 +++++
 4 files changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5.dtsi b/arch/arm/boot/dts/exynos5.dtsi
index 6cc5c37a9b2a..b3c8428de389 100644
--- a/arch/arm/boot/dts/exynos5.dtsi
+++ b/arch/arm/boot/dts/exynos5.dtsi
@@ -216,6 +216,11 @@
 		      reg = <0x10830400 0x200>;
 		};
 
+		trng: rng@10830600 {
+		      compatible = "samsung,exynos5250-trng";
+		      reg = <0x10830600 0x100>;
+		};
+
 		g2d: g2d@10850000 {
 			compatible = "samsung,exynos5250-g2d";
 			reg = <0x10850000 0x1000>;
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index e55748798845..bdd742e3f3c3 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -1111,4 +1111,9 @@
 	clock-names = "secss";
 };
 
+&trng {
+	clocks = <&clock CLK_SSS>;
+	clock-names = "secss";
+};
+
 #include "exynos5250-pinctrl.dtsi"
diff --git a/arch/arm/boot/dts/exynos5410.dtsi b/arch/arm/boot/dts/exynos5410.dtsi
index f5541000606b..4e5d9bad085f 100644
--- a/arch/arm/boot/dts/exynos5410.dtsi
+++ b/arch/arm/boot/dts/exynos5410.dtsi
@@ -392,6 +392,11 @@
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
index 3611f5c05235..f7c2ba61830b 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -1479,6 +1479,11 @@
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

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
