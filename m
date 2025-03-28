Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A384211A00
	for <linux-crypto@vger.kernel.org>; Fri, 28 Mar 2025 07:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743147864; cv=none; b=PMIejcTfqstnmBCnyMbdRGTfSYWTX4T7qGSTEd18toSfJRiRtA6K46spFZbcqi2LaxGKEDu3vNOapZzoWksYsb+ZBRqquLp3DeaqdQHPYDHHTDZbzD9p/bQ8Zc/ZRIja7uR61UE10h0tppHk3wHgZC3GzfwVJJzXl4mW8TLg4xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743147864; c=relaxed/simple;
	bh=+zgydmgyIsStNwKblWAAWyc0BZ3B+SWIYN+KJb0i7pU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=q89D668PI2H8mVEqL2ROWPZCno8BjfisGN6MiCZ33Rwfn7GLwMstv+MTST0iK7exlEsuDEiidWQOFFc3/NEz5hZxdA8LmyxLO9kHeffk1US5UQFnflHOFaQb0vRo0Psxwit8IVv3rlfAVl55So8eEgLZwcgs7pOfZOjOG2eU+QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MqYL4pUD; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MqYL4pUD"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-549644ae382so2293290e87.1
        for <linux-crypto@vger.kernel.org>; Fri, 28 Mar 2025 00:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743147860; x=1743752660; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wqJlxfb5aBB2ZfepHoR0jO5tKOR577Vi8xz08RMS2n0=;
        b=MqYL4pUDUCvzNCABJ7UasUnnyG61PXhlAj0Yfo6EIx87I3s9Wa9n0NSzYLYrC9Ra/L
         tQwcCIrLoolW3Qg6/gHRv0Yqk6JKUotn6VCqp7d+4TTKzIJJxfm6W/XIeG4kCj3MqP/4
         TVAqYkpWoPcUNePqmlzDqU1XO/hbYTxomLR3pvYcfFPGTOXvCSFIuCe+9LWnLehM7C/k
         otBhQcegcjyn2JYc9OVcI8HXaMQz+mOUBM+bgWL/M9+NeTlTlnLkvD3ZWGztDRxTL4Hc
         k8zeFdPJ0P1l4KysdD5HtBP5NHedt7/a1rMUIRjwEyc3nuhraIyOqm745vnJ+hH8v/4r
         Wz1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743147860; x=1743752660;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wqJlxfb5aBB2ZfepHoR0jO5tKOR577Vi8xz08RMS2n0=;
        b=FoHjRttk/Ekv42cw4UHgKRx+qdRyBG+pL0eoMXKSe3OZCdc4oXY//3KJTtW/dFgqOB
         xWH3Vk2uIBY0bvTh9B4H/hLJYF7hmqD0awWRXOorWPhqkT0FMVPzZFS/YYyTi/isIcB9
         XB5yFdmoRFAV8L1hqOd3QiiinxFgKJJMHkACha38y7ESmuVZ29Gsi8bGJA3wAPCWpLha
         yOZ7DwIG9h2AYFcJ947QxA5xLS7F33zkgcppqt954fC96Tv0ES4pbnxa08ibdLBBSMjj
         N8xYDsyXuWE7BVzzzWIAULbHtJlzjCc3Gmm2K4Tw3sRnsgPPiij77/9jhBgRn0VviLqY
         RkSg==
X-Forwarded-Encrypted: i=1; AJvYcCWW2MQBUWMvD3vGqS1tCPXt5zjBa6ipP+Zospd/fBm2zbRZQhF4772KtHnyzI9aVOyKDrqChDjYi8w12dE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCaOWwwwKTHqU7S44jDIR2NYEYR47rsyDSUeGKOXesgafb33kq
	0/SnUQ6GLyRrbynJRfc/slxJdrqBeaoavptWLjQkM5MAQ7ICAXyMId9cHYRSdWw=
X-Gm-Gg: ASbGncsGv8qHE1o1lyevqsCDIZiS3X0+/pq1Tqu6jhr/smJEkINzfKxw1pPMrVV+Ofb
	6snISUd0+L0z+kRIR/xKbYY7wg1ehRlYuRHqgH3O7xuKrMmIoGbJHgcYG469LfrYojIgHzGj+Hx
	xdTvqyPUk+L01U/imsdRxZDKZCMnPeItH5ikLT4cEcz+uBM5/WdZsRRwG6QVSHvnyvvOWUQQz2m
	A2+Rh6O9PVw9t9TFn196d0F+PDE3n1iPgGtImk53wKREzxU5TeAfdlwcv9D02GB4UzvI7WhcIHU
	H0Whk/U5Uw8kfUY9OI12mDlXWObWCOYhYfBFUjoDn/oFUXkiVjTQIb0=
X-Google-Smtp-Source: AGHT+IGLSPJ1RA3Mlh8r4xvIZWPkrQmL4yqPDHVMGHuMR92ZlKGsQvblUQYEwuvD9wlp1zLdTfeK0A==
X-Received: by 2002:a05:6512:b84:b0:549:8fb5:f0ca with SMTP id 2adb3069b0e04-54b011cd7cbmr2156083e87.2.1743147860431;
        Fri, 28 Mar 2025 00:44:20 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54b094bb32esm215589e87.26.2025.03.28.00.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 00:44:19 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Date: Fri, 28 Mar 2025 08:44:01 +0100
Subject: [PATCH 11/12] ARM64: dts: bcm6858: Add BCMBCA peripherals
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250328-bcmbca-peripherals-arm-v1-11-e4e515dc9b8c@linaro.org>
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
with varying IRQ assignments. ARM64 SoCs have additional
peripherals at 0xff858000. On BCM6858 the PERF window was
too big so adjust it down to its real size (0x3000).

Add the watchdog, GPIO blocks, RNG, LED, second UART and DMA
blocks for the BCM6858 based on the vendor files 6858_map_part.h
and 6858_intr.h from the "bcmopen-consumer" code drop.

Curiously, on the BCM6858, the PL081 DMA block is separate
from the two peripheral groups PERF and PERF1, so we put it
in a separate node in the device tree since this is what the
documentation says.

This SoC has up to 256 possible GPIOs due to having 8
registers with 32 GPIOs in each available.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm64/boot/dts/broadcom/bcmbca/bcm6858.dtsi | 120 ++++++++++++++++++++++-
 1 file changed, 119 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/broadcom/bcmbca/bcm6858.dtsi b/arch/arm64/boot/dts/broadcom/bcmbca/bcm6858.dtsi
index caeaf428dc15db3089bf4dc62c4a272782c22c3f..a53520ce693c7360c603e8f46cefe134a509d051 100644
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
@@ -171,4 +275,18 @@ nandcs: nand@0 {
 			};
 		};
 	};
+
+	/* This is NOT in the PERF1 Peripheral group on this SoC! */
+	pl081_dma: dma-controller@ff859000 {
+		compatible = "arm,pl081", "arm,primecell";
+		// The magic B105F00D info is missing
+		arm,primecell-periphid = <0x00041081>;
+		reg = <0xff859000 0x1000>;
+		interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
+		memcpy-burst-size = <256>;
+		memcpy-bus-width = <32>;
+		clocks = <&periph_clk>;
+		clock-names = "apb_pclk";
+		#dma-cells = <2>;
+	};
 };

-- 
2.48.1

