Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBFD2C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Apr 2022 20:23:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245484AbiDYU0v (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Apr 2022 16:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245334AbiDYU0Y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Apr 2022 16:26:24 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC826133182
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 13:22:07 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id n126-20020a1c2784000000b0038e8af3e788so260640wmn.1
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 13:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/HcULCDUWUOb7zL9pkaT5teTJK7hgsOh6ToY9+UZMac=;
        b=xqUTU8xMQZJdiUUUhaiatxHt2pJ0KhhDESFWwIHZFGx0fwxOw1AAnJ3XSHyxDgaIlc
         NMdO0z37i6kh2m1Jx0hX0V+NHdfqEjupyl5rDg9uCzzOIBcdeo+aAU1V2H8oeMErHOsK
         JkIfpXJwmsb9/FPqYTpj2fsoSrbZC7Df405Tte52Pe10azA6zLzQFy6Nlcuq6uczsU3x
         HVm6sEXoG4asvDWClJmbwxnKYAX4uIa9vPkrFIracvHWeh9I5EVw7jeT+D1ATmSLH34k
         Owjjh+WVYq6JgCzrypD9mTU7tWEXkxETAVxJ7BuFtzewjAwbuu2UfjNdJ8o4806Wu+tR
         5sjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/HcULCDUWUOb7zL9pkaT5teTJK7hgsOh6ToY9+UZMac=;
        b=kck4jWWQECv7oc2PxBjdpjK935QWANc8zgWEyHuevnESXv2pLI+a8YcJ1dbwHt9k4G
         45MIjUAP9EOLO3IaYL4VP4+dJXa44nmGumx6NrGXShaGTr+SBwiJQcRq//UmwKcV5DS9
         MK9IYbGKcCY4YunWLhh0HkfseZzB9xy7eOsGcBLlYNhtiokh56qikZtbKyT8g9hq2C19
         f4Eqcz56pc6xYDV2p+nSQmp24AyOH3iZ7D/EIHPIdhuUzw6V1jMeFDg7OmdaQBOlGfvm
         AYA1QL8hT8e3Bie2nhmBjTE6k2b5uo6X5l77RCReM7xZVwpkudt4f/9DTVIrQ1snX12W
         8pyg==
X-Gm-Message-State: AOAM530GbcB2Fd6kdjD3k4NWss5VmlrOkDvGOZ3+NfaRxPp4sAJRNU26
        ck5r7PJldvD7Th3enZebYAbz2A==
X-Google-Smtp-Source: ABdhPJyFG59O4Q5s2JRra7taaFzIKxx9HKl6TygfF76w2bWP4ST4HKjFihAcupMDMyl5BAuFscFu/A==
X-Received: by 2002:a1c:2c6:0:b0:38f:f280:caa2 with SMTP id 189-20020a1c02c6000000b0038ff280caa2mr18100378wmc.87.1650918117419;
        Mon, 25 Apr 2022 13:21:57 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id p3-20020a5d59a3000000b0020a9132d1fbsm11101003wrr.37.2022.04.25.13.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 13:21:56 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v6 31/33] crypto: rockchip: rk_ahash_reg_init use crypto_info from parameter
Date:   Mon, 25 Apr 2022 20:21:17 +0000
Message-Id: <20220425202119.3566743-32-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220425202119.3566743-1-clabbe@baylibre.com>
References: <20220425202119.3566743-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

rk_ahash_reg_init() use crypto_info from TFM context, since we will
remove it, let's take if from parameters.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/rockchip/rk3288_crypto_ahash.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto_ahash.c b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
index d1bf68cb390d..30f78256c955 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_ahash.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
@@ -78,12 +78,10 @@ static int zero_message_process(struct ahash_request *req)
 	return 0;
 }
 
-static void rk_ahash_reg_init(struct ahash_request *req)
+static void rk_ahash_reg_init(struct ahash_request *req,
+			      struct rk_crypto_info *dev)
 {
 	struct rk_ahash_rctx *rctx = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct rk_ahash_ctx *tctx = crypto_ahash_ctx(tfm);
-	struct rk_crypto_info *dev = tctx->dev;
 	int reg_status;
 
 	reg_status = CRYPTO_READ(dev, RK_CRYPTO_CTRL) |
@@ -281,7 +279,7 @@ static int rk_hash_run(struct crypto_engine *engine, void *breq)
 		goto theend;
 	}
 
-	rk_ahash_reg_init(areq);
+	rk_ahash_reg_init(areq, rkc);
 
 	while (sg) {
 		reinit_completion(&rkc->complete);
-- 
2.35.1

