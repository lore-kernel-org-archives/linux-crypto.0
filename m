Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82112C65C0D
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Sep 2022 13:00:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234222AbiIANAe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Sep 2022 09:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234026AbiIAM6q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Sep 2022 08:58:46 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8310091D0A
        for <linux-crypto@vger.kernel.org>; Thu,  1 Sep 2022 05:57:48 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id ay39-20020a05600c1e2700b003a5503a80cfso1399273wmb.2
        for <linux-crypto@vger.kernel.org>; Thu, 01 Sep 2022 05:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=YTCwVt48y9KJqKpi4AoXVBEGpD4ZzF22SRLhTWJSe6w=;
        b=EOV95Uw3PoZc2j6523bZTUxn9QTySQ84KGdXEHr997lk+YH2zr5s/Mwz5UlNAJaKCX
         ZhbdscKpmmJLhtL3UcQOksr9SssHRPpXXR0JJrXivyqEhtfrwLQc3MSBg6V4NCatotp6
         dzJV3Y8Hm2IRw0bieMfs8PhlVWhqjJf/+qXPnmnepVTkPMQR2HDvVwdsk7HZgPFHN5sV
         0TGKaJjVCqi31kUkyUSArX27KuSEYHuKvjDAKlVHSbJc1YnKc3dDE/ekTAGw81Hr6+Vf
         nOsvDNG15zueciMgFJh3RJ3luEUSE5yTe1yBovzCArSzNJdgDoFctu+tDjUvsx3gV52L
         EnDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=YTCwVt48y9KJqKpi4AoXVBEGpD4ZzF22SRLhTWJSe6w=;
        b=M5XUV91QCyDGeXYr9+qGBPe6ZRUd1J/AywbnhZAifgCLekbPwvSSlJYgQa1eN0uZID
         3JPkoP/ePL/yR50ypIE1pzq0ZbNjkdtpTFA6BjDD2roNkgYdIgerPFK1JupFO3SG5VBR
         zHfapCfro/E9s5j6CoWi5BCkQ5rIoIWAMlV22V7J6R/7Wz1GmX2geZyuRWpWvazDGM0C
         pY3r2e+23MS6QCYw5HiPvYK0OJFAILsQAQByTFo1sxk/Wzsx0Z3JTWSVj33h3tK50n+H
         5waxuTwSfxO1MrkiJxDolqjsL3BEBI5updF5UGrRmUJuKtrhIyG7EIhYm4vK4tExRS2p
         za8Q==
X-Gm-Message-State: ACgBeo1Bfr9rrunTSukRx23Za37o0+eQs6xTsAv7lslma51ZiyVEZvXw
        ePRO+MulInhIhyB0sGUYQUPXeg==
