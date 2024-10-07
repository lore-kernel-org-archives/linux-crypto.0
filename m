Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358E281727
	for <linux-crypto@vger.kernel.org>; Mon,  7 Oct 2024 20:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728334734; cv=none; b=M9Uh/ibcjeaVqeoM7/PMHqiogjWp7pkJ8aUMddNmlpXVoEtBljMzdRIB+nOBkzpIgI7rn0rniKxwSvOEbZWdc/19IBb54NGelICN5VpfLRicl2H65LzmR0yehuBB6Iy+2r2Ie1aFd4JLF+T8RdoIMqE258Nltp4uxbOZwuVip/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728334734; c=relaxed/simple;
	bh=TduwfcOKUvyTUdP+3PnrGyrnAJLlw6RPlj/IjtNr2jE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rs5F9M32+cKE0weMonhLI8j+mFx/OLvUM7sY4xAuRg/H54Vhs1i8EKFfUuURv1AUDqwPZ0uam8+sSQvQ62IY2bO08Nx0UVmmusaiiArcEqTpjO3wpKW6CmxZnGA1zqunIzYyrcs8II7+JpKLbFsAkK1ZRIpXDds9Fv4peOsucX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=cdZ9I8gY; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="cdZ9I8gY"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5398b589032so7379109e87.1
        for <linux-crypto@vger.kernel.org>; Mon, 07 Oct 2024 13:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1728334729; x=1728939529; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9dtcxQGm+gJHrWxb3Ewo9TAVXJVxiDC48tDeW68ILjs=;
        b=cdZ9I8gYbnSg+0whyQn0bT26hecG0YZMDbgkSbMR9rEV8PEPbK5njAVT1YmqncZ6mg
         RZ9nROFIDrzFE9+rzcr0Q4IlpKP6wxQE9PQmHpDlMuOr/yQC2+OlB8vVy0nVg9wDxEMX
         /B8PSJ6Uh6Uc8a7e9pcgD1TPOyBUw2hEF5IhTweKPIUE1/RPZRUcVeesiOWskZdKI3mQ
         HF0p4IM9xbPT2YoSZQafNCefTLQbp5/0RxQ7HYb+RpO6enKi+5SqhdFWQaTYH7Nlvc+H
         sCsgyuAdZdI4XVeIDzXsGnosgOIrkFqdsZ05XV42FWxJKxZOzSICXJp4F25eCHaqfYnP
         yRWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728334729; x=1728939529;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9dtcxQGm+gJHrWxb3Ewo9TAVXJVxiDC48tDeW68ILjs=;
        b=qmJQ+eYTHzm+Eovb68/brUWxNaMOZ34PQdM9p7mbg/rfJpxPEIchBFrX9hNgaG1m3P
         8vh/EZKG5HcFgK3HpCNpdp609VhiBby0KTad48P39tOSAH/zSAb8joM8m/6t9UQHZynU
         qxwtSqiACXkweWae+RUxesRlUD5u2/UonxH/RejBJ5B9+IamN5PJMKzWRJmrHqLHlfIN
         M1i0IrP5hISq71kTgj3bC5aNKR48IMET4T0NiVzu2FyS8OD32yIsj3SPK3JImx12ta23
         r8/DWAq4sKeogPrbSq/468ic85QmlSRbew+71LF646hJ+yDmTb3YHuTzacON6FmbSMfv
         Il8g==
X-Gm-Message-State: AOJu0YxEhKTzAeKmPM4fQ8MfCpWrxg+1IwXTFh5FgsIVw66Qwo84jGdE
	m6nv5CTG1cCnBZ2FrvosUM5UPZyB/OQ9a7M7/gjFLUmLShyVGNZ69BrWmYE0xYqLboUSdWvBIB/
	Y
X-Google-Smtp-Source: AGHT+IFUAUIY05AQZdreq22QbLNT8+g95STwd/3PbmQ3oKYvFf7Frzo/1QQLJSL3mQBP7p3DJdamOA==
X-Received: by 2002:a05:6512:2395:b0:536:a7e0:131a with SMTP id 2adb3069b0e04-539ab87d60cmr8759373e87.26.1728334728883;
        Mon, 07 Oct 2024 13:58:48 -0700 (PDT)
