Return-Path: <SRS0=+94A=AC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9F94C433E0
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 19:31:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5D4823A9B
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 19:31:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="Ew3qfOOr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730110AbgFUTbX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Jun 2020 15:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730473AbgFUTbW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Jun 2020 15:31:22 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE495C061797
        for <linux-crypto@vger.kernel.org>; Sun, 21 Jun 2020 12:31:21 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id h5so14585564wrc.7
        for <linux-crypto@vger.kernel.org>; Sun, 21 Jun 2020 12:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+xIdR6ROlQQsYyBm9HmTjwcK2nY5CHq9LE79wf8WO1A=;
        b=Ew3qfOOrPByKwcpe9koDpI9xweCGUmkRRbC+VXL3d4o0y22jIxHyr0Ryq8Uu4s5Yhc
         T9fhC+AtV1f18sdJChGlHtaPt8Sym//uibRkWBWyfaaGcYV2qW9RxhHJdfr0k9EyhIp/
         MgGvkP4i51FyRTfX4Zxm5FmR0Z+/FQs/gDVKe0FWXrsHzwMxjjO5NDLfCdyAATtfPtJp
         s7GcIeQ1YHv9Fjl0KZWzkz1r4xoI9/YGYVgtDRLu28fK9rXOnpCPek6j5P6d2/W1QgUf
         JJMZ2NEX4RfE3Xo+Q0vEWDMj0YNH7iZZC7XqV02pkKPZMBz42JIJLyKvVrnm0JLvk7Zz
         bFrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+xIdR6ROlQQsYyBm9HmTjwcK2nY5CHq9LE79wf8WO1A=;
        b=sz6XCeXYHluP1LV7agm15cqSp5B9kh+Ylalo7V6mAClWC7KhyPaoFeLM9etePgaHs+
         YFEnfwr74mgC8IjAHdO5RsEHjy793HLmnwYqVpT4ElsnsVdYuBrmBMKC1c4KvOxp2DMF
         g8re+LBsm9BS10NaHC4Cg34Nsnkfxhbp9fpSV0ktvKgL1CQa6KO9VzzxAEgGSZQpR1g0
         vSSlOfa93aaLwTXQN55CF+2rEQr3gGWtTWGz5hLw6hC4eeWn1KQh+SPA8VR5aIJmUWuc
         6DfhiK6c03ca9Q8Cg/sehiTOSspLe/yYKMX9GoqoV3VCPW0ghEazV4nXCvGKvawJkT01
         Gf2A==
X-Gm-Message-State: AOAM5315FHmPvrY+DAzW2uKK2w8I81fCTzxo/1M0X3yNU6CM5fCAYT5F
        wMm9S7t8cexDM2Mot/H2/iVnqQ==
X-Google-Smtp-Source: ABdhPJxU3Ktft7BDAPKfDtNSvp3uX0xF9R8DkRISWBzq3I7ApeNjALMCfSw3imCtPNe/nkEZOWagAg==
X-Received: by 2002:a5d:4f0d:: with SMTP id c13mr16090908wru.357.1592767880584;
        Sun, 21 Jun 2020 12:31:20 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id e3sm16086924wrj.17.2020.06.21.12.31.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Jun 2020 12:31:20 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v3 08/14] crypto: sun8i-ce: split into prepare/run/unprepare
Date:   Sun, 21 Jun 2020 19:31:01 +0000
Message-Id: <1592767867-35982-9-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1592767867-35982-1-git-send-email-clabbe@baylibre.com>
References: <1592767867-35982-1-git-send-email-clabbe@baylibre.com>
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

