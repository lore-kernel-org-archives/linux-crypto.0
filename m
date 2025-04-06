Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C1022156B
	for <linux-crypto@vger.kernel.org>; Sun,  6 Apr 2025 15:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743953581; cv=none; b=aS6dm5tOQOZNx24JiSGomjE1O9YrgxUI4GJQ/CQDF6TFO8eYMWRviQ95W6Rmw0xmOvrDwtVTyUl7Ij/ND+Dspml5jxBEBW08ZUVzgY6IyfpaPQ3RWz9VfyGFc10slFhtyrK5f57iH163LBQJPZVvE5OI5xhUYxhwZwepXlLmkh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743953581; c=relaxed/simple;
	bh=iDJZCjvYOzGe5r3HFMTMpjyfglcpGzdhxbjudlT68uo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lG2w23Itv+2ppjrCsalWmN5YqUqqWQ5LTEkND2eJ0OBZe8yykG60m/8wRIeoz2+QwuPAVuTeBVyM+fdvZABtcMxSPgFltY+c3Ld8ScWbc1OL/wTZXat4TAMabV5azUFW1gJV89LUE0o35zD9nmue5NpbVyv3CKzwmbkaHSOUVGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=c3vnlhS1; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="c3vnlhS1"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-54b10594812so4055576e87.1
        for <linux-crypto@vger.kernel.org>; Sun, 06 Apr 2025 08:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743953578; x=1744558378; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Rfw29M1YC9XFEM8I1QgE6Co5IiNp1ynpZsURBnbzUc8=;
        b=c3vnlhS1KNSRKHwBQ1twX1N5XDi9wzeKDm1meXBLFC4f6/KsRMZ+zWrdt1YmbRNmKk
         4qq2eL2p6C4daFtLopS60qA9IIz53XP6RdpczBhQpTcH7BiAq6VTevv66HABNY4zdOlC
         8Akq/dzbSdGqQeJHJs6I7u15B/t4ixII5B0ew8xL39bBKdRUjl7rue4VvBrU+1yUAoxs
         xJraWqXn/BxYIzVo+507JI1rUdNSY1+esCgU652bdq/9NUeXuA8HVCyzyzZTHS/Ya3fX
         4yeA0ZU/vgpHD78qQ5sIp6Y4vbJabQTPBaGoC5L726Cmz9uX1Kcus/SC2GpkJumSRhfr
         7iPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743953578; x=1744558378;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rfw29M1YC9XFEM8I1QgE6Co5IiNp1ynpZsURBnbzUc8=;
        b=KZAh+9wdWkBVP1RczgYjc1YcQXnVaVlO7ha15nlP/+mnRFOf20resauLLDXbtWZpMJ
         jUgSTIE3kV452pub0TvbnonYpBfHBM/YeHA2AEC4yPo7X3OYRKnlFjXa9roIl0+kHqI5
         bqRXiAQ+ln+YtYOkMhFNRloRUtb1X4Hup15bLrUgUZbDaaWAIO0349uWQUq2WbLvKkTC
         6yAD0tPGg0K2upM4q3qExzSoIKZ12kDrzKXOlLk0zteMziEcMw/6m3cNsVPMEq+Pe5uC
         ni041arz0iQLMGgc4oskSpXUF+AxgkMxzU8vcimpUd5Fl9ngEuFjM9RHNpt8PcMS1SrL
         Up8w==
X-Forwarded-Encrypted: i=1; AJvYcCW2U+w9kuCTr4KId9VmbhTcNCJ+QVjkA1HA45rmG4SLh1DryFmcUviIFMOJX0vANGflypaInQHupG83xIc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzk1hIdYoGtye11PuH7kjASRt9BOd8MYTXXVWdqOT1HITcXZyup
	kccYib0P3lhOZsVUDAcm37Toz3yzgEFNpXgGwsOB0XU/utpj2g2CLQISSot67ns=
