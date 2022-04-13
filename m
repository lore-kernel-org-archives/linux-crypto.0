Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7D8DC43219
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Apr 2022 19:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237964AbiDMTKB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Apr 2022 15:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237953AbiDMTJw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Apr 2022 15:09:52 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3484A6E8FA
        for <linux-crypto@vger.kernel.org>; Wed, 13 Apr 2022 12:07:30 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id g18so3969372wrb.10
        for <linux-crypto@vger.kernel.org>; Wed, 13 Apr 2022 12:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yzvgVyreo6slTFAo6yIfKz7ssJtwxUt4QGb+bB9VZnw=;
        b=6LonU9zxcj38hIKp4Ki621p4IxWp8og1w9ueWEVBL9K7/auhG9ymQ4gGzuU7nGsRGT
         ReW/RwoW5pT7pFoWnG5VHnguIrkZFF301PrCYAT4gbwd6oRxxaub7qmWTPogCIbtc1H+
         4GxIpgoYj1CXBl1JfoGrKgIPUpBYoKCBqmX+yLvAW6VkGv5Urpf1g6bz34ezbeylT/qm
         nrRkCiXr+QvgsUc573YNI8VnXqFEIY3+MJvFufVNSFcmJBcGo3Sgbd7cXIuPmyDIMClK
         TKl8Lpy0YmoglSvt6ZMAqN6PgZ4H1d9K99zZA+d0kMYYTVqYsWCliAWiBYcxhYUiRWZA
         2RYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yzvgVyreo6slTFAo6yIfKz7ssJtwxUt4QGb+bB9VZnw=;
        b=sYni3Cfu5C0qP8kLvl+LdBgzb123BmmrpJILwgkxjrppOghPO2/rmWLMSJ6xjgu2T9
         oL+iwj45WaHMgvayWfn9xPjB1QcxPbOjv1HdkxENDROkhbdLQ1sVgk/nIIHb1uZIFsD+
         lKkclO1hYOyj3pUZ9zZkkQHv6Q01MCS4yDRoica2+Innfzp/Y1TbN5KC6Nwads8KRBnb
         FatjAXneTnlo0/luKN84kACmr3dahI/h2PP8SduiiYY3gXr+5J547oK1CYGeUMe1oIWb
         /bN7MqUH/mzYfXrt7Huc7F3v7Qr67A/Il+hdrIMHaqPJqNfQa52gBmZA17NyS8kSrWQJ
         M1+w==
X-Gm-Message-State: AOAM5325HPabq70rsvN6K/JZLZPvEJV/tx1hgrQzQWQ6ikU9LVTLBJgE
        pcbA/Pzu3fXX5NqImOJbxmTlOQ==
X-Google-Smtp-Source: ABdhPJyfWDUOBo407KIkmaHDMAMa8XzduUQe5aiqb2R9yzoWCNwLKvwxBgoyW1wq8NV+NpE5BFzruA==
X-Received: by 2002:a05:6000:384:b0:203:ed51:8ab3 with SMTP id u4-20020a056000038400b00203ed518ab3mr226425wrf.211.1649876848785;
        Wed, 13 Apr 2022 12:07:28 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id o29-20020a05600c511d00b0038e3532b23csm3551852wms.15.2022.04.13.12.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 12:07:28 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v5 07/33] crypto: rockchip: add fallback for ahash
Date:   Wed, 13 Apr 2022 19:06:47 +0000
Message-Id: <20220413190713.1427956-8-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220413190713.1427956-1-clabbe@baylibre.com>
References: <20220413190713.1427956-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Adds a fallback for all case hardware cannot handle.

Fixes: ce0183cb6464b ("crypto: rockchip - switch to skcipher API")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/rockchip/rk3288_crypto_ahash.c | 38 +++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/crypto/rockchip/rk3288_crypto_ahash.c b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
index 49017d1fb510..16009bb0bf16 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_ahash.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
@@ -16,6 +16,40 @@
  * so we put the fixed hash out when met zero message.
  */
 
+static bool rk_ahash_need_fallback(struct ahash_request *req)
+{
+	struct scatterlist *sg;
+
+	sg = req->src;
+	while (sg) {
+		if (!IS_ALIGNED(sg->offset, sizeof(u32))) {
+			return true;
+		}
+		if (sg->length % 4) {
+			return true;
+		}
+		sg = sg_next(sg);
+	}
+	return false;
+}
+
+static int rk_ahash_digest_fb(struct ahash_request *areq)
+{
+	struct rk_ahash_rctx *rctx = ahash_request_ctx(areq);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct rk_ahash_ctx *tfmctx = crypto_ahash_ctx(tfm);
+
+	ahash_request_set_tfm(&rctx->fallback_req, tfmctx->fallback_tfm);
+	rctx->fallback_req.base.flags = areq->base.flags &
+					CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	rctx->fallback_req.nbytes = areq->nbytes;
+	rctx->fallback_req.src = areq->src;
+	rctx->fallback_req.result = areq->result;
+
+	return crypto_ahash_digest(&rctx->fallback_req);
+}
+
 static int zero_message_process(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
@@ -167,6 +201,9 @@ static int rk_ahash_digest(struct ahash_request *req)
 	struct rk_ahash_ctx *tctx = crypto_tfm_ctx(req->base.tfm);
 	struct rk_crypto_info *dev = tctx->dev;
 
+	if (rk_ahash_need_fallback(req))
+		return rk_ahash_digest_fb(req);
+
 	if (!req->nbytes)
 		return zero_message_process(req);
 	else
@@ -309,6 +346,7 @@ static void rk_cra_hash_exit(struct crypto_tfm *tfm)
 	struct rk_ahash_ctx *tctx = crypto_tfm_ctx(tfm);
 
 	free_page((unsigned long)tctx->dev->addr_vir);
+	crypto_free_ahash(tctx->fallback_tfm);
 }
 
 struct rk_crypto_tmp rk_ahash_sha1 = {
-- 
2.35.1

