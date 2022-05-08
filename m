Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70E5AC43219
	for <linux-crypto@archiver.kernel.org>; Sun,  8 May 2022 19:18:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbiEHTWZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 8 May 2022 15:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237403AbiEHTE2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 8 May 2022 15:04:28 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A1CDED2
        for <linux-crypto@vger.kernel.org>; Sun,  8 May 2022 12:00:26 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id a14-20020a7bc1ce000000b00393fb52a386so9661601wmj.1
        for <linux-crypto@vger.kernel.org>; Sun, 08 May 2022 12:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6pTbLIs8HmRuUEZw2l8zof3evoZumgxq0qJ8FLEkt80=;
        b=AiI/bRyGGQ5/bVZfgQzEMkLIuSs9f++QpwoWK8ajWJQyLoYyRNKmnNUNRusfvhaMPm
         +C79Lb8kJLHxTtxkitQ4Ehs1utRSKRQuLoI5J4SJr4NTztv91oJytWO7Lz6IQxBfOY/7
         XoLjug28ig1M7qcSEgyriOerEiSZHF6iXdZIkLO5odeIcQyLrzjy5u84eq/NyGQP43nU
         eyb/4pO75IP6i/JffRZxcWm71bptqXSWshBxxbOXQe75J08KpGndJ72nPr/gi3Z7oTXL
         K3bFnw+ovXz6IWfEEx67PgajJkvctuZahK4jpx26wwh6bJ24XC+eWeiUAlnVuWghFyeH
         O/IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6pTbLIs8HmRuUEZw2l8zof3evoZumgxq0qJ8FLEkt80=;
        b=xKyMdsoHBG8MxupUacyFsx2r/4nNdBdh+ZhFOL1LyGb53sdfrUS6xk7man2CXCvZM2
         qrSW6glbzlSnig3AALN/aW34/qO8QWIwA04Pg86KYdmwVQMQ+M3gFUkEHyJkOhPyz9Ui
         NXhr1QJpc+ga+qEma80MKPMpRjyE1IKG+tfE8aZ7x3X6v7BUwulxLILFH7RzY2MACA2P
         KJe/6PiRQ0c/3ecWFWRKzC+6WNFGszn6J+EicSDZ+Gmmc54qJLKQvgV1/rfH7e2v7Uur
         XcCtzsCWMjzqwmRplg59FfMUqDKAo7xnOHiDCdHzVfqp4xC8FOFuI9Dgon96B2OGSGHX
         MQRQ==
X-Gm-Message-State: AOAM531bYEWGN3rxw5tRkL96GC9++ZQDD0GUXz8UESCCDGnpjUmRY9Td
        S1kUU6U4r0u5c3p7wPbHiJKsfw==
X-Google-Smtp-Source: ABdhPJyLcjSRqR3zIziehWKJPQwNmj07Np4ulYlfpVKJwGJ4x0wDwI2QFjVRZYVBKTzLVXMZrfiWkg==
X-Received: by 2002:a05:600c:4ecc:b0:394:790d:5f69 with SMTP id g12-20020a05600c4ecc00b00394790d5f69mr13209325wmq.196.1652036425929;
        Sun, 08 May 2022 12:00:25 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id n16-20020a05600c3b9000b00394699f803dsm10552348wms.46.2022.05.08.12.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 May 2022 12:00:25 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, ardb@kernel.org, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v7 20/33] crypto: rockchip: rename ablk functions to cipher
Date:   Sun,  8 May 2022 18:59:44 +0000
Message-Id: <20220508185957.3629088-21-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508185957.3629088-1-clabbe@baylibre.com>
References: <20220508185957.3629088-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some functions have still ablk in their name even if there are
not handling ablk_cipher anymore.
So let's rename them.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 .../crypto/rockchip/rk3288_crypto_skcipher.c  | 32 +++++++++----------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
index 3bdb304aa794..d60c206e717d 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
@@ -273,7 +273,7 @@ static int rk_des3_ede_cbc_decrypt(struct skcipher_request *req)
 	return rk_handle_req(dev, req);
 }
 
-static void rk_ablk_hw_init(struct rk_crypto_info *dev, struct skcipher_request *req)
+static void rk_cipher_hw_init(struct rk_crypto_info *dev, struct skcipher_request *req)
 {
 	struct crypto_skcipher *cipher = crypto_skcipher_reqtfm(req);
 	struct crypto_tfm *tfm = crypto_skcipher_tfm(cipher);
@@ -382,7 +382,7 @@ static int rk_cipher_run(struct crypto_engine *engine, void *async_req)
 			}
 		}
 		err = 0;
