Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BB314D714
	for <linux-crypto@vger.kernel.org>; Thu, 20 Jun 2024 23:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718925225; cv=none; b=lbyWTdUkArdvhvNH2J3C3Vk8NHHlWqVQ8V+g1K5P0doDIv4Cl9pBMiBP4Pb6Wt5pJUFPm0vfBsnBYnSvnOR0uxXbmTxAp0A/2sdtNK2boQVwNVdAyRX6sJHXGcKnvb+txqw+FVBXCDX1TzJTnu2zyrXeFyyUW1vrsNSOp/8nheA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718925225; c=relaxed/simple;
	bh=voI/H6TF7EA0lAJZzYE8tRGijdTZkwmqvJoOJbix1bE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YDibCynUAUE59CIQmQNHyK8FQF61ky+r8UfxNL4Z9KZyNpDNd8HaxbFR1MMjxAiWyK4lxwFQCgwZCKctNO+L15J3WvnzQgvc2sPfp0fWd0cEOsNEhb7iPlHBgV8FmdnKlJx/j5PbHCO+43skfRkQnKdsboQOK8T+xd83rUyTebA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eej2cq7X; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eej2cq7X"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-6f99555c922so803989a34.3
        for <linux-crypto@vger.kernel.org>; Thu, 20 Jun 2024 16:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718925223; x=1719530023; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3cJgtDYRGnxNR5uxsP8R2aMDXQF4TAj9PgQdzrH0jxc=;
        b=eej2cq7XYG8Ik10gqgI3xWhQhqA+rpPstrL7bzo6/HlI3M6ePNkIIVdaL7nVDNNXUp
         rrNyIi8ZZWoeLfND/aZCGwpHOEpbbTue1UWoi/XzJQRU1goJeZUY2F1zYBBusU1Me60Y
         QXeUuQEpOmAXL/YLZoQdGG6cjIjDebCZNlclwHwH/XJxiflHLr/RBtiQljCxaMZ+9jaK
         b3od2k5vTGHkZBNPT4bfxDE6S2vh4dBup19pB5eLiskkeGo1PZhjLpMjJPDM2fmvhE7I
         OPlea33X6cEBgBhnyfP9geedEsYq29ajC/8CKu6+DLDkbB7Zn4Tq8aC/P8FGANuan7Bz
         Qf0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718925223; x=1719530023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3cJgtDYRGnxNR5uxsP8R2aMDXQF4TAj9PgQdzrH0jxc=;
        b=j6jlxv9ZYlo1AHaibiu5bQTA8M5RldwoDvGT2B7xapT0SnXWzaRfVEERTuPpychgIe
         R/Fuej9qwT4m2NttlRBlUhbrPFd2dF8rZ8Y1H4F2oYJRwc84lNIVu2YagYnjUFbqpzWy
         Xpo51IzXoe1vpbWONlLNNto1Hq2L5+xAhUPUg9O33QQWU92gSs0XI+lnFiOY4sGfKTa+
         aQPMUb9tRek188KiQQs3hJ2tPUSuiUUpOYgilnFdO6q09EEnyU1n4czt7d+5Mw0Fld4B
         pVpgvfUYGIKEtUk1/nQKyo9NTgENy0240eHcleKLRNAdHyOt/ZKsBhdE22UbZ4xrOF5m
         80Zg==
X-Forwarded-Encrypted: i=1; AJvYcCWJJNuQbbJ1TaLaxtO5wA2ZBNIT6GtbWGN/MIwPIlH2qV0Ej0P1T5F4ryEDK6ww3BY0+4oXT9wFNyprYwa+MkF32lnLkjyL4joK4YwS
X-Gm-Message-State: AOJu0YwjYf5s9KT7pc8WDInrTOZQr/n+Kj8JDnV1bswzkNZR4hM3owjj
	n/mTR+/qe4jCYHX9/tV2e8t3lTk7XHLWcx1N/HadiCkEcCuwpV9EqREbJaxkVXs=
X-Google-Smtp-Source: AGHT+IFo/CfULEDzNMn3svBf7fPxTFvjTmzdPpeV1CFsheF7Pw04fqkYLYCT/ue0ZcXoBsHBHlK0pA==
X-Received: by 2002:a9d:7409:0:b0:6f9:a523:403f with SMTP id 46e09a7af769-70073f20008mr7815451a34.22.1718925223095;
        Thu, 20 Jun 2024 16:13:43 -0700 (PDT)
Received: from localhost ([136.62.192.75])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7009c60a4b1sm90529a34.47.2024.06.20.16.13.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 16:13:42 -0700 (PDT)
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
Subject: [PATCH v3 4/6] hwrng: exynos: Implement bus clock control
Date: Thu, 20 Jun 2024 18:13:37 -0500
Message-Id: <20240620231339.1574-5-semen.protsenko@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240620231339.1574-1-semen.protsenko@linaro.org>
References: <20240620231339.1574-1-semen.protsenko@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some SoCs like Exynos850 might require the SSS bus clock (PCLK) to be
enabled in order to access TRNG registers. Add and handle the optional
PCLK clock accordingly to make it possible.

Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Anand Moon <linux.amoon@gmail.com>
---
Changes in v3:
  - Added missing '\n' in dev_err_probe()
  - Added R-b tag from Krzysztof
  - Added R-b tag from Anand

Changes in v2:
  - Used devm_clk_get_optional_enabled() to avoid calling
    clk_prepare_enable() for PCLK

 drivers/char/hw_random/exynos-trng.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_random/exynos-trng.c
index 997bd22f4498..6ef2ee6c9804 100644
--- a/drivers/char/hw_random/exynos-trng.c
+++ b/drivers/char/hw_random/exynos-trng.c
@@ -47,7 +47,8 @@
 struct exynos_trng_dev {
 	struct device	*dev;
 	void __iomem	*mem;
-	struct clk	*clk;
+	struct clk	*clk;	/* operating clock */
+	struct clk	*pclk;	/* bus clock */
 	struct hwrng	rng;
 };
 
@@ -141,6 +142,13 @@ static int exynos_trng_probe(struct platform_device *pdev)
 		goto err_clock;
 	}
 
+	trng->pclk = devm_clk_get_optional_enabled(&pdev->dev, "pclk");
+	if (IS_ERR(trng->pclk)) {
+		ret = dev_err_probe(&pdev->dev, PTR_ERR(trng->pclk),
+				    "Could not get pclk\n");
+		goto err_clock;
+	}
+
 	ret = devm_hwrng_register(&pdev->dev, &trng->rng);
 	if (ret) {
 		dev_err(&pdev->dev, "Could not register hwrng device.\n");
-- 
2.39.2

