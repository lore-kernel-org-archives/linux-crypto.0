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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7D5EC2D0DB
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 10:46:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADA8F2468C
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 10:46:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="atOCu/d8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729191AbgAVKqS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jan 2020 05:46:18 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54947 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729624AbgAVKpp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jan 2020 05:45:45 -0500
Received: by mail-wm1-f67.google.com with SMTP id b19so6279438wmj.4;
        Wed, 22 Jan 2020 02:45:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XyFi4QUbF6No7tCrbJhCVZ5TjcE02iPJvNCt7IcZqnw=;
        b=atOCu/d8xHcTs6Q9DCR4yOoCncsmGvFRwn3VBq48XEuBvYixBWtSdK1x3JaE3OU9OC
         ODxVylq8Tytjegvo1QsONKr8O8Ky3aMD+tJg0xp4PCXlYb+KbzMgFeN6dhsHfp1BGMI/
         4KEEm8ebnJg+6uaVjvk0lQLz3vgTZOc456xdXU8EFacdblCYBkAQVFPUgp24ytbh5qoC
         vGvFem36xG4b5EgtG3QDmFGRl527x+c3sU0mbL5FukG1lZ4tFDZrvzvsPCaqj14Z+fUe
         Xgz9D6mrp1jW5sywBLwKC5lO+RWFgtOKK2j2T3VaF4fadactNW6r2jTZT6qd15pEjdmL
         vMQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XyFi4QUbF6No7tCrbJhCVZ5TjcE02iPJvNCt7IcZqnw=;
        b=iWprySoo+im6AuWHxiFCupWd+/88tWwh6BrH169B/AJNgopOPZU+B8OwpZc1+cFaOF
         stoeoHu2Wk5FGBuYDd0iABZbDZ6cj7go2eNinsvucguPq4IbEaKiV3YVs1nTmygGszkG
         kZrfiwRgijMbL1leQ0NiWGtUlSbWR/9HMlnFR9YDCid/4VyAFiELqHi4R+gV5V3rbWFX
         xf03H5YevxxKlMNKX5BvmL9cT9D1I9q3JHJcWhxYR4YKQdehMkOPWRU5tM6aYi4Gbowo
         08K0cQGynq44NWvsHBgrP+NBePKEOGDTkeZGzDuEbqIaL6hrvznqnO5LntXRKCDVH+hT
         gaug==
X-Gm-Message-State: APjAAAW/xZn2cWhnb932deWRzsp4npDqaum17UvQxVFIgQpI5WJ+DYuE
        BhrCRAvCAWDsx2Zxu1twOeQ=
X-Google-Smtp-Source: APXvYqx85aFHoyjVcQwtyMo+TulGXbL1bKMZfZZMz5sFYzpX97V4AsH6AcMjPZhniYZfPSeIRLYP6Q==
X-Received: by 2002:a7b:ce8b:: with SMTP id q11mr2385910wmj.100.1579689943589;
        Wed, 22 Jan 2020 02:45:43 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id n3sm3443953wmc.27.2020.01.22.02.45.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 02:45:42 -0800 (PST)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org, iuliana.prodan@nxp.com
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 3/9] crypto: engine: get rid of cur_req
Date:   Wed, 22 Jan 2020 11:45:22 +0100
Message-Id: <20200122104528.30084-4-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200122104528.30084-1-clabbe.montjoie@gmail.com>
References: <20200122104528.30084-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

cur_req was used as a sign of usage of the crypto_engine, now this
behaviour has gone, its usage remains for detecting if we finalize the
cur_req.
But testing if we finalize the cur_req prevent to do more request at a
time and is unnecessary.
It is unnecessary since crypto_finalize_request() is only used for
cryptoengine and so the request finalized will be always the current
request.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 crypto/crypto_engine.c  | 25 ++++++-------------------
 include/crypto/engine.h |  2 --
 2 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index dfcb00e92e09..c21867106aa4 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -24,27 +24,15 @@
 static void crypto_finalize_request(struct crypto_engine *engine,
 			     struct crypto_async_request *req, int err)
 {
-	unsigned long flags;
-	bool finalize_cur_req = false;
 	int ret;
 	struct crypto_engine_ctx *enginectx;
 
-	spin_lock_irqsave(&engine->queue_lock, flags);
-	if (engine->cur_req == req)
-		finalize_cur_req = true;
-	spin_unlock_irqrestore(&engine->queue_lock, flags);
-
-	if (finalize_cur_req) {
-		enginectx = crypto_tfm_ctx(req->tfm);
-		if (enginectx->op.prepare_request &&
-		    enginectx->op.unprepare_request) {
-			ret = enginectx->op.unprepare_request(engine, req);
-			if (ret)
-				dev_err(engine->dev, "failed to unprepare request\n");
-		}
-		spin_lock_irqsave(&engine->queue_lock, flags);
-		engine->cur_req = NULL;
-		spin_unlock_irqrestore(&engine->queue_lock, flags);
+	enginectx = crypto_tfm_ctx(req->tfm);
+	if (enginectx->op.prepare_request &&
+			enginectx->op.unprepare_request) {
+		ret = enginectx->op.unprepare_request(engine, req);
+		if (ret)
+			dev_err(engine->dev, "failed to unprepare request\n");
 	}
 
 	req->complete(req, err);
@@ -101,7 +89,6 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 	if (!async_req)
 		goto out;
 
-	engine->cur_req = async_req;
 	if (backlog)
 		backlog->complete(backlog, -EINPROGRESS);
 
diff --git a/include/crypto/engine.h b/include/crypto/engine.h
index 4d8a2602c9ed..d77080227beb 100644
--- a/include/crypto/engine.h
+++ b/include/crypto/engine.h
@@ -36,7 +36,6 @@
  * @kworker: kthread worker struct for request pump
  * @pump_requests: work struct for scheduling work to the request pump
  * @priv_data: the engine private data
- * @cur_req: the current request which is on processing
  */
 struct crypto_engine {
 	char			name[ENGINE_NAME_LEN];
@@ -57,7 +56,6 @@ struct crypto_engine {
 	struct kthread_work             pump_requests;
 
 	void				*priv_data;
-	struct crypto_async_request	*cur_req;
 };
 
 /*
-- 
2.24.1

