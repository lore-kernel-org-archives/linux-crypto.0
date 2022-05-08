Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8364C433F5
	for <linux-crypto@archiver.kernel.org>; Sun,  8 May 2022 19:18:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiEHTWQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 8 May 2022 15:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237330AbiEHTEX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 8 May 2022 15:04:23 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A051DFB5
        for <linux-crypto@vger.kernel.org>; Sun,  8 May 2022 12:00:24 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 129so7293766wmz.0
        for <linux-crypto@vger.kernel.org>; Sun, 08 May 2022 12:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X5cmGbysdlCxPOGBZlu+t3JbOARc2ikAJ1rgjSkwJRA=;
        b=ObA8HwLV8ZFqefiiD/Epo6RpgRbCDkAylyg8qYBvZLwUozCSgUvhhdGiCyXRqBi5Uu
         DeSGYBkQerugykMKnURD7RU4gp+iQ7Jvdb6eYlGDYJ2wf1/0wWS1SBfpmZq562C/B9mj
         m1HaYb54zTBt0cMfLXoHh08appx0qVtqeOltIgO2TmEcACnM2/KoHkbgF9Ynrh7MeOHk
         f5GS0FBCrHHgQCRH6zfBLExg31qD8er6y3otPMfQH7vEif0Yql5zUKQGftj/q7llkfZk
         BVsqx6CTdnaDpatmTSJ5HoAz/XqgalXJ90+3Jjk+E2jOyUmQd0fPB+doJIXlohdC2qIK
         PYOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X5cmGbysdlCxPOGBZlu+t3JbOARc2ikAJ1rgjSkwJRA=;
        b=bd4UXzghKKCTkmcu34+HPegS+080xOusYvMlrp6H6Kk/oVlAlgJr2t56aS+viXaUEG
         7Y1liKfqbxbVv4sr37Ra9pgXRcuoVEFQN3ZsTiIE0dlN1ILQfzUtlIC2q+fIFRMDdBrN
         VQQvzA3IG0ZxFr5FhFudo05QqbCqBKxH3IF9Ubi7cke9/5lHKOoqDHRinXsEk8kLZEa+
         kHyvmHYCu+S3YcXFjL83nbTPCswoU43FyDo/c/p9AlzYRYDJ3rMKN6i9QVG5Ir6A1Ytj
         /hvXSOkoIx70iIfwN0Sq4+Qx3/6erFavDTidjEtIKyipeXX8J/9fqM1l9oth5TJeyIHJ
         /dhw==
X-Gm-Message-State: AOAM533kSicHLRFqCwESJVLQUPMCo6WCPAJEsYOrF7ckcRfo011Vsqju
        i300BnIH/Q+eiZxaXF92zmEjtYQQxYhGjg==
X-Google-Smtp-Source: ABdhPJxcXLiIrVJvsw8d/HOCCiB1XgWBF8g4tXV1bJcz1ELLIIe8ycq5J5MQTxLjjLDLb3XL3w7dZg==
X-Received: by 2002:a05:600c:1c84:b0:394:5de0:245e with SMTP id k4-20020a05600c1c8400b003945de0245emr19863963wms.32.1652036423722;
        Sun, 08 May 2022 12:00:23 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id n16-20020a05600c3b9000b00394699f803dsm10552348wms.46.2022.05.08.12.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 May 2022 12:00:23 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, ardb@kernel.org, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v7 18/33] crypto: rockchip: fix style issue
Date:   Sun,  8 May 2022 18:59:42 +0000
Message-Id: <20220508185957.3629088-19-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508185957.3629088-1-clabbe@baylibre.com>
References: <20220508185957.3629088-1-clabbe@baylibre.com>
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

