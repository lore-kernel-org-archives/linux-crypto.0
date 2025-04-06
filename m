Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A66A220686
	for <linux-crypto@vger.kernel.org>; Sun,  6 Apr 2025 15:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743953572; cv=none; b=cpk+E1EwjP7iuNuykXgxKoYNxHrEJVR/+6Bo2muTU37tABmD2Cv0tPIRWTdktIBTpeK2s7qRPmFV+oC8ZIgeA1JjEf29DkJROu4SGykcytSVFy2ug/73EueNXFH78cb+6kpDNCZ5G34lyRbvgf0tGUkGuSIJF6GLK+HxuUNs9Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743953572; c=relaxed/simple;
	bh=gM3ZQtP5fl+y/vusB5lo6et9+sqNU8P2xYf11kTHSMc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aV1GrzPKW6yF3YgSgBDQMrieyJcE4BgjBwri2R+sR0wV5bqzzOjFR/osPgi3+d8RrIhvmAuQaGAsFkZuosyxZlWJUgru63MX5DpzpIPIGFgqO5BaXE/XCHxcQx+sI+sy9nKa3vZNou8E9fvxVVc7l3ni+Yh01+izIAU6LyCOUag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HgJtv1k/; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HgJtv1k/"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-548409cd2a8so4152168e87.3
        for <linux-crypto@vger.kernel.org>; Sun, 06 Apr 2025 08:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743953569; x=1744558369; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iEf4cNwCAvTux6g5ErQoMK0ZXsg4RGhL1cTSbSRkU48=;
        b=HgJtv1k/KMWNmmUKvDvtIiOuiVra6C5702Ek/pROux8HeDs5zI8GXa5+eWsu0jZSlP
         045suQBgp8LkA0RjiZyZ7vRWoVuMtZcO8Gb2gz1VbOPIQ8vu5uOeP5V3AiV20kREv556
         xA7YX1vNbho5h62CJtSYGaAYgFdU7rr/vrP1qhL2mJtl+P63RNU4otF2GlxnvzREw2/q
         wFdNQ7LETXjb4GSNpsrLGVZKGCSuuQ44FO3zHbJrO1WH/VS7ZBKgM1kYu0jWriQgJSrP
         gvnUW4dRRuHQapFIvURteqk0luFbj5Tgu9QQXZDDrCMH9mmcoWh5nYc3FIfHBSWMFCHo
         osrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743953569; x=1744558369;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iEf4cNwCAvTux6g5ErQoMK0ZXsg4RGhL1cTSbSRkU48=;
        b=qePkgeaFJKNjni00+1bLvWbGwttLeV9umreBHkRANyC6dzsAm1ZC8kcHGlKuj72FCk
         jVEgLMwzRhojOF4GD+cPMs2Zo91cZsBmfxD3sFhRygcnAYimrt9UGwEZ432pm8+NcpVS
         352UUxVDuCChx55Iw35hDrgiDWd8veqnennM1QlCciw5NOFH9w7uJFYUlYfVM/sWrNxW
         U5TGca+COKGBrptfD5eAB3zn7QJSJWAInA6pZuO0oczE4uVp3X2XZR2aTMbg3nS1saoU
         qTDzqN/UONJzN8PmO0WOeFyYfC+0uCx4oQCKAjOVVht39Mol6A3B7dFP3/vKlD56613u
         qQxA==
X-Forwarded-Encrypted: i=1; AJvYcCV/ILvHlKfbO1KLW2MaXATymamBko09Uot8oEgKe+VnLS1Djpxja7Ty0EQK9w5hqi+lRdXXUGmQB6/UVbo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyf5pKzT9C31Da/YJvO+c5u0hcQITaR0F20SHKy5mlmu3qGKL60
	FLvqpXlDhXtB+R5ev4V54f28fY3CtTsQWNO+q9kdcD3q2Qpfzw6DotkhQp8UEws=
X-Gm-Gg: ASbGncuOQ92qqxSlzHRBaczFT5qBjheGXr+7rknexigPbVHQJeKuho8QHum5kBlnsrh
	mCK6UVpGVp2bXLaQouBi3ea/yLWHLo/CZO3kRWPUEDfsXrzLFXM4HQPsLoL44fnOGlJBlBV/cGU
	N+krItnO9WY3QhOqKMzYqiyaDmCt4cboRwtlC4sws68yYlWJ3zjfsDhc/TgdEtpGFsDfxpz1mtn
	LT6dQFSKdntuEgF6Vb5nCA8hcyYT2RiBCQou7J3xGrdtF0taP3sV/OfiZCmOQHNhMCQp6HIeO0R
	k4qbfcwF1QNJCDcK7ZmQlfGQ9fUcYASH7294IGyMlIBGwW8E96tovUQ=
X-Google-Smtp-Source: AGHT+IHX6ymB+h9Lowm2Yf7MRd1SjNLaX90zJo45WhqpbwKnM4ta7ShvImIRlKAv4ludhs63y9R8sQ==
X-Received: by 2002:a05:6512:3b08:b0:549:69da:cb96 with SMTP id 2adb3069b0e04-54c227ff9d7mr2905626e87.52.1743953569117;
        Sun, 06 Apr 2025 08:32:49 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54c1e671fa8sm989747e87.218.2025.04.06.08.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Apr 2025 08:32:48 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Date: Sun, 06 Apr 2025 17:32:44 +0200
Subject: [PATCH v2 04/12] ARM: dts: bcm6855: Add BCMBCA peripherals
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250406-bcmbca-peripherals-arm-v2-4-22130836c2ed@linaro.org>
References: <20250406-bcmbca-peripherals-arm-v2-0-22130836c2ed@linaro.org>
In-Reply-To: <20250406-bcmbca-peripherals-arm-v2-0-22130836c2ed@linaro.org>
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

