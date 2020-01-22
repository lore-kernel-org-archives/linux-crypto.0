Return-Path: <SRS0=EdI7=3L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53DEFC2D0DB
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 10:46:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DBD224688
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 10:46:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pHjQAKV6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729878AbgAVKqZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jan 2020 05:46:25 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34979 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729624AbgAVKqY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jan 2020 05:46:24 -0500
Received: by mail-wr1-f67.google.com with SMTP id g17so6743192wro.2;
        Wed, 22 Jan 2020 02:46:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HlVN3+Fqo4CnAsTqD0OmkrdM8WtTRqDQDULyBnPtHug=;
        b=pHjQAKV6qoTnYiEUG8pxraj4nOM5bni+aQ67wNb2KUb2//W/kbVd+97/KkvsiDvFhU
         KXfqLc/ykSk0I6tQToqBW5aydEU2S7a5z/ZaqJl4Roqxe9AiFIkwvl5713T/SMxDCs89
         zHicB6uVbaRr0/qRVxYiZ4eAl2VabxBEfnuFZow7BlAD5/g8MbRObrb0MYdOm6903zc+
         kwYTXGhCbJy/61a+nCJUYJtjXvJFwSNmXt/FpRo7Lb4t7ZpidDNG17axWiCba3nFw3md
         /P/HBlOYKl5oYmNfqf3u019vsC7R9mbUrN3uRG0Upg7XDFPuVAFOPizJTj5ljKukwAFP
         6xkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HlVN3+Fqo4CnAsTqD0OmkrdM8WtTRqDQDULyBnPtHug=;
        b=tP5hQcVCsC85SMQQwmkwDu8qYDfzlJg6trgUPg9KBBEQSpAbJVfQXapYKR5vVYj7nn
         B19oWiQ16Gz9cEX5Std7R071oYMC7KCT7GRhib0tiQU2e66tEKRBudNYNBKW2gsucoGo
         xZvtsut8H0sMPMoiVwhC2FufMSpmMvoLBh/QprnzALTCfOUgJvA3VDiKWuKiwu14uDkD
         vwu+M8k9/by1KESoysARV+d/KZBofd1FQcO3TkfPodAGgPfr8V49xSujgyvldgJ6Mcex
         /9Ni7I3v6/MeoOR2Ol+j7B3U8zhpwnNs9V7nYnpGdPBIp+VLhcmdrm0KRuTE83VfclXq
         wRbw==
X-Gm-Message-State: APjAAAUGkSZr1N0hFDu6iQfBX3ArqlVi0v4MizNrXn1zFKcjoxy1jCcs
        +UpLoKfkMUBT98lgTJpMQ2Y=
X-Google-Smtp-Source: APXvYqxtNeNC1yK6GUuYbu+60bk+pxY4Zl+3F/5+yXvy3VXeniYyMGDE6MOXVSGfQdIi4qEjFVGD7w==
X-Received: by 2002:a5d:534d:: with SMTP id t13mr10929059wrv.77.1579689981975;
        Wed, 22 Jan 2020 02:46:21 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id n3sm3443953wmc.27.2020.01.22.02.46.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 02:46:21 -0800 (PST)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org, iuliana.prodan@nxp.com
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 9/9] crypto: sun8i-ce: permit to batch requests
Date:   Wed, 22 Jan 2020 11:45:28 +0100
Message-Id: <20200122104528.30084-10-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200122104528.30084-1-clabbe.montjoie@gmail.com>
References: <20200122104528.30084-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch permit to batch request.
This imply:
- linking two task via next
- set interrupt flag just before running the batch in the last task.
- storing all requests for finalizing them later

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 .../allwinner/sun8i-ce/sun8i-ce-cipher.c      | 60 +++++++++++++++----
 .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 15 +++--
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  |  6 ++
 3 files changed, 66 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index fc0a2299c701..832fb4a51da9 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -96,31 +96,38 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 	int flow, i;
 	int nr_sgs = 0;
 	int nr_sgd = 0;
+	int slot = 0;
 	int err = 0;
 
 	algt = container_of(alg, struct sun8i_ce_alg_template, alg.skcipher);
 
-	dev_dbg(ce->dev, "%s %s %u %x IV(%p %u) key=%u\n", __func__,
+	dev_dbg(ce->dev, "%s %s %u %x IV(%p %u) key=%u slot=%d\n", __func__,
 		crypto_tfm_alg_name(areq->base.tfm),
 		areq->cryptlen,
 		rctx->op_dir, areq->iv, crypto_skcipher_ivsize(tfm),
-		op->keylen);
-
-#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
-	algt->stat_req++;
-#endif
+		op->keylen, slot);
 
 	flow = rctx->flow;
 
 	chan = &ce->chanlist[flow];
