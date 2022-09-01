Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF744ECAAD3
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Sep 2022 12:58:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbiIAM6G (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Sep 2022 08:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233616AbiIAM5e (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Sep 2022 08:57:34 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C66372B7C
        for <linux-crypto@vger.kernel.org>; Thu,  1 Sep 2022 05:57:25 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id u18so9577989wrq.10
        for <linux-crypto@vger.kernel.org>; Thu, 01 Sep 2022 05:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=Lb5wXjXl71KLOn69lH3EgInZyalgQlnigOqDmtk2Tt0=;
        b=pUjnzyHs3Qtdz4cBIm3pKEkaTlVWFhFgjmHad9LeNzJOeMSMZ0r74SncSGCcgdig54
         Tf6eUgDDfEYd180OWu8b/GNhqdolUyqcP64jQfqvX6M8dWA3Ep5q+dQRpMIOd6jvOuJA
         k21Bt/cHmNIgGNFIwQwFMoxHThiGO8QWSh2M4VOft6gb7/0PXKU50ih3NkwrMwgfwVd3
         QM+KYaHvSa7smG8nw1Q4mRCBuYLiMoGQa7e1dy/AwLnIhQKaegOjrb9TEGpZMgtZi3AX
         qPf9A1v81JjYOlooTDDjs8mWMMWPKo+6Y/nl8gs5H+zkdCI8aCcBZTvnNUbPcIOAFLli
         Kz3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=Lb5wXjXl71KLOn69lH3EgInZyalgQlnigOqDmtk2Tt0=;
        b=uow+fsjyJs16zhi0C/ECNeIFTaopQmv+XLR//ZZCwGGs3y7ugP2B6nnUb0Sc0xRA0T
         9dOJKzZvbmw83gJ5iXcGcfQjYBnif3jcEXxM6f8fn8DHxur00Y/QDWaEMuY2PGtNw/T8
         B1LmJajX8zJrW6GLRr8arClsNuULDXRBCbUprfuK9g9eRQlnQhiTY68q6XLT2ANL4eKv
         UDHAIBFOQTDE98+v+yy8YocAXTqR/I0M2OwbfGem4gJEHbp9FLDY9rLgdCijjEhgVtGV
         v+0WijPnb0/47PJR8AcCNV6y+bptyVVtWxLENWNdEi3YcLKyksc0ui3hSQS5tkJQRkMI
         2hIw==
X-Gm-Message-State: ACgBeo2SelFqZcGjPDilLDPzE2URQ4epwAF0vpKe9/62NRI9HC0eFIMI
        52dcDL8+ZhiAxwmSEdTfH71cOg==
X-Google-Smtp-Source: AA6agR5q85txGe157k35TclTmXbqdUaBdWTF7HQkg94KKyn5yLIrKzBsAzn867WX/GXpgWfPh5wtgw==
X-Received: by 2002:a5d:6c6b:0:b0:225:dde:ab40 with SMTP id r11-20020a5d6c6b000000b002250ddeab40mr14723322wrz.690.1662037044057;
        Thu, 01 Sep 2022 05:57:24 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id v5-20020a5d59c5000000b002257fd37877sm15556709wry.6.2022.09.01.05.57.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 05:57:23 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au, ardb@kernel.org,
        davem@davemloft.net, krzysztof.kozlowski+dt@linaro.org,
        mturquette@baylibre.com, robh+dt@kernel.org, sboyd@kernel.org
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>,
        John Keeping <john@metanate.com>
Subject: [PATCH v9 07/33] crypto: rockchip: add fallback for ahash
Date:   Thu,  1 Sep 2022 12:56:44 +0000
Message-Id: <20220901125710.3733083-8-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220901125710.3733083-1-clabbe@baylibre.com>
References: <20220901125710.3733083-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Adds a fallback for all case hardware cannot handle.

Fixes: ce0183cb6464b ("crypto: rockchip - switch to skcipher API")
Reviewed-by: John Keeping <john@metanate.com>
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

