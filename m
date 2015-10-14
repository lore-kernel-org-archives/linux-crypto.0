From: Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH v3 1/3] dt-bindings: Document the STM32 HW RNG bindings
Date: Wed, 14 Oct 2015 16:55:23 +0100
Message-ID: <1444838125-3422-2-git-send-email-daniel.thompson@linaro.org>
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
Received: from mail-wi0-f170.google.com ([209.85.212.170]:34906 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932645AbbJNPzo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Oct 2015 11:55:44 -0400
Received: by wicll6 with SMTP id ll6so3738832wic.0
        for <linux-crypto@vger.kernel.org>; Wed, 14 Oct 2015 08:55:42 -0700 (PDT)
In-Reply-To: <1444838125-3422-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This adds documentation of device tree bindings for the STM32 hardware
random number generator.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Acked-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/rng/st,stm32-rng.txt        | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/st,stm32-rng.txt

diff --git a/Documentation/devicetree/bindings/rng/st,stm32-rng.txt b/Documentation/devicetree/bindings/rng/st,stm32-rng.txt
new file mode 100644
index 000000000000..47f04176f93b
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/st,stm32-rng.txt
@@ -0,0 +1,21 @@
+STMicroelectronics STM32 HW RNG
+===============================
+
+The STM32 hardware random number generator is a simple fixed purpose IP and
+is fully separated from other crypto functions.
+
+Required properties:
+
+- compatible : Should be "st,stm32-rng"
+- reg : Should be register base and length as documented in the datasheet
+- interrupts : The designated IRQ line for the RNG
+- clocks : The clock needed to enable the RNG
+
+Example:
+
+	rng: rng@50060800 {
+		compatible = "st,stm32-rng";
+		reg = <0x50060800 0x400>;
+		interrupts = <80>;
+		clocks = <&rcc 0 38>;
+	};
-- 
2.4.3
