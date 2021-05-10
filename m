Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FB7DC433B4
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 21:37:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C42E060FE7
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 21:37:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbhEJViU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 May 2021 17:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232082AbhEJViU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 May 2021 17:38:20 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8217FC061574
        for <linux-crypto@vger.kernel.org>; Mon, 10 May 2021 14:37:14 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id i9so18994387lfe.13
        for <linux-crypto@vger.kernel.org>; Mon, 10 May 2021 14:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F6J3or1SAc2IwbCi7ek22wAk4JQQDxayXS5WD4oDLPI=;
        b=lE6oCeNQIFAYQCXkjbLN8qm+ZDNB0WzeGqkdDga+tgD182oCEq2WBp0cmHKs8ftSAC
         3bMIL76svxmDEREcwiLrvKxJE3mek/kA2skt9+n0MUyGMThPdJ4DGBZQdgNrCoXJFyzO
         +56mgI+BGcMRd1/75EUxVJO6QLthMKDaC3uQ2eEygCdZioulTyGdlI3Rs8hWpe4kSPng
         HrureIRp9Ye4m5R81UNI1mO7Qfdzzoof01JLZalI2jjWv+8ekQziZ9okS5xIGT4EcEH8
         NZ91I2FwmRHuGlp3jn/sP+KCxtElM55/BHshgMS4roYqDjzW8i+pa3d0snAfMjaEwrB5
         3Fkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F6J3or1SAc2IwbCi7ek22wAk4JQQDxayXS5WD4oDLPI=;
        b=GK+Xytxa7pFjUnpkSGzQrpf2JVEhdj0BAI43QbJoYT5PekG6FJS+FhoZaSGovLjrip
         CmUIyRLCmSJa7lMhI/kGshwqAzPvOcVmUa+8JPjrg97MfDjeUQECCm/fGoO6VCryFb0M
         mTETBAp5sIq7LzNQy/vm1PL1fcstSoPbVfVi0cBQeOYBE69zcsjJ0p1MxJimtXL4fNDR
         xOy+VxmiG2eZi1G2J3Owsg0aEajgck0X1tPkwLDcdPW/GUVVg9yDCoLlfXRaRSvnfnSR
         jNpWORM6dwQXxBExWv8xEC84JHffFIYoSUfZk3qwhUe6N6LKLO11T+DYO6YMICF29hKB
         8z1Q==
X-Gm-Message-State: AOAM531XNysjIBfy/fBzhm0/K5baCKZSGMXW7yzZq1uOnXo+jmed6PPY
        XpUUhJQPgB+cQVuLGvOH2qlkzWWG+9Nmag==
X-Google-Smtp-Source: ABdhPJz2rwXNay1bX9Q1q81JNxvHlgP0BkhIIeka7GD+siDu87gDz8qKAGwgqBEapng921QvJsYY5w==
X-Received: by 2002:a05:6512:b83:: with SMTP id b3mr18378648lfv.312.1620682632823;
        Mon, 10 May 2021 14:37:12 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id q19sm1091660lff.16.2021.05.10.14.37.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 14:37:09 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-arm-kernel@lists.infradead.org,
        Imre Kaloz <kaloz@openwrt.org>,
        Krzysztof Halasa <khalasa@piap.pl>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/3] crypto: ixp4xx: convert to platform driver
Date:   Mon, 10 May 2021 23:36:32 +0200
Message-Id: <20210510213634.600866-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.30.2
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

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Herbert, David: I am looking for an ACK to take this
into the ARM SoC tree as we want to change more stuff in
the machine at the same time that we want to resolve
there.
---
 arch/arm/mach-ixp4xx/common.c  | 26 ++++++++++++++++++++++++
 drivers/crypto/Kconfig         |  3 ++-
 drivers/crypto/ixp4xx_crypto.c | 37 ++++++++++++----------------------
 3 files changed, 41 insertions(+), 25 deletions(-)

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
 
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 9a4c275a1335..aa389e741876 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -324,7 +324,8 @@ config CRYPTO_DEV_TALITOS2
 
 config CRYPTO_DEV_IXP4XX
 	tristate "Driver for IXP4xx crypto hardware acceleration"
-	depends on ARCH_IXP4XX && IXP4XX_QMGR && IXP4XX_NPE
+	depends on IXP4XX_QMGR && IXP4XX_NPE
+	depends on ARCH_IXP4XX || COMPILE_TEST
 	select CRYPTO_LIB_DES
 	select CRYPTO_AEAD
 	select CRYPTO_AUTHENC
diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 0616e369522e..879b93927e2a 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -224,8 +224,6 @@ static dma_addr_t crypt_phys;
 
 static int support_aes = 1;
 
-#define DRIVER_NAME "ixp4xx_crypto"
-
 static struct platform_device *pdev;
 
 static inline dma_addr_t crypt_virt2phys(struct crypt_ctl *virt)
@@ -432,11 +430,6 @@ static int init_ixp_crypto(struct device *dev)
 	int ret = -ENODEV;
 	u32 msg[2] = { 0, 0 };
 
-	if (! ( ~(*IXP4XX_EXP_CFG2) & (IXP4XX_FEATURE_HASH |
-				IXP4XX_FEATURE_AES | IXP4XX_FEATURE_DES))) {
-		printk(KERN_ERR "ixp_crypto: No HW crypto available\n");
-		return ret;
-	}
 	npe_c = npe_request(NPE_ID);
 	if (!npe_c)
 		return ret;
@@ -1364,26 +1357,17 @@ static struct ixp_aead_alg ixp4xx_aeads[] = {
 
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
 	for (i=0; i< num; i++) {
 		struct skcipher_alg *cra = &ixp4xx_algos[i].crypto;
 
@@ -1456,7 +1440,7 @@ static int __init ixp_module_init(void)
 	return 0;
 }
 
-static void __exit ixp_module_exit(void)
+static int ixp_crypto_remove(struct platform_device *pdev)
 {
 	int num = ARRAY_SIZE(ixp4xx_algos);
 	int i;
@@ -1471,11 +1455,16 @@ static void __exit ixp_module_exit(void)
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
2.30.2

