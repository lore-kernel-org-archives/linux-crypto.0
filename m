From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 1/2] hwrng: meson: expose RNG0 clock via DT
Date: Sun, 19 Feb 2017 21:33:16 +0100
Message-ID: <a02b078d-9171-cf66-d5d8-84259f9f9a88@gmail.com>
References: <00b2a4cc-686e-0cc0-43e8-552b70a1e868@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Neil Armstrong <narmstrong@baylibre.com>,
        linux-amlogic@lists.infradead.org, linux-crypto@vger.kernel.org
To: Kevin Hilman <khilman@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36309 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751067AbdBSUdX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 19 Feb 2017 15:33:23 -0500
Received: by mail-wm0-f67.google.com with SMTP id r18so11169789wmd.3
        for <linux-crypto@vger.kernel.org>; Sun, 19 Feb 2017 12:33:22 -0800 (PST)
In-Reply-To: <00b2a4cc-686e-0cc0-43e8-552b70a1e868@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Expose the RNG0 clock via DT.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi   | 2 +-
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi | 5 +++++
 include/dt-bindings/clock/gxbb-clkc.h       | 1 +
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
index 5d995f77..620495a4 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
@@ -380,7 +380,7 @@
 			#size-cells = <2>;
 			ranges = <0x0 0x0 0x0 0xc8834000 0x0 0x2000>;
 
-			rng {
+			hwrng: rng {
 				compatible = "amlogic,meson-rng";
 				reg = <0x0 0x0 0x0 0x4>;
 			};
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
index 04b3324b..a375cb21 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
@@ -524,3 +524,8 @@
 &vpu {
 	compatible = "amlogic,meson-gxbb-vpu", "amlogic,meson-gx-vpu";
 };
+
+&hwrng {
+	clocks = <&clkc CLKID_RNG0>;
+	clock-names = "core";
+};
diff --git a/include/dt-bindings/clock/gxbb-clkc.h b/include/dt-bindings/clock/gxbb-clkc.h
index 692846c7..473676b1 100644
--- a/include/dt-bindings/clock/gxbb-clkc.h
+++ b/include/dt-bindings/clock/gxbb-clkc.h
@@ -15,6 +15,7 @@
 #define CLKID_SPI		34
 #define CLKID_I2C		22
 #define CLKID_SAR_ADC		23
+#define CLKID_RNG0		25
 #define CLKID_ETH		36
 #define CLKID_USB0		50
 #define CLKID_USB1		51
-- 
2.11.1
