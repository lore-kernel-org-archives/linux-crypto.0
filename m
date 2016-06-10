From: Neil Armstrong <narmstrong@baylibre.com>
Subject: [PATCH v2 3/3] ARM64: dts: meson-gxbb: Add Hardware Random Generator node
Date: Fri, 10 Jun 2016 10:21:55 +0200
Message-ID: <1465546915-24229-4-git-send-email-narmstrong@baylibre.com>
References: <1465546915-24229-1-git-send-email-narmstrong@baylibre.com>
Cc: Neil Armstrong <narmstrong@baylibre.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
To: Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1465546915-24229-1-git-send-email-narmstrong@baylibre.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
---
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
index 832815d..8353621 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
@@ -167,6 +167,11 @@
 			};
 		};
 
+		rng {
+			compatible = "amlogic,meson-rng";
+			reg = <0x0 0xc8834000 0x0 0x4>;
+		};
+
 		apb: apb@d0000000 {
 			compatible = "simple-bus";
 			reg = <0x0 0xd0000000 0x0 0x200000>;
-- 
2.7.0
