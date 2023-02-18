Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6833DC6379F
	for <linux-crypto@archiver.kernel.org>; Sat, 18 Feb 2023 20:59:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbjBRU7f (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 18 Feb 2023 15:59:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBRU7d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 18 Feb 2023 15:59:33 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868C714EA9
        for <linux-crypto@vger.kernel.org>; Sat, 18 Feb 2023 12:59:32 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id t19so4722633edi.13
        for <linux-crypto@vger.kernel.org>; Sat, 18 Feb 2023 12:59:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5/WDNEbgisYy7HKbKtg3x5sM5lSnk3f53fWjIWsdioM=;
        b=Y5gt30hgLmyK/3disDGoNv7X5srdEOUlDiSjD/3a48VwOFAiYNikZNzBVmseWIQhc8
         wmvRaOKgWbilnzKnxSlytLpkd6KzKJsiKCs5+q7xHD+eKN8kEQisu/hE0KiDbbqM0cFb
         n8vcdXIsovnFq0a8/68NvPOMDA39RCIuJfGy4fvcKRKD5zFwvtQmFoB4LT/zV8KB1qFH
         flHf1ONOnMquhWR1LE+59FNbM1msej2cg85DdtkUbl4LBz7z73l521/1eoGY0jjpxAId
         +swPpoZFN9EnsJt2paeQsP7Ufukg4c+eKVMcz+ZDSjakeyNohtIZcc9p2MhAW6l67PEh
         X9rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5/WDNEbgisYy7HKbKtg3x5sM5lSnk3f53fWjIWsdioM=;
        b=wAKuOdEmhHGMfJHqsfzKxTqPogg9OSM86kgy5JxxJ3pPiAxQlWcjOdFaJLK56cNcHE
         9u257otqG+0Z9JlGWH7KdwtfHRczfVgOczW8ZlmCPGQnkqPkTMX7CRoBsjuLeymgS12Y
         oWukwkE5C+1oSth7INqag01TYRvfKF80Mcrmmem6uSTbWShbltfaMaY1EGaea7Qm5DGT
         ooDc/n4BXiDaZ89xGm3Jvu0YIQOT8gC9A51M7WgCY+7n/hCDUk1WeZeuEquOr5J/hqUd
         ySvIU+zYJf7nLzDpkBqzfTqF0zbNXoqwC53b8JALO/tGQPOwPpzT8niVDmzgYO4r1ARe
         8blQ==
X-Gm-Message-State: AO0yUKXGgbOSGR1vKP6xCog9hDe/xPlc28YqOiQTS96FUddhTIv67mop
        oOSgl9DufBvkFoVxiTtaWhE=
X-Google-Smtp-Source: AK7set+1fXie4wFZicnTmT6HJm5KRsiKzoOl5iHtScvxq3/fscAEsLtL00IXPlWW+dYOolN6W6DI8w==
X-Received: by 2002:a17:906:aad6:b0:8b1:3b95:cf3f with SMTP id kt22-20020a170906aad600b008b13b95cf3fmr4095079ejb.70.1676753971103;
        Sat, 18 Feb 2023 12:59:31 -0800 (PST)
Received: from ?IPV6:2a01:c22:7b82:af00:2955:cfd1:cf55:9ea? (dynamic-2a01-0c22-7b82-af00-2955-cfd1-cf55-09ea.c22.pool.telefonica.de. [2a01:c22:7b82:af00:2955:cfd1:cf55:9ea])
        by smtp.googlemail.com with ESMTPSA id s21-20020a1709060c1500b00887f6c39ac0sm3762386ejf.98.2023.02.18.12.59.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Feb 2023 12:59:30 -0800 (PST)
Message-ID: <db2112cf-ff3e-e2e6-9eca-1b5956d921fd@gmail.com>
Date:   Sat, 18 Feb 2023 21:59:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: [PATCH 5/5] hwrng: meson: remove struct meson_rng_data
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Olivia Mackall <olivia@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
References: <26216f60-d9b9-f40c-2c2a-95b3fde6c3bc@gmail.com>
In-Reply-To: <26216f60-d9b9-f40c-2c2a-95b3fde6c3bc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Because no other members of struct meson_rng_data are left,
we can remove it completely.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/char/hw_random/meson-rng.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/char/hw_random/meson-rng.c b/drivers/char/hw_random/meson-rng.c
index bf7a6e594..633d98b48 100644
--- a/drivers/char/hw_random/meson-rng.c
+++ b/drivers/char/hw_random/meson-rng.c
@@ -16,10 +16,6 @@
 
 #define RNG_DATA 0x00
 
-struct meson_rng_data {
-	struct hwrng rng;
-};
-
 static int meson_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 {
 	void __iomem *base = (__force void __iomem *)rng->priv;
@@ -32,12 +28,12 @@ static int meson_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 static int meson_rng_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct meson_rng_data *data;
 	struct clk *core_clk;
 	void __iomem *base;
+	struct hwrng *rng;
 
-	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
-	if (!data)
+	rng = devm_kzalloc(dev, sizeof(*rng), GFP_KERNEL);
+	if (!rng)
 		return -ENOMEM;
 
 	base = devm_platform_ioremap_resource(pdev, 0);
@@ -49,11 +45,11 @@ static int meson_rng_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, PTR_ERR(core_clk),
 				     "Failed to get core clock\n");
 
-	data->rng.name = pdev->name;
-	data->rng.read = meson_rng_read;
-	data->rng.priv = (__force unsigned long)base;
+	rng->name = pdev->name;
+	rng->read = meson_rng_read;
+	rng->priv = (__force unsigned long)base;
 
-	return devm_hwrng_register(dev, &data->rng);
+	return devm_hwrng_register(dev, rng);
 }
 
 static const struct of_device_id meson_rng_of_match[] = {
-- 
2.39.2


