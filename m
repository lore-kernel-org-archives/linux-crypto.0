From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 17/35] crypto: shash - Export async functions
Date: Wed, 15 Jul 2009 15:16:10 +0800
Message-ID: <E1MQyio-000506-R8@gondolin.me.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53634 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752640AbZGOHQM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:16:12 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyip-0004ru-7B
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:16:11 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: shash - Export async functions

This patch exports the async functions so that they can be reused
by cryptd when it switches over to using shash.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/shash.c                 |   42 +++++++++++++++++++++--------------------
 include/crypto/internal/hash.h |    3 ++
 2 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index d8e0f8f..3b1b06b 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -202,9 +202,8 @@ static int shash_async_init(struct ahash_request *req)
 	return crypto_shash_init(desc);
 }
 
-static int shash_async_update(struct ahash_request *req)
+int shash_ahash_update(struct ahash_request *req, struct shash_desc *desc)
 {
-	struct shash_desc *desc = ahash_request_ctx(req);
 	struct crypto_hash_walk walk;
 	int nbytes;
 
@@ -214,13 +213,19 @@ static int shash_async_update(struct ahash_request *req)
 
 	return nbytes;
 }
+EXPORT_SYMBOL_GPL(shash_ahash_update);
+
+static int shash_async_update(struct ahash_request *req)
+{
+	return shash_ahash_update(req, ahash_request_ctx(req));
+}
 
 static int shash_async_final(struct ahash_request *req)
 {
 	return crypto_shash_final(ahash_request_ctx(req), req->result);
 }
 
-static int shash_async_digest(struct ahash_request *req)
+int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc)
 {
 	struct scatterlist *sg = req->src;
 	unsigned int offset = sg->offset;
@@ -228,34 +233,31 @@ static int shash_async_digest(struct ahash_request *req)
 	int err;
 
 	if (nbytes < min(sg->length, ((unsigned int)(PAGE_SIZE)) - offset)) {
-		struct crypto_shash **ctx =
-			crypto_ahash_ctx(crypto_ahash_reqtfm(req));
-		struct shash_desc *desc = ahash_request_ctx(req);
 		void *data;
 
-		desc->tfm = *ctx;
-		desc->flags = req->base.flags;
-
 		data = crypto_kmap(sg_page(sg), 0);
 		err = crypto_shash_digest(desc, data + offset, nbytes,
 					  req->result);
 		crypto_kunmap(data, 0);
 		crypto_yield(desc->flags);
-		goto out;
-	}
+	} else
+		err = crypto_shash_init(desc) ?:
+		      shash_ahash_update(req, desc) ?:
+		      crypto_shash_final(desc, req->result);
 
-	err = shash_async_init(req);
-	if (err)
-		goto out;
+	return err;
+}
+EXPORT_SYMBOL_GPL(shash_ahash_digest);
 
-	err = shash_async_update(req);
-	if (err)
-		goto out;
+static int shash_async_digest(struct ahash_request *req)
+{
+	struct crypto_shash **ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
+	struct shash_desc *desc = ahash_request_ctx(req);
 
-	err = shash_async_final(req);
+	desc->tfm = *ctx;
+	desc->flags = req->base.flags;
 
-out:
-	return err;
+	return shash_ahash_digest(req, desc);
 }
 
 static void crypto_exit_shash_ops_async(struct crypto_tfm *tfm)
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 2d1b10f..6e28349 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -63,6 +63,9 @@ int crypto_init_shash_spawn(struct crypto_shash_spawn *spawn,
 
 struct shash_alg *shash_attr_alg(struct rtattr *rta, u32 type, u32 mask);
 
+int shash_ahash_update(struct ahash_request *req, struct shash_desc *desc);
+int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc);
+
 static inline void *crypto_ahash_ctx(struct crypto_ahash *tfm)
 {
 	return crypto_tfm_ctx(&tfm->base);
