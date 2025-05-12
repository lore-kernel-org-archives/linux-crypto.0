Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7AB29293D
	for <linux-crypto@vger.kernel.org>; Mon, 12 May 2025 12:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747051564; cv=none; b=ZhGUBlkKjzc6Ms93ueMIKOVr/oaxDvhdQO6Q+Rlln1SuSWVNqPTX1ccWt2UJvf0PjS2Axu/a36NBRBFBYl3uUYGUpTkdHGnhjDtEk21TUyBVHEXq3miumVWaMaESEhLdD2F4LYBegqx7TkYHbC4HsRDyiYcJ92gO3WoAkmmOhPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747051564; c=relaxed/simple;
	bh=iNvTgILnCEUuGyGVf2KAQalCWhryAWAdjzGVCQRI9V4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KGaGm88kPoNoAMLkn6t1KXoindk3YOhEsz8j2DGNxSlQAOBS+03HIuzXe+t11e5lCN4E7zIrRtYMqQF5Ks9t2ZBTQ8e4VM+ssMdnJuHkOzwst8TUpPVmQ+43PlLRRHtwPtgKojOzfDqLfuyW5ZtRrMRFs1HzLdoZdP5SCsM3iek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wKjYsaAO; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wKjYsaAO"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-54d3ee30af1so4383991e87.0
        for <linux-crypto@vger.kernel.org>; Mon, 12 May 2025 05:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747051560; x=1747656360; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=13/MDnqvilhzElhCywJcKpSZ25QUsLbrCE4P0TR4EUU=;
        b=wKjYsaAOT4Y0dUmaj1VuK9y9gVipWpyNb7O9BChkFszMZGoy7ZZTRJrBtOJ0p3UU4z
         w78GxqEU6X3ymVy51OZCkLSinoOiV8kVSg6pAYXNPyIqgBJEjDZQ7LhnNpE/AceifMRc
         iG9KqNPN0aK5txJhWr6r/Twa7ZsKcF8e3Ce2vQc6Ll+0q36Z2OqSYaLOenSpL3sOM2KC
         F5xZeVqJS3wNuPe3jMttkO1xX0aS3rMbcJrWsvytzm5Hag55d/hTv7aM/tBevvbVgxH5
         R0a6FNU2rFP+vrAyZqX3GE6I4a/CiJ1XlYYcTka8KKhgzvWbPCSx22b2dHWWYLEsdfIW
         ZB3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747051560; x=1747656360;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=13/MDnqvilhzElhCywJcKpSZ25QUsLbrCE4P0TR4EUU=;
        b=XUzL6S+66JpqSZK1/7/08s/MVFe3FieV+4ejp885Ith31f0TdMqcN+RniOajzthidc
         9pymgoANb55DjCeWq7vBl/2g4qLdB2mHEHTwjUWKHbfzGYWKFvWkMhs72G1uFRFjoUaS
         uV+rURYQCX1P6kTlYbHkEWddSrrlfP5RbouAhhhJv7xg/bRzsciw3ZoOoGBbByxCQyCb
         zs33YQByIEfL3MykbUzsBdA41SbxGlzei+6BZuME4du5Oxez8uQbqPrEV9Xy1g9fLWYe
         pRN+OsieJZUJIq4cW/v5BEudbE0EjUykWxP+Gv5LGk9yDKvNRB6FlQmIwh9e1ZYKJ9rj
         eGXQ==
X-Forwarded-Encrypted: i=1; AJvYcCVkUxHgkfk7BqZcxRfzVEE9uCnOyVrLGuIb8rsYj6Mg6QAnaFWEstpT3r6xXL3N0er5eOS/p+tkd+1B5Uw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMcGeEibH1XWBpjT6H56DoU7G8nsuaWliyoK4kbeHUZHxhZPg2
	+oCP6fvnz3Ak6R0QN/SYxiHO7vWFBIEE7ik2Z+LJCNAllkKb2zeYfrwP1oDYUXdLpx0yOcSY6Wt
	w
X-Gm-Gg: ASbGncvqZbu4YY7xoPtIk7rZhpu1t/1XS9iwBq12X7yxTNSlgexgi/Sj4ZEYnyWizoK
	IRSsBm9/EKnsIzAQlF0OArLDvECc6zHXdV5D4M0dRSyogxCdkMs34aLfZ/fJnT5CutCvqu4F+S5
	IwXSjUWs94JzAXnn3iLDVpuTDKtkkQlJkFGCjMKxYGFaRdjjWgn3VO8RFwR/eZTRGHuhSqtoYoO
	jf6rg2O3+Wj5tk0FpoVonwEuWk7gWrGvwdK3oXGXrp3Ralg7N2JRQ5GFdbfHZ0t51z1lworxJIt
	j9PULNC1mk+7qqURp9genMZ13bJFGk9fgnuEW3elp5avoHsTwaRWvUK2pj9qeQ==
X-Google-Smtp-Source: AGHT+IFzh/yJYzxWy00yNIwvV6Uts3H5TcOvRtw6gs/HO6e30umcHnBY9xrWmL0juAaZeBMLvfWD/Q==
X-Received: by 2002:a05:6512:3088:b0:549:8c86:9bf6 with SMTP id 2adb3069b0e04-54fc67e61a5mr4220105e87.39.1747051559621;
        Mon, 12 May 2025 05:05:59 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54fc64bf8a3sm1466033e87.189.2025.05.12.05.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 05:05:59 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 12 May 2025 14:05:53 +0200
Subject: [PATCH v3 07/12] ARM: dts: bcm63148: Add BCMBCA peripherals
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250512-bcmbca-peripherals-arm-v3-7-86f97ab4326f@linaro.org>
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
index 53703827ee3fe58ead1dbe70536d7293ad842d0c..e071cddb28fc2888b8f408b4bc275290dd135642 100644
--- a/arch/arm/boot/dts/broadcom/bcm63148.dtsi
+++ b/arch/arm/boot/dts/broadcom/bcm63148.dtsi
@@ -99,6 +99,62 @@ bus@ff800000 {
 		#size-cells = <1>;
 		ranges = <0 0xfffe8000 0x8000>;
 
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
2.49.0

