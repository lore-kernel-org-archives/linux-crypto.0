Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED6C7C433ED
	for <linux-crypto@archiver.kernel.org>; Tue, 11 May 2021 13:29:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAB6961288
	for <linux-crypto@archiver.kernel.org>; Tue, 11 May 2021 13:29:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbhEKNaw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 May 2021 09:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbhEKNas (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 May 2021 09:30:48 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB46C061574
        for <linux-crypto@vger.kernel.org>; Tue, 11 May 2021 06:29:41 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id a2so7642182lfc.9
        for <linux-crypto@vger.kernel.org>; Tue, 11 May 2021 06:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0kH9GejFwRKEAZVnNqAOcSajeuUIKWFZ2mSCj9ztQJ4=;
        b=uAGW7Wix3B9nYc4qK57H9E8J1wBIayQBT+GL+0GNNbSPwzbK+A7EAyH1BrvQYIV/Y/
         XNKH1GgPPM/Vf1yTRR39ymsNaZTcsLejdvqVW9NgZ93zgGGtTE/oPlRAPwAmiEaQtMdv
         whrhHzW0cVNRxx9uRfodABWVSQXNGdskS6NIQBtbbGQB7R4UAs/s62tzAb/82BUQf5Mj
         dLxZ/w1woEFAziK4bXbX8hkSgkN94bu6+p5inWrH1hGG+/VvE3y6OCOE2G3aTZNLEc2y
         Bak25Qi+Ayi+SOMgrisdmtqPNZygmR9Isa7MgrL+VDxSV7cX6aiwKT24XmrSIrYYrb3X
         csbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0kH9GejFwRKEAZVnNqAOcSajeuUIKWFZ2mSCj9ztQJ4=;
        b=V3UQs4qO32/QUqaMescWDHvRuINjhvjrxYCTLKbVKEsWqRflbwylKJ1FzBIv3vOiaW
         fk0vMHMwdZbn/No1xTaqIjDzZ1YkvuewnzLgI7rK+tkIM44FVJxyGHKsUhMouszjkdg/
         NULmNrjBPmICL4u9SaFEIzZOOI0fLSXjTp8pzgGxX25KhCM0Y7wUoPHDnLhb9CxgK+h1
         m/8GW9JL5tPehBMQW1Zlns4lXeYpuqHV06KxXhaHyPmWAK9WZUZ/5vX+ei71WMsYvs8U
         ZgzXaWjmUCYnuQK7INX3rbiXv+iqoLfOUq+KkTn9QnPzmgfcLqjEkZo2TMToUrf1xWOv
         DPUQ==
X-Gm-Message-State: AOAM5332vppnC1jdONQyEbnKyDIKfLuS4NHHSkpB68hVFT8WNUzVgQlX
        bwAeK9Ol7qXhtIjhAOqm0jcb+A==
X-Google-Smtp-Source: ABdhPJxi8rsT3KpPgclRphHVqaEsDYLBwDAOQdff1nW5XutEVmljUOL7MLlQP1d0Vgo8ry5ZHd7HhQ==
X-Received: by 2002:a05:6512:358c:: with SMTP id m12mr20504720lfr.289.1620739779939;
        Tue, 11 May 2021 06:29:39 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id m4sm3699740ljc.20.2021.05.11.06.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 06:29:39 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Deepak Saxena <dsaxena@plexity.net>
Cc:     linux-crypto@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/5] hw_random: ixp4xx: Turn into a module
Date:   Tue, 11 May 2021 15:29:26 +0200
Message-Id: <20210511132928.814697-3-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210511132928.814697-1-linus.walleij@linaro.org>
References: <20210511132928.814697-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of just initializing always, which will invariably
create problems on multiplatform builds, turn this driver into
a module and pass a resource with the memory location.
The device only exist on the IXP46x so we only register
the device for the IXP46x SoC.

Cc: Deepak Saxena <dsaxena@plexity.net>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
The idea is to apply this through the ARM SoC tree along
with other IXP4xx refactorings.
Please tell me if you prefer another solution.
---
 arch/arm/mach-ixp4xx/common.c       | 24 ++++++++++++++++++-
 drivers/char/hw_random/ixp4xx-rng.c | 37 +++++++++++++----------------
 2 files changed, 40 insertions(+), 21 deletions(-)

