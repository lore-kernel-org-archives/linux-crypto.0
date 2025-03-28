Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC4A212B17
	for <linux-crypto@vger.kernel.org>; Fri, 28 Mar 2025 07:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743147866; cv=none; b=kO4iRmaINyJsCmWHH0oxPikeANwmkGZo8JWVxdgd2tCiHt9yYMt8ADW0eit0Q0lnXTfvHHURjNQTyzzHPEgsiGgCa/YWLI/DzVvgFKEpW9KhR/5o9Io3aa2THoSkcmO665yakxnGQgs0kcIDRxGDqwUpQndew4NYxfNDLcbp98o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743147866; c=relaxed/simple;
	bh=q2PmTDQegE/isnKM1Da4UKDK69dR4SgFV6YzECB6JsE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ePghVuu9XoSwxx6VE9WG2G+fexmPH3H3BDEdTlTHTtJy83akSVluoiUM5oGL8ITquE9ESiIYIfzGYq0JZxiTmunIlCvr1kOJeQAVT/s/xQsSQ4kFoRU5wp64YThG5UrL1f0DHs3H9ijF6JKJvBRwTaj53JH40NsSZdQp0Df2yh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JIRCopL4; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JIRCopL4"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-54af20849bbso1995831e87.0
        for <linux-crypto@vger.kernel.org>; Fri, 28 Mar 2025 00:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743147862; x=1743752662; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zArY1PRZ2YS97S9H1azNoi4GZH8ue6vwYjHQDksS40s=;
        b=JIRCopL44SKE/Cxrs2CGO/WPKhqebwkwbuw44LsGbUOu5x54IFYjiHhvlbuzjpG3wu
         vFJBRl4jXNnVmPhWaUNRtdlZVDe4gXknl8ENoPF3HjCHe8CyhDfjiAk8krUto6tmTv5V
         UftKKg0DKX+m5UBoV/azsRAv9yiVQDbUi+/LOb9A4BB1OMefel14fopKBLmpR9DAALUL
         RThXcX3bDkmjjhyr4pdZIV49+31QxJw/20gB5By9CGIY7XKuz1+MCk702/8WxMlZfdqt
         tPLEbo/azHUObtTGTnOgGI9J5y8FUqqcpeNx5bdDap6nrAi2sULhOezM1hzoSelec+7v
         I36w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743147862; x=1743752662;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zArY1PRZ2YS97S9H1azNoi4GZH8ue6vwYjHQDksS40s=;
        b=Fjkok9uMOvTouLvIauQfnHXvpopwEzLSlRErHc+i/BVBw/gXTnbEaFFgfJY3WGlA9h
         hxdR1lEDSAkhqsStWAl7wO+Ea2JVYaTdB+BHiIOnCp/ZLMW3janwcjppR8c0fpl9mA0F
         O9Zos5L6nRgZGUyN9vXbRC72p4Wn9nPRV0aZbyyk2isc4VVKTD47VHlp/3oeft/PVyKU
         SC2SB53iFQHpt93RTK7Wwf4wQn4bgdvnPh24tqxfXoblfMEPlbOT6L1sn10BYJrQ7BYs
         sq4DU0eVi9zY9pDuy4oXZquRzuamggM17l0auowoFUOevvhqG9IU5VCkq8B2bAmhzlzH
         GLVg==
X-Forwarded-Encrypted: i=1; AJvYcCVrXE7QjmzwwTJPsvF8m7EP888hcV5hCh0WBiO0JJ2yInkdEeqzR+hjxj4mIG6gdqWUV+CYliE1+bZP3aw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLryhdOaQKJ23mJu176sCSwA1/mDaoCaN3bahRiEWGuPYP0gvD
	cfslt4z3wmx64k0ynOxR31S2IQnjmXh8nIv0Zj7vdR0+Alf4F5zaeDr1/P7uKeI=
X-Gm-Gg: ASbGncuWGfH2zfJjeKjmHnQcHFESLzuPg5yqRqtPkdLrQxB7BiPuo+FlkMG7ijIKjzp
	6dNydr7t8TlT+7BrYj0aeeiW0QaGwc3066HaNoZ1tdTrnOCf7lS9hFP4eNuv8nq7tmtncHWVSP2
	UJEtL8UNgAQ24bwvN41fNrGgOC7jaUsNY8cFBPuSRV+b0UsvAb/FwZXFAaeRqPKP01t1JThZwGe
	nUXaubI1dylsbaoOkYuB1p/UMyLIU9WVSRPeBHarpDH/NwLN8DNafcCT7F6eNRfNpa2mzXRwk2o
	JGEarGoOqMDOr0viiMj7414dOWzoj1kx4DCA7Yb7qRTH0skLsme+lCbTRqy75HCwtQ==
