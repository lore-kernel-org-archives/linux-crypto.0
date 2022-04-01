Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21E52C4332F
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Apr 2022 20:19:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347812AbiDAUVJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Apr 2022 16:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352159AbiDAUUt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Apr 2022 16:20:49 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D35270871
        for <linux-crypto@vger.kernel.org>; Fri,  1 Apr 2022 13:18:25 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id u3so5810600wrg.3
        for <linux-crypto@vger.kernel.org>; Fri, 01 Apr 2022 13:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BnZbfMUuha/e58ph4xGFzpx00napP16b2Yi5TPH+Uw8=;
        b=VMGnz5BDyrX57u4altzeS1D55Q0z052+2xAefvFJ5845l+slHi0Mb1fKlR/Z6tlkzF
         7N13JbhT2Q9bQn2CiFSaY+gmr2fJcTq6LykO1V8XfUjFOehoPfUv5TbioGuVaUHDYehC
         umN1WpaCnYQTL2WxFlENEr/UaKtT5hLkwYDQCj87u+VwA8r1gUPCw5pJwv7BBnxXkKWT
         rCijcjU95hswYTA+m0QAoXApm+iif+2SPPEGGishNHy+q6TqbxuS3AWqWARAbYfIWNnT
         xPAsVQc93xVdc66gEHv8VsOjfW+QcM3XabcL/EP2J6Oez1p4wRsEJvmerAG8Xpi1M6qj
         VOlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BnZbfMUuha/e58ph4xGFzpx00napP16b2Yi5TPH+Uw8=;
        b=QPcBSQ99ASThLgDajJ2TtGvfTyZWAPqI/BNc5bk3F2K0xNtNFN5qvt8IGArjW9c2Cc
         fSYVlyBCv2R1Z+J9DInOzD9j2EU3k9pIE0b0Jq28POO2VAToneXNk1ZDc5Q3PL3/abxJ
         7Q86vuNT7PKAgNHpA4sWzqeMcnUsn98VHKsDbUjnzhCsXLYShlaDQRcgajMxl0zmyOl9
         fAIcUbkp2N/V5qYgSqsdkVXYPDk/osLVPNQOmqUKI8W+B0+VRr8d649ZzjRzYJaNotNm
         iiauPPVleuOWKeUeRlHHXfJnygGtBzYSXIw+g2BXPLqjjtEYjZewtELnYEUxfa6aVNym
         tyWg==
X-Gm-Message-State: AOAM530FSfcy7SuDPGQSmXieXoquu1Gx6h14QSbP82l0eh1y/44VcF4J
        VEXMY9oExj07NUt0E73yrrvNLg==
X-Google-Smtp-Source: ABdhPJw6b9aG6u7w0tHzEgkzE7bsoJzQjX153GTY7bCfaimXSYF6Eo0EK2Y5ddabJS5OWw8kO+v8XQ==
X-Received: by 2002:adf:d20f:0:b0:205:e6d4:7dba with SMTP id j15-20020adfd20f000000b00205e6d47dbamr7601835wrh.169.1648844304134;
        Fri, 01 Apr 2022 13:18:24 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id j16-20020a05600c191000b0038ca3500494sm17823838wmq.27.2022.04.01.13.18.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 13:18:23 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au, krzk+dt@kernel.org,
        robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v4 18/33] crypto: rockchip: fix style issue
Date:   Fri,  1 Apr 2022 20:17:49 +0000
Message-Id: <20220401201804.2867154-19-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220401201804.2867154-1-clabbe@baylibre.com>
References: <20220401201804.2867154-1-clabbe@baylibre.com>
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
index 21c9a0327ddf..58acea29bed6 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_ahash.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
@@ -337,7 +337,7 @@ static int rk_cra_hash_init(struct crypto_tfm *tfm)
 
 	/* for fallback */
 	tctx->fallback_tfm = crypto_alloc_ahash(alg_name, 0,
-					       CRYPTO_ALG_NEED_FALLBACK);
+						CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(tctx->fallback_tfm)) {
 		dev_err(tctx->dev->dev, "Could not load fallback driver.\n");
 		return PTR_ERR(tctx->fallback_tfm);
@@ -395,8 +395,8 @@ struct rk_crypto_tmp rk_ahash_sha1 = {
 				  .cra_init = rk_cra_hash_init,
 				  .cra_exit = rk_cra_hash_exit,
 				  .cra_module = THIS_MODULE,
-				  }
-			 }
+			}
+		}
 	}
 };
 
@@ -425,8 +425,8 @@ struct rk_crypto_tmp rk_ahash_sha256 = {
 				  .cra_init = rk_cra_hash_init,
 				  .cra_exit = rk_cra_hash_exit,
 				  .cra_module = THIS_MODULE,
-				  }
-			 }
+			}
+		}
 	}
 };
 
@@ -455,7 +455,7 @@ struct rk_crypto_tmp rk_ahash_md5 = {
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

