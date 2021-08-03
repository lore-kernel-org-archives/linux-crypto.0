Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 526DBC4338F
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Aug 2021 06:32:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A29D60F9C
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Aug 2021 06:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233816AbhHCGcT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Aug 2021 02:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbhHCGcT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Aug 2021 02:32:19 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6D0C06175F;
        Mon,  2 Aug 2021 23:32:08 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id q17-20020a17090a2e11b02901757deaf2c8so3402306pjd.0;
        Mon, 02 Aug 2021 23:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yU/myYHh2vReN4tRl5M0xqMvdpICyJtLf/+F4kJ0R+M=;
        b=TZtD0oQ73gj9v7Da7Y/ZSJEVOvJiUczdZ0KYyXvZV8m1yErq8P6aEiyn4MUt8J8glv
         1eYnR7hKsRmo8IurIe3j2XLp7G5dCoKMYRbdceZvaCY5o5jhN+oi9SjhJXVKJHTQadvw
         8X6FQOXGr9Wtmkb0/Kw20RdY3En5TkDk0v3ZjGTSeYauvd6PVFl5RbCE14DTFbjk9O92
         FLUTEG8kEVlxfuGhYAxjHZ99zzuwYLlX1ei4Sl8/WjR56wz/sEpRld4vcqjNsynYsELk
         csZDKukeBrZEYuh4qr40cyuFEFqJ+Rgd7ArDFXdTNE3Pw4+dyOJd50xwzcOrTO4B2XQB
         e2Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yU/myYHh2vReN4tRl5M0xqMvdpICyJtLf/+F4kJ0R+M=;
        b=Me/nldWEEXKrdFix1sto4dO7SNOERYodGLpUsf3uCx9xV//lySvVpLDswywJ0Sgboy
         +3wWsVjEa7JdVmfCHVv5Wh5ZlulaTfGxM869t+DZ82tkvu3Hckx2+3gwj0PewGxLBVaT
         7yttuGBuWNDGnuJCKV3Qhsdza2LvTfO4GTQA7etNpx4p5sJqHH9cBy0nKAL34KGXOhXU
         qtz30oNvrtNDuhTm8dWkuqQJ0axnZX/Z0QhfWNuoufIO9hY2HmeiQ5AOK+mnIVLNe162
         FB2/+VIWmxRlNNRkuEpP+JXFNsogp+VOEJ0Crt7UxbbshdFOhceL4BEE7OnmrHpfisPg
         6BsA==
X-Gm-Message-State: AOAM531Xb/YcZ8en84o0LHObSgozTxE5G7N9cfVshtyG6zXI1aLev/Sd
        ooHGFWpG5BjPczcYHKr2q0o=
X-Google-Smtp-Source: ABdhPJzdhyt16qsZxVu9D9Au4hF2N/SKOZjyWadJzIJxW87rj0ZSLZBnXxtkqiSoJoUHtrimXw0tJw==
X-Received: by 2002:a63:5c04:: with SMTP id q4mr1699247pgb.127.1627972327547;
        Mon, 02 Aug 2021 23:32:07 -0700 (PDT)
Received: from localhost.localdomain ([154.16.166.234])
        by smtp.gmail.com with ESMTPSA id l10sm12529401pjg.11.2021.08.02.23.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 23:32:07 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Eric Biggers <ebiggers@google.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Corentin Labbe <clabbe@baylibre.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] crypto: sun8i-ce: fix multiple memory leaks in sun8i_ce_hash_run
Date:   Tue,  3 Aug 2021 14:31:38 +0800
Message-Id: <20210803063149.2821093-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In sun8i_ce_hash_run, all the dma_mmap_sg/single will cause memory leak
due to no corresponding unmap operation if errors happen.

Fix this by freeing the objects allocated bydma_mmap_sg/single
when errors occur.

Fixes: 56f6d5aee88d ("crypto: sun8i-ce - support hash algorithms")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
v1->v2: fix some wording and keep error handling code consistent
 .../crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 27 ++++++++++---------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
index 88194718a806..05bb781da701 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
@@ -288,14 +288,14 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	buf = kzalloc(bs * 2, GFP_KERNEL | GFP_DMA);
 	if (!buf) {
 		err = -ENOMEM;
-		goto theend;
+		goto out;
 	}
 	bf = (__le32 *)buf;
 
 	result = kzalloc(digestsize, GFP_KERNEL | GFP_DMA);
 	if (!result) {
 		err = -ENOMEM;
-		goto theend;
+		goto err_buf;
 	}
 
 	flow = rctx->flow;
@@ -321,7 +321,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	if (nr_sgs <= 0 || nr_sgs > MAX_SG) {
 		dev_err(ce->dev, "Invalid sg number %d\n", nr_sgs);
 		err = -EINVAL;
-		goto theend;
+		goto err_result;
 	}
 
 	len = areq->nbytes;
@@ -334,7 +334,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	if (len > 0) {
 		dev_err(ce->dev, "remaining len %d\n", len);
 		err = -EINVAL;
-		goto theend;
+		goto err_unmap_sg;
 	}
 	addr_res = dma_map_single(ce->dev, result, digestsize, DMA_FROM_DEVICE);
 	cet->t_dst[0].addr = cpu_to_le32(addr_res);
@@ -342,7 +342,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	if (dma_mapping_error(ce->dev, addr_res)) {
 		dev_err(ce->dev, "DMA map dest\n");
 		err = -EINVAL;
-		goto theend;
+		goto err_unmap_sg;
 	}
 
 	byte_count = areq->nbytes;
@@ -392,7 +392,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	if (dma_mapping_error(ce->dev, addr_pad)) {
 		dev_err(ce->dev, "DMA error on padding SG\n");
 		err = -EINVAL;
-		goto theend;
+		goto err_addr_res;
 	}
 
 	if (ce->variant->hash_t_dlen_in_bits)
@@ -405,15 +405,18 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	err = sun8i_ce_run_task(ce, flow, crypto_tfm_alg_name(areq->base.tfm));
 
 	dma_unmap_single(ce->dev, addr_pad, j * 4, DMA_TO_DEVICE);
+err_addr_res:
+	dma_unmap_single(ce->dev, addr_res, digestsize, DMA_FROM_DEVICE);
+err_unmap_sg:
 	dma_unmap_sg(ce->dev, areq->src, sg_nents(areq->src),
 		     DMA_TO_DEVICE);
-	dma_unmap_single(ce->dev, addr_res, digestsize, DMA_FROM_DEVICE);
-
-
 	memcpy(areq->result, result, algt->alg.hash.halg.digestsize);
-theend:
-	kfree(buf);
+err_result:
 	kfree(result);
-	crypto_finalize_hash_request(engine, breq, err);
+err_buf:
+	kfree(buf);
+out:
+	if (!err)
+		crypto_finalize_hash_request(engine, breq, err);
 	return 0;
 }
-- 
2.25.1

