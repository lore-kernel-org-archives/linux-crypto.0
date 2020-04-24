Return-Path: <SRS0=W4lJ=6I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A565C54FD0
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Apr 2020 14:02:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 046002075A
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Apr 2020 14:02:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="onhrFneX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbgDXOCq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Apr 2020 10:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728430AbgDXOCp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Apr 2020 10:02:45 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0C6C09B045
        for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2020 07:02:43 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id g12so10838163wmh.3
        for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2020 07:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+xIdR6ROlQQsYyBm9HmTjwcK2nY5CHq9LE79wf8WO1A=;
        b=onhrFneXL+HREqFhDlDzl3KWmCFWaBJqBVFW2Wx9GKFBxdLZbfU8tmLbthreOxb5HE
         vkfvOp8sNqUSe+w766rQlCOaZ2zALdAxikhXyZArCvh6pd0GuQZOCgu6po1AyM+ok/J6
         rVfASAgPx5q7yFJyZwTgIqfAmyfJ9TjI4pJCWS1YkdWtuuSDTR0BEXOTTcJm+VCYSvVJ
         +tZmz69k1o94h2FeAvIdGiGQq/dw8H+pgnhZB8zVvvJwByKGDt3uzqdmOQ5Vfta2R/Gw
         Tv3uTeojtFw7697xTun3MDsSZVmFurAohxpPxP6M9exlkUcaXhw84tv3EQ+nFFo6botG
         jWKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+xIdR6ROlQQsYyBm9HmTjwcK2nY5CHq9LE79wf8WO1A=;
        b=IcHHHQpJMH9Y8nAxoVimrMJ3+X0YMbH1olC4WTR1hYaDV6BjceN4X7G3C7TVNDaToI
         9ui/w0fToVI51kxjNdZWSKyUjQFQ5AEy2j93msmFfe2j7VLtPDjjDJBHp78JkNB8Wcc7
         LJQZAzHRN6Z77CsM+ov0bK4d/5PBiWyJVuvlO7/yPFr8chv73/HhMdaNg2c/FDAXF1jT
         A9ePKSnFlL7mcVA3CYpTKzcEWDE3Ac7kf/1G6tPklT5vG58PQsuWdumX+yt4k7/4sbED
         qjgfnSCnm0fBzDrlCtOwD6/xtftsdFdBTXbOQeHWwI1fiMi/ydxYapIQsjbOG0An9Nsi
         Q8fg==
X-Gm-Message-State: AGi0PubAM+De1zKC/KC8u+RD4BLOsRaE7wLWcFTxJA1C1/BINA9oNQkB
        K9RnQApkPS4M+85h+m+fmBD5ow==
X-Google-Smtp-Source: APiQypIeAx7J/vofT7s3q7EIA9lQ9CwvbzNGpuRn9789QH0+F4q5Fblu7FRr8fgCCWYi3y094ePzZg==
X-Received: by 2002:a1c:bc09:: with SMTP id m9mr9927322wmf.145.1587736962269;
        Fri, 24 Apr 2020 07:02:42 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id v131sm3061051wmb.19.2020.04.24.07.02.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Apr 2020 07:02:40 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 08/14] crypto: sun8i-ce: split into prepare/run/unprepare
Date:   Fri, 24 Apr 2020 14:02:08 +0000
Message-Id: <1587736934-22801-9-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587736934-22801-1-git-send-email-clabbe@baylibre.com>
References: <1587736934-22801-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch split the do_one_request into three.
Prepare will handle all DMA mapping and initialisation of the task
structure.
Unprepare will clean all DMA mapping.
And the do_one_request will be limited to just executing the task.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 .../allwinner/sun8i-ce/sun8i-ce-cipher.c      | 70 ++++++++++++++++---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  |  4 ++
 2 files changed, 66 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index 7716fa2d3250..d662dac83361 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -78,8 +78,9 @@ static int sun8i_ce_cipher_fallback(struct skcipher_request *areq)
 	return err;
 }
 
-static int sun8i_ce_cipher(struct skcipher_request *areq)
+static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req)
 {
+	struct skcipher_request *areq = container_of(async_req, struct skcipher_request, base);
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
 	struct sun8i_cipher_tfm_ctx *op = crypto_skcipher_ctx(tfm);
 	struct sun8i_ce_dev *ce = op->ce;
@@ -237,7 +238,9 @@ static int sun8i_ce_cipher(struct skcipher_request *areq)
 	}
 
 	chan->timeout = areq->cryptlen;
-	err = sun8i_ce_run_task(ce, flow, crypto_tfm_alg_name(areq->base.tfm));
+	rctx->nr_sgs = nr_sgs;
+	rctx->nr_sgd = nr_sgd;
+	return 0;
 
 theend_sgs:
 	if (areq->src == areq->dst) {
@@ -271,13 +274,64 @@ static int sun8i_ce_cipher(struct skcipher_request *areq)
 	return err;
 }
 
