Return-Path: <SRS0=S8oY=Z7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28D85C43603
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Dec 2019 16:21:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE39420692
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Dec 2019 16:21:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OBnrp6ld"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbfLIQVz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Dec 2019 11:21:55 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46061 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbfLIQVz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Dec 2019 11:21:55 -0500
Received: by mail-pf1-f194.google.com with SMTP id 2so7464095pfg.12;
        Mon, 09 Dec 2019 08:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=70oqW20/DJHzjlf28vSOcRGe1yLG+Cg2RK6l9FagL/c=;
        b=OBnrp6ldO9XdylaMgI5/cr9oWs8jDGq/zWcPAWIaikmOEPJNw2qdUzxC+/YcmlCw0V
         Y7KjpfRCnIiqe4G9IETiAXRW4MdRb6JSDi2Y54sI7QlifOqE9qZMcdFJa5WvGx4BxAMl
         9GHwbSrvo3NucwGJMFvAO6p1185lyaPrLhYyp4RTkczwBUxwiEsMtcPaqEthZcF8WJcY
         5h2ymoCBeGF0lgkNF+t49yVm9wv85bei0UJcbmN0704g+/lar2QVoYbNoGWs5VrbIKRj
         Vqvmx3WAqPB7xEdOQkDYggvY72KwgxBMFuMu68zFaDcz93Vi2h71iTgjGulOyAhXNg0Z
         wbpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=70oqW20/DJHzjlf28vSOcRGe1yLG+Cg2RK6l9FagL/c=;
        b=rqG0VOnYpLIjDWJmCz1YynEnEK3vFHafAFUz+UdfGqU9BoVtbVNOIXA4chVCxNEjmA
         ihsqHBJjcOsVrjadviwwXe3YtHS2CHr8/MofWNWRt+vc8j3ASZh0qwFs753qasNp9CjM
         91Okt9OZWnqzgHhLOM8C3DuyuZqHWFdm7ft0QdQeOQMufjCChtNb2j5HiQkDjD4cIeCR
         6GOEhEx4axPghrSK7KKiIhxomogZ1y0iGHwo85Pym5nFAiFnf+O+fTPilpD6aKEO3wBO
         rdOR8NH/TAcLYWT+ac62klz1DpCMFBSR7DvhYX2XUBLTlRyYjuYRLp3uGTxcLGLi0NJw
         VnJw==
X-Gm-Message-State: APjAAAUtX+r2zC2MjYwxUTESwh4XdUbltZ6KFOjgE5rAGTP1nDSPX9++
        xZJg/QnWtzzcvm4RGA+tQN8=
X-Google-Smtp-Source: APXvYqwo9qI45m5jDokO8HihKyUyIE6CPbZT1X7EJ7Eh7j/3O3eilTlx22kkYK4520v5d9URHJbPxg==
X-Received: by 2002:a62:ac15:: with SMTP id v21mr30819253pfe.48.1575908514461;
        Mon, 09 Dec 2019 08:21:54 -0800 (PST)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.gmail.com with ESMTPSA id o8sm202614pjo.7.2019.12.09.08.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 08:21:53 -0800 (PST)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Jamie Iles <jamie@jamieiles.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH v4 resend] crypto: picoxcell: adjust the position of tasklet_init and fix missed tasklet_kill
Date:   Tue, 10 Dec 2019 00:21:44 +0800
Message-Id: <20191209162144.14877-1-hslester96@gmail.com>
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
index 29da449b3e9e..d187312b9864 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1595,6 +1595,11 @@ static const struct of_device_id spacc_of_id_table[] = {
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
@@ -1637,6 +1642,14 @@ static int spacc_probe(struct platform_device *pdev)
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
@@ -1694,8 +1707,6 @@ static int spacc_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&engine->completed);
 	INIT_LIST_HEAD(&engine->in_progress);
 	engine->in_flight = 0;
-	tasklet_init(&engine->complete, spacc_spacc_complete,
-		     (unsigned long)engine);
 
 	platform_set_drvdata(pdev, engine);
 
-- 
2.24.0

