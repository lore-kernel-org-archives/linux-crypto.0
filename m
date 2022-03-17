Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5F5CC433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Mar 2022 20:56:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiCQU6L (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Mar 2022 16:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiCQU5v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Mar 2022 16:57:51 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C31157588
        for <linux-crypto@vger.kernel.org>; Thu, 17 Mar 2022 13:56:26 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id r190-20020a1c2bc7000000b0038a1013241dso3820924wmr.1
        for <linux-crypto@vger.kernel.org>; Thu, 17 Mar 2022 13:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yMC+ddjQPLnvzb+n1/4Ts9zoTDjixdfTxcHcLgl33UM=;
        b=0CIZRGHtGC+7ZNfshBRNIorBMTFaTzUItSMm9flIfgEQtyei5aamXvRFhIFv0f/dnz
         WFmo/OQhZMS5KR1CpDHcNjF6PQ7UUV+zU017QfARGo0uJyGybflPrJWGheh3aZf1TL6g
         uh54FBaGPk8Buw9te2MtQLs0I5nZ4dJiMYXx0hMgEW5TczsGQMvzz2VVF328NZjj2iUA
         hQ+76kulz9SbmNUTIuhV3KPzBqna5kpmnxtNhDjlnT3Ez1urC300tcjycDIKM8ydbSHc
         ypjHqm4EwMdHHmMxR5fq7Eg1fb9FnjEBcMpATCNijtX+fpCIj4DIsdvWw6THNEetzQ8I
         wHtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yMC+ddjQPLnvzb+n1/4Ts9zoTDjixdfTxcHcLgl33UM=;
        b=jI7yoawcfYX5M3vXahLBsvSf+OA3hbe1ZpsX1UOGHu23BNHZjNfXY6TX1C/J/Bs2UO
         qeBwVmBT/TUkZdr0llEQj4q2oGUOpUnfzvs15l5z0BMJ8ZhH6INChCjYhEr6giGb9N7e
         fY27GbPPs5DrhmErbhg+weyV1qP4TraVBuUsNBcIvLAmaEUMyqXaq5FdWLmLPDLNTK4s
         YRr3ziJVCI+iAf87gSv9nL1CYta+kOU3wujAf2YSZD13qY3I0EDDjxWbGSEaZnToYjc8
         6+iyAQotPsEBUnA4r/3ATMo5I6NNJvw7WlUt26r8sY6vobATV4/pYNODasdUE70P+quf
         ELZA==
X-Gm-Message-State: AOAM532UPTfLHRYUJ8yeH1E4HXPdS1Ex0jTYy6IM8uandEBtnja9RH2p
        Z4s8iqAZ057SFUMff05iv7BneA==
X-Google-Smtp-Source: ABdhPJxhBy+ga+OR2knzwzfaH3Ag55V5bJUEjozloT1VOBQ8RI9oyfw3GvZMpsj4lLpVuQGNPlsfWg==
X-Received: by 2002:a1c:2544:0:b0:381:18a:a46d with SMTP id l65-20020a1c2544000000b00381018aa46dmr5644185wml.26.1647550584874;
        Thu, 17 Mar 2022 13:56:24 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id r4-20020a05600c35c400b00389f368cf1esm3695424wmq.40.2022.03.17.13.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 13:56:24 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     herbert@gondor.apana.org.au, jernej.skrabec@gmail.com,
        samuel@sholland.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 19/19] crypto: sun8i-ce: do not fallback if cryptlen is less than sg length
Date:   Thu, 17 Mar 2022 20:56:05 +0000
Message-Id: <20220317205605.3924836-20-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220317205605.3924836-1-clabbe@baylibre.com>
References: <20220317205605.3924836-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The sg length could be more than remaining data on it.
So check the length requirement against the minimum between those two
values.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index 315a62e424d6..74b4e910a38d 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -27,6 +27,7 @@ static int sun8i_ce_cipher_need_fallback(struct skcipher_request *areq)
 	struct scatterlist *sg;
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
 	struct sun8i_ce_alg_template *algt;
+	unsigned int todo, len;
 
 	algt = container_of(alg, struct sun8i_ce_alg_template, alg.skcipher);
 
@@ -51,28 +52,35 @@ static int sun8i_ce_cipher_need_fallback(struct skcipher_request *areq)
 		return true;
 	}
 
+	len = areq->cryptlen;
 	sg = areq->src;
 	while (sg) {
 		if (!IS_ALIGNED(sg->offset, sizeof(u32))) {
 			algt->stat_fb_srcali++;
 			return true;
 		}
-		if (sg->length % 4) {
+		todo = min(len, sg->length);
+		if (todo % 4) {
 			algt->stat_fb_srclen++;
 			return true;
 		}
+		len -= todo;
 		sg = sg_next(sg);
 	}
+
+	len = areq->cryptlen;
 	sg = areq->dst;
 	while (sg) {
 		if (!IS_ALIGNED(sg->offset, sizeof(u32))) {
 			algt->stat_fb_dstali++;
 			return true;
 		}
-		if (sg->length % 4) {
+		todo = min(len, sg->length);
+		if (todo % 4) {
 			algt->stat_fb_dstlen++;
 			return true;
 		}
+		len -= todo;
 		sg = sg_next(sg);
 	}
 	return false;
-- 
2.34.1

