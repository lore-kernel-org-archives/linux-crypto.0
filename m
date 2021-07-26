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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4FB2C432BE
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Jul 2021 08:02:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCD9760F37
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Jul 2021 08:02:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232815AbhGZHWW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Jul 2021 03:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232888AbhGZHWT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Jul 2021 03:22:19 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB03C061757;
        Mon, 26 Jul 2021 01:02:34 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id c16so5027488plh.7;
        Mon, 26 Jul 2021 01:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TztOQrqAi1WWdC8KOhyOiu1dKlM5nvZj+oiQ3YMyM5Q=;
        b=ZGB5+21luOnAKkD/7A35U+OjiJZK9c+9pwkHP9A018dW/F2AD0w9H/5V18yWp1G7UQ
         wpol1BciVR1o+Q31GnZR6Z3ePGJGKRuflhZxDlO4Te5Gma0D45BhIIlhQbwHPUk3bPtw
         DabraqMSH/M/kFGi+fnyAlpbyWf/Wmwn7KRsWJdXhTOocQEV5VtKD4VAHD9sovSPSniD
         1soqFwySa83YNflTn00pgF0ueAFriFz7BLs2ZfjP41bAl3j1o5X7TivslDQ+izLspg7f
         dho1VdM9SN+hzLDiJ7sSxtSoK6NCwsNyhrfAt//nDLm25qUv5HQeFQBF6yHdCSZDmU9L
         sB/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TztOQrqAi1WWdC8KOhyOiu1dKlM5nvZj+oiQ3YMyM5Q=;
        b=Qc9srNIoL8UUG7d9pdz9a/gqod4s3dK4VTaJ6UTX1Er8vYPbJ14DW1W0kBKBbRlU10
         DBIpl2ZWozkX/OzoJSXSMoRq3dda5uTWiltcqvZTmqBS7dZNxKUtphJGV3vuVUUzfooy
         cybNtnU2jIbK5Y6wjQdJrrQ0szLAlJhp2gbNSgu4w/32pGNmLm1AfVjBFabSRhsDVNTu
         WiKvADmBfOhM4eNUjAAQuxNB/6caU+aYqCQ2/+7eRD2bhZ5jc/HY4ktP8C/TwolbnNQ5
         ZQIFF383yO2KGlwJavnBfJwLzbxx9P6aKtrO3yivDuQ8l7PiZ81XAzpKmvAobrXZunG8
         WGpA==
X-Gm-Message-State: AOAM533XVJJKBk2WZ+2sPZ+mijTe2LNUjeeD+3tP+T4Z3PPq/OiO2bIM
        +Ow1ebyu8OU6CTmFosmwPx8=
X-Google-Smtp-Source: ABdhPJw4BP6wmZ6TTj7ePOuCck8LQRGI4lRD7w4VozOPSq+TdQxz/BRrTzLDjSn5gi9RqPGgkHgbyA==
X-Received: by 2002:a17:902:d916:b029:11e:3249:4a17 with SMTP id c22-20020a170902d916b029011e32494a17mr13666778plz.0.1627286554161;
        Mon, 26 Jul 2021 01:02:34 -0700 (PDT)
Received: from localhost.localdomain ([154.16.166.171])
        by smtp.gmail.com with ESMTPSA id 78sm34049460pfw.189.2021.07.26.01.02.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 01:02:33 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers@google.com>,
        Colin Ian King <colin.king@canonical.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Xiang Chen <chenxiang66@hisilicon.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] crypto: sun8i-ce: fix memory leak and return value of sun8i_ce_hash_run
Date:   Mon, 26 Jul 2021 15:59:36 +0800
Message-Id: <20210726075957.2231287-1-mudongliangabcd@gmail.com>
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
v1->v2: move crypto_finalize_hash_request to the end of function; move
the memcpy after the dma_mmap_sg/single functions. 
 .../crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 28 +++++++++----------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
index 3c073eb3db03..fe5db3c84754 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
@@ -324,11 +324,10 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 	struct sun8i_ss_alg_template *algt;
 	struct sun8i_ss_dev *ss;
 	struct scatterlist *sg;
-	int nr_sgs, err, digestsize;
+	int j, i, todo, nr_sgs, digestsize, err;
 	unsigned int len;
 	u64 fill, min_fill, byte_count;
 	void *pad, *result;
-	int j, i, todo;
 	__be64 *bebits;
 	__le64 *lebits;
 	dma_addr_t addr_res, addr_pad;
@@ -368,14 +367,14 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
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
@@ -390,7 +389,7 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 	if (len > 0) {
 		dev_err(ss->dev, "remaining len %d\n", len);
 		err = -EINVAL;
-		goto theend;
+		goto err_addr_res;
 	}
 
 	byte_count = areq->nbytes;
@@ -421,27 +420,28 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
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
 
 	err = sun8i_ss_run_hash_task(ss, rctx, crypto_tfm_alg_name(areq->base.tfm));
 
 	dma_unmap_single(ss->dev, addr_pad, j * 4, DMA_TO_DEVICE);
+err_addr_res:
+	dma_unmap_single(ss->dev, addr_res, digestsize, DMA_FROM_DEVICE);
+err_unmap_sg:
 	dma_unmap_sg(ss->dev, areq->src, sg_nents(areq->src),
 		     DMA_TO_DEVICE);
-	dma_unmap_single(ss->dev, addr_res, digestsize, DMA_FROM_DEVICE);
-
 	memcpy(areq->result, result, algt->alg.hash.halg.digestsize);
-theend:
+err_result:
 	kfree(pad);
 	kfree(result);
 	crypto_finalize_hash_request(engine, breq, err);
-	return 0;
+	return err;
 }
-- 
2.25.1

