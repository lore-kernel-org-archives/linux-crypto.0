Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47EAEC636CC
	for <linux-crypto@archiver.kernel.org>; Sat, 18 Feb 2023 20:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjBRU7e (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 18 Feb 2023 15:59:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjBRU7c (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 18 Feb 2023 15:59:32 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F276114239
        for <linux-crypto@vger.kernel.org>; Sat, 18 Feb 2023 12:59:29 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id ec30so5335939edb.10
        for <linux-crypto@vger.kernel.org>; Sat, 18 Feb 2023 12:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1CdgShzJsLfglTo1Xd8hw9nnwHbg4uyqhCM3K/USB0M=;
        b=J5nWCaZqzX/ZvFVcvj2Aiyl/2tE3nKuC6Cu1p4AccJHRmqBjypVHdWoXGMN3bU/WL3
         Dz5ZUwBPcqm7BJhvP1pJvWcjckmmTYrwSP4RZyACmiam65fA4utvDdcYuFUpC46nKSf5
         5nZ0DdBF7LMKduLKy9vVUZDADy1w+CPcM457qH2SzJompaBGiMEewf2vPD1BVqEmygQN
         E9B6RQ80LbJwLS5MVgl//+XaEgJGCcjZ6tQHO/HDdKTEJyP2y/KOTD9g2ft+k4I2H5fG
         JvVPoQGrBSy3xNjakAjnsh2jNwvVMBacVnv+B0Rgmck66c8EXb90n1tg7bNYXw9KzHss
         RESQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1CdgShzJsLfglTo1Xd8hw9nnwHbg4uyqhCM3K/USB0M=;
        b=lYKKug4UhuULRjYAGFxpv8bWe6ZcA5Q04EGUG1qh7Z1g3XeHvzez1jqY30gpji9a5U
         3bkaBOj/6tTlqj2VVDUwKOxeWvzNsCadZ8vBguOQcfz1KA6kEMp6quvAQKbfuuKx+IgU
         xD6yoyyRVzZ/XkmnDrcDwTeS2+7E0AX26pxjLkRcaPX/peCGWUy1oDegNnbSI50CqS8A
         y1kxGGT4ShvH0wg2cXZLAWug0IkxkqMrBnwG5ZpH7u/ISGhiiK0KXTwr51U+HyG6HKpO
         2VbjVV8SyAH2Ta5bGFZeQe5uwGPIUMHHqFpbF3ZVL+dVSsm1F0/t5tTih6Oh+NT+rnZ8
         8ebg==
X-Gm-Message-State: AO0yUKX4OI134CuTxI94DJzwEMvJTR7yjr1nvSV6igRo/KkBtPsjd3uM
        1ArCOV9tkbUJsjKMEqxZfE0=
X-Google-Smtp-Source: AK7set+pVqKO0qtR2rjMhz2whJ4ZFXhhPKg0n2vy/N4o4SSV+VoJpI48u988WW+cuxwn7blOgg6xFA==
X-Received: by 2002:a05:6402:18:b0:4ab:4011:ff3d with SMTP id d24-20020a056402001800b004ab4011ff3dmr4876606edu.0.1676753968290;
        Sat, 18 Feb 2023 12:59:28 -0800 (PST)
Received: from ?IPV6:2a01:c22:7b82:af00:2955:cfd1:cf55:9ea? (dynamic-2a01-0c22-7b82-af00-2955-cfd1-cf55-09ea.c22.pool.telefonica.de. [2a01:c22:7b82:af00:2955:cfd1:cf55:9ea])
        by smtp.googlemail.com with ESMTPSA id h11-20020a50cdcb000000b004aaa4da918fsm3983907edj.45.2023.02.18.12.59.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Feb 2023 12:59:27 -0800 (PST)
Message-ID: <7d1fc713-850d-d9cd-3fe2-60fd690f406a@gmail.com>
Date:   Sat, 18 Feb 2023 21:57:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: [PATCH 3/5] hwrng: meson: remove not needed call to
 platform_set_drvdata
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

drvdata isn't used, therefore remove this call.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/char/hw_random/meson-rng.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/char/hw_random/meson-rng.c b/drivers/char/hw_random/meson-rng.c
index 22e3dcc6f..a4eb8e35f 100644
--- a/drivers/char/hw_random/meson-rng.c
+++ b/drivers/char/hw_random/meson-rng.c
@@ -53,8 +53,6 @@ static int meson_rng_probe(struct platform_device *pdev)
 	data->rng.name = pdev->name;
 	data->rng.read = meson_rng_read;
 
-	platform_set_drvdata(pdev, data);
-
 	return devm_hwrng_register(dev, &data->rng);
 }
 
-- 
2.39.2


