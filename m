Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336A7342C90
	for <linux-crypto@vger.kernel.org>; Fri, 24 Oct 2025 17:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761328679; cv=none; b=A/dTZKWcr0RbZuHmFcUIgHbLt8IzffinmLjujkP4brMw4j2E1QM0qRDeZLvNJyABAWbUiFa0q5LMySD+umIK+Cqh72w5nughqeRGb/whISZs+QYHIPfwGjokapou3UM9OhRg4QR4ufCt30cgej0VG/AviZt3EMdigJbgzciVyPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761328679; c=relaxed/simple;
	bh=VSqkKAfAsASQV1wNAEnHQHuaUPvFzGicTvWIh5Er0fs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WoPSsLK1IJkjKRRgjbmDitGNCihGfHvJU4WnBcwsxLNY7FDUP28nq3C8pOtFEvFkIE/XB/UALKXxsmdgaWnphJYe8AU6Vy03AWDFbykL3Hf5iQY1Trrtdz/6STYucYhXPMQTz0BB4wJTLGGDs4Nezyz58wDveMB7hmSpGD3cDmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qCKNjb/I; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qCKNjb/I"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-46e6ba26c50so18963045e9.2
        for <linux-crypto@vger.kernel.org>; Fri, 24 Oct 2025 10:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761328675; x=1761933475; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bdUt0RNaR2iDfSWCYFBAweXOdPy+lzj4EhVJE8ZDdzw=;
        b=qCKNjb/I9X/5OZimIEkf7QcbMYNbFdq7qOi1IsLLfTu1W0chklcVXHUGKsJp71kffh
         qVftJcQWh8kraAgKyLx0a09zF1lJk26P7HqmUz+aQ5gVCDvtraxRsat65kVkm5ShVWeO
         1ZOWAdY5SFwvb8fYQ1ggH9jltFzm361f6bIzbyAFoHaVK7INi4yFZ7vwKGuIeRq4kkCG
         FuesT8tPkKYdCSa2Dxj4DHKlouOyy/Aq0re8WNnVlFiDf7lknHUVLZEWSLRTuFU1flQU
         whx/tGYNxpjWhU/8kXd4vcHZqLQDl4iwSXbA3T1iiYvbr9jHtB3pqLtzqbTVLPTkSL+C
         cD/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761328675; x=1761933475;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bdUt0RNaR2iDfSWCYFBAweXOdPy+lzj4EhVJE8ZDdzw=;
        b=FYpefqOIgRiFbPc6vAU63bJCjIYKWoAcKhKvD6E6JZv5i/yCAAg+zuq75+/3rByTDJ
         qD5u2dNYaFYuWBwvXIDRYpvdvb0Ey3ynUOxdyoox3uOE/DVvelwH7nfJVfaHtriUBU2j
         01lIvHq4DEglIqSqG1AC2uz80x9xF/EYNNZ4XM/1IUC3OVzkScOQnp8+TWG+In9dlFq7
         rw/mxofGok+Q58jTwb0ZeuB/gS77vWwrHLEb8VAPhY6u+Y0gLiBPvmm1xKDqQ/1q4pBo
         SpN3w41NYIDjF0ZEt484Hx3cxJ27hubZgmFNlRlYJur9y2f0UsCWSdWQE6XOp7PNuLG3
         jMsg==
X-Forwarded-Encrypted: i=1; AJvYcCWGR/PuFleJkFDPJqqdBq/UjXanJvEYX85zlUcgKusQEWSPQEBK5uAJ2QScf1S7ynKv8REHEBO1C3M2xyw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx71YPL5Rh35B309TmkreTSUiHWKYrf87bpfkHxJLfiqyJUvRLq
	OSdlT+LPpWmF2+HT9sypBKx6WkO1zDMGGg81WWqW+S9rChsLr7ZjYrNU2kA8UdnKKdQ=
