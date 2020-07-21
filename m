Return-Path: <SRS0=Ahx1=BA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C679C43445
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 19:07:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7092D206E9
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 19:07:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="t+rcgIWa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730423AbgGUTHp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jul 2020 15:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730418AbgGUTGx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jul 2020 15:06:53 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF36C0619E5
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2020 12:06:51 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id a14so7377169wra.5
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2020 12:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gu2nO542K4ougfxaUDiK4mdQGGUo4JdtK15CmsafJKs=;
        b=t+rcgIWa5lHEoQzSKZSWF3cm+UP/Hv2bHbRsiniu+dvJwjpHyRU67/tcDUdwbsAbCR
         PA4M9G54dd0n9djarFBeGhj4+r4eugSOnaQH+6xWKNvfUrZvxMEppABN6nh9wRPYc6Ca
         pwZ2LFdj8IqGk3qrhrHOdlGlc9vie7qourBT6FRdTFUjYGhKVcEwVt9o/KNQz+zxcP41
         H9cpo8AWIFj2XQkcDSUhxvQP4PMJFFkOuceVuOAhstc7JTJmvxz8El3KcHW6e0bL5aQZ
         X05EVcLxe3JKVa1FkGoa7xODp7EgzfgTV88IovSHG7J0u7dStnBJWWmNrf5lzOjJPCbl
         Gkvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gu2nO542K4ougfxaUDiK4mdQGGUo4JdtK15CmsafJKs=;
        b=rf02CHmXnF92P7WrzGzfCraUPl+df65ofUx/XqmDm+CqY6GxJnpRBoCHq6PjLkeqOz
         0A+f1puCZznSfkKW6FIkrQIQyjJ2IdEwZ3AOoYsrPQarCaCtPPE2pqWVm3w61ETDWoZA
         a05wyPylDSTvTVG2jXDnV0uv+a6Rbdczbri67Ae+nCeOIdJRCO663CH+9tK0GpgrHVsd
         7/OG3fiaZ4AqkLXux8huRQy/J0MBeboueIiWjhBpC1p4nh3ws7HVxJayLj1YHxskUTl1
         uCItV2haJItBeJaYZZgqyewd+IEA6tg7fMOeq9HgLUn6PCPNoL0nr5iWRNO7wf3NkHDI
         nBxw==
X-Gm-Message-State: AOAM530hoyEdo/FYzapNDsIfUKX5eyHa4guqR+9Pji7+3giYRVIjAsn1
        B7o/LsyWx1NTbPFhbJqdz4a/cQ==
X-Google-Smtp-Source: ABdhPJy1TzvilabUb9mYsFi4a7G6t6pRTeae3rp4mCDfVFZxyjIIBxGOIpmbnr0iJFp0OD93GoXP0w==
X-Received: by 2002:a05:6000:1190:: with SMTP id g16mr26507255wrx.286.1595358410210;
        Tue, 21 Jul 2020 12:06:50 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id s14sm25794848wrv.24.2020.07.21.12.06.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jul 2020 12:06:49 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v4 09/17] crypto: sun8i-ce: split into prepare/run/unprepare
Date:   Tue, 21 Jul 2020 19:06:23 +0000
Message-Id: <1595358391-34525-10-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595358391-34525-1-git-send-email-clabbe@baylibre.com>
References: <1595358391-34525-1-git-send-email-clabbe@baylibre.com>
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
index 2252604d821b..fa12c966c45f 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -75,8 +75,9 @@ static int sun8i_ce_cipher_fallback(struct skcipher_request *areq)
 	return err;
 }
 
-static int sun8i_ce_cipher(struct skcipher_request *areq)
+static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req)
 {
+	struct skcipher_request *areq = container_of(async_req, struct skcipher_request, base);
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
 	struct sun8i_cipher_tfm_ctx *op = crypto_skcipher_ctx(tfm);
 	struct sun8i_ce_dev *ce = op->ce;
@@ -234,7 +235,9 @@ static int sun8i_ce_cipher(struct skcipher_request *areq)
 	}
 
 	chan->timeout = areq->cryptlen;
-	err = sun8i_ce_run_task(ce, flow, crypto_tfm_alg_name(areq->base.tfm));
+	rctx->nr_sgs = nr_sgs;
+	rctx->nr_sgd = nr_sgd;
+	return 0;
 
 theend_sgs:
 	if (areq->src == areq->dst) {
@@ -268,13 +271,64 @@ static int sun8i_ce_cipher(struct skcipher_request *areq)
 	return err;
 }
 
-static int sun8i_ce_handle_cipher_request(struct crypto_engine *engine, void *areq)
+static int sun8i_ce_cipher_run(struct crypto_engine *engine, void *areq)
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
+			kfree_sensitive(rctx->backup_iv);
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
@@ -346,9 +400,9 @@ int sun8i_ce_cipher_init(struct crypto_tfm *tfm)
 		 crypto_tfm_alg_driver_name(&sktfm->base),
 		 crypto_tfm_alg_driver_name(crypto_skcipher_tfm(op->fallback_tfm)));
 
-	op->enginectx.op.do_one_request = sun8i_ce_handle_cipher_request;
-	op->enginectx.op.prepare_request = NULL;
-	op->enginectx.op.unprepare_request = NULL;
+	op->enginectx.op.do_one_request = sun8i_ce_cipher_run;
+	op->enginectx.op.prepare_request = sun8i_ce_cipher_prepare;
+	op->enginectx.op.unprepare_request = sun8i_ce_cipher_unprepare;
 
 	err = pm_runtime_get_sync(op->ce->dev);
 	if (err < 0)
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index f5555c4800e8..084a962b8d4f 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -182,6 +182,8 @@ struct sun8i_ce_dev {
  * @backup_iv:		buffer which contain the next IV to store
  * @bounce_iv:		buffer which contain the IV
  * @ivlen:		size of bounce_iv
+ * @nr_sgs:		The number of source SG (as given by dma_map_sg())
+ * @nr_sgd:		The number of destination SG (as given by dma_map_sg())
  * @fallback_req:	request struct for invoking the fallback skcipher TFM
  */
 struct sun8i_cipher_req_ctx {
@@ -190,6 +192,8 @@ struct sun8i_cipher_req_ctx {
 	void *backup_iv;
 	void *bounce_iv;
 	unsigned int ivlen;
+	int nr_sgs;
+	int nr_sgd;
 	struct skcipher_request fallback_req;   // keep at the end
 };
 
-- 
2.26.2

