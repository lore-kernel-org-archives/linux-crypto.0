Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0571021FF24
	for <linux-crypto@vger.kernel.org>; Wed, 23 Apr 2025 09:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745400156; cv=none; b=JguNmOy7oTK/Jw7IcC0x7GomCTodiRz0w8JKNVM0C6PatYUHJldinJ0kN55w5Avs+v1XcHjXqsjJVcmpGVaeCfG/qaPEdotPygeeb0Ylnu2XqLkHOtBJsRpdCbgwrztJZJxGsCoF/vghsOi3m2Xn6ATDMC+AYm5o+hJAUUYGQtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745400156; c=relaxed/simple;
	bh=VyH7XCsLAa5nIUUrkAniMhtZob8nP568zEy7PxWn2Rc=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=NblOseix5ckRO2NxunzOOSGLmXjRRUF0L3A8TTNhsxl7X6I+iRX9oPT+mFHVOOI9kjJNW1c17wVluT9thc6tFn81IQpJcTjQ3yF0niEhwlwL0A7OUTETucjeV3zjQk8Wt0s3g0faKFHVR6tbJYGxIxhKHQWLRI9I9WCC+NHAX0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=gDZ5btTS; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="gDZ5btTS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=PcO6BogxvjBgpRYrFTiOmVahTqo0XxIWIgS6cCjzCIQ=; b=gDZ5btTSnv6lkfEsyWtl1ngmcC
	33Olm/RNEz3G1B2OmNobASh4L5lqyL4BP2EK2Iql6Dp6n28usRvp8JRc23b0HmONkdfGpwO72r82J
	FsVgKFjeskfvz8zvYVxYgfmrA12V0Kz3G8FzQzoUW9weMM2OzhKDnirB1RqbQnhzonsYYFSpB4oJE
	E9fwiztx/Lxf4zh27E31RA3FMRvn6g9IqpWfHZrKCC66WP2zfhZ1sBOx5KvzFxJyQ0yRj24wA6dEk
	SQ3YvyUIuhYcovt6fKcknOgFq+JRVjuJT8IkNnNaiQA7UUBYquddurCZU038Aup886Iu2CEaQenxl
	LlYC7byQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u7WJI-000LDn-2g;
	Wed, 23 Apr 2025 17:22:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Apr 2025 17:22:28 +0800
Date: Wed, 23 Apr 2025 17:22:28 +0800
Message-Id: <2ea17454f213a54134340b25f70a33cd3f26be37.1745399917.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1745399917.git.herbert@gondor.apana.org.au>
References: <cover.1745399917.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/2] crypto: api - Add crypto_request_clone and fb
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add a helper to clone crypto requests and eliminate code duplication.
Use kmemdup in the helper.

Also add an fb field to crypto_tfm.

This also happens to fix the existing implementations which were
buggy.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202504230118.1CxUaUoX-lkp@intel.com/
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202504230004.c7mrY0C6-lkp@intel.com/
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/acompress.c                  | 29 +++-----------------------
 crypto/ahash.c                      | 32 +++++------------------------
 crypto/api.c                        | 18 ++++++++++++++++
 include/crypto/acompress.h          |  9 +++++---
 include/crypto/hash.h               |  9 +++++---
 include/crypto/internal/acompress.h |  7 ++++++-
 include/crypto/internal/hash.h      |  7 ++++++-
 include/linux/crypto.h              | 11 +++++++---
 8 files changed, 58 insertions(+), 64 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 4c665c6fb5d6..9dea76ed4513 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -11,15 +11,13 @@
 #include <crypto/scatterwalk.h>
 #include <linux/cryptouser.h>
 #include <linux/cpumask.h>
-#include <linux/errno.h>
+#include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/page-flags.h>
 #include <linux/percpu.h>
 #include <linux/scatterlist.h>
 #include <linux/sched.h>
 #include <linux/seq_file.h>
