Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B5A6C433FE
	for <linux-crypto@archiver.kernel.org>; Mon,  2 May 2022 20:19:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239394AbiEBUX0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 May 2022 16:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387321AbiEBUXV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 May 2022 16:23:21 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28E5DF4F
        for <linux-crypto@vger.kernel.org>; Mon,  2 May 2022 13:19:49 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id d5so20878209wrb.6
        for <linux-crypto@vger.kernel.org>; Mon, 02 May 2022 13:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RnRXNVBrNu0gZUzja3H8hBQ5GxF3sLHXexVXlrLV7kM=;
        b=X8fSwKk9SZRgne6mCFt08RJn+hmq7rBZ6PS0Lif5QPtJZlQ/cHfzz0fePdMJeVoEV2
         zyvL1shPlDOhP7u5PUB1+DqnDigLCOfPrleRC1jrVgqFeGA6JfZbpihnOZS8qZ6jX59O
         yQRR3Ef/YOfAgiNOZmbbrm+EHUyXvO0wzB1x/k8lhJSruOvHLpeHyXixqlXvVQKDXCpM
         wAgMek3HRzP8pJX7hZzDEm5FnfCZxCzAXqVgnHT7IgLGxlhiRGCHc21Zbmg74RrYBhgy
         AP6MMmfMlFxTPqfQP+stHDF0r/sBv5lgDW1pewuNM7NazO3Hk/sxtq0oT/FGVKoxNudU
         /VbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RnRXNVBrNu0gZUzja3H8hBQ5GxF3sLHXexVXlrLV7kM=;
        b=AzTmMfOfJuCwI9jGVNG3IBzEiaIpsRmcIB6n/8CXsNO9D1PGm9KoBjBfBz2ud4BngP
         DL9oc9elNRJmEjqDnpO61Tb/2kMgujVKQ4R0YnmNAgdkZV7agHCYYEyIPxENpcuJ4Pft
         7HyjKe5t6HHYzVFphiCsG1X+i08+HlTu3pVHI4FRzufbEsneAGMPIt721UmJy/91l4FR
         7f6sfCWUgHN5+Rs7UxqyE5EErpjo5jWzLNLX83rYIAhWFzhIndAKmv3qgr6Tpj5vorpg
         0mBX9Op6c3q7oNcxaH/wRk3FQev9pe12NOGVLFSZF022bP+BM37I1lXgGczrZtoCHkM3
         tCqg==
X-Gm-Message-State: AOAM533cEroKo2LkRCRsdJrBE0AN3U+AOxpgPw/EOjoA8glAPuTsMnva
        h1y5zYwBZMgZp0ijkzAmDgothQ==
X-Google-Smtp-Source: ABdhPJzbkAkG2vpxk0wI5E7kifV7WOkLd0rKSFIEP5owheSFK+XfGcbbQ7pSR6xmwCbFCTwOuNafGw==
X-Received: by 2002:a05:6000:188c:b0:20c:563a:aa86 with SMTP id a12-20020a056000188c00b0020c563aaa86mr8982895wri.360.1651522788240;
        Mon, 02 May 2022 13:19:48 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id l2-20020adfb102000000b0020c547f75easm7238183wra.101.2022.05.02.13.19.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 13:19:47 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     herbert@gondor.apana.org.au, jernej.skrabec@gmail.com,
        samuel@sholland.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 08/19] crypto: sun8i-ss: use sg_nents_for_len
Date:   Mon,  2 May 2022 20:19:18 +0000
Message-Id: <20220502201929.843194-9-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220502201929.843194-1-clabbe@baylibre.com>
References: <20220502201929.843194-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When testing with some large SG list, the sun8i-ss drivers always
fallback even if it can handle it.
So use sg_nents_for_len() which permits to see less SGs than needed.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 .../allwinner/sun8i-ss/sun8i-ss-cipher.c      | 23 ++++++++-----------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
index 70e2e6e37389..c4cb1ab1eeaa 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
@@ -29,7 +29,8 @@ static bool sun8i_ss_need_fallback(struct skcipher_request *areq)
 	if (areq->cryptlen == 0 || areq->cryptlen % 16)
 		return true;
 
-	if (sg_nents(areq->src) > 8 || sg_nents(areq->dst) > 8)
+	if (sg_nents_for_len(areq->src, areq->cryptlen) > 8 ||
+		sg_nents_for_len(areq->dst, areq->cryptlen) > 8)
 		return true;
 
 	sg = areq->src;
@@ -169,6 +170,8 @@ static int sun8i_ss_cipher(struct skcipher_request *areq)
 	int nr_sgs = 0;
 	int nr_sgd = 0;
 	int err = 0;
+	int nsgs = sg_nents_for_len(areq->src, areq->cryptlen);
+	int nsgd = sg_nents_for_len(areq->dst, areq->cryptlen);
 	int i;
 
 	algt = container_of(alg, struct sun8i_ss_alg_template, alg.skcipher);
@@ -201,8 +204,7 @@ static int sun8i_ss_cipher(struct skcipher_request *areq)
 			goto theend_key;
 	}
 	if (areq->src == areq->dst) {
-		nr_sgs = dma_map_sg(ss->dev, areq->src, sg_nents(areq->src),
-				    DMA_BIDIRECTIONAL);
+		nr_sgs = dma_map_sg(ss->dev, areq->src, nsgs, DMA_BIDIRECTIONAL);
 		if (nr_sgs <= 0 || nr_sgs > 8) {
 			dev_err(ss->dev, "Invalid sg number %d\n", nr_sgs);
 			err = -EINVAL;
@@ -210,15 +212,13 @@ static int sun8i_ss_cipher(struct skcipher_request *areq)
 		}
 		nr_sgd = nr_sgs;
 	} else {
-		nr_sgs = dma_map_sg(ss->dev, areq->src, sg_nents(areq->src),
-				    DMA_TO_DEVICE);
+		nr_sgs = dma_map_sg(ss->dev, areq->src, nsgs, DMA_TO_DEVICE);
 		if (nr_sgs <= 0 || nr_sgs > 8) {
 			dev_err(ss->dev, "Invalid sg number %d\n", nr_sgs);
 			err = -EINVAL;
 			goto theend_iv;
 		}
-		nr_sgd = dma_map_sg(ss->dev, areq->dst, sg_nents(areq->dst),
-				    DMA_FROM_DEVICE);
+		nr_sgd = dma_map_sg(ss->dev, areq->dst, nsgd, DMA_FROM_DEVICE);
 		if (nr_sgd <= 0 || nr_sgd > 8) {
 			dev_err(ss->dev, "Invalid sg number %d\n", nr_sgd);
 			err = -EINVAL;
@@ -274,13 +274,10 @@ static int sun8i_ss_cipher(struct skcipher_request *areq)
 
 theend_sgs:
 	if (areq->src == areq->dst) {
-		dma_unmap_sg(ss->dev, areq->src, sg_nents(areq->src),
-			     DMA_BIDIRECTIONAL);
+		dma_unmap_sg(ss->dev, areq->src, nsgs, DMA_BIDIRECTIONAL);
 	} else {
-		dma_unmap_sg(ss->dev, areq->src, sg_nents(areq->src),
-			     DMA_TO_DEVICE);
-		dma_unmap_sg(ss->dev, areq->dst, sg_nents(areq->dst),
-			     DMA_FROM_DEVICE);
+		dma_unmap_sg(ss->dev, areq->src, nsgs, DMA_TO_DEVICE);
+		dma_unmap_sg(ss->dev, areq->dst, nsgd, DMA_FROM_DEVICE);
 	}
 
 theend_iv:
-- 
2.35.1

