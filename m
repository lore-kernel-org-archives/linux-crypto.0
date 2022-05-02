Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81376C433FE
	for <linux-crypto@archiver.kernel.org>; Mon,  2 May 2022 20:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387469AbiEBUYl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 May 2022 16:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387427AbiEBUXq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 May 2022 16:23:46 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F89DFDD
        for <linux-crypto@vger.kernel.org>; Mon,  2 May 2022 13:19:59 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id k126-20020a1ca184000000b003943fd07180so198243wme.3
        for <linux-crypto@vger.kernel.org>; Mon, 02 May 2022 13:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T/PemtLL/+ON/eMGCnalVatEQc1XzYBkrl+H+ahkgok=;
        b=qn6nCzRQqIvyYOh9x8vLnhJDGIf8saLbZVRgueIApHsi5QjL/K902P4lJG3+UTxwL9
         0f4I1Ujd4sQDv4reaJ04Duu3vayoLhS14GAvRITl2r/unFG9tREAkSnCSTjaRGfrhRT8
         jxXWaBWPJ0MMK1dbXCRyJjVlsZJ/2J9A9mskB7ckS1pG44iNoWyeBCDQltgjD11V6crK
         slu3Bjmse8iZs8hIqq3dwr0xEpZRfQsvPHTb/uejrDzjxoREDHdGs6mYtwVjwl8titlX
         hOdnvDjmRpmFVX7xhZnd0giRAoTAfaBLjNdOO7G9B7yGQISN6tkr0agFtuyMghGJ0VIy
         gfAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T/PemtLL/+ON/eMGCnalVatEQc1XzYBkrl+H+ahkgok=;
        b=iMImwzYZxgDOwl/hPgzJ+FCE0WjUuqat9COJ6Y9dgf+HH6S0cyWWtxq7QG+okAg8Fd
         WZ6dDPVn2K0OX7i+MaYoJQYO4oUMUKn1v+WFIhyWVtXj29mViwcLh0fjg7pJjeiMEnu5
         9lZRLQI3cyqvl2tbiKb6Kmfj9HPnRXMPvKDHLxtK1+lH8692mpTzjuHxjrVt88+Xpiat
         Jnun6rVCMqS/YCc7UI78ygqchTUH/ztLKR4EntsBtXuvygEwg55jnwhV0xZtXoJAHrDQ
         yi1GIrXwi0zWHsqQYa+qsTJLX3lSTTlVYJJwSDwhg1MTuWw6nMwTRvy1896V+8YNly+S
         4kig==
X-Gm-Message-State: AOAM533eGnPiN7gsgpDyLMj4uitY+eLN118g6jofqDGMkBMBK+u0qyAC
        /u7t84ztfh9p/kV7RP4kEzuEvQ==
X-Google-Smtp-Source: ABdhPJzblfA6nN9Ir/zKzCjq9kBWsGKTgKRhl21RRwI6zcBPGY6TFL43tb3xBoPbZ0CtoY/gPedx5A==
X-Received: by 2002:a05:600c:1f17:b0:393:d821:eee4 with SMTP id bd23-20020a05600c1f1700b00393d821eee4mr552714wmb.163.1651522798163;
        Mon, 02 May 2022 13:19:58 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id l2-20020adfb102000000b0020c547f75easm7238183wra.101.2022.05.02.13.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 13:19:57 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     herbert@gondor.apana.org.au, jernej.skrabec@gmail.com,
        samuel@sholland.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 17/19] crypto: sun8i-ce: use sg_nents_for_len
Date:   Mon,  2 May 2022 20:19:27 +0000
Message-Id: <20220502201929.843194-18-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220502201929.843194-1-clabbe@baylibre.com>
References: <20220502201929.843194-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When testing with some large SG list, the sun8i-ce drivers always
fallback even if it can handle it.
So use sg_nents_for_len() which permits to see less SGs than needed.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 .../allwinner/sun8i-ce/sun8i-ce-cipher.c      | 23 ++++++++-----------
 .../crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 10 ++++----
 2 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index 0b1ce58bdeb9..35ab71d3a82d 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -26,7 +26,8 @@ static int sun8i_ce_cipher_need_fallback(struct skcipher_request *areq)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
 	struct scatterlist *sg;
 
-	if (sg_nents(areq->src) > MAX_SG || sg_nents(areq->dst) > MAX_SG)
+	if (sg_nents_for_len(areq->src, areq->cryptlen) > MAX_SG ||
+	    sg_nents_for_len(areq->dst, areq->cryptlen) > MAX_SG)
 		return true;
 
 	if (areq->cryptlen < crypto_skcipher_ivsize(tfm))
@@ -94,6 +95,8 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 	int nr_sgs = 0;
 	int nr_sgd = 0;
 	int err = 0;
+	int ns = sg_nents_for_len(areq->src, areq->cryptlen);
+	int nd = sg_nents_for_len(areq->dst, areq->cryptlen);
 
 	algt = container_of(alg, struct sun8i_ce_alg_template, alg.skcipher);
 
