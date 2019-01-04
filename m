Return-Path: <SRS0=8/la=PM=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727748AbfADEU6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jan 2019 23:20:58 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 16/16] crypto: algapi - remove crypto_alloc_instance()
Date: Thu,  3 Jan 2019 20:16:25 -0800
Message-Id: <20190104041625.3259-17-ebiggers@kernel.org>
In-Reply-To: <20190104041625.3259-1-ebiggers@kernel.org>
References: <20190104041625.3259-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Now that all "blkcipher" templates have been converted to "skcipher",
crypto_alloc_instance() is no longer used.  And it's not useful any
longer as it creates an old-style weakly typed instance rather than a
new-style strongly typed instance.  So remove it, and now that the name
is freed up rename crypto_alloc_instance2() to crypto_alloc_instance().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/algapi.c                | 33 ++-------------------------------
 include/crypto/algapi.h        |  6 ++----
 include/crypto/internal/hash.h |  6 +++---
 3 files changed, 7 insertions(+), 38 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 8b65ada33e5d3..f3d766312bd96 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -845,8 +845,8 @@ int crypto_inst_setname(struct crypto_instance *inst, const char *name,
 }
 EXPORT_SYMBOL_GPL(crypto_inst_setname);
 
-void *crypto_alloc_instance2(const char *name, struct crypto_alg *alg,
-			     unsigned int head)
+void *crypto_alloc_instance(const char *name, struct crypto_alg *alg,
+			    unsigned int head)
 {
 	struct crypto_instance *inst;
 	char *p;
@@ -869,35 +869,6 @@ void *crypto_alloc_instance2(const char *name, struct crypto_alg *alg,
 	kfree(p);
 	return ERR_PTR(err);
 }
-EXPORT_SYMBOL_GPL(crypto_alloc_instance2);
-
-struct crypto_instance *crypto_alloc_instance(const char *name,
-					      struct crypto_alg *alg)
-{
-	struct crypto_instance *inst;
-	struct crypto_spawn *spawn;
-	int err;
-
-	inst = crypto_alloc_instance2(name, alg, 0);
-	if (IS_ERR(inst))
-		goto out;
-
-	spawn = crypto_instance_ctx(inst);
-	err = crypto_init_spawn(spawn, alg, inst,
-				CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC);
-
-	if (err)
-		goto err_free_inst;
-
-	return inst;
-
-err_free_inst:
-	kfree(inst);
-	inst = ERR_PTR(err);
-
-out:
-	return inst;
-}
 EXPORT_SYMBOL_GPL(crypto_alloc_instance);
 
 void crypto_init_queue(struct crypto_queue *queue, unsigned int max_qlen)
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 4a5ad10e75f0e..093869f175d6b 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -185,10 +185,8 @@ static inline struct crypto_alg *crypto_attr_alg(struct rtattr *rta,
 int crypto_attr_u32(struct rtattr *rta, u32 *num);
 int crypto_inst_setname(struct crypto_instance *inst, const char *name,
 			struct crypto_alg *alg);
-void *crypto_alloc_instance2(const char *name, struct crypto_alg *alg,
-			     unsigned int head);
-struct crypto_instance *crypto_alloc_instance(const char *name,
-					      struct crypto_alg *alg);
+void *crypto_alloc_instance(const char *name, struct crypto_alg *alg,
+			    unsigned int head);
 
 void crypto_init_queue(struct crypto_queue *queue, unsigned int max_qlen);
 int crypto_enqueue_request(struct crypto_queue *queue,
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index a0b0ad9d585e6..e355fdb642a92 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -170,7 +170,7 @@ static inline unsigned int ahash_instance_headroom(void)
 static inline struct ahash_instance *ahash_alloc_instance(
 	const char *name, struct crypto_alg *alg)
 {
-	return crypto_alloc_instance2(name, alg, ahash_instance_headroom());
+	return crypto_alloc_instance(name, alg, ahash_instance_headroom());
 }
 
 static inline void ahash_request_complete(struct ahash_request *req, int err)
@@ -233,8 +233,8 @@ static inline void *shash_instance_ctx(struct shash_instance *inst)
 static inline struct shash_instance *shash_alloc_instance(
 	const char *name, struct crypto_alg *alg)
 {
-	return crypto_alloc_instance2(name, alg,
-				      sizeof(struct shash_alg) - sizeof(*alg));
+	return crypto_alloc_instance(name, alg,
+				     sizeof(struct shash_alg) - sizeof(*alg));
 }
 
 static inline struct crypto_shash *crypto_spawn_shash(
-- 
2.20.1
