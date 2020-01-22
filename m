Return-Path: <SRS0=EdI7=3L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FAD6C2D0DB
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 10:45:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D65E92468A
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 10:45:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nr8u3nfY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729664AbgAVKpr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jan 2020 05:45:47 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41831 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729631AbgAVKpr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jan 2020 05:45:47 -0500
Received: by mail-wr1-f66.google.com with SMTP id c9so6699278wrw.8;
        Wed, 22 Jan 2020 02:45:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q1c4fMXgRAivI+KIqtp9qKOWY67co/0FrPc2eCYg+90=;
        b=nr8u3nfYAjPtAAqgYOSmcY7z3j0CmJEacsKmUlaLEU/61bZC071n/wBvVRSqFb857K
         OgGXGQwDY7DHJImYHGuunm8MMkY7V12amlQB+UxyqzJhkdHTPRioVLHlsU+ufOp0FgRq
         X6IqpXOf8Fh99IyQsb9U4VwE9TvnHR8txVF9H1KysmQDUCbRxxS1qo/cilQX0gbQw8Vi
         uBHg1Mk0DGjNKVbVf2FoRcViiKw8KJwChypgsHGnSyvoXbVP8lr7vb+1PVmmsuQLEK4O
         nJmsWCWeclCL4W2BcmjD2ZhOFAC08n82NXIJYrmNfXoeHq63zbubJ4r7p4AWnk3WyuJI
         Kt5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q1c4fMXgRAivI+KIqtp9qKOWY67co/0FrPc2eCYg+90=;
        b=EJNUQUVcbHMdor3px88m/OP57/K72YbU2Yl8Cu+2HRlJMK4hphKII4peza2hGnjXVy
         gLbJ3jlgOULnl0sTPupN+wqUiTPvvYc+mKUAAy8VTW35gEVGpDWr3VcVQi1wfEha/9TE
         YFu5c8zaJKKQykv3gJnf7nWsVPzdgPiqC6/xl1VJoBahdf0ipRhXC1SNFXcCWY+BfsEX
         zdLMvS3TeIPoXiBDKrD0iY5We+ip1IvUtYaXEiiWg92DgcCg8ZtvUuxvyKW37dOqfnOC
         oipTTg1WeN3pPvTQky4hrAXBPtXL43QEArtXpx9gTJwU+3E4gjux9EPmW6Qi94iYFBOY
         mIpA==
X-Gm-Message-State: APjAAAV3dAHOdGrNpZgjUeGrDqJncPdtz0EeG4LsDdnjbzZAzTuut1vC
        Xc2oLMulnsCV7lGKi4aMlQU=
X-Google-Smtp-Source: APXvYqwoJEy1uZGesFKgykNXIpCxdh5m24bdAOqtD59KSsP02/GuJsRs39ZlhORaR+RW4F2HEHRhzA==
X-Received: by 2002:a5d:4a8c:: with SMTP id o12mr10108920wrq.43.1579689944967;
        Wed, 22 Jan 2020 02:45:44 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id n3sm3443953wmc.27.2020.01.22.02.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 02:45:44 -0800 (PST)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org, iuliana.prodan@nxp.com
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 4/9] crypto: engine: permit to choose queue length
Date:   Wed, 22 Jan 2020 11:45:23 +0100
Message-Id: <20200122104528.30084-5-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200122104528.30084-1-clabbe.montjoie@gmail.com>
References: <20200122104528.30084-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds a new function which permit to choose the crypto engine
queue length.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 crypto/crypto_engine.c  | 23 ++++++++++++++++++++---
 include/crypto/engine.h |  2 ++
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index c21867106aa4..5bcb1e740fd9 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -365,15 +365,17 @@ int crypto_engine_stop(struct crypto_engine *engine)
 EXPORT_SYMBOL_GPL(crypto_engine_stop);
 
 /**
- * crypto_engine_alloc_init - allocate crypto hardware engine structure and
+ * crypto_engine_alloc_init2 - allocate crypto hardware engine structure and
  * initialize it.
  * @dev: the device attached with one hardware engine
  * @rt: whether this queue is set to run as a realtime task
+ * @qlen: The size of the crypto queue
  *
  * This must be called from context that can sleep.
  * Return: the crypto engine structure on success, else NULL.
  */
-struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
+struct crypto_engine *crypto_engine_alloc_init2(struct device *dev, bool rt,
+						int qlen)
 {
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO / 2 };
 	struct crypto_engine *engine;
@@ -393,7 +395,7 @@ struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
 	snprintf(engine->name, sizeof(engine->name),
 		 "%s-engine", dev_name(dev));
 
-	crypto_init_queue(&engine->queue, CRYPTO_ENGINE_MAX_QLEN);
+	crypto_init_queue(&engine->queue, qlen);
 	spin_lock_init(&engine->queue_lock);
 
 	engine->kworker = kthread_create_worker(0, "%s", engine->name);
@@ -410,6 +412,21 @@ struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
 
 	return engine;
 }
+EXPORT_SYMBOL_GPL(crypto_engine_alloc_init2);
+
+/**
+ * crypto_engine_alloc_init - allocate crypto hardware engine structure and
+ * initialize it.
+ * @dev: the device attached with one hardware engine
+ * @rt: whether this queue is set to run as a realtime task
+ *
+ * This must be called from context that can sleep.
+ * Return: the crypto engine structure on success, else NULL.
+ */
+struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
+{
+	return crypto_engine_alloc_init2(dev, rt, CRYPTO_ENGINE_MAX_QLEN);
+}
 EXPORT_SYMBOL_GPL(crypto_engine_alloc_init);
 
 /**
diff --git a/include/crypto/engine.h b/include/crypto/engine.h
index d77080227beb..03d9f9ec1cea 100644
--- a/include/crypto/engine.h
+++ b/include/crypto/engine.h
@@ -96,6 +96,8 @@ void crypto_finalize_skcipher_request(struct crypto_engine *engine,
 int crypto_engine_start(struct crypto_engine *engine);
 int crypto_engine_stop(struct crypto_engine *engine);
 struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt);
+struct crypto_engine *crypto_engine_alloc_init2(struct device *dev, bool rt,
+						int qlen);
 int crypto_engine_exit(struct crypto_engine *engine);
 
 #endif /* _CRYPTO_ENGINE_H */
-- 
2.24.1

