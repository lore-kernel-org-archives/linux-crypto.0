Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37E1FC4321E
	for <linux-crypto@archiver.kernel.org>; Sun,  8 May 2022 19:18:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiEHTWD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 8 May 2022 15:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236624AbiEHTEO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 8 May 2022 15:04:14 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDABDF85
        for <linux-crypto@vger.kernel.org>; Sun,  8 May 2022 12:00:13 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id q23so16716846wra.1
        for <linux-crypto@vger.kernel.org>; Sun, 08 May 2022 12:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yzvgVyreo6slTFAo6yIfKz7ssJtwxUt4QGb+bB9VZnw=;
        b=JsiIEZbEorhvcZhNqOJyFrQfGu/JLj+5HxjhV183f6b/htj1yxYBv4yaK5nPWzJ90p
         oiGnbbjhnbKLrQce2+XWAtZuoR5Tesixo9WBwdHQXcD2fxtOs1iJ9Gybj0N8invS45N/
         1q2++C0HAZkPNs7zUjTDKeZXXNyJD/soyPiF/p9woE5UYqy5HSH3l7gSn/dCZF4cF4Gf
         xMK2tRuXGkd4IULgkVxaLIi57ZBBbJROh7ryTyRbDyhNr9tf6ajG8Q5Y67reczNcBAK7
         ZnTMyIVLeLuPtN4FQx701kI88NQa7tO8cToZAktD/MjRfWL45MgVBEaCqPxtARXCNfeS
         7IhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yzvgVyreo6slTFAo6yIfKz7ssJtwxUt4QGb+bB9VZnw=;
        b=tPqjx0N+pPlBVpjXmvXfzguv+uHTIzU1WOre46lFU1eU7HtNUjB/uUwgrqVHgtJlIk
         eEh98cfJl3VcB2ii0jGshLCt0hmf2vGymlKrxyRyVyGFOR0QH73Fs6qTyQzgunc4UC1c
         4XXAWKvBwJ3K87STJdO4rzPbdSDukQteDzVvlb2mcz5M0wTJYrJtdx9+fXVKoVqsDSX1
         1ukaSC9if136yPoL8nbvGmwfqO8Hwcz9pkYqFWY6OwZtnHnnNKYl7SO1f0wr78iPcdue
         jAgpQPesy2zRgaP8YoIht4USQHvt2DMWGTAek3/ceGZD72X6PyVdHy3V2S+ry3CS9Ny1
         5yVA==
X-Gm-Message-State: AOAM5319Tl5TaWKMZRMPTNcQos2HMcn/JCdmzYNI6+6463xZvWBS+YSq
        n2Fy01G0EoUuEQy6OZ+UZ9cELw==
X-Google-Smtp-Source: ABdhPJzctY1kgG5Nzp0gZ1p4e7AznRgsramsEtrcJP0YHQqPAKpQBcF7hn+yKTSdbbPC3zsrMv528A==
X-Received: by 2002:a05:6000:1707:b0:20c:660c:7c78 with SMTP id n7-20020a056000170700b0020c660c7c78mr11030537wrc.150.1652036412312;
        Sun, 08 May 2022 12:00:12 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id n16-20020a05600c3b9000b00394699f803dsm10552348wms.46.2022.05.08.12.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 May 2022 12:00:11 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, ardb@kernel.org, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v7 07/33] crypto: rockchip: add fallback for ahash
Date:   Sun,  8 May 2022 18:59:31 +0000
Message-Id: <20220508185957.3629088-8-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508185957.3629088-1-clabbe@baylibre.com>
References: <20220508185957.3629088-1-clabbe@baylibre.com>
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

