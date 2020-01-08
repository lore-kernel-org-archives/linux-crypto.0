Return-Path: <SRS0=xmdE=25=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99E0FC33CA2
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jan 2020 15:42:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 675072073A
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jan 2020 15:42:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YG0xVTOG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbgAHPmA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jan 2020 10:42:00 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:39300 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgAHPl7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jan 2020 10:41:59 -0500
Received: by mail-pj1-f66.google.com with SMTP id t101so1250176pjb.4;
        Wed, 08 Jan 2020 07:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mJRKn/O/sOX/kyS1VZ/irmvWoHkJDZeTp8EAvr0/qOg=;
        b=YG0xVTOGwobn7MkYuigBVuI2P5YBHuxt2pujqDSpd244i/mB3gGqUL4KHrZmovON2B
         zlXrPoIfjTThPnu14evwkJEn6TcoA/8dKnCvr1GHMPVYczWX6nBq6HvukReNPHPyHed1
         mrRlg0zS/7KRigfPEO2cxihRdmWxKW3la0LHFggxDFyZTdO+2FouCfijnc/2Vb6Uif3Y
         2iAncq5qQtzwvZ9msCaqvtGR2qNXPy/wdfrHbo0Z1Y3tAATkRmeJceuE+MCucM5vluJI
         nAEVrAuOeOsDFs6qwYdY6OV1GSFwEe4//rKQwyKUtxr19jWGsuH0dVxfnO17KGMFuYs5
         Df4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mJRKn/O/sOX/kyS1VZ/irmvWoHkJDZeTp8EAvr0/qOg=;
        b=JVpMi4A8clHhFIegycZ8SHHIHJJJm2Ni2XaV96Qvzh+DgTwDkQ1EszJrAIjf1mKcx6
         12NYGfFXxlUTleRgcvO9qNUYgEHEXS1L/ihFqChxn0TCs9OCOiBwiP1eLhZuywnnZCpJ
         GLyQUkXlCwvQI/06pvhrlbvm7mkTWUAAMTWc4+dvc8uUtRYvZTsEtv1M4j59kShDjdkB
         KqnKlUAw41cxHn/CsBQ9FnbmHMLi0/ngb+UYDB1+yS0o1BVigasVmOGu389E/UUHaVJs
         9lvlcJ3IBfq4+WoAuDd76yCNuBJ4z21DtiJzvyoc6iqi84KRYwTkNZrjhPxIeiOuLP61
         YkOA==
X-Gm-Message-State: APjAAAXIdRRvQ4t+KCJ3Enhjsw2YMHv5SEf1WRA17L5KR/J3KOgaiaT5
        dGTJyAOKcC3JfESef2C85GRyUOfR
X-Google-Smtp-Source: APXvYqzIEdSREN3lBgaCQc0cjuoW4xFgu91Jmy3nEsRiYSH8iUN95iY+Lz5MGfght77Gg04tXjTk0Q==
X-Received: by 2002:a17:90a:b002:: with SMTP id x2mr4937065pjq.38.1578498118271;
        Wed, 08 Jan 2020 07:41:58 -0800 (PST)
Received: from localhost.localdomain (c-67-165-113-11.hsd1.wa.comcast.net. [67.165.113.11])
        by smtp.gmail.com with ESMTPSA id e1sm4286640pfl.98.2020.01.08.07.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 07:41:57 -0800 (PST)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH v6 2/7] crypto: caam - drop global context pointer and init_done
Date:   Wed,  8 Jan 2020 07:40:42 -0800
Message-Id: <20200108154047.12526-3-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200108154047.12526-1-andrew.smirnov@gmail.com>
References: <20200108154047.12526-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Leverage devres to get rid of code storing global context as well as
init_done flag.

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
 drivers/crypto/caam/caamrng.c | 60 ++++++++++++-----------------------
 drivers/crypto/caam/intern.h  |  5 ---
 drivers/crypto/caam/jr.c      |  1 -
 3 files changed, 20 insertions(+), 46 deletions(-)

diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index 1ce7fbd29e85..fe187db91233 100644
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
+	return container_of(r, struct caam_rng_ctx, rng);
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
@@ -309,28 +308,11 @@ static int caam_init(struct hwrng *rng)
 	return err;
 }
 
-static struct hwrng caam_rng = {
-	.name		= "rng-caam",
-	.init           = caam_init,
-	.cleanup	= caam_cleanup,
-	.read		= caam_read,
-};
-
-void caam_rng_exit(void)
-{
-	if (!init_done)
-		return;
-
-	hwrng_unregister(&caam_rng);
-	kfree(rng_ctx);
-}
-
 int caam_rng_init(struct device *ctrldev)
 {
+	struct caam_rng_ctx *ctx;
 	u32 rng_inst;
 	struct caam_drv_private *priv = dev_get_drvdata(ctrldev);
-	int err;
-	init_done = false;
 
 	/* Check for an instantiated RNG before registration */
 	if (priv->era < 10)
@@ -342,18 +324,16 @@ int caam_rng_init(struct device *ctrldev)
 	if (!rng_inst)
 		return 0;
 
-	rng_ctx = kmalloc(sizeof(*rng_ctx), GFP_DMA | GFP_KERNEL);
-	if (!rng_ctx)
+	ctx = devm_kzalloc(ctrldev, sizeof(*ctx), GFP_DMA | GFP_KERNEL);
+	if (!ctx)
 		return -ENOMEM;
 
-	dev_info(ctrldev, "registering rng-caam\n");
+	ctx->rng.name    = "rng-caam";
+	ctx->rng.init    = caam_init;
+	ctx->rng.cleanup = caam_cleanup;
+	ctx->rng.read    = caam_read;
 
-	err = hwrng_register(&caam_rng);
-	if (!err) {
-		init_done = true;
-		return err;
-	}
+	dev_info(ctrldev, "registering rng-caam\n");
 
-	kfree(rng_ctx);
-	return err;
+	return devm_hwrng_register(ctrldev, &ctx->rng);
 }
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index c7c10c90464b..6d64931409eb 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -161,7 +161,6 @@ static inline void caam_pkc_exit(void)
 #ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_RNG_API
 
 int caam_rng_init(struct device *dev);
-void caam_rng_exit(void);
 
 #else
 
@@ -170,10 +169,6 @@ static inline int caam_rng_init(struct device *dev)
 	return 0;
 }
 
-static inline void caam_rng_exit(void)
-{
-}
-
 #endif /* CONFIG_CRYPTO_DEV_FSL_CAAM_RNG_API */
 
 #ifdef CONFIG_CAAM_QI
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index fc97cde27059..f15d0d92c031 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -53,7 +53,6 @@ static void unregister_algs(void)
 
 	caam_qi_algapi_exit();
 
-	caam_rng_exit();
 	caam_pkc_exit();
 	caam_algapi_hash_exit();
 	caam_algapi_exit();
-- 
2.21.0

