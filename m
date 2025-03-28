Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608BC211A2B
	for <linux-crypto@vger.kernel.org>; Fri, 28 Mar 2025 07:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743147855; cv=none; b=JVUw4SXs7yOmQSS+WLsp/YoDQ0NcbYIYC2UH7at9qWOu6lPtCb7cqBfEBGzFEUPDbWR/Ooty8t7qTFsjvuog2tcKD/RPvyb0VK2z3dY7+lhkIqS/oLiVzteH/RLqpqUHUk+wAjBOFbvuLK9ZHnnI49a2K0o0kOdQF+V8A1Si8mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743147855; c=relaxed/simple;
	bh=Q7IIwB5olksBdU4VpclQbY+F88U3b856uYZBkOJVhIE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AaLPEIaqhsKL98RpD+BrzPcGbAnRFy1aflEnWBV7Qob3/tn6Qs0iu/OUD3nBwEaV+5hygJuAiFsHm0hd6jlSQUSV6yJWxV2hiv8KpZeIIl9Nb12CHxSA85jdHMjzU7Vwlb2NIw+TJ8+smGT/I1TAeQjGcf/kDq7pEJUmHcDokQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gRb6mhw1; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gRb6mhw1"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-54addb5a139so2098098e87.0
        for <linux-crypto@vger.kernel.org>; Fri, 28 Mar 2025 00:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743147851; x=1743752651; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G+/3tbeqcbFmamPw/dqh2HIcfIwHxXrx1N8SMpql6C8=;
        b=gRb6mhw1Z/zUn9JcSYhN0fFTrmjRCZbfevBFXiyU9+7376RM1O2hGHVcUhgSbIs1sI
         v3kQCwn2xzVjM/B0pB6ntk9w9QTtxZ48dEsuwz94CwnS/rXKjhbRi6fSWZEa42OD6cD3
         FiGPfgAqxhVz6QeVkj9Y4fHVEQOeL6jwyH0L0L3gMx0ORkcFrUufRlB/gWDLGMAS7qio
         ye4z3mpo+VrOLCjtI6T5NjzlBxRQwmj4xFpwV4LrsABvPjC3Sy7ZSKhpQl8IboXupLqH
         5SElM0ZS1pH8rIUjG71fRo2qz6j6OYkL9w5JBZHR6+Yy1MERYSmW6A2J2eEPOZJR+PB8
         7Ujg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743147851; x=1743752651;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G+/3tbeqcbFmamPw/dqh2HIcfIwHxXrx1N8SMpql6C8=;
        b=v9iMEiFVeq2TvY8b4OnD67vVEsvrWvEb4gipUDb+MgHzL/03uG4vvwS4wWc3aWPAtz
         GKRVj2+N1RF688N39Vq5vOD4j8sWG83vWSFh0QopjFLIm3lbtHnPTi086xvrCxRGpX0C
         +fDtvsckDWO+bIxkti1AqHPAF3qTNZIIYZ9EIHn7riKINr668F4iPO/fZ3ftlgGJxU8Y
         6wMTHcODewbCGDVxVz+rEampN7lXBCSIFnms+V3tGxdq0yXWdru+BDA1b90J22tLYuYH
         TsBC2YDa0ncdC6SHUssGI2zNEQzVfxUKWk/E2ZoGiBHPSEENYi/gh8nBx8oIu9PcfPO+
         eczA==
X-Forwarded-Encrypted: i=1; AJvYcCXz2Z3ifDL7r+53I4xb2HPd6tGci+F/eo54Ohj8nSHDYXTrIx8DDIMWaL8/snX64b7FUvPDurKr9Fd5wJs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIXGrWrqggO5KH7KydrNG5nRoVkHWYdjUtYOf+nGglMdvb36sZ
	ktHORRjpTFuJU6t4R1yWaWVclxkWqc/qtKW3+ahRKRL2MTxF8VxBYhkjDDXlCtc=
X-Gm-Gg: ASbGncsLyMnHlDlqOnMKxtoieZ9p9txidGfa2REuBRBJ8fh78y4A5rMNy9wfc2SkB9K
	68a7cyi3yOkpMUHb5YUSfjSQhVtCYAlqtp3l61N6VRAnnacWPioYHGjJGYyK+yCN46JUh9nYc8T
	2cP06AXZUPodoo3S4Rdw6d0oVJrMcdj99D+yCVIRBaq5ArlWZL9DBRKy4dzXLVSVHdaJnyqxCTT
	CobpqsXSrk49pDu8nPWvuWJWM/E+Oum3KBI6O2em6KmAaaiJYI+0ItVT/uavhuVyvyVbrmsXAOr
	nl2JCVIdePInXj4yWtlyOaO0Sia5/Uj+GYcd55FI3RNMHPIVbXY/Nug=
X-Google-Smtp-Source: AGHT+IHeRT5PX7p82HtHwGrF6oShAjlRHSmV+Ax3yGf3Yi7h0e++JC8XWjlv/I2B1dbasVvvi7Z+DQ==
X-Received: by 2002:a05:6512:4010:b0:549:4df0:76 with SMTP id 2adb3069b0e04-54b011ce4f0mr2397769e87.4.1743147851345;
        Fri, 28 Mar 2025 00:44:11 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54b094bb32esm215589e87.26.2025.03.28.00.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 00:44:10 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Date: Fri, 28 Mar 2025 08:43:55 +0100
Subject: [PATCH 05/12] ARM: dts: bcm6878: Add BCMBCA peripherals
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250328-bcmbca-peripherals-arm-v1-5-e4e515dc9b8c@linaro.org>
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

Add the first and second watchdog, GPIO, RNG, LED and
DMA blocks for the BCM6878 based on the vendor files
6878_map_part.h and 6878_intr.h from the "bcmopen-consumer"
code drop.

This SoC has up to 256 possible GPIOs due to having 8
registers with 32 GPIOs in each available.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/boot/dts/broadcom/bcm6878.dtsi | 118 ++++++++++++++++++++++++++++++++
 1 file changed, 118 insertions(+)

diff --git a/arch/arm/boot/dts/broadcom/bcm6878.dtsi b/arch/arm/boot/dts/broadcom/bcm6878.dtsi
index cf378970db08c05c40564a38931417a7be759532..f317fc888da0ef449d9b5153677e6dadd869a7db 100644
--- a/arch/arm/boot/dts/broadcom/bcm6878.dtsi
+++ b/arch/arm/boot/dts/broadcom/bcm6878.dtsi
@@ -108,6 +108,111 @@ bus@ff800000 {
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
+			interrupts = <GIC_SPI 21 IRQ_TYPE_LEVEL_HIGH>;
+		};
+
+		leds: led-controller@700 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "brcm,bcm63138-leds";
+			reg = <0x700 0xdc>;
+			status = "disabled";
+		};
+
 		hsspi: spi@1000 {
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -134,6 +239,19 @@ nandcs: nand@0 {
 			};
 		};
 
+		pl081_dma: dma-controller@11000 {
+			compatible = "arm,pl081", "arm,primecell";
+			// The magic B105F00D info is missing
+			arm,primecell-periphid = <0x00041081>;
+			reg = <0x11000 0x1000>;
+			interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
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
2.48.1

