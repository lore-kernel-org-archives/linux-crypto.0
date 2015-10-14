From: Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH v3 3/3] ARM: dts: stm32f429: Adopt STM32 RNG driver
Date: Wed, 14 Oct 2015 16:55:25 +0100
Message-ID: <1444838125-3422-4-git-send-email-daniel.thompson@linaro.org>
References: <1443904519-24012-1-git-send-email-daniel.thompson@linaro.org>
 <1444838125-3422-1-git-send-email-daniel.thompson@linaro.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@linaro.org, linaro-kernel@lists.linaro.org,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Linus Walleij <linus.walleij@linaro.org>
To: Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:34290 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932668AbbJNPzt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Oct 2015 11:55:49 -0400
Received: by wicgb1 with SMTP id gb1so135545218wic.1
        for <linux-crypto@vger.kernel.org>; Wed, 14 Oct 2015 08:55:48 -0700 (PDT)
In-Reply-To: <1444838125-3422-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

New bindings and driver have been created for STM32 series parts. This
patch integrates this changes.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Acked-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
---
 arch/arm/boot/dts/stm32f429.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/stm32f429.dtsi b/arch/arm/boot/dts/stm32f429.dtsi
index cb0613090243..90081fc22c6c 100644
--- a/arch/arm/boot/dts/stm32f429.dtsi
+++ b/arch/arm/boot/dts/stm32f429.dtsi
@@ -175,6 +175,13 @@
 			reg = <0x40023800 0x400>;
 			clocks = <&clk_hse>;
 		};
+
+		rng: rng@50060800 {
+			compatible = "st,stm32-rng";
+			reg = <0x50060800 0x400>;
+			interrupts = <80>;
+			clocks = <&rcc 0 38>;
+		};
 	};
 };
 
-- 
2.4.3
