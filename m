Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F23221E091
	for <linux-crypto@vger.kernel.org>; Sun,  6 Apr 2025 15:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743953579; cv=none; b=jEbEqJxLNHk/fFt05QSErSc5pFCWFkAoXPzdPwXlibbIgGKM01rPlqKqmIowpsLCebeiPQz1FdCNiuk3QSXEeYWSStE2IAkRGNISeHmHsi/sLXyGNo/ZKiKtZzeq9YXy/lg6D8r1LSoU94EHur+5IituKpblcH5WHh2HFCMNtCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743953579; c=relaxed/simple;
	bh=YDrkEWeTsdMn84aNAbf/VQFW41iz+LQAjJhuUzBzoGc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EDsT/KaI+vMfjdvQZsxVbpjcO70DvXKD3RbKRjsFszVn4YTgT1bByWNUL/3dYC/mQv830bF4d+eEYlwaE5VGFbYzqC+GaaBivCFUYPPKCpnSonAE/U6qNKEyf2A1tezMfmiBtLzThjVBBGWZaLiI8tBYPLMaS3Nq1shidl+JkPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TM3sKEh4; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TM3sKEh4"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5493b5bc6e8so4501880e87.2
        for <linux-crypto@vger.kernel.org>; Sun, 06 Apr 2025 08:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743953575; x=1744558375; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XM7VZdytvS/9hUgz3c6+oanhzNKcJjPBC3I1WtjPp7I=;
        b=TM3sKEh4JO+4/NnuJ2i5Wy1hITXJ+hP98zsxFIHqEVzfps6fXpx/I5P2IMMSTM1aw7
         6eR0eRpTcPPSJ4X7G989I0O3ecITpnuQgHGT4Ts1yrLM8/43yvz07ENcynFQG35XxCp7
         wxLQUgKk32SIdPiRmGsRsSC7b7fIt7FBhOFLeAp1LdXPLSCxC3zJCfnMsPdxkkD7J4wq
         AavWcJyxU87qiNNxrPEaN4wMgMYw9VkteOAZHZWu/ImyCDxCMqz5ngzyJWTkcETk455V
         j0JIekMVwMyLLQ0/bL0LzyUwUORf40ebO6EBInPUAiP3/7JqQoxUj+0IZ3peWdDE5pq9
         PzWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743953575; x=1744558375;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XM7VZdytvS/9hUgz3c6+oanhzNKcJjPBC3I1WtjPp7I=;
        b=akAw+C3THnbbLYK7aygW/Q6qhSdG2F8B4vGWHCAG7bvO4lGbhsr2Bd45Vxiyu7LS3j
         pBvC3V/o6U1o6lKiuEnm2Raa7wZF0J0vvpZDlQPE6UgWnzahYWGjSmYJ3XkRUB35KjtG
         qQ8GuSgFPKH4io/A650XU8cYsL1QtRnYT9XIfYpT0UunaHofQ8tNU+5KVF73ggkiVbWQ
         uP7GCxzpJPA5ad46wSTqJP9GGxevuyQp3Sua3CODG0oU3utB+PhhTb8TkV1f6owN/qcV
         92WjLWrLZK2310Co2IacKHbgb+ovJSt8Axw4t6a9zmxuK0guEUnFBD5DT1Kc4y4ex/RJ
         Quaw==
X-Forwarded-Encrypted: i=1; AJvYcCVVRmjuKSw2e4o77VQB9goWj6yXqF6ryEqkBMa4zka3V9dXVdWHwZJcKC5Tr5JtCOxecgw4jEUumoO9EJw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSpf2Pbne9RJ0BPfTQtF+OysciLCP9US+nJONQ5SlL7AAlkarq
	48oi03HkvgFdlz4tk9h2ea7BRd40WZSVT+arZhBj24HlGvWNNGW3FzHLwTiSUB0=
