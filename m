Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0C3AC433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Feb 2022 19:47:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiB1Trv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:47:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiB1Tro (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Feb 2022 14:47:44 -0500
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D4AEDF32
        for <linux-crypto@vger.kernel.org>; Mon, 28 Feb 2022 11:45:56 -0800 (PST)
Received: by mail-wr1-f50.google.com with SMTP id v21so17092644wrv.5
        for <linux-crypto@vger.kernel.org>; Mon, 28 Feb 2022 11:45:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v1CCwvJnO4832jIoRmVnfn1erTUdDyF/92qblaVtPw0=;
        b=T6Rn7DKpnSnnyV16iFJeQmRkesyHpgcXn2Birf8VDLN9xJJGQpe3sACuKvCcbBSzZp
         siIvE0Wto1zd4n35xBM9jwhXXuxpshiEgB5NSXAzBIjyPFM7YZxoUzrs/crK6L5GQeOi
         qp2or336e6FCD9jVoQLmc8cKh7dDQmcYGeJSvQLQh/petM7XhbHZ9vcjasOowF/9lO+d
         k5bSMHM5nIKEgCLuN2GImvNmVAizz+JSDptuOE9n3ShIu8d7B4cvboMM+3h6/P2EpHPa
         rowmx1yWviBahOqGRGPklUwvfFZhf4c28OrRmBMOilIh7Mplsg6Y8IualsaBFQhrgK5Q
         CoQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v1CCwvJnO4832jIoRmVnfn1erTUdDyF/92qblaVtPw0=;
        b=vQZihaSZd2jkyNbGJKzfbAUMe0Mersm1nrivIyjozl/OpcODgpDhWFj3yI0/4TJ4U2
         ZL54fFHgSp0Hfh1RYbga6UScFXlTRwCVQqy+jdz5UPe2G90MWnvPzWUNnM5LVUJYS4mQ
         ROfiIXCtysuFvaC5yEmIbKODaZnHoXTvAwOqKOjlAu24KhDbX9uvqrzKPsdusoKKWpa5
         mJMR0mGiOAMbqOdXR63xOjPMJDdspmMrHLczmscC74ENnEn/T27N+U47I3rokDt7Vccn
         xsPpFtXxreQ/IdGGEVetqE2oPzZCMvX38Y/el1WFL62xkdkznJGX2sP+BOn7S8Qovc8H
         oM/A==
X-Gm-Message-State: AOAM532qL9gdEGVwj0RIGcawkTs+r0OTvwWd2ffXz47XM5fSUve5bPz3
        In1R9Emq6eUQzuRIudlU9eSFCA==
X-Google-Smtp-Source: ABdhPJxDjjxXTOkNOHngS/ruLX9ZyvuuzcTSee0l/s0FxFJnrHS9T5djEiIy1zF/izWnMoGEURsAnQ==
X-Received: by 2002:a5d:45cb:0:b0:1ed:f938:7e17 with SMTP id b11-20020a5d45cb000000b001edf9387e17mr16706103wrs.170.1646077248771;
        Mon, 28 Feb 2022 11:40:48 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id v25-20020a05600c215900b0038117f41728sm274143wml.43.2022.02.28.11.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 11:40:48 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski@canonical.com, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 07/16] crypto: rockchip: add fallback for ahash
Date:   Mon, 28 Feb 2022 19:40:28 +0000
Message-Id: <20220228194037.1600509-8-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220228194037.1600509-1-clabbe@baylibre.com>
References: <20220228194037.1600509-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Adds a fallback for all case hardware cannot handle.

Fixes: ce0183cb6464b ("crypto: rockchip - switch to skcipher API")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/rockchip/rk3288_crypto_ahash.c | 37 +++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/crypto/rockchip/rk3288_crypto_ahash.c b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
index 49017d1fb510..417cf4487514 100644
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
-- 
2.34.1

