From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: engine: fix linux-next merge conflict
Date: Thu,  8 Sep 2016 15:57:02 +0200
Message-ID: <20160908135724.1311726-1-arnd@arndb.de>
Cc: Petr Mladek <pmladek@suse.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:59944 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754070AbcIHN6M (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Sep 2016 09:58:12 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

A merge conflict between the akpm-current tree and the crypto tree
caused a build failure in ARM allmodconfig today:

crypto/crypto_engine.c: In function 'crypto_transfer_hash_request':
crypto/crypto_engine.c:234:3: error: implicit declaration of function 'queue_kthread_work' [-Werror=implicit-function-declaration]

This adapts the crypto code to the API change.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 4cba7cf025f3 ("crypto: engine - permit to enqueue ashash_request")
Fixes: 8ca76638a2d0 ("kthread: kthread worker API cleanup")
---
 crypto/crypto_engine.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index 64fcd9ee3e2e..6989ba0046df 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -231,7 +231,7 @@ int crypto_transfer_hash_request(struct crypto_engine *engine,
 	ret = ahash_enqueue_request(&engine->queue, req);
 
 	if (!engine->busy && need_pump)
-		queue_kthread_work(&engine->kworker, &engine->pump_requests);
+		kthread_queue_work(&engine->kworker, &engine->pump_requests);
 
 	spin_unlock_irqrestore(&engine->queue_lock, flags);
 	return ret;
@@ -284,7 +284,7 @@ void crypto_finalize_cipher_request(struct crypto_engine *engine,
 
 	req->base.complete(&req->base, err);
 
-	queue_kthread_work(&engine->kworker, &engine->pump_requests);
+	kthread_queue_work(&engine->kworker, &engine->pump_requests);
 }
 EXPORT_SYMBOL_GPL(crypto_finalize_cipher_request);
 
-- 
2.9.0