X-Gm-Gg: ASbGnctVq/qGYIVMbPbbSkc9JuB0mzcN0O7fNOnuKAnlk7omFPVTHwx4fxibxtxqLnT
	ujcbbmE02Lmg7S7gHVE0rcsr8meB0bSLA4tKThelsD63bi+ZvdLPPMMcOR+v7XbCHhOxCd2QwlJ
	2KLwDSE1dAaD9ZEzDv8n1mZW4cZ+RB5Ynv3UT3WxDQumRviXD76jRW35jpCQLMfbR9vIu3xroAa
	sMuNrLHAk8K8BXurJFDvEiAQlwC9UWTNVGPfADdul83nitYkzH5sVJV0Yq9Od1BidqSJvNplBdh
	g+clN0Sm1e4jCrfj7tvhDxWsXCZUw0EGFz43Rip/gCcMxm+3xs4y33o=
X-Google-Smtp-Source: AGHT+IGatGeNIuxIlqc+4azXsluaw7cwdCRqrVj9KzzeSUMPgq7VF7F0zj8KyrBeuAJmbGbwaI4bsg==
X-Received: by 2002:a05:6512:e9c:b0:549:7394:2cd0 with SMTP id 2adb3069b0e04-54c232dfabbmr2490447e87.19.1743953575548;
        Sun, 06 Apr 2025 08:32:55 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54c1e671fa8sm989747e87.218.2025.04.06.08.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Apr 2025 08:32:54 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Date: Sun, 06 Apr 2025 17:32:49 +0200
Subject: [PATCH v2 09/12] ARM64: dts: bcm4908: Add BCMBCA peripherals
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250406-bcmbca-peripherals-arm-v2-9-22130836c2ed@linaro.org>
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
peripherals at 0xff858000.

Add the watchdog, remaining GPIO blocks, RNG, and DMA blocks
for the BCM4908 based on the vendor files 4908_map_part.h
and 4908_intr.h from the "bcmopen-consumer" code drop.

This SoC has up to 320 possible GPIOs due to having 10
registers with 32 GPIOs in each available.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm64/boot/dts/broadcom/bcmbca/bcm4908.dtsi | 122 ++++++++++++++++++++++-
 1 file changed, 120 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/broadcom/bcmbca/bcm4908.dtsi b/arch/arm64/boot/dts/broadcom/bcmbca/bcm4908.dtsi
index 613ba7ee43d6489ea0f1490d2fccaf90961b2694..a2e5277a2e77c0bdec5d933d3121b4ebf2d2d07b 100644
--- a/arch/arm64/boot/dts/broadcom/bcmbca/bcm4908.dtsi
+++ b/arch/arm64/boot/dts/broadcom/bcmbca/bcm4908.dtsi
@@ -323,6 +323,7 @@ pmb: power-controller@2800c0 {
 		};
 	};
 
+	/* PERF Peripherals */
 	bus@ff800000 {
 		compatible = "simple-bus";
 		#address-cells = <1>;
@@ -348,13 +349,103 @@ watchdog@28 {
 			};
 		};
 
