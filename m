Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D037A1E5718
	for <linux-crypto@vger.kernel.org>; Mon, 21 Oct 2024 10:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507749; cv=none; b=a8nwt0UdHo6V3oPsA0vT4EQ+6P1JCrv3ngoYpoZOq4mdPuBvQB4XiJ8IPWPNRSdyfUhUBdS9v/wd2qS1bicJZF2B5CYLP+ZifK1dedBs10VFueYVSgIR4SQuj7bvlNkUqT2UBqGSD97WXxVkZDBAmK4gqzTnMpDnmIjWuwcGg0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507749; c=relaxed/simple;
	bh=qDfLDiY9pJBEPkTk46q1s0eEmVhGbOO8bvw3rrpuQxU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MdR4p5fQH50g2wgKyh3W+hcHAs6JmY38PSgGXz+r+W5Z6J0oyv2MdZLLcidNMfZuXYjCkMYZsbhHMJKpbuZIsxrO9mYEWox0OpKIf+ZO0ueNfTn7mVR0Sqan8Yxe+nKxaOGM2btrZM1M7RjgiKpOpjqV/BhYs25BBmbnntw9NbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=VIzQP8r+; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="VIzQP8r+"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4316f3d3c21so12816645e9.3
        for <linux-crypto@vger.kernel.org>; Mon, 21 Oct 2024 03:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1729507744; x=1730112544; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1Atr2m7zdIM0Y1v/AdZCEMRn04z6/SRPDkUDeR2023s=;
        b=VIzQP8r+38ozAPOzT4DWPBYL76Ga8TgR4rjOHd3XXJgMhnHZRbQTyNBSrp1LSRXbZv
         19idXXEBMKlLUXLt+tPh2raEGDijGV91Dofz1iLo/iX/g6Fs3vWE27ZcGFTZGQpf6Qdz
         CSy9lFNnOW7W7bEMQX+Ut8b+dsRnGkUOvSB//moJI4AJO/Z2c3SUeZO+w1/jR7YoIvNO
         jV/oI4CpNUFcTA8sQ67LKfGGIgnBS4Zd0qk4Y4fTfbcn0XSUKOQyNHe79w2dPZF45EzK
         lRiNl9bUuv0eTdP4uTFTH8D6Y5HC1nD3zFrPYD8MwHvMcv83O5q12IWKqXLh/9WcxXXJ
         kdMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729507744; x=1730112544;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1Atr2m7zdIM0Y1v/AdZCEMRn04z6/SRPDkUDeR2023s=;
        b=ucJS+KYpluGJPcG34Ct+xrDbgxWyY+md2C3VEBY5Qv8ekkMUrNwGIJbVbUfh6CUVnB
         A0DyUZo/yP4r03m+kceqLoynyDUyiuoQN5wEzSRj96dDX5UdubaENlxMy2MmjU73hAdZ
         vzlmoBDHcc1XAP9Su8F6862USelTMNQkKXL7Sa9HVn7sGEWMNak1/WQ4nv8dy/opxsVd
         +O7etdNCbSxgQpTSvAu4ZYM9wE2auJ4dwRmXwRRTnU41KvEvDokgo7FuARiCETs7TaUb
         3eNRuSsZpJVzarkM4ED7kf95arlDRDCok0raMw1nsDQFMksSK3bCtO5VznVKQ00T2fEE
         ybUg==
X-Gm-Message-State: AOJu0YyYQguxfpVR7Ei9klvZYAJvFm/RgOaKp5QfL7ReiC5PM0ANbv1p
	YfQTdbPFrecbrqGuBcPDeBAVfC+ZgOTFwWiJq6LxmuO5VkuMs0nxcTXP3ZwyXJo=
X-Google-Smtp-Source: AGHT+IHXx61Ao824+Y8WM2vLZN5QENN6sFJC98E/+uQVmm2RxY9i5Zaey5ezIo/BQaibdZI+iRiB8w==
X-Received: by 2002:a05:600c:4f92:b0:430:57f2:bae2 with SMTP id 5b1f17b1804b1-4316168f5c5mr89853365e9.23.1729507744055;
        Mon, 21 Oct 2024 03:49:04 -0700 (PDT)
