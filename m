Return-Path: <SRS0=AJZI=ZP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C06EEC432C0
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Nov 2019 14:18:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85C58205C9
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Nov 2019 14:18:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zh0Pta1c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfKWOS5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 23 Nov 2019 09:18:57 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45627 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbfKWOS5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 23 Nov 2019 09:18:57 -0500
Received: by mail-pg1-f194.google.com with SMTP id k1so4860133pgg.12;
        Sat, 23 Nov 2019 06:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5+HKRBPgrlkT72FJQm83/RuV1HTnht2e+fyIAxU9IDU=;
        b=Zh0Pta1c9piN/Ve/Tm/yyJw3tYQCNPqVHwiKmyDBAdixxgE9caRst3dWuOOiP3Pfpz
         LlXICjJbocBjxSosmyf6f5bE2yNK4gVjxly26pBZgkemWAQW8quPexC2kaOLvQfO0DYN
         bnAutBZM3Fv1TiBCQD8Dlrk+PiZ4jSj69hF+Bx2B4ZcLAVO93bI2yiAZF94uHcLCVBoq
         XP8ZC3674XIh7wt8h3PtN0xdl1cMbnMNxEiuFgun/UCRYEVDVXYWFH7+lMeF21dF4x3F
         VhmxYWkmCNtwB8/hQhmBmtWjuezn4M8ZWkCbKXHBG1puIR1Bcb3kVRudO1xMB+IIfQQ0
         GkNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5+HKRBPgrlkT72FJQm83/RuV1HTnht2e+fyIAxU9IDU=;
        b=ZknJetqrRoJWG/snQijJZjTigENB8SSgb1pbbSbGGy1AhJMka1jKRJSNvCg/q3L+mT
         45j4qAsOCbZ6ci8X2M3TOJUnJlQdviijGAEUSz7obCe/hS1+P3sjC7knEoLOiOpqQM/v
         ya4Po1XLqMOaddU7INql8DNavV3Z4d9Ev3ufp+Lu4GjJt8tauLlJDsdYRVu/ew51jpsx
         X9E+F+LkbbVMYcOxCqoO+HbwwftQ+x6mLjTpUkX4G9H4fqcz4wYqjuZhvidlGJTu/hTk
         1zpWPulR4XbpUO0AhOhvh8xKwwXu+9pCQJEqVZAdikKOtV4BY6dcropaepq75FE6B9Ai
         GAkg==
X-Gm-Message-State: APjAAAX9l+qLiuhHA6jYmUuBuyECqIGPXsVz945jW+MeJPDYwLDlsyPY
        19/PQB0ZttJcNwfTeyk8THU=
X-Google-Smtp-Source: APXvYqwmM2CGZ9NV2t7afNAi5NSJrnoU73ZseZAi/yjFX7c23seSOvOH06ah+PrGHGVjwGHml2iDSA==
X-Received: by 2002:a63:710:: with SMTP id 16mr2106649pgh.58.1574518736821;
        Sat, 23 Nov 2019 06:18:56 -0800 (PST)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.gmail.com with ESMTPSA id b5sm2484267pjp.13.2019.11.23.06.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 06:18:56 -0800 (PST)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Jamie Iles <jamie@jamieiles.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH v4] crypto: picoxcell: adjust the position of tasklet_init and fix missed tasklet_kill
Date:   Sat, 23 Nov 2019 22:18:45 +0800
Message-Id: <20191123141845.16183-1-hslester96@gmail.com>
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
function and uses devm_add_action to kill the tasklet automatically.

Fixes: ce92136843cb ("crypto: picoxcell - add support for the picoxcell crypto engines")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
Changes in v4:
  - Use devm_add_action instead of devm_add_action_or_reset.

 drivers/crypto/picoxcell_crypto.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 3cbefb41b099..2680e1525db5 100644
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
+	ret = devm_add_action(&pdev->dev, spacc_tasklet_kill,
+			      &engine->complete);
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

