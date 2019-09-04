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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A97CC3A5A2
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 02:36:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C18B208E4
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 02:36:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N89FswKp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbfIDCgC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 22:36:02 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33173 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728107AbfIDCfm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 22:35:42 -0400
Received: by mail-pl1-f193.google.com with SMTP id t11so2765386plo.0;
        Tue, 03 Sep 2019 19:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a1OXvWBHbx6Jpw0bU7aMn0vFZQwXoXSk/2hAapg2HNo=;
        b=N89FswKpklM+SWQ7xH7sP3vvgxQXcVsgZFT70yhrJFGdHj5N1A5osZuiPlmaAxFmA6
         y531hW2VCze8hfb67Vhp+kVuzpTWQQc0j22tqMgN5DofSmuSmuR264OdVGDmwjbg6o8k
         yE2v5xq/FY8VsUVvCHTvEj/CqCEVCFgM34ac6ZvA3G/aM8eaj6KGrmEf+uSi+p3XXRrA
         3NOdQYfM0MaHc2DrsGXnjXan7w8SbtrwTuMx71geFdPBqNXD+fuHCNZ36qBbuTjnG9zh
         DuayDqXupdKaUoMPXjUkqmzjXllXl0ZYMKnEhtEegpG3srVZkjJJe1Z4l66MEWgHhMPp
         NrOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a1OXvWBHbx6Jpw0bU7aMn0vFZQwXoXSk/2hAapg2HNo=;
        b=nNNCZUN0rHXJiO9p724q/R4JwHWUqaXX5tWnjFDGBP9rrMyryO6S3YETXWMK86FO3I
         eafNpYHsVowCfi0vzC0dxctdvjvWBbG07wKTKhqTKdAMBMqHowKvRIe8LSMcYnyONxdN
         p9Qnhg/tktcGFHL0KVTK8ayvrldmw0GazJLC3ybFrxaIhfZ+XCmuKXWXaFiw7sylB/we
         CyZddQboX/Sx81AYpxB+CGUbgW7zCvlQwHYnFcO4g88IoudTI4XywggS4X+Bjs8/EMN8
         a7dqblK7vd8T+Le7wpT0NXKJyL7HbXSd5tYBEkC3MLOmm1QWyGLy+iAdNmgOFIJKQ3EA
         QMcw==
X-Gm-Message-State: APjAAAWh5e411KEGT3iO6gsEzeVgnjiiMTsM7MYizr0GpNTyJdYjK2AH
        jpq1aWTruq87gODqR7VaNF6AFXHz8fc=
X-Google-Smtp-Source: APXvYqwUghA4TVKfW2qDHg/7FIK5uKmxjYeQsM/wQ6mJu/s0HfWLzR95ucRe/K4+OeOynoI9eHcJcw==
X-Received: by 2002:a17:902:e605:: with SMTP id cm5mr1921890plb.226.1567564541965;
        Tue, 03 Sep 2019 19:35:41 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id i74sm7480250pfe.28.2019.09.03.19.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 19:35:41 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/12] crypto: caam - use devres to de-initialize QI
Date:   Tue,  3 Sep 2019 19:35:11 -0700
Message-Id: <20190904023515.7107-9-andrew.smirnov@gmail.com>
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

Use devres to de-initialize the QI and drop explicit de-initialization
code in caam_remove().

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/caam/ctrl.c   | 14 +-------------
 drivers/crypto/caam/intern.h |  3 ---
 drivers/crypto/caam/qi.c     |  8 ++++++--
 drivers/crypto/caam/qi.h     |  1 -
 4 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 25f8f76551a5..37cd04f8ddb1 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -333,11 +333,6 @@ static int caam_remove(struct platform_device *pdev)
 	/* Remove platform devices under the crypto node */
 	of_platform_depopulate(ctrldev);
 
-#ifdef CONFIG_CAAM_QI
-	if (ctrlpriv->qi_init)
-		caam_qi_shutdown(ctrldev);
-#endif
-
 	return 0;
 }
 
@@ -770,7 +765,7 @@ static int caam_probe(struct platform_device *pdev)
 	ret = of_platform_populate(nprop, caam_match, NULL, dev);
 	if (ret) {
 		dev_err(dev, "JR platform devices creation error\n");
-		goto shutdown_qi;
+		return ret;
 	}
 
 	ring = 0;
@@ -931,13 +926,6 @@ static int caam_probe(struct platform_device *pdev)
 caam_remove:
 	caam_remove(pdev);
 	return ret;
-
-shutdown_qi:
-#ifdef CONFIG_CAAM_QI
-	if (ctrlpriv->qi_init)
-		caam_qi_shutdown(dev);
-#endif
-	return ret;
 }
 
 static struct platform_driver caam_driver = {
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index 359eb76d1259..c7c10c90464b 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -81,9 +81,6 @@ struct caam_drv_private {
 	 */
 	u8 total_jobrs;		/* Total Job Rings in device */
 	u8 qi_present;		/* Nonzero if QI present in device */
-#ifdef CONFIG_CAAM_QI
-	u8 qi_init;		/* Nonzero if QI has been initialized */
-#endif
 	u8 mc_en;		/* Nonzero if MC f/w is active */
 	int secvio_irq;		/* Security violation interrupt number */
 	int virt_en;		/* Virtualization enabled in CAAM */
diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c
index 378f627e1d64..dacf2fa4aa8e 100644
--- a/drivers/crypto/caam/qi.c
+++ b/drivers/crypto/caam/qi.c
@@ -500,9 +500,10 @@ void caam_drv_ctx_rel(struct caam_drv_ctx *drv_ctx)
 }
 EXPORT_SYMBOL(caam_drv_ctx_rel);
 
-void caam_qi_shutdown(struct device *qidev)
+static void caam_qi_shutdown(void *data)
 {
 	int i;
+	struct device *qidev = data;
 	struct caam_qi_priv *priv = &qipriv;
 	const cpumask_t *cpus = qman_affine_cpus();
 
@@ -761,7 +762,10 @@ int caam_qi_init(struct platform_device *caam_pdev)
 			    &times_congested, &caam_fops_u64_ro);
 #endif
 
-	ctrlpriv->qi_init = 1;
+	err = devm_add_action_or_reset(qidev, caam_qi_shutdown, ctrlpriv);
+	if (err)
+		return err;
+
 	dev_info(qidev, "Linux CAAM Queue I/F driver initialised\n");
 	return 0;
 }
diff --git a/drivers/crypto/caam/qi.h b/drivers/crypto/caam/qi.h
index db0549549e3b..848958951f68 100644
--- a/drivers/crypto/caam/qi.h
+++ b/drivers/crypto/caam/qi.h
@@ -147,7 +147,6 @@ int caam_drv_ctx_update(struct caam_drv_ctx *drv_ctx, u32 *sh_desc);
 void caam_drv_ctx_rel(struct caam_drv_ctx *drv_ctx);
 
 int caam_qi_init(struct platform_device *pdev);
-void caam_qi_shutdown(struct device *dev);
 
 /**
  * qi_cache_alloc - Allocate buffers from CAAM-QI cache
-- 
2.21.0

