From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [RFC] [PATCH 1/3] crypto: ahash - Add some helper functions
Date: Tue, 7 Jul 2009 09:24:51 +0200
Message-ID: <20090707072451.GD20288@secunet.com>
References: <20090707072343.GC20288@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:36451 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393AbZGGHWL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jul 2009 03:22:11 -0400
Content-Disposition: inline
In-Reply-To: <20090707072343.GC20288@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/crypto/hash.h          |   25 +++++++++++++++++++++++++
 include/crypto/internal/hash.h |    5 +++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index d56bb71..bd473a0 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -14,6 +14,7 @@
 #define _CRYPTO_HASH_H
 
 #include <linux/crypto.h>
+#include <crypto/algapi.h>
 
 struct shash_desc {
 	struct crypto_shash *tfm;
@@ -54,6 +55,15 @@ static inline struct crypto_ahash *__crypto_ahash_cast(struct crypto_tfm *tfm)
 	return (struct crypto_ahash *)tfm;
 }
 
+static inline struct crypto_ahash *crypto_spawn_ahash(
+				struct crypto_spawn *spawn)
+{
+	u32 type = CRYPTO_ALG_TYPE_AHASH;
+	u32 mask = CRYPTO_ALG_TYPE_AHASH_MASK;
+
+	return __crypto_ahash_cast(crypto_spawn_tfm(spawn, type, mask));
+}
+
 static inline struct crypto_ahash *crypto_alloc_ahash(const char *alg_name,
 						      u32 type, u32 mask)
 {
@@ -86,6 +96,11 @@ static inline struct ahash_tfm *crypto_ahash_crt(struct crypto_ahash *tfm)
 	return &crypto_ahash_tfm(tfm)->crt_ahash;
 }
 
+static inline unsigned int crypto_ahash_blocksize(struct crypto_ahash *tfm)
+{
+	return crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
+}
+
 static inline unsigned int crypto_ahash_digestsize(struct crypto_ahash *tfm)
 {
 	return crypto_ahash_crt(tfm)->digestsize;
@@ -162,6 +177,16 @@ static inline int crypto_ahash_final(struct ahash_request *req)
 	return crt->final(req);
 }
 
+static inline void ahash_request_complete(struct ahash_request *req, int err)
+{
+	req->base.complete(&req->base, err);
+}
+
+static inline u32 ahash_request_flags(struct ahash_request *req)
+{
+	return req->base.flags;
+}
+
 static inline void ahash_request_set_tfm(struct ahash_request *req,
 					 struct crypto_ahash *tfm)
 {
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 82b7056..bbcc076 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -51,6 +51,11 @@ static inline void *crypto_ahash_ctx(struct crypto_ahash *tfm)
 	return crypto_tfm_ctx(&tfm->base);
 }
 
+static inline void *crypto_ahash_ctx_aligned(struct crypto_ahash *tfm)
+{
+	return crypto_tfm_ctx_aligned(&tfm->base);
+}
+
 static inline struct ahash_alg *crypto_ahash_alg(
 	struct crypto_ahash *tfm)
 {
-- 
1.5.4.2

