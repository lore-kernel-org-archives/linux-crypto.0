Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EAC229293D
	for <linux-crypto@vger.kernel.org>; Mon, 12 May 2025 12:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747051561; cv=none; b=cl6F1fj97kRWRjYCEw/m11PpnMHUEmd0n4SPPRqEjUnfGgGE1QymH5jtJtbalc4cIygVpqijB3Cj8ZRp/o5k0a53ZS1uyiLr8dwf8eTQxOZmaPQLiBwepDZV2eHgW2/xGgJXtPbpLMJvN9ER9Dv1BR1uCIf/sa1GMFt1fZr7B58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747051561; c=relaxed/simple;
	bh=twiIqRf6Y1MWxL/OzKmjXR/LSpyFylDcuJLTflZtMls=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=eCQyzdDXaa9+pAEqxnwkIjqBTUYSf1Z2eploAfossl572b3ynD+hLuFKKJGAJqi+vsGXfva9IyuqwbCEr75EFolIFdzkNkT/GfsR4Z0UQG8uFgAgbRCZqz30uLA9LMf2EeBIU1yRJHzTar1auJCXwFgtb2865DFttT3R0nAKPS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lIP7zoj3; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lIP7zoj3"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-54fbd1ba65dso4936802e87.0
        for <linux-crypto@vger.kernel.org>; Mon, 12 May 2025 05:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747051557; x=1747656357; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x3p7DB+5t+yrFgplraEPjC26Y+l8QS9JPSIhGfbkZRY=;
        b=lIP7zoj3LB3e4IuqYRKduYgeqXyAzH1R/Ds0+FC5DnZTCLkCFQI5BQzZd+XKtsCCMF
         aLXddRnNAhW7W5pakpYQuA5hrPLE18TA8xVHxp3Fo9ZkhODvvVq3UFEsTpBCs1JUxLHh
         8dnZXXD5W5jjXZnZ2b8tkqzhICW59acVFrVdllsNWB+CFr2PAlY2TGUfd8XeMD0dYXSr
         NycNUSRj4l6ftsfOnnhzu5owha7ngTzFY1cznD57qeS64/aJkFohqencLd/ZRKd/UxWQ
         iHC7diybD2EGKZ2GqgW5jBIgs+4Vag108ouQMnwnwcPLo3py3vtiS+XNkY2ihSizvIlh
         5amw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747051557; x=1747656357;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x3p7DB+5t+yrFgplraEPjC26Y+l8QS9JPSIhGfbkZRY=;
        b=DxXQftQ8ROTtrqnJE2UxGXfLi9+cMyv62Izl/o+eeufZRXj6UHggDDIMqpWd1JIMRz
         uRIgHQCyzA26b5M0ie5DoFonKIYkQEd8K85SYELK/H0r1jZx86+kRzk4iTHAY0MztVMt
         zwW5bUum4DCTkVdYjo5chpaBoVeckVSO7QfggRmGzwbb4NsStk74+Q1o0yfIkGsYjU08
         D1Or+jr4AOoLxmpZH+AHHTca7cIfCOM3+r8rPtBymF1HnuMnFpPNYv1I1popXWe6TUrp
         nhPa+NjX5w8wWKNjy8iO9qHfR8hmsYQMQN2Eu/gct67kcPYRfWPaT7ddGQuWP95R38Se
         Bg+Q==
X-Forwarded-Encrypted: i=1; AJvYcCVzPb8QXMFQ12ilci9bMjOldqZmMMx8BLIiLD77ZHKNlxKBH32MuIuOL8aKGWuH8ApNDJpL87jNXPxYzFU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXntCj09ZzuGg46TTAAYfGsDMFqEP0T+7b+2JP+WCubBrVZOLD
	sjONaTbwyzUozbzwJiTWA+C1Jzb639fMvdUXqHMmloNLsNetFruwYdYZjrwOFYOO4Jj5lwLJB+p
	c
X-Gm-Gg: ASbGnct+U+Iq4rBGzgybAt1uSsDVgfWKk92k44rU5+kdlJ6r7FckHJ0aEL402ig0HcI
	ee/ONSL+8O2OiR3RDUUVhwj5VCGps9mTgQFHCtkrIfGFKfCEmnEjxzw3l4veu9NamFoPSkR8HSX
	emXY75gop/JVSIssptFskQT4VYBEu4uc5/lc7arrOJXxLrHj5AkbW9hFQyymBznT24Jp/yaxusT
	TtHPssJVwNzrCOUBlhpnVGR93p48YOMAfw1Auqyjd6leMzopgfF+ZnG9iN2sqqyYt6cp5tRjX2Q
	2wFXvvk+sDUcA3qUUCVaAVdvJ2KPkIY6iKahN0fqZ0jX6Eh2mjRbvcYRnRFS5g==
X-Google-Smtp-Source: AGHT+IFyxT+e/TpUjh6gEnf6+3FsAXhoKrFqOea2BadRcCNRn1SUi4Rzh5CZkkdbeVFmcxxdJdmnEw==
X-Received: by 2002:a05:6512:660d:b0:545:62c:4b29 with SMTP id 2adb3069b0e04-54fc67c5b72mr3878104e87.22.1747051557169;
        Mon, 12 May 2025 05:05:57 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54fc64bf8a3sm1466033e87.189.2025.05.12.05.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 05:05:56 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 12 May 2025 14:05:51 +0200
Subject: [PATCH v3 05/12] ARM: dts: bcm6878: Add BCMBCA peripherals
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250512-bcmbca-peripherals-arm-v3-5-86f97ab4326f@linaro.org>
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
index 43eb678e14d04be487af39c9365186b6fb919cf3..dd837bf693905736a7b8ef9cfefea8368e6df6ed 100644
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
+			interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
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
2.49.0

