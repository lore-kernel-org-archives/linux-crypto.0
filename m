Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D91F21146D
	for <linux-crypto@vger.kernel.org>; Fri, 28 Mar 2025 07:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743147850; cv=none; b=ppkFClm/VgHmOmObAZimnjGY5KnuTz8pLUNd8Mgk2tZqL35jptVLxt+YjEL+Gq+duZXycx2JsGyAuyeEB2/sSy+HKwGtAPh26e3hyKif5RgehGBhq3ClEa0ET+G6/monsLW5MnSz2P3N0j/sG+N9vOkyjfQkxTOBAWTpvi3ppVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743147850; c=relaxed/simple;
	bh=8sRjf1g9G04U48+0KKrsadx9Nhw1Z3mfbjcZNLZU8co=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Hph8zuO21KGyzlFcgqoixE0A7cNQI9LKcKfX6ZUH6D+8pBaVJlJrc0zYvAvz7s2c7Q2k1ECanrZIe75B7+dlBGdX4CENcjkXaKqNApr84eDai1kdMgTqJflfupUXHZZhWClhy1SHvRPDg0n9pFt1IAsuupggUhbKyYxFu6pgKA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RbsBcD1S; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RbsBcD1S"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5499c5d9691so1934835e87.2
        for <linux-crypto@vger.kernel.org>; Fri, 28 Mar 2025 00:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743147846; x=1743752646; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e4+m0DQrar8QI/tlP9bedfL21OK40rHqMTDJEYU92jM=;
        b=RbsBcD1SzKNSnB9tPgszYP3qeT5dqjch7UMRsqd6IlonJoQECSgEmTusmEj7edDbdg
         b0gHpIUSgbcZwuWH5pG2LWysAohwyMdyZQquLA/6azXtFmprD5bfSouFgusJY6wGTxRl
         Bh0payVrA1zjrYvCXldGSO6m+1U0R3fSFS5OtviUclxaAqA0FZm/sp0pfN0hXRWgKcYu
         tGZd4bc+Tgg/d4Emat0pvCEArO9mIb/cRwW2Bl1w6IdIh3DVS8SrfkToxH8RzGW1gPSM
         bNSVDQX6X8MFZQOaTcypfGoIauWGgzuakJHcKSUYXPaf1r5tAq5wZ4xM2UjrYKk+4+oa
         2tjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743147846; x=1743752646;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e4+m0DQrar8QI/tlP9bedfL21OK40rHqMTDJEYU92jM=;
        b=mluCWlKl6TUXHs1sFpzvYtD0OcLmH6X9XJEYikcLtNPQXm8G/Va+9hl1qVie3B/Skx
         Z7b7uUHZ2zJaRD6f3kcrbB9x4oUU1XKJHuXWASQ1cT6NCWtj94Jf982N00YhckWJXAbP
         /zjiJwOar4bB28FM25GwkPtzHoyXN/paej99mEETMa6gp+tadoZyCYW1/VDPpZO3i+bX
         CW/ToVN27diOsx24KmNEUq/Afw5obCm/NOsvCStTVoVT72RFwSizCQ/1GTJOZkuI0+Oh
         EgFSx25lIXXtbhOvb37NznbfUKIFRdhZAlB51PYyzNuLjNtjiC4RRU/S+xeeVnTFbPO0
         FGgQ==
X-Forwarded-Encrypted: i=1; AJvYcCW2o0qJlUSGN9Eix/ogI+USD4tFIIpB0fZ0OYa1+9dT/vjksqW7tY+5yghZTWVJYWOqw+XCgbHk+bEPPUc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yztne8L33Cq5VXMBMBoGuhnVdLdsXaHDGyxWg3yT6FGHGHffSuL
	ozCT44rTTB0nRu0H1U/XWemFhnKyuHVSxX1/IuzM2yjatdGVidQvhWmAurWA+IQ=
X-Gm-Gg: ASbGncsi1HvZ8hTKTOhaPw5qVAOk3SuSb7HaTmIXXMceN31Yc/ANHX40BkTp1KifTom
	QyD2nCZA6eC2SxVZqnrYl8hbVsr2Cj59PIzOFBsazeFllvpup6/BsI/LdoviPZ4b2R8KeKGe/V2
	I2gvXjiQ8F4cLz+/Y2Xvl7BxVgPtsgAw2/6XhXabDdIi29T93N/8KB8syj6KC0HmLTKLp+Tz+v9
	GrovUfT+u6xLkLaWu3atF3y7QJ0WwZMTJEszGt2Lt4ze1PlOBfTqAFsADT16HsHzHGalTxaW/vR
	HQQ4oVZ2w273PjGVc8NMib6f+usBhCoYSWK1ljoa49HNYTqS+otIpDdTMbRPkj6yDw==
X-Google-Smtp-Source: AGHT+IGEJLYduYUPeoDkIamTghfK6td5L59kTNjPxXBCyjG4pfVB1wPpXcD2GVk/GNmyMa7totuByg==
X-Received: by 2002:a05:6512:1196:b0:548:91f6:4328 with SMTP id 2adb3069b0e04-54b011d5afamr2870433e87.15.1743147846331;
        Fri, 28 Mar 2025 00:44:06 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54b094bb32esm215589e87.26.2025.03.28.00.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 00:44:05 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Date: Fri, 28 Mar 2025 08:43:52 +0100
Subject: [PATCH 02/12] dt-bindings: rng: r200: Add interrupt property
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250328-bcmbca-peripherals-arm-v1-2-e4e515dc9b8c@linaro.org>
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

This IP block has an interrupt. Add it and add it to the
example as well.

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
2.48.1

