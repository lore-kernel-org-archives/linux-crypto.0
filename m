Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89C41C61DA4
	for <linux-crypto@archiver.kernel.org>; Sat, 18 Feb 2023 20:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjBRU7e (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 18 Feb 2023 15:59:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjBRU7c (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 18 Feb 2023 15:59:32 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6CC1554E
        for <linux-crypto@vger.kernel.org>; Sat, 18 Feb 2023 12:59:31 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id ez14so5103000edb.1
        for <linux-crypto@vger.kernel.org>; Sat, 18 Feb 2023 12:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P1ozOXB1+zZ3Q23vSw9o85yMZkUJu05HyoWaZK330OQ=;
        b=o1OS4IpOoma7JtDQozUijuo160vnNSserkItANHAXJnEY+bNqmKGz1eWB0sLn6uT8p
         lkm+b74YtqgbYPPRES3X43AXUvPDfTJ8sU1mfOFlkQQu22lsMtzyrV+E0ilJjzJJt2S0
         onorIRtTdKV/pq8s96rhJj6p5iSKFNKvKGSesT+OKQRPDiz0oBf8c8977UZ1nzRPU4Af
         J1b0WlvwWsi6P1Zlvov0tTeZQcj4COZ/gROZorWOtbyUYXSJw0pehhCwCxcYufTKvU38
         /HbMHlygJxeMKx+j1kLSUdtfOwUPPzwvt6le/1yc0QB+kVc4jv2SOmRNKI88/KrdelqK
         S5JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P1ozOXB1+zZ3Q23vSw9o85yMZkUJu05HyoWaZK330OQ=;
        b=JKYUsONQLb7kPAoD0bc/15nFo4J6y0/9VmkGU8hfUL9rgS2AiN91MJh05UQtW0ZQ4E
         0d/gzYIWdLSIR5ufYyYpb3v+Y9qGUlBuzlWBpqWrH+kSupHAEntb3z3hun+ugF6X9V3U
         KCQmU8l/62W0ImH217Lq0zHRi0Ti+RzC/O6hFyXibSv4Y0ldpWk5Hq67tpLz4Uc80Se2
         RU/KtWIpvnmjSxK21DLOOQAFQeZEF13WcmQ6lwXu2mb7VI8TRyw0PdwhHEsZw/11EI40
         5dib3RctwibypFYucG30hs0Ep2nraLmL+z9ApLHSUNnMdMXyx0A1p3BzFFuebZolsIws
         3eDQ==
X-Gm-Message-State: AO0yUKUtaIhNJ4n8z5LRLK9o4jAOFqQ36hmg/hb4oRrW7bzB4fHsPmGB
        lZBCHlZJ89V6r9alBvy6txg=
X-Google-Smtp-Source: AK7set+s82dof//uh76YWzHccMEghPUnl8N5ozBosD4OqaybacZZ7orcJqlrbF76QDPG5PD31rxn3Q==
X-Received: by 2002:a17:906:3b91:b0:8b1:3824:1f58 with SMTP id u17-20020a1709063b9100b008b138241f58mr4478036ejf.21.1676753969676;
        Sat, 18 Feb 2023 12:59:29 -0800 (PST)
Received: from ?IPV6:2a01:c22:7b82:af00:2955:cfd1:cf55:9ea? (dynamic-2a01-0c22-7b82-af00-2955-cfd1-cf55-09ea.c22.pool.telefonica.de. [2a01:c22:7b82:af00:2955:cfd1:cf55:9ea])
        by smtp.googlemail.com with ESMTPSA id q11-20020a50c34b000000b004ad601533a3sm3695961edb.55.2023.02.18.12.59.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Feb 2023 12:59:29 -0800 (PST)
Message-ID: <4dafc70f-be7f-bfdc-8845-bd97b27d1c4c@gmail.com>
Date:   Sat, 18 Feb 2023 21:58:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: [PATCH 4/5] hwrng: meson: use struct hw_random priv data
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

Use the priv data member of struct hwrng to make the iomem base address
available in meson_rng_read(). This allows for removing struct
meson_rng_data completely in the next step.
__force is used to silence sparse warnings.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/char/hw_random/meson-rng.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/char/hw_random/meson-rng.c b/drivers/char/hw_random/meson-rng.c
index a4eb8e35f..bf7a6e594 100644
--- a/drivers/char/hw_random/meson-rng.c
+++ b/drivers/char/hw_random/meson-rng.c
@@ -17,16 +17,14 @@
 #define RNG_DATA 0x00
 
 struct meson_rng_data {
-	void __iomem *base;
 	struct hwrng rng;
 };
 
 static int meson_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 {
-	struct meson_rng_data *data =
-			container_of(rng, struct meson_rng_data, rng);
+	void __iomem *base = (__force void __iomem *)rng->priv;
 
-	*(u32 *)buf = readl_relaxed(data->base + RNG_DATA);
+	*(u32 *)buf = readl_relaxed(base + RNG_DATA);
 
 	return sizeof(u32);
 }
@@ -36,14 +34,15 @@ static int meson_rng_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct meson_rng_data *data;
 	struct clk *core_clk;
+	void __iomem *base;
 
 	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
-	data->base = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(data->base))
-		return PTR_ERR(data->base);
+	base = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
 
 	core_clk = devm_clk_get_optional_enabled(dev, "core");
 	if (IS_ERR(core_clk))
@@ -52,6 +51,7 @@ static int meson_rng_probe(struct platform_device *pdev)
 
 	data->rng.name = pdev->name;
 	data->rng.read = meson_rng_read;
+	data->rng.priv = (__force unsigned long)base;
 
 	return devm_hwrng_register(dev, &data->rng);
 }
-- 
2.39.2


