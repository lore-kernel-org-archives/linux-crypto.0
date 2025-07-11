Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B072199FAB;
	Fri, 11 Jul 2025 18:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752258636; cv=none; b=IKOBE+wxExGxYi3pvs46hkkBV1EkK/y/oy2TrzJn794GR3V/kNPAi1o+EsiAPGvSy/sbQIlJ4V/5+ChzegIC7u5fxYP8NKiKicvgs9py5dho9HrjGeaxB8mUP9GLo3T4vFMUUYubn2HtACqywSgpcyZuB09+EWekz/ClkMoAVrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752258636; c=relaxed/simple;
	bh=zpMA/dMCXiP1D6D+wn2rANCebAxggughyZr2DNtUrUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lCNLlIXnwKK8jLrrmT5N4hqmcEqhGK8ZfOQXsF5nx5JMzAQdmabTcGlmEPojd3V9ne69GMw5mhQSbJ6YfxW+lavCWhrrmHxr+0gsgGOfYnc/8gHsEjVRLvt5kF5fHEqDikqc9IoMsJ+UHWmMq8KZGCdjeninfxtT9cbrvnIw7K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RK+U/lm6; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RK+U/lm6"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-607cc1a2bd8so3945831a12.2;
        Fri, 11 Jul 2025 11:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752258632; x=1752863432; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F6yiVhcxL2AzY6CvTzVfTLqG5PW0uz+KvplY6hVmTe4=;
        b=RK+U/lm6/Si/1IAxeE0MFyK+1ALgFCirokh435+EY7mix+1RQvI5eJ6fXzqPxEEuN8
         72L4nIVri2W/kRlyUZRdDHZX6y49FgKx4oy7vkQnnxmepXzQpx7NtH+clgpybJxQeMh7
         eS9g/huPypcptOxLco71ojW27rItL8DamFqeeMpEIYckFlTgyp5y1O6TNU7dDoh9NeXa
         OgDNahIR2FyFBVFglzK+eByfe+BI/YZl96CvgSFvptOxkvCsaFjgjCCCLBY/KpqJoXrw
         gTiCulyg+bK3b9CEYChkB0beOqKjSD9rCEUohM6L+pWAsvSVhfDKbIy/V5mzm8RWLb3t
         82iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752258632; x=1752863432;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F6yiVhcxL2AzY6CvTzVfTLqG5PW0uz+KvplY6hVmTe4=;
        b=l7o00t6+F/zbSRVnvhbhwMGEJmEuZEJ9DCLfLKYg/gWB/CqsHAKWlHG5XOKDHWyQOy
         YMR7o6Twkm0qIgivdJoEmTUKq7atBlPcwNEnul6SigEWANBZQsBJ6IXfIPOJC2AzJzTQ
         woGau1ERTI/3Ah3Zi7O2TS4pKfjZ4lsfPAK3tH+i1VuMI7E5nqjSczaXnEhJb2ZJZr0A
         ciYjuEulhp2PBhUk+aJqXE9g8VkEjaIhnbl1lTHi+CSW6nNvsYuXAaa1zpB6Q4tVZwrF
         l2uf28PxZxYgZOTVZEamPkulaeXg44Nbc4NuWYSGWuCp7WNyNyGRLsECNh1bvg6iPhZJ
         U9ZQ==
X-Forwarded-Encrypted: i=1; AJvYcCWvwcwEEog11BdFP+ZoIrSdjV0cgATdCFCRiJduUgNr8VuhMl3uKSLDWgYU5aG3QqciBvF72xFWxFsmqUo=@vger.kernel.org, AJvYcCXDi0tlm83F1oYu+YEkkCogxEVLYR73yuPYzMO0XIUAILQM2AqUHzHQxonGtWO983RtKjosA7kQLzXoQv83@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9uDb0+9e652KVRaZgm6NM5/yXqWxpi1pQgM+/OgOPDKsnRLAt
	pgFvFQeQRMVSHg0hY2Z+QOP58IuzTdzSbM9tjBNo0f4cbDeg/YI13bcM
