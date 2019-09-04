Return-Path: <SRS0=oAbn=W7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CC66C3A5A7
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 02:36:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8DD822CF8
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 02:36:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M5QHPpHz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbfIDCfr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 22:35:47 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35855 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728163AbfIDCfq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 22:35:46 -0400
Received: by mail-pl1-f193.google.com with SMTP id f19so8849396plr.3;
        Tue, 03 Sep 2019 19:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HBBIQ2ygAAAzNXsLICQMJrTUcjEuunt/v0rZQB2OEV8=;
        b=M5QHPpHz5gIwrnbKFChx+FQxefSY8txehv2OMO9WlkjGE+jJy4GQpyfyLNmOf0F8Ng
         63HZCJLelAe25ImvuEzSo97x7SLlwszwlwp0xRR169CafLYDUdIb5LOwvj8PvHixugvK
         oDcSrIX5+tQiLEKHnq2+tslWOCDzDfwzC8h0YB19KakOExWjjVoAhRT4SJNaZzE2rnSt
         RxjT+0S+Q/bC3ncG0i49s+4eLD/wpWXfV4wFD7JBda8c+G+ucy92NlOSoOS4/IFConSp
         otV/QZc7XcOqCVOURu5CEq/H5LTkFRL3+1pvNpj2GzohHESriwu5Id6MyouazRIj8qeb
         Tr6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HBBIQ2ygAAAzNXsLICQMJrTUcjEuunt/v0rZQB2OEV8=;
        b=sPwGT3fSfCPrbDVc4J1J9zHfYwkUjeyZPHjWpz1UK/TjdtwxxWqkE2rFU0pxo4QRFc
         PUcycOdvLvDJr5Wst3M1h7lju0xlm1hHnltr1pRpWh+yZHPlU5nOCZ2mso58LzfN1SbV
         qsJCkdZOxHEt/xo1g45tc4oBdTstgAaIZkfSg1NKhMs5ZcIhMiWOOqWat314rqLw/tCy
         BWqmonDv6OdoOgElVCvrsL1POsf3yFw3E8B1wjrn9N6FiWcUauS+GW6OM//zyAkZ+zbE
         H353h5beM2XuJqeYpynAgJFx/NWrqWlIV4aIAUL1FubdMwpJk7p9uS1KFZyZTy4tZv/p
         s0QQ==
X-Gm-Message-State: APjAAAV2ry5tGSskk1+9Q5SdMmWconcIrNiDgObeYcfXYv8U8yifqSrR
        9Lrwgw1NVxsKwb/mOpHHbV9L+bhVepU=
X-Google-Smtp-Source: APXvYqwGvKRGkMvXbflmJT/LOzlrcM/4q3gVyrWRlvcjoRY2KIPfksZ/8ZI6d+uNq7bo3NCwW7M50w==
X-Received: by 2002:a17:902:7c07:: with SMTP id x7mr20907394pll.54.1567564545683;
        Tue, 03 Sep 2019 19:35:45 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id i74sm7480250pfe.28.2019.09.03.19.35.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 19:35:45 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/12] crypto: caam - convert caamrng to platform device
Date:   Tue,  3 Sep 2019 19:35:14 -0700
Message-Id: <20190904023515.7107-12-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190904023515.7107-1-andrew.smirnov@gmail.com>
References: <20190904023515.7107-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In order to allow caam_jr_enqueue() to lock underlying JR's
device (via device_lock(), see commit that follows) we need to make
sure that no code calls caam_jr_enqueue() as a part of caam_jr_probe()
to avoid a deadlock. Unfortunately, current implementation of caamrng
code does exactly that in caam_init_buf().

Another big problem with original caamrng initialization is a
circular reference in the form of:

 1. caam_rng_init() aquires JR via caam_jr_alloc(). Freed only by
    caam_rng_exit()

 2. caam_rng_exit() is only called by unregister_algs() once last JR
    is shut down

 3. caam_jr_remove() won't call unregister_algs() for last JR
    until tfm_count reaches zero, which can only happen via
    unregister_algs() -> caam_rng_exit() call chain.

To avoid all of that, convert caamrng code to a platform device driver
and extend caam_probe() to create corresponding platform device.

Additionally, this change also allows us to remove any access to
struct caam_drv_private in caamrng.c as well as simplify resource
ownership/deallocation via devres.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/caam/caamrng.c | 102 +++++++++++++---------------------
 drivers/crypto/caam/ctrl.c    |  39 +++++++++++++
 drivers/crypto/caam/jr.c      |  23 ++++++--
 3 files changed, 97 insertions(+), 67 deletions(-)

diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index e8baacaabe07..f83ad34ac009 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -70,6 +70,7 @@ struct buf_data {
 
 /* rng per-device context */
 struct caam_rng_ctx {
+	struct hwrng hwrng;
 	struct device *jrdev;
 	dma_addr_t sh_desc_dma;
 	u32 sh_desc[DESC_RNG_LEN];
@@ -78,14 +79,6 @@ struct caam_rng_ctx {
 	struct buf_data bufs[2];
 };
 
-static struct caam_rng_ctx *rng_ctx;
-
-/*
- * Variable used to avoid double free of resources in case
- * algorithm registration was unsuccessful
- */
-static bool init_done;
-
 static inline void rng_unmap_buf(struct device *jrdev, struct buf_data *bd)
 {
 	if (bd->addr)
@@ -143,7 +136,7 @@ static inline int submit_job(struct caam_rng_ctx *ctx, int to_current)
 
 static int caam_read(struct hwrng *rng, void *data, size_t max, bool wait)
 {
-	struct caam_rng_ctx *ctx = rng_ctx;
+	struct caam_rng_ctx *ctx = (void *)rng->priv;
 	struct buf_data *bd = &ctx->bufs[ctx->current_buf];
 	int next_buf_idx, copied_idx;
 	int err;
@@ -247,15 +240,16 @@ static inline int rng_create_job_desc(struct caam_rng_ctx *ctx, int buf_id)
 static void caam_cleanup(struct hwrng *rng)
 {
 	int i;
+	struct caam_rng_ctx *ctx = (void *)rng->priv;
 	struct buf_data *bd;
 
 	for (i = 0; i < 2; i++) {
-		bd = &rng_ctx->bufs[i];
+		bd = &ctx->bufs[i];
 		if (atomic_read(&bd->empty) == BUF_PENDING)
 			wait_for_completion(&bd->filled);
 	}
 
-	rng_unmap_ctx(rng_ctx);
+	rng_unmap_ctx(ctx);
 }
 
 static int caam_init_buf(struct caam_rng_ctx *ctx, int buf_id)
@@ -274,12 +268,10 @@ static int caam_init_buf(struct caam_rng_ctx *ctx, int buf_id)
 	return 0;
 }
 
-static int caam_init_rng(struct caam_rng_ctx *ctx, struct device *jrdev)
+static int caam_init_rng(struct caam_rng_ctx *ctx)
 {
 	int err;
 
-	ctx->jrdev = jrdev;
-
 	err = rng_create_sh_desc(ctx);
 	if (err)
 		return err;
@@ -294,65 +286,49 @@ static int caam_init_rng(struct caam_rng_ctx *ctx, struct device *jrdev)
 	return caam_init_buf(ctx, 1);
 }
 
-static struct hwrng caam_rng = {
-	.name		= "rng-caam",
-	.cleanup	= caam_cleanup,
-	.read		= caam_read,
-};
-
-void caam_rng_exit(void)
+static void caamrng_jr_free(void *data)
 {
-	if (!init_done)
-		return;
-
-	caam_jr_free(rng_ctx->jrdev);
-	hwrng_unregister(&caam_rng);
-	kfree(rng_ctx);
+	caam_jr_free(data);
 }
 
-int caam_rng_init(struct device *ctrldev)
+static int caamrng_probe(struct platform_device *pdev)
 {
-	struct device *dev;
-	u32 rng_inst;
-	struct caam_drv_private *priv = dev_get_drvdata(ctrldev);
+	struct device *dev = &pdev->dev;
+	struct caam_rng_ctx *ctx;
 	int err;
-	init_done = false;
-
-	/* Check for an instantiated RNG before registration */
-	if (priv->era < 10)
-		rng_inst = (rd_reg32(&priv->ctrl->perfmon.cha_num_ls) &
-			    CHA_ID_LS_RNG_MASK) >> CHA_ID_LS_RNG_SHIFT;
-	else
-		rng_inst = rd_reg32(&priv->ctrl->vreg.rng) & CHA_VER_NUM_MASK;
 
-	if (!rng_inst)
-		return 0;
+	ctx = devm_kmalloc(dev, sizeof(*ctx), GFP_DMA | GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
 
-	dev = caam_jr_alloc();
-	if (IS_ERR(dev)) {
-		pr_err("Job Ring Device allocation for transform failed\n");
-		return PTR_ERR(dev);
-	}
-	rng_ctx = kmalloc(sizeof(*rng_ctx), GFP_DMA | GFP_KERNEL);
-	if (!rng_ctx) {
-		err = -ENOMEM;
-		goto free_caam_alloc;
+	ctx->jrdev = caam_jr_alloc();
+	err = PTR_ERR_OR_ZERO(ctx->jrdev);
+	if (err) {
+		dev_err(dev, "Job Ring Device allocation for transform failed\n");
+		return err;
 	}
-	err = caam_init_rng(rng_ctx, dev);
-	if (err)
-		goto free_rng_ctx;
 
-	dev_info(dev, "registering rng-caam\n");
+	err = devm_add_action_or_reset(dev, caamrng_jr_free, ctx->jrdev);
+	if (err)
+		return err;
 
-	err = hwrng_register(&caam_rng);
-	if (!err) {
-		init_done = true;
+	err = caam_init_rng(ctx);
+	if (err)
 		return err;
-	}
 
-free_rng_ctx:
-	kfree(rng_ctx);
-free_caam_alloc:
-	caam_jr_free(dev);
-	return err;
+	ctx->hwrng.cleanup = caam_cleanup;
+	ctx->hwrng.read    = caam_read;
+	ctx->hwrng.name    = "rng-caam";
+	ctx->hwrng.priv    = (unsigned long)ctx;
+
+	dev_info(dev, "registering rng-caam\n");
+
+	return devm_hwrng_register(dev, &ctx->hwrng);
 }
+
+struct platform_driver caamrng_driver = {
+	.probe = caamrng_probe,
+	.driver = {
+		.name = "caamrng",
+	},
+};
diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index d101c28d3d1f..ce3d5817c443 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -557,6 +557,26 @@ static void caam_remove_debugfs(void *root)
 }
 #endif
 
+static void caam_platform_device_unregister(void *data)
+{
+	platform_device_unregister(data);
+}
+
+static int caam_platform_device_register(struct device *dev, const char *name)
+{
+	struct platform_device *pdev;
+	int ret;
+
+	pdev = platform_device_register_simple(name,  -1, NULL, 0);
+	ret = PTR_ERR_OR_ZERO(pdev);
+	if (ret)
+		return ret;
+
+	return devm_add_action_or_reset(dev,
+					caam_platform_device_unregister,
+					pdev);
+}
+
 /* Probe routine for CAAM top (controller) level */
 static int caam_probe(struct platform_device *pdev)
 {
@@ -907,6 +927,25 @@ static int caam_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	if (IS_ENABLED(CONFIG_CRYPTO_DEV_FSL_CAAM_RNG_API)) {
+		u32 rng_inst;
+
+		/* Check for an instantiated RNG before registration */
+		if (ctrlpriv->era < 10)
+			rng_inst = (rd_reg32(&ctrl->perfmon.cha_num_ls) &
+				    CHA_ID_LS_RNG_MASK) >> CHA_ID_LS_RNG_SHIFT;
+		else
+			rng_inst = rd_reg32(&ctrl->vreg.rng) &
+				CHA_VER_NUM_MASK;
+
+
+		if (rng_inst) {
+			ret = caam_platform_device_register(dev, "caamrng");
+			if (ret)
+				return ret;
+		}
+	}
+
 	return 0;
 }
 
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index d11956bc358f..47b389cb1c62 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -37,7 +37,6 @@ static void register_algs(struct device *dev)
 	caam_algapi_init(dev);
 	caam_algapi_hash_init(dev);
 	caam_pkc_init(dev);
-	caam_rng_init(dev);
 	caam_qi_algapi_init(dev);
 
 algs_unlock:
@@ -53,7 +52,6 @@ static void unregister_algs(void)
 
 	caam_qi_algapi_exit();
 
-	caam_rng_exit();
 	caam_pkc_exit();
 	caam_algapi_hash_exit();
 	caam_algapi_exit();
@@ -287,7 +285,7 @@ struct device *caam_jr_alloc(void)
 
 	if (list_empty(&driver_data.jr_list)) {
 		spin_unlock(&driver_data.jr_alloc_lock);
-		return ERR_PTR(-ENODEV);
+		return ERR_PTR(-EPROBE_DEFER);
 	}
 
 	list_for_each_entry(jrpriv, &driver_data.jr_list, list_node) {
@@ -587,15 +585,32 @@ static struct platform_driver caam_jr_driver = {
 	.remove      = caam_jr_remove,
 };
 
+extern struct platform_driver caamrng_driver;
+
 static int __init jr_driver_init(void)
 {
+	int ret;
+
 	spin_lock_init(&driver_data.jr_alloc_lock);
 	INIT_LIST_HEAD(&driver_data.jr_list);
-	return platform_driver_register(&caam_jr_driver);
+	ret = platform_driver_register(&caam_jr_driver);
+	if (ret)
+		return ret;
+
+	if (IS_ENABLED(CONFIG_CRYPTO_DEV_FSL_CAAM_RNG_API)) {
+		ret = platform_driver_register(&caamrng_driver);
+		if (ret) {
+			platform_driver_unregister(&caam_jr_driver);
+			return ret;
+		}
+	}
+
+	return 0;
 }
 
 static void __exit jr_driver_exit(void)
 {
+	platform_driver_unregister(&caamrng_driver);
 	platform_driver_unregister(&caam_jr_driver);
 }
 
-- 
2.21.0

