Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBEF0293746
	for <linux-crypto@vger.kernel.org>; Mon, 12 May 2025 12:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747051562; cv=none; b=WqYiF1PV5Vxs7XH74+u/Pki9+RIOcfPyhxuYUeFjgzMY9qlqSntBs7Ui52hbfwpd+0STtmNrLFWrlQPsR2bP+Lnn6fdBuGlpTnfT1m3yu1dObWfUdqmyMdc3DrSvV3DRdz3VWB5QESb9mg9xUim5OE+WWx64GaaYN9+kHA3m7zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747051562; c=relaxed/simple;
	bh=4bWaWkJdTEaXs9fYwJYdrqRwMIH+MjinXsdLRCjNiOs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WsyEAji9KHcQaKIIrvfR6qGpwnpkaSXfmDLf1Kj5OZFzwe0n3gdp0iVY/lnmC/bP5qAQaYk2r3IsTRzXeByo3gbJhG/86A+R1V/dOob513PT0xTNU2D4vS4NAO+iLGJv9oAMHDnJKeSP3CA0rfSIYO9yGUEdIgzJlQXJMwYopUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qQu91j96; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qQu91j96"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-54c0fa6d455so5254781e87.1
        for <linux-crypto@vger.kernel.org>; Mon, 12 May 2025 05:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747051558; x=1747656358; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Uqw+GjF+9qEiY0+j7o2mMDzIbpEBexjSYyH79EkvzYA=;
        b=qQu91j96qmOhjAe0M7S1d821KxHB4UVhWmHEVfw30XU1RYlLcnyuLRbfSSZw4am3zJ
         qtFt8M+S9Vf3EEG533xavyifxq5n4d4h9v9oXdrdhXkZzF1hGO1DHXgCU4Rd7djPyX2F
         jAIqc8E3ThD1ogwA7CUREP+vOka+Yc7JqYTnFKr3vUuuLGdEXcrjJFGPkbi4RXtQ0oRv
         vBiIHjrgn3poqtI8yiF6VuRIfeCxuiqDyAJFejvpFrIiiL24lm/2LxLw3XiwYm4iOOm6
         O4hXqbFSrLpXc0F3GCDBtfZTnb3IZBjJxloXfjkYyo9/EA6AC+yhhG4GWP56vCZcDQFh
         2aRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747051558; x=1747656358;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uqw+GjF+9qEiY0+j7o2mMDzIbpEBexjSYyH79EkvzYA=;
        b=pUmcLxPvIlrNyKQ7EZK4us2KHBDqziK2i2/3dHvAh7DLp7dRebTp36Febkv/hOwVUt
         dihpa0fbw782OC6ljIh5SHtLxnsZ0vWFd81Nr57YyhiCt728ekDtQ4h9rlSUxz0sOG0o
         wSBnWF7KVfV3HkCBLcmLRsIpojm/KLSmF55s9BAHl7rPnjkwoIjITvgD29SHnZPdFwCu
         r6Zq4PkIDlw8qayLiNDqwfNZqny5IYGMpk6FBTbffB174Xaet1jAMeJaLP8nW5w9RqGi
         BMIkSTIj2R55T4B0HMHTIV0eCWb/uLCkljx6XthSK8+BkTM76NFh6A8WBrFug3wEsK8k
         Fa4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUAeD4DE655TxiKAYsAfNZ9+1/3b/PvURiqy5zCAflwX8ptU1RpR3KzepBc5ykpByaCnnDPAhfGJllaE2U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrLZMCwjOa+lJeISR8MlLNhhjaEHAZzYHlYusQMx4vWbv14eQn
	CFs7HFFMWniBmQpE6xt9Vp1UpsIAG4Upga5rqsZ+0FT4HDKEbNdNgi7wwPv2D8EskeT4TjtjaTi
	S
X-Gm-Gg: ASbGnct5FgCPb8oDS4aEyw0/ykY6PLM7+5K5JR9MB7KEyyw4AF8RuUEFTOKSTflCuzF
	K0Tg8aRIdVmIh5+pcCbT0Elx0fb4COqhBaABiPRU9YvBrKEHx6L86FCNDLdZGNAAQudy1Zc1Uxk
	u3xZeaQ1Q4tF4pIhlZtiF/Rpyog/sWvFBjP1rLxSIdrSSTrjG1jE/lEKc62irTyjZ1b8mnhk1N4
	gnZA1I4UoX7LmcEvEXUoLcoQTd2eI7etOaz0oaHOq7XMSFn4SDb0j9nrPW0tUQLYnD7ZIRn/9Gp
	hZkHT59Ztdns+lvbM7bHKRrOebBb5IK6mULOuL/Bjmv95K9R1SKnyGR42fAtJS8xay1h9GWC
