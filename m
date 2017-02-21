From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v2 2/3] ARM64: dts: meson-gx: add clock CLKID_RNG0 to hwrng
 node
Date: Tue, 21 Feb 2017 21:18:16 +0100
Message-ID: <8bf052e3-de8f-dbdf-be76-369a7bb1ed15@gmail.com>
References: <daf765e2-1a60-8dea-fee0-8af6ddecdf8e@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-clk@vger.kernel.org, devicetree@vger.kernel.org
To: Jerome Brunet <jbrunet@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-amlogic@lists.infradead.org, linux-crypto@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Michael Turquette <mturquette@baylibre.com>
Return-path: <linux-clk-owner@vger.kernel.org>
In-Reply-To: <daf765e2-1a60-8dea-fee0-8af6ddecdf8e@gmail.com>
Sender: linux-clk-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add clock CLKID_RNG0 to HW randon number generator node and
extend the DT binding documentation accordingly.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
v2:
- splitted first version of patch into two
- add DT binding documentation
- mention that clock is optional
- replace spaces with tabs in DT binding example
---
 Documentation/devicetree/bindings/rng/amlogic,meson-rng.txt | 8 ++++++--
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi                   | 2 +-
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi                 | 5 +++++
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/rng/amlogic,meson-rng.txt b/Documentation/devicetree/bindings/rng/amlogic,meson-rng.txt
index 202f2d09..4c012a04 100644
--- a/Documentation/devicetree/bindings/rng/amlogic,meson-rng.txt
+++ b/Documentation/devicetree/bindings/rng/amlogic,meson-rng.txt
@@ -5,10 +5,14 @@ Required properties:
 
 - compatible : should be "amlogic,meson-rng"
 - reg : Specifies base physical address and size of the registers.
+- clocks : Optional core clock
+- clock-names: Name of core clock, must be "core"
 
 Example:
 
 rng {
-        compatible = "amlogic,meson-rng";
-        reg = <0x0 0xc8834000 0x0 0x4>;
+	compatible = "amlogic,meson-rng";
+	reg = <0x0 0xc8834000 0x0 0x4>;
+	clocks = <&clkc CLKID_RNG0>;
+	clock-names = "core";
 };
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
-- 
2.11.1


