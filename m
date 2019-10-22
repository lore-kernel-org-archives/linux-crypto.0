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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA68BCA9EA0
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 15:30:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B085A2084B
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 15:30:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="twr9OH5r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732346AbfJVPam (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Oct 2019 11:30:42 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35713 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732338AbfJVPad (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Oct 2019 11:30:33 -0400
Received: by mail-pf1-f196.google.com with SMTP id 205so10875478pfw.2;
        Tue, 22 Oct 2019 08:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a7lQln2Sn3ga5wzLGGjdEAkfx3q9Gt4gdmnzplHbZZI=;
        b=twr9OH5rmelYAVJxvbLwuEbfW7DorGSn1XUE/WWgYTM5Pz5/NUhgfjcEwsWe/gi5ap
         7vzQLwHjKRMT2EnqrEKzYZSRFJdYUeq0wG9rYBF94015ItMyZE5mQDeyHblitcnae1a4
         8K6ABiYyV/D4PPVTm8WoQNiCXTHaMNv6Tt3swJN/m42fLW8GbLElQUiO2zQXPeAfIHy2
         e7Q2jQycF0btkTzK4W6npQT2gnzyGxUPjVwhr0RgB7N+38e6eugyK0I3vns7oJkOb8G0
         SY0VrmGVXmH7kpwKus7qdNWqY0U62XZUpWIgfMmNruNQFTv+g6eeHSwanMxCBNzPPUa1
         rK5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a7lQln2Sn3ga5wzLGGjdEAkfx3q9Gt4gdmnzplHbZZI=;
        b=V4oCbHcBp1ylHFvWWvxkL6x7FQwnLQX3mQEXzmrE3sV/kP6w0bzvdntnzeLiuL8WpR
         B9oy+WSy5LkEuQxqsQenn6KkanKgSDK4QO/iKKUVYxpMmHjEkHQ09wNWaOgINRyy26F/
         K2DfIIC2vjE2HqnYsDsj6gXDz9eGB5FFa8HiK8s1D7/r35K/z6/IS+6flyebiP3NpTSK
         5hSzokDAORx5CbnPT421JLOrPW8ZFjDrorAv0yHTcC4ZcVNADZpslQI08VNaDW51v0+x
         k/HOtf7nWnxNXLhXdpQB767NTfPt3BzUEbtGglVus0btPIArny4lwjUSgDWGwJ55RfOq
         YiUQ==
X-Gm-Message-State: APjAAAVc5sW9SyhHvIJK5tsX4Q090WxhVG71OFPwD/tVb38p3hyIu7ot
        VvJqSj8YDXD83cq6cw/KptXhAGbC
X-Google-Smtp-Source: APXvYqwNIRFnMtl/3wnDddhjlXRdWZN+1lbNhvkSKUI0M2LaKl6WJKoCqZOiWVk1vLi1BJS85PoAyQ==
X-Received: by 2002:a65:504b:: with SMTP id k11mr4451139pgo.13.1571758232064;
        Tue, 22 Oct 2019 08:30:32 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id z63sm6066128pgb.75.2019.10.22.08.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 08:30:30 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/6] crypto: caam - use devres to populate platform devices
Date:   Tue, 22 Oct 2019 08:30:12 -0700
Message-Id: <20191022153013.3692-6-andrew.smirnov@gmail.com>
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

Use devres to de-initialize the RNG and drop explicit de-initialization
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
 drivers/crypto/caam/ctrl.c | 26 +++-----------------------
 1 file changed, 3 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 7cdb48c7e28e..0540df59ed8a 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -321,20 +321,6 @@ static int instantiate_rng(struct device *ctrldev, int state_handle_mask,
 	return ret;
 }
 
-static int caam_remove(struct platform_device *pdev)
-{
-	struct device *ctrldev;
-	struct caam_drv_private *ctrlpriv;
-
-	ctrldev = &pdev->dev;
-	ctrlpriv = dev_get_drvdata(ctrldev);
-
-	/* Remove platform devices under the crypto node */
-	of_platform_depopulate(ctrldev);
-
-	return 0;
-}
-
 /*
  * kick_trng - sets the various parameters for enabling the initialization
  *	       of the RNG4 block in CAAM
@@ -761,7 +747,7 @@ static int caam_probe(struct platform_device *pdev)
 #endif
 	}
 
-	ret = of_platform_populate(nprop, caam_match, NULL, dev);
+	ret = devm_of_platform_populate(dev);
 	if (ret) {
 		dev_err(dev, "JR platform devices creation error\n");
 		return ret;
@@ -783,8 +769,7 @@ static int caam_probe(struct platform_device *pdev)
 	/* If no QI and no rings specified, quit and go home */
 	if ((!ctrlpriv->qi_present) && (!ctrlpriv->total_jobrs)) {
 		dev_err(dev, "no queues configured, terminating\n");
-		ret = -ENOMEM;
-		goto caam_remove;
+		return -ENOMEM;
 	}
 
 	if (ctrlpriv->era < 10)
@@ -847,7 +832,7 @@ static int caam_probe(struct platform_device *pdev)
 		} while ((ret == -EAGAIN) && (ent_delay < RTSDCTL_ENT_DLY_MAX));
 		if (ret) {
 			dev_err(dev, "failed to instantiate RNG");
-			goto caam_remove;
+			return ret;
 		}
 		/*
 		 * Set handles init'ed by this module as the complement of the
@@ -921,10 +906,6 @@ static int caam_probe(struct platform_device *pdev)
 			    &ctrlpriv->ctl_tdsk_wrap);
 #endif
 	return 0;
-
-caam_remove:
-	caam_remove(pdev);
-	return ret;
 }
 
 static struct platform_driver caam_driver = {
@@ -933,7 +914,6 @@ static struct platform_driver caam_driver = {
 		.of_match_table = caam_match,
 	},
 	.probe       = caam_probe,
-	.remove      = caam_remove,
 };
 
 module_platform_driver(caam_driver);
-- 
2.21.0

