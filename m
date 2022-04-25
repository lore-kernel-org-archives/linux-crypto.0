Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A38BDC43217
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Apr 2022 20:22:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245318AbiDYUZo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Apr 2022 16:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245346AbiDYUZ2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Apr 2022 16:25:28 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A376A12D206
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 13:21:45 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id v64-20020a1cac43000000b0038cfd1b3a6dso228372wme.5
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 13:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R5vq5Bgg0GZnREfAKsIq2BCzfZlNqniOuDOVX7ptgS8=;
        b=K5apVdfdWrDo9ukPlzrj9+9KY0m9iTK/hWQiRgYqK4IyaLYt/oe+4gOgJEV1Ut+JLy
         3bGm/+BOtad6o7dyE4SKlF+fJJGsTMS/oci4c8fLSGu5VUOhJQnmQsBasBbtYncRjs+j
         LF64bbzC0iIrv0RN1Um6AYNLpbmblKVdJ6d6Fj/UNxdJDg7nrrPiqzuq+S67FRdDF7D3
         tY9wn2O0FcbC5IaVjD5RoHZIrNowsysvogyf6bzlLrc+IXBkzr0UpUQRhqRbpsB8MTRq
         P7b4e1mRhMecvuvTBsQojNto+5d0H229E2d0lqiA8J7qZniSkmkc/t8/S67ocGA9GLNu
         2pFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R5vq5Bgg0GZnREfAKsIq2BCzfZlNqniOuDOVX7ptgS8=;
        b=xb6MlgDSC9Q1Q6qAMEgmfkNms+15ZzbPExxeX9dGGWpN/Ho17eA7oXLqZGp2GMmkG8
         IuhbrQN3iVGe5q7BeyEG+VecBfKFG/9BnkklzToJ2V6gtHlx3Cl4JalalQIkJxr4DsOv
         36UqnvbWfvsG+uqs7Bkdl0OMw+/8SWW8xyngyNpE3ff3sK9RhzQhQkB8S+EYnwWfRxrp
         3OwbtZMeY4yHSfMyYktESZeo5R9PUn6+5p8qBUN+kgtGUcufbJHU/DCGzBluaVSdxGK4
         aW4p+n6zPBrsJKi1xDzeaRhbQrkPwWQmt/k6LUHzWIV8l8nG7/42f+zrIVorZABCdEjk
         NpIQ==
X-Gm-Message-State: AOAM533hkva18BKqMgVFXcdnwRiRtZeT53JZVmxVZcqDl/PfB8bBPHBQ
        17hhZdY/1ATLt9eIF7qthxANc7iOPjpFhQ==
X-Google-Smtp-Source: ABdhPJxiTR3Xs8owoOBUUZ1RHATewVGrE2jNvNEZzcFLtdHPjVHWqKyvmVdU63TsDULIwyoN/yCu1g==
X-Received: by 2002:a05:600c:348f:b0:393:dcff:f95b with SMTP id a15-20020a05600c348f00b00393dcfff95bmr15403757wmq.76.1650918103942;
        Mon, 25 Apr 2022 13:21:43 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id p3-20020a5d59a3000000b0020a9132d1fbsm11101003wrr.37.2022.04.25.13.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 13:21:43 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v6 17/33] crypto: rockchip: use read_poll_timeout
Date:   Mon, 25 Apr 2022 20:21:03 +0000
Message-Id: <20220425202119.3566743-18-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220425202119.3566743-1-clabbe@baylibre.com>
References: <20220425202119.3566743-1-clabbe@baylibre.com>
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

