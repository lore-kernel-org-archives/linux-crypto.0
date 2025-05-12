Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3212529373B
	for <linux-crypto@vger.kernel.org>; Mon, 12 May 2025 12:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747051560; cv=none; b=Y0fT6psM7s7zASbM+jcex5TNKH3yusA20DlCzMw6qBv3DjiOKUqLggQNnomQvdx9hD/ctfoLkkbLMAufGRq7beA1k0TJrCpl4Q67zqTVGoeQbWiys0Tm70lnpJBChVHX6hvzSY7Z0KQ6nIsFYUP9qw3RIt6/36HeCog8tYpJCTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747051560; c=relaxed/simple;
	bh=gM3ZQtP5fl+y/vusB5lo6et9+sqNU8P2xYf11kTHSMc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=C1btSLFUKcWwpdQVf4VZOjdnqRe9gYbUpZn0kEnhHki0/UuP7DlI6oYtKGZQ6FYqHSwWTIHaMZASEQJP1cl5Jnyc5Vc05leOkq9A64OTVANDeCLzroqsx+Mj1Vj00f9N4+s84TsKqsy+a2HRAnw5el/8bPEM5lhNqTvr7AfQvvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bYZdaX9U; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bYZdaX9U"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-54b09cb06b0so5797639e87.1
        for <linux-crypto@vger.kernel.org>; Mon, 12 May 2025 05:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747051556; x=1747656356; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iEf4cNwCAvTux6g5ErQoMK0ZXsg4RGhL1cTSbSRkU48=;
        b=bYZdaX9U7Lyys6LUy8Cnb0BmQfbQbqqD3vaP+W/67ajUQdN0hB0CB/UBVujxGPXVB6
         gJIMgVpeAWbEy8psHdoqfervYTIN6NLLulYoPX8X0/pKdqkHsaAUd6zsBvv2y8hctCRi
         ILH+HCFxXvKIPRsnLBZzFkR9Bm45jzdcs/ugdbutmi2wsOYkMlXsBRF88RLlHAxGmujU
         /9pjUFadUPuW2QcSWIcbAmMeqPR2E/o5WDFaom7mV/MZZuV5NGFuKotdxPjTnEsLaxB+
         NMKdlxalmdBEXar4Q0zuAFK2TPEOebeSCeWL4jPz8xPgxC5oK30jQOHJWNIS2URWqLkw
         fqdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747051556; x=1747656356;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iEf4cNwCAvTux6g5ErQoMK0ZXsg4RGhL1cTSbSRkU48=;
        b=VGxqOssleQh9/TNRCoGMKKR8KwQxUYzDllAi/DsCphaXrqDeQrXskI7x5yzmaUEQO5
         EzMh7PqM0MEpeMuT2N2JwURhoDYgM+wA8jDfNmPUyQ1/uOIQnm0QTr+WU6aOQSaOQkpd
         r1jDrfJMPAxYuu4jMcyGkqeMWk4NrBmDSCJ2iZb1lqNF0tplJOMHn+KmSttIw00z8h+A
         tQt2fSJuTbjSSU++rBwXqfmQKHIakOJJj2C7lk+3RaAB1ptR4F7BUH+AoQ2thESpEMcR
         XNMu/3wYKQdgS7YAhKsk3UhizdWTLdncXLLtMvrzhCj5xNhPvy3X742Y4J/61RAXEB/5
         lofg==
X-Forwarded-Encrypted: i=1; AJvYcCVFOq6FLT+DY2D8+JCBdDaFVlYAM5y3AXehn+eP22qbQQ/qq7zxxbeCBEttMzLB+l2e4A9RU1RAzsHZE74=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfLlKs0tYcglr/jfu3jpLlZmrBBJIrEM+ksVrXRsl/ElLu5Go4
	JwzZJj3xkUbOxwdLOAnp8NpAgvNjo/Gap0gtdk8xzXut/wgD18Kn+xo8AQ1ycTt5hLbHKu90r+k
	v