X-Google-Smtp-Source: AGHT+IGmha8Fr2gz/FUW8U8A5VVRA9bYdMwRke2TGOO5wTQdAYbyURhNf7j91OLXxy4jdG7Mg7idRQ==
X-Received: by 2002:a05:6512:159f:b0:545:54b:6a05 with SMTP id 2adb3069b0e04-54b012668cemr2795574e87.45.1743147862054;
        Fri, 28 Mar 2025 00:44:22 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54b094bb32esm215589e87.26.2025.03.28.00.44.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 00:44:20 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Date: Fri, 28 Mar 2025 08:44:02 +0100
Subject: [PATCH 12/12] ARM64: dts: bcm63158: Add BCMBCA peripherals
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250328-bcmbca-peripherals-arm-v1-12-e4e515dc9b8c@linaro.org>
References: <20250328-bcmbca-peripherals-arm-v1-0-e4e515dc9b8c@linaro.org>
In-Reply-To: <20250328-bcmbca-peripherals-arm-v1-0-e4e515dc9b8c@linaro.org>
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
with varying IRQ assignments. On BCM63158 the PERF window was
too big so adjust it down to its real size (0x3000).

Add the watchdog, GPIO blocks, RNG, LED, second UART and DMA
blocks for the BCM63158 based on the vendor files 63158_map_part.h
and 63158_intr.h from the "bcmopen-consumer" code drop.

The DTSI file has clearly been authored for the B0 revision of
the SoC: there is an earlier A0 version, but this has
the UARTs in the legacy PERF memory space, while the B0
has opened a new peripheral window at 0xff812000 for the
three UARTs. It also has a designated AHB peripheral area
at 0xff810000 where the DMA resides, so we create new windows
for these two peripheral group reflecting the internal
structure of the B0 SoC.

This SoC has up to 256 possible GPIOs due to having 8
registers with 32 GPIOs in each available.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm64/boot/dts/broadcom/bcmbca/bcm63158.dtsi | 150 +++++++++++++++++++++-
 1 file changed, 147 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/broadcom/bcmbca/bcm63158.dtsi b/arch/arm64/boot/dts/broadcom/bcmbca/bcm63158.dtsi
index 48d618e75866452a64adfdc781ac0ea3c2eff3e8..a47c5d6d034a7ae56803a651636148383acb8cc9 100644
--- a/arch/arm64/boot/dts/broadcom/bcmbca/bcm63158.dtsi
+++ b/arch/arm64/boot/dts/broadcom/bcmbca/bcm63158.dtsi
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0+ OR MIT)
 /*
  * Copyright 2022 Broadcom Ltd.
+ * This DTSI is for the B0 and later revision of the SoC
  */
 
 #include <dt-bindings/interrupt-controller/irq.h>
@@ -119,11 +120,107 @@ gic: interrupt-controller@1000 {
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
 
 		hsspi: spi@1000 {
 			#address-cells = <1>;
@@ -150,14 +247,61 @@ nandcs: nand@0 {
 				reg = <0>;
 			};
 		};
+	};
+
+	/* B0 AHB Peripherals */
+	bus@ff810000 {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges = <0x0 0x0 0xff810000 0x2000>;
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
+
+	/* B0 ARM UART Peripheral block */
+	bus@ff812000 {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges = <0x0 0x0 0xff812000 0x3000>;
 
-		uart0: serial@12000 {
+		uart0: serial@0 {
 			compatible = "arm,pl011", "arm,primecell";
-			reg = <0x12000 0x1000>;
+			reg = <0x0 0x1000>;
 			interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&uart_clk>, <&uart_clk>;
 			clock-names = "uartclk", "apb_pclk";
 			status = "disabled";
 		};
+
+		uart1: serial@1000 {
+			compatible = "arm,pl011", "arm,primecell";
+			reg = <0x1000 0x1000>;
+			interrupts = <GIC_SPI 33 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&uart_clk>, <&uart_clk>;
+			clock-names = "uartclk", "apb_pclk";
+			status = "disabled";
+		};
+
+		uart2: serial@2000 {
+			compatible = "arm,pl011", "arm,primecell";
+			reg = <0x2000 0x1000>;
+			interrupts = <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&uart_clk>, <&uart_clk>;
+			clock-names = "uartclk", "apb_pclk";
+			status = "disabled";
+		};
 	};
 };

-- 
2.48.1

