Return-Path: <SRS0=VsUo=YP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99E35CA9EA0
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 15:30:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EBCC218AE
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 15:30:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="frkKSecJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732315AbfJVPa2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Oct 2019 11:30:28 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33013 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731847AbfJVPa2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Oct 2019 11:30:28 -0400
Received: by mail-pf1-f196.google.com with SMTP id c184so1355111pfb.0;
        Tue, 22 Oct 2019 08:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rT4GXJF7buPzYnqx1xUjqSmLFZuFPpQXbUzgyd/qzyo=;
        b=frkKSecJzMMV84FXEwhiPWVRa7fA/HBirX5Ee433R2NY5Tg7ukl7nuR26bEQ1QG724
         1UpWkQ2zqTUXih8UgaDEocX87XDJ9ggN25yMzsKMUapdO2c35l0W4s4RB7rd3bKEZBCu
         X99tDNj1m/ycQE8uOp6lPQalgSUVlfH/iSHE/IlCtr+T9ESzEshAttra9jhA4r/Qz2HD
         zLEmWqUCa+FDBXPHqK0Ro1TpUOD7VNvf5qUHnuByge+oWOlrCB6jwJuFZYsHrvNKeAbP
         upH39WW29kuzM3svDJMRHhknVK1BbBpAPDzQECwA0zj5Nsk6NWgZTxvSEaTfRHHA2A7p
         54mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rT4GXJF7buPzYnqx1xUjqSmLFZuFPpQXbUzgyd/qzyo=;
        b=S0UlGPykUhHszFCOc+wYeYZMFNjbLAMLiZkClFqV0p4jD8UbgGQ2xhkSbZs2T4tGYE
         K9jd85KrilYMJXU+idfr63SzJwrzPmCIiGp6UPRTYyGstNvwNs4YYiDGKaKsFnkUZJaB
         XFUWKalZkkzU4J+8JRyBkdtLh+uqEamfGDwJQtIHEJZfV4aAun4BeiOOPRkR1h3jUXQ4
         jFub4MKesrX7uO7dQFr4rGrYeXS4Buku/pIxhaYg9300qXAo8fxHbkWPpxLl4UxdbEbI
         wUfpZ6RGju/dI+tHSHEorKj72pUQy5awLys5jVxWVDijSDBJodQ4L9nFZPN5XtOJCmL/
         FlrA==
X-Gm-Message-State: APjAAAVJQEJaVfid+WwM6uFNrCca6owgIRlhGm/KnwOq464wqfCDZnmk
        7P/xt8J/hTkmOB6uuVR0mo1GeWxw
X-Google-Smtp-Source: APXvYqz2jivGMVgx/Ywafy07MpfqNt6nU536T1eaDqJlAEHikHNtbs9majer6J4WihD1cY5t/HRHMQ==
X-Received: by 2002:a63:a02:: with SMTP id 2mr4355409pgk.389.1571758227209;
        Tue, 22 Oct 2019 08:30:27 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id z63sm6066128pgb.75.2019.10.22.08.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 08:30:26 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/6] crypto: caam - use devres to remove debugfs
Date:   Tue, 22 Oct 2019 08:30:09 -0700
Message-Id: <20191022153013.3692-3-andrew.smirnov@gmail.com>
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

Use devres to remove debugfs and drop corresponding
debugfs_remove_recursive() call.

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

