Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 481B9C433FF
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 18:20:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16D342089E
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 18:20:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="FXvvR/2y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbfG3SQE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 14:16:04 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35377 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728581AbfG3SQD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 14:16:03 -0400
Received: by mail-pg1-f194.google.com with SMTP id s1so24174456pgr.2
        for <linux-crypto@vger.kernel.org>; Tue, 30 Jul 2019 11:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fZ2yGRGixrVq89SE/3sUKGnRTFmWEruiAwAYLTHr6iY=;
        b=FXvvR/2yf25eczobuvXsgNunlgZNY0w3KhFqp/peC1Vfp8XTZDqlFWrAX8IcwcOHaP
         g/U3o0f467WY9KTNoTrBopxtNFpKP9Ppy1yxmOUhRURRAfQdzNJBbh13/H+MWokPkdY0
         MsSaYfCKcwFJ5ppHmd2/BC6UTnye7AmtQfA7s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fZ2yGRGixrVq89SE/3sUKGnRTFmWEruiAwAYLTHr6iY=;
        b=XBrYHl0/wd88tY8vIKpiNXv0PBnlMO+Sy6PGVKhQf1unSaIBjHLdJAiQWSSF3F6k3G
         CpVPoJchdfeBZIRoRB7S4kvWyIOLkqd1xlEhhxVtq4GSR9fjMsv5pMm0pUpPj1Xv89/b
         7MdjiDZvrb96N141Lg1cR3zbS0z9fHw2VV8OM/pDCbQLI9XaNlhhKc9ch1nTgIfy4P01
         qArtm2jSSF3SEjJ7pkaLAunyMkOTsqR64m6DwqJxiHIqcoilMji2z8P4WdwF5IMFxofi
         ITyLyDmLyluovKjq4WrksXAkOhvO5xyRjJWYpi7bqLl3NQMufy7Ytnag0Dhws2OA3oXa
         D/gg==
X-Gm-Message-State: APjAAAVmvUJmV5wR59bVxSCh2uvGYybvpFwgZIZUNQ3iAX1xNLdqcboo
        YmyGgPpz9zxxm5SntosG6NeDlw==
X-Google-Smtp-Source: APXvYqyiiAzX8h4LCwCDfWYOHM9e437/81BC/cMc60TLDu9DxFcuvWiVPFE3ffhnCZnbhnBdgGJrvQ==
X-Received: by 2002:aa7:8383:: with SMTP id u3mr43265233pfm.175.1564510563046;
        Tue, 30 Jul 2019 11:16:03 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:1:fa53:7765:582b:82b9])
        by smtp.gmail.com with ESMTPSA id g1sm106744083pgg.27.2019.07.30.11.16.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 11:16:02 -0700 (PDT)
From:   Stephen Boyd <swboyd@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v6 05/57] crypto: Remove dev_err() usage after platform_get_irq()
Date:   Tue, 30 Jul 2019 11:15:05 -0700
Message-Id: <20190730181557.90391-6-swboyd@chromium.org>
X-Mailer: git-send-email 2.22.0.709.g102302147b-goog
In-Reply-To: <20190730181557.90391-1-swboyd@chromium.org>
References: <20190730181557.90391-1-swboyd@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

We don't need dev_err() messages when platform_get_irq() fails now that
platform_get_irq() prints an error message itself when something goes
wrong. Let's remove these prints with a simple semantic patch.

// <smpl>
@@
expression ret;
struct platform_device *E;
@@

ret =
(
platform_get_irq(E, ...)
|
platform_get_irq_byname(E, ...)
);

if ( \( ret < 0 \| ret <= 0 \) )
{
(
-if (ret != -EPROBE_DEFER)
-{ ...
-dev_err(...);
-... }
|
...
-dev_err(...);
)
...
}
// </smpl>

While we're here, remove braces on if statements that only have one
statement (manually).

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: <linux-crypto@vger.kernel.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---

Please apply directly to subsystem trees

 drivers/crypto/atmel-aes.c             | 1 -
 drivers/crypto/atmel-sha.c             | 1 -
 drivers/crypto/atmel-tdes.c            | 1 -
 drivers/crypto/ccree/cc_driver.c       | 4 +---
 drivers/crypto/img-hash.c              | 1 -
 drivers/crypto/mediatek/mtk-platform.c | 4 +---
 drivers/crypto/mxs-dcp.c               | 8 ++------
 drivers/crypto/omap-aes.c              | 1 -
 drivers/crypto/omap-des.c              | 1 -
 drivers/crypto/omap-sham.c             | 1 -
 drivers/crypto/sahara.c                | 4 +---
 drivers/crypto/stm32/stm32-cryp.c      | 4 +---
 drivers/crypto/stm32/stm32-hash.c      | 4 +---
 13 files changed, 7 insertions(+), 28 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 2b7af44c7b85..026f193556f9 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -2673,7 +2673,6 @@ static int atmel_aes_probe(struct platform_device *pdev)
 	/* Get the IRQ */
 	aes_dd->irq = platform_get_irq(pdev,  0);
 	if (aes_dd->irq < 0) {
-		dev_err(dev, "no IRQ resource info\n");
 		err = aes_dd->irq;
 		goto res_err;
 	}
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index ab0cfe748931..84cb8748a795 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -2779,7 +2779,6 @@ static int atmel_sha_probe(struct platform_device *pdev)
 	/* Get the IRQ */
 	sha_dd->irq = platform_get_irq(pdev,  0);
 	if (sha_dd->irq < 0) {
-		dev_err(dev, "no IRQ resource info\n");
 		err = sha_dd->irq;
 		goto res_err;
 	}
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index fa76620281e8..6256883a89ed 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -1281,7 +1281,6 @@ static int atmel_tdes_probe(struct platform_device *pdev)
 	/* Get the IRQ */
 	tdes_dd->irq = platform_get_irq(pdev,  0);
 	if (tdes_dd->irq < 0) {
-		dev_err(dev, "no IRQ resource info\n");
 		err = tdes_dd->irq;
 		goto res_err;
 	}
diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index 980aa04b655b..d611cfe6e8e5 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -339,10 +339,8 @@ static int init_cc_resources(struct platform_device *plat_dev)
 
 	/* Then IRQ */
 	new_drvdata->irq = platform_get_irq(plat_dev, 0);
-	if (new_drvdata->irq < 0) {
-		dev_err(dev, "Failed getting IRQ resource\n");
+	if (new_drvdata->irq < 0)
 		return new_drvdata->irq;
-	}
 
 	init_completion(&new_drvdata->hw_queue_avail);
 
diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index d27c812c3d8d..6754eaafdc85 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -980,7 +980,6 @@ static int img_hash_probe(struct platform_device *pdev)
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
-		dev_err(dev, "no IRQ resource info\n");
 		err = irq;
 		goto res_err;
 	}
diff --git a/drivers/crypto/mediatek/mtk-platform.c b/drivers/crypto/mediatek/mtk-platform.c
index 125318a88cd4..4f43318ca14b 100644
--- a/drivers/crypto/mediatek/mtk-platform.c
+++ b/drivers/crypto/mediatek/mtk-platform.c
@@ -495,10 +495,8 @@ static int mtk_crypto_probe(struct platform_device *pdev)
 
 	for (i = 0; i < MTK_IRQ_NUM; i++) {
 		cryp->irq[i] = platform_get_irq(pdev, i);
-		if (cryp->irq[i] < 0) {
-			dev_err(cryp->dev, "no IRQ:%d resource info\n", i);
+		if (cryp->irq[i] < 0)
 			return cryp->irq[i];
-		}
 	}
 
 	cryp->clk_cryp = devm_clk_get(&pdev->dev, "cryp");
diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index f1fa637cb029..bf8d2197bc11 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -994,16 +994,12 @@ static int mxs_dcp_probe(struct platform_device *pdev)
 	}
 
 	dcp_vmi_irq = platform_get_irq(pdev, 0);
-	if (dcp_vmi_irq < 0) {
-		dev_err(dev, "Failed to get IRQ: (%d)!\n", dcp_vmi_irq);
+	if (dcp_vmi_irq < 0)
 		return dcp_vmi_irq;
-	}
 
 	dcp_irq = platform_get_irq(pdev, 1);
-	if (dcp_irq < 0) {
-		dev_err(dev, "Failed to get IRQ: (%d)!\n", dcp_irq);
+	if (dcp_irq < 0)
 		return dcp_irq;
-	}
 
 	sdcp = devm_kzalloc(dev, sizeof(*sdcp), GFP_KERNEL);
 	if (!sdcp)
diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 45a4647f7030..2f53fbb74100 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -1180,7 +1180,6 @@ static int omap_aes_probe(struct platform_device *pdev)
 
 		irq = platform_get_irq(pdev, 0);
 		if (irq < 0) {
-			dev_err(dev, "can't get IRQ resource\n");
 			err = irq;
 			goto err_irq;
 		}
diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 1ee69a979677..484a693122af 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -1049,7 +1049,6 @@ static int omap_des_probe(struct platform_device *pdev)
 
 		irq = platform_get_irq(pdev, 0);
 		if (irq < 0) {
-			dev_err(dev, "can't get IRQ resource: %d\n", irq);
 			err = irq;
 			goto err_irq;
 		}
diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index e8e2907bd9f4..ac80bc6af093 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1989,7 +1989,6 @@ static int omap_sham_get_res_pdev(struct omap_sham_dev *dd,
 	/* Get the IRQ */
 	dd->irq = platform_get_irq(pdev, 0);
 	if (dd->irq < 0) {
-		dev_err(dev, "no IRQ resource info\n");
 		err = dd->irq;
 		goto err;
 	}
diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index b0b8e3d48aef..8ac8ec6decd5 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1403,10 +1403,8 @@ static int sahara_probe(struct platform_device *pdev)
 
 	/* Get the IRQ */
 	irq = platform_get_irq(pdev,  0);
-	if (irq < 0) {
-		dev_err(&pdev->dev, "failed to get irq resource\n");
+	if (irq < 0)
 		return irq;
-	}
 
 	err = devm_request_irq(&pdev->dev, irq, sahara_irq_handler,
 			       0, dev_name(&pdev->dev), dev);
diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 98ae02826e8f..72f86063b046 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -1975,10 +1975,8 @@ static int stm32_cryp_probe(struct platform_device *pdev)
 		return PTR_ERR(cryp->regs);
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq < 0) {
-		dev_err(dev, "Cannot get IRQ resource\n");
+	if (irq < 0)
 		return irq;
-	}
 
 	ret = devm_request_threaded_irq(dev, irq, stm32_cryp_irq,
 					stm32_cryp_irq_thread, IRQF_ONESHOT,
diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index 2b70d8796f25..cfc8e0e37bee 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -1450,10 +1450,8 @@ static int stm32_hash_probe(struct platform_device *pdev)
 		return ret;
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq < 0) {
-		dev_err(dev, "Cannot get IRQ resource\n");
+	if (irq < 0)
 		return irq;
-	}
 
 	ret = devm_request_threaded_irq(dev, irq, stm32_hash_irq_handler,
 					stm32_hash_irq_thread, IRQF_ONESHOT,
-- 
Sent by a computer through tubes

