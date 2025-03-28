Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB28211A05
	for <linux-crypto@vger.kernel.org>; Fri, 28 Mar 2025 07:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743147854; cv=none; b=ZsZ2B2vIuxIYKcdH//aPv7hHS+IMMqb0D5MzOYN1FuY5jSA5vuz0hVxtYTDiSkCzH/QGKk1e+0J54MllyjaDwE1kjJVk6OijEGnwHnyb9IbcfDLWhbj++PXxMJwQS1EqtV2ALLMtJxsT3v48rOPjLUa5ngLSvjq2hWHRarAvHSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743147854; c=relaxed/simple;
	bh=p+SiVxlSEGnOTHSwRGX7HFpd0rYneKTYoUHd4aSRoZk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dAw2KNeOmvAtMRUTS4Cz6eHPqQRl4kxx3jNghvA5aQKPl1q2GQxek0mXYeWvgE2GCeT5av52BeISpiWy3Q5C5Q7xnHl26h3XYtk0uJfgumjMozw95FFuGitjllzqKycACMx39L3k4sUdPG0Y6QICsp+tX8txUEtThcdqbXkEMos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nYI5wPAo; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nYI5wPAo"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-54acc0cd458so2010154e87.0
        for <linux-crypto@vger.kernel.org>; Fri, 28 Mar 2025 00:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743147850; x=1743752650; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YR4tw573chI/SmSNQiSCUnriSXeZaFDLdhuvK4Xv12c=;
        b=nYI5wPAoprusJMgXsctvOChjl06gOLzQ/q3SDdhMZ+/OPDw92dKJ0K3L2VMaScgwKD
         xIZW5+AdbDFLcxoDzlX0/czV/OidOvaUryg3HgCFBc/EYBdialkP3e5/6h/pm1+Si1LV
         TlBHnUTXrPbLcvZAZRpibuKaPagWqdbdYZN0l1wBagmuH6lO6NVGgQjXvxKt+bYOfHKe
         dv28GZnGppNxNIWqtWGJx8RnmerQ8QpDSxnuG4F+zKEaMCpk0+AtgeGNXw4TAZ1mCL8N
         yhnAQgEJ+mPutvBY1X6dek+xzUfD+yRNjpk5wV30vfiJuYYJ2ZVlIMw9cR3H43Mov5EV
         pTAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743147850; x=1743752650;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YR4tw573chI/SmSNQiSCUnriSXeZaFDLdhuvK4Xv12c=;
        b=Wupd3Bvdtc7tq3C6RORSEiv0F6CKJqk8bDt4uf5KTeAsxbYwxh/dGAuHeyySwGsNqM
         oFXJiC9XZVeT60n39qvNOPWMcrez0Q+J5JKau4vKsg152Da4yXhmvsgqB5/Cnf52Jqav
         KyxkcfRparkCYSSuC/2VI42Sm7Wy/1k9TQ5bk+CtJ2kFmy2VfTYSRx+LRnq6Vkw0+Bur
         YiXyPI7ZUruDX8cATvr7YxUXC7ZFYh8DiTj5uNNaH7BL+jXnSTIn/HVoc1Z4PW92qQRA
         2Ls0SuY/9hCS0kG7Q5lOVvIPncuY3pw2ouUuwv6xwsCbFYY3Bbv9lrBq628Saij49AtK
         /czw==
X-Forwarded-Encrypted: i=1; AJvYcCX+iTOLqGatq17q2yQ22xqJo+9N539bJqeQsPNt9zhlLTcDBleieu0YLm2F/zlKfsDtp+z2gWnJDzmKnOo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwEkJMXVNpxpQI6unLE5uVVbhRMlIB7k7tWnvLYp2zVBLkLSpR6
	lIPygNkpPg0NPNtEa9EXnq3e1VgrbXB+ROUoqVzPLTV+s3psKb8efxkIbKjx78s=
X-Gm-Gg: ASbGncsi+8ffjth74bKERSU93Vnh4GdMj2hDUuM40lHXmCUCddZlfkABXqRfMYIrHiz
	JJuzNRVWdHZxHuo1biTC3Uh3YMWdwRC92NYzgpT1WG3GW928hqHba5t+mVWOgi+jPzY5fmeCSPJ
	vIEodF96rr0Y+WEaxkE0zpzt4SkyElumIAbyPFZvUCuKRvWRvyxu6vj+KVwWpsqhZjiw355vVeX
	R0AQNWYVCjZab2jsNhJ7sPyVy4QOk+YuvNTmtWZfwvCz+haNgLGUkNeju76vqM0Aw9z35fvUyPS
	hslsBR5L0oBeRMhFWJdqJeUDg2f55d8emO48Zdg2R2i7qKDhJOBQ3Fs=
X-Google-Smtp-Source: AGHT+IF/ArmOEOXgXQfLBNjjj8sVYQ+qLLQU2T2u/X0I6BLM6MCN9j17POGFH6OdY6C2kgn4C8GWFQ==
X-Received: by 2002:a05:6512:3b9d:b0:54a:fa5a:e9b1 with SMTP id 2adb3069b0e04-54b011cd656mr2461814e87.10.1743147850260;
        Fri, 28 Mar 2025 00:44:10 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54b094bb32esm215589e87.26.2025.03.28.00.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 00:44:08 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Date: Fri, 28 Mar 2025 08:43:54 +0100
Subject: [PATCH 04/12] ARM: dts: bcm6855: Add BCMBCA peripherals
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250328-bcmbca-peripherals-arm-v1-4-e4e515dc9b8c@linaro.org>
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
2.48.1