Received: from localhost ([2a02:8071:b783:6940:492d:9548:aca1:239d])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a994d5745e2sm245251166b.23.2024.10.07.13.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2024 13:58:47 -0700 (PDT)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: Switch back to struct platform_driver::remove()
Date: Mon,  7 Oct 2024 22:58:06 +0200
Message-ID: <20241007205803.444994-9-u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=27399; i=u.kleine-koenig@baylibre.com; h=from:subject; bh=TduwfcOKUvyTUdP+3PnrGyrnAJLlw6RPlj/IjtNr2jE=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBnBEtkpxLXxCQBiIsYHRf+EOTWCxYs7ryqB4wxY NFj75xq2ciJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZwRLZAAKCRCPgPtYfRL+ TixPB/4jYtLQWpCJGslkoWfftxnxzSip0i1NFHXU45JGXoS8gUt7cwarfq5ZLKyLG8M471Fjinr 0eGJKJF/sM/iyklmdoIEEclxGkdESbkyYxjk+l3UtV7CkLm0mKCg6Zsl3V3C1T2rS5q8T/ALAwC skY5fypskAU4V07pf7HMXGzOCEO2M49LHxd8DhaAJRq/NO40Jf8envjY3LiMloGdm/VNQXTxYQV zXDWgbk0Dq8eCaaVEBJmihgwOYo977qCy8nFKeiuLOfq8zAJrwSahrwWo3Fx6cS3qVJuhWxg6G2 y1hhJzIvUQLQoFBefZUK5SsRjVrupds5kv8+du1jr9P9vDE/
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

