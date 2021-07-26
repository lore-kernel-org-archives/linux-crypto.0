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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7AB3C4338F
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Jul 2021 15:25:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC17460F59
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Jul 2021 15:25:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235110AbhGZOpV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Jul 2021 10:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234823AbhGZOpU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Jul 2021 10:45:20 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DEB7C061757;
        Mon, 26 Jul 2021 08:25:48 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id a20so12258651plm.0;
        Mon, 26 Jul 2021 08:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YJ2wiacers242b03J1VtREz0S4EVBe3CkaiVWqJ9kVg=;
        b=hXQPIflR8ZhFX0feKPijERYg/69KAJPHtc16bQXnx5lGj90ised38lKMXuA3isoLjo
         Fb50Xww5eEsA1wFlnsHLSziCczZE1Jagx9Y8YNEElKJ9qPA88sVm8K8dfT0dnWRS5BBa
         aKK94+bXmAgSdIIza7k3+8Q8vrqK9rKc9OgqYH99Irpn8FwFP0USqQxAefNFiJKtKq4F
         zJw47BcDpvQR/nqjoY9oFLkizYEnsh3ERrDltT3NvLQp2Ma9Bo5Da4ob/Pwme5++Q4ZM
         Zju/5+OCgF0Po3B1EDRpC/L+DU14X7eIbPkPGtbo5VxH3GW7U79ANkpwjL3SAgv1qHnB
         VkRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YJ2wiacers242b03J1VtREz0S4EVBe3CkaiVWqJ9kVg=;
        b=g5Zo1hf3Y11Cu9sLfjQ7xxrPgtiGJtytUmKXPB8ypxr1xG8BUTJ6X+kCkWXHshqEDX
         HIeAGrxBy0aXhqpn735HoiHec3hwjnhQWX9fqYNibo6Wg0FtQAOSf6CS04+C+nQJhqx1
         XcMdOjPFdyCKO1fpgG0+pymzGaGWHCPOQarHpFkrnmp7ZWej4K7McTK6s7UVOprvQIz9
         PMk6zOLFYmQsZODeTRTrYDSQOntCXrpJcaPGcNwymOt9iRkU2omG1GVVCmJxjJAcAjds
         dZCj8x5NXvGv8bwgGjrJ6TGrjIjfc0F61SaMtepMIYuVVnMkUAGHJSLb8uBnt59K0jEy
         K/ZA==
X-Gm-Message-State: AOAM530KsU6lGxy4NIeNXEjAxCcSj+7UiVelT8zz7RHJjGl7cKcW/rOu
        OX6h5IjSStbIx97B6dImGg0=
X-Google-Smtp-Source: ABdhPJz9jcD2Df8C8OTsG5zvot3I4VXhYSaUTGjdkxXuICoBM5u5IMzBo9TCZcXaWwQ1mgTN5C2Ltw==
X-Received: by 2002:aa7:9541:0:b029:32c:cefa:123f with SMTP id w1-20020aa795410000b029032ccefa123fmr18103572pfq.24.1627313147752;
        Mon, 26 Jul 2021 08:25:47 -0700 (PDT)
Received: from localhost.localdomain ([154.16.166.171])
        by smtp.gmail.com with ESMTPSA id x14sm307079pfu.200.2021.07.26.08.25.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 08:25:47 -0700 (PDT)
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
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: [PATCH v4] crypto: sun8i-ss: fix multiple memory leaks in sun8i_ss_hash_run
Date:   Mon, 26 Jul 2021 23:25:21 +0800
Message-Id: <20210726152533.2281139-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In sun8i_ss_hash_run, all the dma_mmap_sg/single will cause memory leak
due to no corresponding unmap operation if errors happen.

Fix this by adding error handling part for all the dma_mmap_sg/single.

Fixes: d9b45418a917 ("crypto: sun8i-ss - support hash algorithms")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
v1->v2: move crypto_finalize_hash_request to the end of function; move
the memcpy after the dma_mmap_sg/single functions.
v2->v3: remove some unrelated code changes; delete the fix of return value
since there is no corresponding handling code
v3->v4: change sun8i_ce to sun8i_ss
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