X-Gm-Gg: ASbGncsHlcXB4B2FIH64dOSLJPOisV+kPSn9yPMwzUDbAD/SO2iu6id4hj7O7d94TjY
	LZoBrfwWGhw7jeZPZJ9xajlruqKs690ZNbmE45gVfaFh+HO+Mta2tyH4I/gM/6SgOsdEP1JsU3w
	RJjL3ZslXJqDxxgEOs0cTR08SX82KgYHmuirGMnxfezDheF8/TpVfoKsUnG2MnviVpNBYq2Jeyk
	xh+ce+itQFLDqocJYAuMt5IDX0bO5TP29F8SXLlqeVzbYpEMLATmGaB9Ic5/j95Wr5uhLpJ3XH0
	tzFDWLvUziV3hcblF/f2GKubKsoLPGQhKFrtR5BeL4JNp5aTriM5vf4KY+8q7A==
X-Google-Smtp-Source: AGHT+IGF/tN/73qnDBRQZZwG62q6XEIuTj2FHvkPQA7oYljHSPxp6v+OZz7XCPfOwL4Qtn3HFaA1zQ==
X-Received: by 2002:a05:6512:1406:b0:54f:cdb9:598a with SMTP id 2adb3069b0e04-54fcdb95a59mr1867410e87.39.1747051555930;
        Mon, 12 May 2025 05:05:55 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54fc64bf8a3sm1466033e87.189.2025.05.12.05.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 05:05:55 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 12 May 2025 14:05:50 +0200
Subject: [PATCH v3 04/12] ARM: dts: bcm6855: Add BCMBCA peripherals
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250512-bcmbca-peripherals-arm-v3-4-86f97ab4326f@linaro.org>
References: <20250512-bcmbca-peripherals-arm-v3-0-86f97ab4326f@linaro.org>
In-Reply-To: <20250512-bcmbca-peripherals-arm-v3-0-86f97ab4326f@linaro.org>
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 William Zhang <william.zhang@broadcom.com>, 
 Anand Gore <anand.gore@broadcom.com>, 
 Kursad Oney <kursad.oney@broadcom.com>, 
 Florian Fainelli <florian.fainelli@broadcom.com>, 
 =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Olivia Mackall <olivia@selenic.com>, Ray Jui <rjui@broadcom.com>, 
 Scott Branden <sbranden@broadcom.com>, 
 Florian Fainelli <f.fainelli@gmail.com>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-crypto@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
X-Mailer: b4 0.14.2

All the BCMBCA SoCs share a set of peripherals at 0xff800000,
albeit at slightly varying memory locations on the bus and
with varying IRQ assignments.

Add the first and second watchdog, GPIO, RNG, LED, DMA and
second PL011 UART blocks for the BCM6855 based on the vendor
files 6855_map_part.h and 6855_intr.h from the
"bcmopen-consumer" code drop.

This SoC has up to 256 possible GPIOs due to having 8
registers with 32 GPIOs in each available.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/boot/dts/broadcom/bcm6855.dtsi | 127 ++++++++++++++++++++++++++++++++
 1 file changed, 127 insertions(+)