-#include <linux/slab.h>
 #include <linux/smp.h>
 #include <linux/spinlock.h>
 #include <linux/string.h>
@@ -79,7 +77,7 @@ static void crypto_acomp_exit_tfm(struct crypto_tfm *tfm)
 		alg->exit(acomp);
 
 	if (acomp_is_async(acomp))
-		crypto_free_acomp(acomp->fb);
+		crypto_free_acomp(crypto_acomp_fb(acomp));
 }
 
 static int crypto_acomp_init_tfm(struct crypto_tfm *tfm)
@@ -89,8 +87,6 @@ static int crypto_acomp_init_tfm(struct crypto_tfm *tfm)
 	struct crypto_acomp *fb = NULL;
 	int err;
 
-	acomp->fb = acomp;
-
 	if (tfm->__crt_alg->cra_type != &crypto_acomp_type)
 		return crypto_init_scomp_ops_async(tfm);
 
@@ -104,7 +100,7 @@ static int crypto_acomp_init_tfm(struct crypto_tfm *tfm)
 		if (crypto_acomp_reqsize(fb) > MAX_SYNC_COMP_REQSIZE)
 			goto out_free_fb;
 
-		acomp->fb = fb;
+		tfm->fb = crypto_acomp_tfm(fb);
 	}
 
 	acomp->compress = alg->compress;
@@ -570,24 +566,5 @@ int acomp_walk_virt(struct acomp_walk *__restrict walk,
 }
 EXPORT_SYMBOL_GPL(acomp_walk_virt);
 
-struct acomp_req *acomp_request_clone(struct acomp_req *req,
-				      size_t total, gfp_t gfp)
-{
-	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
-	struct acomp_req *nreq;
-
-	nreq = kmalloc(total, gfp);
-	if (!nreq) {
-		acomp_request_set_tfm(req, tfm->fb);
-		req->base.flags = CRYPTO_TFM_REQ_ON_STACK;
-		return req;
-	}
-
-	memcpy(nreq, req, total);
-	acomp_request_set_tfm(req, tfm);
-	return req;
-}
-EXPORT_SYMBOL_GPL(acomp_request_clone);
-
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Asynchronous compression type");
diff --git a/crypto/ahash.c b/crypto/ahash.c
index 7a74092323b9..9b813f7b9177 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -12,13 +12,11 @@
  * Copyright (c) 2008 Loc Ho <lho@amcc.com>
  */
 
-#include <crypto/scatterwalk.h>
 #include <linux/cryptouser.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 #include <linux/string.h>
@@ -301,7 +299,8 @@ int crypto_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 
 		err = alg->setkey(tfm, key, keylen);
 		if (!err && ahash_is_async(tfm))
-			err = crypto_ahash_setkey(tfm->fb, key, keylen);
+			err = crypto_ahash_setkey(crypto_ahash_fb(tfm),
+						  key, keylen);
 		if (unlikely(err)) {
 			ahash_set_needkey(tfm, alg);
 			return err;
@@ -732,7 +731,7 @@ static void crypto_ahash_exit_tfm(struct crypto_tfm *tfm)
 		tfm->__crt_alg->cra_exit(tfm);
 
 	if (ahash_is_async(hash))
-		crypto_free_ahash(hash->fb);
+		crypto_free_ahash(crypto_ahash_fb(hash));
 }
 
 static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
@@ -745,8 +744,6 @@ static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
 	crypto_ahash_set_statesize(hash, alg->halg.statesize);
 	crypto_ahash_set_reqsize(hash, crypto_tfm_alg_reqsize(tfm));
 
-	hash->fb = hash;
-
 	if (tfm->__crt_alg->cra_type == &crypto_shash_type)
 		return crypto_init_ahash_using_shash(tfm);
 
@@ -756,7 +753,7 @@ static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
 		if (IS_ERR(fb))
 			return PTR_ERR(fb);
 
