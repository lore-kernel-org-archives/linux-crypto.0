Return-Path: <SRS0=W3IF=ZO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 590E7C43215
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 11:25:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 270FF20674
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 11:25:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hM9ejjbb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727598AbfKVLZj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Nov 2019 06:25:39 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33745 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbfKVLZj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Nov 2019 06:25:39 -0500
Received: by mail-pf1-f193.google.com with SMTP id c184so3377308pfb.0;
        Fri, 22 Nov 2019 03:25:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9Y7FbQzcdcd1UzsvI05Y/rekBo5nDZ9fDA2c4GXJdaU=;
        b=hM9ejjbb1cnIKaPqZx3YOubhILP+DT3AWPMMzMnvIYpYpoGfoSgX42vo3qeSC9KMFt
         EXA0L1nTJhZK/uf3AQnjN0enCc2KnKW8bxa7y7hJETGF7Tibr2UE3tuZ185Ck8vgBA4k
         VshxBRhHdkzXAqDhxUhLkrn1RxddXBytotrphzzlTs3QGdj/eTya1lyxtngyxKJwyBWX
         5nxc3GCj1cilkmQ0xtSyTDl2FqrSMaZjczDUb1CuqJn+HxEnPxJ70gUve1+AH7ObqCUY
         irWdgodeMl9BHtzWy2r5zvhATewdXgImVynzf8/bFiuyk00dM5dZvV2S8tcICYh/hkbK
         /ZFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9Y7FbQzcdcd1UzsvI05Y/rekBo5nDZ9fDA2c4GXJdaU=;
        b=QU39SG0ddme7xJa0aWMh77empy2Yb5Ilvewcqgt4tFJzVVzRzikGm58rjkbcgV3AtM
         S4XS0eO63+0ElsR0YC9LI4vq0txE6ZOmD7sqJHEt7AQC7trnKF1c19Zdm8GQ4ADyyf+3
         kXf+1gGTbAN5yUIU2PBVkefbXS7y5xk568xyWldK2OckIDIJ9YDhUwjjUfKAafSpbDSh
         3t9VgW+CNFuT5Zgem2/3bdnjSF6En2lOH/goE9pu6t0AibwDbf34dSvkYWTK93IhrEYW
         BNnnt37YCG4JZkq1lERyWMCFhUOp2svOHZgRsFnqpUx2LINUWg5Ecfa5zccPflxqmNNq
         MtFg==
X-Gm-Message-State: APjAAAUiMsdRGBAaqpXnz4fnqozcdCuhhf0hq7+R7OFcShKfs8uimzFg
        huP5isH0JOR5fDhjVoG09aE=
X-Google-Smtp-Source: APXvYqwU0VoaCMq80b38Q42RSD3lh4SXr6vNdkVUXpK/rumdwSTGqW8/qOpm0j5m8/6VSiM8awwuyg==
X-Received: by 2002:a63:1014:: with SMTP id f20mr14801914pgl.279.1574421938351;
        Fri, 22 Nov 2019 03:25:38 -0800 (PST)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.gmail.com with ESMTPSA id d139sm7511334pfd.162.2019.11.22.03.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 03:25:37 -0800 (PST)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Jamie Iles <jamie@jamieiles.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH v2] crypto: picoxcell: use non-devm request_irq and add missed tasklet_kill
Date:   Fri, 22 Nov 2019 19:25:29 +0800
Message-Id: <20191122112529.10908-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This driver forgets to kill tasklet when probe fails and remove.

Since tasklet should not be killed until the IRQ handler has been
unregistered, we use non-devm request_irq instead to make it able
to control its unregistration.

Furthermore, tasklet should be initialized before registering IRQ
handler. So we adjust the order of calling to fix it.

Finally, we fix the missed tasklet_kill in both probe failure and
remove.

Fixes: ce92136843cb ("crypto: picoxcell - add support for the picoxcell crypto engines")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
Changes in v2:
  - Use non-devm request_irq.
  - Adjust the order of calling.
  - Modify commit message.

 drivers/crypto/picoxcell_crypto.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 3cbefb41b099..b751822bb0cb 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1655,10 +1655,14 @@ static int spacc_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	if (devm_request_irq(&pdev->dev, irq->start, spacc_spacc_irq, 0,
-			     engine->name, engine)) {
+	tasklet_init(&engine->complete, spacc_spacc_complete,
+		     (unsigned long)engine);
+
+	if (request_irq(irq->start, spacc_spacc_irq, 0, engine->name,
+			engine)) {
 		dev_err(engine->dev, "failed to request IRQ\n");
-		return -EBUSY;
+		ret = -EBUSY;
+		goto err_tasklet_kill;
 	}
 
 	engine->dev		= &pdev->dev;
@@ -1667,15 +1671,18 @@ static int spacc_probe(struct platform_device *pdev)
 
 	engine->req_pool = dmam_pool_create(engine->name, engine->dev,
 		MAX_DDT_LEN * sizeof(struct spacc_ddt), 8, SZ_64K);
-	if (!engine->req_pool)
-		return -ENOMEM;
+	if (!engine->req_pool) {
+		ret = -ENOMEM;
+		goto err_free_irq;
+	}
 
 	spin_lock_init(&engine->hw_lock);
 
 	engine->clk = clk_get(&pdev->dev, "ref");
 	if (IS_ERR(engine->clk)) {
 		dev_info(&pdev->dev, "clk unavailable\n");
-		return PTR_ERR(engine->clk);
+		ret = PTR_ERR(engine->clk);
+		goto err_free_irq;
 	}
 
 	if (clk_prepare_enable(engine->clk)) {
@@ -1712,8 +1719,6 @@ static int spacc_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&engine->completed);
 	INIT_LIST_HEAD(&engine->in_progress);
 	engine->in_flight = 0;
-	tasklet_init(&engine->complete, spacc_spacc_complete,
-		     (unsigned long)engine);
 
 	platform_set_drvdata(pdev, engine);
 
@@ -1761,6 +1766,10 @@ static int spacc_probe(struct platform_device *pdev)
 	clk_disable_unprepare(engine->clk);
 err_clk_put:
 	clk_put(engine->clk);
+err_free_irq:
+	free_irq(irq->start, engine);
+err_tasklet_kill:
+	tasklet_kill(&engine->complete);
 
 	return ret;
 }
@@ -1770,6 +1779,7 @@ static int spacc_remove(struct platform_device *pdev)
 	struct spacc_aead *aead, *an;
 	struct spacc_alg *alg, *next;
 	struct spacc_engine *engine = platform_get_drvdata(pdev);
+	struct resource *irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 
 	del_timer_sync(&engine->packet_timeout);
 	device_remove_file(&pdev->dev, &dev_attr_stat_irq_thresh);
@@ -1786,6 +1796,8 @@ static int spacc_remove(struct platform_device *pdev)
 
 	clk_disable_unprepare(engine->clk);
 	clk_put(engine->clk);
+	free_irq(irq->start, engine);
+	tasklet_kill(&engine->complete);
 
 	return 0;
 }
-- 
2.24.0