After commit 0edb555a65d1 ("platform: Make platform_driver::remove()
return void") .remove() is (again) the right callback to implement for
platform drivers.

Convert all platform drivers below drivers/crypto to use .remove(), with
the eventual goal to drop struct platform_driver::remove_new(). As
.remove() and .remove_new() have the same prototypes, conversion is done
by just changing the structure member name in the driver initializer.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
---
Hello,

given the simplicity of the individual changes I do this all in a single
patch. I you don't agree, please tell and I will happily split it.

It's based on Friday's next, feel free to drop changes that result in a
conflict when you come around to apply this. I'll care for the fallout
at a later time then. (Having said that, if you use b4 am -3 and git am
-3, there should be hardly any conflict.)

Note I didn't Cc: all the individual driver maintainers to not trigger
sending limits and spam filters.

Best regards
Uwe

 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c   | 2 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c   | 2 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c   | 2 +-
 drivers/crypto/amcc/crypto4xx_core.c                | 2 +-
 drivers/crypto/amlogic/amlogic-gxl-core.c           | 2 +-
 drivers/crypto/aspeed/aspeed-acry.c                 | 2 +-
 drivers/crypto/aspeed/aspeed-hace.c                 | 2 +-
 drivers/crypto/atmel-aes.c                          | 2 +-
 drivers/crypto/atmel-sha.c                          | 2 +-
 drivers/crypto/atmel-tdes.c                         | 2 +-
 drivers/crypto/axis/artpec6_crypto.c                | 2 +-
 drivers/crypto/bcm/cipher.c                         | 2 +-
 drivers/crypto/caam/jr.c                            | 2 +-
 drivers/crypto/ccp/sp-platform.c                    | 2 +-
 drivers/crypto/ccree/cc_driver.c                    | 2 +-
 drivers/crypto/exynos-rng.c                         | 2 +-
 drivers/crypto/gemini/sl3516-ce-core.c              | 2 +-
 drivers/crypto/hisilicon/sec/sec_drv.c              | 2 +-
 drivers/crypto/hisilicon/trng/trng.c                | 2 +-
 drivers/crypto/img-hash.c                           | 2 +-
 drivers/crypto/inside-secure/safexcel.c             | 2 +-
 drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c         | 2 +-
 drivers/crypto/intel/keembay/keembay-ocs-aes-core.c | 2 +-
 drivers/crypto/intel/keembay/keembay-ocs-ecc.c      | 2 +-
 drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c | 2 +-
 drivers/crypto/marvell/cesa/cesa.c                  | 2 +-
 drivers/crypto/mxs-dcp.c                            | 2 +-
 drivers/crypto/n2_core.c                            | 4 ++--
 drivers/crypto/omap-aes.c                           | 2 +-
 drivers/crypto/omap-des.c                           | 2 +-
 drivers/crypto/omap-sham.c                          | 2 +-
 drivers/crypto/qce/core.c                           | 2 +-
 drivers/crypto/qcom-rng.c                           | 2 +-
 drivers/crypto/rockchip/rk3288_crypto.c             | 2 +-
 drivers/crypto/s5p-sss.c                            | 2 +-
 drivers/crypto/sa2ul.c                              | 2 +-
 drivers/crypto/sahara.c                             | 2 +-
 drivers/crypto/starfive/jh7110-cryp.c               | 2 +-
 drivers/crypto/stm32/stm32-crc32.c                  | 2 +-
 drivers/crypto/stm32/stm32-cryp.c                   | 2 +-
 drivers/crypto/stm32/stm32-hash.c                   | 2 +-
 drivers/crypto/talitos.c                            | 2 +-
 drivers/crypto/tegra/tegra-se-main.c                | 2 +-
 drivers/crypto/xilinx/zynqmp-aes-gcm.c              | 2 +-
 drivers/crypto/xilinx/zynqmp-sha.c                  | 2 +-
 45 files changed, 46 insertions(+), 46 deletions(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
index 890664bd5f0f..58a76e2ba64e 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
@@ -542,7 +542,7 @@ MODULE_DEVICE_TABLE(of, a20ss_crypto_of_match_table);
 
 static struct platform_driver sun4i_ss_driver = {
 	.probe          = sun4i_ss_probe,
-	.remove_new     = sun4i_ss_remove,
+	.remove         = sun4i_ss_remove,
 	.driver         = {
 		.name           = "sun4i-ss",
 		.pm		= &sun4i_ss_pm_ops,
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index e55e58e164db..ec1ffda9ea32 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -1129,7 +1129,7 @@ MODULE_DEVICE_TABLE(of, sun8i_ce_crypto_of_match_table);
 
 static struct platform_driver sun8i_ce_driver = {
 	.probe		 = sun8i_ce_probe,
-	.remove_new	 = sun8i_ce_remove,
+	.remove		 = sun8i_ce_remove,
 	.driver		 = {
 		.name		= "sun8i-ce",
 		.pm		= &sun8i_ce_pm_ops,
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
index 0dbc0220146c..f45685707e0d 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
@@ -929,7 +929,7 @@ MODULE_DEVICE_TABLE(of, sun8i_ss_crypto_of_match_table);
 
 static struct platform_driver sun8i_ss_driver = {
 	.probe		 = sun8i_ss_probe,
-	.remove_new	 = sun8i_ss_remove,
+	.remove		 = sun8i_ss_remove,
 	.driver		 = {
 		.name		= "sun8i-ss",
 		.pm             = &sun8i_ss_pm_ops,
diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 6006703fb6d7..1bed5ca78deb 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1497,7 +1497,7 @@ static struct platform_driver crypto4xx_driver = {
 		.of_match_table = crypto4xx_match,
 	},
 	.probe		= crypto4xx_probe,
-	.remove_new	= crypto4xx_remove,
+	.remove		= crypto4xx_remove,
 };
 
 module_platform_driver(crypto4xx_driver);
diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index f54ab0d0b1e8..1e5addb947a5 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -322,7 +322,7 @@ MODULE_DEVICE_TABLE(of, meson_crypto_of_match_table);
 
 static struct platform_driver meson_crypto_driver = {
 	.probe		 = meson_crypto_probe,
-	.remove_new	 = meson_crypto_remove,
+	.remove		 = meson_crypto_remove,
 	.driver		 = {
 		.name		   = "gxl-crypto",
 		.of_match_table	= meson_crypto_of_match_table,
diff --git a/drivers/crypto/aspeed/aspeed-acry.c b/drivers/crypto/aspeed/aspeed-acry.c
index b4613bd4ad96..3a3aca787ddf 100644
--- a/drivers/crypto/aspeed/aspeed-acry.c
+++ b/drivers/crypto/aspeed/aspeed-acry.c
@@ -808,7 +808,7 @@ MODULE_DEVICE_TABLE(of, aspeed_acry_of_matches);
 
 static struct platform_driver aspeed_acry_driver = {
 	.probe		= aspeed_acry_probe,
-	.remove_new	= aspeed_acry_remove,
+	.remove		= aspeed_acry_remove,
 	.driver		= {
 		.name   = KBUILD_MODNAME,
 		.of_match_table = aspeed_acry_of_matches,
diff --git a/drivers/crypto/aspeed/aspeed-hace.c b/drivers/crypto/aspeed/aspeed-hace.c
index 062f2a66dd23..3fe644bfe037 100644
--- a/drivers/crypto/aspeed/aspeed-hace.c
+++ b/drivers/crypto/aspeed/aspeed-hace.c
@@ -266,7 +266,7 @@ MODULE_DEVICE_TABLE(of, aspeed_hace_of_matches);
 
 static struct platform_driver aspeed_hace_driver = {
 	.probe		= aspeed_hace_probe,
-	.remove_new	= aspeed_hace_remove,
+	.remove		= aspeed_hace_remove,
 	.driver         = {
 		.name   = KBUILD_MODNAME,
 		.of_match_table = aspeed_hace_of_matches,
diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 0dd90785db9a..14bf86957d31 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -2453,7 +2453,7 @@ static void atmel_aes_remove(struct platform_device *pdev)
 
 static struct platform_driver atmel_aes_driver = {
 	.probe		= atmel_aes_probe,
-	.remove_new	= atmel_aes_remove,
+	.remove		= atmel_aes_remove,
 	.driver		= {
 		.name	= "atmel_aes",
 		.of_match_table = atmel_aes_dt_ids,
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 8cc57df25778..67a170608566 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -2691,7 +2691,7 @@ static void atmel_sha_remove(struct platform_device *pdev)
 
 static struct platform_driver atmel_sha_driver = {
 	.probe		= atmel_sha_probe,
-	.remove_new	= atmel_sha_remove,
+	.remove		= atmel_sha_remove,
 	.driver		= {
 		.name	= "atmel_sha",
 		.of_match_table	= atmel_sha_dt_ids,
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index dcc2380a5889..9df9986ba170 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -1074,7 +1074,7 @@ static void atmel_tdes_remove(struct platform_device *pdev)
 
 static struct platform_driver atmel_tdes_driver = {
 	.probe		= atmel_tdes_probe,
-	.remove_new	= atmel_tdes_remove,
+	.remove		= atmel_tdes_remove,
 	.driver		= {
 		.name	= "atmel_tdes",
 		.of_match_table = atmel_tdes_dt_ids,
diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index 75440ea6206e..1c1f57baef0e 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -2975,7 +2975,7 @@ static void artpec6_crypto_remove(struct platform_device *pdev)
 
 static struct platform_driver artpec6_crypto_driver = {
 	.probe   = artpec6_crypto_probe,
-	.remove_new = artpec6_crypto_remove,
+	.remove = artpec6_crypto_remove,
 	.driver  = {
 		.name  = "artpec6-crypto",
 		.of_match_table = artpec6_crypto_of_match,
diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index 1a3ecd44cbaf..7540eb7cd331 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -4704,7 +4704,7 @@ static struct platform_driver bcm_spu_pdriver = {
 		   .of_match_table = of_match_ptr(bcm_spu_dt_ids),
 		   },
 	.probe = bcm_spu_probe,
-	.remove_new = bcm_spu_remove,
+	.remove = bcm_spu_remove,
 };
 module_platform_driver(bcm_spu_pdriver);
 
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 26eba7de3fb0..9fcdb64084ac 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -819,7 +819,7 @@ static struct platform_driver caam_jr_driver = {
 		.pm = pm_ptr(&caam_jr_pm_ops),
 	},
 	.probe       = caam_jr_probe,
-	.remove_new  = caam_jr_remove,
+	.remove      = caam_jr_remove,
 	.shutdown    = caam_jr_remove,
 };
 
diff --git a/drivers/crypto/ccp/sp-platform.c b/drivers/crypto/ccp/sp-platform.c
index ff6ceb4feee0..3933cac1694d 100644
--- a/drivers/crypto/ccp/sp-platform.c
+++ b/drivers/crypto/ccp/sp-platform.c
@@ -210,7 +210,7 @@ static struct platform_driver sp_platform_driver = {
 		.of_match_table = sp_of_match,
 	},
 	.probe = sp_platform_probe,
-	.remove_new = sp_platform_remove,
+	.remove = sp_platform_remove,
 #ifdef CONFIG_PM
 	.suspend = sp_platform_suspend,
 	.resume = sp_platform_resume,
diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index 9177b54bb0f5..061e68a31c36 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -643,7 +643,7 @@ static struct platform_driver ccree_driver = {
 #endif
 	},
 	.probe = ccree_probe,
-	.remove_new = ccree_remove,
+	.remove = ccree_remove,
 };
 
 static int __init ccree_init(void)
diff --git a/drivers/crypto/exynos-rng.c b/drivers/crypto/exynos-rng.c
index 0dd8baf16cb4..2aaa98f9b44e 100644
--- a/drivers/crypto/exynos-rng.c
+++ b/drivers/crypto/exynos-rng.c
@@ -389,7 +389,7 @@ static struct platform_driver exynos_rng_driver = {
 		.of_match_table = exynos_rng_dt_match,
 	},
 	.probe		= exynos_rng_probe,
-	.remove_new	= exynos_rng_remove,
+	.remove		= exynos_rng_remove,
 };
 
 module_platform_driver(exynos_rng_driver);
diff --git a/drivers/crypto/gemini/sl3516-ce-core.c b/drivers/crypto/gemini/sl3516-ce-core.c
index 1d1a889599bb..f7e0e3fea15c 100644
--- a/drivers/crypto/gemini/sl3516-ce-core.c
+++ b/drivers/crypto/gemini/sl3516-ce-core.c
@@ -528,7 +528,7 @@ MODULE_DEVICE_TABLE(of, sl3516_ce_crypto_of_match_table);
 
 static struct platform_driver sl3516_ce_driver = {
 	.probe		 = sl3516_ce_probe,
-	.remove_new	 = sl3516_ce_remove,
+	.remove		 = sl3516_ce_remove,
 	.driver		 = {
 		.name		= "sl3516-crypto",
 		.pm		= &sl3516_ce_pm_ops,
diff --git a/drivers/crypto/hisilicon/sec/sec_drv.c b/drivers/crypto/hisilicon/sec/sec_drv.c
index 9bafcc5aa404..ef0cb733c92c 100644
--- a/drivers/crypto/hisilicon/sec/sec_drv.c
+++ b/drivers/crypto/hisilicon/sec/sec_drv.c
@@ -1304,7 +1304,7 @@ MODULE_DEVICE_TABLE(acpi, sec_acpi_match);
 
 static struct platform_driver sec_driver = {
 	.probe = sec_probe,
-	.remove_new = sec_remove,
+	.remove = sec_remove,
 	.driver = {
 		.name = "hisi_sec_platform_driver",
 		.of_match_table = sec_match,
diff --git a/drivers/crypto/hisilicon/trng/trng.c b/drivers/crypto/hisilicon/trng/trng.c
index 66c551ecdee8..ac74df4a9471 100644
--- a/drivers/crypto/hisilicon/trng/trng.c
+++ b/drivers/crypto/hisilicon/trng/trng.c
@@ -324,7 +324,7 @@ MODULE_DEVICE_TABLE(acpi, hisi_trng_acpi_match);
 
 static struct platform_driver hisi_trng_driver = {
 	.probe		= hisi_trng_probe,
-	.remove_new     = hisi_trng_remove,
+	.remove         = hisi_trng_remove,
 	.driver		= {
 		.name	= "hisi-trng-v2",
 		.acpi_match_table = ACPI_PTR(hisi_trng_acpi_match),
diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index 7e93159c3b6b..1dc2378aa88b 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -1084,7 +1084,7 @@ static const struct dev_pm_ops img_hash_pm_ops = {
 
 static struct platform_driver img_hash_driver = {
 	.probe		= img_hash_probe,
-	.remove_new	= img_hash_remove,
+	.remove		= img_hash_remove,
 	.driver		= {
 		.name	= "img-hash-accelerator",
 		.pm	= &img_hash_pm_ops,
diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index f5c1912aa564..45758c7aa80e 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1868,7 +1868,7 @@ MODULE_DEVICE_TABLE(of, safexcel_of_match_table);
 
 static struct platform_driver  crypto_safexcel = {
 	.probe		= safexcel_probe,
-	.remove_new	= safexcel_remove,
+	.remove		= safexcel_remove,
 	.driver		= {
 		.name	= "crypto-safexcel",
 		.of_match_table = safexcel_of_match_table,
diff --git a/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c b/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
index f8a77bff8844..449c6d3ab2db 100644
--- a/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
+++ b/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
@@ -1588,7 +1588,7 @@ static const struct of_device_id ixp4xx_crypto_of_match[] = {
 
 static struct platform_driver ixp_crypto_driver = {
 	.probe = ixp_crypto_probe,
-	.remove_new = ixp_crypto_remove,
+	.remove = ixp_crypto_remove,
 	.driver = {
 		.name = "ixp4xx_crypto",
 		.of_match_table = ixp4xx_crypto_of_match,
diff --git a/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c b/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
index 9b2d098e5eb2..8a8f6c81e010 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
@@ -1656,7 +1656,7 @@ static int kmb_ocs_aes_probe(struct platform_device *pdev)
 /* The OCS driver is a platform device. */
 static struct platform_driver kmb_ocs_aes_driver = {
 	.probe = kmb_ocs_aes_probe,
-	.remove_new = kmb_ocs_aes_remove,
+	.remove = kmb_ocs_aes_remove,
 	.driver = {
 			.name = DRV_NAME,
 			.of_match_table = kmb_ocs_aes_of_match,
diff --git a/drivers/crypto/intel/keembay/keembay-ocs-ecc.c b/drivers/crypto/intel/keembay/keembay-ocs-ecc.c
index 5e24f2d8affc..59308926399d 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-ecc.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-ecc.c
@@ -991,7 +991,7 @@ static const struct of_device_id kmb_ocs_ecc_of_match[] = {
 /* The OCS driver is a platform device. */
 static struct platform_driver kmb_ocs_ecc_driver = {
 	.probe = kmb_ocs_ecc_probe,
-	.remove_new = kmb_ocs_ecc_remove,
+	.remove = kmb_ocs_ecc_remove,
 	.driver = {
 			.name = DRV_NAME,
 			.of_match_table = kmb_ocs_ecc_of_match,
diff --git a/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c b/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
index e54c79890d44..95dc8979918d 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
@@ -1243,7 +1243,7 @@ static int kmb_ocs_hcu_probe(struct platform_device *pdev)
 /* The OCS driver is a platform device. */
 static struct platform_driver kmb_ocs_hcu_driver = {
 	.probe = kmb_ocs_hcu_probe,
-	.remove_new = kmb_ocs_hcu_remove,
+	.remove = kmb_ocs_hcu_remove,
 	.driver = {
 			.name = DRV_NAME,
 			.of_match_table = kmb_ocs_hcu_of_match,
diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
index 5fd31ba715c2..ac8005f77755 100644
--- a/drivers/crypto/marvell/cesa/cesa.c
+++ b/drivers/crypto/marvell/cesa/cesa.c
@@ -604,7 +604,7 @@ MODULE_DEVICE_TABLE(platform, mv_cesa_plat_id_table);
 
 static struct platform_driver marvell_cesa = {
 	.probe		= mv_cesa_probe,
-	.remove_new	= mv_cesa_remove,
+	.remove		= mv_cesa_remove,
 	.id_table	= mv_cesa_plat_id_table,
 	.driver		= {
 		.name	= "marvell-cesa",
diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index c82775dbb557..162647acd8dc 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -1243,7 +1243,7 @@ MODULE_DEVICE_TABLE(of, mxs_dcp_dt_ids);
 
 static struct platform_driver mxs_dcp_driver = {
 	.probe	= mxs_dcp_probe,
-	.remove_new = mxs_dcp_remove,
+	.remove = mxs_dcp_remove,
 	.driver	= {
 		.name		= "mxs-dcp",
 		.of_match_table	= mxs_dcp_dt_ids,
diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index b11545cc5cb7..14c302d2db79 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -2119,7 +2119,7 @@ static struct platform_driver n2_crypto_driver = {
 		.of_match_table	=	n2_crypto_match,
 	},
 	.probe		=	n2_crypto_probe,
-	.remove_new	=	n2_crypto_remove,
+	.remove		=	n2_crypto_remove,
 };
 
 static const struct of_device_id n2_mau_match[] = {
@@ -2146,7 +2146,7 @@ static struct platform_driver n2_mau_driver = {
 		.of_match_table	=	n2_mau_match,
 	},
 	.probe		=	n2_mau_probe,
-	.remove_new	=	n2_mau_remove,
+	.remove		=	n2_mau_remove,
 };
 
 static struct platform_driver * const drivers[] = {
diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index bad1adacbc84..e27b84616743 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -1305,7 +1305,7 @@ static SIMPLE_DEV_PM_OPS(omap_aes_pm_ops, omap_aes_suspend, omap_aes_resume);
 
 static struct platform_driver omap_aes_driver = {
 	.probe	= omap_aes_probe,
-	.remove_new = omap_aes_remove,
+	.remove = omap_aes_remove,
 	.driver	= {
 		.name	= "omap-aes",
 		.pm	= &omap_aes_pm_ops,
diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 209d3dc03a9b..498cbd585ed1 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -1115,7 +1115,7 @@ static SIMPLE_DEV_PM_OPS(omap_des_pm_ops, omap_des_suspend, omap_des_resume);
 
 static struct platform_driver omap_des_driver = {
 	.probe	= omap_des_probe,
-	.remove_new = omap_des_remove,
+	.remove = omap_des_remove,
 	.driver	= {
 		.name	= "omap-des",
 		.pm	= &omap_des_pm_ops,
diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 5bcd9ab0f72a..7021481bf027 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -2216,7 +2216,7 @@ static void omap_sham_remove(struct platform_device *pdev)
 
 static struct platform_driver omap_sham_driver = {
 	.probe	= omap_sham_probe,
-	.remove_new = omap_sham_remove,
+	.remove = omap_sham_remove,
 	.driver	= {
 		.name	= "omap-sham",
 		.of_match_table	= omap_sham_of_match,
diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index 28b5fd823827..e228a31fe28d 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -299,7 +299,7 @@ MODULE_DEVICE_TABLE(of, qce_crypto_of_match);
 
 static struct platform_driver qce_crypto_driver = {
 	.probe = qce_crypto_probe,
-	.remove_new = qce_crypto_remove,
+	.remove = qce_crypto_remove,
 	.driver = {
 		.name = KBUILD_MODNAME,
 		.of_match_table = qce_crypto_of_match,
diff --git a/drivers/crypto/qcom-rng.c b/drivers/crypto/qcom-rng.c
index 09419e79e34c..0685ba122e8a 100644
--- a/drivers/crypto/qcom-rng.c
+++ b/drivers/crypto/qcom-rng.c
@@ -262,7 +262,7 @@ MODULE_DEVICE_TABLE(of, qcom_rng_of_match);
 
 static struct platform_driver qcom_rng_driver = {
 	.probe = qcom_rng_probe,
-	.remove_new =  qcom_rng_remove,
+	.remove =  qcom_rng_remove,
 	.driver = {
 		.name = KBUILD_MODNAME,
 		.of_match_table = of_match_ptr(qcom_rng_of_match),
diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index f74b3c81ba6d..b77bdce8e7fc 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -433,7 +433,7 @@ static void rk_crypto_remove(struct platform_device *pdev)
 
 static struct platform_driver crypto_driver = {
 	.probe		= rk_crypto_probe,
-	.remove_new	= rk_crypto_remove,
+	.remove		= rk_crypto_remove,
 	.driver		= {
 		.name	= "rk3288-crypto",
 		.pm		= &rk_crypto_pm_ops,
diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 8b6e3f5c94de..57ab237e899e 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -2335,7 +2335,7 @@ static void s5p_aes_remove(struct platform_device *pdev)
 
 static struct platform_driver s5p_aes_crypto = {
 	.probe	= s5p_aes_probe,
-	.remove_new = s5p_aes_remove,
+	.remove = s5p_aes_remove,
 	.driver	= {
 		.name	= "s5p-secss",
 		.of_match_table = s5p_sss_dt_match,
diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 461eca40e878..dda239f8285a 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -2489,7 +2489,7 @@ static void sa_ul_remove(struct platform_device *pdev)
 
 static struct platform_driver sa_ul_driver = {
 	.probe = sa_ul_probe,
-	.remove_new = sa_ul_remove,
+	.remove = sa_ul_remove,
 	.driver = {
 		   .name = "saul-crypto",
 		   .of_match_table = of_match,
diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 96d4af5d48a6..533080b0cddc 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1421,7 +1421,7 @@ static void sahara_remove(struct platform_device *pdev)
 
 static struct platform_driver sahara_driver = {
 	.probe		= sahara_probe,
-	.remove_new	= sahara_remove,
+	.remove		= sahara_remove,
 	.driver		= {
 		.name	= SAHARA_NAME,
 		.of_match_table = sahara_dt_ids,
diff --git a/drivers/crypto/starfive/jh7110-cryp.c b/drivers/crypto/starfive/jh7110-cryp.c
index e4dfed7ee0b0..45e5e8356752 100644
--- a/drivers/crypto/starfive/jh7110-cryp.c
+++ b/drivers/crypto/starfive/jh7110-cryp.c
@@ -215,7 +215,7 @@ MODULE_DEVICE_TABLE(of, starfive_dt_ids);
 
 static struct platform_driver starfive_cryp_driver = {
 	.probe  = starfive_cryp_probe,
-	.remove_new = starfive_cryp_remove,
+	.remove = starfive_cryp_remove,
 	.driver = {
 		.name           = DRIVER_NAME,
 		.of_match_table = starfive_dt_ids,
diff --git a/drivers/crypto/stm32/stm32-crc32.c b/drivers/crypto/stm32/stm32-crc32.c
index e0faddbf8990..de4d0402f133 100644
--- a/drivers/crypto/stm32/stm32-crc32.c
+++ b/drivers/crypto/stm32/stm32-crc32.c
@@ -465,7 +465,7 @@ MODULE_DEVICE_TABLE(of, stm32_dt_ids);
 
 static struct platform_driver stm32_crc_driver = {
 	.probe  = stm32_crc_probe,
-	.remove_new = stm32_crc_remove,
+	.remove = stm32_crc_remove,
 	.driver = {
 		.name           = DRIVER_NAME,
 		.pm		= &stm32_crc_pm_ops,
diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 937f6dab8955..14c6339c2e43 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -2771,7 +2771,7 @@ static const struct dev_pm_ops stm32_cryp_pm_ops = {
 
 static struct platform_driver stm32_cryp_driver = {
 	.probe  = stm32_cryp_probe,
-	.remove_new = stm32_cryp_remove,
+	.remove = stm32_cryp_remove,
 	.driver = {
 		.name           = DRIVER_NAME,
 		.pm		= &stm32_cryp_pm_ops,
diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index 351827372ea6..768b27de4737 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -2532,7 +2532,7 @@ static const struct dev_pm_ops stm32_hash_pm_ops = {
 
 static struct platform_driver stm32_hash_driver = {
 	.probe		= stm32_hash_probe,
-	.remove_new	= stm32_hash_remove,
+	.remove		= stm32_hash_remove,
 	.driver		= {
 		.name	= "stm32-hash",
 		.pm = &stm32_hash_pm_ops,
diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 511ddcb0efd4..e8c0db687c57 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3560,7 +3560,7 @@ static struct platform_driver talitos_driver = {
 		.of_match_table = talitos_match,
 	},
 	.probe = talitos_probe,
-	.remove_new = talitos_remove,
+	.remove = talitos_remove,
 };
 
 module_platform_driver(talitos_driver);
diff --git a/drivers/crypto/tegra/tegra-se-main.c b/drivers/crypto/tegra/tegra-se-main.c
index f94c0331b148..8fa7cbe9372c 100644
--- a/drivers/crypto/tegra/tegra-se-main.c
+++ b/drivers/crypto/tegra/tegra-se-main.c
@@ -387,7 +387,7 @@ static struct platform_driver tegra_se_driver = {
 		.of_match_table = tegra_se_of_match,
 	},
 	.probe		= tegra_se_probe,
-	.remove_new	= tegra_se_remove,
+	.remove		= tegra_se_remove,
 };
 
 static int tegra_se_host1x_probe(struct host1x_device *dev)
diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
index 7f0ec6887a39..6e72d9229410 100644
--- a/drivers/crypto/xilinx/zynqmp-aes-gcm.c
+++ b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
@@ -438,7 +438,7 @@ MODULE_DEVICE_TABLE(of, zynqmp_aes_dt_ids);
 
 static struct platform_driver zynqmp_aes_driver = {
 	.probe	= zynqmp_aes_aead_probe,
-	.remove_new = zynqmp_aes_aead_remove,
+	.remove = zynqmp_aes_aead_remove,
 	.driver = {
 		.name		= "zynqmp-aes",
 		.of_match_table = zynqmp_aes_dt_ids,
diff --git a/drivers/crypto/xilinx/zynqmp-sha.c b/drivers/crypto/xilinx/zynqmp-sha.c
index 1bcec6f46c9c..580649f9bff8 100644
--- a/drivers/crypto/xilinx/zynqmp-sha.c
+++ b/drivers/crypto/xilinx/zynqmp-sha.c
@@ -248,7 +248,7 @@ static void zynqmp_sha_remove(struct platform_device *pdev)
 
 static struct platform_driver zynqmp_sha_driver = {
 	.probe = zynqmp_sha_probe,
-	.remove_new = zynqmp_sha_remove,
+	.remove = zynqmp_sha_remove,
 	.driver = {
 		.name = "zynqmp-sha3-384",
 	},

base-commit: 58ca61c1a866bfdaa5e19fb19a2416764f847d75
-- 
2.45.2