X-Google-Smtp-Source: AGHT+IHfwoROTwu8y7TH1PMx5xgHrbT3nnfG+S98Biusb0bw61ipKrcXYXN7U64BqA6qV90JyJTVEQ==
X-Received: by 2002:a05:6512:3ca9:b0:545:225d:6463 with SMTP id 2adb3069b0e04-54fc67d631cmr3718127e87.42.1747051558400;
        Mon, 12 May 2025 05:05:58 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54fc64bf8a3sm1466033e87.189.2025.05.12.05.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 05:05:57 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 12 May 2025 14:05:52 +0200
Subject: [PATCH v3 06/12] ARM: dts: bcm63138: Add BCMBCA peripherals
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250512-bcmbca-peripherals-arm-v3-6-86f97ab4326f@linaro.org>
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

Extend the peripheral interrupt window to 0x10000 as it need
to fit the DMA block.

Add the GPIO, RNG and LED and DMA blocks for the
BCM63138 based on the vendor files 63138_map_part.h and
63138_intr.h from the "bcmopen-consumer" code drop.

This SoC has up to 160 possible GPIOs due to having 5
registers with 32 GPIOs in each available.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/boot/dts/broadcom/bcm63138.dtsi | 79 +++++++++++++++++++++++++++++++-
 1 file changed, 78 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/broadcom/bcm63138.dtsi b/arch/arm/boot/dts/broadcom/bcm63138.dtsi
index e74ba6bf370da63d3c115e38b4f20c71baff2116..4ec568586b14c89daceddea8f17381f72f512a93 100644
--- a/arch/arm/boot/dts/broadcom/bcm63138.dtsi
+++ b/arch/arm/boot/dts/broadcom/bcm63138.dtsi
@@ -184,13 +184,69 @@ ubus@fffe8000 {
 		compatible = "simple-bus";
 		#address-cells = <1>;
 		#size-cells = <1>;
-		ranges = <0 0xfffe8000 0x8100>;
+		ranges = <0 0xfffe8000 0x10000>;
 
 		timer: timer@80 {
 			compatible = "brcm,bcm6328-timer", "syscon";
 			reg = <0x80 0x3c>;
 		};
 
+		/* GPIOs 0 .. 31 */
+		gpio0: gpio@100 {
+			compatible = "brcm,bcm6345-gpio";
+			reg = <0x100 0x04>, <0x114 0x04>;
+			reg-names = "dirout", "dat";
+			gpio-controller;
+			#gpio-cells = <2>;
+			status = "disabled";
+		};
+
+		/* GPIOs 32 .. 63 */
+		gpio1: gpio@104 {
+			compatible = "brcm,bcm6345-gpio";
+			reg = <0x104 0x04>, <0x118 0x04>;
+			reg-names = "dirout", "dat";
+			gpio-controller;
+			#gpio-cells = <2>;
+			status = "disabled";
+		};
+
+		/* GPIOs 64 .. 95 */
+		gpio2: gpio@108 {
+			compatible = "brcm,bcm6345-gpio";
+			reg = <0x108 0x04>, <0x11c 0x04>;
+			reg-names = "dirout", "dat";
+			gpio-controller;
+			#gpio-cells = <2>;
+			status = "disabled";
+		};
+
+		/* GPIOs 96 .. 127 */
+		gpio3: gpio@10c {
+			compatible = "brcm,bcm6345-gpio";
+			reg = <0x10c 0x04>, <0x120 0x04>;
+			reg-names = "dirout", "dat";
+			gpio-controller;
+			#gpio-cells = <2>;
+			status = "disabled";
+		};
+
+		/* GPIOs 128 .. 159 */
+		gpio4: gpio@110 {
+			compatible = "brcm,bcm6345-gpio";
+			reg = <0x110 0x04>, <0x124 0x04>;
+			reg-names = "dirout", "dat";
+			gpio-controller;
+			#gpio-cells = <2>;
+			status = "disabled";
+		};
+
+		rng@300 {
+			compatible = "brcm,iproc-rng200";
+			reg = <0x300 0x28>;
+			interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
+		};
+
 		serial0: serial@600 {
 			compatible = "brcm,bcm6345-uart";
 			reg = <0x600 0x1b>;
@@ -209,6 +265,14 @@ serial1: serial@620 {
 			status = "disabled";
 		};
 
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
@@ -248,6 +312,19 @@ bootlut: bootlut@8000 {
 			reg = <0x8000 0x50>;
 		};
 
+		pl081_dma: dma-controller@d000 {
+			compatible = "arm,pl081", "arm,primecell";
+			// The magic B105F00D info is missing
+			arm,primecell-periphid = <0x00041081>;
+			reg = <0xd000 0x1000>;
+			interrupts = <GIC_SPI 23 IRQ_TYPE_LEVEL_HIGH>;
+			memcpy-burst-size = <256>;
+			memcpy-bus-width = <32>;
+			clocks = <&periph_clk>;
+			clock-names = "apb_pclk";
+			#dma-cells = <2>;
+		};
+
 		reboot {
 			compatible = "syscon-reboot";
 			regmap = <&timer>;

-- 
2.49.0

