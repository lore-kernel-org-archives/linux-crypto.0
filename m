Return-Path: <SRS0=AJZI=ZP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90347C432C0
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Nov 2019 13:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F94320714
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Nov 2019 13:48:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dIO2eTXS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfKWNsj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 23 Nov 2019 08:48:39 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33050 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbfKWNsj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 23 Nov 2019 08:48:39 -0500
Received: by mail-pg1-f195.google.com with SMTP id 6so324401pgk.0;
        Sat, 23 Nov 2019 05:48:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Sno9U1PiqFvmo7XNuFb/fM3y1xecgkh8dRFnJhiyLZ8=;
        b=dIO2eTXSRfnJ5qBnHKQA9gilNwns0fzAfXwEcLEeEAB6lu7e0HA52j2T9lKRGijDJn
         HDxTbfWVNUbAw6Q3TR+ryuIRqryWL8m+H4BIq7/YTM8F7tsraamCQgnxpXDUvsHbm09v
         U/dfM/mm9+TbCHT7GnpfUYrzaiGH0nOap7AV0dQ7mNNg+vKHw4q07mboGZSvA3Io0yBM
         iGeUQgDycJ0vb2OENG8Og7mXciLS3ExjdMcCKemEjrBqRyMwviBbPhEQ+Lj8OGLEX121
         Z5rP8l9V7gERdtWhDgDtHMj8X9W3HvExxI30hmCM9m5Mp70WKOozXfWK/D9/7+kdB0C2
         Ckig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Sno9U1PiqFvmo7XNuFb/fM3y1xecgkh8dRFnJhiyLZ8=;
        b=K+IaACKJ+p5pBSxEq+BiOHg53YcaCTEY30FNHRJe6q4ENTy+aSponPiOd+LtquhOy2
         +mu+C8khw9XBgSiEHKX14YOYD5N4fbdmGPjWqNH8/FRyVJjIBdwvzcSzMBP+nwmwglTi
         GPJt2oRH24b3o6wfvY1d60yqoCiAzLyUM2hrRlqQiKbFK2mRT27I9k3kw8zLAaOMW+ow
         RBx/Vc/w5UBHdmSFIW38piE/Zq+g0dawpoAZCsfGYRm0T2x+2lvWQr3yMk1/1Mz6D29P
         pv2OgSK9JluG/lMawW4hGNgFvYfPTvloWaTrXdIZig8vCioasHHB+mCznXG86XfD5a6i
         R7aA==
X-Gm-Message-State: APjAAAX/yYHev1O5xZCEAgRfE6wFsBp8Q+7Hq4dIGkdfUShueZz67KEi
        utzP/kCTskTd8FdOOlYL3pk=
X-Google-Smtp-Source: APXvYqzmqJo/Vw8yEyNcuA87aVY/EWNUXbh1cMlEOmzlSoF2sF1UGY9RcYbLyVEkjkgfX53+ojS0/g==
X-Received: by 2002:a63:6b82:: with SMTP id g124mr21823420pgc.178.1574516918396;
        Sat, 23 Nov 2019 05:48:38 -0800 (PST)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.gmail.com with ESMTPSA id i102sm2400594pje.17.2019.11.23.05.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 05:48:37 -0800 (PST)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Jamie Iles <jamie@jamieiles.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH v3] crypto: picoxcell: adjust the position of tasklet_init and fix missed tasklet_kill
Date:   Sat, 23 Nov 2019 21:48:17 +0800
Message-Id: <20191123134817.30953-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Since tasklet is needed to be initialized before registering IRQ
handler, adjust the position of tasklet_init to fix the wrong order.

Besides, to fix the missed tasklet_kill, this patch adds a helper
function and uses devm_add_action_or_reset to kill the tasklet
automatically.

Fixes: ce92136843cb ("crypto: picoxcell - add support for the picoxcell crypto engines")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
Changes in v3:
  - Use devm_add_action_or_reset to simplify the patch.

 drivers/crypto/picoxcell_crypto.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 3cbefb41b099..497dbf1d6cf6 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1613,6 +1613,11 @@ static const struct of_device_id spacc_of_id_table[] = {
 MODULE_DEVICE_TABLE(of, spacc_of_id_table);
 #endif /* CONFIG_OF */
 
+static void spacc_tasklet_kill(void *data)
+{
+	tasklet_kill(data);
+}
+
 static int spacc_probe(struct platform_device *pdev)
 {
 	int i, err, ret;
@@ -1655,6 +1660,14 @@ static int spacc_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
+	tasklet_init(&engine->complete, spacc_spacc_complete,
+		     (unsigned long)engine);
+
+	ret = devm_add_action_or_reset(&pdev->dev, spacc_tasklet_kill,
+				       &engine->complete);
+	if (ret)
+		return ret;
+
 	if (devm_request_irq(&pdev->dev, irq->start, spacc_spacc_irq, 0,
 			     engine->name, engine)) {
 		dev_err(engine->dev, "failed to request IRQ\n");
@@ -1712,8 +1725,6 @@ static int spacc_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&engine->completed);
 	INIT_LIST_HEAD(&engine->in_progress);
 	engine->in_flight = 0;
-	tasklet_init(&engine->complete, spacc_spacc_complete,
-		     (unsigned long)engine);
 
 	platform_set_drvdata(pdev, engine);
 
-- 
2.24.0

