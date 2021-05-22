Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C9C1C2B9F2
	for <linux-crypto@archiver.kernel.org>; Sat, 22 May 2021 17:01:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 661E161164
	for <linux-crypto@archiver.kernel.org>; Sat, 22 May 2021 17:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbhEVRCs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 22 May 2021 13:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbhEVRCs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 May 2021 13:02:48 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9415C061574
        for <linux-crypto@vger.kernel.org>; Sat, 22 May 2021 10:01:20 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id q7so32980029lfr.6
        for <linux-crypto@vger.kernel.org>; Sat, 22 May 2021 10:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cq6+ozOHxatifJxmjJnhjKtut+46PPMCogrnEz7m7b0=;
        b=UAVFWis8oSSM6tsabuur7WglLQPrnLt2nHbWJlJ5cssnDGXqj8Z5Yg0krfCbVG1aJe
         B6bxsqQxP4v+Er2ucGNFdE0z2ettZZlrWu+7k6kJH+P5pkcFErF3JP6fPhQQyXQtlqrV
         o3QmEKAFAWYJcSd0Qj331nOVS7xOORhqRH1xRtiUXn3DriCx3wckNnuC6rER1iqVocDu
         DAZFbrlK9hyyfEOT/zRu9CYGy4JrIy0vZPhbkY/24SWDTWo3m5L7CDlIpp6Fpaq6ztcp
         QkV0TjwWE4IRZuKAd8cAXBgqajoiOV9Oz6qWDKD49LcHcVarnFc0cKwiKyxHUkQVGEi1
         vuqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cq6+ozOHxatifJxmjJnhjKtut+46PPMCogrnEz7m7b0=;
        b=QIPKKIIU2sd4M9mvtkHAdtIwlpgvH9gnvd2GRsOOSSHUFFZ+RNhH79MZFYKTfis5wg
         C+NjYz2UK4InXHey/n43YDp23K93uzPUI+GwQ6tjy4VPH//WzDaUuNPaThEl8kXoYsRo
         qhMY7Px04oI5Fgj3bdUZ86iTMCm05kX42y+kYl89yIbZfINjWF779WBtVhEfQtbOVu2t
         d8pqFMfhwSbUnmKoTDS7USRytanMGotPVMKaPGHLj5cRgAKrcdYfjC8ELUlDK7HzJZ3K
         BVFpJBj8VXbCpVBlV67X87tsq8DM3ZFrLqV60XeoC6IGfzMg9Sdr1/pniFu7SX4O1dkT
         yeMA==
X-Gm-Message-State: AOAM532OT43Xkfe8Rz3McW2ygZycqf42sG3Kl7EXbj7oijM9rWmc1J39
        vSLCUnmkhlJEhaDYFH8Sgww55x+C46XSlQ==
X-Google-Smtp-Source: ABdhPJzG+z9Qjdc+9D2ks76dCLD7hvXbetW6b0VU5Zkz3/r4fD/i3Mllb2JarGZwVahNNNkx1jnVqA==
X-Received: by 2002:a05:6512:a83:: with SMTP id m3mr5545501lfu.44.1621702878939;
        Sat, 22 May 2021 10:01:18 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id u15sm958870lfs.67.2021.05.22.10.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 May 2021 10:01:18 -0700 (PDT)
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
Subject: [PATCH 1/3 v3] crypto: ixp4xx: convert to platform driver
Date:   Sat, 22 May 2021 18:59:11 +0200
Message-Id: <20210522165913.915100-1-linus.walleij@linaro.org>
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

