Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9866211A05
	for <linux-crypto@vger.kernel.org>; Fri, 28 Mar 2025 07:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743147859; cv=none; b=NE0whOvcqVolB9+I39zJqyHnbveEXTnhMPr0sEGR7T3Se3J8v0tHI0D5/HuPoD/7erNVMTvxwAKjBu1AmO8rNe5jEQMD7hACCbwLXy+gdDQSNugMKEsdEAPJ16Rx3rqLfPuxsbAwVW5Px2jJ3l9yyN+aN7wK0GfvEArRyq/nE5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743147859; c=relaxed/simple;
	bh=zlPnLDOVNhN6779M2tqjANdGgeVb1jdCNr4N0cOKy6M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fTjNUZ0sTPBK+GDYIsga2GMOmVvK1q5yrrI3h9scX2BfuKbis9uQItVyGrmoccNRR81Qd7PtZd3HKWYe/FgecwXgFJ+zuLnCrwFV7fOYHeE3jjUm/s5JoaADMLT7IYmEnviyGPN9ZbfHgKzSBFkdTrSj62UZ6VxW7n+X2qhPRS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=s9kqtjzR; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="s9kqtjzR"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5495c1e1b63so2117777e87.0
        for <linux-crypto@vger.kernel.org>; Fri, 28 Mar 2025 00:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743147854; x=1743752654; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cxJsf8FE0MuuxFa/Fkir6Q9pPJ5F0EO+7sE3OSG544w=;
        b=s9kqtjzRxktPkhLlsc0zqWFR3BjjkQ/Y3r3Wm75viqJFjkj9BmMAD89gp2jAR5kCNW
         BL5OPRct5LPgyzb1JuNLeYztFUcOWPZmax4RxJywZNrps6wQfzmarKDNHv3/v7ePf/Br
         OqC1T2Ddsc5PDz1i6cY9jWtb/j0A4VGvlrje40ElJS4U0jg8S1qLrhbTBhKJFz2pzpIz
         AbmsjagoyQkRmnlS7MI+kQ03+gBfbTYXHvZSXFrZJ+RWjWieM6aU12IqYG0EfSRnxeL1
         D5QL49v4l+URPCphsEmrpdLZbrJQeaoT4J/D/ro0WIcmi+wB9EauS/kf2lq9buILoT+C
         4Sbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743147854; x=1743752654;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cxJsf8FE0MuuxFa/Fkir6Q9pPJ5F0EO+7sE3OSG544w=;
        b=tZ2+diHE3z2P4k2vnuzt7VRcd3caarjIldQD5R7kXjfsQ9DGgLEKlVbx6pbG3Jx103
         3vSprFTI7W8T12ZuMrpZmDaWUehkh4tqLLn0R3SH2DVigOAJneF/snWCrUhcurgKVUPf
         68HfARzWyXLU6IAPYNQ5tVTm5l+ol/QDXNGTc4B1ylBPnTETgdCs3QPcVf+oCkIcqZQ/
         +FkXW1WZj64BY3Fi5uRezb1dqlX/h0JGBYAaj1LOLL998iUSmmp2n38De+q8redeVInQ
         VOpQSHcUBAdJbHQTEimNJYbP8/vNju4b8yb5NsZ6w1cykHB/Trz8JZVqLT2D+N8VMXNb
         LLUA==
X-Forwarded-Encrypted: i=1; AJvYcCUp2+oxbK1ZydGt6yMAtvsLSCRqulhXNc/+Ex8ZpokAb9EOz8CxhNAvXHlrGD/L4BuvNSdRCq87/IbL3gk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmYcnFJtlZWLIKeAX4fcFOPtUczVX9Oazy1kv9Lovlp008EOus
	7x13T3GryV303gyBYOnYfRXGimTV6tUQrjwZf5n/uGo3Lixe0OSPvvRwIfEjEhU=
X-Gm-Gg: ASbGncsf3x7j90PICPk/s5yTfPbeShonhhEmHEOlpN2CpApLUm8mKXQQd8lW34QhOnZ
	j7IV3kyPffOK2iAeUoMchGDKtX0hdpxYFmJHNVRQ4coI89rM7gbJe6RpkLrAr3A4PJ1E6oF/Do4
	27ExoAiZL3XerfI5jRKwOajvAmVQdv2XaIEZe5Z/GbIHTou8UCwpjOBwzc9gCWobfSUpzSoQuvH
	FYcjLt1AgRQJYk5gRg5e0RCrXcAgvdKaC86gsmMoSnT0kgScMZGpARaJWaGNu8mZklvxmp72CjQ
	Qv5t3F5rg4uTuhkn0T5AEd9t3ONYLwBIJQOm69DaIGgPji9ZWQIXXKc=
X-Google-Smtp-Source: AGHT+IHSoffSWfcJMRGuGw6L4wY74EAeuWbkQZylOYsn5uGLkfOegEfRmQeY8GK/mlQStmMGQIfdWQ==
X-Received: by 2002:a05:6512:3e0a:b0:545:bb6:8e41 with SMTP id 2adb3069b0e04-54b0127873fmr2753525e87.52.1743147853995;
        Fri, 28 Mar 2025 00:44:13 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54b094bb32esm215589e87.26.2025.03.28.00.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 00:44:13 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Date: Fri, 28 Mar 2025 08:43:57 +0100
Subject: [PATCH 07/12] ARM: dts: bcm63148: Add BCMBCA peripherals
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250328-bcmbca-peripherals-arm-v1-7-e4e515dc9b8c@linaro.org>
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

Add the GPIO, RNG and LED and DMA blocks for the
BCM63148 based on the vendor files 63148_map_part.h and
63148_intr.h from the "bcmopen-consumer" code drop.

This SoC has up to 160 possible GPIOs due to having 5
registers with 32 GPIOs in each available.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/boot/dts/broadcom/bcm63148.dtsi | 64 ++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/arch/arm/boot/dts/broadcom/bcm63148.dtsi b/arch/arm/boot/dts/broadcom/bcm63148.dtsi
index 53703827ee3fe58ead1dbe70536d7293ad842d0c..0f6232f0553ad62fbaa7d8db251a0204ed6ed782 100644
--- a/arch/arm/boot/dts/broadcom/bcm63148.dtsi
+++ b/arch/arm/boot/dts/broadcom/bcm63148.dtsi
@@ -99,6 +99,62 @@ bus@ff800000 {
 		#size-cells = <1>;
 		ranges = <0 0xfffe8000 0x8000>;
 
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
 		uart0: serial@600 {
 			compatible = "brcm,bcm6345-uart";
 			reg = <0x600 0x20>;
@@ -108,6 +164,14 @@ uart0: serial@600 {
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

-- 
2.48.1