X-Google-Smtp-Source: AA6agR4DhNkSNVscrQtiJc/N+98GVw5yV+gj7nXevqNBdZiMDks/VsUWt/2HoJ53BUNqjfR268aZrA==
X-Received: by 2002:a05:600c:310b:b0:3a6:8970:27fc with SMTP id g11-20020a05600c310b00b003a6897027fcmr5081113wmo.98.1662037066767;
        Thu, 01 Sep 2022 05:57:46 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id v5-20020a5d59c5000000b002257fd37877sm15556709wry.6.2022.09.01.05.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 05:57:46 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au, ardb@kernel.org,
        davem@davemloft.net, krzysztof.kozlowski+dt@linaro.org,
        mturquette@baylibre.com, robh+dt@kernel.org, sboyd@kernel.org
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v9 29/33] crypto: rockchip: store crypto_info in request context
Date:   Thu,  1 Sep 2022 12:57:06 +0000
Message-Id: <20220901125710.3733083-30-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220901125710.3733083-1-clabbe@baylibre.com>
References: <20220901125710.3733083-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The crypto_info to use must be stored in the request context.
This will help when 2 crypto_info will be available on rk3399.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/rockchip/rk3288_crypto.h          |  2 ++
 drivers/crypto/rockchip/rk3288_crypto_ahash.c    | 14 ++++++--------
 drivers/crypto/rockchip/rk3288_crypto_skcipher.c |  6 ++++--
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.h b/drivers/crypto/rockchip/rk3288_crypto.h
index 28bf09fe1c1d..ff9fc25972eb 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.h
+++ b/drivers/crypto/rockchip/rk3288_crypto.h
@@ -215,6 +215,7 @@ struct rk_ahash_ctx {
 
 /* the private variable of hash for fallback */
 struct rk_ahash_rctx {
+	struct rk_crypto_info		*dev;
 	struct ahash_request		fallback_req;
 	u32				mode;
 	int nrsg;
@@ -231,6 +232,7 @@ struct rk_cipher_ctx {
 };
 
 struct rk_cipher_rctx {
+	struct rk_crypto_info		*dev;
 	u8 backup_iv[AES_BLOCK_SIZE];
 	u32				mode;
 	struct skcipher_request fallback_req;   // keep at the end
diff --git a/drivers/crypto/rockchip/rk3288_crypto_ahash.c b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
index 636dbcde0ca3..d1bf68cb390d 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_ahash.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
@@ -200,6 +200,7 @@ static int rk_ahash_export(struct ahash_request *req, void *out)
 
 static int rk_ahash_digest(struct ahash_request *req)
 {
+	struct rk_ahash_rctx *rctx = ahash_request_ctx(req);
 	struct rk_ahash_ctx *tctx = crypto_tfm_ctx(req->base.tfm);
 	struct rk_crypto_info *dev = tctx->dev;
 
@@ -209,6 +210,8 @@ static int rk_ahash_digest(struct ahash_request *req)
 	if (!req->nbytes)
 		return zero_message_process(req);
 
+	rctx->dev = dev;
+
 	return crypto_transfer_hash_request_to_engine(dev->engine, req);
 }
 
@@ -223,10 +226,8 @@ static void crypto_ahash_dma_start(struct rk_crypto_info *dev, struct scatterlis
 static int rk_hash_prepare(struct crypto_engine *engine, void *breq)
 {
 	struct ahash_request *areq = container_of(breq, struct ahash_request, base);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct rk_ahash_rctx *rctx = ahash_request_ctx(areq);
-	struct rk_ahash_ctx *tctx = crypto_ahash_ctx(tfm);
-	struct rk_crypto_info *rkc = tctx->dev;
+	struct rk_crypto_info *rkc = rctx->dev;
 	int ret;
 
 	ret = dma_map_sg(rkc->dev, areq->src, sg_nents(areq->src), DMA_TO_DEVICE);
@@ -241,10 +242,8 @@ static int rk_hash_prepare(struct crypto_engine *engine, void *breq)
 static int rk_hash_unprepare(struct crypto_engine *engine, void *breq)
 {
 	struct ahash_request *areq = container_of(breq, struct ahash_request, base);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct rk_ahash_rctx *rctx = ahash_request_ctx(areq);
-	struct rk_ahash_ctx *tctx = crypto_ahash_ctx(tfm);
-	struct rk_crypto_info *rkc = tctx->dev;
+	struct rk_crypto_info *rkc = rctx->dev;
 
 	dma_unmap_sg(rkc->dev, areq->src, rctx->nrsg, DMA_TO_DEVICE);
 	return 0;
@@ -255,11 +254,10 @@ static int rk_hash_run(struct crypto_engine *engine, void *breq)
 	struct ahash_request *areq = container_of(breq, struct ahash_request, base);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct rk_ahash_rctx *rctx = ahash_request_ctx(areq);
-	struct rk_ahash_ctx *tctx = crypto_ahash_ctx(tfm);
 	struct ahash_alg *alg = __crypto_ahash_alg(tfm->base.__crt_alg);
 	struct rk_crypto_tmp *algt = container_of(alg, struct rk_crypto_tmp, alg.hash);
 	struct scatterlist *sg = areq->src;
-	struct rk_crypto_info *rkc = tctx->dev;
+	struct rk_crypto_info *rkc = rctx->dev;
 	int err = 0;
 	int i;
 	u32 v;
diff --git a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
index cf0dfb6029d8..0b1c90ababb7 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
@@ -86,12 +86,15 @@ static int rk_cipher_handle_req(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct rk_cipher_ctx *tctx = crypto_skcipher_ctx(tfm);
+	struct rk_cipher_rctx *rctx = skcipher_request_ctx(req);
 	struct rk_crypto_info *rkc = tctx->dev;
 	struct crypto_engine *engine = rkc->engine;
 
 	if (rk_cipher_need_fallback(req))
 		return rk_cipher_fallback(req);
 
+	rctx->dev = rkc;
+
 	return crypto_transfer_skcipher_request_to_engine(engine, req);
 }
 
@@ -290,7 +293,6 @@ static int rk_cipher_run(struct crypto_engine *engine, void *async_req)
 {
 	struct skcipher_request *areq = container_of(async_req, struct skcipher_request, base);
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
-	struct rk_cipher_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct rk_cipher_rctx *rctx = skcipher_request_ctx(areq);
 	struct scatterlist *sgs, *sgd;
 	int err = 0;
@@ -303,7 +305,7 @@ static int rk_cipher_run(struct crypto_engine *engine, void *async_req)
 	unsigned int todo;
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
 	struct rk_crypto_tmp *algt = container_of(alg, struct rk_crypto_tmp, alg.skcipher);
-	struct rk_crypto_info *rkc = ctx->dev;
+	struct rk_crypto_info *rkc = rctx->dev;
 
 	algt->stat_req++;
 
-- 
2.35.1

