Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A8021146D
	for <linux-crypto@vger.kernel.org>; Fri, 28 Mar 2025 07:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743147852; cv=none; b=neu30I0MO7jEOGRiEtoB0sivQPmO9H4I4x8nORuzbkKiJSneaTRbGMG8Gpm7fBp/yyhcRIQY3/Zno6Jpr8RkehMHmU8FrIihC24w+aFyyGMMrErP1XnQAcaUuIDuF3ijGKPITnEETDSz+53UywHIY1hhDCFgvlU+jYelkEHt/fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743147852; c=relaxed/simple;
	bh=7JeZQS+D1n+0/R410HAKHsJwf40ODPGET4YSYKT9VP4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ee2BV96eP+bAumhaJS6l8fh9GW17oOF4kfvQvY9w4nWBOLr1yHhUCH2FiR0NIkssun/c1nitsvyz6B0w4hgQGBsqsI55yI+l/xCESHAhx1v6NvE7c+EOk1mePb0sQqxSfQpHDsPcpAM0NYc99VAy00fSTOy/UN6pWOLjp/dupoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wT6MA/Vn; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wT6MA/Vn"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5499c8fa0f3so1983934e87.2
        for <linux-crypto@vger.kernel.org>; Fri, 28 Mar 2025 00:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743147848; x=1743752648; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XEirBUBZll/2CNmNMKcH5j/pk8NKD9yNsuFDYjiUshY=;
        b=wT6MA/Vnf2Mz3HgoIxFDVWYRn6KAsgnspgh88XqhCbYUQobY7Q7z9eI98K4Yfotc1v
         Wap+r2AUuFZQhuOiyHlTd78+kbplZPSii/2EsyVflSSA5xV2c+1OyMXOLl2tiUtsUomq
         /vOxfMUFNpKbbIBRuYRTu5d56Qf3vYqXHtIC/YCsujVU4n9V9YGcMLkJNl37S8zR/cs3
         z2Qkv8hfJJcX6sHq3wKx1LyobYNLD/rG/fTriDiPXWN017VzNg9PIJ08GdHNAsfhRotI
         X1KqnhQ/P2zpewMxpriQS6qkBHBeuBh+FN13j4hIQxQ45dnbPrQcSyCriBPu5K8FuBAu
         dW0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743147848; x=1743752648;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XEirBUBZll/2CNmNMKcH5j/pk8NKD9yNsuFDYjiUshY=;
        b=u8BiemdEM8YkjFna0WNjricV6zjMLGG7eExungYooPxKTfRj3txfJmstZw4KaiZ5mU
         l900dWVcaZOVif0a6QrehxXzshLHQHFdz9n3OxuW5IBUffYQyalX1SMso3Fn+DH2iiGO
         /oP5syA2vaJfmmU1TuX+LebiubRth1y7SGAU5ZwX1Q1muvKbL5Ha7SJv8H7Anq4qK0XR
         pDhjoJ4G52VyiqdwTKl6U+SKzuVNnPL2KlB8NXPCDsNrtyLneO7eCBO3Qwvnoq5B/idF
         PJ1rhFK+eqCRDKQ8XUd0cC+K76qr6xpuY/yYmSNQVAoHrcCM76dBwz9OXfppe6WVTXsi
         9Tdw==
X-Forwarded-Encrypted: i=1; AJvYcCVMQOpG6cFsge/T6EqhbjJWrVK7qcNOQMr4/MVZpY4X42DSdmIMquWo96ADncLeJL3SKmjDoE1Cp2ylp7Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywz+YE0kcr/d7cgkVohyO/xUQexdTD8eNtaP9OOoARPiNUBna82
	HjF1JNcV56bOxhhEEL1DiYRB2bfCB9JF5Gdmvk8r/vx04NPVOMJnTJgkNES05no=
X-Gm-Gg: ASbGncvbVcIKvTcKEKR1RS3LgBSOZYrlFqqAwa4iiMsxVUUNEfDazn6Lktu0deqCZxF
	c7TXL4WC5JILrW6TeDkfFDY1XrrDpqfJhEPkDE2w+e/oxQ69yn6RpqNa+dKrFc+J+9gpLSOJyN5
	bjG/xUo3RUPsgF5/s4JTJVhM0XR3nED4ZtZ6sDJ1cSXOcL9lJShwxaXTlCO1N6Ce7pIXnr0bKIA
	H8d6lOVScd+knN+M5bgiIMxIvLPCJQ4F3Zd4jLy7lSMhNVyZwmzsq0ufwwWHupvo4w0Dc0NepMB
	zLZET/l1euRFqeZg2/+Q6kxZMApLg711BOB7QV2AX/hnsO5kCJSD3vY=
X-Google-Smtp-Source: AGHT+IGZ7IwtSD+rsiwYaWCAmSHkc24I3XE28ZvKsRaUNPPNFoNoNkWcCp9SfiyRprQhmO6Yvld/ow==
X-Received: by 2002:ac2:4e05:0:b0:549:6cac:6717 with SMTP id 2adb3069b0e04-54b01273163mr2319734e87.53.1743147847926;
        Fri, 28 Mar 2025 00:44:07 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54b094bb32esm215589e87.26.2025.03.28.00.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 00:44:06 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Date: Fri, 28 Mar 2025 08:43:53 +0100
Subject: [PATCH 03/12] ARM: dts: bcm6846: Add interrupt to RNG
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250328-bcmbca-peripherals-arm-v1-3-e4e515dc9b8c@linaro.org>
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

The r200 RNG has an interrupt so let's add it.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/boot/dts/broadcom/bcm6846.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/broadcom/bcm6846.dtsi b/arch/arm/boot/dts/broadcom/bcm6846.dtsi
index e0e06af3fe891df3c3d8c2005cf1980d33a7762b..d36d0a791dbf4ca3442797691957c3247c7187e7 100644
--- a/arch/arm/boot/dts/broadcom/bcm6846.dtsi
+++ b/arch/arm/boot/dts/broadcom/bcm6846.dtsi
@@ -196,6 +196,7 @@ uart0: serial@640 {
 		rng@b80 {
 			compatible = "brcm,iproc-rng200";
 			reg = <0xb80 0x28>;
+			interrupts = <GIC_SPI 21 IRQ_TYPE_LEVEL_HIGH>;
 		};
 
 		leds: led-controller@800 {

-- 
2.48.1

