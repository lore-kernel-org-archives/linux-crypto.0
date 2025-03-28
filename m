Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467E2212B3A
	for <linux-crypto@vger.kernel.org>; Fri, 28 Mar 2025 07:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743147861; cv=none; b=iQ8u8p40RQWZrDEoJfXJORIZeRX/n1Zd1KN5C94AQbrz5g99f0wyCH1Wehzua8R9KpzDrg3xtfNR6UPWTa/S5cmrDGxns8+dQ7Qb7eDTWi9owKyN9882g8MSayEXPFN2MTzeOhE2TpdZpWUGicXqMm6QZSaJd+/QL0udNSMGMhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743147861; c=relaxed/simple;
	bh=O3tClXRclkQgAO4VzgKTMLresCnfR5pMyLyTEvXZOF8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AemDC36ySkQiT7aPHsLSryfhPifc2Y37butVC0qBzPyEeRka0Ch151hf277rfjO+6BfA/aIDTLjh0181YzNWujxBgG2SQ3VDmPttdp1eAfMflMQJBMJFKprIT6Onm2Sz81EK7wiS4cke2tdHgU6JK+5wpbqeFEW+LzgZ1VTDjAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ssZBJF1E; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ssZBJF1E"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-54afb5fcebaso2189638e87.3
        for <linux-crypto@vger.kernel.org>; Fri, 28 Mar 2025 00:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743147857; x=1743752657; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kGnDRXAGG98eVElkSPXbq2Nc5ZK4mxpr5pnNPqwv2lI=;
        b=ssZBJF1EQz81fXuI8alFRWFVcRHS6eG/xx3UJNI9JN82hoVScPPmD9g+veikgnGdMB
         zKW3CkaZRaEhkj1N1h/tuhI4bEonqxaIiAh5zm1HneNC8poIRmG8+oMRSPsBAPlIRw2I
         M2uNv+uw/GEJxBfkOTiiqhzXpV/nstxe6GqjsPQgjbWGpwF5q0LG6Lw4eCeg/DcIrxfq
         w2sx/l5/S7tgOlD5RyxDmXOPKQ5knvmgcrEKnGMzlgfvIihpMmX6BMIoe/eniOEiRYmz
         81cJjA0dFbwAAYPplwjFXhM4JaZ9H2fJtjmIxf8LYVU6IHcRahb3PeW68QgCHuMpIfFs
         0Rxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743147857; x=1743752657;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kGnDRXAGG98eVElkSPXbq2Nc5ZK4mxpr5pnNPqwv2lI=;
        b=mv8Jl/5jfH7GEnGFHmIlJ7m0TcuLsiQRhBasOuKLNAwFAjllnPeZL7hxAXPeGa04tK
         VWIVA/TK4PPv1n6NQ7tVx0ScD9S7hBlyaz+XRHB1O6HR1HsGbJ/iVAb5+2G735P5XaBQ
         XH77JwftdrhHg/DhX0y1C04v66GLLnlQcL3plhy+JXhEcQkzSuYjLt1YcI2mmh51IMI1
         yIlzqh/seCCikvQoFcHalvIftVyWbRg8MmQ6NY/VqzglKU3F3zHmwwI+9Q5Xgi3CKQMb
         e6xDeAy8/+jtZ54V34Wzq3YRYh0aZrJqX/0PUpvVoxajTroHfNJkSihU9nH5OCRDdUza
         H9bg==
X-Forwarded-Encrypted: i=1; AJvYcCV3TwSdRCV7oJ+JwZCOOYAj4DNEjPiqjkAjwiGSSCZqlePhYuPYpyTmG0kVEnxubi2Y+k82SCQ/8P/TQyk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9wSEUdlbKkjXueSfb7wtStLChk9KnZROhfHSUvPCcArEc2mM1
	WugQnXdR6Z1uvBv8j4NrAO6SRy+mPeSyiqy8uamb3tZftmeeq9+cQ4lYGcZpZZE=
X-Gm-Gg: ASbGncuPXa5UXLHBJnsHj6kS96SnbaKBPTgb4XWPc3J6F9jMPYvtc/s166ArkvaN+Ee
	hE3xa7DraPjUnk3aRqwWHEFLXcTbkr2pSG5lJq+kpFNkkqChVs1h89M+5mk6Hu76ytphLJhKVDm
	yxEO6Ia5JAMhBV8Z5MtacWQluUXLq58n00H9oKMTpdoPAsd/OhEVjPqY5Ke+VmNtI17NSOrTHTt
	LQDj4KOsIj3CrDx9XrSknQF/tgD1Qk+IO2t/oOG39ff17PIqICnpWXk4e1nQwVh33uCD8TRxOBE
	R+jnpWdm8ylPXR2OpELAAj66ySvVRskV0x0wwOdJkONwijrLk3aCOwM=
X-Google-Smtp-Source: AGHT+IGIG3vCUNQ5N3JhklA22up77ViQKE2bk7SUD1+1D+haElLf4Xv+3Q6z3mgezL384pMZBiBsfg==
X-Received: by 2002:a05:6512:104f:b0:545:2c2c:5802 with SMTP id 2adb3069b0e04-54b0126a6demr2911529e87.48.1743147857220;
        Fri, 28 Mar 2025 00:44:17 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54b094bb32esm215589e87.26.2025.03.28.00.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 00:44:16 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Date: Fri, 28 Mar 2025 08:43:59 +0100
Subject: [PATCH 09/12] ARM64: dts: bcm4908: Add BCMBCA peripherals
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250328-bcmbca-peripherals-arm-v1-9-e4e515dc9b8c@linaro.org>
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
2.48.1

