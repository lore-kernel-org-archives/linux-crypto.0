Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEBD7C43334
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Jul 2022 09:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbiGFJGp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Jul 2022 05:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232736AbiGFJF5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Jul 2022 05:05:57 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7958324F00
        for <linux-crypto@vger.kernel.org>; Wed,  6 Jul 2022 02:04:53 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id z12so11454080wrq.7
        for <linux-crypto@vger.kernel.org>; Wed, 06 Jul 2022 02:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YefmDD2ry3pwsMvqRhlFBCTRYluZUGamucEuHQLyttA=;
        b=L7ciS97RLhOsfeKYlDlu8uDqvlYHu5nruqE3Z1CfDRdMSrwQf6knk8+pVieatsISs9
         Of0f745OYA404hCWfAOC33y8Pbuj//tIzFKT9F2/QfHQUVaxwVZMuc1GzxHfe+YMU8ny
         BQx7w2gmkVRQTqY3MKq88QPjKEt3J4loRHPXZ36XuTbmtcWnrcf2QPeNSlp+WJUPnDSR
         UyUTpl7VQhBGKBKHal/IkqvfX8qeyQeUzJ5lcUXnAc1g2VUHq2A+KSJ6AHAWqGG+3lPV
         iKP1cFPhrjskyhvHotSobOUfRmL7bKKpio+ustI4Pb/bGnI//Z/2vFkrxfdirWuHiWYa
         2vCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YefmDD2ry3pwsMvqRhlFBCTRYluZUGamucEuHQLyttA=;
        b=IJ6dWgl00c7erjNdcF3Dqp4e/I837pZyvWwnJMiRTNGMPNrwNPupaGS97W8iznjhii
         msnwgFfJ9ZTE1FTwQpwT2icZ0lRsosyRq2gGsSojQczy4qZfye9EcbpnLimt0XOxNmiN
         XTB8pF3zWtPWs1sx3kt9iTLCZTc0K3asVPzMB7yRabFpPPnwzgTpTGeRmwy+sFNWJBGi
         lExx+qw9m50Vz5vxkLvjhLtdhJJGc7HBwJ5R3GBA+my1M6UuCfNU+l7Q82WLO8fBOP7+
         OD1ewTwVmeNPCUbyqrCwUq0/zbyJl9t2lD4igkylARPOVVdBSa5frq84ePre3xT08RtM
         7D8w==
X-Gm-Message-State: AJIora/qrR/vL02w1wu4h089LRIiJaXE2woEWjO9E5hAFV/rRStPCHvw
        cv7r7Fa+unQGOFevgFcUQAWkKA==
X-Google-Smtp-Source: AGRyM1tP38P1u6ggCE6YQXSuG57GyJD05zvmba2ae23fJzXhQ4yWNHlDdFkZuypKNNeZIaGw6Pz+fw==
X-Received: by 2002:adf:fb08:0:b0:21b:af81:2ffd with SMTP id c8-20020adffb08000000b0021baf812ffdmr36962812wrr.685.1657098291934;
        Wed, 06 Jul 2022 02:04:51 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id v11-20020adfe28b000000b0021d6ef34b2asm5230223wri.51.2022.07.06.02.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 02:04:51 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, mturquette@baylibre.com,
        p.zabel@pengutronix.de, robh+dt@kernel.org, sboyd@kernel.org
Cc:     linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        john@metanate.com, didi.debian@cknow.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v8 18/33] crypto: rockchip: fix style issue
Date:   Wed,  6 Jul 2022 09:03:57 +0000
Message-Id: <20220706090412.806101-19-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220706090412.806101-1-clabbe@baylibre.com>
References: <20220706090412.806101-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes some warning reported by checkpatch

Reviewed-by: John Keeping <john@metanate.com>
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

