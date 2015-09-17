From: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v2 6/7] ARM: STi: STiH407: Enable the 2 HW Random Number Generators for STiH4{07,10}
Date: Thu, 17 Sep 2015 14:45:56 +0100
Message-ID: <1442497557-9271-7-git-send-email-lee.jones@linaro.org>
References: <1442497557-9271-1-git-send-email-lee.jones@linaro.org>
Cc: kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, peter@korsgaard.com,
	festevam@gmail.com, kieranbingham@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:35842 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbbIQNqP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Sep 2015 09:46:15 -0400
Received: by wicgb1 with SMTP id gb1so118747069wic.1
        for <linux-crypto@vger.kernel.org>; Thu, 17 Sep 2015 06:46:14 -0700 (PDT)
In-Reply-To: <1442497557-9271-1-git-send-email-lee.jones@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

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
