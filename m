Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45313446C8
	for <linux-crypto@vger.kernel.org>; Fri, 24 Oct 2025 17:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761328270; cv=none; b=dF1yJsg9E5zxHWv3vEM+Bxvy4sYwTbDcs550lZnCRLlz/MwvfcFG3DzbRy+cWtoteN4OUhWvjjejnX0PnAPnOVnYAEnq7BwvNA+AItp9hybWBgtQEnLvn2ognGWyDHWmeDIh6H5gXAImaCmy6VqnkzKTIwit0cK2vONUBJPccEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761328270; c=relaxed/simple;
	bh=8OtrpREBtZB1x192nC3r4mm44r4aYjTnAu6oo/Ofj2g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=S36zPRMi+W8My3gMFv/sa6FMcENVgAHvokp4SYmR8VShv3nqwPSVr58esqjeCTYawcjpH2fmwMR1J1NFtLfDrsbQDxWOXWTKlJSpERX7qAaeGXZaRYirr63/2O+kyZkbhBssy7+1c56Q2/SyYgqqFmXOdRY3Sf62NS8brYpVOU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SJSAvB/C; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SJSAvB/C"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3f99ac9acc4so2197350f8f.3
        for <linux-crypto@vger.kernel.org>; Fri, 24 Oct 2025 10:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761328265; x=1761933065; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rOLCVk9/QiwKN1UsTQZ1CrvJYvRM1UlIJhn07XUe2KE=;
        b=SJSAvB/CsSjk1zmRm6AGqxMzCQmvBN1M/IavOPcRxaLjFoqt5Y1o+CAcM12XpvuqGH
         EVXxwVL7oYDEApUQa9zUB6w+WEBtLEa7/jw9kqwe4jzvQPFu2nyJStm+mg8T0FNZuX8S
         uZRc4j2y4c+NuWeB8YjWl7xAVPbTaFFKFWVnIw+VFKEvLagst1P4yTpfFAqQmnbmJjCn
         PWXxo0G8zSyPtIZIFIKDubBy0yfSa8if50eUsqNzoC43EU5T3oI/azVGS2MwKob8mmXv
         11iIc+lUUeaoTYpygZ3Aq1yGs11gUNSriH2QPSJKe7MyvEwa7CVgGJXvNIXj62lmcTIZ
         irtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761328265; x=1761933065;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rOLCVk9/QiwKN1UsTQZ1CrvJYvRM1UlIJhn07XUe2KE=;
        b=rwJQaD09wtdlRVvOsozQ4khfItIDOr0VVe2TZd5AWElkSzS2RrBv5KguS4nX7RgaCC
         XvX5P7v7iggt8uZl6wX6mxynZKOhRk8e+11ndAYh/YzC5lgIZJrl1kL+JTpqp7iksBW7
         2szls0jaQAygqhtX4HX5wTtbYyhyXmtxTnS6+wiEXknaHNqxsvWspSosFZnWxK2cy/of
         S2307B/PNGbd2wroXEse5vhJzIOkgu+XKySQSIzi+DmL2+cGPz+Ksk7vTqqdPDQgv6dO
         0EvPqoEuAygbdX1lXXhqJzihc1KrOGk3pKxwdJOx+AF5uygYLs/p/REMQSk7PxBSt5oy
         0xww==
X-Forwarded-Encrypted: i=1; AJvYcCXGBTrDD+j9vw6poXFPh0qSk4ro6DbNCviL7FhfeEdb1YgxifhTa9SzBzxhU0LE3QRxCsMLwv2sD+iNFEQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvhB6r7aebT61LhveKlGPE7FAQTbUWpipOSdnqEPLGuKLKKrWb
	1KjAPJM7CFVWMpSbSJ0weAK/K3cWy0hpmIY5qdV4dpapZPU6OrOW9bQEsUK0JYrsHrU=
X-Gm-Gg: ASbGnctMZ5MMUI4UkifEKd31xs/XKpFCuBWZxu0fOgj4Z90Tyv2a9wYMel4v8smBZmN
	2JTAxPoq2YzJN9atzb4IOPHSK3t5/JaX2yaYkQ+5iL76nzIil8YLF1D+UDQTY1Wb4BXBxXH2Es4
	FW0JlvPUS8+dxXGTHG1CdRt2L8Vyj9Rwilz4cu3/tUlDHTKrzZEEmRQapKFsTpIut54X+ep6kLN
	TNqdMS/iJXi3Q+jyci5PDL3slPZW5WqoAZcvrMlu3ZYtNG7vxNBVUYmaBUtAr/a0eogWOlUqkkJ
	J5YSdr+m9HI967fYqRLKTx7x8Og7J5f144cSHP6tawScnRHf7obU1lHyVcAe0q0VhonABNgKijw
	IyZQyMSvWt1fzI/0t0BUttgVbFx4VGivvpLKHX1CF+WD0wJmdUrspONS9BZ8dvNa3Kflekoa31w
	nBcWkzaGDSo5ga4ZZh6Wmb6sd9yRcc4zvDenywlXwcsHxT9eYYHjaYv4mckCucZ0YQloQEwpeAN
	w==
X-Google-Smtp-Source: AGHT+IGYnylqqVKrCTZY94vqPvipylQ/dkxetbC2sOasmr565marnizJOrsOZZOI5A86DycSGu2Bsg==
X-Received: by 2002:a05:6000:4715:b0:427:5ed:2d95 with SMTP id ffacd0b85a97d-42705ed2dbdmr18159704f8f.17.1761328264940;
        Fri, 24 Oct 2025 10:51:04 -0700 (PDT)
Received: from ta2.c.googlers.com (213.53.77.34.bc.googleusercontent.com. [34.77.53.213])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429897e7622sm10321900f8f.8.2025.10.24.10.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 10:51:04 -0700 (PDT)
From: Tudor Ambarus <tudor.ambarus@linaro.org>
Date: Fri, 24 Oct 2025 17:51:00 +0000
Subject: [PATCH v2 1/2] dt-bindings: rng: add google,gs101-trng compatible
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251024-gs101-trng-v2-1-c2bb81322da4@linaro.org>
References: <20251024-gs101-trng-v2-0-c2bb81322da4@linaro.org>
In-Reply-To: <20251024-gs101-trng-v2-0-c2bb81322da4@linaro.org>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761328263; l=1419;
 i=tudor.ambarus@linaro.org; s=20241212; h=from:subject:message-id;
 bh=8OtrpREBtZB1x192nC3r4mm44r4aYjTnAu6oo/Ofj2g=;
 b=EQv43Oor9EYwbIg+bkdEWKveNwuPK3fDoxFXHSnLdCDKDEvkdprIIYFqEghv/+a5an6lUJ7j5
 LF59aorIIHyBSZYPZRgaBHpL21gSRPECTAlmuIjbb2IRfV9mNHr9bOf
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
index 1a71935d8a1906591439c03b7678538e656324b6..b85edb47036ae745b863bd8ded500891ea28c723 100644
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
@@ -27,6 +31,9 @@ properties:
   reg:
     maxItems: 1
 
+  power-domains:
+    maxItems: 1
+
 required:
   - compatible
   - clocks

-- 
2.51.1.851.g4ebd6896fd-goog

