Return-Path: <SRS0=4UkV=XO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92302C4CEC4
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Sep 2019 05:10:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B21A21927
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Sep 2019 05:10:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TK1Jg2tr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732002AbfISFKn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Sep 2019 01:10:43 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54743 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732000AbfISFKm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Sep 2019 01:10:42 -0400
Received: by mail-wm1-f67.google.com with SMTP id p7so2623765wmp.4;
        Wed, 18 Sep 2019 22:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Hi1ifQQR9gpdPmRZ1GOZNnhiHESsDUToV+uCj5M5hAM=;
        b=TK1Jg2trmgQTscppX/zra/WBdWr0pzqo34rey/+Un83KLSAoVGfAq2QgYlWpdRdmHD
         vi6lDlaLbbdWIh7dBg/1Grq/SD+FPunqfubr/NG/tNKGGuHfUW/onB+zS5IRjMzKJAJv
         iNenFOljXnWu+C7H6iB9pJUqUFnupc4XfEx343e7IPQc0ExRVqoETwI0S8E8/6x7/o3L
         QreXpoXj4i9UNrUI4rTpnrisDtFc19+Wc5IpEx20CNsdb6RYyZ9FZFMzvWLvw+V8UV1p
         FGLW7wnAYSFg+VFLwJ6oD0GKkv8dhlsCFgLN/+Uo+uaViaUUJI0jWYys9G/1Uf6XqWyu
         9JjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hi1ifQQR9gpdPmRZ1GOZNnhiHESsDUToV+uCj5M5hAM=;
        b=loeHAs2+KngwxJI/YPdslb1MEZ7BnCXxmeejvkTllJ/fL2c6ioVJQRmTjLfDWilTaW
         QbdS1EKGj7hQynrV3zhriil6a6Sh/sUepqqROd/yHvk3cAHaS3W3Y0kueKMFjB5hsEyv
         6Xlo5Q0CUhQHsJQbq0W+0JiprVMrTwiq1GhvP9y1kNalGt5SMA2J84mGzBgvch+xiBDF
         Cgy8PbZkktbblzfPi5eigZJi1MYbW/LWMU15bqQ28USWf1KMaIjjn8NUyjIsxcPs2FFl
         8tMNymd/aH7955tCyCa1DBTnO+wZ8y2izBW+wlemEgLpKLu8p2WKwS6T22V4bJ4YC27B
         QZ/g==
X-Gm-Message-State: APjAAAXp3Zov0R2cTV/WJ/BTkvupyxj6e+Zz1qOPdLy+rH/QlSBqriJx
        MCbR9Ub7KJDyfwZiLFtjKfE=
X-Google-Smtp-Source: APXvYqyVk3y2OIdHpqJR/8P23/9jE0vBB3PdySaF0TSBma65hUbbJHUsJBsKuYeaK/xH8Bl4wuB6Bg==
X-Received: by 2002:a7b:cb8b:: with SMTP id m11mr1076276wmi.145.1568869840588;
        Wed, 18 Sep 2019 22:10:40 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id 94sm6575552wrk.92.2019.09.18.22.10.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 22:10:40 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 1/2] crypto: sun4i-ss: simplify enable/disable of the device
Date:   Thu, 19 Sep 2019 07:10:34 +0200
Message-Id: <20190919051035.4111-2-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190919051035.4111-1-clabbe.montjoie@gmail.com>
References: <20190919051035.4111-1-clabbe.montjoie@gmail.com>
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
Acked-by: Maxime Ripard <mripard@kernel.org>
---
 drivers/crypto/sunxi-ss/sun4i-ss-core.c | 77 +++++++++++++++----------
 1 file changed, 46 insertions(+), 31 deletions(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-core.c b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
index 9aa6fe081a27..6c2db5d83b06 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-core.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-core.c
@@ -223,6 +223,45 @@ static struct sun4i_ss_alg_template ss_algs[] = {
 #endif
 };
 
+static void sun4i_ss_disable(struct sun4i_ss_ctx *ss)
+{
+	if (ss->reset)
+		reset_control_assert(ss->reset);
+
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
+
+	err = clk_prepare_enable(ss->ssclk);
+	if (err) {
+		dev_err(ss->dev, "Cannot prepare_enable ssclk\n");
+		goto err_enable;
+	}
+
+	if (ss->reset) {
+		err = reset_control_deassert(ss->reset);
+		if (err) {
+			dev_err(ss->dev, "Cannot deassert reset control\n");
+			goto err_enable;
+		}
+	}
+
+	return err;
+err_enable:
+	sun4i_ss_disable(ss);
+	return err;
+}
+
 static int sun4i_ss_probe(struct platform_device *pdev)
 {
 	u32 v;
@@ -269,17 +308,9 @@ static int sun4i_ss_probe(struct platform_device *pdev)
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
@@ -288,16 +319,7 @@ static int sun4i_ss_probe(struct platform_device *pdev)
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
@@ -387,12 +409,8 @@ static int sun4i_ss_probe(struct platform_device *pdev)
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
 
@@ -416,10 +434,7 @@ static int sun4i_ss_remove(struct platform_device *pdev)
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