diff --git a/arch/arm/mach-ixp4xx/common.c b/arch/arm/mach-ixp4xx/common.c
index f86c1bf34eea..a10aa14d09b1 100644
--- a/arch/arm/mach-ixp4xx/common.c
+++ b/arch/arm/mach-ixp4xx/common.c
@@ -237,6 +237,27 @@ static struct resource ixp46x_i2c_resources[] = {
 	}
 };
 
+/* A single 32-bit register on IXP46x */
+#define IXP4XX_HWRANDOM_BASE_PHYS	0x70002100
+
+static struct resource ixp46x_hwrandom_resource[] = {
+	{
+		.start = IXP4XX_HWRANDOM_BASE_PHYS,
+		.end = IXP4XX_HWRANDOM_BASE_PHYS + 0x3,
+		.flags = IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device ixp46x_hwrandom_device = {
+	.name           = "ixp4xx-hwrandom",
+	.id             = -1,
+	.dev = {
+		.coherent_dma_mask      = DMA_BIT_MASK(32),
+	},
+	.resource = ixp46x_hwrandom_resource,
+	.num_resources  = ARRAY_SIZE(ixp46x_hwrandom_resource),
+};
+
 /*
  * I2C controller. The IXP46x uses the same block as the IOP3xx, so
  * we just use the same device name.
@@ -249,7 +270,8 @@ static struct platform_device ixp46x_i2c_controller = {
 };
 
 static struct platform_device *ixp46x_devices[] __initdata = {
-	&ixp46x_i2c_controller
+	&ixp46x_hwrandom_device,
+	&ixp46x_i2c_controller,
 };
 
 unsigned long ixp4xx_exp_bus_size;
diff --git a/drivers/char/hw_random/ixp4xx-rng.c b/drivers/char/hw_random/ixp4xx-rng.c
index defd8176cb68..8b59aeefd4a4 100644
--- a/drivers/char/hw_random/ixp4xx-rng.c
+++ b/drivers/char/hw_random/ixp4xx-rng.c
@@ -15,6 +15,7 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/platform_device.h>
 #include <linux/init.h>
 #include <linux/bitops.h>
 #include <linux/hw_random.h>
@@ -36,35 +37,31 @@ static struct hwrng ixp4xx_rng_ops = {
 	.data_read	= ixp4xx_rng_data_read,
 };
 
-static int __init ixp4xx_rng_init(void)
+static int ixp4xx_rng_probe(struct platform_device *pdev)
 {
 	void __iomem * rng_base;
-	int err;
+	struct device *dev = &pdev->dev;
+	struct resource *res;
 
 	if (!cpu_is_ixp46x()) /* includes IXP455 */
 		return -ENOSYS;
 
-	rng_base = ioremap(0x70002100, 4);
-	if (!rng_base)
-		return -ENOMEM;
-	ixp4xx_rng_ops.priv = (unsigned long)rng_base;
-	err = hwrng_register(&ixp4xx_rng_ops);
-	if (err)
-		iounmap(rng_base);
-
-	return err;
-}
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	rng_base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(rng_base))
+		return PTR_ERR(rng_base);
 
-static void __exit ixp4xx_rng_exit(void)
-{
-	void __iomem * rng_base = (void __iomem *)ixp4xx_rng_ops.priv;
-
-	hwrng_unregister(&ixp4xx_rng_ops);
-	iounmap(rng_base);
+	ixp4xx_rng_ops.priv = (unsigned long)rng_base;
+	return devm_hwrng_register(dev, &ixp4xx_rng_ops);
 }
 
-module_init(ixp4xx_rng_init);
-module_exit(ixp4xx_rng_exit);
+static struct platform_driver ixp4xx_rng_driver = {
+	.driver = {
+		.name = "ixp4xx-hwrandom",
+	},
+	.probe = ixp4xx_rng_probe,
+};
+module_platform_driver(ixp4xx_rng_driver);
 
 MODULE_AUTHOR("Deepak Saxena <dsaxena@plexity.net>");
 MODULE_DESCRIPTION("H/W Pseudo-Random Number Generator (RNG) driver for IXP45x/46x");
-- 
2.30.2

