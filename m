Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 061C2C2B9F8
	for <linux-crypto@archiver.kernel.org>; Tue, 25 May 2021 08:32:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D352261419
	for <linux-crypto@archiver.kernel.org>; Tue, 25 May 2021 08:32:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhEYIeX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 May 2021 04:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbhEYIeX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 May 2021 04:34:23 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E301C061574
        for <linux-crypto@vger.kernel.org>; Tue, 25 May 2021 01:32:53 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id i9so44788372lfe.13
        for <linux-crypto@vger.kernel.org>; Tue, 25 May 2021 01:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X4hWr3FMFUTmFblhPen11gcDOLFQZwv4OPOjwSTEn3A=;
        b=n58by9iVWWH6Lcyf09D3MgzC3+Ye+cZkYqN7JnQnORGiXfKLICWkGIjuqEMmeMhzO6
         VrpYxLXRTpkRh1rqFAiyoxBXqfXOy5WQJzViM0FaF4o8x/l6tK02jgGYkmQVJRWxdY5E
         nowCQkAGCFL/n0KcncQ9qDFdk95RtzWQ47wwSTLiT0Lnh0Jvtz3fddeW7KIl8k7bzdpY
         vebGf08qMtLnpfO2wdtFdKCdRGfeQAuJyzMRLGEJJwSCr0YfBvPa1Y5MWvdVy/pM6dKB
         dGQtEsEfJ1V4Nlqcu1FOAeaP/j/mBXbLIkY8hpNGUOBQDKZvMD1xrLDnGSHN3G3Wos0p
         wiHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X4hWr3FMFUTmFblhPen11gcDOLFQZwv4OPOjwSTEn3A=;
        b=Mz5HxQFTqqDma4YL1+4FCotVS6ug3PmBIAG/dvAQg8UElFvy8CT426WKg5LgeDu3gT
         323UJXPhROwFytfVkZigI5AOx3ucDOrBbK/Y5vTFtgMD7MM1HgYM8T9fZ/ZySabGlwR+
         lxco7pFhqz5O6/W1kOLTikilVkXEgSgmgqvia4O3llARDZw3F2Ew6RYK8zQA9BOPg25Q
         u/WbxE8UVxXGcGp248nJGz3+5Amd/p3WdNU2iRspDevLutrUpWTsFPTJ/EU1w03/R+Yy
         rlGZgyCKl9ND0Mel9ASJ1vUiLJrSlH6EIiClp81VVdzWz9V0+GIMUL7Mu7gNPIzMe/xR
         afsA==
X-Gm-Message-State: AOAM533Uf1EPXyS6ikQBLpIubZ84ysCbU4HEZsskOpAC9i8LixORWZL6
        GHlzGzvQ+D97edw1JEcO4i5tyLi9EyHIaQ==
X-Google-Smtp-Source: ABdhPJxQaEYI2NH7vCCJxWsY2o/gdeFf8bgdFQd/hDtWXJUASt3DlM3bSUkPfZsQ7mmm/V5RZ4xwKQ==
X-Received: by 2002:a05:6512:33d5:: with SMTP id d21mr13142953lfg.418.1621931571604;
        Tue, 25 May 2021 01:32:51 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id b6sm1664858lfb.114.2021.05.25.01.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 01:32:51 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Corentin Labbe <clabbe@baylibre.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        Imre Kaloz <kaloz@openwrt.org>,
        Krzysztof Halasa <khalasa@piap.pl>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/3 v4] crypto: ixp4xx: convert to platform driver
Date:   Tue, 25 May 2021 10:30:46 +0200
Message-Id: <20210525083048.1113870-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The ixp4xx_crypto driver traditionally registers a bare platform
device without attaching it to a driver, and detects the hardware
at module init time by reading an SoC specific hardware register.

Change this to the conventional method of registering the platform
device from the platform code itself when the device is present,
turning the module_init/module_exit functions into probe/release
driver callbacks.

This enables compile-testing as well as potentially having ixp4xx
coexist with other ARMv5 platforms in the same kernel in the future.

Cc: Corentin Labbe <clabbe@baylibre.com>
Tested-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v3->v4:
- No changes, just resending with the other patches.
ChangeLog v2->v3:
- No changes, just resending with the other patches.
ChangeLog v1->v2:
- Rebase on Corentin's patches in the cryptodev tree
- Drop the compile test Kconfig, it will not compile for
  anything not IXP4xx anyway because it needs the NPE and QMGR
  to be compiled in and those only exist on IXP4xx.
---
 arch/arm/mach-ixp4xx/common.c  | 26 ++++++++++++++++++++++++
 drivers/crypto/ixp4xx_crypto.c | 37 ++++++++++++----------------------
 2 files changed, 39 insertions(+), 24 deletions(-)

