From: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5/6] ARM: STi: STiH407: Enable the 2 HW Random Number Generators for STiH4{07,10}
Date: Fri, 11 Sep 2015 21:08:29 +0100
Message-ID: <1442002110-28733-6-git-send-email-lee.jones@linaro.org>
References: <1442002110-28733-1-git-send-email-lee.jones@linaro.org>
Cc: kernel@stlinux.com, mpm@selenic.com, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442002110-28733-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stih407-family.dtsi | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/stih407-family.dtsi b/arch/arm/boot/dts/stih407-family.dtsi
index 838b812..9452b42 100644
--- a/arch/arm/boot/dts/stih407-family.dtsi
+++ b/arch/arm/boot/dts/stih407-family.dtsi
@@ -565,5 +565,19 @@
 						  <&phy_port2 PHY_TYPE_USB3>;
 			};
 		};
+
+		rng10: rng@08a89000 {
+			compatible      = "st,rng";
+			reg		= <0x08a89000 0x1000>;
+			clocks          = <&clk_sysin>;
+			status		= "okay";
+		};
+
+		rng11: rng@08a8a000 {
+			compatible      = "st,rng";
+			reg		= <0x08a8a000 0x1000>;
+			clocks          = <&clk_sysin>;
+			status		= "okay";
+		};
 	};
 };
-- 
1.9.1
