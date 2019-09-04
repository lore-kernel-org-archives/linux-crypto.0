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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57CB5C3A5A2
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 02:36:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3394B22CF5
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 02:36:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SkqR950j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728509AbfIDCgN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 22:36:13 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:32928 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728053AbfIDCfk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 22:35:40 -0400
Received: by mail-pg1-f196.google.com with SMTP id n190so10349497pgn.0;
        Tue, 03 Sep 2019 19:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=79mGtzg2avauSIHeamJMGyddX51QEzlIz9816hhBdak=;
        b=SkqR950jwmIP+2IMd8TQ9ltEgBMi8oFi45w0W5YFwEN5Q86jZzTFq/ZH5DTJPMB6zT
         c0GVw/QE2hRHRx/Ug2ijGoJgFbrKUYNF+cmAQ+P/RghkJE7ckGBvpzp6iEp2E8Bi4ak1
         EDbmkBW/u48ck7J54B0YyZYRlHPKrxTggmLuRSzCTXdFnfgqWeipKQuQ9jtYGFRNhfDg
         rCljJJQSqWtGDJeFdQTHV2JHjp5GIMIxBDNIQ+QYPjaBITtY6EL9UJhsyq/LzUk2aBlX
         oZJt6ALN1slq9F/FfPpBx9BjwUSyiJ8mjxROidVt5Fk9EIs8B3Ff3h/gGfvF+2KSErMG
         jX3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=79mGtzg2avauSIHeamJMGyddX51QEzlIz9816hhBdak=;
        b=El3J2100WyYboyW1Ahu716L5gk72Fj3F4nktAXzBLxUDMVJjMfKE81TfxdYSxRfrNd
         ESz95obtn0FYzQ/zy0Slp4u5TY48v79yBWDKxPKnLov6CkfkhuL9xCxQd5trWVgbQWdI
         nNZdSZPM4AFtKV7ojLYhJSMd8whwhrW+Pt2meHpxK8HimuwIdHMO3tNjdnveAdHXV2DA
         +vc4YCyP1VmlFqkHhNxm3YOTxpuswjGqYAtbpmhbCa/zmvu4w2LAgebEqYlDy+uVl161
         gu1cS8er4QE+tl5ajcJL5X9m2Oq4uwBYgl9CbJMSETCrNvi8Iy6SLhxNsf9kzcrfRCQz
         OJ8A==
X-Gm-Message-State: APjAAAV3bvTooeDFauQiVbX5ju6jgwhwdd2H0fskeUa06DVLO8z38tEy
        qlIj9MXJG3k0fIvp5r43v8W4o2wbvWc=
X-Google-Smtp-Source: APXvYqwfycK82vB9x7SPDZkaPhMG1HPJrGE4mhyFXHoWcHHnUDragJhVmo/COyQ1VhZ4qlfBIEw3iw==
X-Received: by 2002:a63:d04e:: with SMTP id s14mr31489424pgi.189.1567564539509;
        Tue, 03 Sep 2019 19:35:39 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id i74sm7480250pfe.28.2019.09.03.19.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 19:35:38 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/12] crypto: caam - use devres to remove debugfs
Date:   Tue,  3 Sep 2019 19:35:09 -0700
Message-Id: <20190904023515.7107-7-andrew.smirnov@gmail.com>
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

Use devres to remove debugfs and drop corresponding
debugfs_remove_recursive() call.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/caam/ctrl.c   | 21 ++++++++++++++-------
 drivers/crypto/caam/intern.h |  1 -
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 35bf82d1bedc..254963498abc 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -327,11 +327,6 @@ static int caam_remove(struct platform_device *pdev)
 	if (!ctrlpriv->mc_en && ctrlpriv->rng4_sh_init)
 		deinstantiate_rng(ctrldev, ctrlpriv->rng4_sh_init);
 
-	/* Shut down debug views */
-#ifdef CONFIG_DEBUG_FS
-	debugfs_remove_recursive(ctrlpriv->dfs_root);
-#endif
-
 	return 0;
 }
 
@@ -563,6 +558,13 @@ static int init_clocks(struct device *dev, const struct caam_imx_data *data)
 	return devm_add_action_or_reset(dev, disable_clocks, ctrlpriv);
 }
 
+#ifdef CONFIG_DEBUG_FS
+static void caam_remove_debugfs(void *root)
+{
+	debugfs_remove_recursive(root);
+}
+#endif
+
 /* Probe routine for CAAM top (controller) level */
 static int caam_probe(struct platform_device *pdev)
 {
@@ -575,6 +577,7 @@ static int caam_probe(struct platform_device *pdev)
 	struct caam_drv_private *ctrlpriv;
 #ifdef CONFIG_DEBUG_FS
 	struct caam_perfmon *perfmon;
+	struct dentry *dfs_root;
 #endif
 	u32 scfgr, comp_params;
 	u8 rng_vid;
@@ -728,8 +731,12 @@ static int caam_probe(struct platform_device *pdev)
 	 */
 	perfmon = (struct caam_perfmon __force *)&ctrl->perfmon;
 
-	ctrlpriv->dfs_root = debugfs_create_dir(dev_name(dev), NULL);
-	ctrlpriv->ctl = debugfs_create_dir("ctl", ctrlpriv->dfs_root);
+	dfs_root = debugfs_create_dir(dev_name(dev), NULL);
+	ret = devm_add_action_or_reset(dev, caam_remove_debugfs, dfs_root);
+	if (ret)
+		return ret;
+
+	ctrlpriv->ctl = debugfs_create_dir("ctl", dfs_root);
 #endif
 
 	/* Check to see if (DPAA 1.x) QI present. If so, enable */
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index 731b06becd9c..359eb76d1259 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -102,7 +102,6 @@ struct caam_drv_private {
 	 * variables at runtime.
 	 */
 #ifdef CONFIG_DEBUG_FS
-	struct dentry *dfs_root;
 	struct dentry *ctl; /* controller dir */
 	struct debugfs_blob_wrapper ctl_kek_wrap, ctl_tkek_wrap, ctl_tdsk_wrap;
 #endif
-- 
2.21.0