X-Gm-Gg: ASbGncu03SxVh79kfX56lI6EExmEtn/sWwbYm2LoFvmXcnQ8aJxGx7X5BN2wNUL6c+m
	mpaPNAO/5cgUHFLt8Mf9PI9npUp4ZVoZSswRKskAXeBA55qaXfaOAmL2rSA4MPMH5GB/Ui+3Erh
	lANiLrpYT3y5/rveAyIoJK87HFQCDU+OcQpf6QRNkWjpSsv1h8Dx614siCJpHYz125X/+rQ/ZsF
	tDfM5mBnNtz84J6U7napsOoOHyJAoIqDQ9CmRuHVPrVeU/dSrDuaLci1mB/S85cA2vjvtzGUv/M
	g2KwnOHUqHfXT8LPdo9bwIfzOZ+uzAsc5RtXT8i3/35XJM7lCbsDnUYLNUx9qqBKqw==
X-Google-Smtp-Source: AGHT+IEUkyzkL0J7M5KnLMNvYFvrvh0lK6hSoUd1fasgJ+0yTB0AYLW6EM3ZZUL9Y1uNKBF2MJkRiA==
X-Received: by 2002:a05:6512:3b93:b0:549:b28b:17ca with SMTP id 2adb3069b0e04-54c23346dbemr2379200e87.37.1743953578087;
        Sun, 06 Apr 2025 08:32:58 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54c1e671fa8sm989747e87.218.2025.04.06.08.32.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Apr 2025 08:32:57 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Date: Sun, 06 Apr 2025 17:32:51 +0200
Subject: [PATCH v2 11/12] ARM64: dts: bcm6858: Add BCMBCA peripherals
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250406-bcmbca-peripherals-arm-v2-11-22130836c2ed@linaro.org>
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
peripherals at 0xff858000. On BCM6858 the PERF window was
too big so adjust it down to its real size (0x3000).

Add the watchdog, GPIO blocks, RNG, LED, second UART and DMA
blocks for the BCM6858 based on the vendor files 6858_map_part.h
and 6858_intr.h from the "bcmopen-consumer" code drop.

Curiously, on the BCM6858, the PL081 DMA block is separate
from the two peripheral groups PERF and PERF1, so we put it
in its own bus in the device tree to translate the fourcell
addresses.

This SoC has up to 256 possible GPIOs due to having 8
registers with 32 GPIOs in each available.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm64/boot/dts/broadcom/bcmbca/bcm6858.dtsi | 127 ++++++++++++++++++++++-
 1 file changed, 126 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/broadcom/bcmbca/bcm6858.dtsi b/arch/arm64/boot/dts/broadcom/bcmbca/bcm6858.dtsi
index caeaf428dc15db3089bf4dc62c4a272782c22c3f..38331305e6da8eec39d02aeb0e02f3b45e2f5c4d 100644
--- a/arch/arm64/boot/dts/broadcom/bcmbca/bcm6858.dtsi
+++ b/arch/arm64/boot/dts/broadcom/bcmbca/bcm6858.dtsi
@@ -111,11 +111,12 @@ gic: interrupt-controller@1000 {
 		};
 	};
 
+	/* PERF Peripherals */
 	bus@ff800000 {
 		compatible = "simple-bus";
 		#address-cells = <1>;
 		#size-cells = <1>;
-		ranges = <0x0 0x0 0xff800000 0x62000>;
+		ranges = <0x0 0x0 0xff800000 0x3000>;
 
 		twd: timer-mfd@400 {
 			compatible = "brcm,bcm4908-twd", "simple-mfd", "syscon";
@@ -136,6 +137,86 @@ watchdog@28 {
 			};
 		};
 
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
 		uart0: serial@640 {
 			compatible = "brcm,bcm6345-uart";
 			reg = <0x640 0x18>;
@@ -145,6 +226,29 @@ uart0: serial@640 {
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
@@ -171,4 +275,25 @@ nandcs: nand@0 {
 			};
 		};
 	};
+
+	/* This is NOT in the PERF1 Peripheral group on this SoC! */
+	bus@ff859000 {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges = <0x0 0x0 0xff859000 0x1000>;
+
+		pl081_dma: dma-controller@0 {
+			compatible = "arm,pl081", "arm,primecell";
+			// The magic B105F00D info is missing
+			arm,primecell-periphid = <0x00041081>;
+			reg = <0x0 0x1000>;
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

