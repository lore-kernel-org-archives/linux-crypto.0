Return-Path: <SRS0=HVQB=5E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E303C4332D
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Mar 2020 16:13:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF9E620663
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Mar 2020 16:13:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hLyAnhV8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbgCSQND (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Mar 2020 12:13:03 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35593 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728270AbgCSQNC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Mar 2020 12:13:02 -0400
Received: by mail-pl1-f196.google.com with SMTP id g6so1264493plt.2;
        Thu, 19 Mar 2020 09:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ikmpOAjYjiZjMcu6wx7gyB/EupCQsqCMEG2y7EaS2d8=;
        b=hLyAnhV8iUaz9L6OvG4yok1R9WrlsS20bncuv83nVZ0kwXAVT7JnagX+1FyleeKQU3
         NPLybW8AU7TVFaYcq2++OvmSE/f2/tbpQWSYu8DjrtD2DVyd1MSqSf1/TVXr9aQH5nU9
         ryKrm8YfUnkr0OMad3Aqis1hRx8iAh0EpKPdj8D9F8uHkp9jwortazkfG3IEVxxtPKYM
         E1Fmz8D952rthLm6jx/RakoFuw/k+/duzDj2LrVsNN0jhmx7lVy2fFufDdGVPXb6NM4U
         Xj/XM1L8AxosM/7hfoYLw/k8SuEo4TPfBXO4+D3Zeslu6JOLckeEQb3BqRPTqmpwus8V
         i3Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ikmpOAjYjiZjMcu6wx7gyB/EupCQsqCMEG2y7EaS2d8=;
        b=si7N8iqWAIkDMmukhTbRNuxcgd3zOGeyyifBdDVAzwzZWti2xwg097/LWqHZd9hsao
         gEnWuclXl7RMnxfuesLr8ZUS8itiJUOefDL+KMMV37jYsid5jlTc9tWoj2IZ7cyS80tf
         jiC7uDuS07ynQ5HWey5v17d2w5URoot+L4qMjlhMvXVFOPmzqQu9hT3+M6SBrEkAM98T
         wIzRXSLSLegydn/qTeI2/iR5VSMOkSbWIl+JQ28xKqc4p1orxNZrav/F8M73YO2fNOEo
         uUSr2JI6MCiFGBEyTy7bywv09464TL/211slnFOxwgNZvX28AlFT9IhG1jyX771AczqP
         kPLg==
X-Gm-Message-State: ANhLgQ1CbMSHaJcHVvD8LguQMn7TOdWAakn8D3EiOe0jY0vnUXKN1ZFo
        fJCdA0zrwufEVaTh+X/TXtDXRJG4
X-Google-Smtp-Source: ADFU+vueUOzYFERasM0E8oI12/jKiVh9SgetVEDam1juhfHfTlJhmNbYo5OAkg3dcBk6a+CiQBYrqA==
X-Received: by 2002:a17:902:a588:: with SMTP id az8mr4030968plb.163.1584634380181;
        Thu, 19 Mar 2020 09:13:00 -0700 (PDT)
Received: from localhost.localdomain (c-67-165-113-11.hsd1.wa.comcast.net. [67.165.113.11])
        by smtp.gmail.com with ESMTPSA id x189sm3000078pfb.1.2020.03.19.09.12.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 09:12:58 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH v9 3/9] crypto: caam - drop global context pointer and init_done
Date:   Thu, 19 Mar 2020 09:12:27 -0700
Message-Id: <20200319161233.8134-4-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200319161233.8134-1-andrew.smirnov@gmail.com>
References: <20200319161233.8134-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Leverage devres to get rid of code storing global context as well as
init_done flag.

Original code also has a circular deallocation dependency where
unregister_algs() -> caam_rng_exit() -> caam_jr_free() chain would
only happen if all of JRs were freed. Fix this by moving
caam_rng_exit() outside of unregister_algs() and doing it specifically
for JR that instantiated HWRNG.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-imx@nxp.com
---
 drivers/crypto/caam/caamrng.c | 67 +++++++++++++++++------------------
 drivers/crypto/caam/intern.h  |  7 ++--
 drivers/crypto/caam/jr.c      | 13 ++++---
 3 files changed, 44 insertions(+), 43 deletions(-)

diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index 69a02ac5de54..753625f2b2c0 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -70,6 +70,7 @@ struct buf_data {
 
 /* rng per-device context */
 struct caam_rng_ctx {
+	struct hwrng rng;
 	struct device *jrdev;
 	dma_addr_t sh_desc_dma;
 	u32 sh_desc[DESC_RNG_LEN];
@@ -78,13 +79,10 @@ struct caam_rng_ctx {
 	struct buf_data bufs[2];
 };
 
-static struct caam_rng_ctx *rng_ctx;
-
-/*
- * Variable used to avoid double free of resources in case
- * algorithm registration was unsuccessful
- */
-static bool init_done;
+static struct caam_rng_ctx *to_caam_rng_ctx(struct hwrng *r)
+{
+	return (struct caam_rng_ctx *)r->priv;
+}
 
 static inline void rng_unmap_buf(struct device *jrdev, struct buf_data *bd)
 {
@@ -143,7 +141,7 @@ static inline int submit_job(struct caam_rng_ctx *ctx, int to_current)
 
 static int caam_read(struct hwrng *rng, void *data, size_t max, bool wait)
 {
-	struct caam_rng_ctx *ctx = rng_ctx;
+	struct caam_rng_ctx *ctx = to_caam_rng_ctx(rng);
 	struct buf_data *bd = &ctx->bufs[ctx->current_buf];
 	int next_buf_idx, copied_idx;
 	int err;
@@ -246,17 +244,18 @@ static inline int rng_create_job_desc(struct caam_rng_ctx *ctx, int buf_id)
 
 static void caam_cleanup(struct hwrng *rng)
 {
+	struct caam_rng_ctx *ctx = to_caam_rng_ctx(rng);
 	int i;
 	struct buf_data *bd;
 
 	for (i = 0; i < 2; i++) {
-		bd = &rng_ctx->bufs[i];
+		bd = &ctx->bufs[i];
 		if (atomic_read(&bd->empty) == BUF_PENDING)
 			wait_for_completion(&bd->filled);
 	}
 
-	rng_unmap_ctx(rng_ctx);
-	caam_jr_free(rng_ctx->jrdev);
+	rng_unmap_ctx(ctx);
+	caam_jr_free(ctx->jrdev);
 }
 
 static int caam_init_buf(struct caam_rng_ctx *ctx, int buf_id)
@@ -277,7 +276,7 @@ static int caam_init_buf(struct caam_rng_ctx *ctx, int buf_id)
 
 static int caam_init(struct hwrng *rng)
 {
-	struct caam_rng_ctx *ctx = rng_ctx;
+	struct caam_rng_ctx *ctx = to_caam_rng_ctx(rng);
 	int err;
 
 	ctx->jrdev = caam_jr_alloc();
@@ -309,28 +308,19 @@ static int caam_init(struct hwrng *rng)
 	return err;
 }
 
-static struct hwrng caam_rng = {
-	.name		= "rng-caam",
-	.init           = caam_init,
-	.cleanup	= caam_cleanup,
-	.read		= caam_read,
-};
+int caam_rng_init(struct device *ctrldev);
 
-void caam_rng_exit(void)
+void caam_rng_exit(struct device *ctrldev)
 {
-	if (!init_done)
-		return;
-
-	hwrng_unregister(&caam_rng);
-	kfree(rng_ctx);
+	devres_release_group(ctrldev, caam_rng_init);
 }
 
 int caam_rng_init(struct device *ctrldev)
 {
+	struct caam_rng_ctx *ctx;
 	u32 rng_inst;
 	struct caam_drv_private *priv = dev_get_drvdata(ctrldev);
-	int err;
-	init_done = false;
+	int ret;
 
 	/* Check for an instantiated RNG before registration */
 	if (priv->era < 10)
@@ -342,18 +332,27 @@ int caam_rng_init(struct device *ctrldev)
 	if (!rng_inst)
 		return 0;
 
-	rng_ctx = kmalloc(sizeof(*rng_ctx), GFP_DMA | GFP_KERNEL);
-	if (!rng_ctx)
+	if (!devres_open_group(ctrldev, caam_rng_init, GFP_KERNEL))
+		return -ENOMEM;
+
+	ctx = devm_kzalloc(ctrldev, sizeof(*ctx), GFP_DMA | GFP_KERNEL);
+	if (!ctx)
 		return -ENOMEM;
 
+	ctx->rng.name    = "rng-caam";
+	ctx->rng.init    = caam_init;
+	ctx->rng.cleanup = caam_cleanup;
+	ctx->rng.read    = caam_read;
+	ctx->rng.priv    = (unsigned long)ctx;
+
 	dev_info(ctrldev, "registering rng-caam\n");
 
-	err = hwrng_register(&caam_rng);
-	if (!err) {
-		init_done = true;
-		return err;
+	ret = devm_hwrng_register(ctrldev, &ctx->rng);
+	if (ret) {
+		caam_rng_exit(ctrldev);
+		return ret;
 	}
 
-	kfree(rng_ctx);
-	return err;
+	devres_close_group(ctrldev, caam_rng_init);
+	return 0;
 }
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index 230ea88184f5..402d6a362e8c 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -47,6 +47,7 @@ struct caam_drv_private_jr {
 	struct caam_job_ring __iomem *rregs;	/* JobR's register space */
 	struct tasklet_struct irqtask;
 	int irq;			/* One per queue */
+	bool hwrng;
 
 	/* Number of scatterlist crypt transforms active on the JobR */
 	atomic_t tfm_count ____cacheline_aligned;
@@ -163,7 +164,7 @@ static inline void caam_pkc_exit(void)
 #ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_RNG_API
 
 int caam_rng_init(struct device *dev);
-void caam_rng_exit(void);
+void caam_rng_exit(struct device *dev);
 
 #else
 
@@ -172,9 +173,7 @@ static inline int caam_rng_init(struct device *dev)
 	return 0;
 }
 
-static inline void caam_rng_exit(void)
-{
-}
+static inline void caam_rng_exit(struct device *dev) {}
 
 #endif /* CONFIG_CRYPTO_DEV_FSL_CAAM_RNG_API */
 
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 88aff2aefd5d..4af22e7ceb4f 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -27,7 +27,8 @@ static struct jr_driver_data driver_data;
 static DEFINE_MUTEX(algs_lock);
 static unsigned int active_devs;
 
-static void register_algs(struct device *dev)
+static void register_algs(struct caam_drv_private_jr *jrpriv,
+			  struct device *dev)
 {
 	mutex_lock(&algs_lock);
 
@@ -37,7 +38,7 @@ static void register_algs(struct device *dev)
 	caam_algapi_init(dev);
 	caam_algapi_hash_init(dev);
 	caam_pkc_init(dev);
-	caam_rng_init(dev);
+	jrpriv->hwrng = !caam_rng_init(dev);
 	caam_qi_algapi_init(dev);
 
 algs_unlock:
@@ -53,7 +54,6 @@ static void unregister_algs(void)
 
 	caam_qi_algapi_exit();
 
-	caam_rng_exit();
 	caam_pkc_exit();
 	caam_algapi_hash_exit();
 	caam_algapi_exit();
@@ -135,6 +135,9 @@ static int caam_jr_remove(struct platform_device *pdev)
 	jrdev = &pdev->dev;
 	jrpriv = dev_get_drvdata(jrdev);
 
+	if (jrpriv->hwrng)
+		caam_rng_exit(jrdev->parent);
+
 	/*
 	 * Return EBUSY if job ring already allocated.
 	 */
@@ -514,7 +517,7 @@ static int caam_jr_probe(struct platform_device *pdev)
 	int error;
 
 	jrdev = &pdev->dev;
-	jrpriv = devm_kmalloc(jrdev, sizeof(*jrpriv), GFP_KERNEL);
+	jrpriv = devm_kzalloc(jrdev, sizeof(*jrpriv), GFP_KERNEL);
 	if (!jrpriv)
 		return -ENOMEM;
 
@@ -590,7 +593,7 @@ static int caam_jr_probe(struct platform_device *pdev)
 
 	atomic_set(&jrpriv->tfm_count, 0);
 
-	register_algs(jrdev->parent);
+	register_algs(jrpriv, jrdev->parent);
 
 	return 0;
 }
-- 
2.21.0

