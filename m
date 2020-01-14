Return-Path: <SRS0=ZPJC=3D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A92BC33CB3
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jan 2020 14:00:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40DEB24679
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jan 2020 14:00:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YwKwklKF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbgANOAM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Jan 2020 09:00:12 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54628 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729040AbgANOAH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Jan 2020 09:00:07 -0500
Received: by mail-wm1-f65.google.com with SMTP id b19so13872899wmj.4;
        Tue, 14 Jan 2020 06:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mmCo0cmcYxTYUl0HTh9b5uPHQjBF+Ornrl4fpC6nIuw=;
        b=YwKwklKFwVrhQTbq9+emPqf95apR1314k05ofi1R4X4ecmLMYVeTbhUyQp8rc6JOOE
         1OtSdz22N7qTe1XPnouOPYwL70jWyR9WzmlK2ZXg2p4vGpwHbn4BMRc+jo0MBgwO6T0l
         kwj1Qo0YWV0mSI6WuIA9JmgmgulgXFJC/X0mzv2VstuVM/XkmTbkjnaL13iIDmY92It8
         5oNt9CMr3GzgOVZqxWqargG03QKjOuUSUMJbmcmPXGbcmT0gddtiaVxm7R4gWVDD353H
         OJ5ZNctjqERrdhzXqK1zFZdA3CDKpvZ79XSCt2HQ6upbF63gIHwk+/f4B7j0TroYbesC
         L5Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mmCo0cmcYxTYUl0HTh9b5uPHQjBF+Ornrl4fpC6nIuw=;
        b=rcIHleI73aIPMfFTkCUOdiB4s/Di6/J114pp92+lkbFvqF7JcYF2ekbKFO7xnLsp2l
         uywubl83JiupnTTu/BnxsB7UgGHEU//5PfYw1QMWiQTbEBauMABOI6HYz2VGb603VbKh
         1EugfIiCNkzXwvxv6GQXSSLQCwU0PkOMslPkUPzl5LqDDJJzLXZed0ATVdqyNOAQcT0a
         pPwFNv27r/KUPXWLpY3xG54AhdoM3g364wYQIAbFrShC+LQ9Gph0N+E4emAa78p3oEyk
         NjD7LUZgEQJLGUebYh1rXIVtadh72+CE77MSzcuQMkB70j9iQ+RsqDufs/nTMlZZ0yTt
         TNMQ==
X-Gm-Message-State: APjAAAV5xiXdxrUJsuCQg8SN5CD1Un/n4EUs+dp661ZOcabNI9lJoUqY
        GrINbq9f0mK6BIV8DHWuRNg=
X-Google-Smtp-Source: APXvYqxIi99Bpxvcwct69pL122PlCYsc6pFqFmQLsPv1kKKkDRC+0KM4vq6kSF3tJBiUx5oECNcNKw==
X-Received: by 2002:a7b:c389:: with SMTP id s9mr27249334wmj.7.1579010405396;
        Tue, 14 Jan 2020 06:00:05 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id 4sm17854448wmg.22.2020.01.14.06.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 06:00:04 -0800 (PST)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     alexandre.torgue@st.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, mcoquelin.stm32@gmail.com,
        mripard@kernel.org, wens@csie.org, iuliana.prodan@nxp.com,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH RFC 10/10] crypto: sun8i-ce: use the new batch mechanism
Date:   Tue, 14 Jan 2020 14:59:36 +0100
Message-Id: <20200114135936.32422-11-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114135936.32422-1-clabbe.montjoie@gmail.com>
References: <20200114135936.32422-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Now all infrastructure to batch request are in place, it is time to use
it.
Introduce some debug for it also.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 .../crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c    | 14 ++++++++------
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c  |  9 ++++++---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h       |  2 ++
 3 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index 41d18c18d1d1..fe5374788304 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -103,20 +103,22 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 
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
 
+#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
+	algt->stat_req++;
+	if (chan->engine->ct + 1 > chan->tmax)
+		chan->tmax = chan->engine->ct + 1;
+#endif
+
 	cet = &chan->tl[slot];
 	memset(cet, 0, sizeof(struct ce_task));
 
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index 39bf684c0ff5..7cd98c227357 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -104,7 +104,7 @@ int sun8i_ce_run_task(struct sun8i_ce_dev *ce, int flow, const char *name)
 	int err = 0;
 
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
-	ce->chanlist[flow].stat_req++;
+	ce->chanlist[flow].stat_req += ce->chanlist[flow].engine->ct;
 #endif
 	/* mark last one */
 	ce->chanlist[flow].tl[ce->chanlist[flow].engine->ct - 1].t_common_ctl |= cpu_to_le32(CE_COMM_INT);
@@ -287,7 +287,10 @@ static int sun8i_ce_dbgfs_read(struct seq_file *seq, void *v)
 	int i;
 
 	for (i = 0; i < MAXFLOW; i++)
-		seq_printf(seq, "Channel %d: nreq %lu\n", i, ce->chanlist[i].stat_req);
+		seq_printf(seq, "Channel %d: nreq %lu tmax %d eqlen=%d/%d\n", i,
+			   ce->chanlist[i].stat_req, ce->chanlist[i].tmax,
+			   ce->chanlist[i].engine->queue.qlen,
+			   ce->chanlist[i].engine->queue.max_qlen);
 
 	for (i = 0; i < ARRAY_SIZE(ce_algs); i++) {
 		if (!ce_algs[i].ce)
@@ -345,7 +348,7 @@ static int sun8i_ce_allocate_chanlist(struct sun8i_ce_dev *ce)
 	for (i = 0; i < MAXFLOW; i++) {
 		init_completion(&ce->chanlist[i].complete);
 
-		ce->chanlist[i].engine = crypto_engine_alloc_init(ce->dev, true);
+		ce->chanlist[i].engine = crypto_engine_alloc_init2(ce->dev, true, MAXTASK, MAXTASK * 2);
 		if (!ce->chanlist[i].engine) {
 			dev_err(ce->dev, "Cannot allocate engine\n");
 			i--;
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index 2d3325a13bf1..22bb15fea476 100644
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
@@ -145,6 +146,7 @@ struct sun8i_ce_flow {
 	struct ce_task *tl;
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
 	unsigned long stat_req;
+	int tmax;
 #endif
 };
 
-- 
2.24.1

