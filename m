Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8180C221561
	for <linux-crypto@vger.kernel.org>; Sun,  6 Apr 2025 15:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743953580; cv=none; b=OjwfPMVibk5EYwxJN7x0R9uv9ZD9jZowQhJVJAyg5472KVTxIgmdWxMuOppFikPplzznDbal1HrO2mpybhvSEfu66t4ifPVqCdoSkAsEzKgZXefGr6+Wj4O0s0touvCYgcjctnMKPGdn+48jMbrwBJu8rjrgNgqPPSYdo4Vf7Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743953580; c=relaxed/simple;
	bh=F0a08LwbAnGDokg0vBvBMahzn/p1vaaNz6vfPvgBKG4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=iYE7laoFY5dRMq+N1mSnR6ktiN0CMYdsmf8eLTSTBvm2xa7ABgHoqzo9xvLB4hBIjgGSPJ2ACEnKq1r8vFfLZg6Ygd5bX84LaFAcGVv3WHVprtaXtKVOedRrf//rmgVNZD9kAvgEZlddadekVU3xRHnXuBnC0ninVX4pwuP7WHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=u0g8nfRf; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="u0g8nfRf"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-54addb5a139so3988447e87.0
        for <linux-crypto@vger.kernel.org>; Sun, 06 Apr 2025 08:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743953576; x=1744558376; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qMV0L0+THdEhKdsNmNESmpAlHXgmh851fInPOyFXPJY=;
        b=u0g8nfRfXhfzI2eAPnbmHpCyr+IZGfCCY4wwuF4REqZ+yeyct+wPKrJ7v3JfAWPQFx
         oURbSF5gdDfuiTMTRgh3xU3HjxhRERKi8gjbErBgTZHabO2w9WLTRf7JdY2MPAMfVWom
         sOxqkphqWBmC+Lweg5XVqfiuB/HuEvDCKUtMFH1uHkX0l0jqNbGDxv5LA/WEUuOngNuU
         tJ4RXFGD7uGcPyDYrdxurKcA0Zq723BnWXP+dHT7ustGijhC+WCNq+xjj/SExsCOSO0S
         7PMMVa4a5GCn3Xypv1rklebqkfb9E4+crX5RBXmT9AvgUxG9iuqdWzXxFjF4NcyvTRXT
         ED5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743953576; x=1744558376;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qMV0L0+THdEhKdsNmNESmpAlHXgmh851fInPOyFXPJY=;
        b=a1uFgDg+u8hoHKR11QQPtwKe5FxpLmCBMAE3PUgXaZSInj6fBHOhmtAuQce+dF7RpD
         uBlNaqJpAxNaCTgk5s9CyIOV253mZXCQosg/XQByEM+cqgWp4cRXTvtwDJHIjGCQmk0g
         jy8KJjZVMr6t3AD01062zdg81+xIr0XVgSfaCjuEf8eEZYrI0vBg+hslmP02DSsbjTR3
         61lm1jxZFC8itAXqPlgYnw1A1Qp36LG+aQIN0eAeQ1GWTLa01nCKcEVDRx/jRDeuRoE0
         W5aJ18NUcsSeSuHDrF0raYDJrOjvgWbMxbZm8Pi9yILfWYTGWgEv8A91hDmkU3C2NeVO
         p5FA==
X-Forwarded-Encrypted: i=1; AJvYcCX/+68W4jrpR930cpqWpMZVxBUKs1i0bPh2e7Fvbm2zctEsxv3u3MU3H0b5fMF+H8h6I00dG4w3vQSjwpk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBsCqWcomBkWDYwoAHkMCqEld8SERPm2hBHNkQ3A4Hp31q50Ln
	x/fRri67v4zGdSH/cfI4i2hZBS3QobQRpKOeUMrTWq4yStZbKqSlJuZOAQS4ocQ=
X-Gm-Gg: ASbGncuVxwyiMn0/TAmCW9FlO+kXVJ7DFAiJ2XhcaakLqqUmgw58rn/U1MXNbQDgeZI
	BSfKs1xjsF9yGpMEXYckk68H6pjsz5T/499Xy7u3Z/GggaYjSgyJWJEBKMijxy3tYCvwGdyiQBx
	ByfyC57eKIyTHwOMifjZ8DVYLO9dE+afEqWLRHiYyeg7KZVtcOqnZQjiBpXrxX5ynKM85Ripcnf
	hW/jXCYvVXfon+wS2WFV/sBBBjfplmxArrr22GRPx6H56s9bMM2RkDcqiP7a+Jdha1h4K7P6mTR
	sZ95Qq6N06MXe7TDh9m2fRU2OvQjXbTwNdTzs2RCvjIJVKzM0+7+0Ho=
