Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DAA2C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Apr 2022 19:08:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbiDMTKg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Apr 2022 15:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238001AbiDMTKE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Apr 2022 15:10:04 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D266F4AC
        for <linux-crypto@vger.kernel.org>; Wed, 13 Apr 2022 12:07:41 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id u3so4005999wrg.3
        for <linux-crypto@vger.kernel.org>; Wed, 13 Apr 2022 12:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R5vq5Bgg0GZnREfAKsIq2BCzfZlNqniOuDOVX7ptgS8=;
        b=kyPfgqPdX5bKPeUlT6rwUXDmRRnm9phoOWKd2lLRfBui57/iosZbbybnVQd1+O9PHA
         rE70HAXbBr6Z5MYEOVk0excL9TlcmbNdZZ10pQEQDR8IWVYiMm/J6VuKX1iwxs02yTux
         OHVpdgNN0w0h3xasHgaLdCA0wOicFnSU1+kwZiS1ug+A0RDQZjos9TocTMwetvJFXvcr
         wACUQkT8xa5/TztjvoDqCAN0suUwAl06Y9GwOFuluzcH07bcIm4gBEFmxu1wIa54wNJH
         lIAVz7wDoPPKNdR0lx/7QtDZy5rNYVindttxvUF5ikRvLdVQfi7RbOPJPqOEto4tDwaL
         DjtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R5vq5Bgg0GZnREfAKsIq2BCzfZlNqniOuDOVX7ptgS8=;
        b=0ciw0WaaWqk6d3f/cpg9Dp4eROvG/9deQYdkI0fP6S943vG48NuGs8t1jVIY3m64fn
         LYcu+1DfdaJUjEhE8GPSHM+oTjTQ6tEtUOJ/0qvS6szE54GE8xyzBw31fIahHBxL4f6l
         MDvxcLvIxtpyJHuuxEQoichME6qhduqVAHShEQREA7a2o7BBr/zu9Pp7rBlMpVJjGxED
         cQh+ZlXXBCzx52QdTn1NAT2Mr2FvXNvkY24wjiGklz9AT6GLktTPkbAicO90B51Efn32
         FbJyuZjML5o1xPn6IG9+6PbqEsPHLQtWTg3j4hvDvT7BKkWeEs4aIXPDGJ3qdCxBzmYe
         kHWA==
X-Gm-Message-State: AOAM531rJyNMQ1oH6dOIBXwpN83NmCtmgpjCv04bH7xjJq8+oltmAWHG
        MXgMRddKGBrfnJAr+RodEWkUew==
X-Google-Smtp-Source: ABdhPJzC+WzU/9ehOhCA2MTjsi0jXGnxry8CN6OaecUq8DOc3IWTzYkhUPWe8nUjlNIo8D3cPZwu+w==
X-Received: by 2002:adf:f508:0:b0:207:a8fe:c8bd with SMTP id q8-20020adff508000000b00207a8fec8bdmr224403wro.313.1649876859713;
        Wed, 13 Apr 2022 12:07:39 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id o29-20020a05600c511d00b0038e3532b23csm3551852wms.15.2022.04.13.12.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 12:07:39 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v5 17/33] crypto: rockchip: use read_poll_timeout
Date:   Wed, 13 Apr 2022 19:06:57 +0000
Message-Id: <20220413190713.1427956-18-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220413190713.1427956-1-clabbe@baylibre.com>
References: <20220413190713.1427956-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use read_poll_timeout instead of open coding it.
In the same time, fix indentation of related comment.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/rockchip/rk3288_crypto_ahash.c | 24 +++++++++----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto_ahash.c b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
index 137013bd4410..1fbab86c9238 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_ahash.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
@@ -10,6 +10,7 @@
  */
 #include <linux/device.h>
 #include <asm/unaligned.h>
+#include <linux/iopoll.h>
 #include "rk3288_crypto.h"
 
 /*
@@ -295,18 +296,17 @@ static int rk_hash_run(struct crypto_engine *engine, void *breq)
 		sg = sg_next(sg);
 	}
 
-		/*
-		 * it will take some time to process date after last dma
-		 * transmission.
-		 *
-		 * waiting time is relative with the last date len,
-		 * so cannot set a fixed time here.
-		 * 10us makes system not call here frequently wasting
-		 * efficiency, and make it response quickly when dma
-		 * complete.
-		 */
-	while (!CRYPTO_READ(tctx->dev, RK_CRYPTO_HASH_STS))
-		udelay(10);
+	/*
+	 * it will take some time to process date after last dma
+	 * transmission.
+	 *
+	 * waiting time is relative with the last date len,
+	 * so cannot set a fixed time here.
+	 * 10us makes system not call here frequently wasting
+	 * efficiency, and make it response quickly when dma
+	 * complete.
+	 */
+	readl_poll_timeout(tctx->dev->reg + RK_CRYPTO_HASH_STS, v, v == 0, 10, 1000);
 
 	for (i = 0; i < crypto_ahash_digestsize(tfm) / 4; i++) {
 		v = readl(tctx->dev->reg + RK_CRYPTO_HASH_DOUT_0 + i * 4);
-- 
2.35.1