-		rk_ablk_hw_init(ctx->dev, areq);
+		rk_cipher_hw_init(ctx->dev, areq);
 		if (ivsize) {
 			if (ivsize == DES_BLOCK_SIZE)
 				memcpy_toio(ctx->dev->reg + RK_CRYPTO_TDES_IV_0, ivtouse, ivsize);
@@ -448,7 +448,7 @@ static int rk_cipher_run(struct crypto_engine *engine, void *async_req)
 	return err;
 }
 
-static int rk_ablk_init_tfm(struct crypto_skcipher *tfm)
+static int rk_cipher_tfm_init(struct crypto_skcipher *tfm)
 {
 	struct rk_cipher_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
@@ -482,7 +482,7 @@ static int rk_ablk_init_tfm(struct crypto_skcipher *tfm)
 	return err;
 }
 
-static void rk_ablk_exit_tfm(struct crypto_skcipher *tfm)
+static void rk_cipher_tfm_exit(struct crypto_skcipher *tfm)
 {
 	struct rk_cipher_ctx *ctx = crypto_skcipher_ctx(tfm);
 
@@ -503,8 +503,8 @@ struct rk_crypto_tmp rk_ecb_aes_alg = {
 		.base.cra_alignmask	= 0x0f,
 		.base.cra_module	= THIS_MODULE,
 
-		.init			= rk_ablk_init_tfm,
-		.exit			= rk_ablk_exit_tfm,
+		.init			= rk_cipher_tfm_init,
+		.exit			= rk_cipher_tfm_exit,
 		.min_keysize		= AES_MIN_KEY_SIZE,
 		.max_keysize		= AES_MAX_KEY_SIZE,
 		.setkey			= rk_aes_setkey,
@@ -525,8 +525,8 @@ struct rk_crypto_tmp rk_cbc_aes_alg = {
 		.base.cra_alignmask	= 0x0f,
 		.base.cra_module	= THIS_MODULE,
 
-		.init			= rk_ablk_init_tfm,
-		.exit			= rk_ablk_exit_tfm,
+		.init			= rk_cipher_tfm_init,
+		.exit			= rk_cipher_tfm_exit,
 		.min_keysize		= AES_MIN_KEY_SIZE,
 		.max_keysize		= AES_MAX_KEY_SIZE,
 		.ivsize			= AES_BLOCK_SIZE,
@@ -548,8 +548,8 @@ struct rk_crypto_tmp rk_ecb_des_alg = {
 		.base.cra_alignmask	= 0x07,
 		.base.cra_module	= THIS_MODULE,
 
-		.init			= rk_ablk_init_tfm,
-		.exit			= rk_ablk_exit_tfm,
+		.init			= rk_cipher_tfm_init,
+		.exit			= rk_cipher_tfm_exit,
 		.min_keysize		= DES_KEY_SIZE,
 		.max_keysize		= DES_KEY_SIZE,
 		.setkey			= rk_des_setkey,
@@ -570,8 +570,8 @@ struct rk_crypto_tmp rk_cbc_des_alg = {
 		.base.cra_alignmask	= 0x07,
 		.base.cra_module	= THIS_MODULE,
 
-		.init			= rk_ablk_init_tfm,
-		.exit			= rk_ablk_exit_tfm,
+		.init			= rk_cipher_tfm_init,
+		.exit			= rk_cipher_tfm_exit,
 		.min_keysize		= DES_KEY_SIZE,
 		.max_keysize		= DES_KEY_SIZE,
 		.ivsize			= DES_BLOCK_SIZE,
@@ -593,8 +593,8 @@ struct rk_crypto_tmp rk_ecb_des3_ede_alg = {
 		.base.cra_alignmask	= 0x07,
 		.base.cra_module	= THIS_MODULE,
 
-		.init			= rk_ablk_init_tfm,
-		.exit			= rk_ablk_exit_tfm,
+		.init			= rk_cipher_tfm_init,
+		.exit			= rk_cipher_tfm_exit,
 		.min_keysize		= DES3_EDE_KEY_SIZE,
 		.max_keysize		= DES3_EDE_KEY_SIZE,
 		.setkey			= rk_tdes_setkey,
@@ -615,8 +615,8 @@ struct rk_crypto_tmp rk_cbc_des3_ede_alg = {
 		.base.cra_alignmask	= 0x07,
 		.base.cra_module	= THIS_MODULE,
 
-		.init			= rk_ablk_init_tfm,
-		.exit			= rk_ablk_exit_tfm,
+		.init			= rk_cipher_tfm_init,
+		.exit			= rk_cipher_tfm_exit,
 		.min_keysize		= DES3_EDE_KEY_SIZE,
 		.max_keysize		= DES3_EDE_KEY_SIZE,
 		.ivsize			= DES_BLOCK_SIZE,
-- 
2.35.1

