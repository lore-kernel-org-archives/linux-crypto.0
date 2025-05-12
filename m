Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C617292932
	for <linux-crypto@vger.kernel.org>; Mon, 12 May 2025 12:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747051558; cv=none; b=NAHY94ptkDoRcy6oVhnerGdW6y4jEUmjfyfu/JPYiWzkWsBYNxhWVLiNbzqP/UjmKvynt7QphvrIrWMz9zcS7z2L6FWPkS+Rlg5dea0BTbk8Joer3qUP/GxHqLUhU2HYdSv5HpYuv190YRoqu+7+H1vesXfNWIPXghUiMfxbNbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747051558; c=relaxed/simple;
	bh=fX35407DGM9sCZxTOq78dYnEd4V42rGAm0XPIvfpasU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=V97O0k/dfVNLIylENiIJaoVbQJLkqRrKQfIufXegG9FyYybmgp9JycvWaISvXEQL7uKpITuyCTqx0XzUxK4vbtP1X2HzqRT5/oQOzsn+oTBWf/RaKtvpnQmwIMSvOCg21W3Ue0e8+HnV/C577Q0XrxVaRQOJ3+HHaJKXX/UNHGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yiEjFc0y; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yiEjFc0y"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-54ea69e9352so5794972e87.2
        for <linux-crypto@vger.kernel.org>; Mon, 12 May 2025 05:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747051554; x=1747656354; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eMW8ZYmbAyYveksUpaECxL5x4y2TvNw5k0vzt9tGwik=;
        b=yiEjFc0yctOo1esm3FP33yMREoJws1ZvUuYbG2tZU0ZbI39qqzVJddM/5tastfP1/w
         WR2DdqGP3KCLhCkvZ66IqzybdMDDC4Gx6ntu2LMYZBQOsnRFrOYTOlIAW0BonmOXrZ6a
         kD8e731nquRNhCWvn2UoRAvgGdWeTwstwGv9+KjrFr8ofJmQxv2zOuNxsA+0NyiVQB1h
         fmb5G8ntHkAbvUNLe0T81GwOgSx/9zCmW+sJcw3cr5UnQff0To8tQoQQelCk8Ac+TTLQ
         PFfo4WDLU2w242ONpure2kaGEIx4RqdgR8EajJu+dsKXcPZfEjUVAaYp3a2h7uMB162W
         Gudw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747051554; x=1747656354;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eMW8ZYmbAyYveksUpaECxL5x4y2TvNw5k0vzt9tGwik=;
        b=P9+/SokbGcytC5Z/ggUi+wLLYjAFDbFzT6649IvAERSlZvEj3X3NwKx1h+4JzI2UGP
         y16ExzF5cS9NYE4LJ+FRibFwqnsbJzyOKXT1OjaagMqAMpnHmJyPq7b+unNGC5THKqPI
         J+ICBNzUpcYZqdR64GgmjhT216ZYUDHtNaQf4E6NUM0uWOjxKZ7hw+JNpSY4XSsLPoxB
         87FDztLpJ5aU0oAUw5vXtg3jyutZLEB7jA2B80KJESMcEhkKiRybIjmwf373o78mm+bR
         zTJyilR9mCmSEVjhLtXdsqI7TaXKObr/hvitXaZRRmDpP/616lOA1ckgh2I9ZPnSN66C
         C67w==
X-Forwarded-Encrypted: i=1; AJvYcCVWKOSNPcuAWGh5W1aSoLkAYYj2yfLN9AJE40twuYSy45p10L+7Y0DhgpfCfSqEmi3xRF9FMNknlvV+iHQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4nJdxcQG/4A6npsPUiVta7JcjWJiqc49Gb8F9UsqqC1jv5r5o
	VQCkGiK/id6Tz96XUJv0dYJrTEVsBwgdNJKr8j4QY0aK+VZud7mOg+MhEPg0gLXoapFKjiJU+Lh
	Z
X-Gm-Gg: ASbGncten5T6nquyXENXmCTwaKQkjGZ5RcCs62AR5RFPzn9q8rXEH5gJa3yZIQC7xX2
	1+t3HwCrN+wcOZSdg92YHCBESNE8IIeavOt9vaa5Hy/sgWFkVf0UuQtrmJO3N+AYW/EtzcdZges
	rVm23BaN2HAianlfFo6tpKnOf7YCTzyGSggJYe89GQSKePmZ64p6ZzWmm6kjyjWQ+lpZo+IpIsA
	tHuy3KmkJrHX0WsRT9Pg2XdbWtWONafnAsVIRz4QhK8D7+EOl/16td1erQ6DyfAeG/VhxZjkkiL
	Bv4+c6SW8SPgJBeDMV4qv9QCM4z6lf0Bn3OGCH/bjl+0MswXTlArz8RWgmm/5w==
X-Google-Smtp-Source: AGHT+IHxb2O+hRExT7wJM0hdL0T4Go9j50fqYlAT256TZUreuKCMSBufTsDqXxN7OMd7gcH+p4r4lg==
X-Received: by 2002:a05:6512:228b:b0:545:2b68:936e with SMTP id 2adb3069b0e04-54fc67c8ed5mr3411723e87.25.1747051554236;
        Mon, 12 May 2025 05:05:54 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54fc64bf8a3sm1466033e87.189.2025.05.12.05.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 05:05:53 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 12 May 2025 14:05:49 +0200
Subject: [PATCH v3 03/12] ARM: dts: bcm6846: Add interrupt to RNG
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250512-bcmbca-peripherals-arm-v3-3-86f97ab4326f@linaro.org>
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

The r200 RNG has an interrupt so let's add it.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/boot/dts/broadcom/bcm6846.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/broadcom/bcm6846.dtsi b/arch/arm/boot/dts/broadcom/bcm6846.dtsi
index e0e06af3fe891df3c3d8c2005cf1980d33a7762b..f5591a45d2e4ad64d8f95680aea327771825252b 100644
--- a/arch/arm/boot/dts/broadcom/bcm6846.dtsi
+++ b/arch/arm/boot/dts/broadcom/bcm6846.dtsi
@@ -196,6 +196,7 @@ uart0: serial@640 {
 		rng@b80 {
 			compatible = "brcm,iproc-rng200";
 			reg = <0xb80 0x28>;
+			interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
 		};
 
 		leds: led-controller@800 {

-- 
2.49.0

