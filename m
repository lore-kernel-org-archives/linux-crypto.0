Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56D0BC2B9F8
	for <linux-crypto@archiver.kernel.org>; Mon, 24 May 2021 15:55:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B9E26109F
	for <linux-crypto@archiver.kernel.org>; Mon, 24 May 2021 15:55:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235109AbhEXP5Y (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 May 2021 11:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235328AbhEXP4Z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 May 2021 11:56:25 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27C1C061360
        for <linux-crypto@vger.kernel.org>; Mon, 24 May 2021 08:09:22 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id s25so34021669ljo.11
        for <linux-crypto@vger.kernel.org>; Mon, 24 May 2021 08:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X4hWr3FMFUTmFblhPen11gcDOLFQZwv4OPOjwSTEn3A=;
        b=VteJcDQTI/tmABqtSz3k5EKwiieu35auIlGo2bNufxfu4l5GnVkEhiw9xhxE3uREdo
         LcfuTrII9rtivHAKztWIJql1J3OuCUF2pGTw4e9h3biYHzTzcExkFfaL4gXDAcZm5WxW
         sE3o/IOyNS9QX9gRb3r09me8uMXuNKGh6nrbsnLnNp9NIk+Y2S7rzSKcLxcQOasdmBou
         AWNEUdvX9HaPZXJkWemDAV0eDCJci43xPKrU1xucClzXTelLj1CEmDnpCqA0lcBA9WYj
         ekyL96RKWJv8tpyqyd+2uXm196TYrdaQdr+efo6zdEJE86diBSIqErZ35hkKjrK50yBs
         Np0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X4hWr3FMFUTmFblhPen11gcDOLFQZwv4OPOjwSTEn3A=;
        b=AD9Y1IfHVnzitHHwktoqNnC28qvv481Cz5XVgbjeFTCn2RMj6yLE68iqiK1zTjkKHl
         zY8ipa1xe6ghG68/LP8ha1jCX86znKl72/6LpK7DDqI4JCfowUpa8Qjw3LzKLReWfQrP
         5thXFqKAh8FAxKMuHrTFsAy/G6D9mpxXTTeA8OtJY6CHhZ/XYvYw+KFWbFdp7uXl2y2x
         Ly3GwBaEK7dcZo2CN3D3GJ/2lw54832VLeEIVLHvZgRONAi8FGyIoDpH7n+WOsn+r6/O
         0q57OXNQVzkr+rsyfYOJ1SdaJA8N0h5VmDv9D+/EWs54hmvuFEsUJSPwvHAlHu+VN2C0
         /Wpg==
X-Gm-Message-State: AOAM532xJNys37TsGIwqaz4o2cR4bcJMLELZ3Yc2lickJuNhFcet30n6
        8k8zKgS9rN8wP6RZ855Oj12GXPPfoyOj9g==
X-Google-Smtp-Source: ABdhPJzuK10nl9bxr8Fk3cxRcyVOzOryacKEKzytsGTSvs1Onj/qC6W/wXhhcKzdYFFwqlBguiMaRA==
X-Received: by 2002:a2e:8e21:: with SMTP id r1mr17326093ljk.166.1621868960877;
        Mon, 24 May 2021 08:09:20 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id p16sm1318877lfc.113.2021.05.24.08.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 08:09:20 -0700 (PDT)
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
Date:   Mon, 24 May 2021 17:07:15 +0200
Message-Id: <20210524150717.1090553-1-linus.walleij@linaro.org>
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