diff --git a/arch/arm/boot/dts/broadcom/bcm6855.dtsi b/arch/arm/boot/dts/broadcom/bcm6855.dtsi
index 52915ec6f339335d87b4e50e1c03625fffb9a45d..a88c3f0fbcb037ee5c6b31933415f90cb51ded2a 100644
--- a/arch/arm/boot/dts/broadcom/bcm6855.dtsi
+++ b/arch/arm/boot/dts/broadcom/bcm6855.dtsi
@@ -116,6 +116,103 @@ bus@ff800000 {
 		#size-cells = <1>;
 		ranges = <0 0xff800000 0x800000>;
 
+		watchdog@480 {
+			compatible = "brcm,bcm6345-wdt";
+			reg = <0x480 0x10>;
+		};
+
+		watchdog@4c0 {
+			compatible = "brcm,bcm6345-wdt";
+			reg = <0x4c0 0x10>;
+			status = "disabled";
+		};
+
+		/* GPIOs 0 .. 31 */
+		gpio0: gpio@500 {
+			compatible = "brcm,bcm6345-gpio";
+			reg = <0x500 0x04>, <0x520 0x04>;
+			reg-names = "dirout", "dat";
+			gpio-controller;
+			#gpio-cells = <2>;
+			status = "disabled";
+		};
+
+		/* GPIOs 32 .. 63 */
+		gpio1: gpio@504 {
+			compatible = "brcm,bcm6345-gpio";
+			reg = <0x504 0x04>, <0x524 0x04>;
+			reg-names = "dirout", "dat";
+			gpio-controller;
+			#gpio-cells = <2>;
+			status = "disabled";
+		};
+
+		/* GPIOs 64 .. 95 */
+		gpio2: gpio@508 {
+			compatible = "brcm,bcm6345-gpio";
+			reg = <0x508 0x04>, <0x528 0x04>;
+			reg-names = "dirout", "dat";
+			gpio-controller;
+			#gpio-cells = <2>;
+			status = "disabled";
+		};
+
+		/* GPIOs 96 .. 127 */
+		gpio3: gpio@50c {
+			compatible = "brcm,bcm6345-gpio";
+			reg = <0x50c 0x04>, <0x52c 0x04>;
+			reg-names = "dirout", "dat";
+			gpio-controller;
+			#gpio-cells = <2>;
+			status = "disabled";
+		};
+
+		/* GPIOs 128 .. 159 */
+		gpio4: gpio@510 {
+			compatible = "brcm,bcm6345-gpio";
+			reg = <0x510 0x04>, <0x530 0x04>;
+			reg-names = "dirout", "dat";
+			gpio-controller;
+			#gpio-cells = <2>;
+			status = "disabled";
+		};
+
+		/* GPIOs 160 .. 191 */
+		gpio5: gpio@514 {
+			compatible = "brcm,bcm6345-gpio";
+			reg = <0x514 0x04>, <0x534 0x04>;
+			reg-names = "dirout", "dat";
+			gpio-controller;
+			#gpio-cells = <2>;
+			status = "disabled";
+		};
+
+		/* GPIOs 192 .. 223 */
+		gpio6: gpio@518 {
+			compatible = "brcm,bcm6345-gpio";
+			reg = <0x518 0x04>, <0x538 0x04>;
+			reg-names = "dirout", "dat";
+			gpio-controller;
+			#gpio-cells = <2>;
+			status = "disabled";
+		};
+
+		/* GPIOs 224 .. 255 */
+		gpio7: gpio@51c {
+			compatible = "brcm,bcm6345-gpio";
+			reg = <0x51c 0x04>, <0x53c 0x04>;
+			reg-names = "dirout", "dat";
+			gpio-controller;
+			#gpio-cells = <2>;
+			status = "disabled";
+		};
+
+		rng@b80 {
+			compatible = "brcm,iproc-rng200";
+			reg = <0xb80 0x28>;
+			interrupts = <GIC_SPI 81 IRQ_TYPE_LEVEL_HIGH>;
+		};
+
 		hsspi: spi@1000 {
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -143,6 +240,27 @@ nandcs: nand@0 {
 			};
 		};
 
+		leds: led-controller@3000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "brcm,bcm63138-leds";
+			reg = <0x3000 0xdc>;
+			status = "disabled";
+		};
+
+		pl081_dma: dma-controller@11000 {
+			compatible = "arm,pl081", "arm,primecell";
+			// The magic B105F00D info is missing
+			arm,primecell-periphid = <0x00041081>;
+			reg = <0x11000 0x1000>;
+			interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
+			memcpy-burst-size = <256>;
+			memcpy-bus-width = <32>;
+			clocks = <&periph_clk>;
+			clock-names = "apb_pclk";
+			#dma-cells = <2>;
+		};
+
 		uart0: serial@12000 {
 			compatible = "arm,pl011", "arm,primecell";
 			reg = <0x12000 0x1000>;
@@ -151,5 +269,14 @@ uart0: serial@12000 {
 			clock-names = "uartclk", "apb_pclk";
 			status = "disabled";
 		};
+
+		uart1: serial@13000 {
+			compatible = "arm,pl011", "arm,primecell";
+			reg = <0x13000 0x1000>;
+			interrupts = <GIC_SPI 33 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&uart_clk>, <&uart_clk>;
+			clock-names = "uartclk", "apb_pclk";
+			status = "disabled";
+		};
 	};
 };

-- 
2.49.0

