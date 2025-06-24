Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45632D1319;
	Tue, 24 Jun 2025 13:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750773191; cv=none; b=kOBlzePLu3xVenDrvhKMJNpN7C2bWUVshKLrQ/KyhW/U5tvteK8qnc3+N+XBYP1ylfHSH8XtP/emohaSBzwxktUudSlWt5s27efTUj6rc3xhmWkHYx3hNbVXxzPQPG/bCchx6VxHLLT0XQHg7MKpvRO7ysGCKi0LpV4P+hdZf3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750773191; c=relaxed/simple;
	bh=uNX7wkKnDVwTfeF+Q3nPk1uUrBA9eGeCjEZk/snRgyQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ABIvXaTegLxcWu7SKlQKrp5Ahzynls0ZixRD2fSlMaxFv1j+7WXsJu3V+6vOEWJ3MREd+GaelNXvKNUZr7soBMNo48NIE9p6GFu5WqRIsIhtoWCgqawf/IftqAat80j17gh+lHuh1Y7AezbF4KRf3i8RHq07chFiBjqdFHCrgZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cSatnkW6; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cSatnkW6"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-553dceb342fso414057e87.0;
        Tue, 24 Jun 2025 06:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750773188; x=1751377988; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wN4giaX3vmqVUZtbZtIjALAYwpEYzbdeOb30EYe4QKU=;
        b=cSatnkW6js1s0Arc1MbkqwChOY4e0P7abJUAyNT1wlRYUvx9k2/2VFHjp/wQ52RgW0
         wimDno+8uizWss7c+tRhuRhWo107KqkRS5dORQWEF97Z0kgnEvcsYeCIGqFibs6BEiS7
         p7pjKo0JZxak6PfIHFf88k4MHeaXewKWz0nEHYm5rTD8+Ww8d3EO158ODb/N7xtrOVIC
         PUyg3ofEuVL3eiF/eXybgnMDTdaS0xezh4aeCoteM02KKoIr+AzvoyMrw+ixBNbYGD1a
         Q9dMLJzZW2D+oJgu0ro+ka0aPASuIgDVV+oZW9gIIgXXg+yvuryg/vp84Baq2UKu4yQK
         xR+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750773188; x=1751377988;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wN4giaX3vmqVUZtbZtIjALAYwpEYzbdeOb30EYe4QKU=;
        b=A0IBh8hAzv7uUEkAkJbbE4pRqd29Zo1yv8Av8axdnldkvOqNi0tQIqqtKcTUGwFVlL
         q4oJgmO9iP5ULjxgc/atYJiudKp+splAFKg9zq+9gJi1RI1+fhA4NNOPsyHxKAWIw0dz
         EfKj853ubDYzSVspz3BusAo9sx1yf0a4LOrKlP/JVIvFj13tQIu3qsAqDOYX796Q0Ubj
         5FFRfzfnov04KEVNb30RHsJrPGcgxEYf8G79M6ftuQozQxtCIVmDqNpda7wzNnW+FDf8
         zQmXgP2boTHyTsFw/ldha1HZzl56f4VErfvVyM4O3buCb/aIwic3yyBxLxvi1VMC0G8+
         4CVQ==
X-Forwarded-Encrypted: i=1; AJvYcCUdf4Qvuo5eKgAhPHWWBWM3VNPjEhXaHA3Z3z+bkuMzZ76AaQfOn+qjL1ISsVB6YZkymSTtkmTxqP8U@vger.kernel.org, AJvYcCXpfGq+/PZLSjpWsgsWvIzGZ+tSdK4trB/AeV1cUWTBzwpyV+7HaSgVM5LniUsCKk3GH/iG1tQ71p1iVkRX@vger.kernel.org
X-Gm-Message-State: AOJu0YxEjFwFvg9uQeFcGpNaAfcIbLv13jEOkYAKG267eSxn+CO6b+rU
	/NM2EfSOTxzFGbk7jphA6lUSqdjPnDigAv2q0buoj9ePwsH+LZILtOOo
