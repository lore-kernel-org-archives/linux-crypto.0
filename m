Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4721D293473
	for <linux-crypto@vger.kernel.org>; Mon, 12 May 2025 12:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747051557; cv=none; b=X65hrm7hMg0YRyP+ePyssxfJ74wHePJfW3FhuYtPW0x4IIB0OcITHHkUG/02i/rC9kKvxl5z3P+aNUExzubrVi6FRnuko3+uyUavXgYUdarZJWkBIs8iqRZ8rcC1fP6xFDxflSLadZnvuqaz8TNSWDQmrz0v9MEC3nTg/bwmsPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747051557; c=relaxed/simple;
	bh=k57KumfTqkRBjwzB5nsewQ7XWlKYcQPp7x2UhedqkFQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OA5OdAnytuZ77o49ixdP0FsX8Ce58uPVp7Yy4fInbAjbuGtrvIQ9ut2yjuO8RmoK8HHemMuoTeRYmp5N4/vOwWt0Db683xeyiEv1vB+km8Llr7ShWQfpkztglUaGElTu6eiy9Wxg3KJCBt67bjpFXb0dES7oPAhuGJJpvNuWUno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Q1Bh3Wo+; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Q1Bh3Wo+"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-54298ec925bso6442138e87.3
        for <linux-crypto@vger.kernel.org>; Mon, 12 May 2025 05:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747051552; x=1747656352; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7Bizm6h1CDdffqhCM31Ev0bSZrO0bxrQbCDmltlpuTU=;
        b=Q1Bh3Wo+XPnTV2UqIoHN3y2HjZQl+GkL6S5vvXthyib7UlXr4LEvM4/CGQh/JFVpof
         evrowzs6LKWdFy05K93ExRBVItpOJqwF/+L/sRyRuxiIsPCtlOmzRzU1EkxGi5OPdkQg
         jO7O0tO7uaKjGK5tiyDTGe2uy3N0t7wTzKPv59lA3kQ29tLNKnbnCNaiLbKDT4sFgWaE
         hWCrP1SUnT2ScV4wGWSETwfOSleNJBmIoCLuI7Hu6/X7oqjL+r5NID7j7PbUK2LItbp3
         2v9h7i01CNjlNiBlTZIAtc7YgMsxcMgMFys9mTYb9cg+YeVejUmv0INZSFU81f46dGm2
         0Tjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747051552; x=1747656352;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Bizm6h1CDdffqhCM31Ev0bSZrO0bxrQbCDmltlpuTU=;
        b=hxGpn4x6+s2AnTqLRsOgAS5pCjWS+I5XBIBSwawbhvYV2ajuCFq/u53YUEpmkPqpU3
         i52qhlo7k3YRQFPnBv314qdLUuAQfS3ptCezSCRcvhFGcZoAMASkM573Hle+BTv7pJt8
         qmHMyS/IOpeu+ms1y6/Sv5dovYdAPVYYVLVJaI8K/2K7/n/Fn75RXD3rTB6YFKmTfls0
         mseNKFpAe8WRfi4mjCG3H3VAwOUAVT5eTc3EwcowWdyuXrN9+NW34VWx3LEZm3uL2XeW
         v58xr/mMwuFL+h/sj2AO6lUSuaLd6KJWu5H546tTpr6EVKz9RURqu2o8T6PSG5/AT/eN
         VRqg==
X-Forwarded-Encrypted: i=1; AJvYcCXEA59g14DRfVgzzz//NUpkkAngTIgfpv2B4SH7HmgWHHiyOQGx8B+G0OcrSu2/Neh9QnSvWSeAlRa3W/E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzulA29o/jycPC4WmNrUxM4gV3VQkSiyEe2EiWoHv8zUKXljLBQ
	agQlowkZNCZqdK7LGJrw4uoYtlOX0i3IiFJbWqUKhUqApF/dorysXaUjagZQootDfSAM2FeqI7x
	R
X-Gm-Gg: ASbGncu2RTqhTt5C20JiV7KkOdbd32ID8gosHuCXOGsIo/VLN2BVSYQzxJJ36aq7woh
	609iqftVuDm8tjc8Li34V0S9CtpGDH4kfJMuWS+/WnNxXup37WEWZW90KjyctviSrhVUT4XlhU3
	wXtckIUyzZw+KiZ5iZpftcw2XgQODaDGQle2YszTYvOovWkZSXgomjcMgPzokAUFqfMXrlqltwr
	02XECxOtIQEhsUL8W79EFh70ZUIPltAlfMcojUHg56hq8rir4Q4BNegOC+bPtjsuKH/Mx2VgXn2
	4tlVZuDdRIB9uUg8ZDMzPAjt5rbrYYm/SsQuLDyRa3I8Z2oIXeEWTDUaKvLAL5obvAeA2T83
X-Google-Smtp-Source: AGHT+IHUoH9YybM7VLnMAo3tNgj/P/n5qW5oBE3DnYE8EyBisEgdXJTrVYzEQwzEU3pLBUrAseEOfw==
X-Received: by 2002:a05:6512:461b:b0:54e:751f:4094 with SMTP id 2adb3069b0e04-54fc67c95cfmr3214756e87.23.1747051552532;
        Mon, 12 May 2025 05:05:52 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54fc64bf8a3sm1466033e87.189.2025.05.12.05.05.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 05:05:51 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 12 May 2025 14:05:48 +0200
Subject: [PATCH v3 02/12] dt-bindings: rng: r200: Add interrupt property
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250512-bcmbca-peripherals-arm-v3-2-86f97ab4326f@linaro.org>
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

