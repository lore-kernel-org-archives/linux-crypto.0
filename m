Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E514C433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Apr 2022 20:22:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245317AbiDYUZn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Apr 2022 16:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245347AbiDYUZ2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Apr 2022 16:25:28 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817041291C9
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 13:21:46 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id j15so9233656wrb.2
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 13:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X5cmGbysdlCxPOGBZlu+t3JbOARc2ikAJ1rgjSkwJRA=;
        b=gkkLdFaSFOADuQpex7MgMLo3q4WHaUhNXEw9O3ZM6oZIBtP0PG69DqNLxD8Jq6s08D
         Hu48yf7Gi3pH5BWFcQyuoQZ902YYQ6mZWKaKZmjIxbCZyZ1m7tga+Jn8FIv9sMtWi/bh
         4FJIBHiGvi6IQXbEees57YriwC5I/0x44U2WGcgRdKXz0BEKxFg9wTsFzgKpYEPbSioT
         Pc9PPxebTrrDxqz3S5W4S6AWq8r/vZRhthOlJu0v+YnP+Im6OVBXvPSrJ2Qg5SnsDDgY
         7N2R3M+GhcEP0DqRgyvXpmMnkVXLPP3vLFje+GBGExtzvHQhdrv9DhRUJ/2/QntaeV3h
         M2WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X5cmGbysdlCxPOGBZlu+t3JbOARc2ikAJ1rgjSkwJRA=;
        b=Oo0RG9DbISkA4bksTH3S20vanWrdOTQiFMnifvA3dx6pQDBD0ZnaV4QYZk+gb7+Sn8
         MGiGNyr5jdPAHlh85xhm07FFFDHSWU6LEfQwmxf81nDXK+9BDfSj+TyV04bro8NU46sZ
         WLfAxoq2RIHq/M+hH3SNpy6DCxAyfRCYky0anZ4FewBGcnwN/CvIy4KOU7/qNn7xPYlp
         0UkwH1TZADP0ZMq44ue3tcnUZiLKrSZAgAsdLPHUdpXxPivS2MyvIR6lp2X0XhwD281M
         5/q2EPoWfj+UINO8oUXjB1eZ3TR6lD/yT+E0SPNqNyzMMTa+K9M5WHor4R3xvq5rEJwB
         U7/g==
X-Gm-Message-State: AOAM531qoXfQz9zvWf3OuOgMrwYkuCv8vDqSonmzuf3LzE541lPzyC+E
        w9at0jZ2E9myOyKemnOmAuWpTg==
X-Google-Smtp-Source: ABdhPJx0ehWDWEpwXPfa0LsCViUZIZpEn0Nh5dIMf8V9qNJCHLboNq+t7FnAM3CEdE2QivxRKgTvGw==
X-Received: by 2002:a5d:42c8:0:b0:20a:d91f:87b5 with SMTP id t8-20020a5d42c8000000b0020ad91f87b5mr6850064wrr.301.1650918104899;
        Mon, 25 Apr 2022 13:21:44 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id p3-20020a5d59a3000000b0020a9132d1fbsm11101003wrr.37.2022.04.25.13.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 13:21:44 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v6 18/33] crypto: rockchip: fix style issue
Date:   Mon, 25 Apr 2022 20:21:04 +0000
Message-Id: <20220425202119.3566743-19-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220425202119.3566743-1-clabbe@baylibre.com>
References: <20220425202119.3566743-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes some warning reported by checkpatch

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/rockchip/rk3288_crypto_ahash.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto_ahash.c b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
index 1fbab86c9238..fae779d73c84 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_ahash.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
@@ -336,7 +336,7 @@ static int rk_cra_hash_init(struct crypto_tfm *tfm)
 
 	/* for fallback */
 	tctx->fallback_tfm = crypto_alloc_ahash(alg_name, 0,
-					       CRYPTO_ALG_NEED_FALLBACK);
+						CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(tctx->fallback_tfm)) {
 		dev_err(tctx->dev->dev, "Could not load fallback driver.\n");
 		return PTR_ERR(tctx->fallback_tfm);
@@ -394,8 +394,8 @@ struct rk_crypto_tmp rk_ahash_sha1 = {
 				  .cra_init = rk_cra_hash_init,
 				  .cra_exit = rk_cra_hash_exit,
 				  .cra_module = THIS_MODULE,
-				  }
-			 }
+			}
+		}
 	}
 };
 
@@ -424,8 +424,8 @@ struct rk_crypto_tmp rk_ahash_sha256 = {
 				  .cra_init = rk_cra_hash_init,
 				  .cra_exit = rk_cra_hash_exit,
 				  .cra_module = THIS_MODULE,
-				  }
-			 }
+			}
+		}
 	}
 };
 
@@ -454,7 +454,7 @@ struct rk_crypto_tmp rk_ahash_md5 = {
 				  .cra_init = rk_cra_hash_init,
 				  .cra_exit = rk_cra_hash_exit,
 				  .cra_module = THIS_MODULE,
-				  }
 			}
+		}
 	}
 };
-- 
2.35.1

