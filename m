Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7F3176AB4
	for <linux-crypto@vger.kernel.org>; Tue, 18 Jun 2024 20:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718743529; cv=none; b=cr/9t8WkTiAOFnIGAsQy4ZQy8+cLUhSWEsN4/rBlGDpYRtJNds8KDd/QWPaFswM3H3zIMQN1t6EPiWt3pP1E8z0Qn3eaDceR708UlL9fUB12RBhrlp2wHZMB/Q5I7ogqGxfbc1FggKob7OKs+Lt9935ccUSKO7RL7x+/Dlqe3No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718743529; c=relaxed/simple;
	bh=sT0sL+RgnVg+AcQBnBOs3VMjWsZ2hzrqXKz/8cJCc5Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Wg85xIMbI0W6HOkwt/3d/qib5KSnAxcwsVRrZbq7m0E6qZmkno13x6uHIYAlTcXDG+gxcVDDmB6G6psZY4IyEqaC8wYQ7Azj2DQifbb4h+a6lfBKrm7vB8mHdgLRZephhIQrNTsiUzn+ZdhC+w2pCUS2/Z7ASLZv9YoTEZFpxns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tFfjpUMC; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tFfjpUMC"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-6f9a4f9923aso3263372a34.0
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jun 2024 13:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718743526; x=1719348326; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0aRxOAD2Qgk5Lly7g3t86NVGFyqjyCN/MyLZiIAVgHs=;
        b=tFfjpUMCoTEIxTtYITK2ouVif7oQGDFsXuGPjH5Z2yG/pst/U9bLYzawApH1QPvjY+
         jMH2f/umE6iK9aSiNKWSAOitylJDmkzJ4+oX+Qgd3OUhRVNVshWc0Sv352thIostt54N
         +d1INApBiKOKOCKxVeG/Sy7A90BACt+TumHrMNxkuf+6To+2CyQS1/5iO2XkbNw5ydqG
         rE8mF+AAo1xoil1fssubZ2Dk2XY+LJVnf0gzDUq6iGBYMyVv6hGM9OwTJuy0B8IVpVEb
         nIq+TQ0GR4aMTEq7236TuTD5hrptq08T6dzcVpXoxvwB+4xuxnUmn+iUmOCc4I3zY2fA
         /oVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718743526; x=1719348326;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0aRxOAD2Qgk5Lly7g3t86NVGFyqjyCN/MyLZiIAVgHs=;
        b=aSa7WZ6K7tMPca3EEUBpgEkE4zRTyvMxJSM0CvwDJyeTHmBWwAzsMx4FEQ9AbEwPK+
         usmYY6cyDyZI2VRNaWOs3DW6JzNGA5cd6jXSB/7Ck+DkKS2sNVThmeWftkL7clGqputJ
         cmZL3YERF/WuN9wdqFjjdBZrZN3n6dyfqeY2htiMzmlQzIgbEdPkibhgztaG1+nnpss3
         2VV+bdTgb96wdeELs4YhfoDuq58cnvfmW+bKcLKFNfuDvqC0EECcutjBqP2A2zRnAEKx
         ezVMYbZcTaSTsn+yHEWKVRFX3//QiqykiGdWoP35Jsv0b/XJJ2SoTGL/6KoCIUkJFV0O
         ti5w==
X-Forwarded-Encrypted: i=1; AJvYcCUp91i5mTWuxBokT1Z13btJn4dexd/wVbcDAmobiEcS5dzUSCO35CUVArHOiCK+LkbmzHe14mziwhXKBuT9uUIahuKn7+STQxyxhIcT
X-Gm-Message-State: AOJu0YyID92JLJIhvJz0i/Xh4Qn67Z+U6slVkw4XhuIivBgoscmihUMx
	xSq89VIpEcFQeazqN3M4QV/Wzx8PALTU9sD37eilMyOBtJKPL1eJGwg2xcPKxeg=
X-Google-Smtp-Source: AGHT+IFsyuXPTcRk/B3lUM1O8/TQZfkRs+GDfXqj2NsRA9yWpG9ZWVrUspoi5rnxH+NBKKi8Gu9VmQ==
X-Received: by 2002:a05:6830:1d91:b0:6f9:c989:261c with SMTP id 46e09a7af769-700766349damr883708a34.33.1718743526611;
        Tue, 18 Jun 2024 13:45:26 -0700 (PDT)
Received: from localhost ([136.62.192.75])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-6fb97051e68sm1692599a34.80.2024.06.18.13.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jun 2024 13:45:26 -0700 (PDT)
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
Subject: [PATCH v2 3/7] hwrng: exynos: Use devm_clk_get_enabled() to get the clock
Date: Tue, 18 Jun 2024 15:45:19 -0500
Message-Id: <20240618204523.9563-4-semen.protsenko@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240618204523.9563-1-semen.protsenko@linaro.org>
References: <20240618204523.9563-1-semen.protsenko@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use devm_clk_get_enabled() helper instead of calling devm_clk_get() and
then clk_prepare_enable(). It simplifies the error handling and makes
the code more compact. Also use dev_err_probe() to handle possible
-EPROBE_DEFER errors if the clock is not available yet.

Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
---
Changes in v2:
  - No changes (it's a new patch added in v2)

 drivers/char/hw_random/exynos-trng.c | 21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_random/exynos-trng.c
index 88a5088ed34d..91c210d80a3d 100644
--- a/drivers/char/hw_random/exynos-trng.c
+++ b/drivers/char/hw_random/exynos-trng.c
@@ -134,32 +134,23 @@ static int exynos_trng_probe(struct platform_device *pdev)
 		goto err_pm_get;
 	}
 
-	trng->clk = devm_clk_get(&pdev->dev, "secss");
+	trng->clk = devm_clk_get_enabled(&pdev->dev, "secss");
 	if (IS_ERR(trng->clk)) {
-		ret = PTR_ERR(trng->clk);
-		dev_err(&pdev->dev, "Could not get clock.\n");
-		goto err_clock;
-	}
-
-	ret = clk_prepare_enable(trng->clk);
-	if (ret) {
-		dev_err(&pdev->dev, "Could not enable the clk.\n");
+		ret = dev_err_probe(&pdev->dev, PTR_ERR(trng->clk),
+				    "Could not get clock");
 		goto err_clock;
 	}
 
 	ret = devm_hwrng_register(&pdev->dev, &trng->rng);
 	if (ret) {
 		dev_err(&pdev->dev, "Could not register hwrng device.\n");
-		goto err_register;
+		goto err_clock;
 	}
 
 	dev_info(&pdev->dev, "Exynos True Random Number Generator.\n");
 
 	return 0;
 
-err_register:
-	clk_disable_unprepare(trng->clk);
-
 err_clock:
 	pm_runtime_put_noidle(&pdev->dev);
 
@@ -171,10 +162,6 @@ static int exynos_trng_probe(struct platform_device *pdev)
 
 static void exynos_trng_remove(struct platform_device *pdev)
 {
-	struct exynos_trng_dev *trng = platform_get_drvdata(pdev);
-
-	clk_disable_unprepare(trng->clk);
-
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 }
-- 
2.39.2

