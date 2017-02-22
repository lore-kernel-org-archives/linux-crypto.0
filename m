From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v3 2/4] ARM64: dts: meson-gx: add clock to DT binding
 documentation for hwrng
Date: Wed, 22 Feb 2017 07:59:08 +0100
Message-ID: <86db7397-8355-0d07-5180-c78d6cd06c84@gmail.com>
References: <4e2d12e5-f75b-3ac6-a3f7-18e8a8b7283b@gmail.com>
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
In-Reply-To: <4e2d12e5-f75b-3ac6-a3f7-18e8a8b7283b@gmail.com>
Sender: linux-clk-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add clock to DT binding documentation.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
v2:
- splitted first version of patch into two
- add DT binding documentation
- mention that clock is optional
- replace spaces with tabs in DT binding example
v3:
- splitted DT extension and binding documentation update into two patches
---
 Documentation/devicetree/bindings/rng/amlogic,meson-rng.txt | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/rng/amlogic,meson-rng.txt b/Documentation/devicetree/bindings/rng/amlogic,meson-rng.txt
index 202f2d09..4d403645 100644
--- a/Documentation/devicetree/bindings/rng/amlogic,meson-rng.txt
+++ b/Documentation/devicetree/bindings/rng/amlogic,meson-rng.txt
@@ -6,9 +6,16 @@ Required properties:
 - compatible : should be "amlogic,meson-rng"
 - reg : Specifies base physical address and size of the registers.
 
+Optional properties:
+
+- clocks : phandle to the following named clocks
+- clock-names: Name of core clock, must be "core"
+
 Example:
 
 rng {
-        compatible = "amlogic,meson-rng";
-        reg = <0x0 0xc8834000 0x0 0x4>;
+	compatible = "amlogic,meson-rng";
+	reg = <0x0 0xc8834000 0x0 0x4>;
+	clocks = <&clkc CLKID_RNG0>;
+	clock-names = "core";
 };
-- 
2.11.1


