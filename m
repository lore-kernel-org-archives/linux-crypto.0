From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 2/3] crypto: engine - find request type with cra_type
Date: Mon, 14 Aug 2017 15:17:24 +0200
Message-ID: <20170814131725.9402-3-clabbe.montjoie@gmail.com>
References: <20170814131725.9402-1-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170814131725.9402-1-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The current method for finding request type is based on crypto_tfm_alg_type.

But in case of skcipher, it is the same than ablkcipher.
Using cra_type for this work permits to make the distinction between the two.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 crypto/crypto_engine.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index 61e7c4e02fd2..74b840749074 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -38,7 +38,8 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 	struct ablkcipher_request *breq;
 	unsigned long flags;
 	bool was_busy = false;
-	int ret, rtype;
+	int ret;
+	const struct crypto_type *cratype;
 
 	spin_lock_irqsave(&engine->queue_lock, flags);
 
@@ -94,7 +95,7 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 
 	spin_unlock_irqrestore(&engine->queue_lock, flags);
 
-	rtype = crypto_tfm_alg_type(engine->cur_req->tfm);
+	cratype = engine->cur_req->tfm->__crt_alg->cra_type;
 	/* Until here we get the request need to be encrypted successfully */
 	if (!was_busy && engine->prepare_crypt_hardware) {
 		ret = engine->prepare_crypt_hardware(engine);
@@ -104,8 +105,7 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 		}
 	}
 
-	switch (rtype) {
-	case CRYPTO_ALG_TYPE_AHASH:
+	if (cratype == &crypto_ahash_type) {
 		hreq = ahash_request_cast(engine->cur_req);
 		if (engine->prepare_hash_request) {
 			ret = engine->prepare_hash_request(engine, hreq);
@@ -122,7 +122,7 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 			goto req_err;
 		}
 		return;
-	case CRYPTO_ALG_TYPE_ABLKCIPHER:
+	} else if (cratype == &crypto_ablkcipher_type) {
 		breq = ablkcipher_request_cast(engine->cur_req);
 		if (engine->prepare_cipher_request) {
 			ret = engine->prepare_cipher_request(engine, breq);
@@ -139,21 +139,18 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 			goto req_err;
 		}
 		return;
-	default:
+	} else {
 		dev_err(engine->dev, "failed to prepare request of unknown type\n");
 		return;
 	}
 
 req_err:
-	switch (rtype) {
-	case CRYPTO_ALG_TYPE_AHASH:
+	if (cratype == &crypto_ahash_type) {
 		hreq = ahash_request_cast(engine->cur_req);
 		crypto_finalize_hash_request(engine, hreq, ret);
-		break;
-	case CRYPTO_ALG_TYPE_ABLKCIPHER:
+	} else if (cratype == &crypto_ablkcipher_type) {
 		breq = ablkcipher_request_cast(engine->cur_req);
 		crypto_finalize_cipher_request(engine, breq, ret);
-		break;
 	}
 	return;
 
-- 
2.13.0
