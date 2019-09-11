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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08783C49ED6
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 11:47:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D396920CC7
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 11:47:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P4lbFX7i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727762AbfIKLq6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Sep 2019 07:46:58 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38838 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726696AbfIKLq5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Sep 2019 07:46:57 -0400
Received: by mail-wm1-f67.google.com with SMTP id o184so3146689wme.3;
        Wed, 11 Sep 2019 04:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JgPahXjzwJ1FlZOqme8sddUdHnTiNo6i0GnstFUSooI=;
        b=P4lbFX7igZ66ZuRooFnd4doxXIvDnTHfGnMDq6qWqE+hWs/lu7TnLfr+reaot9BhJU
         VBGMoQacwjjlo5pU6kByJ82mXJZyZBl8p26EG9NKA7lDmk0ez9s1s1FPHDxicBoE/Kv6
         GMhbuumfZUxwA1GI6DlKYeJjBfvLRmd3+rkT0Y8L1TmIVsq2TqhHj1HtLQMnVGCaaLNX
         ImY4UkOJECA2GWNfdfUcjW9A+ET5T5LK4196gAZzSFlN/9HMJZXCo0mWRMtl+r7cxhrg
         4zwlkvGBDCh3fcesptlSBusICqOaXCe0uf4pSBmxT1n9Wla8rSa6wG8QE1jcr0a2neNc
         1eFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JgPahXjzwJ1FlZOqme8sddUdHnTiNo6i0GnstFUSooI=;
        b=IiUQNgZHzvi9jyVW6+uowM0JOnIHWx2n0bVJ91cnBImSi9+vLNeTyC/w/cm8iaYwFJ
         6uh3swTFLAXylHljNO3z2IrHcAi9z8NQ6Y4r78ktPcK0dGPtOa54sfktCC9N/L9TniGU
         ihubQb1Tn54MtLAooDtt9vyfl+kpSd6/zvW9HLQ88G666JUuFCxeMzrvavF6I/UlpSWD
         EkzBGJl2AqY4X4l46lCDUnAZ+wnk5oxwmcrzPZj9LmCwr1IY/bHyWRHtNiM7SwR1g2jb
         +Y7UWPm9QZjKpe+L6wo6ZR4wHG8HQhu+/vmppDZrMYVAQNvqF/ocn1MBUjuVjVKsFuO0
         9Atw==
X-Gm-Message-State: APjAAAUvsu/5HJBlbnqVLGXyFuw/jlcQS/K/4H1nCCDllssG9tOjL8Fb
        DLueIe/U2PhJgGXW61edHdg=
X-Google-Smtp-Source: APXvYqyRRmmBfhyhIZqCKiLtoNymxUAz/1znvD3aUph9HKxmo1InEcfcN5xqR9cw52jqGqSoTHbiKw==
X-Received: by 2002:a1c:1d84:: with SMTP id d126mr3569473wmd.58.1568202415208;
        Wed, 11 Sep 2019 04:46:55 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id h17sm4864705wme.6.2019.09.11.04.46.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 04:46:54 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 1/2] crypto: sun4i-ss: simplify enable/disable of the device
Date:   Wed, 11 Sep 2019 13:46:49 +0200
Message-Id: <20190911114650.20567-2-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190911114650.20567-1-clabbe.montjoie@gmail.com>
References: <20190911114650.20567-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch regroups resource enabling/disabling in dedicated function.
This simplify error handling and will permit to support power
management.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/sunxi-ss/sun4i-ss-core.c | 73 ++++++++++++++-----------
 1 file changed, 42 insertions(+), 31 deletions(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-core.c b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
index 9aa6fe081a27..2c9ff01dddfc 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-core.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
@@ -223,6 +223,41 @@ static struct sun4i_ss_alg_template ss_algs[] = {
 #endif
 };
 
+static void sun4i_ss_disable(struct sun4i_ss_ctx *ss)
+{
+	if (ss->reset)
+		reset_control_assert(ss->reset);
+	clk_disable_unprepare(ss->ssclk);
+	clk_disable_unprepare(ss->busclk);
+}
+
+static int sun4i_ss_enable(struct sun4i_ss_ctx *ss)
+{
+	int err;
+
+	err = clk_prepare_enable(ss->busclk);
+	if (err) {
+		dev_err(ss->dev, "Cannot prepare_enable busclk\n");
+		goto err_enable;
+	}
+	err = clk_prepare_enable(ss->ssclk);
+	if (err) {
+		dev_err(ss->dev, "Cannot prepare_enable ssclk\n");
+		goto err_enable;
+	}
+	if (ss->reset) {
+		err = reset_control_deassert(ss->reset);
+		if (err) {
+			dev_err(ss->dev, "Cannot deassert reset control\n");
+			goto err_enable;
+		}
+	}
+	return err;
+err_enable:
+	sun4i_ss_disable(ss);
+	return err;
+}
+
 static int sun4i_ss_probe(struct platform_device *pdev)
 {
 	u32 v;
@@ -269,17 +304,9 @@ static int sun4i_ss_probe(struct platform_device *pdev)
 		ss->reset = NULL;
 	}
 
-	/* Enable both clocks */
-	err = clk_prepare_enable(ss->busclk);
-	if (err) {
-		dev_err(&pdev->dev, "Cannot prepare_enable busclk\n");
-		return err;
-	}
-	err = clk_prepare_enable(ss->ssclk);
-	if (err) {
-		dev_err(&pdev->dev, "Cannot prepare_enable ssclk\n");
-		goto error_ssclk;
-	}
+	err = sun4i_ss_enable(ss);
+	if (err)
+		goto error_enable;
 
 	/*
 	 * Check that clock have the correct rates given in the datasheet
@@ -288,16 +315,7 @@ static int sun4i_ss_probe(struct platform_device *pdev)
 	err = clk_set_rate(ss->ssclk, cr_mod);
 	if (err) {
 		dev_err(&pdev->dev, "Cannot set clock rate to ssclk\n");
-		goto error_clk;
-	}
-
-	/* Deassert reset if we have a reset control */
-	if (ss->reset) {
-		err = reset_control_deassert(ss->reset);
-		if (err) {
-			dev_err(&pdev->dev, "Cannot deassert reset control\n");
-			goto error_clk;
-		}
+		goto error_enable;
 	}
 
 	/*
@@ -387,12 +405,8 @@ static int sun4i_ss_probe(struct platform_device *pdev)
 			break;
 		}
 	}
-	if (ss->reset)
-		reset_control_assert(ss->reset);
-error_clk:
-	clk_disable_unprepare(ss->ssclk);
-error_ssclk:
-	clk_disable_unprepare(ss->busclk);
+error_enable:
+	sun4i_ss_disable(ss);
 	return err;
 }
 
@@ -416,10 +430,7 @@ static int sun4i_ss_remove(struct platform_device *pdev)
 	}
 
 	writel(0, ss->base + SS_CTL);
-	if (ss->reset)
-		reset_control_assert(ss->reset);
-	clk_disable_unprepare(ss->busclk);
-	clk_disable_unprepare(ss->ssclk);
+	sun4i_ss_disable(ss);
 	return 0;
 }
 
-- 
2.21.0

