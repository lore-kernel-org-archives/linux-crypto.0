Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29EF8C636CC
	for <linux-crypto@archiver.kernel.org>; Sat, 18 Feb 2023 20:59:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjBRU7a (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 18 Feb 2023 15:59:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBRU73 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 18 Feb 2023 15:59:29 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC2D14203
        for <linux-crypto@vger.kernel.org>; Sat, 18 Feb 2023 12:59:28 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id ec30so5335808edb.10
        for <linux-crypto@vger.kernel.org>; Sat, 18 Feb 2023 12:59:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WdR42IB0NMvV6bLj/h4nCD5zMdmqmCIUqAFbenEs5jY=;
        b=dojBO0MiYR79MdvodHUNO3HcDuVwsneTZzbHkTbRl7v7la1fZAKaAArywlObWLMFzt
         O2FA6+fgDCKzhYC8iS8LVKClgJzXTtTEdPRdu5mB1h2GmuLLuyiv8uHkBayR20Gltt5V
         3d8BEOWpUmBM9/uNxGYFkbXrZMI7oToWwkvlMV5WWrXVhLBPL0gLAEMh49m9HNWe8ffA
         MfYJaz6TXqVxMb9i14oLKeK7rIo2eQFvWAgcaJtjnsffWqT5cwJVk9StbcRfGZR3k5+h
         iRYcvsczzPzQNhdLxeEXrcGUcnsCoyHTUks2kUQgr7qiJJdc5heWGK6oP3lWlEVGZmYH
         I1dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WdR42IB0NMvV6bLj/h4nCD5zMdmqmCIUqAFbenEs5jY=;
        b=1nHFZEgTNM6qI8My1mRrJ5xqarTuAIUtEirgprClpgMTjoawucHJkIsMEYd/e+QKiq
         8A7WawEVnGXcW5KU26Tj3XB43K4lR5HVtYOeexpGODoW7c/Y2NAtxNt8GN5xPWffmID8
         XEh+wJ/OtJ3LPsjh/AoJrXJ51GILI5XaSE13cuAzh39V1IJbjYzpETgeBHpneIrBpz8c
         oxjyisMyXwxK6pBu65kQ7Rmrys84wHMsuK7jjaziNkK5Ip5jo6qNJcerFDEe7nzEmF6i
         PnBB3vpeXSOyf5XNsfiyxITSGPJVkvzbHEOD4SBIw7iNaK+bvhb1KDk9kdMixoPq4NiN
         Q4bQ==
X-Gm-Message-State: AO0yUKVZYc4XdJGRdKTXgG1FNah3aBiAt5UzkF7v3tu2jboMDFQcnElx
        Be9mXDOUWtfq/iukY89E01Q=
X-Google-Smtp-Source: AK7set9cn7AqlwQY14jsDUTgDMEHCJVp98ap0AM9NBu0+EJmF1xUaZbDvmql9CCf4iQ0SRty6XfT/Q==
X-Received: by 2002:a17:907:33cc:b0:895:58be:94a with SMTP id zk12-20020a17090733cc00b0089558be094amr3758894ejb.14.1676753966699;
        Sat, 18 Feb 2023 12:59:26 -0800 (PST)
Received: from ?IPV6:2a01:c22:7b82:af00:2955:cfd1:cf55:9ea? (dynamic-2a01-0c22-7b82-af00-2955-cfd1-cf55-09ea.c22.pool.telefonica.de. [2a01:c22:7b82:af00:2955:cfd1:cf55:9ea])
        by smtp.googlemail.com with ESMTPSA id de24-20020a1709069bd800b008b13c87d951sm3804629ejc.146.2023.02.18.12.59.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Feb 2023 12:59:26 -0800 (PST)
Message-ID: <abd9a2ce-5b9b-c6bd-d3bf-8791d4005231@gmail.com>
Date:   Sat, 18 Feb 2023 21:56:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: [PATCH 2/5] hwrng: meson: use devm_clk_get_optional_enabled
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

Use devm_clk_get_optional_enabled() to simplify the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/char/hw_random/meson-rng.c | 24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff --git a/drivers/char/hw_random/meson-rng.c b/drivers/char/hw_random/meson-rng.c
index e79069b6d..22e3dcc6f 100644
--- a/drivers/char/hw_random/meson-rng.c
+++ b/drivers/char/hw_random/meson-rng.c
@@ -19,7 +19,6 @@
 struct meson_rng_data {
 	void __iomem *base;
 	struct hwrng rng;
-	struct clk *core_clk;
 };
 
 static int meson_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
@@ -32,16 +31,11 @@ static int meson_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 	return sizeof(u32);
 }
 
-static void meson_rng_clk_disable(void *data)
-{
-	clk_disable_unprepare(data);
-}
-
 static int meson_rng_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct meson_rng_data *data;
-	int ret;
+	struct clk *core_clk;
 
 	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
 	if (!data)
@@ -51,21 +45,11 @@ static int meson_rng_probe(struct platform_device *pdev)
 	if (IS_ERR(data->base))
 		return PTR_ERR(data->base);
 
-	data->core_clk = devm_clk_get_optional(dev, "core");
-	if (IS_ERR(data->core_clk))
-		return dev_err_probe(dev, PTR_ERR(data->core_clk),
+	core_clk = devm_clk_get_optional_enabled(dev, "core");
+	if (IS_ERR(core_clk))
+		return dev_err_probe(dev, PTR_ERR(core_clk),
 				     "Failed to get core clock\n");
 
-	if (data->core_clk) {
-		ret = clk_prepare_enable(data->core_clk);
-		if (ret)
-			return ret;
-		ret = devm_add_action_or_reset(dev, meson_rng_clk_disable,
-					       data->core_clk);
-		if (ret)
-			return ret;
-	}
-
 	data->rng.name = pdev->name;
 	data->rng.read = meson_rng_read;
 
-- 
2.39.2


