Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D10C1514DE
	for <linux-crypto@vger.kernel.org>; Thu, 20 Jun 2024 23:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718925227; cv=none; b=FI9I74bKVcJ8O1zLI9/byHUrsP4cXfZkXJ7vkl7ZPkc5vveKnxah/XfdDZegz4K8bfCWEbg3zlE9lz1L50Qp6nSYQ3AV51N9Faj7hki2A6SrcFMbqBz6To1tAvsQvX7oOW6sXJy7paO0hvg0ro5OoQwAe7B2FOZwJn9UEnKtEYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718925227; c=relaxed/simple;
	bh=OnEU/sDI6L4n4GuKABhOjlofl7NLYJUjjb44iomKIdw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BVEwHZeM4sJxaRzOks3cATpmPYhBlCAIaiP+58gZJuOS+fN0RncHXsBpoQeMQkReY0dIlzGqqK1tL5lRot2mBWA47ICXB560Jc/NV0GFqc7L5s+2ipsyxYajkL0qG/0TSGYe7NoyhCeQt3YWqQV64KRM4Di8pGJOk5K3aOgzMt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KbGzKlsu; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KbGzKlsu"
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3d2472450d6so753902b6e.3
        for <linux-crypto@vger.kernel.org>; Thu, 20 Jun 2024 16:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718925224; x=1719530024; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zz8ynrGU4z42Aj9sdj4ptAZtRt0FzTqPDvedxGwGE2Y=;
        b=KbGzKlsuFU1MfOfM+Ae5/YotqltjV0hy5HkjLHV/b5SHJ6gHDkITlmrmHo0NkylSKw
         5uJWeA0epi6Ym+UhRcXiV/fEgsTTJnrwrJz/3/pEMBPKK9C9Ir1YVHoaP7lDO/OSG8i1
         /1w98jnfKtR4buUC2EU9haxz2CGUKjqBT1JQa17PpWNZ7AnAttujMQpukXYOC6Rbxuz+
         bi2EbPqojfU1LJ2613JCd/DkZOZ/A3aw6faqLgE54g6gdW6E4LOe1lZo9kJwupOau6Hd
         gH5C2VCe3Kt9wdoG7M90nMBr1EHIKQ5DEm/7Xe6Fb1ZYk+ZCmhTt2vLzqpx3J2q47veK
         P1YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718925224; x=1719530024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zz8ynrGU4z42Aj9sdj4ptAZtRt0FzTqPDvedxGwGE2Y=;
        b=DwrIG3pbiYggkXQeYK61awzYDbLITG4ElR+b1nNv1rKR+vRoEnjW3Vn2hn2N7q5XaO
         wYW5cZP5W5etWv5tz85/AQKotUyA6eN8p37I3wM5eBAGd2GCGcpUuSq+Fk7Z+RxPDFPA
         v7bMlwRC5mEtHqN9ousnBeJilddR5AN8liJd0UaB80u/ziM8rC+CD9brX7NCFh14d9Nf
         mWSWiLZRTiEJcLhPIQjuBQs99WUQg1/i6G9NNJh5ATnvztuoQpsKAFjobg8YOdMLOCZc
         sChDfqH5LK7Lyh/03S7L/kdxGFbVEGVxQS1LHTvwvv6xb0UkA+ho0QKwRgUD1gaW9xRx
         +m2g==
X-Forwarded-Encrypted: i=1; AJvYcCXwsnRO5wJpD11jYJg2KzM0Q2NEfr3iuKnbrXhjzJUjaL8q6YKe9ovHaUHIUVDpRlW3Qtf3D0JP4qCplj5S//ytmTqljEm0FM8CtwT/
X-Gm-Message-State: AOJu0YwSY9QsIlCnyAn+M4CtFoVIIhhl5LldQpAulIhnzzxxF28//Shr
	3KjHZR8mfQOOQ+GVyIsYvAaqvbTaTua9AHD53Xds5wDp5H0I4Z/eDVvREc/UqzE=
X-Google-Smtp-Source: AGHT+IGMxuLpMKjIuYdJYrob79SDg2RZvql0ouDIgVaa+eFVMNZbWP3rPhPLCBOfG/l5X2eomxjBsA==
X-Received: by 2002:a05:6808:300f:b0:3d2:2b8e:a7e2 with SMTP id 5614622812f47-3d51baf503fmr6570385b6e.48.1718925224517;
        Thu, 20 Jun 2024 16:13:44 -0700 (PDT)
Received: from localhost ([136.62.192.75])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3d5344de45bsm86185b6e.3.2024.06.20.16.13.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 16:13:44 -0700 (PDT)
From: Sam Protsenko <semen.protsenko@linaro.org>
To: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>
Cc: Anand Moon <linux.amoon@gmail.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 6/6] hwrng: exynos: Enable Exynos850 support
Date: Thu, 20 Jun 2024 18:13:39 -0500
Message-Id: <20240620231339.1574-7-semen.protsenko@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240620231339.1574-1-semen.protsenko@linaro.org>
References: <20240620231339.1574-1-semen.protsenko@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add Exynos850 compatible and its driver data. It's only possible to
access TRNG block via SMC calls in Exynos850, so specify that fact using
EXYNOS_SMC flag in the driver data.

Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Łukasz Stelmach <l.stelmach@samsung.com>
---
Changes in v3:
  - Added R-b tag from Krzysztof
  - Added A-b tag from Łukasz

Changes in v2:
  - Changed QUIRK_SMC to EXYNOS_SMC to reflect the name change in the
    previous patch

 drivers/char/hw_random/exynos-trng.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_random/exynos-trng.c
index 9fa30583cc86..9f039fddaee3 100644
--- a/drivers/char/hw_random/exynos-trng.c
+++ b/drivers/char/hw_random/exynos-trng.c
@@ -320,6 +320,9 @@ static DEFINE_SIMPLE_DEV_PM_OPS(exynos_trng_pm_ops, exynos_trng_suspend,
 static const struct of_device_id exynos_trng_dt_match[] = {
 	{
 		.compatible = "samsung,exynos5250-trng",
+	}, {
+		.compatible = "samsung,exynos850-trng",
+		.data = (void *)EXYNOS_SMC,
 	},
 	{ },
 };
-- 
2.39.2

