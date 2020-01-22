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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0092C2D0DB
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 10:46:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A586E2465B
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 10:46:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gY97jhBx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729592AbgAVKpm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jan 2020 05:45:42 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36348 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729578AbgAVKpm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jan 2020 05:45:42 -0500
Received: by mail-wr1-f67.google.com with SMTP id z3so6746551wru.3;
        Wed, 22 Jan 2020 02:45:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lo8LLHFbuM7TeGYDeTlQoBN8WOd2hUEZekUpabEc1mM=;
        b=gY97jhBxzfGaSoSJe/9DJBRMWHpcwm2pHDbhJbZ5+5w49H5BCpCkqHYZwE1vo8tDnt
         bpNKVku2NGfETc/ThU4Sf5qw6sbYIP7ndKZm7JEw3KE3mY14jO1zcipE/+V6fIkB+Zc3
         t0z4/Th/wP+oUvshpss+455rUZGXGelGdf/W++RDJoqlmIwGmLjYRgE3V48yyng4q5z8
         NwZYiLZ/LFp91vIAWzQvCLPji0AZjRVfXKWoUdQgOsCy41402wg0mwK3AHWpNyWfzgt3
         8xPncSZ5Zzc337KUWJC/dwoeVjEWa548Zs872YwKEh9NIB7yjGbA83TfhohB5xzkK7M4
         F6Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lo8LLHFbuM7TeGYDeTlQoBN8WOd2hUEZekUpabEc1mM=;
        b=MRJpBvHrJh43J6X0H0yDoy1nTblSqvi7o4fQrPbfPkN5w0HCFCLCpg7nc+ggsEfD6Q
         RUrWV6qeOZPCNKfZeXbcQyPVhaSw6m7BxcLHbosZ0STaMw0dHSd8A0vdMTBUkU+tJAKL
         Y4qnXicRUStavgivWHiQktF0YWOtOTYKyn1LzczCSbFmS16t+CMGCADUcSEN/CQPGgjn
         C2ckzfBfUrbnvxAeqilkhSlEdRYjOgfr3OPkKDocP9LRhfXhdktZI/m2+Y9qFyatZQBS
         hIpkVy5+1BOFQdPCnc6kh0JnHbBR0asZuQPO+Gv4TMCacxVT9U7WGhwZpu0lqw4eUdZQ
         EbJA==
X-Gm-Message-State: APjAAAWKMKwYo9IIUBFot2x39Iug5RxM5JNDVZYiN/C31s/tt/qwdO88
        /Kzf6U00elF0IdELiD9U5qQ=
X-Google-Smtp-Source: APXvYqylHdDo0Ce4Pl3PZywawsbwSz1/WCPI8gnceqoCrzqzmRYGpJyEyygKdIwwAlHY5ZOO24nm3A==
X-Received: by 2002:a5d:49c7:: with SMTP id t7mr10174792wrs.369.1579689940777;
        Wed, 22 Jan 2020 02:45:40 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id n3sm3443953wmc.27.2020.01.22.02.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 02:45:40 -0800 (PST)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org, iuliana.prodan@nxp.com
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 1/9] crypto: engine: workqueue can only be processed one by one
Date:   Wed, 22 Jan 2020 11:45:20 +0100
Message-Id: <20200122104528.30084-2-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200122104528.30084-1-clabbe.montjoie@gmail.com>
References: <20200122104528.30084-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some bykeshedding are unnecessary since a workqueue can only be executed
one by one.
This behaviour is documented in:
- kernel/kthread.c: comment of kthread_worker_fn()
- Documentation/core-api/workqueue.rst: the functions associated with the work items one after the other

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 crypto/crypto_engine.c  | 13 -------------
 include/crypto/engine.h |  2 --
 2 files changed, 15 deletions(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index eb029ff1e05a..feb0d82dd454 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -73,16 +73,6 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 
 	spin_lock_irqsave(&engine->queue_lock, flags);
 
-	/* Make sure we are not already running a request */
-	if (engine->cur_req)
-		goto out;
-
-	/* If another context is idling then defer */
-	if (engine->idling) {
-		kthread_queue_work(engine->kworker, &engine->pump_requests);
-		goto out;
-	}
-
 	/* Check if the engine queue is idle */
 	if (!crypto_queue_len(&engine->queue) || !engine->running) {
 		if (!engine->busy)
@@ -96,7 +86,6 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 		}
 
 		engine->busy = false;
-		engine->idling = true;
 		spin_unlock_irqrestore(&engine->queue_lock, flags);
 
 		if (engine->unprepare_crypt_hardware &&
@@ -104,7 +93,6 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 			dev_err(engine->dev, "failed to unprepare crypt hardware\n");
 
 		spin_lock_irqsave(&engine->queue_lock, flags);
-		engine->idling = false;
 		goto out;
 	}
 
@@ -410,7 +398,6 @@ struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
 	engine->rt = rt;
 	engine->running = false;
 	engine->busy = false;
-	engine->idling = false;
 	engine->cur_req_prepared = false;
 	engine->priv_data = dev;
 	snprintf(engine->name, sizeof(engine->name),
diff --git a/include/crypto/engine.h b/include/crypto/engine.h
index e29cd67f93c7..7e7cbd9ca3b5 100644
--- a/include/crypto/engine.h
+++ b/include/crypto/engine.h
@@ -21,7 +21,6 @@
 /*
  * struct crypto_engine - crypto hardware engine
  * @name: the engine name
- * @idling: the engine is entering idle state
  * @busy: request pump is busy
  * @running: the engine is on working
  * @cur_req_prepared: current request is prepared
@@ -42,7 +41,6 @@
  */
 struct crypto_engine {
 	char			name[ENGINE_NAME_LEN];
-	bool			idling;
 	bool			busy;
 	bool			running;
 	bool			cur_req_prepared;
-- 
2.24.1