X-Gm-Gg: ASbGnct/EV20Or3qUNVuVcTU/RL+MbKM43Ls2b91DyhjPfKqb/Zr75s/Jog+51ST+Zt
	SQecM0BTOABpXKw9hAIZQP/fjiR4jdkCSMS6lue31KpDOSqWKXiHn1sDv+er3AYsU2SDAzAYq8t
	PUQJhIP5Z4bmXC7vAx/o9W1cRXS1FjyJILx/PQHUT0ofVBxCoievQJVnGQ862C+QYVKIRtHyg+r
	oy1Enmi+k4hvkS7safuU07+UjFGd3ZDiH5v3c8Q7Xh7+yyh8n9x1pIifFq5OGhr/XGWoeHtx1Tu
	+GpCQ2WRWr1fBb+q7pmxoZ/FdFlnXdSjrwVdRIshLypgQu4q70G84eCw6HkcnCJcj+Ic4Cu7S8z
	7L33+N6Ib/I2JfEKB69Q27iIEXJUKLW+TT8wWO/fn3lNc1H6IOcXLyctNKViMjNSwmAVIu+Kh+0
	bJ2z0y/R63x4CufjSBkndD1QeBrqsirBvceCK2ujFNdnRaaZPbhcBN
X-Google-Smtp-Source: AGHT+IFsoZFB0tp8+Ix3Ahj2qQkKTO41JFdcnIV2Y9pnCVaB8qxrPU8f/giCj+VPzq5b0sapD/+AIg==
X-Received: by 2002:a05:600c:8215:b0:471:a3b:56d with SMTP id 5b1f17b1804b1-475d2edace1mr37349155e9.34.1761328675489;
        Fri, 24 Oct 2025 10:57:55 -0700 (PDT)
Received: from ta2.c.googlers.com (213.53.77.34.bc.googleusercontent.com. [34.77.53.213])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475cad4c81dsm104062465e9.0.2025.10.24.10.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 10:57:55 -0700 (PDT)
From: Tudor Ambarus <tudor.ambarus@linaro.org>
Date: Fri, 24 Oct 2025 17:57:34 +0000
Subject: [PATCH v3 1/2] dt-bindings: rng: add google,gs101-trng compatible
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251024-gs101-trng-v3-1-5d3403738f39@linaro.org>
References: <20251024-gs101-trng-v3-0-5d3403738f39@linaro.org>
In-Reply-To: <20251024-gs101-trng-v3-0-5d3403738f39@linaro.org>
To: =?utf-8?q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>, 
 Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
 Peter Griffin <peter.griffin@linaro.org>, 
 =?utf-8?q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>, semen.protsenko@linaro.org, 
 willmcvicker@google.com, kernel-team@android.com, 
 linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, Tudor Ambarus <tudor.ambarus@linaro.org>, 
 Krzysztof Kozlowski <krzk@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761328674; l=1416;
 i=tudor.ambarus@linaro.org; s=20241212; h=from:subject:message-id;
 bh=VSqkKAfAsASQV1wNAEnHQHuaUPvFzGicTvWIh5Er0fs=;
 b=TUEcoNwwAwQ353epU4/TqYF+EqZtHiYEB5oZJTslCHQ7ANEPvO/wg0+dwkmN8uBeXDUXaXNFX
 K5fWbcR9GfPAkSc1/TSFsux2yQMkPQd5vyNUQWzGoc0j25Oqei9aMM2
X-Developer-Key: i=tudor.ambarus@linaro.org; a=ed25519;
 pk=uQzE0NXo3dIjeowMTOPCpIiPHEz12IA/MbyzrZVh9WI=

Add support for the TRNG found on GS101. It works well with the current
exynos850 TRNG support.

The TRNG controller can be part of a power domain, allow the relevant
property 'power-domains'.

Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 .../devicetree/bindings/rng/samsung,exynos5250-trng.yaml    | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.yaml b/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.yaml
index 1a71935d8a1906591439c03b7678538e656324b6..699831927932949a433fa5dca767ad366fb76f2c 100644
--- a/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.yaml
+++ b/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.yaml
@@ -12,9 +12,13 @@ maintainers:
 
 properties:
   compatible:
-    enum:
-      - samsung,exynos5250-trng
-      - samsung,exynos850-trng
+    oneOf:
+      - enum:
+          - samsung,exynos5250-trng
+          - samsung,exynos850-trng
+      - items:
+          - const: google,gs101-trng
+          - const: samsung,exynos850-trng
 
   clocks:
     minItems: 1
@@ -24,6 +28,9 @@ properties:
     minItems: 1
     maxItems: 2
 
+  power-domains:
+    maxItems: 1
+
   reg:
     maxItems: 1
 

-- 
2.51.1.851.g4ebd6896fd-goog

