Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C101293B49
	for <linux-crypto@vger.kernel.org>; Mon, 12 May 2025 12:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747051569; cv=none; b=aPEHsz0EH2uXnd3g+uiERspZJag0kU0IvwXhjS7zqV7qKxlvLeEmAT16E92hgDLi/S84/INJuisuq3/lw+KVfD1gNtTG1uzQfDuHBnvb2CS9LezIFtsifRwNV+0cvXzchqXEEqD/50K9i1DxXD1asUSv2T0UHRMISC1+WoJavh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747051569; c=relaxed/simple;
	bh=Pl0LyUgTiTeJq+yJ87khuxuTAGXPr2YU08fCOjU8zbM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Lk18ZMtsXfV7cPEyH5gq3w1+3FjMc62JCrhm/JMNfLyhsNCEV7mK8EGfdbOZ0on9JleBCWeEUFLKZM3kUoDx87cWUciLhyEatSeHF+jYvdrfbeOjfPJ+n+hBn/lwWO6G9BpYoES1Nd6irxyjif9VNNirD+gjiBkQmeMlLSf28sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nl/CGw2P; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nl/CGw2P"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-54fcb8b889cso2832144e87.3
        for <linux-crypto@vger.kernel.org>; Mon, 12 May 2025 05:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747051565; x=1747656365; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/MYiew/7MjE/NSPkg8zeewtIqLpitjfhqjwjRNOSYf0=;
        b=nl/CGw2PTZXu9Fnk2F9B0rxbCBotZyd8EzualAzuLQ0TuXUUa7m9QUIDETP3vmH3pt
         nFRm1AruFM2lfVOVp7hPz9DSS6zuLUi4yS6bXPR+/vcxhxrOrz85E7lFi5sDe7t78/dc
         pfz9KyT6ZXaWUBVtiy3rHIg2gtZGY7s9luTY8wxlM99jmtSw0OoZjgODMdU4z+Vfuq9V
         0xmmb0Exqfa/0svHDgofdU/GgHwtTY+1X8IR2Q0G5qu0my3eHoHXgzOC2n0jKG2XimcS
         ZyosdOun+VCnvgsDtTcXQOD9CCQTK+G7k62p965rlRJ5o8sLRrzqKuflK8PGizN3/DsS
         vUjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747051565; x=1747656365;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/MYiew/7MjE/NSPkg8zeewtIqLpitjfhqjwjRNOSYf0=;
        b=StUMSL1rxnB47rdn1cZe3dVgaGXe5iTO8bDwroyzbcNKEw+M4lXGALhWBdAzQWGuT+
         5ZUdmX48N/kv54FRPe6T1YTOYzoyR10c9ES2gBSOHVi4MWJvFS8/QYyrhMwC8BJ706GZ
         JHjqXQPh8S5k3S0DEBp9HrCkqUXUiObuzvytkFQoTTPPdyOECpxBR+F2Dzj390NpHeuy
         64Ffn+Kc7LwKUT5jbX60IX7rPEqh4se1aheR8nhUyo6LLNdzN6x8yTbYdMYc8c/fNLfA
         sMRjtz2wVUBbh7TI1IVbmLX4guSXh5ZWdfaTEhs/fY0fafolo1jblRSz/GfuQnywhoSc
         lIfA==
X-Forwarded-Encrypted: i=1; AJvYcCWbGa2smtIarnJ57AfjMgMwDODue0L7JuExOCzB6jt8cH2z5smac0+aqmD+sDqWIMv3kSjtlfoqtUnCDiw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMJNg64iAV4YalZNYdxkFAxpkscVbP+wIHzpZIYKN76XZWJhqx
	M47KildXyh9XW/3Dhy5Bc5jONHIuu5To7HNMAOkP6N0JsYs7UjgoTiijTx9QazLePGWrY5fixKi
	m
X-Gm-Gg: ASbGncs5XdEI4sz2yVNIqptAIWf2+8Jih7OAnFM8PDQ/I23dnmRc5sBofMKJpvT7qH9
	YDZDVA6/gDYEDaGtiED6AJ6TiCDyjU8wAvoDT5wmv/bfDKimDB/I+J+9TM+4e+p/5HDGtxijWX9
	Zqnk0LD8Nin1zS4zEaOk/7kysXbFnGuOw1Bc/2KvuqX4hyf40vzMMmuk7cZsxDWCAZ8NfLyXbVj
	HCazOim2qX+mY+cqgYKv27nvvuFAfxlKvapnnc7W20iL3WifdLVBUJM7UdWe3vwwiYNRc9NITZu
	7S2IL0S8JuHJ/dSg/lAe5dLNb0JZaI2iMFE9ZPMs2mcM+ALteMsj/BHyH+d/Vg==
X-Google-Smtp-Source: AGHT+IEEk2VZG3z9Te9sVeOPNqXXigxd1r+ev72HZog3PhTFGJpu9Bl5l1Tn1D8zxgukbGbiw9kC3g==
X-Received: by 2002:a05:6512:4381:b0:54d:6981:4b83 with SMTP id 2adb3069b0e04-54fc67cb105mr4892037e87.24.1747051564927;
        Mon, 12 May 2025 05:06:04 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54fc64bf8a3sm1466033e87.189.2025.05.12.05.06.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 05:06:04 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 12 May 2025 14:05:57 +0200
Subject: [PATCH v3 11/12] ARM64: dts: bcm6858: Add BCMBCA peripherals
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250512-bcmbca-peripherals-arm-v3-11-86f97ab4326f@linaro.org>
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
with varying IRQ assignments. ARM64 SoCs have additional
peripherals at 0xff858000. Extend the peripheral window range
to 0x400000 and add the DMA controller at offset 0x59000.

Add the watchdog, GPIO blocks, RNG, LED, second UART and DMA
blocks for the BCM6858 based on the vendor files 6858_map_part.h
and 6858_intr.h from the "bcmopen-consumer" code drop.

This SoC has up to 256 possible GPIOs due to having 8
registers with 32 GPIOs in each available.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm64/boot/dts/broadcom/bcmbca/bcm6858.dtsi | 119 ++++++++++++++++++++++-
 1 file changed, 118 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/broadcom/bcmbca/bcm6858.dtsi b/arch/arm64/boot/dts/broadcom/bcmbca/bcm6858.dtsi
index caeaf428dc15db3089bf4dc62c4a272782c22c3f..c105a734a64897e714ed107e0ddccc5eebd415da 100644
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
+		ranges = <0x0 0x0 0xff800000 0x400000>;
 
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
@@ -170,5 +274,18 @@ nandcs: nand@0 {
 				reg = <0>;
 			};
 		};
+
+		pl081_dma: dma-controller@59000 {
+			compatible = "arm,pl081", "arm,primecell";
+			// The magic B105F00D info is missing
+			arm,primecell-periphid = <0x00041081>;
+			reg = <0x59000 0x1000>;
+			interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
+			memcpy-burst-size = <256>;
+			memcpy-bus-width = <32>;
+			clocks = <&periph_clk>;
+			clock-names = "apb_pclk";
+			#dma-cells = <2>;
+		};
 	};
 };

-- 
2.49.0

