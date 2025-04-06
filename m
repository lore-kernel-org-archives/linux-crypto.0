Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C11921D594
	for <linux-crypto@vger.kernel.org>; Sun,  6 Apr 2025 15:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743953578; cv=none; b=jRjXRb8nKxv2nShMHwUx7XGx4is6EhoqLQJJfD14mauSiJVXAfSQ4kswAy+MTxLm86UDy2C/J5JDEyo23aBpPaSIj0F5flyhprMc0bukdKZ21TyRenwOEsSXiTvC3I2ue8QEnD4eJz1TGTJfzYkCPHsZ/v3+9/fyXMR3CRpOaOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743953578; c=relaxed/simple;
	bh=pbHfDCTjaHzfxW+OAsE5Dq8CDB3EGZWsdyuuoaQDvZY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jzn3akp/1aZUQXIKE+M7FwiPw10vI+CMaT+q1KB499wb6qyJNhBF5O4hcSqfzjXpR2s1GgZgqzoxnn1S5tRN1O9n2aKArcYUPqoT/IQ8dt+w/XjJDorOEyIUOkVX22DlsoM+OFZLzuOXeFgeOI2naqYJFjDpFfVKv73NFG7Dats=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gcUwH2VE; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gcUwH2VE"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-54acc0cd458so4396895e87.0
        for <linux-crypto@vger.kernel.org>; Sun, 06 Apr 2025 08:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743953574; x=1744558374; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9ajeMdU2bzp3CfLA2J3Ap/K02MBno4FVMRdHz6CQ8IU=;
        b=gcUwH2VEImDdMo+lB+m2TfuuXh+lic/EnSeo+8r5cDTTkcx5pqQwZfu8GyTwMcKosP
         d9Fxz2/umQst0cn9LTW46VsFIgvOTqbyFbpQ/lpUO5O8hCR+Y13lah7Utwff7fWOhvIQ
         0+MH4zdq+LbsZw4fHyBgXZcVFo+Q18TK+5rd7wW9iGZO7kvF5SkyWiApfsRLqTR7s+eW
         GdXnwFYwa9ELsYQBEVovMfeqQ+PEPrYeXhgz4seM6rTtoZivu5NSzfAy3iegd8HXgci1
         tavKYoBGuTVZHn45aJzFZQR6hUSbLU5hawjOL511HlvdoPJoWnOFQGqGncvgJ6Z3mQwn
         5SuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743953574; x=1744558374;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9ajeMdU2bzp3CfLA2J3Ap/K02MBno4FVMRdHz6CQ8IU=;
        b=bbffyyqIb3KQrue510bhf5UxumGtVpijFMSDnMVgiYKhwfwe9xd8hWQRPt+PH5ySlQ
         nD7xNMFxDM1Lyzc9xjc+FnKDPZCf28eyUinXsz4rSS9CEV1oaMxjxTJLgkqfwp06d8nx
         bcuV+7Lmky7t7gU6NY9jZm4EMIF0mD8fBTCICpZ6VJJVrz8X6B09gQixhVPwcpVsKDMS
         6H33cJRvD/OKazPTxndFYTrL6ibJkhOTvzOO1Z/17c+CmvjLa7R62ANxHyOyAriEADfP
         SlZSKVVhT6jxexj9wolRlQOpOZHMt40Mj46LXeoy0vd//kxtt94R6yJZDy9c8oa75Pxg
         RdDg==
X-Forwarded-Encrypted: i=1; AJvYcCXjiAEW6M4MrBFFYwGTIOAfCYPGVDvSqg2MRP+V2RRGqvfLkh9dlwYl966AlKKbQVVRMWfVlhVTDFRA4/8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdNmkMJ1Bu8jSkkeu1Gd49z16GjyH9yt9nEnikAT67fufujCsA
	AYh1Dkpn2OmVob5T1GImJmXFIZx45MYlmvPDG7SGss+Atl4CxVFqlPkwnl6I9hMOp36au44N3p5
	DKeE=
X-Gm-Gg: ASbGncsT/yHd6kmAM1fn4TMc5KdunhcbD7jj+z0NDEyw6NwTUbn5GZXiKseg0RxbFFz
	QGDxRqEfrRvUtQekVqR0a21YUqDHYR5vUukbEY2xuxhlPYvxjU/9lcJD8g83jxDubIKYVt2rRPR
	Gh2i2lSJEQWCIzdzQzZPq4aJ/sYFTKk2ZTRi3E90DiujEA6TFfLbgX0pBhgAs//8ZZeYj+nP8m2
	blQf5z+oJPdfolp15WpPve8jQBbZRQI7T30wZ2s8Q6fB9XxVFdCMFb+6USZvkhWCGFjqA2/OB2m
	KJX2YCQdOdaHBoMj78UMdvkZ1wFf180fT95+CqBU9JitSXGA1I9kiLg=
X-Google-Smtp-Source: AGHT+IFj9LWnQwqEwwAM4v/TD9+jrEVV6TFXglDNz6bQzR+BzsB+tyvLPIttTR1FGzpY9DtHm6lc6g==
X-Received: by 2002:a05:6512:3da4:b0:549:9163:9f5c with SMTP id 2adb3069b0e04-54c297b7208mr1252974e87.1.1743953573998;
        Sun, 06 Apr 2025 08:32:53 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54c1e671fa8sm989747e87.218.2025.04.06.08.32.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Apr 2025 08:32:53 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Date: Sun, 06 Apr 2025 17:32:48 +0200
Subject: [PATCH v2 08/12] ARM: dts: bcm63178: Add BCMBCA peripherals
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250406-bcmbca-peripherals-arm-v2-8-22130836c2ed@linaro.org>
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