diff --git a/arch/arm/mach-ixp4xx/common.c b/arch/arm/mach-ixp4xx/common.c
index 000f672a94c9..007a44412e24 100644
--- a/arch/arm/mach-ixp4xx/common.c
+++ b/arch/arm/mach-ixp4xx/common.c
@@ -233,12 +233,38 @@ static struct platform_device *ixp46x_devices[] __initdata = {
 unsigned long ixp4xx_exp_bus_size;
 EXPORT_SYMBOL(ixp4xx_exp_bus_size);
 
+static struct platform_device_info ixp_dev_info __initdata = {
+	.name		= "ixp4xx_crypto",
+	.id		= 0,
+	.dma_mask	= DMA_BIT_MASK(32),
+};
+
+static int __init ixp_crypto_register(void)
+{
+	struct platform_device *pdev;
+
+	if (!(~(*IXP4XX_EXP_CFG2) & (IXP4XX_FEATURE_HASH |
+				IXP4XX_FEATURE_AES | IXP4XX_FEATURE_DES))) {
+		printk(KERN_ERR "ixp_crypto: No HW crypto available\n");
+		return -ENODEV;
+	}
+
+	pdev = platform_device_register_full(&ixp_dev_info);
+	if (IS_ERR(pdev))
+		return PTR_ERR(pdev);
+
+	return 0;
+}
+
 void __init ixp4xx_sys_init(void)
 {
 	ixp4xx_exp_bus_size = SZ_16M;
 
 	platform_add_devices(ixp4xx_devices, ARRAY_SIZE(ixp4xx_devices));
 
+	if (IS_ENABLED(CONFIG_CRYPTO_DEV_IXP4XX))
+		ixp_crypto_register();
+
 	if (cpu_is_ixp46x()) {
 		int region;
 
diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index b38650b0fea1..76099d6cfff9 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -229,8 +229,6 @@ static dma_addr_t crypt_phys;
 
 static int support_aes = 1;
 
-#define DRIVER_NAME "ixp4xx_crypto"
-
 static struct platform_device *pdev;
 
 static inline dma_addr_t crypt_virt2phys(struct crypt_ctl *virt)
@@ -453,11 +451,6 @@ static int init_ixp_crypto(struct device *dev)
 	int ret = -ENODEV;
 	u32 msg[2] = { 0, 0 };
 
-	if (! ( ~(*IXP4XX_EXP_CFG2) & (IXP4XX_FEATURE_HASH |
-				IXP4XX_FEATURE_AES | IXP4XX_FEATURE_DES))) {
-		dev_err(dev, "ixp_crypto: No HW crypto available\n");
-		return ret;
-	}
 	npe_c = npe_request(NPE_ID);
 	if (!npe_c)
 		return ret;
@@ -1441,26 +1434,17 @@ static struct ixp_aead_alg ixp4xx_aeads[] = {
 
 #define IXP_POSTFIX "-ixp4xx"
 
-static const struct platform_device_info ixp_dev_info __initdata = {
-	.name		= DRIVER_NAME,
-	.id		= 0,
-	.dma_mask	= DMA_BIT_MASK(32),
-};
-
-static int __init ixp_module_init(void)
+static int ixp_crypto_probe(struct platform_device *_pdev)
 {
 	int num = ARRAY_SIZE(ixp4xx_algos);
 	int i, err;
 
-	pdev = platform_device_register_full(&ixp_dev_info);
-	if (IS_ERR(pdev))
-		return PTR_ERR(pdev);
+	pdev = _pdev;
 
 	err = init_ixp_crypto(&pdev->dev);
-	if (err) {
-		platform_device_unregister(pdev);
+	if (err)
 		return err;
-	}
+
 	for (i = 0; i < num; i++) {
 		struct skcipher_alg *cra = &ixp4xx_algos[i].crypto;
 
@@ -1531,7 +1515,7 @@ static int __init ixp_module_init(void)
 	return 0;
 }
 
-static void __exit ixp_module_exit(void)
+static int ixp_crypto_remove(struct platform_device *pdev)
 {
 	int num = ARRAY_SIZE(ixp4xx_algos);
 	int i;
@@ -1546,11 +1530,16 @@ static void __exit ixp_module_exit(void)
 			crypto_unregister_skcipher(&ixp4xx_algos[i].crypto);
 	}
 	release_ixp_crypto(&pdev->dev);
-	platform_device_unregister(pdev);
+
+	return 0;
 }
 
-module_init(ixp_module_init);
-module_exit(ixp_module_exit);
+static struct platform_driver ixp_crypto_driver = {
+	.probe = ixp_crypto_probe,
+	.remove = ixp_crypto_remove,
+	.driver = { .name = "ixp4xx_crypto" },
+};
+module_platform_driver(ixp_crypto_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Christian Hohnstaedt <chohnstaedt@innominate.com>");
-- 
2.31.1

