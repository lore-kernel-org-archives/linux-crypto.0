Return-Path: <SRS0=EdI7=3L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A184C33CB6
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 10:46:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 008802465B
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 10:46:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ds2DOy1l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729679AbgAVKps (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jan 2020 05:45:48 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53332 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729643AbgAVKps (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jan 2020 05:45:48 -0500
Received: by mail-wm1-f68.google.com with SMTP id m24so6292885wmc.3;
        Wed, 22 Jan 2020 02:45:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4S+yn/Cw6FGkvqLirx1JEfwucBuYI5yAQeYyvQqpsxI=;
        b=ds2DOy1lyspOM14eZEZs2/17U7vnqFrKa7f9ZBdQhN3W9OxGpcntPuZZiS4Hsl6ioY
         r4D3P5iDPZSf3E90XC1Aow6iI6BUhadDjEJm9/ucW2Y0H37h0r+yiyeMlf0MZhMNTD11
         fH3qWP+32nBsBvXOUSWj+uMPXUpB9LLHMgvRSEbLfbyRLiFhBaoJZnCjIx2a5gkcwPP+
         aXO8SMILlAgDBw++VXJwFn7X/MUproKFpz7HMI/rJNEMkdv3vJ7ijVAgHB4zs6g3erol
         Kzi1VfRw2TEIFy6U8aurXO4lk4IR7j/SykPiA4WjQJ1hH0t/V3eRkJg/4nCnrWwDBl0e
         bHcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4S+yn/Cw6FGkvqLirx1JEfwucBuYI5yAQeYyvQqpsxI=;
        b=sNdggCDbBhOyMVT0+NepbucIgdfihWFfDlVUWmoBYTnDCYDL+W9NVZJcY5GzuYZQAT
         n46LPJE2z+hH4b+znq94y7RDQxBArHPg7pVGn8Qc2p9kOStET4aQVYZT6X7fyWsOhhpa
         lyaorJeDFsyHawg18x5aSEs+gxu2w9fi473GaiiMx0yDX73S2vmQbETA1uvemQq10vyB
         NHWUacye1+LRGL3CDLQeaX+DKSgquR6DoM0RoJIXSQk15YuCj+cN5lx3KLzTBgr9oBoO
         xBdH2yNRonh1/2V2Zz//5/lxkrMTn1P1Byd7ZkkE+XXzRiuFtkrJgBLsrWVLk0ix2EE/
         gSTQ==
X-Gm-Message-State: APjAAAWm9jQA7DzwVKJ/GS9BLsT1TeBWsE4f5exXECujd6+L1Cb/qzDZ
        jZw9yQfd3pdnMP5W109WFD8=
X-Google-Smtp-Source: APXvYqzkbte6byNdOwmDLXzTtCGjykKZZDRnZdH9h1iEP0BQW3vmY4+IZrPO4ti01TA5oPeKafpHYg==
X-Received: by 2002:a1c:6308:: with SMTP id x8mr2357168wmb.80.1579689946278;
        Wed, 22 Jan 2020 02:45:46 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id n3sm3443953wmc.27.2020.01.22.02.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 02:45:45 -0800 (PST)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org, iuliana.prodan@nxp.com
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 5/9] crypto: engine: add enqueue_request/can_do_more
Date:   Wed, 22 Jan 2020 11:45:24 +0100
Message-Id: <20200122104528.30084-6-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200122104528.30084-1-clabbe.montjoie@gmail.com>
References: <20200122104528.30084-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchs adds two new function wrapper in crypto_engine.
- enqueue_request() for drivers enqueuing request to hardware.
- can_queue_more() for letting drivers to tell if they can
enqueue/prepare more.

Since some drivers (like caam) only enqueue request without "doing"
them, do_one_request() is now optional.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 crypto/crypto_engine.c  | 25 ++++++++++++++++++++++---
 include/crypto/engine.h | 14 ++++++++------
 2 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index 5bcb1e740fd9..4a28548c49aa 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -83,6 +83,7 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 		goto out;
 	}
 
+retry:
 	/* Get the fist request from the engine queue to handle */
 	backlog = crypto_get_backlog(&engine->queue);
 	async_req = crypto_dequeue_request(&engine->queue);
@@ -118,10 +119,28 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 			goto req_err2;
 		}
 	}
+
+	if (enginectx->op.enqueue_request) {
+		ret = enginectx->op.enqueue_request(engine, async_req);
+		if (ret) {
+			dev_err(engine->dev, "failed to enqueue request: %d\n",
+				ret);
+			goto req_err;
+		}
+	}
+	if (enginectx->op.can_queue_more && engine->queue.qlen > 0) {
+		ret = enginectx->op.can_queue_more(engine, async_req);
+		if (ret > 0) {
+			spin_lock_irqsave(&engine->queue_lock, flags);
+			goto retry;
+		}
+		if (ret < 0) {
+			dev_err(engine->dev, "failed to call can_queue_more\n");
+			/* TODO */
+		}
+	}
 	if (!enginectx->op.do_one_request) {
-		dev_err(engine->dev, "failed to do request\n");
-		ret = -EINVAL;
-		goto req_err;
+		return;
 	}
 	ret = enginectx->op.do_one_request(engine, async_req);
 	if (ret) {
diff --git a/include/crypto/engine.h b/include/crypto/engine.h
index 03d9f9ec1cea..8ab9d26e30fe 100644
--- a/include/crypto/engine.h
+++ b/include/crypto/engine.h
@@ -63,14 +63,16 @@ struct crypto_engine {
  * @prepare__request: do some prepare if need before handle the current request
  * @unprepare_request: undo any work done by prepare_request()
  * @do_one_request: do encryption for current request
+ * @enqueue_request:	Enqueue the request in the hardware
+ * @can_queue_more:	if this function return > 0, it will tell the crypto
+ * 	engine that more space are availlable for prepare/enqueue request
  */
 struct crypto_engine_op {
-	int (*prepare_request)(struct crypto_engine *engine,
-			       void *areq);
-	int (*unprepare_request)(struct crypto_engine *engine,
-				 void *areq);
-	int (*do_one_request)(struct crypto_engine *engine,
-			      void *areq);
+	int (*prepare_request)(struct crypto_engine *engine, void *areq);
+	int (*unprepare_request)(struct crypto_engine *engine, void *areq);
+	int (*do_one_request)(struct crypto_engine *engine, void *areq);
+	int (*enqueue_request)(struct crypto_engine *engine, void *areq);
+	int (*can_queue_more)(struct crypto_engine *engine, void *areq);
 };
 
 struct crypto_engine_ctx {
-- 
2.24.1

