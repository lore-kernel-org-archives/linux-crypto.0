Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF439C65C0D
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Sep 2022 12:58:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbiIAM6v (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Sep 2022 08:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233825AbiIAM6R (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Sep 2022 08:58:17 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D1758A1F2
        for <linux-crypto@vger.kernel.org>; Thu,  1 Sep 2022 05:57:36 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id n17-20020a05600c501100b003a84bf9b68bso1392896wmr.3
        for <linux-crypto@vger.kernel.org>; Thu, 01 Sep 2022 05:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=cJE9JrNh4HvbwKuPRZxdjE4sOr8yHsnud2KqNuPrCRY=;
        b=eJrWPz90vueiK3A/H8oVrUd6nj9ISq0Y+RyhJZ5xFG8jbsh6YMVV2c6a7fS9nLg3t/
         ci+2vZYIKoiUtrJvUlRhAGFASFokpdE+VnphNpJWQENXRBUANKKuSZCSSE8uC+iF4WqR
         x+cx2Wh9Q9EELsvds6YMhjoCeRBcf3vEBl4rSOroVYiKzWUOC0S+Cf0q86SEDNpVnIPw
         +3RLYdkQdHbAzhtA/i0oT9TS2xguJ9LTjKOHuK2vWsBqIsjYUiqBT4VGa6FDNl5KtFP+
         OcnGXZlih/FsSXZ3iKnQAccmsu8Ioie5N0AYuJnzFGeWDBPJuZ9MZr9wgWmgjQSCLHoz
         OUuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=cJE9JrNh4HvbwKuPRZxdjE4sOr8yHsnud2KqNuPrCRY=;
        b=eiPQElSHqkrTIj1mHzrCUvBy05/hMtW33I4xjNhgax80wHysZ2dLn8y+dqMsQdLAAv
         pEMvsJ4Q9uA5h0zjwGGpmZM9XU2PdwQwK08NhX19sFbZp4tGDFcQPd7nhNacKNo5oRLp
         VsFb86S6K88g7SGrFRKKSgqDzlGpkx5+gNPJUedcGFl+X8TdUNvKT93IbRk6m0s1yJCo
         FHiuF5hQsHWjOSSxtabEaUXPZykNQm7dhtJrYc3qKEXNjTWH5xnAqGbAmddWmIxA3N5x
         q2yhZfGIg2wWV5f4c0hYpr2IeI/E1WhPuyLQ36cuuhOwJIfWKZm8j8DpFwJlZxAP9GXq
         077Q==
X-Gm-Message-State: ACgBeo2rGTnJLhxHHg9td3R7U75crB2T+cVU3WpZoyX2G3MT+/3ZDZfq
        bZPFhqOF5QFBUgbG9Xo0Z7l0HKfjse8I1g==
X-Google-Smtp-Source: AA6agR5DXoFlCKdfdusOr/u9AHDjFvT0CFyVXgc7HSt4BUV78VZv6oBoXK/8i4WguWPANHx56rJNgw==
X-Received: by 2002:a05:600c:29ca:b0:3a6:75fe:82af with SMTP id s10-20020a05600c29ca00b003a675fe82afmr5249856wmd.3.1662037054338;
        Thu, 01 Sep 2022 05:57:34 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id v5-20020a5d59c5000000b002257fd37877sm15556709wry.6.2022.09.01.05.57.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 05:57:33 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au, ardb@kernel.org,
        davem@davemloft.net, krzysztof.kozlowski+dt@linaro.org,
        mturquette@baylibre.com, robh+dt@kernel.org, sboyd@kernel.org
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>,
        John Keeping <john@metanate.com>
Subject: [PATCH v9 17/33] crypto: rockchip: use read_poll_timeout
Date:   Thu,  1 Sep 2022 12:56:54 +0000
Message-Id: <20220901125710.3733083-18-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220901125710.3733083-1-clabbe@baylibre.com>
References: <20220901125710.3733083-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use read_poll_timeout instead of open coding it.
In the same time, fix indentation of related comment.

Reviewed-by: John Keeping <john@metanate.com>
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

