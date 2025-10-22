Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B240320A0C
	for <linux-crypto@vger.kernel.org>; Wed, 22 Oct 2025 11:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761131982; cv=none; b=fYKJtlcaGYy26Wj1phJm0z8tzQdDfndqDQJUjoRU1nK+boDcqA58x2BRHbwQciR9FK+9dr9ZjZV8b7gfNTr5RzExQsRbE7UjJjjgQXBci0HrSMrNBtRaZra1wuwMs/ceSBZ+SuWwnLUGoe4g7nc8Tp6AK6mLJZwAizcyfhzxIEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761131982; c=relaxed/simple;
	bh=wFL7EaC7oajWS8si1y0wmfU9HL7IN0yiHQa1hCUg5Ls=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=q5mKh1mZAIsBHtc/PAVHgl5hrnmiL0lggpFJ8tL7zqIKgwgSDvh23NycG7qAcZvdepG+maHjrly7TnP17Ovz+yMxu5MaDfffaGHUmfXqZjqp8mId8dvRYhJvDOk2C5suO3Q1ooj/6I2cFyGNLWTQNOBAd8SRniF90nePBUQxa3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AjAKZ/mc; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AjAKZ/mc"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-426fc536b5dso3753616f8f.3
        for <linux-crypto@vger.kernel.org>; Wed, 22 Oct 2025 04:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761131979; x=1761736779; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+TkKDb8seGZ3p0bb+weF9fHd1+l2SxCH4jqobx5Z0NA=;
        b=AjAKZ/mc7EWnnQzrNesITi72sW4ZFm4O/4KccWtbn6ml+5ewC3EedtTk73cjVJ5Rjk
         tLOcdMm73Rr/Zr401m0XnkMbyKodbiHmUXhNADOgIhxsMcxOHgk6kRVY01ef1N9tJIP+
         pggt58RXe6L+8mv5WOwnH3SXFqgIsvguDeBYW1Zzi8QnuNJRkfWJCi99do2DKW6p/0bI
         c1QW1MSwLkMj+EE+zxtmbFtHEAov5zhiDZ0Va48A6ZaH/EchiqMy09tHCHc4junXQe8o
         4+eqIfi517NFIONqqT/v+8MrbPW4zVCq3yUBQXYPOHaloOMyZNWIEDNDlXdjuH2eISAI
         gncg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761131979; x=1761736779;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+TkKDb8seGZ3p0bb+weF9fHd1+l2SxCH4jqobx5Z0NA=;
        b=aiC4J90eQTElTTDZKZqnLYSXWEwp3sNRn9fJQI+WnPX+DcV44V8E80zcqiVDA7TTYp
         Qrm5lldFSVocalELX5q7KNQv7EgH0wnBtwNhYIfgpKEoDk7jSrs09/yGCHPDhaqJ9wnj
         4uwjsu3q9fQQa3pPJOLxAkhHoAh1R6OnpA6OU9Ba65map1HlyqQMfdGAGmNAGUWwOmPS
         OqojBbUKX4uKSAPQnS9jycn8YOTLYu0OWHnxmUdzTwMoqGYqXBJ1VwGfCtAyvHICFQpk
         LVqPKdnQBdpuVvuWyeR37gOzKvvwWOEgMv4pxbcsTPCKL68KYENtuak0a8D+r3JI5F6R
         mM1A==
X-Forwarded-Encrypted: i=1; AJvYcCWa2yUEbaOHgpgLxYafz+nhv0SB01qnCrgQAIIDSKIMREJ6f7R4JIwKNN+H7gpTaQvt+Sr+ENUf4nw7WIA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBH9z3s/FklklOIOhXomYZ0Ay0d3i9qSige6Q6EOw5a6Q3URlO
	Zz4QYIivqPQ9Vxwar8B0mx/mL8gRDupL16UBgGevw91njdWTNr/SJH3c/OI9PNtMKas=
X-Gm-Gg: ASbGncu/x+Q/Ycd81UNBv8MQsTsEH/RQPjw7Goc4azkNCgVhGk6UnGmNL2qTaK41sca
	XLeyMe3ne827ZGseiC+oy5trkEHqFVIrniRaXNJHMRyDFkUD48tRikQgvhVBk6a2Ml0978RbWB3
	UIsL7RVatwzioUOM1G5IzZdjH/YCB3YIVjGE9YhzuduKXNbPEMvpQvyAgchUhK0nCwlWg5/wMCO
	DuvyUTmQ6qBwY/Lug0HKSYpoqNeZpzrKyMkzetFqNx4h5E3NQ0rzeSxXK9cfBeMjVORYXV0K8bE
	Khs+TfMMJjdnTDm8qFJOwmmT1Uhjw+qxOAbeIFrMHcixQHO2tfLgKfk6H0VAoCqhucHc6LqJB2D
	oUdbdQfrSS3F3kmyNmiwYwT6Nf5CPvrYk7v0/KfitEjK21OJxkuPzgsH8YJRf294x77lCwqmC3l
	afxEUAqVmCdbQnIzSq/0H6O/ggsiRZnvMv5CJggODkzZPgJaqUQ9qtzsnmyVOlZls=
X-Google-Smtp-Source: AGHT+IE/+qEk3SjQE0WaGw/Ate00STQbnaD0YtCC+WFT4/Fbr+bdpqv2kFO9m4rVu0eXE78+nSoBzA==
X-Received: by 2002:a05:6000:491d:b0:427:55b:cf6 with SMTP id ffacd0b85a97d-427055b0cf8mr14963659f8f.7.1761131978900;
        Wed, 22 Oct 2025 04:19:38 -0700 (PDT)
Received: from ta2.c.googlers.com (213.53.77.34.bc.googleusercontent.com. [34.77.53.213])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f009a78csm24820692f8f.26.2025.10.22.04.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 04:19:38 -0700 (PDT)
From: Tudor Ambarus <tudor.ambarus@linaro.org>
Date: Wed, 22 Oct 2025 11:19:35 +0000
Subject: [PATCH 1/2] dt-bindings: rng: add google,gs101-trng compatible
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251022-gs101-trng-v1-1-8817e2d7a6fc@linaro.org>
References: <20251022-gs101-trng-v1-0-8817e2d7a6fc@linaro.org>
In-Reply-To: <20251022-gs101-trng-v1-0-8817e2d7a6fc@linaro.org>
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
 linux-kernel@vger.kernel.org, Tudor Ambarus <tudor.ambarus@linaro.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761131977; l=1108;
 i=tudor.ambarus@linaro.org; s=20241212; h=from:subject:message-id;
 bh=wFL7EaC7oajWS8si1y0wmfU9HL7IN0yiHQa1hCUg5Ls=;
 b=BADVR+Jf79pRXQQP7OJ+g5sLQY7l/hCEa6RUAs9sGn87SwsuC7w4rRwpSLmGz9MKiaePKpFtk
 kdDu7pTDMneDUah7lu5PkCdDDp1n5XfUkpHjxqyC9OeuHgEpauWIQ/v
X-Developer-Key: i=tudor.ambarus@linaro.org; a=ed25519;
 pk=uQzE0NXo3dIjeowMTOPCpIiPHEz12IA/MbyzrZVh9WI=

Add support for the TRNG found on GS101. It works well with the current
exynos850 TRNG support.

Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
---
 .../devicetree/bindings/rng/samsung,exynos5250-trng.yaml       | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.yaml b/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.yaml
index 1a71935d8a1906591439c03b7678538e656324b6..4cae7dccbb915cf50dfa8db86b43293a66200002 100644
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

-- 
2.51.0.915.g61a8936c21-goog

