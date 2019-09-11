Return-Path: <SRS0=VsuX=XG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E40CC5ACAE
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 11:47:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A2B620872
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 11:47:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q1jZcqmW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbfIKLq7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Sep 2019 07:46:59 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37553 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbfIKLq6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Sep 2019 07:46:58 -0400
Received: by mail-wm1-f65.google.com with SMTP id r195so3165012wme.2;
        Wed, 11 Sep 2019 04:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XLyQ3Vlb+rG+95957y6BztxIW1tdl5LgP7WaxmxVaO0=;
        b=Q1jZcqmWsHMzgEghiccCanRSPHWlytaT/p73rkABDBpEVrVIdPyhVBsQRa83y7yMwk
         8vVGvx30GcYDujSlS3VxDH5ZmkqUbcKICCbkOmPADFguytXS59u9yHhwAmSl5fDbd5YY
         X2li4ZcxeJjFi6+DJyrRPSgpSsMU6SySDL60WMIS2gWFtEQie2Vnug5trHsGrDV8qLF0
         ihFNv9p5QnRps0Xm7D//Dig9Y6f1hok8zIrdddu9wOkudYYpIYdHUh3+fyEJ465lg6Dw
         wB7tnkq37MYs03eZ/B6bTZslAceoKcWexuBT6RYVxRTcq3GAL2lZ4E8CWlwiiMHhwBp2
         Iruw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XLyQ3Vlb+rG+95957y6BztxIW1tdl5LgP7WaxmxVaO0=;
        b=VnAop/hBEewJpXGs5+PMwBPpSRqXpcgZoNj8g9bsmw77TOOiZVFepLH+8t9Vai7iR0
         oqej2wY29ebvuEG+5OxQeekWQkBMhxGdnSrxLcNkSFPwLZUvMpdQt9yURCtghlAiWM9v
         gHMVKhQGktAGPTF4fgxw8zBaMc0hBEM11jiTDXiUs38GgwtKcLZo9NvAyTPmveYiUgGp
         McuH6K4PuA3W1FhExLuVkzq/W5Gh88YBnG+1dFoJkdAu1HjKZVEHqIX+iK6PkODAg+e0
         IDBHlBsqYqz1mMcDTwvYH2Bc3fF7xCMl7yn5Jr+lh5406LCyJOrIhM8BjSClTGtHcrXq
         eLkw==
X-Gm-Message-State: APjAAAW6+FT7nunW7xA6QkCgqdM93iHWMGYPGsktd0sCYckRZNIBulrz
        RftsyXTyAH5YWT15GpXcc18=
X-Google-Smtp-Source: APXvYqw/b7RlrRsnWT6dq2slgxmNWcb7VI6HItkHhXi+DVQQc12hADdcTu7V5ysU+9FcYNW/Ovxx5g==
X-Received: by 2002:a1c:f518:: with SMTP id t24mr3443917wmh.98.1568202416288;
        Wed, 11 Sep 2019 04:46:56 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id h17sm4864705wme.6.2019.09.11.04.46.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 04:46:55 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 2/2] crypto: sun4i-ss: enable pm_runtime
Date:   Wed, 11 Sep 2019 13:46:50 +0200
Message-Id: <20190911114650.20567-3-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190911114650.20567-1-clabbe.montjoie@gmail.com>
References: <20190911114650.20567-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch enables power management on the Security System.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c |  5 +++
 drivers/crypto/sunxi-ss/sun4i-ss-core.c   | 42 ++++++++++++++++++++++-
 2 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
index fa4b1b47822e..1fedec9e83b0 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
@@ -10,6 +10,8 @@
  *
  * You could find the datasheet in Documentation/arm/sunxi.rst
  */
+
+#include <linux/pm_runtime.h>
 #include "sun4i-ss.h"
 
 static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
