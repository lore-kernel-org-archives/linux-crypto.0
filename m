Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43E6211A33
	for <linux-crypto@vger.kernel.org>; Fri, 28 Mar 2025 07:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743147848; cv=none; b=YfWcqSBgPPWZUloFLzeazN9zqEc78paX9PD4eFCnf6wu+nonLe4/yrHWArdKoO75t6MzXxPxu7aBny85lVV0hOB4TKjFipXd9uBGkGEeEZNtcjp33TPoa7e1khnoV5vydWFeAqvjkP2ZsCYRvqr9sxKrZMoaZ1m3BLLMKhvRPco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743147848; c=relaxed/simple;
	bh=xU4upV0EA41eAPdxIY10JZKK8Lais+D10/cnQHoag4w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bVH0qvfzD3pwVdfuI6plWyXbQW++onwpPm7ICuJNur29yXyjzqe9DeGI6TXTl+leHthZ0gYNy+sxNG5qhSL2vl+vVYvD0SZiNwTe4VM+BKu6pJ1IxcgsRwsMcSNJFOSypivrl2XNE+PhTGqNKy2jJZ729JY39KQV7Obl5OdxhS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HIiU02pZ; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HIiU02pZ"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-54acc04516fso1799970e87.0
        for <linux-crypto@vger.kernel.org>; Fri, 28 Mar 2025 00:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743147845; x=1743752645; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H0VhS/v22NU8eHmN3wX2UOpbzS0x/EJicz5QW5NMbiE=;
        b=HIiU02pZ+QXjps13hil9nLUsb3JhTqSnU5G82a0cSS+l3qAOmMuD8/HYwpTVeRwe8L
         9WoZV7ucp7IXqYqgCHFvsZCZgA3+L1NnMSvhVHFcoSkYgSs7N2CU5CS0cErfzG3+BKZH
         dvWV1BHwI4ZLzYzojr5J7CDPMiaKjgMU8JLM4xDJHJJKcW9FHEcNZrs6sv1LOaHqkLwX
         B5F3T0IfoeA1AqyzdaDyCREwL9IECL8ct7RUm8LJRGc+vztnqUCHwK0qgeHxan5ZIYTm
         uG/3zzR9lcMpMZNaRPizQ4V+l38Vqq2hQgnVBlHWmMudSw28wyQ3Wi3PbD1XI4iqKPoP
         g3/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743147845; x=1743752645;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H0VhS/v22NU8eHmN3wX2UOpbzS0x/EJicz5QW5NMbiE=;
        b=RLj0RD7O+nxZJinyfzCLltrdiEaXL9TQdMNgORLlAq7fRK7TkvH5emwiX27m2xpcAJ
         87neLznz1uX4HSPYzbGJV47EUIaxyMX7L6v7HTkQuN7Bwhtj98AZXTkULywwGlJUIyq7
         s81Dlw1RHYk+51J3oGiCBUawQbNb8xSOPRhlqimbqF0QbrVVhcwT+8H6I9jKKpH5l8zG
         +KMrDdxE1r1kF57t0ToKq0UyzppXWVwTsK4n/8BfrqgOUrvJJsoCk0sb+njDXWi73lF8
         z56ag2Rt/e3j4p1JE+pahbVRY5CtvYWqsV10lDOgDgiqnhd/Fx0Vz8LHhxKlq8pXsx/1
         crFQ==
X-Forwarded-Encrypted: i=1; AJvYcCUSti5UMbFhQ/uLt3AFRyfKZs9XspNOywsG14JbGJIjHFsku2BmkXtWKl1y+ZJ44tEnmhWApKmUUVsSDco=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8c18KGy8EcsgR4LUsQdhnzfh3EzVFBLvbsZFMfzA9rrkd7orB
	eeUAr+iYXN8pioUWlYksbW1vyY1gFxV8K0Z2uxiT/do2w6rFK7anYW0Pd4CeF4I=
X-Gm-Gg: ASbGnctTw5AxYaEa5ZhFLKHY7Gf7N4JGW6DKMPzqTW591JlcorCQ+Di/yudPBtgqpp5
	DmhYjKFokCHxSM4TYVRNVCRrX1ceZxKFGGsmrMC1/lmEccxwkj1IgAdv5CKgcY3ys1Xa8tYS+qC
	s4/eja8TwdC9GaNRfsaRTu88dVSbXyQ6+xtYUA4QgT8P+r2bVn+NYb6q0YpevVbaqKYNtkNz2Kn
	MDkdNg07BVfO511j9AE3j4CXnThaW/LdgdVw7wt34mIXrM/D3QG6aZYOQvMcJ/5IPpP2s4PwI0r
	birxnmmBrSB0y6F66i2TWhz14B8L0lGaBWUnPZi/FshvTVarxVsCESb7UCkRvzH6bQ==
X-Google-Smtp-Source: AGHT+IFqexEpUV8AIrXmhig8TO6o/adeivq1AYJStXwRnF5UkTeMDdMVIJ/YWHWaksBob2pUlYpnUA==
X-Received: by 2002:a05:6512:10c4:b0:545:60b:f381 with SMTP id 2adb3069b0e04-54b011dceb2mr1996778e87.29.1743147844697;
        Fri, 28 Mar 2025 00:44:04 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54b094bb32esm215589e87.26.2025.03.28.00.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 00:44:03 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Date: Fri, 28 Mar 2025 08:43:51 +0100
Subject: [PATCH 01/12] ARM: dts: bcm6878: Correct UART0 IRQ number
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250328-bcmbca-peripherals-arm-v1-1-e4e515dc9b8c@linaro.org>
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

According to the vendor file 6878_intr.h the UART0 has IRQ
28, not 32.

Assuming this is a copy-and-paste error.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/boot/dts/broadcom/bcm6878.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/broadcom/bcm6878.dtsi b/arch/arm/boot/dts/broadcom/bcm6878.dtsi
index 70cf23a65fdb5ac7ed9eabc986f4ebb4df263c43..cf378970db08c05c40564a38931417a7be759532 100644
--- a/arch/arm/boot/dts/broadcom/bcm6878.dtsi
+++ b/arch/arm/boot/dts/broadcom/bcm6878.dtsi
@@ -137,7 +137,7 @@ nandcs: nand@0 {
 		uart0: serial@12000 {
 			compatible = "arm,pl011", "arm,primecell";
 			reg = <0x12000 0x1000>;
-			interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 28 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&uart_clk>, <&uart_clk>;
 			clock-names = "uartclk", "apb_pclk";
 			status = "disabled";

-- 
2.48.1