X-Google-Smtp-Source: AGHT+IGmejp9qDxskZuF/W/MttOETDK6SM29Z8uze5MFHErOJIJUow3naYSenZ2O5S1vADK8+zXGAA==
X-Received: by 2002:a05:6512:3e1f:b0:549:39b1:65d6 with SMTP id 2adb3069b0e04-54c227fef71mr2527448e87.47.1743953576525;
        Sun, 06 Apr 2025 08:32:56 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54c1e671fa8sm989747e87.218.2025.04.06.08.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Apr 2025 08:32:56 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Date: Sun, 06 Apr 2025 17:32:50 +0200
Subject: [PATCH v2 10/12] ARM64: dts: bcm6856: Add BCMBCA peripherals
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250406-bcmbca-peripherals-arm-v2-10-22130836c2ed@linaro.org>
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
with varying IRQ assignments. ARM64 SoCs have additional
peripherals at 0xff858000. On BCM6856 the PERF window was
too big so adjust it down to its real size (0x3000) and add
another window for PERF1 at 0xff858000.

Add the watchdog, GPIO blocks, RNG, LED, second UART and DMA
blocks for the BCM6856 based on the vendor files 6856_map_part.h
and 6856_intr.h from the "bcmopen-consumer" code drop.

This SoC has up to 256 possible GPIOs due to having 8
registers with 32 GPIOs in each available.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm64/boot/dts/broadcom/bcmbca/bcm6856.dtsi | 138 ++++++++++++++++++++++-
 1 file changed, 137 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/broadcom/bcmbca/bcm6856.dtsi b/arch/arm64/boot/dts/broadcom/bcmbca/bcm6856.dtsi
index 00c62c1e5df00c722884a7adfcb7be08a43c0dc3..d6d0b8e1a65b494be414dd5841b65f8ff489d684 100644
--- a/arch/arm64/boot/dts/broadcom/bcmbca/bcm6856.dtsi
+++ b/arch/arm64/boot/dts/broadcom/bcmbca/bcm6856.dtsi
@@ -93,11 +93,103 @@ gic: interrupt-controller@1000 {
 		};
 	};
 
+	/* PERF Peripherals */
 	bus@ff800000 {
 		compatible = "simple-bus";
 		#address-cells = <1>;
 		#size-cells = <1>;
-		ranges = <0x0 0x0 0xff800000 0x800000>;
+		ranges = <0x0 0x0 0xff800000 0x3000>;
+
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
 
 		uart0: serial@640 {
 			compatible = "brcm,bcm6345-uart";
@@ -108,6 +200,29 @@ uart0: serial@640 {
 			status = "disabled";
 		};
 
+		uart1: serial@660 {
+			compatible = "brcm,bcm6345-uart";
+			reg = <0x660 0x18>;
+			interrupts = <GIC_SPI 33 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&periph_clk>;
+			clock-names = "refclk";
+			status = "disabled";
+		};
+
+		leds: led-controller@800 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "brcm,bcm63138-leds";
+			reg = <0x800 0xdc>;
+			status = "disabled";
+		};
+
+		rng@b80 {
+			compatible = "brcm,iproc-rng200";
+			reg = <0xb80 0x28>;
+			interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
+		};
+
 		hsspi: spi@1000 {
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -134,4 +249,25 @@ nandcs: nand@0 {
 			};
 		};
 	};
+
+	/* PERF1 Peripherals */
+	bus@ff858000 {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges = <0x0 0x0 0xff858000 0x4000>;
+
+		pl081_dma: dma-controller@1000 {
+			compatible = "arm,pl081", "arm,primecell";
+			// The magic B105F00D info is missing
+			arm,primecell-periphid = <0x00041081>;
+			reg = <0x1000 0x1000>;
+			interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
+			memcpy-burst-size = <256>;
+			memcpy-bus-width = <32>;
+			clocks = <&periph_clk>;
+			clock-names = "apb_pclk";
+			#dma-cells = <2>;
+		};
+	};
 };

-- 
2.49.0