-		hash->fb = fb;
+		tfm->fb = crypto_ahash_tfm(fb);
 	}
 
 	ahash_set_needkey(hash, alg);
@@ -1036,7 +1033,7 @@ EXPORT_SYMBOL_GPL(ahash_request_free);
 int crypto_hash_digest(struct crypto_ahash *tfm, const u8 *data,
 		       unsigned int len, u8 *out)
 {
-	HASH_REQUEST_ON_STACK(req, tfm->fb);
+	HASH_REQUEST_ON_STACK(req, crypto_ahash_fb(tfm));
 	int err;
 
 	ahash_request_set_callback(req, 0, NULL, NULL);
@@ -1049,24 +1046,5 @@ int crypto_hash_digest(struct crypto_ahash *tfm, const u8 *data,
 }
 EXPORT_SYMBOL_GPL(crypto_hash_digest);
 
-struct ahash_request *ahash_request_clone(struct ahash_request *req,
-					  size_t total, gfp_t gfp)
-{
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct ahash_request *nreq;
-
-	nreq = kmalloc(total, gfp);
-	if (!nreq) {
-		ahash_request_set_tfm(req, tfm->fb);
-		req->base.flags = CRYPTO_TFM_REQ_ON_STACK;
-		return req;
-	}
-
-	memcpy(nreq, req, total);
-	ahash_request_set_tfm(req, tfm);
-	return req;
-}
-EXPORT_SYMBOL_GPL(ahash_request_clone);
-
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Asynchronous cryptographic hash type");
diff --git a/crypto/api.c b/crypto/api.c
index e427cc5662b5..172e82f79c69 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -528,6 +528,7 @@ void *crypto_create_tfm_node(struct crypto_alg *alg,
 		goto out;
 
 	tfm = (struct crypto_tfm *)(mem + frontend->tfmsize);
+	tfm->fb = tfm;
 
 	err = frontend->init_tfm(tfm);
 	if (err)
@@ -712,5 +713,22 @@ void crypto_destroy_alg(struct crypto_alg *alg)
 }
 EXPORT_SYMBOL_GPL(crypto_destroy_alg);
 
+struct crypto_async_request *crypto_request_clone(
+	struct crypto_async_request *req, size_t total, gfp_t gfp)
+{
+	struct crypto_tfm *tfm = req->tfm;
+	struct crypto_async_request *nreq;
+
+	nreq = kmemdup(req, total, gfp);
+	if (!nreq) {
+		req->tfm = tfm->fb;
+		return req;
+	}
+
+	nreq->flags &= ~CRYPTO_TFM_REQ_ON_STACK;
+	return nreq;
+}
+EXPORT_SYMBOL_GPL(crypto_request_clone);
+
 MODULE_DESCRIPTION("Cryptographic core API");
 MODULE_LICENSE("GPL");
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 1b30290d6380..933c48a4855b 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -114,7 +114,6 @@ struct crypto_acomp {
 	int (*compress)(struct acomp_req *req);
 	int (*decompress)(struct acomp_req *req);
 	unsigned int reqsize;
-	struct crypto_acomp *fb;
 	struct crypto_tfm base;
 };
 
@@ -553,7 +552,11 @@ static inline struct acomp_req *acomp_request_on_stack_init(
 	return req;
 }
 
-struct acomp_req *acomp_request_clone(struct acomp_req *req,
-				      size_t total, gfp_t gfp);
+static inline struct acomp_req *acomp_request_clone(struct acomp_req *req,
+						    size_t total, gfp_t gfp)
+{
+	return container_of(crypto_request_clone(&req->base, total, gfp),
+			    struct acomp_req, base);
+}
 
 #endif
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 5f87d1040a7c..68813a83443b 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -246,7 +246,6 @@ struct crypto_ahash {
 	bool using_shash; /* Underlying algorithm is shash, not ahash */
 	unsigned int statesize;
 	unsigned int reqsize;
-	struct crypto_ahash *fb;
 	struct crypto_tfm base;
 };
 
@@ -1035,7 +1034,11 @@ static inline struct ahash_request *ahash_request_on_stack_init(
 	return req;
 }
 
-struct ahash_request *ahash_request_clone(struct ahash_request *req,
-					  size_t total, gfp_t gfp);
+static inline struct ahash_request *ahash_request_clone(
+	struct ahash_request *req, size_t total, gfp_t gfp)
+{
+	return container_of(crypto_request_clone(&req->base, total, gfp),
+			    struct ahash_request, base);
+}
 
 #endif	/* _CRYPTO_HASH_H */
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 7eda32619024..6550dad18e0f 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -220,13 +220,18 @@ static inline u32 acomp_request_flags(struct acomp_req *req)
 	return crypto_request_flags(&req->base) & ~CRYPTO_ACOMP_REQ_PRIVATE;
 }
 
