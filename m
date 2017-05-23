From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 1/2] crypto: engine - replace pr_xxx by dev_xxx
Date: Tue, 23 May 2017 14:09:02 +0200
Message-ID: <20170523120903.31637-1-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36508 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936053AbdEWMLJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 May 2017 08:11:09 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

By adding a struct device *dev to struct engine, we could store the
device used at register time and so use all dev_xxx functions instead of
pr_xxx.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 crypto/crypto_engine.c  | 23 +++++++++++++----------
 include/crypto/engine.h |  1 +
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index 727bd5c3569e..61e7c4e02fd2 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -70,7 +70,7 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 
 		if (engine->unprepare_crypt_hardware &&
 		    engine->unprepare_crypt_hardware(engine))
-			pr_err("failed to unprepare crypt hardware\n");
+			dev_err(engine->dev, "failed to unprepare crypt hardware\n");
 
 		spin_lock_irqsave(&engine->queue_lock, flags);
 		engine->idling = false;
@@ -99,7 +99,7 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 	if (!was_busy && engine->prepare_crypt_hardware) {
 		ret = engine->prepare_crypt_hardware(engine);
 		if (ret) {
-			pr_err("failed to prepare crypt hardware\n");
+			dev_err(engine->dev, "failed to prepare crypt hardware\n");
 			goto req_err;
 		}
 	}
@@ -110,14 +110,15 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 		if (engine->prepare_hash_request) {
 			ret = engine->prepare_hash_request(engine, hreq);
 			if (ret) {
-				pr_err("failed to prepare request: %d\n", ret);
+				dev_err(engine->dev, "failed to prepare request: %d\n",
+					ret);
 				goto req_err;
 			}
 			engine->cur_req_prepared = true;
 		}
 		ret = engine->hash_one_request(engine, hreq);
 		if (ret) {
-			pr_err("failed to hash one request from queue\n");
+			dev_err(engine->dev, "failed to hash one request from queue\n");
 			goto req_err;
 		}
 		return;
@@ -126,19 +127,20 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 		if (engine->prepare_cipher_request) {
 			ret = engine->prepare_cipher_request(engine, breq);
 			if (ret) {
-				pr_err("failed to prepare request: %d\n", ret);
+				dev_err(engine->dev, "failed to prepare request: %d\n",
+					ret);
 				goto req_err;
 			}
 			engine->cur_req_prepared = true;
 		}
 		ret = engine->cipher_one_request(engine, breq);
 		if (ret) {
-			pr_err("failed to cipher one request from queue\n");
+			dev_err(engine->dev, "failed to cipher one request from queue\n");
 			goto req_err;
 		}
 		return;
 	default:
-		pr_err("failed to prepare request of unknown type\n");
+		dev_err(engine->dev, "failed to prepare request of unknown type\n");
 		return;
 	}
 
@@ -275,7 +277,7 @@ void crypto_finalize_cipher_request(struct crypto_engine *engine,
 		    engine->unprepare_cipher_request) {
 			ret = engine->unprepare_cipher_request(engine, req);
 			if (ret)
-				pr_err("failed to unprepare request\n");
+				dev_err(engine->dev, "failed to unprepare request\n");
 		}
 		spin_lock_irqsave(&engine->queue_lock, flags);
 		engine->cur_req = NULL;
@@ -312,7 +314,7 @@ void crypto_finalize_hash_request(struct crypto_engine *engine,
 		    engine->unprepare_hash_request) {
 			ret = engine->unprepare_hash_request(engine, req);
 			if (ret)
-				pr_err("failed to unprepare request\n");
+				dev_err(engine->dev, "failed to unprepare request\n");
 		}
 		spin_lock_irqsave(&engine->queue_lock, flags);
 		engine->cur_req = NULL;
@@ -384,7 +386,7 @@ int crypto_engine_stop(struct crypto_engine *engine)
 	spin_unlock_irqrestore(&engine->queue_lock, flags);
 
 	if (ret)
-		pr_warn("could not stop engine\n");
+		dev_warn(engine->dev, "could not stop engine\n");
 
 	return ret;
 }
@@ -411,6 +413,7 @@ struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
 	if (!engine)
 		return NULL;
 
+	engine->dev = dev;
 	engine->rt = rt;
 	engine->running = false;
 	engine->busy = false;
diff --git a/include/crypto/engine.h b/include/crypto/engine.h
index 1bf600fc99f7..9e968a1033d0 100644
--- a/include/crypto/engine.h
+++ b/include/crypto/engine.h
@@ -58,6 +58,7 @@ struct crypto_engine {
 	struct list_head	list;
 	spinlock_t		queue_lock;
 	struct crypto_queue	queue;
+	struct device *dev;
 
 	bool			rt;
 
-- 
2.13.0
