From: Christian Lamparter <chunkeey@gmail.com>
Subject: [PATCH v1 4/4] crypto: crypto4xx - kill MODULE_NAME
Date: Fri, 22 Dec 2017 21:18:38 +0100
Message-ID: <c3621f23fed7d6fff33083ae538004ea59c01d8f.1513908140.git.chunkeey@gmail.com>
References: <4baa099377d73ea99c7802a9685815b32e8bf119.1513908140.git.chunkeey@gmail.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:45244 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756781AbdLVUSn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 15:18:43 -0500
Received: by mail-wr0-f195.google.com with SMTP id h1so28786394wre.12
        for <linux-crypto@vger.kernel.org>; Fri, 22 Dec 2017 12:18:43 -0800 (PST)
Received: from debian64.daheim (p5B0D71BC.dip0.t-ipconnect.de. [91.13.113.188])
        by smtp.gmail.com with ESMTPSA id u194sm7408735wmd.6.2017.12.22.12.18.39
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Dec 2017 12:18:40 -0800 (PST)
Received: from chuck by debian64.daheim with local (Exim 4.90_RC4)
        (envelope-from <chunkeey@gmail.com>)
        id 1eSTmA-0005k9-Lz
        for linux-crypto@vger.kernel.org; Fri, 22 Dec 2017 21:18:38 +0100
In-Reply-To: <4baa099377d73ea99c7802a9685815b32e8bf119.1513908140.git.chunkeey@gmail.com>
In-Reply-To: <00179ef6e3c4e5db6258cd6e273e4063b8437d18.1513908140.git.chunkeey@gmail.com>
References: <4baa099377d73ea99c7802a9685815b32e8bf119.1513908140.git.chunkeey@gmail.com> <1e932b627e79aa2c70e2c7278e4ac930303faa3f.1513908140.git.chunkeey@gmail.com> <00179ef6e3c4e5db6258cd6e273e4063b8437d18.1513908140.git.chunkeey@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

KBUILD_MODNAME provides the same value.

Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 2 +-
 drivers/crypto/amcc/crypto4xx_core.h | 2 --
 drivers/crypto/amcc/crypto4xx_trng.c | 2 +-
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 4b03318775ac..f148627e925c 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1432,7 +1432,7 @@ MODULE_DEVICE_TABLE(of, crypto4xx_match);
 
 static struct platform_driver crypto4xx_driver = {
 	.driver = {
-		.name = MODULE_NAME,
+		.name = KBUILD_MODNAME,
 		.of_match_table = crypto4xx_match,
 	},
 	.probe		= crypto4xx_probe,
diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
index 61a02a4c5794..23b726da6534 100644
--- a/drivers/crypto/amcc/crypto4xx_core.h
+++ b/drivers/crypto/amcc/crypto4xx_core.h
@@ -28,8 +28,6 @@
 #include "crypto4xx_reg_def.h"
 #include "crypto4xx_sa.h"
 
-#define MODULE_NAME "crypto4xx"
-
 #define PPC460SX_SDR0_SRST                      0x201
 #define PPC405EX_SDR0_SRST                      0x200
 #define PPC460EX_SDR0_SRST                      0x201
diff --git a/drivers/crypto/amcc/crypto4xx_trng.c b/drivers/crypto/amcc/crypto4xx_trng.c
index 677ca17fd223..5e63742b0d22 100644
--- a/drivers/crypto/amcc/crypto4xx_trng.c
+++ b/drivers/crypto/amcc/crypto4xx_trng.c
@@ -92,7 +92,7 @@ void ppc4xx_trng_probe(struct crypto4xx_core_device *core_dev)
 	if (!rng)
 		goto err_out;
 
-	rng->name = MODULE_NAME;
+	rng->name = KBUILD_MODNAME;
 	rng->data_present = ppc4xx_trng_data_present;
 	rng->data_read = ppc4xx_trng_data_read;
 	rng->priv = (unsigned long) dev;
-- 
2.15.1