@@ -169,8 +172,7 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 	}
 
 	if (areq->src == areq->dst) {
-		nr_sgs = dma_map_sg(ce->dev, areq->src, sg_nents(areq->src),
-				    DMA_BIDIRECTIONAL);
+		nr_sgs = dma_map_sg(ce->dev, areq->src, ns, DMA_BIDIRECTIONAL);
 		if (nr_sgs <= 0 || nr_sgs > MAX_SG) {
 			dev_err(ce->dev, "Invalid sg number %d\n", nr_sgs);
 			err = -EINVAL;
@@ -178,15 +180,13 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 		}
 		nr_sgd = nr_sgs;
 	} else {
-		nr_sgs = dma_map_sg(ce->dev, areq->src, sg_nents(areq->src),
-				    DMA_TO_DEVICE);
+		nr_sgs = dma_map_sg(ce->dev, areq->src, ns, DMA_TO_DEVICE);
 		if (nr_sgs <= 0 || nr_sgs > MAX_SG) {
 			dev_err(ce->dev, "Invalid sg number %d\n", nr_sgs);
 			err = -EINVAL;
 			goto theend_iv;
 		}
-		nr_sgd = dma_map_sg(ce->dev, areq->dst, sg_nents(areq->dst),
-				    DMA_FROM_DEVICE);
+		nr_sgd = dma_map_sg(ce->dev, areq->dst, nd, DMA_FROM_DEVICE);
 		if (nr_sgd <= 0 || nr_sgd > MAX_SG) {
 			dev_err(ce->dev, "Invalid sg number %d\n", nr_sgd);
 			err = -EINVAL;
@@ -231,14 +231,11 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 
 theend_sgs:
 	if (areq->src == areq->dst) {
-		dma_unmap_sg(ce->dev, areq->src, sg_nents(areq->src),
-			     DMA_BIDIRECTIONAL);
+		dma_unmap_sg(ce->dev, areq->src, ns, DMA_BIDIRECTIONAL);
 	} else {
 		if (nr_sgs > 0)
-			dma_unmap_sg(ce->dev, areq->src, sg_nents(areq->src),
-				     DMA_TO_DEVICE);
-		dma_unmap_sg(ce->dev, areq->dst, sg_nents(areq->dst),
-			     DMA_FROM_DEVICE);
+			dma_unmap_sg(ce->dev, areq->src, ns, DMA_TO_DEVICE);
+		dma_unmap_sg(ce->dev, areq->dst, nd, DMA_FROM_DEVICE);
 	}
 
 theend_iv:
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
index 1c82cd510c75..59e07eb5f058 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
@@ -204,7 +204,7 @@ static bool sun8i_ce_hash_need_fallback(struct ahash_request *areq)
 	if (areq->nbytes == 0)
 		return true;
 	/* we need to reserve one SG for padding one */
-	if (sg_nents(areq->src) > MAX_SG - 1)
+	if (sg_nents_for_len(areq->src, areq->nbytes) > MAX_SG - 1)
 		return true;
 	sg = areq->src;
 	while (sg) {
@@ -229,7 +229,7 @@ int sun8i_ce_hash_digest(struct ahash_request *areq)
 	if (sun8i_ce_hash_need_fallback(areq))
 		return sun8i_ce_hash_digest_fb(areq);
 
-	nr_sgs = sg_nents(areq->src);
+	nr_sgs = sg_nents_for_len(areq->src, areq->nbytes);
 	if (nr_sgs > MAX_SG - 1)
 		return sun8i_ce_hash_digest_fb(areq);
 
@@ -328,6 +328,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	u64 bs;
 	int digestsize;
 	dma_addr_t addr_res, addr_pad;
+	int ns = sg_nents_for_len(areq->src, areq->nbytes);
 
 	algt = container_of(alg, struct sun8i_ce_alg_template, alg.hash);
 	ce = algt->ce;
@@ -372,7 +373,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	cet->t_sym_ctl = 0;
 	cet->t_asym_ctl = 0;
 
-	nr_sgs = dma_map_sg(ce->dev, areq->src, sg_nents(areq->src), DMA_TO_DEVICE);
+	nr_sgs = dma_map_sg(ce->dev, areq->src, ns, DMA_TO_DEVICE);
 	if (nr_sgs <= 0 || nr_sgs > MAX_SG) {
 		dev_err(ce->dev, "Invalid sg number %d\n", nr_sgs);
 		err = -EINVAL;
@@ -441,8 +442,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	err = sun8i_ce_run_task(ce, flow, crypto_tfm_alg_name(areq->base.tfm));
 
 	dma_unmap_single(ce->dev, addr_pad, j * 4, DMA_TO_DEVICE);
-	dma_unmap_sg(ce->dev, areq->src, sg_nents(areq->src),
-		     DMA_TO_DEVICE);
+	dma_unmap_sg(ce->dev, areq->src, ns, DMA_TO_DEVICE);
 	dma_unmap_single(ce->dev, addr_res, digestsize, DMA_FROM_DEVICE);
 
 
-- 
2.35.1

