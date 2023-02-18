Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE0E3C61DA4
	for <linux-crypto@archiver.kernel.org>; Sat, 18 Feb 2023 20:59:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjBRU72 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 18 Feb 2023 15:59:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBRU71 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 18 Feb 2023 15:59:27 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9449814203
        for <linux-crypto@vger.kernel.org>; Sat, 18 Feb 2023 12:59:26 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id ee44so2159241edb.5
        for <linux-crypto@vger.kernel.org>; Sat, 18 Feb 2023 12:59:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0QTO9PpApH85uzwvnB99HB5hu6zu/FbxafdLqyL29Co=;
        b=d+ccR/0D22hSA5kCVrSjDpZIOSfgkYctT3r2H8LEPv5Sv5egD9jlKCfSt8ALY+6wPI
         Xi2vsWD0sHItyC48fZVquxpOUnsiRll6ZOBc/f/CMw+t4N0hX5TqqpDhPYSFh8eNfXnf
         evuZDeYi8/fgFpvN/fZCFfaIn5HBB+uNxmz/316Fb4g1jOvt7iSdxRoJncXjTTRtY55f
         0TL2uIMVHWzKa8I1qACp5dGDXBFvohIMcLnMDwjnOCeR3y/Vmrb1TweKvilO7B2PE67l
         Z+TnCG5yFHEIC0WnA0mL4W52T+7qniFvmpVdcD6Re+ziHouevcp8xbMQfp6CWtnT6Gja
         NHhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0QTO9PpApH85uzwvnB99HB5hu6zu/FbxafdLqyL29Co=;
        b=N5Z2ICNzH1ZHRen1cABRfJxMYauYgI8hrnPV17ryX8pLJ4+0omXMG91vVDR6z584KO
         EPmYiFgH+Z/AMh/kKSow1457JSgOowFNoeKR5K7VvtkG2uff+CesCOf8SAZKF/M10/2P
         pf7Q7o8tSR0hJ6F0aRO5GU9U5acDL+e62eMj+rJCH2uwTzc8DOJSsTDKKKzoo3f0KbMK
         WB9WeGYsFwrbNj0ExSUsf+wBVbHUGsR/38/rM/5qjv4LXubue0Kkh1FsDQa2A6Nr+YDx
         JFmhS1/75KH0pRMCuZ9G8Gak/uNgTb2OwGVU+5h+dyQ3GYnsgVlPZ8vu6rSfOKFGz6v5
         xiMw==
X-Gm-Message-State: AO0yUKXKeQkE0Zmbw7mQnfIjA9NJEokKb7vsrwPNJI8T2xvTRsqCRgAm
        d9ASUMpIN22B3VBhVeeDYak=
X-Google-Smtp-Source: AK7set/dc9CZIosai3n1UIgyVUHTcMBDJdwpKTJKT2OsjIIjpXeznyAsfrrChlPzNtdR+d71IHx4pA==
X-Received: by 2002:aa7:c2d3:0:b0:4ad:7bd3:bb44 with SMTP id m19-20020aa7c2d3000000b004ad7bd3bb44mr6597778edp.35.1676753965050;
        Sat, 18 Feb 2023 12:59:25 -0800 (PST)
Received: from ?IPV6:2a01:c22:7b82:af00:2955:cfd1:cf55:9ea? (dynamic-2a01-0c22-7b82-af00-2955-cfd1-cf55-09ea.c22.pool.telefonica.de. [2a01:c22:7b82:af00:2955:cfd1:cf55:9ea])
        by smtp.googlemail.com with ESMTPSA id f29-20020a50a6dd000000b004ad6e3e4a26sm3628583edc.84.2023.02.18.12.59.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Feb 2023 12:59:24 -0800 (PST)
Message-ID: <08fa1416-8786-b442-2a45-0ba669992639@gmail.com>
Date:   Sat, 18 Feb 2023 21:55:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: [PATCH 1/5] hwrng: meson: remove unused member of struct
 meson_rng_data
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

Member pdev isn't used, remove it.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/char/hw_random/meson-rng.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/char/hw_random/meson-rng.c b/drivers/char/hw_random/meson-rng.c
index 8bb30282c..e79069b6d 100644
--- a/drivers/char/hw_random/meson-rng.c
+++ b/drivers/char/hw_random/meson-rng.c
@@ -18,7 +18,6 @@
 
 struct meson_rng_data {
 	void __iomem *base;
-	struct platform_device *pdev;
 	struct hwrng rng;
 	struct clk *core_clk;
 };
@@ -48,8 +47,6 @@ static int meson_rng_probe(struct platform_device *pdev)
 	if (!data)
 		return -ENOMEM;
 
-	data->pdev = pdev;
-
 	data->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(data->base))
 		return PTR_ERR(data->base);
-- 
2.39.2


