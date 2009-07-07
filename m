From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [RFC] [PATCH 2/3] crypto: ahash - add crypto_ahash_finup
Date: Tue, 7 Jul 2009 09:25:57 +0200
Message-ID: <20090707072557.GE20288@secunet.com>
References: <20090707072343.GC20288@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:36474 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755195AbZGGHXR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jul 2009 03:23:17 -0400
Content-Disposition: inline
In-Reply-To: <20090707072343.GC20288@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds the finup method for ahash. This can be used to
do the last hash update and the hash final together.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/ahash.c         |    1 +
 crypto/shash.c         |   15 +++++++++++++++
 include/crypto/hash.h  |    6 ++++++
 include/linux/crypto.h |    2 ++
 4 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index f347637..c2fbc6d 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -200,6 +200,7 @@ static int crypto_init_ahash_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 	crt->init = alg->init;
 	crt->update = alg->update;
 	crt->final  = alg->final;
+	crt->finup  = alg->finup; 
 	crt->digest = alg->digest;
 	crt->setkey = alg->setkey ? ahash_setkey : ahash_nosetkey;
 	crt->digestsize = alg->digestsize;
diff --git a/crypto/shash.c b/crypto/shash.c
index 2ccc8b0..3f494fe 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -224,6 +224,20 @@ static int shash_async_final(struct ahash_request *req)
 	return crypto_shash_final(ahash_request_ctx(req), req->result);
 }
 
+static int shash_async_finup(struct ahash_request *req)
+{
+	int err;
+
+	err = shash_async_update(req);
+	if (err)
+		goto out;
+
+	err = shash_async_final(req);
+
+out:
+	return err;
+}
+
 static int shash_async_digest(struct ahash_request *req)
 {
 	struct scatterlist *sg = req->src;
@@ -292,6 +306,7 @@ static int crypto_init_shash_ops_async(struct crypto_tfm *tfm)
 	crt->init = shash_async_init;
 	crt->update = shash_async_update;
 	crt->final  = shash_async_final;
+	crt->finup  = shash_async_finup;
 	crt->digest = shash_async_digest;
 	crt->setkey = shash_async_setkey;
 
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index bd473a0..7c36733 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -177,6 +177,12 @@ static inline int crypto_ahash_final(struct ahash_request *req)
 	return crt->final(req);
 }
 
+static inline int crypto_ahash_finup(struct ahash_request *req)
+{
+	struct ahash_tfm *crt = crypto_ahash_crt(crypto_ahash_reqtfm(req));
+	return crt->finup(req);
+}
+
 static inline void ahash_request_complete(struct ahash_request *req, int err)
 {
 	req->base.complete(&req->base, err);
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index ec29fa2..ab3e4b8 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -225,6 +225,7 @@ struct ahash_alg {
 	int (*reinit)(struct ahash_request *req);
 	int (*update)(struct ahash_request *req);
 	int (*final)(struct ahash_request *req);
+	int (*finup)(struct ahash_request *req);
 	int (*digest)(struct ahash_request *req);
 	int (*setkey)(struct crypto_ahash *tfm, const u8 *key,
 			unsigned int keylen);
@@ -437,6 +438,7 @@ struct ahash_tfm {
 	int (*init)(struct ahash_request *req);
 	int (*update)(struct ahash_request *req);
 	int (*final)(struct ahash_request *req);
+	int (*finup)(struct ahash_request *req);
 	int (*digest)(struct ahash_request *req);
 	int (*setkey)(struct crypto_ahash *tfm, const u8 *key,
 			unsigned int keylen);
-- 
1.5.4.2