@@ -497,13 +499,16 @@ int sun4i_ss_cipher_init(struct crypto_tfm *tfm)
 		return PTR_ERR(op->fallback_tfm);
 	}
 
+	pm_runtime_get_sync(op->ss->dev);
 	return 0;
 }
 
 void sun4i_ss_cipher_exit(struct crypto_tfm *tfm)
 {
 	struct sun4i_tfm_ctx *op = crypto_tfm_ctx(tfm);
+
 	crypto_free_sync_skcipher(op->fallback_tfm);
+	pm_runtime_put_sync(op->ss->dev);
 }
 
 /* check and set the AES key, prepare the mode to be used */
diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-core.c b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
index 2c9ff01dddfc..5e6e1a308f60 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-core.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <crypto/scatterwalk.h>
 #include <linux/scatterlist.h>
 #include <linux/interrupt.h>
@@ -258,6 +259,37 @@ static int sun4i_ss_enable(struct sun4i_ss_ctx *ss)
 	return err;
 }
 
+#ifdef CONFIG_PM
+static int sun4i_ss_pm_suspend(struct device *dev)
+{
+	struct sun4i_ss_ctx *ss = dev_get_drvdata(dev);
+
+	sun4i_ss_disable(ss);
+	return 0;
+}
+
+static int sun4i_ss_pm_resume(struct device *dev)
+{
+	struct sun4i_ss_ctx *ss = dev_get_drvdata(dev);
+
+	return sun4i_ss_enable(ss);
+}
+#endif
+
+const struct dev_pm_ops sun4i_ss_pm_ops = {
+	SET_RUNTIME_PM_OPS(sun4i_ss_pm_suspend, sun4i_ss_pm_resume, NULL)
+};
+
+static void sun4i_ss_pm_init(struct sun4i_ss_ctx *ss)
+{
+	pm_runtime_use_autosuspend(ss->dev);
+	pm_runtime_set_autosuspend_delay(ss->dev, 1000);
+
+	pm_runtime_get_noresume(ss->dev);
+	pm_runtime_set_active(ss->dev);
+	pm_runtime_enable(ss->dev);
+}
+
 static int sun4i_ss_probe(struct platform_device *pdev)
 {
 	u32 v;
@@ -357,9 +389,12 @@ static int sun4i_ss_probe(struct platform_device *pdev)
 	writel(0, ss->base + SS_CTL);
 
 	ss->dev = &pdev->dev;
+	platform_set_drvdata(pdev, ss);
 
 	spin_lock_init(&ss->slock);
 
+	sun4i_ss_pm_init(ss);
+
 	for (i = 0; i < ARRAY_SIZE(ss_algs); i++) {
 		ss_algs[i].ss = ss;
 		switch (ss_algs[i].type) {
@@ -388,7 +423,8 @@ static int sun4i_ss_probe(struct platform_device *pdev)
 			break;
 		}
 	}
-	platform_set_drvdata(pdev, ss);
+
+	pm_runtime_put_sync(ss->dev);
 	return 0;
 error_alg:
 	i--;
@@ -405,6 +441,7 @@ static int sun4i_ss_probe(struct platform_device *pdev)
 			break;
 		}
 	}
+	pm_runtime_disable(ss->dev);
 error_enable:
 	sun4i_ss_disable(ss);
 	return err;
@@ -429,6 +466,8 @@ static int sun4i_ss_remove(struct platform_device *pdev)
 		}
 	}
 
+	pm_runtime_disable(ss->dev);
+
 	writel(0, ss->base + SS_CTL);
 	sun4i_ss_disable(ss);
 	return 0;
@@ -445,6 +484,7 @@ static struct platform_driver sun4i_ss_driver = {
 	.remove         = sun4i_ss_remove,
 	.driver         = {
 		.name           = "sun4i-ss",
+		.pm		= &sun4i_ss_pm_ops,
 		.of_match_table	= a20ss_crypto_of_match_table,
 	},
 };
-- 
2.21.0

