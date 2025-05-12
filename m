Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EFD29375C
	for <linux-crypto@vger.kernel.org>; Mon, 12 May 2025 12:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747051568; cv=none; b=aQTVETYRTNe1QKW58sVRV9HmUJJoBqUm6brKC3pj4Ar2kjTkhxoAdTHaTlLztd0LIU6XaQHX/om9dwLyMYg0x69YtgTpBMGXWmheKWSTrpr5ZYmiV4jSP1Q9PS3IzrIb+cadcheJZHzAM3fhSLay88Bcxt4K5WJCf0ioUbHDB5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747051568; c=relaxed/simple;
	bh=0EFZp6jCdPwGTF5uBHzyjqY+Ty0+cL5jFgXOVv/OZ1c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ukkvc0oO/gPCiI8h3wlD3xnPZzNHu4YSSv1UESBR06+BJ44SgVY/SyVsnFeXgKXdlYeWIP6DWJracpHWqGda6vfLzgP9IuN03/9qyPgQA5NjmTW9zoKSZu18YUOZq5ObODOzkDBLYBgYLE9gkc/vwzyffJWVCA4M+E5DelJaTLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LHeDlf/t; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LHeDlf/t"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-54298ec925bso6442435e87.3
        for <linux-crypto@vger.kernel.org>; Mon, 12 May 2025 05:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747051564; x=1747656364; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iMHCBS0if0cnlwKmMIsceybB2DKlEexq99G6FWGTcxI=;
        b=LHeDlf/t7C47bEeJwr8OVj70g9EfwWvMYmhBLV6lBHgY+ztKmmCsMkyGaifX/1b9Nq
         v6MWEWbmdeFZaS8warcpZ0C1iObw6SXdDUxlJlFPUaPGH14EK3FKGljZGD1AlFetZ1Po
         MehdW6D1wbwjxuu/LlMm3xUGeFPV8yOyi8/+0fHB6rxMNoAzpFbpsj8XsXfSo+SUfgZR
         EBOoMCmhEzsAHdpxJvyhtAgNoea+qZsaU4XXSpb/7yAItx4HdQWRSk/6H97EELvcmUvL
         5BHH0yPle5ckwzzf7FCE7cZFU7DF2n17aO42lOc9MJl5x0oWaOAWBURXt/TRGJip1SS2
         iNkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747051564; x=1747656364;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iMHCBS0if0cnlwKmMIsceybB2DKlEexq99G6FWGTcxI=;
        b=BBqLhQfWrwsM6YzDL7QPLv7+dVB+m2vgh+ae+zh3orYea5Pn/FvByKi2dfSKDYW3tY
         lbJuJNepsoA0PRLPb8o1MRck/EpQpL0n8iAaEayv/bJgNGl3mUYzFKPMq9QMi6V4VU2p
         NBsJrxDnH24ayvIIGzSKG8ENSS8CzQwTXrHGUHliizEj3CpXoUo/UrFF0GPOc9hjetls
         jG/Wp9ZwgLmMRRxs9IWUEcyEG1tyZktygghoXDWaeAlX9XlABCmMnxhiSjw86vizzovY
         86Jj5Sr0m4U1R1O/Lj1gM8iKTwQ0Wm4SCQH5OMQdEVKNHDqawPuUR1Io+p+AMs0Q+EhH
         eDxw==
X-Forwarded-Encrypted: i=1; AJvYcCWUWuHuGHBlaVGj+MR3WzZSQ9PMh8SzCL+wFtE9wv9rv75+KGZ61IovxfXKhYpHa8D2CkA58mnfFEAFqsE=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywq/spdpaI3ZxM4Z/NNyBAxy2olY3Fk0i3ARnDMb9xvDto7FAhO
	kVPExV1uLfsiGMRRSy8tNpr1m+6iJMyU8nYBifxPYWIjJ6BlxQoojgUnLEfmJlP3qQzFSO1J01K
	c
X-Gm-Gg: ASbGncu1Tk8EBv5un7b2AdjGlw889SIQmtJR4u1dkq7v7FnOaQQZ2GPUAssN2uuXAdV
	GJvui5g4v+FrkbiNYwdMilkxY2Su1npnC6x6XT4IQnz7sDOwafFSMdSVLCyDTyZ65Ulxo4Pyj9n
	Bkrklh4MQye7fGrwmniqZPApBQfYGrZy+rLxlC/MLjlMd3FjxkJxiaaR+SybzuFT83y/2hhb1Af
	NmF4o5Mqo2Gkhx+t+i8xqo+S21Uv/U6Tf3vt+RdCUtKRn4+6DO3C0ub+B7WRccy2ZkQLmQiL5I/
	xHwP2BLlA7gZ/ROzjfm+wXAD9O3VRN8UqK17tt86lUxb+FYusOlyGA+Cxu+moVcrosANMYTT
X-Google-Smtp-Source: AGHT+IFKLyv7PHn6Lok1bEUkjovUWReFWptxKqF+Zjq8PYbN39Dl2AbUjj1cgZazNFL5Lv8ZsKYfRA==
X-Received: by 2002:a05:6512:3b86:b0:54f:c5bc:3cfd with SMTP id 2adb3069b0e04-54fc67e4cfdmr3762780e87.39.1747051563829;
        Mon, 12 May 2025 05:06:03 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54fc64bf8a3sm1466033e87.189.2025.05.12.05.06.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 05:06:03 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 12 May 2025 14:05:56 +0200
Subject: [PATCH v3 10/12] ARM64: dts: bcm6856: Add BCMBCA peripherals
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250512-bcmbca-peripherals-arm-v3-10-86f97ab4326f@linaro.org>
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
peripherals at 0xff858000. Extend the BCM6856 the PERF window
to 0x400000 and add the DMA block at offset 0x59000.

Add the watchdog, GPIO blocks, RNG, LED, second UART and DMA
blocks for the BCM6856 based on the vendor files 6856_map_part.h
and 6856_intr.h from the "bcmopen-consumer" code drop.

This SoC has up to 256 possible GPIOs due to having 8
registers with 32 GPIOs in each available.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm64/boot/dts/broadcom/bcmbca/bcm6856.dtsi | 130 ++++++++++++++++++++++-
 1 file changed, 129 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/broadcom/bcmbca/bcm6856.dtsi b/arch/arm64/boot/dts/broadcom/bcmbca/bcm6856.dtsi
index 00c62c1e5df00c722884a7adfcb7be08a43c0dc3..dcbd0fdd33d25fa340c417e8284826801ebc00bb 100644
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
+		ranges = <0x0 0x0 0xff800000 0x400000>;
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
@@ -133,5 +248,18 @@ nandcs: nand@0 {
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

