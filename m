Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908C2293450
	for <linux-crypto@vger.kernel.org>; Mon, 12 May 2025 12:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747051565; cv=none; b=lwO4x1+vJpSUL8X9LnavtiVT4hCp4FwR3X54NGUiVR2XSOgenqhBNS3dDpsaWgL6X4+RUEYVQAIavGZIpCqaBJ/NBVguSs0q+oBsvJoF3+yauqOHBaIf/zaxUvpnSY+DnVYqN9peARP0yTWXjD/KOuyK/c+vm11VOX4T6010yYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747051565; c=relaxed/simple;
	bh=pbHfDCTjaHzfxW+OAsE5Dq8CDB3EGZWsdyuuoaQDvZY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AiyooTWrh9qgP0kWUdzoEC9LdoirNICZhYnsqb5saKJPd8DORvXq2z4yFOAkK8UFqMqZXQRcbqNZvJOIve4He2FMatcmSwXkBKye3nzFo2l/LTNXgODyt/YAQWeDLAVUxg42e7K0+cIIHSyEbpdXdBRbJXwm8zcSc3QYsRQtHzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pwCjKkVY; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pwCjKkVY"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-54fc61b3ccaso4254011e87.1
        for <linux-crypto@vger.kernel.org>; Mon, 12 May 2025 05:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747051561; x=1747656361; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9ajeMdU2bzp3CfLA2J3Ap/K02MBno4FVMRdHz6CQ8IU=;
        b=pwCjKkVYkIjyzWLtbdx4hLlm6pIhuRufqzPF6OZEFHmBX/TaXbUQLVFYs6ciG1sxSo
         dxUTShWdL4YpdsXBuEl2BfYp90gOMoS2uFUvpIT6y1yQrGl8sve7QeSJaWuQkN0IPCfu
         PAsXFGBDzUDA6vHrqFI1eqAZVoDds/jSbkg4T8m85MuWbboYxBPrHc0gkIuKNnGWztJX
         ecph0XIVTTDzooVAgHtxHSkhmYn/1GvO+WGeZtVVHK5I4ZwQ45+IU2OUns5SQ86MVEpU
         k7Fl7Q/5YzJGiZLvT3rjYTmFwdxEI9VP0CVQSAfnVPFspGGk8rICO21SbfCni2ULMzTk
         wk4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747051561; x=1747656361;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9ajeMdU2bzp3CfLA2J3Ap/K02MBno4FVMRdHz6CQ8IU=;
        b=ltpdArCY/HEoUp+CspvIh0iLueb1eSBn16srB4fBtGbKGMCws2RMq9DjvU7YZdn51c
         5JEwgBndycufIHrimGq5rnR6BkeFgUjbSizQctGYTui4UI+frMlsblK4mCqRWlueFA92
         2k+ag5zsXjhFGyhTZJjZE6mq4raMI6pADa8PudkZoWp26J3RSyoWlhazyFvAnEI1YqjK
         VJvR0Z2MvaPYYFoPDcTuHQ1EDLRKPfVgBTju/vggjaIM2mEUT3WxfrvpRvCqF6Y1YT2S
         4yAnimMIcgXNym8o1FN1UhSMM2g2KPAXQwEuyrvXdq6+T8n8sZd5P6dRA+bVlFmYCnvz
         v39A==
X-Forwarded-Encrypted: i=1; AJvYcCUg9SqpA43l2Lvfi8ieJIM7AWkjoolMajt8b4ifYZPJBZyFCLSouzkqkHH05GK9ciheqmT1DatQRs1Hfog=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBRzRlMJpQJKFZTFJafi2SKWvePrveREnCium7hOMVAf6gZdEX
	8XvqA7TOEorX/tefu6v+Sbb1+HIXZgW1HaKDqJlQm4yav/YF6t9UhzUTNTeW1m3MbQG5rxiqL9D
	U
X-Gm-Gg: ASbGncsqmHzeEoQpX8efyVz1MFNrbhuF9WhmYCmUkQRO+o6oxtrSF0Fp4y4MXmICLCP
	t0+i7cohSa8seGNghE6AhEVCeGh0qYr7udl7Z40Ll6wZN5Rk4Kvwu86aSN8aYCDRLs3YkD/evS+
	GVYbTQWNy3GcFlRinzIvIyuTmqEgYMk2AaGsfCUCg8tMkuKrCTcwTiqciokyMoFuotQrOOGBTaT
	CYVG2LBqANf2O2SJs8j0uLAPZkC0Zzl75DBsd5KCwZy8drJvjoAPxji0mv9IapMzjMAvV0NyUKA
	uBkJ5fu5+t2p25niaIPRTuT2+XnRO/YBxFUkhnnLyRDF7InQ6PczEbo80rbhDg==
X-Google-Smtp-Source: AGHT+IGSmwcgd/v/2nB6DnUNhnkM2SXlf2xtwMRKJKghp8E3JFM5XZm6ROlGaVa5BJ8wKDCpqrrdig==
X-Received: by 2002:a05:6512:4408:b0:549:5769:6ae3 with SMTP id 2adb3069b0e04-54fc67acffdmr3842426e87.6.1747051561017;
        Mon, 12 May 2025 05:06:01 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54fc64bf8a3sm1466033e87.189.2025.05.12.05.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 05:06:00 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 12 May 2025 14:05:54 +0200
Subject: [PATCH v3 08/12] ARM: dts: bcm63178: Add BCMBCA peripherals
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250512-bcmbca-peripherals-arm-v3-8-86f97ab4326f@linaro.org>
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

Add the watchdog, GPIO, RNG, LED and DMA blocks for the
BCM63178 based on the vendor files 63178_map_part.h and
63178_intr.h from the "bcmopen-consumer" code drop.

This SoC has up to 256 possible GPIOs due to having 8
registers with 32 GPIOs in each available.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/boot/dts/broadcom/bcm63178.dtsi | 112 +++++++++++++++++++++++++++++++
 1 file changed, 112 insertions(+)

diff --git a/arch/arm/boot/dts/broadcom/bcm63178.dtsi b/arch/arm/boot/dts/broadcom/bcm63178.dtsi
index 6d8d33498983acfc0c65ee155f64ddedc4a6b376..430750b3030f2534d6bf0468d895ca565007a53f 100644
--- a/arch/arm/boot/dts/broadcom/bcm63178.dtsi
+++ b/arch/arm/boot/dts/broadcom/bcm63178.dtsi
@@ -117,6 +117,97 @@ bus@ff800000 {
 		#size-cells = <1>;
 		ranges = <0 0xff800000 0x800000>;
 
+		watchdog@480 {
+			compatible = "brcm,bcm6345-wdt";
+			reg = <0x480 0x10>;
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
+			interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
+		};
+
 		hsspi: spi@1000 {
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -143,6 +234,27 @@ nandcs: nand@0 {
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

-- 
2.49.0

