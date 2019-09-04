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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCE25C3A5A7
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 02:36:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B60CD22CF8
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 02:36:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aKwsNpRy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbfIDCff (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 22:35:35 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45904 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727222AbfIDCfd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 22:35:33 -0400
Received: by mail-pg1-f195.google.com with SMTP id 4so6784367pgm.12;
        Tue, 03 Sep 2019 19:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/Vz3+FFcpK6JU84307Yag/Sm9BKHY7RRzc3BqadD5HQ=;
        b=aKwsNpRyh/V2OWW7e4hCWXCs0PB2rvQR5ufxCbysYv26uMecM6hOmgW6I5EIcFRwBU
         sEoAwPkhkru9Z+y7aZTarzJCJn9b9PxyPLnCI0Xknn5xvybgmn3Hsw4nYCS3f56lmX70
         6WNotQ57WjfveCHi0zqCHrjdFcMBg700cc/rzDKvTBNntDtTYjJCBHysIKb5dkG3oJPD
         k5LXIZx1OVeg7Wjvpg6ooeKPt040Q76njTMyZmJONQon67ww81S/GkRxgjoKsF+L1xPq
         HZB4meG2rJVO01Jv39J526ZgBbSQjBxFI9m6QGxw9VvbdaXizZGVSUuYjSfBZv7/BxNW
         f/XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/Vz3+FFcpK6JU84307Yag/Sm9BKHY7RRzc3BqadD5HQ=;
        b=UAlP/VimAyUDkSMAdjsJuoOH6j/yoIAh2qHpyDv218+I04YNdbm8O0Al8bdihK1v8v
         0VJkFfgE3ti8Yg7Ic7MJKI6Wc9wSIDM6VHFnqsWWUSYx1EnaO8f+HUsdzKDc7J5EUrJV
         IBLvkhOlbLII0bhoQ9jFe5/YuaY4fsj8WtHqRRUdlSdhpDqfN+2A9LVMrlxxrSeWN59V
         lEnh1o4DChAOOlNaUgst4lA6eeedjB5zbhXDiLs5LFMlWzHYCx1N7jfzWsyPuPl9htKw
         5KFdQGDEPyvW42e24WAgtVHTnA+/oxnYLs9X2z+j+G1cy/J91J8zWEfemHxE23oriT3c
         YVDA==
X-Gm-Message-State: APjAAAUdMq4VTd/zQse7QrHzOsec7h8ztdkNRcSiPlw0YFrGrJxJ1fre
        5/RjPlCgOnQoSZiahMlaYMQopBr7uQM=
X-Google-Smtp-Source: APXvYqxHYh3GCWa0AI1Ai2/9QvB01YG7eDooQPP9i1ZoxJRNQjuB6bjsvTas0nFhCn9yaCO95RqSpg==
X-Received: by 2002:a17:90a:19c4:: with SMTP id 4mr2635503pjj.20.1567564532375;
        Tue, 03 Sep 2019 19:35:32 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id i74sm7480250pfe.28.2019.09.03.19.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 19:35:31 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/12] crypto: caam - make sure clocks are enabled first
Date:   Tue,  3 Sep 2019 19:35:04 -0700
Message-Id: <20190904023515.7107-2-andrew.smirnov@gmail.com>
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

In order to access IP block's registers we need to enable appropriate
clocks first, otherwise we are risking hanging the CPU.

The problem becomes very apparent when trying to use CAAM driver built
as a kernel module. In that case caam_probe() gets called after
clk_disable_unused() which means all of the necessary clocks are
guaranteed to be disabled.

Coincidentally, this change also fixes iomap leak introduced by early
return (instead of "goto iounmap_ctrl") in commit
41fc54afae70 ("crypto: caam - simplfy clock initialization")

Tested on ZII i.MX6Q+ RDU2

Fixes: 176435ad2ac7 ("crypto: caam - defer probing until QMan is available")
Fixes: 41fc54afae70 ("crypto: caam - simplfy clock initialization")
Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/caam/ctrl.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 3c059d0e4207..db22777d59b4 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -594,6 +594,21 @@ static int caam_probe(struct platform_device *pdev)
 	dev_set_drvdata(dev, ctrlpriv);
 	nprop = pdev->dev.of_node;
 
+	imx_soc_match = soc_device_match(caam_imx_soc_table);
+	caam_imx = (bool)imx_soc_match;
+
+	if (imx_soc_match) {
+		if (!imx_soc_match->data) {
+			dev_err(dev, "No clock data provided for i.MX SoC");
+			return -EINVAL;
+		}
+
+		ret = init_clocks(dev, imx_soc_match->data);
+		if (ret)
+			return ret;
+	}
+
+
 	/* Get configuration properties from device tree */
 	/* First, get register page */
 	ctrl = of_iomap(nprop, 0);
@@ -604,9 +619,6 @@ static int caam_probe(struct platform_device *pdev)
 
 	caam_little_end = !(bool)(rd_reg32(&ctrl->perfmon.status) &
 				  (CSTA_PLEND | CSTA_ALT_PLEND));
-	imx_soc_match = soc_device_match(caam_imx_soc_table);
-	caam_imx = (bool)imx_soc_match;
-
 	comp_params = rd_reg32(&ctrl->perfmon.comp_parms_ms);
 	if (comp_params & CTPR_MS_PS && rd_reg32(&ctrl->mcr) & MCFGR_LONG_PTR)
 		caam_ptr_sz = sizeof(u64);
@@ -640,18 +652,6 @@ static int caam_probe(struct platform_device *pdev)
 	}
 #endif
 
-	if (imx_soc_match) {
-		if (!imx_soc_match->data) {
-			dev_err(dev, "No clock data provided for i.MX SoC");
-			return -EINVAL;
-		}
-
-		ret = init_clocks(dev, imx_soc_match->data);
-		if (ret)
-			return ret;
-	}
-
-
 	/* Allocating the BLOCK_OFFSET based on the supported page size on
 	 * the platform
 	 */
-- 
2.21.0

