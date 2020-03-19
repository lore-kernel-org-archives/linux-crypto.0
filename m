Return-Path: <SRS0=HVQB=5E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9429C4332D
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Mar 2020 16:13:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A317D21473
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Mar 2020 16:13:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WXJyVBCM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgCSQM7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Mar 2020 12:12:59 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42551 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728270AbgCSQM6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Mar 2020 12:12:58 -0400
Received: by mail-pf1-f194.google.com with SMTP id x2so1664126pfn.9;
        Thu, 19 Mar 2020 09:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2ATfd/evJNtMJU02hUmWNanYOGwfjBYhe+ZX93KVWo4=;
        b=WXJyVBCMhQcj1Acc4peOKy6p6WE/HUAHqynqghVewLt1XZh3aRdOaPLv5gBK+roM+7
         0ZiYI6a8WkuQVTQmILxbF4UFruapLPiGdEK9vty0atWUgFPi8f45eSU8jUPuI5UcDITU
         3Hz437FRpMito1vdnzTZJTQvt7LtRgPacpIQe1exuikEPcUqS+K52pxUGCfmDJPfScVY
         8cKWHs8Zb+KWiM/HdPG8WfG1VMW1EAVdmHbCAjj7xOAqjXlPqxIr9bn0gudxEaXg0ZNc
         q+uCcp+mPWLWFFLQI7TBUmdl/i3xFCQCJKNZPdezm09cvtnwJnIfbVZFZIO4cz/RT6Ex
         Q8mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2ATfd/evJNtMJU02hUmWNanYOGwfjBYhe+ZX93KVWo4=;
        b=g54WRyZboxfEjQLOwRQIi3XMaKdBmgX8gGP940vyRqEBQvJs+D3l/EpJlmBnezuFxB
         078ti25XnQ2hiQc6Ee0FqgCg1maaUARKXlqrN0WSKpuV2Q4qwwd+UgkhMzJlsYP1bKnr
         pU8OESK9cw64dhQX9T9yiePY2R4k7q5MXEYW6tE0W6i09EEuIrDnsAD9UcnCXjwcERUI
         4HH/sfNhp+uIURviw601pqfqchMmm20CwEo/0FhSdRQB3TpVYI8TtuRy7XCI2Iw5tvVC
         y5bN+SeoSDcBbAtYzH6CnZaR/rFxak6h7gC8RkX2zoKavpC9zeKegIKo0XOfHrQ2DFA8
         YJOA==
X-Gm-Message-State: ANhLgQ1Q5ynbSIe1KGzMY+8EBRrDxXg7ptphat9gGQNVIXsgoXowcUhj
        qtdYjxVsLEzRKuTQcTvwx4LTAvJK
X-Google-Smtp-Source: ADFU+vv+pWFZecsO7frRO11faN5pvh+F/TRuukBTwRiEWzKrNRCczdn48UnyriBlFTCMMSWA9J30Xw==
X-Received: by 2002:a62:15d3:: with SMTP id 202mr4995261pfv.231.1584634376609;
        Thu, 19 Mar 2020 09:12:56 -0700 (PDT)
Received: from localhost.localdomain (c-67-165-113-11.hsd1.wa.comcast.net. [67.165.113.11])
        by smtp.gmail.com with ESMTPSA id x189sm3000078pfb.1.2020.03.19.09.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 09:12:54 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH v9 2/9] crypto: caam - use struct hwrng's .init for initialization
Date:   Thu, 19 Mar 2020 09:12:26 -0700
Message-Id: <20200319161233.8134-3-andrew.smirnov@gmail.com>
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

Make caamrng code a bit more symmetric by moving initialization code
to .init hook of struct hwrng.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
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
index 34cbb4a56f05..69a02ac5de54 100644
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