-		gpio0: gpio-controller@500 {
+		/* GPIOs 0 .. 31 */
+		gpio0: gpio@500 {
 			compatible = "brcm,bcm6345-gpio";
+			reg = <0x500 0x04>, <0x528 0x04>;
 			reg-names = "dirout", "dat";
-			reg = <0x500 0x28>, <0x528 0x28>;
+			gpio-controller;
+			#gpio-cells = <2>;
+		};
+
+		/* GPIOs 32 .. 63 */
+		gpio1: gpio@504 {
+			compatible = "brcm,bcm6345-gpio";
+			reg = <0x504 0x04>, <0x52c 0x04>;
+			reg-names = "dirout", "dat";
+			gpio-controller;
+			#gpio-cells = <2>;
+			status = "disabled";
+		};
+
+		/* GPIOs 64 .. 95 */
+		gpio2: gpio@508 {
+			compatible = "brcm,bcm6345-gpio";
+			reg = <0x508 0x04>, <0x530 0x04>;
+			reg-names = "dirout", "dat";
+			gpio-controller;
+			#gpio-cells = <2>;
+			status = "disabled";
+		};
+
+		/* GPIOs 96 .. 127 */
+		gpio3: gpio@50c {
+			compatible = "brcm,bcm6345-gpio";
+			reg = <0x50c 0x04>, <0x534 0x04>;
+			reg-names = "dirout", "dat";
+			gpio-controller;
+			#gpio-cells = <2>;
+			status = "disabled";
+		};
 
+		/* GPIOs 128 .. 159 */
+		gpio4: gpio@510 {
+			compatible = "brcm,bcm6345-gpio";
+			reg = <0x510 0x04>, <0x538 0x04>;
+			reg-names = "dirout", "dat";
+			gpio-controller;
 			#gpio-cells = <2>;
+			status = "disabled";
+		};
+
+		/* GPIOs 160 .. 191 */
+		gpio5: gpio@514 {
+			compatible = "brcm,bcm6345-gpio";
+			reg = <0x514 0x04>, <0x53c 0x04>;
+			reg-names = "dirout", "dat";
 			gpio-controller;
+			#gpio-cells = <2>;
+			status = "disabled";
+		};
+
+		/* GPIOs 192 .. 223 */
+		gpio6: gpio@518 {
+			compatible = "brcm,bcm6345-gpio";
+			reg = <0x518 0x04>, <0x540 0x04>;
+			reg-names = "dirout", "dat";
+			gpio-controller;
+			#gpio-cells = <2>;
+			status = "disabled";
+		};
+
+		/* GPIOs 224 .. 255 */
+		gpio7: gpio@51c {
+			compatible = "brcm,bcm6345-gpio";
+			reg = <0x51c 0x04>, <0x544 0x04>;
+			reg-names = "dirout", "dat";
+			gpio-controller;
+			#gpio-cells = <2>;
+			status = "disabled";
+		};
+
+		/* GPIOs 256 .. 287 */
+		gpio8: gpio@520 {
+			compatible = "brcm,bcm6345-gpio";
+			reg = <0x520 0x04>, <0x548 0x04>;
+			reg-names = "dirout", "dat";
+			gpio-controller;
+			#gpio-cells = <2>;
+			status = "disabled";
+		};
+
+		/* GPIOs 288 .. 319 */
+		gpio9: gpio@524 {
+			compatible = "brcm,bcm6345-gpio";
+			reg = <0x524 0x04>, <0x54c 0x04>;
+			reg-names = "dirout", "dat";
+			gpio-controller;
+			#gpio-cells = <2>;
+			status = "disabled";
 		};
 
 		pinctrl@560 {
@@ -584,6 +675,12 @@ leds: leds@800 {
 			#size-cells = <0>;
 		};
 
+		rng@b80 {
+			compatible = "brcm,iproc-rng200";
+			reg = <0xb80 0x28>;
+			interrupts = <GIC_SPI 79 IRQ_TYPE_LEVEL_HIGH>;
+		};
+
 		hsspi: spi@1000 {
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -638,6 +735,27 @@ reset-controller@2644 {
 		};
 	};
 
+	/* PERF1 Peripherals */
+	bus@ff858000 {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges = <0x00 0x00 0xff858000 0x3000>;
+
+		pl081_dma: dma-controller@1000 {
+			compatible = "arm,pl081", "arm,primecell";
+			// The magic B105F00D info is missing
+			arm,primecell-periphid = <0x00041081>;
+			reg = <0x1000 0x1000>;
+			interrupts = <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
+			memcpy-burst-size = <256>;
+			memcpy-bus-width = <32>;
+			clocks = <&periph_clk>;
+			clock-names = "apb_pclk";
+			#dma-cells = <2>;
+		};
+	};
+
 	reboot {
 		compatible = "syscon-reboot";
 		regmap = <&twd>;

-- 
2.49.0

