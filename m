Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93BB8C433F5
	for <linux-crypto@archiver.kernel.org>; Sun,  8 May 2022 19:18:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbiEHTWa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 8 May 2022 15:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238048AbiEHTEn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 8 May 2022 15:04:43 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5051BDEA0
        for <linux-crypto@vger.kernel.org>; Sun,  8 May 2022 12:00:39 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id v12so16671980wrv.10
        for <linux-crypto@vger.kernel.org>; Sun, 08 May 2022 12:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JBfzxCMFwSqtUUAKgLYX1NAdCBaYrQJEwA5Wp5fjHpE=;
        b=X49Rs6jVUOJqsKLd9jCnOcyVt8anEgCOlsz0UpHKBZyITY/VIqK5RzWuqqpOR7ud/R
         36j9fkZwvcmYiYS0Zza4NW9ELQ/m0CMALIYo7TuUduPJtbV2e/3S4WRYiH9tZeHxPcOU
         ce4I0mHJlDdMRdb4g8L9DmIsb3pXWaL5cYIyroTictucbxTR7bk5+jp6zZgujAKg8dxo
         cRnspmco7/r682hMxNP6cA2SWdZVgH8F7pQHZqxMcxmEWlmOGpq1CRd5ypd1RlFhNVpE
         9+ZTm4JaP0aN+xRfnK29crWT9l/6tP+1r72mSDzpnar1HbAJqPEuaBZg7/3O1MDXHXkc
         VLVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JBfzxCMFwSqtUUAKgLYX1NAdCBaYrQJEwA5Wp5fjHpE=;
        b=zd/Zuq0276mKtlPrbHgma014RtH5ayT2r/jOi/rW2OXfBDzjpjJzHAgQPpL/tRJPTs
         smvoL3JlRTklaiWXjG0uwgU+e28a+pin9w3Y/M+HQetn7U+GStMz7bu1MKlBSJBwW6YH
         iV2QacialbymTD3J6HhzoiNUtbWmiqnR8PvmRNfROSUAzbABPLcAOCAw9lpmK9PVVzDR
         m5QpvTz6DXR0SyeyCnqQzJRxT8u5zmT35OAtsFS1grlkvN6j175SFRUpc/jl0qVDAgc/
         cU5Q6LU+oboF0IDgeHOkpH0wgaqMukG2oe0yK3pv9ftPRAu7BaU+cUnnqbQ2dyYDNBek
         ZKfQ==
X-Gm-Message-State: AOAM5319CCDjI/2LlpyCQ9u1wGC2oRn62EQp8SltkTa3bpm9O/Vt/ifw
        pbDeYKgYG294hVLuyRQAFDY+6g==
X-Google-Smtp-Source: ABdhPJzncxhGn7VRrhx5Bk1UNUpsBAsFpyNOBZ0pRTwwqnTzrOzKrSuLmPcV6khsNUhAKov1Q6ZN/A==
X-Received: by 2002:a5d:47cc:0:b0:20c:6b7c:8a19 with SMTP id o12-20020a5d47cc000000b0020c6b7c8a19mr10648752wrc.608.1652036438918;
        Sun, 08 May 2022 12:00:38 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id n16-20020a05600c3b9000b00394699f803dsm10552348wms.46.2022.05.08.12.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 May 2022 12:00:38 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, ardb@kernel.org, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v7 32/33] crypto: rockchip: permit to have more than one reset
Date:   Sun,  8 May 2022 18:59:56 +0000
Message-Id: <20220508185957.3629088-33-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508185957.3629088-1-clabbe@baylibre.com>
References: <20220508185957.3629088-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The RK3399 has 3 resets, so the driver to handle multiple resets.
This is done by using devm_reset_control_array_get_exclusive().

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/rockchip/rk3288_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index d6d78b8af57c..9ba9b9e433c4 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -276,7 +276,7 @@ static int rk_crypto_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	crypto_info->rst = devm_reset_control_get(dev, "crypto-rst");
+	crypto_info->rst = devm_reset_control_array_get_exclusive(dev);
 	if (IS_ERR(crypto_info->rst)) {
 		err = PTR_ERR(crypto_info->rst);
 		goto err_crypto;
-- 
2.35.1

