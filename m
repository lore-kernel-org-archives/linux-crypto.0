Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6DDAC4332F
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Apr 2022 19:08:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236109AbiDMTLL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Apr 2022 15:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238039AbiDMTKc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Apr 2022 15:10:32 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440A36E561
        for <linux-crypto@vger.kernel.org>; Wed, 13 Apr 2022 12:07:42 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id m14so3993945wrb.6
        for <linux-crypto@vger.kernel.org>; Wed, 13 Apr 2022 12:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X5cmGbysdlCxPOGBZlu+t3JbOARc2ikAJ1rgjSkwJRA=;
        b=ufKL9VIndyqZ4MhiQDjEtVC6iDUF2J9QMg+q0nhVUdbMPsPRDTZ9GTWPD+QMm0v4Wo
         5isFsNTYadv/ZJUGPNU/ayUAAGLtBP5DLT8KwMGV0y4+flKUiBtiTxaXxBWnFB4q8izK
         VYrkYg+i3xfpyEh3oX3aJTeBpWABTEbUUQj7ePRtAUWC6uMtz13Wk8KaHCffBJL/KgKA
         /6psmZxukCuXVmZ0fz63YzXJRo5TFWnzbqQmLNrjOApp7pWCwCOXbZOPzjrfvz3AlDOl
         AG39NtyNohJzXnSw1EwAT9AzEB/XMMCkZ1hpiqDvz82o0tKGLjc1/5VWATSLTx10mUrB
         csCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X5cmGbysdlCxPOGBZlu+t3JbOARc2ikAJ1rgjSkwJRA=;
        b=cBb9RlN5G9W5hHv0H1sYM4bxtLLNjLuY4EF07QiBzM0LnCk9mJlBpFdqSJA5dF0dAN
         TAqhMKMx2xp6BfGRZcnmwhTShoEpybo4DP22mGA9ZW8qufcqgKiMIzg0PsPQmcRhkNeW
         IoJpEDJ5bcMPe9XMyHnPmzw0JQP4MMqbvGbbVD0289ofjBmayLMWCO85On6NX8wR0Wxv
         25Y/Oq72OQc8AG298Y2dAo6M2WksmJMWiGM71gCJy2RXMQMFSRBMCAAGPJRyFz1W7hQO
         TE+8lGBg64ykF4XNqhExeIqCQnbsD9uZ1enomEGkAeCrkofSms5xQP4c6WKu2HDi0CnI
         F6GA==
X-Gm-Message-State: AOAM533vkD79+l2I9JnFw7ZRJ9y+HN3hbn/OorOO3+YorF+9Adb2VjAi
        WQqJcML953L9cQO6LEIBcuDjXQ==
X-Google-Smtp-Source: ABdhPJx0IUtALN8qdR/PJGJ6+/VnPl6tnMq+JJvkrux0LnmYGAhqbWxi2VESjVWPpRJGThBIEAXwXg==
X-Received: by 2002:adf:816b:0:b0:203:7fae:a245 with SMTP id 98-20020adf816b000000b002037faea245mr219615wrm.619.1649876860815;
        Wed, 13 Apr 2022 12:07:40 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id o29-20020a05600c511d00b0038e3532b23csm3551852wms.15.2022.04.13.12.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 12:07:40 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v5 18/33] crypto: rockchip: fix style issue
Date:   Wed, 13 Apr 2022 19:06:58 +0000
Message-Id: <20220413190713.1427956-19-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220413190713.1427956-1-clabbe@baylibre.com>
References: <20220413190713.1427956-1-clabbe@baylibre.com>
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

