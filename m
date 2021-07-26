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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD06BC4320A
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Jul 2021 09:56:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C520B60E0C
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Jul 2021 09:56:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbhGZJPg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Jul 2021 05:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232156AbhGZJPf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Jul 2021 05:15:35 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2357C061757;
        Mon, 26 Jul 2021 02:56:03 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id gv20-20020a17090b11d4b0290173b9578f1cso12705668pjb.0;
        Mon, 26 Jul 2021 02:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8hq1iwo5Hm1g8aqgoAxXS/EpDF9ENodl1JxcIEWdESM=;
        b=Px3S4BKiazxPjW1E/yyznc3VnwcyyEkBrD1s0NbkzNsa/LlsIyxNSi/IfJUFzOwT+5
         yCNPZdmz0z642AmSQ/YTdyMEGViAedy1Vg6KcM3OeIn7xZT9D4pN6hrA9//BgA4XY3Ma
         LgXK1gXy3Q5pk7BO1oknmAC2kpXmLG27plvFchrn+dljf5CfyalatDyDGkEh8gzDtV7M
         4oxMznO1xd78rIX+qdcHvm7S5IyQWASK5Sdfc+pbhXn+9RdERMIZBOgHSltbXIQ1TPle
         XQDPiJbJUZfeeH0+CHDhs42LnYiC3jjUtvhNxQv96Ucoqcd+dThTCn/Z9VsmHoRy7s15
         b3uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8hq1iwo5Hm1g8aqgoAxXS/EpDF9ENodl1JxcIEWdESM=;
        b=VPSoKwAknb7b5czz7Iz8TUt1ZhVJd90Rn9sKY4dPKChB4lBRPClIujO7MqvXsvsIR/
         lH+QRYypbsAAkkbj5El3JCBjAJov4k1L+zP9cAbXVYXp9GK79GvH5KddJcYPZyHdnFHo
         bNHIFL0u7E0xVgM7nnyo2hkKjbPHkeGvlJddIriUVMz377DkLmHbWk8vMa0kzCSh7Vdj
         cTtZ+lVdDw276GfjJxEuFjGrTEPsjLMyMfNK+eafkpyPZ1eIiOY85KVhVm3YH0UicDQz
         j9MgPAASQJ5BKPnAipYXIqczwpOSEX/x2mOSh9RnJNIeDpRnaydeG6pqA7GHzNNFh3U+
         BMew==
X-Gm-Message-State: AOAM533n6fTw13Jm2zgXb/X6riZoDuy0lQ0n3gyrTaVCWbc5qNzDg7ub
        dqWPTeAKfbGP2jiv4QfcCsc=
X-Google-Smtp-Source: ABdhPJzCKM9r4O0HketpP2tZvU8A7c4NgYZXDFv335Gdxhn9JWdsPxJ6xFTlZodmsTONsRKS13lm5A==
X-Received: by 2002:a17:90b:212:: with SMTP id fy18mr5411891pjb.52.1627293363106;
        Mon, 26 Jul 2021 02:56:03 -0700 (PDT)
Received: from localhost.localdomain ([154.16.166.171])
        by smtp.gmail.com with ESMTPSA id r7sm10268304pga.44.2021.07.26.02.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 02:56:02 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Eric Biggers <ebiggers@google.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Colin Ian King <colin.king@canonical.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: [PATCH v3] crypto: sun8i-ce: fix memory leak and return value of sun8i_ce_hash_run
Date:   Mon, 26 Jul 2021 17:55:13 +0800
Message-Id: <20210726095536.2251860-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In sun8i_ce_hash_run, all the dma_mmap_sg/single will cause memory leak
due to no corresponding unmap operation if errors happen.

Fix this by adding error handling part for all the dma_mmap_sg/single.

Fixes: d9b45418a917 ("crypto: sun8i-ss - support hash algorithms")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
v1->v2: move crypto_finalize_hash_request to the end of function; move
the memcpy after the dma_mmap_sg/single functions.
v2->v3: remove some unrelated code changes; delete the fix of return value
since there is no corresponding handling code 
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
index 3c073eb3db03..5448705e8ae1 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
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
@@ -428,18 +428,19 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 	if (dma_mapping_error(ss->dev, addr_pad)) {
 		dev_err(ss->dev, "DMA error on padding SG\n");
 		err = -EINVAL;
-		goto theend;
+		goto err_addr_res;
 	}
 
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
-- 
2.25.1