-static int sun8i_ce_handle_cipher_request(struct crypto_engine *engine, void *areq)
+int sun8i_ce_cipher_run(struct crypto_engine *engine, void *areq)
 {
-	int err;
 	struct skcipher_request *breq = container_of(areq, struct skcipher_request, base);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(breq);
+	struct sun8i_cipher_tfm_ctx *op = crypto_skcipher_ctx(tfm);
+	struct sun8i_ce_dev *ce = op->ce;
+	struct sun8i_cipher_req_ctx *rctx = skcipher_request_ctx(breq);
+	int flow, err;
 
-	err = sun8i_ce_cipher(breq);
+	flow = rctx->flow;
+	err = sun8i_ce_run_task(ce, flow, crypto_tfm_alg_name(breq->base.tfm));
 	crypto_finalize_skcipher_request(engine, breq, err);
+	return 0;
+}
+
+static int sun8i_ce_cipher_unprepare(struct crypto_engine *engine, void *async_req)
+{
+	struct skcipher_request *areq = container_of(async_req, struct skcipher_request, base);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
+	struct sun8i_cipher_tfm_ctx *op = crypto_skcipher_ctx(tfm);
+	struct sun8i_ce_dev *ce = op->ce;
+	struct sun8i_cipher_req_ctx *rctx = skcipher_request_ctx(areq);
+	struct sun8i_ce_flow *chan;
+	struct ce_task *cet;
+	unsigned int ivsize, offset;
+	int nr_sgs = rctx->nr_sgs;
+	int nr_sgd = rctx->nr_sgd;
+	int flow;
+
+	flow = rctx->flow;
+	chan = &ce->chanlist[flow];
+	cet = chan->tl;
+	ivsize = crypto_skcipher_ivsize(tfm);
+
+	if (areq->src == areq->dst) {
+		dma_unmap_sg(ce->dev, areq->src, nr_sgs, DMA_BIDIRECTIONAL);
+	} else {
+		if (nr_sgs > 0)
+			dma_unmap_sg(ce->dev, areq->src, nr_sgs, DMA_TO_DEVICE);
+		dma_unmap_sg(ce->dev, areq->dst, nr_sgd, DMA_FROM_DEVICE);
+	}
+
+	if (areq->iv && ivsize > 0) {
+		if (cet->t_iv)
+			dma_unmap_single(ce->dev, cet->t_iv, rctx->ivlen,
+					 DMA_TO_DEVICE);
+		offset = areq->cryptlen - ivsize;
+		if (rctx->op_dir & CE_DECRYPTION) {
+			memcpy(areq->iv, rctx->backup_iv, ivsize);
+			kzfree(rctx->backup_iv);
+		} else {
+			scatterwalk_map_and_copy(areq->iv, areq->dst, offset,
+						 ivsize, 0);
+		}
+		kfree(rctx->bounce_iv);
+	}
+
+	dma_unmap_single(ce->dev, cet->t_key, op->keylen, DMA_TO_DEVICE);
 
 	return 0;
 }
@@ -347,9 +401,9 @@ int sun8i_ce_cipher_init(struct crypto_tfm *tfm)
 		 crypto_tfm_alg_driver_name(&sktfm->base),
 		 crypto_tfm_alg_driver_name(crypto_skcipher_tfm(&op->fallback_tfm->base)));
 
-	op->enginectx.op.do_one_request = sun8i_ce_handle_cipher_request;
-	op->enginectx.op.prepare_request = NULL;
-	op->enginectx.op.unprepare_request = NULL;
+	op->enginectx.op.do_one_request = sun8i_ce_cipher_run;
+	op->enginectx.op.prepare_request = sun8i_ce_cipher_prepare;
+	op->enginectx.op.unprepare_request = sun8i_ce_cipher_unprepare;
 
 	err = pm_runtime_get_sync(op->ce->dev);
 	if (err < 0)
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index c9c7ef8299e2..fe97fee74e47 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -182,6 +182,8 @@ struct sun8i_ce_dev {
  * @backup_iv:	buffer which contain the next IV to store
  * @bounce_iv:	buffer which contain a copy of IV
  * @ivlen:	size of bounce_iv
+ * @nr_sgs:	The number of source SG (as given by dma_map_sg())
+ * @nr_sgd:	The number of destination SG (as given by dma_map_sg())
  */
 struct sun8i_cipher_req_ctx {
 	u32 op_dir;
@@ -189,6 +191,8 @@ struct sun8i_cipher_req_ctx {
 	void *backup_iv;
 	void *bounce_iv;
 	unsigned int ivlen;
+	int nr_sgs;
+	int nr_sgd;
 };
 
 /*
-- 
2.26.2

