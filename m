From: Christian Lamparter <chunkeey@gmail.com>
Subject: [PATCH v1 3/4] crypto: crypto4xx - fix missing irq devname
Date: Fri, 22 Dec 2017 21:18:37 +0100
Message-ID: <00179ef6e3c4e5db6258cd6e273e4063b8437d18.1513908140.git.chunkeey@gmail.com>
References: <4baa099377d73ea99c7802a9685815b32e8bf119.1513908140.git.chunkeey@gmail.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:37410 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756679AbdLVUSm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 15:18:42 -0500
Received: by mail-wm0-f65.google.com with SMTP id f140so23562428wmd.2
        for <linux-crypto@vger.kernel.org>; Fri, 22 Dec 2017 12:18:42 -0800 (PST)
Received: from debian64.daheim (p5B0D71BC.dip0.t-ipconnect.de. [91.13.113.188])
        by smtp.gmail.com with ESMTPSA id e20sm16200333wre.6.2017.12.22.12.18.39
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Dec 2017 12:18:39 -0800 (PST)
Received: from chuck by debian64.daheim with local (Exim 4.90_RC4)
        (envelope-from <chunkeey@gmail.com>)
        id 1eSTmA-0005k3-K5
        for linux-crypto@vger.kernel.org; Fri, 22 Dec 2017 21:18:38 +0100
In-Reply-To: <4baa099377d73ea99c7802a9685815b32e8bf119.1513908140.git.chunkeey@gmail.com>
In-Reply-To: <1e932b627e79aa2c70e2c7278e4ac930303faa3f.1513908140.git.chunkeey@gmail.com>
References: <4baa099377d73ea99c7802a9685815b32e8bf119.1513908140.git.chunkeey@gmail.com> <1e932b627e79aa2c70e2c7278e4ac930303faa3f.1513908140.git.chunkeey@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto4xx_device's name variable is not set to anything.
The common devname for request_irq seems to be the module
name. This will fix the seemingly anonymous interrupt
entry in /proc/interrupts for crypto4xx.

Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 2 +-
 drivers/crypto/amcc/crypto4xx_core.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index fde0136029f1..4b03318775ac 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1370,7 +1370,7 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 	rc = request_irq(core_dev->irq, is_revb ?
 			 crypto4xx_ce_interrupt_handler_revb :
 			 crypto4xx_ce_interrupt_handler, 0,
-			 core_dev->dev->name, dev);
+			 KBUILD_MODNAME, dev);
 	if (rc)
 		goto err_request_irq;
 
diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
index 013d9992a44e..61a02a4c5794 100644
--- a/drivers/crypto/amcc/crypto4xx_core.h
+++ b/drivers/crypto/amcc/crypto4xx_core.h
@@ -82,7 +82,6 @@ struct pd_uinfo {
 
 struct crypto4xx_device {
 	struct crypto4xx_core_device *core_dev;
-	char *name;
 	void __iomem *ce_base;
 	void __iomem *trng_base;
 
-- 
2.15.1
