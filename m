Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B04EAC4338F
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Jul 2021 06:28:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E9A4604D7
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Jul 2021 06:28:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbhGZFsB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Jul 2021 01:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbhGZFrx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Jul 2021 01:47:53 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54CEC061757;
        Sun, 25 Jul 2021 23:28:22 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id ds11-20020a17090b08cbb0290172f971883bso18279484pjb.1;
        Sun, 25 Jul 2021 23:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fJtZ1Lge7ch9gY6HxQCqLZ3+7A2ZCl+Ej1e0SFj7GW4=;
        b=UdWjKO+LBekJG2YJTComW+9j6yGUTpqqkY21ZZ/fdzX6poSUAItOZDdq5l+7yt7egq
         kclO4AjkRKmmS32JhDD8/iENz4Uce8y5b95yD5hI4OiW7J34vwufDJOi0KVtQvssI7lp
         xCBMLBgtQtiYz97unMlw+4i+PGWF06sYybX1h1fHm291/iTDcXDWoJ417rP4lEV+JKKy
         FZZuhQsGyrzZuUkvnMxMv8ZpNHVBbv3QaFWRIl5cYOGf5xsn9mqS8NPjuEMgqHJ8nDLd
         WauHF7rZwn4SdGQ3OIiatqYHfWsh9J/zSeQqxyzXkWGFXZNrgQr2rHFOVodxbWoKshmD
         crTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fJtZ1Lge7ch9gY6HxQCqLZ3+7A2ZCl+Ej1e0SFj7GW4=;
        b=n+hC6IZNmOLTy5tgbHB8mUcd0PD1Upvfu/kUtCL6TUbqEHFtilnSqZ+rp+i+OGhnLJ
         pdrhoPvqdPyhuXjdKtJW1DBR/xXyP2u5i3Zk7vRUjUGSXQ4xFqZ0NOmqxoZTc1HSIh13
         8nr0d3hr/T4AnDl6rFCcdg1VptJtxyrcY4WCkMx+nn79DtFLU9aGuN4nkETN6ybNBywV
         pEf7K9Fjp5oA9drPW+mB9Gvbs1CSAlPGMb0RHkkU9IFQnuq7qB3cCitNQOwjc1JCj72b
         jzYkDvkVeERdGGVH11W2umoENdTBnm/O6A33xm0bdiDfBXzoK1vnDuwxtqAUzGlzHXTJ
         mv7w==
X-Gm-Message-State: AOAM531BUhffJJrqKP0T0jqkEmUf3r3yfNj7YDrboqNe6PKhDpmfB33P
        afjcRw5r2LlDxU+XIMN6ZFEcJapIHfT/YpLC
X-Google-Smtp-Source: ABdhPJydxRF0jWm3UmMPuPpO+Clvc8XaF4cFhSLLWu1nFOvN5MOJf1A0EifKXWs21u3+WNN6hzukoA==
X-Received: by 2002:a63:3741:: with SMTP id g1mr17137811pgn.134.1627280902185;
        Sun, 25 Jul 2021 23:28:22 -0700 (PDT)
Received: from localhost.localdomain ([154.16.166.171])
        by smtp.gmail.com with ESMTPSA id w2sm12325363pjd.35.2021.07.25.23.28.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 23:28:21 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Xiang Chen <chenxiang66@hisilicon.com>
Cc:     dan.carpenter@oracle.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: sun8i-ce: fix memory leak and return value of sun8i_ce_hash_run
Date:   Mon, 26 Jul 2021 14:27:50 +0800
Message-Id: <20210726062801.2078117-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes some memory leak caused by dma_mmap_sg/single
in the error handling code. In addition, it fixes the return value
when errors related with dma_mmap_sg/single occur.

Reported-by: Dongliang Mu <mudongliangabcd@gmail.com>
Fixes: 732b764099f65 ("crypto: sun8i-ce - fix two error path's memory leak")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 .../crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 37 ++++++++++---------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
index 3c073eb3db03..7c4ed19f5466 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
@@ -324,11 +324,11 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 	struct sun8i_ss_alg_template *algt;
 	struct sun8i_ss_dev *ss;
 	struct scatterlist *sg;
-	int nr_sgs, err, digestsize;
+	int j, i, todo, nr_sgs, tmp_err, digestsize;
+	int err = 0;
 	unsigned int len;
 	u64 fill, min_fill, byte_count;
 	void *pad, *result;
-	int j, i, todo;
 	__be64 *bebits;
 	__le64 *lebits;
 	dma_addr_t addr_res, addr_pad;
@@ -368,14 +368,14 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 	if (nr_sgs <= 0 || nr_sgs > MAX_SG) {
 		dev_err(ss->dev, "Invalid sg number %d\n", nr_sgs);
 		err = -EINVAL;
-		goto theend;
+		goto err_result;
 	}
 
 	addr_res = dma_map_single(ss->dev, result, digestsize, DMA_FROM_DEVICE);
 	if (dma_mapping_error(ss->dev, addr_res)) {
 		dev_err(ss->dev, "DMA map dest\n");
 		err = -EINVAL;
-		goto theend;
+		goto err_unmap_sg;
 	}
 
 	len = areq->nbytes;
@@ -390,7 +390,7 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 	if (len > 0) {
 		dev_err(ss->dev, "remaining len %d\n", len);
 		err = -EINVAL;
-		goto theend;
+		goto err_addr_res;
 	}
 
 	byte_count = areq->nbytes;
@@ -421,27 +421,30 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 	}
 
 	addr_pad = dma_map_single(ss->dev, pad, j * 4, DMA_TO_DEVICE);
-	rctx->t_src[i].addr = addr_pad;
-	rctx->t_src[i].len = j;
-	rctx->t_dst[i].addr = addr_res;
-	rctx->t_dst[i].len = digestsize / 4;
 	if (dma_mapping_error(ss->dev, addr_pad)) {
 		dev_err(ss->dev, "DMA error on padding SG\n");
 		err = -EINVAL;
-		goto theend;
+		goto err_addr_res;
 	}
+	rctx->t_src[i].addr = addr_pad;
+	rctx->t_src[i].len = j;
+	rctx->t_dst[i].addr = addr_res;
+	rctx->t_dst[i].len = digestsize / 4;
 
-	err = sun8i_ss_run_hash_task(ss, rctx, crypto_tfm_alg_name(areq->base.tfm));
+	tmp_err = sun8i_ss_run_hash_task(ss, rctx, crypto_tfm_alg_name(areq->base.tfm));
+
+	memcpy(areq->result, result, algt->alg.hash.halg.digestsize);
+
+	crypto_finalize_hash_request(engine, breq, tmp_err);
 
 	dma_unmap_single(ss->dev, addr_pad, j * 4, DMA_TO_DEVICE);
+err_addr_res:
+	dma_unmap_single(ss->dev, addr_res, digestsize, DMA_FROM_DEVICE);
+err_unmap_sg:
 	dma_unmap_sg(ss->dev, areq->src, sg_nents(areq->src),
 		     DMA_TO_DEVICE);
-	dma_unmap_single(ss->dev, addr_res, digestsize, DMA_FROM_DEVICE);
-
-	memcpy(areq->result, result, algt->alg.hash.halg.digestsize);
-theend:
+err_result:
 	kfree(pad);
 	kfree(result);
-	crypto_finalize_hash_request(engine, breq, err);
-	return 0;
+	return err;
 }
-- 
2.25.1