X-Gm-Gg: ASbGnctW4Pwe4U+/aJYbdV9w5w0UGeBPw+IryRRJKQ5ztwr8cdksNofZop7J8s8/nhI
	g4gUdLXd+FXbVmEXzVJA0r6XpekDlxd9RGUSZELrzJBjbMs/jccFbSh/HIxjnZwPQjIuOpZV8kF
	gurDUVkKR/T5M+oocEASrWJxqK8YnG1kzXCmkXW+4zt8d774EW3KWuu6bdMo6oD7ERnxLbqQw7m
	L0PnmWSwK70FNbeel5NUdKB7ErmcYgQJmp4WNima+Lk42USwYMBKfJpIaO3yxIAxqzEatqhl9io
	HMgb1qn5Fxi6Gl5AQOpwtwVcfVWg8qPSjeyZBQy+HYEI8J2SPIjIK1V0pJXeY7pAxjQMKGxVvkG
	IzEJAfNSplNhbgKBLnTCjeJ0fFzuPWh5CT7QaGgfYmxik1TSieuYlxBIh8srtPg==
X-Google-Smtp-Source: AGHT+IGvmJuGS3IZ/uyOBYmFaf2eCOHsx/MrEv4aHYhplNKbOds3Lba3ShwHOK3DV9og2hdief5A/w==
X-Received: by 2002:a05:6512:a89:b0:553:35ad:2f45 with SMTP id 2adb3069b0e04-553e3cfec05mr5091992e87.50.1750773187422;
        Tue, 24 Jun 2025 06:53:07 -0700 (PDT)
Received: from user-A520M-DS3H.sberdevices.ru (broadband-188-32-30-96.ip.moscow.rt.ru. [188.32.30.96])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-554e6dc186esm1282905e87.114.2025.06.24.06.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 06:53:06 -0700 (PDT)
From: Alexey Romanov <romanov.alexey2000@gmail.com>
To: neil.armstrong@linaro.org,
	clabbe@baylibre.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	khilman@baylibre.com,
	jbrunet@baylibre.com,
	martin.blumenstingl@googlemail.com
Cc: linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Alexey Romanov <romanov.alexey2000@gmail.com>
Subject: [PATCH v12 03/22] crypto: amlogic - Remove clock input
Date: Tue, 24 Jun 2025 16:51:55 +0300
Message-Id: <20250624135214.1355051-4-romanov.alexey2000@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250624135214.1355051-1-romanov.alexey2000@gmail.com>
References: <20250624135214.1355051-1-romanov.alexey2000@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Amlogic crypto IP, which uses DMA crypto engine,
doesn't take a clock input.

Fixes: 48fe583fe541 ("crypto: amlogic - Add crypto accelerator for amlogic GXL")
Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
---
 drivers/crypto/amlogic/amlogic-gxl-core.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index d7e455f73c04..90b539401b71 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -9,7 +9,6 @@
 
 #include <crypto/engine.h>
 #include <crypto/internal/skcipher.h>
-#include <linux/clk.h>
 #include <linux/dma-mapping.h>
 #include <linux/err.h>
 #include <linux/interrupt.h>
@@ -267,19 +266,6 @@ static int meson_crypto_probe(struct platform_device *pdev)
 	if (IS_ERR(mc->base))
 		return PTR_ERR(mc->base);
 
-	mc->busclk = devm_clk_get(&pdev->dev, "blkmv");
-	if (IS_ERR(mc->busclk)) {
-		err = PTR_ERR(mc->busclk);
-		dev_err(&pdev->dev, "Cannot get core clock err=%d\n", err);
-		return err;
-	}
-
-	err = clk_prepare_enable(mc->busclk);
-	if (err != 0) {
-		dev_err(&pdev->dev, "Cannot prepare_enable busclk\n");
-		return err;
-	}
-
 	err = meson_allocate_chanlist(mc);
 	if (err)
 		goto error_flow;
@@ -304,7 +290,6 @@ static int meson_crypto_probe(struct platform_device *pdev)
 	meson_unregister_algs(mc);
 error_flow:
 	meson_free_chanlist(mc, mc->flow_cnt - 1);
-	clk_disable_unprepare(mc->busclk);
 	return err;
 }
 
@@ -319,8 +304,6 @@ static void meson_crypto_remove(struct platform_device *pdev)
 	meson_unregister_algs(mc);
 
 	meson_free_chanlist(mc, mc->flow_cnt - 1);
-
-	clk_disable_unprepare(mc->busclk);
 }
 
 static const struct meson_pdata meson_gxl_pdata = {
-- 
2.34.1

