Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D38F21CC71
	for <linux-crypto@vger.kernel.org>; Sun,  6 Apr 2025 15:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743953571; cv=none; b=VS3dmLjQWPFaqR9FXI9/aDedUtaZDRrakZqRLv/5fcSryt4gyn/lpa8azkxDCMGm0BOXDOHOs+JUg3zdaXgpk5mDkrIGICorPGYFff0VEE81ixcf09rkzbv7ZDG/K1dN38H7gujP2FOQQZEjA0LY6u9ngs0wzWbdRC8OsoyPuc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743953571; c=relaxed/simple;
	bh=k57KumfTqkRBjwzB5nsewQ7XWlKYcQPp7x2UhedqkFQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=U0Q82yFa3bW8HriPyJwRxXfdhayUjRkeCALCP1oKYyxMGIQoIiBc89VhjlzK6rkLHz/ZVW7Wt3UAz4x2kCq/7dldM5T91QHbv8TZgk8u2DMh+tVdiWiN79VjMwD7u0l1qRNqVOGvdEo9DLPG2tcisMukp8mVu4Vk5VlcKZo/b8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=b2JMIHcy; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="b2JMIHcy"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5493b5bc6e8so4501763e87.2
        for <linux-crypto@vger.kernel.org>; Sun, 06 Apr 2025 08:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743953567; x=1744558367; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7Bizm6h1CDdffqhCM31Ev0bSZrO0bxrQbCDmltlpuTU=;
        b=b2JMIHcycwhOrIfYbrGnxbkkW+crKBUlu9h3fIguR6WWNna3C+0EpeG8wCOWK5GH8Y
         RcdGlBrsbR/PRJ55ctvGAikiDcfgM5Ov+NLwoK+wuzIgZawAQULwD1Vd+MCgSrBbaUVi
         oirxYtsNfN9MuhoP1X/NIIF3P4enJ19/useKpwHxZ7Pm+SLsli2uiE+fPUlGvOryAHFE
         +qoJZZu1cyf0ovegrJATVMdNMcaM3581823IkkXhg0frtpr8C+9zNnJ4b5BlA8k0DRit
         Wwg+YWXxTwBIQhv3hCQFl9lne51W5/fs+ZgHHZsARuqjEdlxwDSjruKke2fkI/ZcBN2c
         /2Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743953567; x=1744558367;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Bizm6h1CDdffqhCM31Ev0bSZrO0bxrQbCDmltlpuTU=;
        b=uV78AtUj/LvV76QzA0WJWf+/oW7b7fBzkl1kCBzlODfkXOH8St0+wzCQysf8r9lqTf
         FfZVFQO5m6Ze8CadZtTDHZIpyJsWJqvUn4ISlp4WrX2ldHsPUwyX9YnS+Veip9m7nPyH
         mwY1jbd71hCB+RaAnUOcip3zrmQyy32wVrw8Fh/+joD9+MToYrpbxz4Jxm7R7S7tPTCL
         L6OtBP1k2WSJ6ahkOJ9PJ4L9BisYzhbpPrUebE8E2NstqlRxlKyr01CSj5r9eGtvHJwe
         XbJmfHmmKVsWhTMY57O4bJI0FPot2QdZySlWxr/PztjSQSSm/YBa/YQ/nnjAMuP1Fb7j
         cRTQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYFznSLfdioBBHuYvjg1TQbJE6nfLiY5AmeaAADtl4fMQ7UPug2GjYKBzaLXFejckYNqtc1N/QtCEEIoc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRIRedbfZdpe3tEK6neqT1U5yOWcLI7PlsZ3ijJHVKad6K6/W4
	fUdClgpxOpP/pDlx/9RWJH+HGRakAvwb3DNqcGI1m1jI9iRJG3vzPy2DLDnzy4k=
X-Gm-Gg: ASbGnctnLuWZPnVa6Z4G61KybwZv7JODyJtEf8niSRM9eQ1lzL+gi8QrnBS/iJi8feQ
	kpUWf6uMP//ssio/VhfCpn0ZeXdhxwyCT6MwcfwZvvfUnmnGT+dOx+AbwOX0EfurhCNU1zgpXdu
	tKcrKvBjmhux8RUBvM/AHkLtjXe6zYIJGfnA22NpswhYCAD+ItBR+LjbyIUccdmhynI2WqmAYhn
	MIO1GbGyclb45cxijR7YE0sd5yRcg5/RAhqpfh2tCIyet9UOfwYihtv+b+jIKvpDMNKhe+zFCwa
	17UUgaP2sX1pecaN5SBmGDbmY0ePIcN7neLDR6paaDOjay8bzOT/rqc=
X-Google-Smtp-Source: AGHT+IFie+5iQdZTFiEqXLdGG/9Obz2+zMwWEcSfzmmzsP0hfhvXebqGm8T5GChopGRfGqsSOpyx0g==
X-Received: by 2002:a05:6512:1253:b0:549:7330:6a5a with SMTP id 2adb3069b0e04-54c232e23d2mr2694580e87.23.1743953567253;
        Sun, 06 Apr 2025 08:32:47 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54c1e671fa8sm989747e87.218.2025.04.06.08.32.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Apr 2025 08:32:46 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Date: Sun, 06 Apr 2025 17:32:42 +0200
Subject: [PATCH v2 02/12] dt-bindings: rng: r200: Add interrupt property
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250406-bcmbca-peripherals-arm-v2-2-22130836c2ed@linaro.org>
References: <20250406-bcmbca-peripherals-arm-v2-0-22130836c2ed@linaro.org>
In-Reply-To: <20250406-bcmbca-peripherals-arm-v2-0-22130836c2ed@linaro.org>
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
 linux-crypto@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
X-Mailer: b4 0.14.2

This IP block has an interrupt. Add it and add it to the
example as well.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 Documentation/devicetree/bindings/rng/brcm,iproc-rng200.yaml | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/rng/brcm,iproc-rng200.yaml b/Documentation/devicetree/bindings/rng/brcm,iproc-rng200.yaml
index 827983008ecf707019f45847cd86d5686e3b2469..817cbdaa2b2d75705eda212521186c40a9975ea0 100644
--- a/Documentation/devicetree/bindings/rng/brcm,iproc-rng200.yaml
+++ b/Documentation/devicetree/bindings/rng/brcm,iproc-rng200.yaml
@@ -20,11 +20,17 @@ properties:
   reg:
     maxItems: 1
 
+  interrupts:
+    maxItems: 1
+
 additionalProperties: false
 
 examples:
   - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
     rng@18032000 {
         compatible = "brcm,iproc-rng200";
         reg = <0x18032000 0x28>;
+        interrupts = <GIC_SPI 83 IRQ_TYPE_LEVEL_HIGH>;
     };

-- 
2.49.0