X-Gm-Gg: ASbGncsU37fEkuw+HNq1lXERQarF0pzeDQoGA7pQ+s8bkXmvQKHuPbpY9SCnp4uU5aN
	Ah4BMupIEzAYXLKQF5sJcA4qy+mIU2QcSSZQn4ism6b301qrAeH7oZWugfg1xm/I5vCqJRq5sGf
	P5TYm+8BXvmCrguGvjYmNHd2xxZUnaz0HtBKD0Xwimj6UBysP59rVdZ+adpvEdt9lFU/5+2oQoz
	Nc5/4mT8iD5//u8QDat8ryEn2oDnNtoNVVwRvBwjXgptXfUJLApTv1tWTqfA1Of/caX/WLGh45B
	7aI99VMyL4N8VXO2W1plqBEXa+tszMzMEeWl+SOhTdbcW2wou9MHm0oaEWYgRW1woyWxX22aTjb
	afh6TffLt1AHAi3EVh7myC9Lgy/OE0W1qHCc=
X-Google-Smtp-Source: AGHT+IHIIlShxU2Eabjl4/b7qE20xlv4fERAh27KnCiO8zgUlt7tLSxGFoKqF94aot1PKDbFjTib2A==
X-Received: by 2002:a17:907:2684:b0:ade:36e4:ceba with SMTP id a640c23a62f3a-ae6fc3c4510mr481717466b.52.1752258632413;
        Fri, 11 Jul 2025 11:30:32 -0700 (PDT)
Received: from ws-linux01 ([2a02:2f07:6009:b200:8bc2:7901:5231:7913])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae6e7ee569asm334750066b.44.2025.07.11.11.30.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jul 2025 11:30:31 -0700 (PDT)
From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Subject: [PATCH 2/2] crypto: engine: remove {prepare,unprepare}_crypt_hardware callbacks
Date: Fri, 11 Jul 2025 21:29:32 +0300
Message-ID: <20250711182932.918257-2-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250711182932.918257-1-ovidiu.panait.oss@gmail.com>
References: <20250711182932.918257-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The {prepare,unprepare}_crypt_hardware callbacks were added back in 2016
by commit 735d37b5424b ("crypto: engine - Introduce the block request
crypto engine framework"), but they were never implemented by any driver.
Remove them as they are unused.

Since the 'engine->idling' and 'was_busy' flags are no longer needed,
remove them as well.

Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
 Documentation/crypto/crypto_engine.rst |  6 ------
 crypto/crypto_engine.c                 | 30 +-------------------------
 include/crypto/internal/engine.h       | 11 ----------
 3 files changed, 1 insertion(+), 46 deletions(-)

diff --git a/Documentation/crypto/crypto_engine.rst b/Documentation/crypto/crypto_engine.rst
index d562ea17d994..7ef850e28016 100644
--- a/Documentation/crypto/crypto_engine.rst
+++ b/Documentation/crypto/crypto_engine.rst
@@ -36,12 +36,6 @@ engine using ``crypto_engine_stop()`` and destroy the engine with
 Before transferring any request, you have to fill the context enginectx by
 providing functions for the following:
 
-* ``prepare_crypt_hardware``: Called once before any prepare functions are
-  called.
-
-* ``unprepare_crypt_hardware``: Called once after all unprepare functions have
-  been called.
-
 * ``prepare_cipher_request``/``prepare_hash_request``: Called before each
   corresponding request is performed. If some processing or other preparatory
   work is required, do it here.
diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index 8a2400f240d4..18e1689efe12 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -74,7 +74,6 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 	struct crypto_engine_alg *alg;
 	struct crypto_engine_op *op;
 	unsigned long flags;
-	bool was_busy = false;
 	int ret;
 
 	spin_lock_irqsave(&engine->queue_lock, flags);
@@ -83,12 +82,6 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 	if (!engine->retry_support && engine->cur_req)
 		goto out;
 
-	/* If another context is idling then defer */
-	if (engine->idling) {
-		kthread_queue_work(engine->kworker, &engine->pump_requests);
-		goto out;
-	}
-
 	/* Check if the engine queue is idle */
 	if (!crypto_queue_len(&engine->queue) || !engine->running) {
 		if (!engine->busy)
@@ -102,15 +95,6 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 		}
 
 		engine->busy = false;
-		engine->idling = true;
-		spin_unlock_irqrestore(&engine->queue_lock, flags);
-
-		if (engine->unprepare_crypt_hardware &&
-		    engine->unprepare_crypt_hardware(engine))
-			dev_err(engine->dev, "failed to unprepare crypt hardware\n");
-
-		spin_lock_irqsave(&engine->queue_lock, flags);
-		engine->idling = false;
 		goto out;
 	}
 