Received: from localhost (p50915d2d.dip0.t-ipconnect.de. [80.145.93.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4316f5c2b46sm53088555e9.36.2024.10.21.03.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2024 03:49:03 -0700 (PDT)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
Subject: [PATCH] hwrng - Switch back to struct platform_driver::remove()
Date: Mon, 21 Oct 2024 12:48:55 +0200
Message-ID: <20241021104854.411313-2-u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=7572; i=u.kleine-koenig@baylibre.com; h=from:subject; bh=qDfLDiY9pJBEPkTk46q1s0eEmVhGbOO8bvw3rrpuQxU=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBnFjGX62qO3kJT7EjC2CxQ/BiZZnNBBMsJ2NaNn wTEM6YvSZiJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZxYxlwAKCRCPgPtYfRL+ TleCB/9LLmeck9vbeliqiSZHSsaYJeyhovpWEz8n1wVRefa85NJ+4PV8gr9TQYz4gYvlyJhEqlN RJ1fvYyUbWaaz47BBOzSjp4coV5Wsv0nXx4KBxOD0IE69xnqzwOOrTPF49JoZ/sV0hOuuW+0gdN l3CqfDhNiUqnuftgppIOxaIxiyN/LU0fjuaMJkD7LifhFT7rFRFnXPRJppWZK9Wx/VqMh1LbBTU QnpOLtbiwXiGXPh3AHzZpqyB258Cki8151od/4RlTGOnRmXVJPwW8QECN7lWSxItxmC9Lx461QI L+E54PNGk94Ak1TLaUXD1MESq3Jpx0jaN37gSQ0QrUAwtgrz
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

After commit 0edb555a65d1 ("platform: Make platform_driver::remove()
return void") .remove() is (again) the right callback to implement for
platform drivers.

Convert all platform drivers below drivers/char/hw_random to use
.remove(), with the eventual goal to drop struct
platform_driver::remove_new(). As .remove() and .remove_new() have the
same prototypes, conversion is done by just changing the structure
member name in the driver initializer.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
---
Hello,

given the simplicity of the individual changes I do this all in a single
patch. I you don't agree, please tell and I will happily split it.

It's based on today's next, feel free to drop changes that result in a
conflict when you come around to apply this. I'll care for the fallout
at a later time then. (Having said that, if you use b4 am -3 and git am
-3, there should be hardly any conflict.)

Note I didn't Cc: all the individual driver maintainers to not trigger
sending limits and spam filters.

Best regards
Uwe

 drivers/char/hw_random/atmel-rng.c      | 2 +-
 drivers/char/hw_random/cctrng.c         | 2 +-
 drivers/char/hw_random/exynos-trng.c    | 2 +-
 drivers/char/hw_random/ingenic-rng.c    | 2 +-
 drivers/char/hw_random/ks-sa-rng.c      | 2 +-
 drivers/char/hw_random/mxc-rnga.c       | 2 +-
 drivers/char/hw_random/n2-drv.c         | 2 +-
 drivers/char/hw_random/npcm-rng.c       | 2 +-
 drivers/char/hw_random/omap-rng.c       | 2 +-
 drivers/char/hw_random/stm32-rng.c      | 2 +-
 drivers/char/hw_random/timeriomem-rng.c | 2 +-
 drivers/char/hw_random/xgene-rng.c      | 2 +-
 12 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
index e9157255f851..143406bc6939 100644
--- a/drivers/char/hw_random/atmel-rng.c
+++ b/drivers/char/hw_random/atmel-rng.c
@@ -216,7 +216,7 @@ MODULE_DEVICE_TABLE(of, atmel_trng_dt_ids);
 
 static struct platform_driver atmel_trng_driver = {
 	.probe		= atmel_trng_probe,
-	.remove_new	= atmel_trng_remove,
+	.remove		= atmel_trng_remove,
 	.driver		= {
 		.name	= "atmel-trng",
 		.pm	= pm_ptr(&atmel_trng_pm_ops),
diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
index 4c50efc46483..4db198849695 100644
--- a/drivers/char/hw_random/cctrng.c
+++ b/drivers/char/hw_random/cctrng.c
@@ -653,7 +653,7 @@ static struct platform_driver cctrng_driver = {
 		.pm = &cctrng_pm,
 	},
 	.probe = cctrng_probe,
-	.remove_new = cctrng_remove,
+	.remove = cctrng_remove,
 };
 
 module_platform_driver(cctrng_driver);
diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_random/exynos-trng.c
index 9f039fddaee3..02e207c09e81 100644
--- a/drivers/char/hw_random/exynos-trng.c
+++ b/drivers/char/hw_random/exynos-trng.c
@@ -335,7 +335,7 @@ static struct platform_driver exynos_trng_driver = {
 		.of_match_table = exynos_trng_dt_match,
 	},
 	.probe = exynos_trng_probe,
-	.remove_new = exynos_trng_remove,
+	.remove = exynos_trng_remove,
 };
 
 module_platform_driver(exynos_trng_driver);
diff --git a/drivers/char/hw_random/ingenic-rng.c b/drivers/char/hw_random/ingenic-rng.c
index 2f9b6483c4a1..bbfd662d25a6 100644
--- a/drivers/char/hw_random/ingenic-rng.c
+++ b/drivers/char/hw_random/ingenic-rng.c
@@ -132,7 +132,7 @@ MODULE_DEVICE_TABLE(of, ingenic_rng_of_match);
 
 static struct platform_driver ingenic_rng_driver = {
 	.probe		= ingenic_rng_probe,
-	.remove_new	= ingenic_rng_remove,
+	.remove		= ingenic_rng_remove,
 	.driver		= {
 		.name	= "ingenic-rng",
 		.of_match_table = ingenic_rng_of_match,
diff --git a/drivers/char/hw_random/ks-sa-rng.c b/drivers/char/hw_random/ks-sa-rng.c
index 36c34252b4f6..d8fd8a354482 100644
--- a/drivers/char/hw_random/ks-sa-rng.c
+++ b/drivers/char/hw_random/ks-sa-rng.c
@@ -261,7 +261,7 @@ static struct platform_driver ks_sa_rng_driver = {
 		.of_match_table = ks_sa_rng_dt_match,
 	},
 	.probe		= ks_sa_rng_probe,
-	.remove_new	= ks_sa_rng_remove,
+	.remove		= ks_sa_rng_remove,
 };
 
 module_platform_driver(ks_sa_rng_driver);
diff --git a/drivers/char/hw_random/mxc-rnga.c b/drivers/char/hw_random/mxc-rnga.c
index f01eb95bee31..e3fcb8bcc29b 100644
--- a/drivers/char/hw_random/mxc-rnga.c
+++ b/drivers/char/hw_random/mxc-rnga.c
@@ -188,7 +188,7 @@ static struct platform_driver mxc_rnga_driver = {
 		.of_match_table = mxc_rnga_of_match,
 	},
 	.probe = mxc_rnga_probe,
-	.remove_new = mxc_rnga_remove,
+	.remove = mxc_rnga_remove,
 };
 
 module_platform_driver(mxc_rnga_driver);
diff --git a/drivers/char/hw_random/n2-drv.c b/drivers/char/hw_random/n2-drv.c
index 1b49e3a86d57..ea6d5599242f 100644
--- a/drivers/char/hw_random/n2-drv.c
+++ b/drivers/char/hw_random/n2-drv.c
@@ -858,7 +858,7 @@ static struct platform_driver n2rng_driver = {
 		.of_match_table = n2rng_match,
 	},
 	.probe		= n2rng_probe,
-	.remove_new	= n2rng_remove,
+	.remove		= n2rng_remove,
 };
 
 module_platform_driver(n2rng_driver);
diff --git a/drivers/char/hw_random/npcm-rng.c b/drivers/char/hw_random/npcm-rng.c
index bce8c4829a1f..9ff00f096f38 100644
--- a/drivers/char/hw_random/npcm-rng.c
+++ b/drivers/char/hw_random/npcm-rng.c
@@ -176,7 +176,7 @@ static struct platform_driver npcm_rng_driver = {
 		.of_match_table = of_match_ptr(rng_dt_id),
 	},
 	.probe		= npcm_rng_probe,
-	.remove_new	= npcm_rng_remove,
+	.remove		= npcm_rng_remove,
 };
 
 module_platform_driver(npcm_rng_driver);
diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index 4914a8720e58..5e8b50f15db7 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -558,7 +558,7 @@ static struct platform_driver omap_rng_driver = {
 		.of_match_table = of_match_ptr(omap_rng_of_match),
 	},
 	.probe		= omap_rng_probe,
-	.remove_new	= omap_rng_remove,
+	.remove		= omap_rng_remove,
 };
 
 module_platform_driver(omap_rng_driver);
diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index 9d041a67c295..b4d6ffb7dded 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -565,7 +565,7 @@ static struct platform_driver stm32_rng_driver = {
 		.of_match_table = stm32_rng_match,
 	},
 	.probe = stm32_rng_probe,
-	.remove_new = stm32_rng_remove,
+	.remove = stm32_rng_remove,
 };
 
 module_platform_driver(stm32_rng_driver);
diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
index 65b8260339f5..7174bfccc7b3 100644
--- a/drivers/char/hw_random/timeriomem-rng.c
+++ b/drivers/char/hw_random/timeriomem-rng.c
@@ -193,7 +193,7 @@ static struct platform_driver timeriomem_rng_driver = {
 		.of_match_table	= timeriomem_rng_match,
 	},
 	.probe		= timeriomem_rng_probe,
-	.remove_new	= timeriomem_rng_remove,
+	.remove		= timeriomem_rng_remove,
 };
 
 module_platform_driver(timeriomem_rng_driver);
diff --git a/drivers/char/hw_random/xgene-rng.c b/drivers/char/hw_random/xgene-rng.c
index 642d13519464..39acaa503fec 100644
--- a/drivers/char/hw_random/xgene-rng.c
+++ b/drivers/char/hw_random/xgene-rng.c
@@ -375,7 +375,7 @@ MODULE_DEVICE_TABLE(of, xgene_rng_of_match);
 
 static struct platform_driver xgene_rng_driver = {
 	.probe = xgene_rng_probe,
-	.remove_new = xgene_rng_remove,
+	.remove = xgene_rng_remove,
 	.driver = {
 		.name		= "xgene-rng",
 		.of_match_table = xgene_rng_of_match,
-- 
2.45.2

