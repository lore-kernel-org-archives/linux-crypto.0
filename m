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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4550DC282DD
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jan 2020 15:42:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AAE82073A
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jan 2020 15:42:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="knynJ8ba"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729006AbgAHPl6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jan 2020 10:41:58 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45565 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgAHPl5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jan 2020 10:41:57 -0500
Received: by mail-pg1-f194.google.com with SMTP id b9so1747121pgk.12;
        Wed, 08 Jan 2020 07:41:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TcjeClmRH5R/km2Nzp0idBoWoVhmeZ5+erKgXpUxBBo=;
        b=knynJ8ba5fZ3R4P8XjkZ1TML44VOpPpxwLv9dGJ0RIRNMWtozzeLvArzdrNnNNAnqb
         vzyZ0bPXlp+l8BVqd5v3Ywk07VigcGDd15nIS6HCw0lRl2FkVi/GIYB/LQ3jaXBFyNyV
         rLEd3tHmPfsoLASlv+cmh75bU7LOCJGZsrCKGn8gNjc+gzEPS8JdbfHoezZli8P3a42k
         lC1EAYDWkzXmprwK2YfWmkSQYL0T8yfk6TAj7Z5nwI/mDMhiF0e/07DIQCdWZbw7I7os
         cPaK2AUAhDqnZ41308IPuFaO2qEeqj/nuzpKl94NMPjs6lF/qG+KZ+HizBlABMP5ZVDw
         gagQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TcjeClmRH5R/km2Nzp0idBoWoVhmeZ5+erKgXpUxBBo=;
        b=k46ht+2W0ezuUX+W4gQLFT7BuoekGyr57tcCStZDlTn3jWEUSTjTy7BvyqEnidfTpv
         N+Jt2bAnkLyFHJir8CT7YDVkofngLTYEUpQ8U8n8/8c7tG9ctV8UiqdqoCBiNuYzLIeY
         7JocIHwBdvP7ElMieG1Lqj+U4MPLPqS9mIskBUlmSAnU+nao+JlT2oI8q/AGh46ePlnC
         pHcXYnFnR7Toh7zCaibepg5Oie/VEKasGxbzlbHTzhSWDlhP7lQS4qNfP7bSjrw8XcRs
         cY0g/TecWPYzkqd/tgz5D8ZQIwLvA1Fux60/uWQr77m6tCy8zvvFIb+UlQetD6nmuqm5
         NAmA==
X-Gm-Message-State: APjAAAUyIuiX+Bf2OvQXjTXERMPIKyioPm7UNEvl4rPq/BK9AMO7v3n6
        3ClXHYzxR2AMtwzVwxHv3IF0ddqQ
X-Google-Smtp-Source: APXvYqxc7eLrfF3txmj8EG0QDiovMY2NZkrKXm4CAZCmFpdoaeqLTtGGMBP/xOCzhAmUuMtUHy6mvQ==
X-Received: by 2002:a63:4b49:: with SMTP id k9mr5812279pgl.269.1578498116399;
        Wed, 08 Jan 2020 07:41:56 -0800 (PST)
Received: from localhost.localdomain (c-67-165-113-11.hsd1.wa.comcast.net. [67.165.113.11])
        by smtp.gmail.com with ESMTPSA id e1sm4286640pfl.98.2020.01.08.07.41.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 07:41:55 -0800 (PST)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH v6 1/7] crypto: caam - use struct hwrng's .init for initialization
Date:   Wed,  8 Jan 2020 07:40:41 -0800
Message-Id: <20200108154047.12526-2-andrew.smirnov@gmail.com>
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

Make caamrng code a bit more symmetric by moving initialization code
to .init hook of struct hwrng.

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
 drivers/crypto/caam/caamrng.c | 47 ++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index e8baacaabe07..1ce7fbd29e85 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -256,6 +256,7 @@ static void caam_cleanup(struct hwrng *rng)
 	}
 
 	rng_unmap_ctx(rng_ctx);
+	caam_jr_free(rng_ctx->jrdev);
 }
 
 static int caam_init_buf(struct caam_rng_ctx *ctx, int buf_id)
@@ -274,28 +275,43 @@ static int caam_init_buf(struct caam_rng_ctx *ctx, int buf_id)
 	return 0;
 }
 
-static int caam_init_rng(struct caam_rng_ctx *ctx, struct device *jrdev)
+static int caam_init(struct hwrng *rng)
 {
+	struct caam_rng_ctx *ctx = rng_ctx;
 	int err;
 
-	ctx->jrdev = jrdev;
+	ctx->jrdev = caam_jr_alloc();
+	err = PTR_ERR_OR_ZERO(ctx->jrdev);
+	if (err) {
+		pr_err("Job Ring Device allocation for transform failed\n");
+		return err;
+	}
 
 	err = rng_create_sh_desc(ctx);
 	if (err)
-		return err;
+		goto free_jrdev;
 
 	ctx->current_buf = 0;
 	ctx->cur_buf_idx = 0;
 
 	err = caam_init_buf(ctx, 0);
 	if (err)
-		return err;
+		goto free_jrdev;
+
+	err = caam_init_buf(ctx, 1);
+	if (err)
+		goto free_jrdev;
 
-	return caam_init_buf(ctx, 1);
+	return 0;
+
+free_jrdev:
+	caam_jr_free(ctx->jrdev);
+	return err;
 }
 
 static struct hwrng caam_rng = {
 	.name		= "rng-caam",
+	.init           = caam_init,
 	.cleanup	= caam_cleanup,
 	.read		= caam_read,
 };
@@ -305,14 +321,12 @@ void caam_rng_exit(void)
 	if (!init_done)
 		return;
 
-	caam_jr_free(rng_ctx->jrdev);
 	hwrng_unregister(&caam_rng);
 	kfree(rng_ctx);
 }
 
 int caam_rng_init(struct device *ctrldev)
 {
-	struct device *dev;
 	u32 rng_inst;
 	struct caam_drv_private *priv = dev_get_drvdata(ctrldev);
 	int err;
@@ -328,21 +342,11 @@ int caam_rng_init(struct device *ctrldev)
 	if (!rng_inst)
 		return 0;
 
-	dev = caam_jr_alloc();
-	if (IS_ERR(dev)) {
-		pr_err("Job Ring Device allocation for transform failed\n");
-		return PTR_ERR(dev);
-	}
 	rng_ctx = kmalloc(sizeof(*rng_ctx), GFP_DMA | GFP_KERNEL);
-	if (!rng_ctx) {
-		err = -ENOMEM;
-		goto free_caam_alloc;
-	}
-	err = caam_init_rng(rng_ctx, dev);
-	if (err)
-		goto free_rng_ctx;
+	if (!rng_ctx)
+		return -ENOMEM;
 
-	dev_info(dev, "registering rng-caam\n");
+	dev_info(ctrldev, "registering rng-caam\n");
 
 	err = hwrng_register(&caam_rng);
 	if (!err) {
@@ -350,9 +354,6 @@ int caam_rng_init(struct device *ctrldev)
 		return err;
 	}
 
-free_rng_ctx:
 	kfree(rng_ctx);
-free_caam_alloc:
-	caam_jr_free(dev);
 	return err;
 }
-- 
2.21.0