+	slot = chan->ct;
+
+#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
+	algt->stat_req++;
+	if (chan->ct + 1 > chan->tmax)
+		chan->tmax = chan->ct + 1;
+#endif
 
-	cet = chan->tl;
+	cet = &chan->tl[slot];
 	memset(cet, 0, sizeof(struct ce_task));
 
 	cet->t_id = cpu_to_le32(flow);
 	common = ce->variant->alg_cipher[algt->ce_algo_id];
-	common |= rctx->op_dir | CE_COMM_INT;
+	common |= rctx->op_dir;
 	cet->t_common_ctl = cpu_to_le32(common);
+	if (slot > 0)
+		chan->tl[slot - 1].next = cpu_to_le32(chan->t_phy + 176 * slot);
+
 	/* CTS and recent CE (H6) need length in bytes, in word otherwise */
 	if (ce->variant->has_t_dlen_in_bytes)
 		cet->t_dlen = cpu_to_le32(areq->cryptlen);
@@ -240,6 +247,9 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 	chan->timeout = areq->cryptlen;
 	rctx->nr_sgs = nr_sgs;
 	rctx->nr_sgd = nr_sgd;
+	rctx->slot = slot;
+	chan->lreq[chan->ct] = &areq->base;
+	chan->ct++;
 	return 0;
 
 theend_sgs:
@@ -281,14 +291,41 @@ int sun8i_ce_cipher_run(struct crypto_engine *engine, void *areq)
 	struct sun8i_cipher_tfm_ctx *op = crypto_skcipher_ctx(tfm);
 	struct sun8i_ce_dev *ce = op->ce;
 	struct sun8i_cipher_req_ctx *rctx = skcipher_request_ctx(breq);
+	struct sun8i_ce_flow *chan;
 	int flow, err;
+	int i;
 
 	flow = rctx->flow;
+	chan = &ce->chanlist[flow];
 	err = sun8i_ce_run_task(ce, flow, crypto_tfm_alg_name(breq->base.tfm));
-	crypto_finalize_skcipher_request(engine, breq, err);
+	for (i = 0; i < chan->ct; i++) {
+		if (!chan->lreq[i]) {
+			dev_err(ce->dev, "Missing request at slot %d\n", i);
+			continue;
+		}
+		breq = container_of(chan->lreq[i], struct skcipher_request, base);
+		crypto_finalize_skcipher_request(engine, breq, err);
+		chan->lreq[i] = NULL;
+	}
+	chan->ct = 0;
 	return 0;
 }
 
