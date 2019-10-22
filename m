Return-Path: <SRS0=VsUo=YP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8911ECA9EB9
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 15:30:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 602EC218AE
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 15:30:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FV/G6B86"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730720AbfJVPac (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Oct 2019 11:30:32 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43881 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732328AbfJVPac (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Oct 2019 11:30:32 -0400
Received: by mail-pl1-f196.google.com with SMTP id v5so3789554ply.10;
        Tue, 22 Oct 2019 08:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q8gWc5J/oCoXIx5BDQrMSebjO4yMPwjpyADtE3ynQqA=;
        b=FV/G6B86QblOcvwX8xLacb4A5cbeKWR7XsgcSLGLjZAteBvZD/0DL0QvNXmH9j3X5J
         KcVxC2u6xjiRFZtAG1KK787z8OhfUBttZddImowWDyFhx+/JFv4uZVjvnsgGuVp4mqGJ
         SUi9NGCHtAJz7Zo9cM4SAzBw+75cp+XUAkLEbhBXV1xEyqzjbI4vIu7FLOw0T6kcz2MG
         o/9WSGFwJSWsdVNoaj3SXFsLlj1rCMU4QcKJY6BPJSpKCvAcBmkwg3OksHbfN3Lo8Iut
         MydDm6CYHalYl2rXK73iiKHI/aVLHtgN+3xVmGRjduzp7p4Wctf3QoH4wrOTX+RPRsoX
         XS/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q8gWc5J/oCoXIx5BDQrMSebjO4yMPwjpyADtE3ynQqA=;
        b=h4u0goMzzS6/raPgUgWk2b2aToIIUIkOAfXjdQjmFYWkImQMY0jm7F4/aSspieBljp
         lP7af48d2GRShIk46ohOgETAWYOhTlHb7GD+WVhSJ6XJfB/2Ut1BKsqL3CakwrQ2zX2d
         uZCGwIk1og7dxBsyXozeqgI2aGQviWG1IurcdeacQ/ERmZJJ/tLsrkZm4hJScRuKhRvF
         VoxIBgyz7sgdqkiRFS//3v4q/TKtm0irO8gj3CX6zZkSWMvctVUNYfSdiNm3hqoQ3wu7
         mKeAJHZgD7wRuv3hFdy5VoHfNJJwZuY70WCnDmx2armi5nFixPhiNMXW2tnI/m9KmE+v
         GWnQ==
X-Gm-Message-State: APjAAAXODA1RcKqbl+kLqUl4s0ehMexxn4969XQ7WUf0lQZZWTWSZKow
        UW2l/DGI5vIyCLugroiL9/QF/wL+
X-Google-Smtp-Source: APXvYqzYnHFhxF0RHgswSV8/p/C/lR8uqfu8jZjkCrwMYVFhxfr1gz7ora3bFK9GRqDg+9i5LPi5Jg==
X-Received: by 2002:a17:902:fe0f:: with SMTP id g15mr1398239plj.224.1571758230500;
        Tue, 22 Oct 2019 08:30:30 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id z63sm6066128pgb.75.2019.10.22.08.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 08:30:29 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/6] crypto: caam - use devres to de-initialize QI
Date:   Tue, 22 Oct 2019 08:30:11 -0700
Message-Id: <20191022153013.3692-5-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191022153013.3692-1-andrew.smirnov@gmail.com>
References: <20191022153013.3692-1-andrew.smirnov@gmail.com>
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
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
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
index f8c75a999913..7cdb48c7e28e 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -332,11 +332,6 @@ static int caam_remove(struct platform_device *pdev)
 	/* Remove platform devices under the crypto node */
 	of_platform_depopulate(ctrldev);
 
-#ifdef CONFIG_CAAM_QI
-	if (ctrlpriv->qi_init)
-		caam_qi_shutdown(ctrldev);
-#endif
-
 	return 0;
 }
 
@@ -769,7 +764,7 @@ static int caam_probe(struct platform_device *pdev)
 	ret = of_platform_populate(nprop, caam_match, NULL, dev);
 	if (ret) {
 		dev_err(dev, "JR platform devices creation error\n");
-		goto shutdown_qi;
+		return ret;
 	}
 
 	ring = 0;
@@ -930,13 +925,6 @@ static int caam_probe(struct platform_device *pdev)
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

