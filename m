Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECB8AC433E9
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 12:32:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A35CF23356
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 12:32:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbhAGMca (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Jan 2021 07:32:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbhAGMc3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Jan 2021 07:32:29 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA19C0612F6;
        Thu,  7 Jan 2021 04:31:49 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id x126so3768063pfc.7;
        Thu, 07 Jan 2021 04:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JRk8t1M4XXjPEk7oyhWaY6rs5Sl9RScV/nWFL0Tu+/w=;
        b=kYC9dTtWAXY4xKQ/GQ4YLzK0W3XwA/v9tBfEw1XfRdYS2voXTYlj42FmwN8IFu5Bfv
         JMQMpaQ36VXpv66DlJg3QqoQ4lJ+w6o9RUwX+2gf4WQEnAXnLa9yv0AeaaGapgFX2Wzu
         42oR762tRp1x4BgfjO0MazixRgcE8XcydZMOucaAGjhtcrfEgRHl4cZBdtKpVxddNwhf
         180qtNIApokfroeh0cNuMVn2VZs98TX8E2dpqj2a/osygcmHAKUg+WWTqLpmffGLDfJG
         TBBo2IvbLVQVcBx23WQBH5JTqhtWgYwZBLt55qL3vLmVL+PDq7Su3mMWiJhIjVlfCTLN
         zLDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JRk8t1M4XXjPEk7oyhWaY6rs5Sl9RScV/nWFL0Tu+/w=;
        b=MGMDPB+Itcq5Cy8pID5+Q73j8Gl12PrQzHhJAMaoQY/vRXRZ9juAniDutjtpr9iwv3
         bso4qz4DTelblEqXcximcVTCfpqnQlsSDyApbK8ImXmafm4eo7JhIlzmi0CihKcBgrue
         fyDmIzw3WqlxKM3xhw0O0xbnhHUtxBWCQrkT1S0o+dXjHFT5JfJuyIh3cQ6wsn7vbCcA
         5g5+l0Gk2RdwHVjz40jrxA6qbJaR8+0j12kpFmijdOgyHTTCRZNcrA1IdX8vTxlziOh7
         0sHmqQi8n7UZFXh85zjqBsIuKp7NE7e04aVe1o5li5fc1CdMD4Vd7LFl/CKVXGpRNbdB
         06iQ==
X-Gm-Message-State: AOAM5313K9Eb4a2AVnZgVXTFhj6XRPRySA18CgYYYqeYKBWTvMVhzH3v
        jMuaBx7lzAmAKtsvmU704qA=
X-Google-Smtp-Source: ABdhPJyu3WtVMoxBM4D25J3ONFDYaaGBZCccHMGw5dFAMa5AazfuQ4DJ1h3Q7vYBYDehN21EQTwdfw==
X-Received: by 2002:a65:6152:: with SMTP id o18mr1641272pgv.392.1610022709048;
        Thu, 07 Jan 2021 04:31:49 -0800 (PST)
Received: from localhost.localdomain ([49.207.216.201])
        by smtp.gmail.com with ESMTPSA id h12sm6356014pgk.70.2021.01.07.04.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 04:31:48 -0800 (PST)
From:   Allen Pais <allen.lkml@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, ludovic.desroches@microchip.com,
        jesper.nilsson@axis.com, lars.persson@axis.com,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com, gcherian@marvell.com,
        thomas.lendacky@amd.com, john.allen@amd.com, gilad@benyossef.com,
        bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
        matthias.bgg@gmail.com, jamie@jamieiles.com,
        giovanni.cabiddu@intel.com, heiko@sntech.de, krzk@kernel.org,
        vz@mleia.com, k.konieczny@samsung.com,
        linux-crypto@vger.kernel.org, linux-mediatek@lists.infradead.org,
        qat-linux@intel.com, linux-rockchip@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v2 16/19] crypto: rockchip: convert tasklets to use new tasklet_setup() API
Date:   Thu,  7 Jan 2021 17:59:41 +0530
Message-Id: <20210107122944.16363-13-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107122944.16363-1-allen.lkml@gmail.com>
References: <20210107122944.16363-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 drivers/crypto/rockchip/rk3288_crypto.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index 35d73061d156..af6ad9f49009 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -201,9 +201,9 @@ static int rk_crypto_enqueue(struct rk_crypto_info *dev,
 	return ret;
 }
 
-static void rk_crypto_queue_task_cb(unsigned long data)
+static void rk_crypto_queue_task_cb(struct tasklet_struct *T)
 {
-	struct rk_crypto_info *dev = (struct rk_crypto_info *)data;
+	struct rk_crypto_info *dev = from_tasklet(dev, t, queue_task);
 	struct crypto_async_request *async_req, *backlog;
 	unsigned long flags;
 	int err = 0;
@@ -231,9 +231,9 @@ static void rk_crypto_queue_task_cb(unsigned long data)
 		dev->complete(dev->async_req, err);
 }
 
-static void rk_crypto_done_task_cb(unsigned long data)
+static void rk_crypto_done_task_cb(struct tasklet_struct *t)
 {
-	struct rk_crypto_info *dev = (struct rk_crypto_info *)data;
+	struct rk_crypto_info *dev = from_tasklet(dev, t, done_task);
 
 	if (dev->err) {
 		dev->complete(dev->async_req, dev->err);
@@ -389,10 +389,8 @@ static int rk_crypto_probe(struct platform_device *pdev)
 	crypto_info->dev = &pdev->dev;
 	platform_set_drvdata(pdev, crypto_info);
 
-	tasklet_init(&crypto_info->queue_task,
-		     rk_crypto_queue_task_cb, (unsigned long)crypto_info);
-	tasklet_init(&crypto_info->done_task,
-		     rk_crypto_done_task_cb, (unsigned long)crypto_info);
+	tasklet_setup(&crypto_info->queue_task, rk_crypto_queue_task_cb);
+	tasklet_setup(&crypto_info->done_task, rk_crypto_done_task_cb);
 	crypto_init_queue(&crypto_info->queue, 50);
 
 	crypto_info->enable_clk = rk_crypto_enable_clk;
-- 
2.25.1

