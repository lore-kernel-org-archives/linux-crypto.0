Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9398C168DA
	for <linux-crypto@vger.kernel.org>; Tue, 18 Jun 2024 00:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718671069; cv=none; b=UrsMdn2PecC/aLv1Ht7AsNRMWK+ECyGICf8Rd2ykYh7tMfuLGjh2z9C2TzJaGBiTgK2yEEFtY9eqFlQmj/HNeHj8e+rxBgXPeM7po+47oeq/i+6ltAquqBS13JiWPN5jnNv4cASMLpwnpDoPvnyRKG86WpU9ZCDeYumG/ehftpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718671069; c=relaxed/simple;
	bh=0XLUBor4Wy71S2SW7ou5JiqldczfvtidDdV09ttw2Rs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rXNfjp5ZU6gMkrWwjdM51fS9uxiKKUrz/kTrgFXf6gpN9jrSPUbJwe2tXsmEQQFnBnDCWvWRCABbbW32+Tf95LqBn661UfcOfoL+6GVk5s4iwT1EEHhk47+OYuZw+8Gd2C6Gu6WRoclb9jvrz927AlLA8Jg8yfBX8fLG0W/Enew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PUtLX58D; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PUtLX58D"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-5bafcb42d28so2725010eaf.0
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2024 17:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718671066; x=1719275866; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UzEHeTFimKuQQxWwyrDcO+o5XCit+aZv+PnU9elFrsI=;
        b=PUtLX58DR5JgYvbCN1BHnB4DgXLXwGGYlNMeOGwGirio4667qdNIOIl2XkJdnkSYIf
         pwdgVyAmm5v4Zgubw9YM0UFkfKqa2ulzl0xMtZUwTTBRsOl8x2XzHHOIRGds6kanf32D
         w0AF0YmES4sqUq/Pvoz0eUnjwv/P3PyJh2JymMfeAZMv3ExNJSmu/5RLubFZ+gE0AIXx
         iqu/gyZjvIer1r74nyiiXUoDoHLSc2rsajJZ+pT4gyNmNI+1IBop0g5dAZ01GqPPwsj8
         puWx4E5QqDprxCeH72wROcvdrOE4q7SvGcpRwJooDiUDsSCTmWxshzmhup2xXJXcvWkw
         fFpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718671066; x=1719275866;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UzEHeTFimKuQQxWwyrDcO+o5XCit+aZv+PnU9elFrsI=;
        b=kMlVgKIxMqatNBZexf5dKtA/NaIHq17Mzgwd2Ps+IFAMjBiSOg77avzSNq+zpUhUJN
         nWn64zM+R9QP4paorJmH4WRtryP8uRssE5XHIjhMsP+SHSzQSjefy/1VYEEPaasHpmIu
         6zyvTlTKCqtYOcWErg0NGHNkBx8MPSWh6Ub34jc/vwLH5J/xpK1Iy6W9JEvEvHQ0J85V
         pOSavCpgorA0f9TdJpeffCR4OjXebgV47dZnjyRadvS5V7A6E9rlNABJaFIZko7Ak9va
         6+DqAA2Ho5sndPMEp/BJr2IH1/PdDoDNJG2TLKXCKWqKrjXBYJS+53JO+skMNKAt79sZ
         79KA==
X-Forwarded-Encrypted: i=1; AJvYcCXxQg0fY1s5sJXJe9tT4rXRw/IR989IAqGS9U2vzv0FcotpRURSGrK6xg4OpPkQoM7lS66t7hWI9QQ7G763XqF1pTw/QSjCbTzRQAi3
X-Gm-Message-State: AOJu0YzaQJRzwaCs1OoNj4EdgmxYmshpkBHrMTT430nHVKUDy3IR3sIi
	j6NZaaUJVsUQi8NUp2qUwlEe2/uTMImicmcoKvVKhmyX7iBomYb/3CbCQe1Pf2w=
X-Google-Smtp-Source: AGHT+IGfQPJkGUEmf7bvL5EHIQMFh2lzC9gdoJFes+mvAbebBn2gmOigq0ygMHUP4CBQUyY/zDxPJA==
X-Received: by 2002:a05:6820:80c:b0:5ba:f20c:361b with SMTP id 006d021491bc7-5bdadc84948mr13508706eaf.8.1718671066504;
        Mon, 17 Jun 2024 17:37:46 -0700 (PDT)
Received: from localhost ([136.62.192.75])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5bd5f2a1801sm1216364eaf.37.2024.06.17.17.37.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jun 2024 17:37:46 -0700 (PDT)
From: Sam Protsenko <semen.protsenko@linaro.org>
To: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] hwrng: exynos: Implement bus clock control
Date: Mon, 17 Jun 2024 19:37:40 -0500
Message-Id: <20240618003743.2975-5-semen.protsenko@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240618003743.2975-1-semen.protsenko@linaro.org>
References: <20240618003743.2975-1-semen.protsenko@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some SoCs like Exynos850 might require the SSS bus clock (PCLK) to be
enabled in order to access TRNG registers. Add and handle optional PCLK
clock accordingly to make it possible.

Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
---
 drivers/char/hw_random/exynos-trng.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_random/exynos-trng.c
index 88a5088ed34d..4520a280134c 100644
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
 
@@ -141,10 +142,23 @@ static int exynos_trng_probe(struct platform_device *pdev)
 		goto err_clock;
 	}
 
+	trng->pclk = devm_clk_get_optional(&pdev->dev, "pclk");
+	if (IS_ERR(trng->pclk)) {
+		ret = dev_err_probe(&pdev->dev, PTR_ERR(trng->pclk),
+				    "cannot get pclk");
+		goto err_clock;
+	}
+
+	ret = clk_prepare_enable(trng->pclk);
+	if (ret) {
+		dev_err(&pdev->dev, "Could not enable the pclk.\n");
+		goto err_clock;
+	}
+
 	ret = clk_prepare_enable(trng->clk);
 	if (ret) {
 		dev_err(&pdev->dev, "Could not enable the clk.\n");
-		goto err_clock;
+		goto err_clock_enable;
 	}
 
 	ret = devm_hwrng_register(&pdev->dev, &trng->rng);
@@ -160,6 +174,9 @@ static int exynos_trng_probe(struct platform_device *pdev)
 err_register:
 	clk_disable_unprepare(trng->clk);
 
+err_clock_enable:
+	clk_disable_unprepare(trng->pclk);
+
 err_clock:
 	pm_runtime_put_noidle(&pdev->dev);
 
@@ -174,6 +191,7 @@ static void exynos_trng_remove(struct platform_device *pdev)
 	struct exynos_trng_dev *trng = platform_get_drvdata(pdev);
 
 	clk_disable_unprepare(trng->clk);
+	clk_disable_unprepare(trng->pclk);
 
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-- 
2.39.2

