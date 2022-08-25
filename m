Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AC9AC04AA5
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Aug 2022 07:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237642AbiHYHY0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Aug 2022 03:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237631AbiHYHYZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Aug 2022 03:24:25 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B83A1A73
        for <linux-crypto@vger.kernel.org>; Thu, 25 Aug 2022 00:24:24 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id y3so11432162ejc.1
        for <linux-crypto@vger.kernel.org>; Thu, 25 Aug 2022 00:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=4oX7Kz3MVV4hSXJmoV3BElc0F08jxmt7raiQQsmxayc=;
        b=MW5H/NNoqjJGKjOXPEUp6diJ0Ebk/7ve+sG3Vf+l0KuUBAvXz50GCgcJA7dHF9RJ/F
         YV/wOibDRkpDRz0sxjw3FI6zpSxqAJhGSdlI/poeQ1wGxShokSYfdqEa/N9SYMbHYltQ
         8aS3yEcIDE5WMl1gLsBxto2pvSbrnNxlrdczPsANNjjd0el6V17a15Kru2mtpPeAaIlq
         jkSt7scusL3g90qGNjr6AVdm+8+0TO+xzAz7a31PiMrRRq1SJ6r3Nez1lVaKTFkFn4uC
         eCrb+CCZFAk7kAOIu8uO3XWZecG+oZ4w8EoHj8P8lfNlPvUmj/bsNUsKsWVOA5XumtFe
         WGOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=4oX7Kz3MVV4hSXJmoV3BElc0F08jxmt7raiQQsmxayc=;
        b=XfrkfMy3gALuXRNKlYD5YuNBBDD8jzSmb4wuVMPnM1Z9IbR7+wYcBnz8LWWq0Fda91
         3tSeoSdLMqbRdlr3ueU1gIhZ1vDlITEF6u3uslCsRo2H00Nvu8lipOSI083CgNnskJoW
         AGM0Sb/5VQfW5IUYDlkSOYUP7ulxAw5zevT4cC+o5X2NRR4qN5Fqnp9bArV+pehQ1wcN
         cINnUjPnMe3Oq/H7SxWA/te3ctQNPmrbYITT5yuECzI0zcCrw2RmIlCd1jn5BFfu/t6H
         F0v/F2ikz/moSxfEAE4v813X5UHrImxok0IFFMHGZaP66m3ky+8hkHPCxO3vS9E0AxlK
         rHjw==
X-Gm-Message-State: ACgBeo1lfzuSDsexKr8X6HuunGok6VkPmvavZaUM3efUrf6TXiif560r
        GK0PBzQIaW6c0oSE9IXj5B8qOA==
X-Google-Smtp-Source: AA6agR7lhsz5pWp2kpFfMDfBBKJfF6f8ewMsA/5Mzz4qzehyEEhDRGqQs7+PcOiIi+6aXE6zbycuUg==
X-Received: by 2002:a17:907:970b:b0:73d:5a29:959 with SMTP id jg11-20020a170907970b00b0073d5a290959mr1656893ejc.183.1661412262910;
        Thu, 25 Aug 2022 00:24:22 -0700 (PDT)
Received: from lb02065.fritz.box ([2001:9e8:142d:a900:eab:b5b1:a064:1d0d])
        by smtp.gmail.com with ESMTPSA id ky12-20020a170907778c00b0073ce4abf093sm2032281ejc.214.2022.08.25.00.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 00:24:22 -0700 (PDT)
From:   Jack Wang <jinpu.wang@ionos.com>
To:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc:     Corentin Labbe <clabbe@baylibre.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] crypto: gemin: Fix error check for dma_map_sg
Date:   Thu, 25 Aug 2022 09:24:16 +0200
Message-Id: <20220825072421.29020-2-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220825072421.29020-1-jinpu.wang@ionos.com>
References: <20220825072421.29020-1-jinpu.wang@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

dma_map_sg return 0 on error.

Cc: Corentin Labbe <clabbe@baylibre.com>
Cc: Hans Ulli Kroll <ulli.kroll@googlemail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Fixes: 46c5338db7bd ("crypto: sl3516 - Add sl3516 crypto engine")
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/crypto/gemini/sl3516-ce-cipher.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/gemini/sl3516-ce-cipher.c b/drivers/crypto/gemini/sl3516-ce-cipher.c
index 14d0d83d388d..34fea8aa91b6 100644
--- a/drivers/crypto/gemini/sl3516-ce-cipher.c
+++ b/drivers/crypto/gemini/sl3516-ce-cipher.c
@@ -149,7 +149,7 @@ static int sl3516_ce_cipher(struct skcipher_request *areq)
 	if (areq->src == areq->dst) {
 		nr_sgs = dma_map_sg(ce->dev, areq->src, sg_nents(areq->src),
 				    DMA_BIDIRECTIONAL);
-		if (nr_sgs <= 0 || nr_sgs > MAXDESC / 2) {
+		if (!nr_sgs || nr_sgs > MAXDESC / 2) {
 			dev_err(ce->dev, "Invalid sg number %d\n", nr_sgs);
 			err = -EINVAL;
 			goto theend;
@@ -158,14 +158,14 @@ static int sl3516_ce_cipher(struct skcipher_request *areq)
 	} else {
 		nr_sgs = dma_map_sg(ce->dev, areq->src, sg_nents(areq->src),
 				    DMA_TO_DEVICE);
-		if (nr_sgs <= 0 || nr_sgs > MAXDESC / 2) {
+		if (!nr_sgs || nr_sgs > MAXDESC / 2) {
 			dev_err(ce->dev, "Invalid sg number %d\n", nr_sgs);
 			err = -EINVAL;
 			goto theend;
 		}
 		nr_sgd = dma_map_sg(ce->dev, areq->dst, sg_nents(areq->dst),
 				    DMA_FROM_DEVICE);
-		if (nr_sgd <= 0 || nr_sgd > MAXDESC) {
+		if (!nr_sgd || nr_sgd > MAXDESC) {
 			dev_err(ce->dev, "Invalid sg number %d\n", nr_sgd);
 			err = -EINVAL;
 			goto theend_sgs;
-- 
2.34.1