@@ -129,22 +113,11 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 	if (!engine->retry_support)
 		engine->cur_req = async_req;
 
-	if (engine->busy)
-		was_busy = true;
-	else
+	if (!engine->busy)
 		engine->busy = true;
 
 	spin_unlock_irqrestore(&engine->queue_lock, flags);
 
-	/* Until here we get the request need to be encrypted successfully */
-	if (!was_busy && engine->prepare_crypt_hardware) {
-		ret = engine->prepare_crypt_hardware(engine);
-		if (ret) {
-			dev_err(engine->dev, "failed to prepare crypt hardware\n");
-			goto req_err_1;
-		}
-	}
-
 	alg = container_of(async_req->tfm->__crt_alg,
 			   struct crypto_engine_alg, base);
 	op = &alg->op;
@@ -474,7 +447,6 @@ struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *dev,
 	engine->rt = rt;
 	engine->running = false;
 	engine->busy = false;
-	engine->idling = false;
 	engine->retry_support = retry_support;
 	engine->priv_data = dev;
 
diff --git a/include/crypto/internal/engine.h b/include/crypto/internal/engine.h
index 8da1a13619c9..f19ef376833f 100644
--- a/include/crypto/internal/engine.h
+++ b/include/crypto/internal/engine.h
@@ -21,7 +21,6 @@ struct device;
 /*
  * struct crypto_engine - crypto hardware engine
  * @name: the engine name
- * @idling: the engine is entering idle state
  * @busy: request pump is busy
  * @running: the engine is on working
  * @retry_support: indication that the hardware allows re-execution
@@ -31,12 +30,6 @@ struct device;
  * @list: link with the global crypto engine list
  * @queue_lock: spinlock to synchronise access to request queue
  * @queue: the crypto queue of the engine
- * @prepare_crypt_hardware: a request will soon arrive from the queue
- * so the subsystem requests the driver to prepare the hardware
- * by issuing this call
- * @unprepare_crypt_hardware: there are currently no more requests on the
- * queue so the subsystem notifies the driver that it may relax the
- * hardware by issuing this call
  * @kworker: kthread worker struct for request pump
  * @pump_requests: work struct for scheduling work to the request pump
  * @priv_data: the engine private data
@@ -44,7 +37,6 @@ struct device;
  */
 struct crypto_engine {
 	char			name[ENGINE_NAME_LEN];
-	bool			idling;
 	bool			busy;
 	bool			running;
 
@@ -56,9 +48,6 @@ struct crypto_engine {
 	struct crypto_queue	queue;
 	struct device		*dev;
 
-	int (*prepare_crypt_hardware)(struct crypto_engine *engine);
-	int (*unprepare_crypt_hardware)(struct crypto_engine *engine);
-
 	struct kthread_worker           *kworker;
 	struct kthread_work             pump_requests;
 
-- 
2.50.0

