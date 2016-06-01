From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 13/28] crypto: engine: avoid unnecessary context switches
Date: Wed, 1 Jun 2016 11:56:14 +0300
Message-ID: <1464771389-10640-14-git-send-email-t-kristo@ti.com>
References: <1464771389-10640-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>, <lokeshvutla@ti.com>,
	Tero Kristo <t-kristo@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<tony@atomide.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([198.47.19.12]:50767 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757537AbcFAI6Q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 1 Jun 2016 04:58:16 -0400
In-Reply-To: <1464771389-10640-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Crypto engine will now hi-jack the currently running thread for executing
crypto functionality. Only if we are not running a thread (in interrupt
context) the kthread will be scheduled.

This will improve performance of crypto operations using crypto engine.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 crypto/crypto_engine.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index a55c82d..aac5870 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -136,6 +136,14 @@ static void crypto_pump_work(struct kthread_work *work)
 	crypto_pump_requests(engine, true);
 }
 
+static void queue_pump_work(struct crypto_engine *engine)
+{
+	if (in_interrupt())
+		queue_kthread_work(&engine->kworker, &engine->pump_requests);
+	else
+		crypto_pump_requests(engine, true);
+}
+
 /**
  * crypto_transfer_request - transfer the new request into the engine queue
  * @engine: the hardware engine
@@ -156,10 +164,11 @@ int crypto_transfer_request(struct crypto_engine *engine,
 
 	ret = ablkcipher_enqueue_request(&engine->queue, req);
 
+	spin_unlock_irqrestore(&engine->queue_lock, flags);
+
 	if (!engine->busy && need_pump)
-		queue_kthread_work(&engine->kworker, &engine->pump_requests);
+		queue_pump_work(engine);
 
-	spin_unlock_irqrestore(&engine->queue_lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(crypto_transfer_request);
@@ -210,7 +219,7 @@ void crypto_finalize_request(struct crypto_engine *engine,
 
 	req->base.complete(&req->base, err);
 
-	queue_kthread_work(&engine->kworker, &engine->pump_requests);
+	queue_pump_work(engine);
 }
 EXPORT_SYMBOL_GPL(crypto_finalize_request);
 
@@ -234,7 +243,7 @@ int crypto_engine_start(struct crypto_engine *engine)
 	engine->running = true;
 	spin_unlock_irqrestore(&engine->queue_lock, flags);
 
-	queue_kthread_work(&engine->kworker, &engine->pump_requests);
+	queue_pump_work(engine);
 
 	return 0;
 }
-- 
1.9.1