+static inline struct crypto_acomp *crypto_acomp_fb(struct crypto_acomp *tfm)
+{
+	return __crypto_acomp_tfm(crypto_acomp_tfm(tfm)->fb);
+}
+
 static inline struct acomp_req *acomp_fbreq_on_stack_init(
 	char *buf, struct acomp_req *old)
 {
 	struct crypto_acomp *tfm = crypto_acomp_reqtfm(old);
 	struct acomp_req *req = (void *)buf;
 
-	acomp_request_set_tfm(req, tfm->fb);
+	acomp_request_set_tfm(req, crypto_acomp_fb(tfm));
 	req->base.flags = CRYPTO_TFM_REQ_ON_STACK;
 	acomp_request_set_callback(req, acomp_request_flags(old), NULL, NULL);
 	req->base.flags &= ~CRYPTO_ACOMP_REQ_PRIVATE;
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 1e80dd084a23..0bc0fefc9b3c 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -272,13 +272,18 @@ static inline bool crypto_ahash_req_chain(struct crypto_ahash *tfm)
 	return crypto_tfm_req_chain(&tfm->base);
 }
 
+static inline struct crypto_ahash *crypto_ahash_fb(struct crypto_ahash *tfm)
+{
+	return __crypto_ahash_cast(crypto_ahash_tfm(tfm)->fb);
+}
+
 static inline struct ahash_request *ahash_fbreq_on_stack_init(
 	char *buf, struct ahash_request *old)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(old);
 	struct ahash_request *req = (void *)buf;
 
-	ahash_request_set_tfm(req, tfm->fb);
+	ahash_request_set_tfm(req, crypto_ahash_fb(tfm));
 	req->base.flags = CRYPTO_TFM_REQ_ON_STACK;
 	ahash_request_set_callback(req, ahash_request_flags(old), NULL, NULL);
 	req->base.flags &= ~CRYPTO_AHASH_REQ_PRIVATE;
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index f691ce01745e..fe75320ff9a3 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -14,7 +14,7 @@
 
 #include <linux/completion.h>
 #include <linux/errno.h>
-#include <linux/refcount.h>
+#include <linux/refcount_types.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 
@@ -411,9 +411,11 @@ struct crypto_tfm {
 	u32 crt_flags;
 
 	int node;
-	
+
+	struct crypto_tfm *fb;
+
 	void (*exit)(struct crypto_tfm *tfm);
-	
+
 	struct crypto_alg *__crt_alg;
 
 	void *__crt_ctx[] CRYPTO_MINALIGN_ATTR;
@@ -509,5 +511,8 @@ static inline void crypto_request_set_tfm(struct crypto_async_request *req,
 	req->flags &= ~CRYPTO_TFM_REQ_ON_STACK;
 }
 
+struct crypto_async_request *crypto_request_clone(
+	struct crypto_async_request *req, size_t total, gfp_t gfp);
+
 #endif	/* _LINUX_CRYPTO_H */
 
-- 
2.39.5