+static int sun8i_ce_qmore(struct crypto_engine *engine, void *async_req)
+{
+	struct skcipher_request *areq = container_of(async_req, struct skcipher_request, base);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
+	struct sun8i_cipher_tfm_ctx *op = crypto_skcipher_ctx(tfm);
+	struct sun8i_ce_dev *ce = op->ce;
+	struct sun8i_cipher_req_ctx *rctx = skcipher_request_ctx(areq);
+	struct sun8i_ce_flow *chan;
+	int flow;
+
+	flow = rctx->flow;
+	chan = &ce->chanlist[flow];
+	return MAXTASK - chan->ct;
+}
+
 static int sun8i_ce_cipher_unprepare(struct crypto_engine *engine, void *async_req)
 {
 	struct skcipher_request *areq = container_of(async_req, struct skcipher_request, base);
@@ -301,11 +338,13 @@ static int sun8i_ce_cipher_unprepare(struct crypto_engine *engine, void *async_r
 	unsigned int ivsize, offset;
 	int nr_sgs = rctx->nr_sgs;
 	int nr_sgd = rctx->nr_sgd;
+	int slot = rctx->slot;
 	int flow;
 
 	flow = rctx->flow;
 	chan = &ce->chanlist[flow];
-	cet = chan->tl;
+
+	cet = &chan->tl[slot];
 	ivsize = crypto_skcipher_ivsize(tfm);
 
 	if (areq->src == areq->dst) {
@@ -404,6 +443,7 @@ int sun8i_ce_cipher_init(struct crypto_tfm *tfm)
 	op->enginectx.op.do_one_request = sun8i_ce_cipher_run;
 	op->enginectx.op.prepare_request = sun8i_ce_cipher_prepare;
 	op->enginectx.op.unprepare_request = sun8i_ce_cipher_unprepare;
+	op->enginectx.op.can_queue_more = sun8i_ce_qmore;
 
 	err = pm_runtime_get_sync(op->ce->dev);
 	if (err < 0)
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index e8bf7bf31061..348d3927344b 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -104,8 +104,10 @@ int sun8i_ce_run_task(struct sun8i_ce_dev *ce, int flow, const char *name)
 	int err = 0;
 
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
-	ce->chanlist[flow].stat_req++;
+	ce->chanlist[flow].stat_req += ce->chanlist[flow].ct;
 #endif
+	/* mark last one */
+	ce->chanlist[flow].tl[ce->chanlist[flow].ct - 1].t_common_ctl |= cpu_to_le32(CE_COMM_INT);
 
 	mutex_lock(&ce->mlock);
 
@@ -120,7 +122,7 @@ int sun8i_ce_run_task(struct sun8i_ce_dev *ce, int flow, const char *name)
 	/* Be sure all data is written before enabling the task */
 	wmb();
 
-	v = 1 | (ce->chanlist[flow].tl->t_common_ctl & 0x7F) << 8;
+	v = 1 | (ce->chanlist[flow].tl[0].t_common_ctl & 0x7F) << 8;
 	writel(v, ce->base + CE_TLR);
 	mutex_unlock(&ce->mlock);
 
@@ -128,7 +130,7 @@ int sun8i_ce_run_task(struct sun8i_ce_dev *ce, int flow, const char *name)
 			msecs_to_jiffies(ce->chanlist[flow].timeout));
 
 	if (ce->chanlist[flow].status == 0) {
-		dev_err(ce->dev, "DMA timeout for %s\n", name);
+		dev_err(ce->dev, "DMA timeout for %s on flow %d (batch=%d)\n", name, flow, ce->chanlist[flow].ct);
 		err = -EFAULT;
 	}
 	/* No need to lock for this read, the channel is locked so
@@ -285,7 +287,10 @@ static int sun8i_ce_dbgfs_read(struct seq_file *seq, void *v)
 	int i;
 
 	for (i = 0; i < MAXFLOW; i++)
-		seq_printf(seq, "Channel %d: nreq %lu\n", i, ce->chanlist[i].stat_req);
+		seq_printf(seq, "Channel %d: nreq %lu tmax %d eqlen=%d/%d\n", i,
+			   ce->chanlist[i].stat_req, ce->chanlist[i].tmax,
+			   ce->chanlist[i].engine->queue.qlen,
+			   ce->chanlist[i].engine->queue.max_qlen);
 
 	for (i = 0; i < ARRAY_SIZE(ce_algs); i++) {
 		if (!ce_algs[i].ce)
@@ -343,7 +348,7 @@ static int sun8i_ce_allocate_chanlist(struct sun8i_ce_dev *ce)
 	for (i = 0; i < MAXFLOW; i++) {
 		init_completion(&ce->chanlist[i].complete);
 
-		ce->chanlist[i].engine = crypto_engine_alloc_init(ce->dev, true);
+		ce->chanlist[i].engine = crypto_engine_alloc_init2(ce->dev, true, MAXTASK * 2);
 		if (!ce->chanlist[i].engine) {
 			dev_err(ce->dev, "Cannot allocate engine\n");
 			i--;
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index 2d3325a13bf1..59e9985fc6c8 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -135,6 +135,7 @@ struct ce_task {
  * @t_phy:	Physical address of task
  * @tl:		pointer to the current ce_task for this flow
  * @stat_req:	number of request done by this flow
+ * @tmax:	The maximum number of tasks done in one batch
  */
 struct sun8i_ce_flow {
 	struct crypto_engine *engine;
@@ -143,8 +144,11 @@ struct sun8i_ce_flow {
 	dma_addr_t t_phy;
 	int timeout;
 	struct ce_task *tl;
+	struct crypto_async_request     *lreq[MAXTASK];
+	int ct;
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
 	unsigned long stat_req;
+	int tmax;
 #endif
 };
 
@@ -185,6 +189,7 @@ struct sun8i_ce_dev {
  * @ivlen:	size of bounce_iv
  * @nr_sgs:	The number of source SG (as given by dma_map_sg())
  * @nr_sgd:	The number of destination SG (as given by dma_map_sg())
+ * @slot:	The slot in the tasklist used for this requests
  */
 struct sun8i_cipher_req_ctx {
 	u32 op_dir;
@@ -194,6 +199,7 @@ struct sun8i_cipher_req_ctx {
 	unsigned int ivlen;
 	int nr_sgs;
 	int nr_sgd;
+	int slot;
 };
 
 /*
-- 
2.24.1

