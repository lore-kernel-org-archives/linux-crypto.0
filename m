Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4DAEC4332F
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Mar 2022 20:56:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbiCQU5n (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Mar 2022 16:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiCQU5d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Mar 2022 16:57:33 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 713DE1680A7
        for <linux-crypto@vger.kernel.org>; Thu, 17 Mar 2022 13:56:16 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id v130-20020a1cac88000000b00389d0a5c511so5595921wme.5
        for <linux-crypto@vger.kernel.org>; Thu, 17 Mar 2022 13:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mu9PNXccAJdhVTexskBbnqVFS7DSWYIvwlxUPxT8X/M=;
        b=20FqSq7+Gz98jUhIdLLoZKY4NQ4nwWdB2FhOdxY4KWxv2Oty4wuU1LzfpgHH32VYrP
         fwhyeMoyXMGQO10ha//eGEFRjCo00OKekoJn2xTX/Omr3n3HhhztcKsVxQTZOxLVj1mN
         BhwAFc5mTOvNF3gN2VqrSDZ3qKycRhHyS6Ov1k/ibiwsd6anmqbbpVaEf/mwaK+o3EyA
         qZE1eCTa1NXz8YZDDGTVaay6NewAnXN3sCRd65ij1xwFV5QlSyCdn5BzHBhWymaEq6DQ
         HO3ZnSH+Kyi5f36IETcEB7sMOHdnMYriahS65OsRs5XEdRALC8faNwXPi6r/E9eXMQ8o
         xUJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mu9PNXccAJdhVTexskBbnqVFS7DSWYIvwlxUPxT8X/M=;
        b=6gj3j2gFPygKJBmIV5xDCN+TzXIHKMMQOv5VlWgcKpwYSR5d7gKaXCTkzJyKVLovgF
         WtC91c3nY9BH2GPb8+lbjb3Djc1gKFPOEETavi98abvBcBVaoerdgEeKN0wOEzuRFWMm
         Z9/+0fdWNNLMkeiIstvmbpQP5yXS/MWR7or7eUK70qgg4101pTmCJDB6ZgbvTSMSNYQ0
         ha4eOXiH1fk85AKt46WAZ/WY1xtz1mNTk/m+pcqDYxqpzuS0aORsio+c0NRcC+WTxvN/
         cOa039znGiR7A+O3xyBt2nNY0e0jQowrpAbue12pPqwXFOHu4+aWTz/CmoWrugNMgT7u
         NCfw==
X-Gm-Message-State: AOAM532ZyGXIDhaxk/d9FKevpGQimRryV0oJKomue/k8QqSv+95VmpSw
        KFpgeXLweQLVNP6wC4Fp8oZtwg==
X-Google-Smtp-Source: ABdhPJwPCZcP/c7dsS44hNuURWEY5qBz3XyOo6LK/OCQ/ZdXbIYkZNYma1Wjm/vCLxwccdX1oQGzCg==
X-Received: by 2002:a05:600c:651:b0:381:3d7b:40e0 with SMTP id p17-20020a05600c065100b003813d7b40e0mr13220460wmm.17.1647550575007;
        Thu, 17 Mar 2022 13:56:15 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id r4-20020a05600c35c400b00389f368cf1esm3695424wmq.40.2022.03.17.13.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 13:56:14 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     herbert@gondor.apana.org.au, jernej.skrabec@gmail.com,
        samuel@sholland.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 05/19] crypto: sun8i-ss: handle zero sized sg
Date:   Thu, 17 Mar 2022 20:55:51 +0000
Message-Id: <20220317205605.3924836-6-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220317205605.3924836-1-clabbe@baylibre.com>
References: <20220317205605.3924836-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

sun8i-ss does not handle well the possible zero sized sg.

Fixes: d9b45418a917 ("crypto: sun8i-ss - support hash algorithms")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
index 1a71ed49d233..ca4f280af35d 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
@@ -380,13 +380,21 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 	}
 
 	len = areq->nbytes;
-	for_each_sg(areq->src, sg, nr_sgs, i) {
+	sg = areq->src;
+	i = 0;
+	while (len > 0 && sg) {
+		if (sg_dma_len(sg) == 0) {
+			sg = sg_next(sg);
+			continue;
+		}
 		rctx->t_src[i].addr = sg_dma_address(sg);
 		todo = min(len, sg_dma_len(sg));
 		rctx->t_src[i].len = todo / 4;
 		len -= todo;
 		rctx->t_dst[i].addr = addr_res;
 		rctx->t_dst[i].len = digestsize / 4;
+		sg = sg_next(sg);
+		i++;
 	}
 	if (len > 0) {
 		dev_err(ss->dev, "remaining len %d\n", len);
-- 
2.34.1

