Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76992C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Mar 2022 20:56:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbiCQU57 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Mar 2022 16:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiCQU5e (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Mar 2022 16:57:34 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20AD316C0B5
        for <linux-crypto@vger.kernel.org>; Thu, 17 Mar 2022 13:56:17 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id u10so9013055wra.9
        for <linux-crypto@vger.kernel.org>; Thu, 17 Mar 2022 13:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2g5+OXXHtg4dVO5sgGI8Y44BohZHmyHHz8c1WE1IAa8=;
        b=gVSNX4Kbw8N0TPcUABNW+pM2hluoNYOGmaP1gWPjf3qpsTEpap8/RKxQALghYxJLUb
         KmDYqzOUqdHHaOJVZqUYSFff38UoiVZGyiOiESpx/OOxK8r+K9fwJThqU3o5QppMT2Aa
         Nn7zFrBpW8ObdLEMw8X7vEC8zYnf1yH30BUUTOHndB0PBw/V6nK8kEAt1pUGsi5XdTsw
         gfdik0aHe5Ltq7oRN1qvJilj6Kv4HbQlfB3rWa+bDGbC7TFPK9EKSGOx4DX3W9XfHhAI
         /LzU0pkr7ZByyRxjMhpMnbgWROeGmh3/bbsEP3Rr1H8gCBZvyU1fPqtuctRrnG1WPjXP
         qYVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2g5+OXXHtg4dVO5sgGI8Y44BohZHmyHHz8c1WE1IAa8=;
        b=mua4HI1IEPK/Q6myXHN2WTwQ4MfwZUAlUOJWf9EUAFI3fGYaRuPW5n59lAeeNdRbqm
         DJGhBRgl5Oc0Gi5p+qd/zTpCmMHCh3B8Ps1sE2z9M00JDQoYUr6R+rMtAQXMY3uUowNZ
         ZikDypYMyM5Ar4nap9BEuKN1zI35ASY42hjSJXYa31LWUPjNa0t0nYG6VXqd3F5Aa9su
         H7QBk3pUmdPVW+WlkyjpLjMz5fgA0s4vgkh650rJyOH0WCjVuwCRv84cdYlowG57DaWR
         tEwphvEha+LOrHmvGQHPzIuhrkvTHNn+YLcHm8XcxPh1QFMoQFCb9LqCXk2XGvFFe4KD
         H29g==
X-Gm-Message-State: AOAM532Ivf7kpzEiXz5/OxaOzTwNn0di14xQChmWBvVKsyN2/xiU5HV8
        yHDMjfzonmZ6rIU+o3IeWYnMQQ==
X-Google-Smtp-Source: ABdhPJxPcQUgeh+LlcQ5hHSMR68TLbSbzmQ3p0v4Xg47Q7kVp3zk02M+/6y8bOLfgsLcLJurRDdISw==
X-Received: by 2002:a5d:66c4:0:b0:203:f597:d5ed with SMTP id k4-20020a5d66c4000000b00203f597d5edmr368993wrw.470.1647550575668;
        Thu, 17 Mar 2022 13:56:15 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id r4-20020a05600c35c400b00389f368cf1esm3695424wmq.40.2022.03.17.13.56.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 13:56:15 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     herbert@gondor.apana.org.au, jernej.skrabec@gmail.com,
        samuel@sholland.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 06/19] crypto: sun8i-ss: remove redundant test
Date:   Thu, 17 Mar 2022 20:55:52 +0000
Message-Id: <20220317205605.3924836-7-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220317205605.3924836-1-clabbe@baylibre.com>
References: <20220317205605.3924836-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some fallback tests were redundant with what sun8i_ss_hash_need_fallback() already do.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
index ca4f280af35d..eaa0bbaf5581 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
@@ -288,21 +288,11 @@ int sun8i_ss_hash_digest(struct ahash_request *areq)
 	struct sun8i_ss_alg_template *algt;
 	struct sun8i_ss_dev *ss;
 	struct crypto_engine *engine;
-	struct scatterlist *sg;
-	int nr_sgs, e, i;
+	int e;
 
 	if (sun8i_ss_hash_need_fallback(areq))
 		return sun8i_ss_hash_digest_fb(areq);
 
-	nr_sgs = sg_nents(areq->src);
-	if (nr_sgs > MAX_SG - 1)
-		return sun8i_ss_hash_digest_fb(areq);
-
-	for_each_sg(areq->src, sg, nr_sgs, i) {
-		if (sg->length % 4 || !IS_ALIGNED(sg->offset, sizeof(u32)))
-			return sun8i_ss_hash_digest_fb(areq);
-	}
-
 	algt = container_of(alg, struct sun8i_ss_alg_template, alg.hash);
 	ss = algt->ss;
 
-- 
2.34.1

