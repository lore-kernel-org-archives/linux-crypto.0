Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C399D211A05
	for <linux-crypto@vger.kernel.org>; Fri, 28 Mar 2025 07:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743147856; cv=none; b=RJLpCm+NpCAWl2TlhJGSS9C2DC4fuip+vJPdw/w2g7dzsSKTypuBsdqcMiIq2ZoGckWi3jcKJhZ7IORhX2qi7u3p8Ckf38IXsQJOesVbg+xQGRi3bRVFUtKmYowvFRtjbdvSxb1pFKqyb5mRsRFqD7m8NJc496zfMOTnZwEc8vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743147856; c=relaxed/simple;
	bh=o3PlYmFlCAOBTPSLVx/uVOa281qBIQqRgdUQskbmtUw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Y6KO30TxST2uQm00c1zH83lTtlFpX8W6Jy238KtHjL7t2hd8UMWQ4UZNgkt7a3v8Wib1dYIfeGW2m7fQqZqS0NG6E2ByUYlVoMqhiB8QSS+5h3UMsbGJM2AwCVuLycqfRN43z71SpUw73lQFC7pY8Rlifre+q6cSuNXrdNgjiXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=X90hg5Le; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="X90hg5Le"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5499c5d9691so1934896e87.2
        for <linux-crypto@vger.kernel.org>; Fri, 28 Mar 2025 00:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743147853; x=1743752653; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jUAEmJN1kVT6sqNjgFjTIi54896X7oEqtHP0xbwjDaA=;
        b=X90hg5LeScd2/dpF0ndezOa1oTfJwRXIKQtwDJhYXmik6zENSGpyUczwnwZpk7vLKo
         ZqQ/Y+Ulb0pr8Af8I76ld9vCdf6hIJz/D0WAg7NhdCxW/1y9Bnl1xQzx5ixMXMa9v1CH
         GWoUDnjuXP+Cj5OA3xbBe35EzoHjQt9CI3zZbZ6g80Y91zby0tUvXh6lFWP1yyH2WnDv
         vW7SJI99yMooPZ4xWNtfaibzBQzrqumwGS3qtfUCJUjvjp5gN/qHQyEXsuIGmbEtBK2y
         qevXlyCz08d9qV3NJdjh+CEbdrobkTIOjQyyihoEnCf0pNJ4QxGIXIcSfNVWJf9rSjkh
         NOIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743147853; x=1743752653;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jUAEmJN1kVT6sqNjgFjTIi54896X7oEqtHP0xbwjDaA=;
        b=YT2T8kYz13UOGUW6HteSJ7t8lfZSNkQjhk5maTJLa4t9Y+yEUYKnLBGPqOVL495dDs
         tP/Yohz8NyR3E04Ud/V6z0pxbnqjo8hpfX/p/s4csWH2l/n+a8UVGe7Y79B27RFEb3lM
         +9WZe8VIO5+jggM4L+3exWCCjFPptZ9D57pfF4r7ZBViSj8QE1dQDnM414iq3RhFMX33
         9HlI+cX7VF5yIXmMpaD4is+V59kKEtg7+DDIMAo/vAEoiTqDtQ1p6kLh+nCCWbQG13NA
         Z1oyez/FpLG3J573UEi6N4VciKwSvQjnGo2SB8rh9KJOkhLW1OqzpRcTfqb+H6dX31Ly
         rw5w==
X-Forwarded-Encrypted: i=1; AJvYcCW42ENDZZNVnBexjZcU18O90VRXhuw7AcD6tYdwLUMdjJxTqLDajPoo3Pk8tBH9KMu2zSPKhiEiJHe7KxA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyanK+oA+NHmDBGXA3sXOo0yIwdyKDQZPnCNq2MPNIqqJaE3ofW
	8HD2ZjW9omLXaXzmNp5R6M59Y58jcYSlG3edARnk9UMapfCdvdtlzQ9xXxA2Wtw=
X-Gm-Gg: ASbGnctdnZ4X5h0HXaT9KB9b8/UF6s79Fggo0BMXgsfu9c21P0/H50FvUCyTexxhYHE
	QcePJjDEzmpAEBVFlglvh03WCW0KhFlrF6q+kLhb0vEr3Q171Oc71pmCMRa1MZlCJ7Np7hyxJLT
	7gPC0FAPNRgfOzzxy0iGkyWpomMPPnoKPz+zL4oqO3YHrORfD6JaNdp1LuqYy2XC21LPEGYv53M
	SBNMK8zs3C0LzEEe690ZAFAU1C7B62fFndMMq5IawfNz0JKGt2gVQb/wybsEfNcDCESjqxpy3sL
	9DsMNUliUpe79xtVcL7dm7xwlHBGtA0faQsdfwAWshYsPgbAuMtOesA=
X-Google-Smtp-Source: AGHT+IFL1i4v/eWOzjyE6pr2XfQNO7EGVzKr09ZBgd139s8iEDfYFiur9MgF1dlZFkJRtcV0d94NRw==
X-Received: by 2002:ac2:4e16:0:b0:549:5b54:2c5b with SMTP id 2adb3069b0e04-54b011dd0a0mr2804182e87.24.1743147852919;
        Fri, 28 Mar 2025 00:44:12 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54b094bb32esm215589e87.26.2025.03.28.00.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 00:44:11 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Date: Fri, 28 Mar 2025 08:43:56 +0100
Subject: [PATCH 06/12] ARM: dts: bcm63138: Add BCMBCA peripherals
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250328-bcmbca-peripherals-arm-v1-6-e4e515dc9b8c@linaro.org>
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
index e74ba6bf370da63d3c115e38b4f20c71baff2116..182394a96bd46eb0258ebfa6d5f00ea008aa671c 100644
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
+			reg = <0x500 0x04>, <0x514 0x04>;
+			reg-names = "dirout", "dat";
+			gpio-controller;
+			#gpio-cells = <2>;
+			status = "disabled";
+		};
+
+		/* GPIOs 32 .. 63 */
+		gpio1: gpio@504 {
+			compatible = "brcm,bcm6345-gpio";
+			reg = <0x504 0x04>, <0x518 0x04>;
+			reg-names = "dirout", "dat";
+			gpio-controller;
+			#gpio-cells = <2>;
+			status = "disabled";
+		};
+
+		/* GPIOs 64 .. 95 */
+		gpio2: gpio@508 {
+			compatible = "brcm,bcm6345-gpio";
+			reg = <0x508 0x04>, <0x51c 0x04>;
+			reg-names = "dirout", "dat";
+			gpio-controller;
+			#gpio-cells = <2>;
+			status = "disabled";
+		};
+
+		/* GPIOs 96 .. 127 */
+		gpio3: gpio@50c {
+			compatible = "brcm,bcm6345-gpio";
+			reg = <0x50c 0x04>, <0x520 0x04>;
+			reg-names = "dirout", "dat";
+			gpio-controller;
+			#gpio-cells = <2>;
+			status = "disabled";
+		};
+
+		/* GPIOs 128 .. 159 */
+		gpio4: gpio@510 {
+			compatible = "brcm,bcm6345-gpio";
+			reg = <0x510 0x04>, <0x524 0x04>;
+			reg-names = "dirout", "dat";
+			gpio-controller;
+			#gpio-cells = <2>;
+			status = "disabled";
+		};
+
+		rng@300 {
+			compatible = "brcm,iproc-rng200";
+			reg = <0x300 0x28>;
+			interrupts = <GIC_SPI 21 IRQ_TYPE_LEVEL_HIGH>;
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
2.48.1

