Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87336CCA486
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Jul 2022 09:07:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbiGFJHs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Jul 2022 05:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232856AbiGFJGi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Jul 2022 05:06:38 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 621272528D
        for <linux-crypto@vger.kernel.org>; Wed,  6 Jul 2022 02:05:05 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id cl1so21071608wrb.4
        for <linux-crypto@vger.kernel.org>; Wed, 06 Jul 2022 02:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/HcULCDUWUOb7zL9pkaT5teTJK7hgsOh6ToY9+UZMac=;
        b=jzmrHnL6AP5JP5ynKqMYe5yX2tYmFdVE8TwhZFHgWJFWW0o1xKFCEzfUtnEChQnGm/
         A6fQvxFRl2SJpiM4Zj/xug3hmVwSmyjac1QgUpHLeezzF65VvWPXm1axFpEEUOV6/Tvq
         FmFmnBGkQtH8EGsxTiOQ3zh9mBrKz/VYH64Ram1n1qoiNJN0DeG0dPQXrNtxp3U+wfWW
         e1NjKc352R2J8iC4t/8fmbX8ZkB6Zor6dVY+HZIwU2XX5wv7jTxP50GPf53rIHxA+20F
         12t1xepnNyAfFnfApYwl21tsc0KoW0p5KIZ1vlvUXF4b+4tt44fifPg2WA5jVg9InUm5
         TAyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/HcULCDUWUOb7zL9pkaT5teTJK7hgsOh6ToY9+UZMac=;
        b=MZvAE/FfuJ5pj6pP91o4P9PhdORAaEsfle3goel8OVRZUZPJqCzsyIRC66X3yKE2YR
         +TPizKjEAbAg6l5chvokVOyRvaLx0APqKPusUd8O2q5vxaFbyH5P91U5XYGYj/gMpKao
         b/srY5h2yJE15jyemNZxoT5WYyCqrwh5x18dvNZPzbYtXQXEnibdayYf9LwyKt5DAPPi
         2UZ9EKfx/B9b6OnW+iX8j44bkL6V6r3IjnhPALJeULHYU5axaNqJE+qLgcpqiQGXziRX
         2OHm8FAqzvlBgwwQsS3g+AuBZf1Bttcyzr8y4LMmzXPzHZMPay7rR7qrrNMH7pM+olcJ
         4XkQ==
X-Gm-Message-State: AJIora/528rmS202jdW+LvXkbs0Pk7UC+PG6cuZl2eztOLuCPXxpjlnI
        faI4RXDgaJhjYYai6C1F4aNCzw==
X-Google-Smtp-Source: AGRyM1vRD4rRZCFfC8x4QQPMMOy8cjZ8voHj35W/8OT3F5k7JS0Li37UwyHkRVf/XoUVjf0EDwXrnw==
X-Received: by 2002:adf:fb08:0:b0:21b:af81:2ffd with SMTP id c8-20020adffb08000000b0021baf812ffdmr36963912wrr.685.1657098305026;
        Wed, 06 Jul 2022 02:05:05 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id v11-20020adfe28b000000b0021d6ef34b2asm5230223wri.51.2022.07.06.02.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 02:05:04 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, mturquette@baylibre.com,
        p.zabel@pengutronix.de, robh+dt@kernel.org, sboyd@kernel.org
Cc:     linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        john@metanate.com, didi.debian@cknow.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v8 31/33] crypto: rockchip: rk_ahash_reg_init use crypto_info from parameter
Date:   Wed,  6 Jul 2022 09:04:10 +0000
Message-Id: <20220706090412.806101-32-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220706090412.806101-1-clabbe@baylibre.com>
References: <20220706090412.806101-1-clabbe@baylibre.com>
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

